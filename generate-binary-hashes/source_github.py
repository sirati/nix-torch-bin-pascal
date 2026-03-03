"""
GitHub Releases backend for binary-wheel hash generation.

Fetches wheel assets from a GitHub release tag via the GitHub REST API.

Authentication
--------------
No API token is required for public repositories.  Unauthenticated requests
are permitted at up to 60 per hour, which is far more than the 1–2 calls
needed per run.  A token is accepted purely as an optional convenience to
raise that limit to 5 000 req/h.

Token resolution order (first non-empty value wins):

1. The ``token`` constructor argument.
2. The file at ``token_file`` (contents are stripped of surrounding whitespace).
3. The ``GITHUB_TOKEN`` environment variable.
4. No token — unauthenticated request.

SHA-256 hashes are obtained in one of two ways (in preference order):

1. The ``digest`` field on each asset object — GitHub started including
   ``"digest": "sha256:<hex>"`` in release-asset responses in late 2023.
   When present this avoids any downloading at all.

2. Stream-download the wheel file and compute its SHA-256 locally using
   ``hashlib``.  No temporary files are written to disk.

Usage
-----
    from source_github import GithubReleasesSource

    source = GithubReleasesSource(
        repo="Dao-AILab/flash-attention",
        tag="v2.8.3",
    )
    for entry in source.fetch_wheels():
        print(entry.name, entry.hexhash)
"""
from __future__ import annotations

import hashlib
import json
import os
import sys
from typing import Iterator
from urllib.error import HTTPError
from urllib.request import Request, urlopen

from common import WheelEntry


# GitHub REST API base URL — override via env var for testing / GHE.
_GITHUB_API = os.environ.get("GITHUB_API_URL", "https://api.github.com")

# The project root is the parent of the generate-binary-hashes/ directory
# that contains this file.  The token file lives there, if it exists at all.
_PROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
_DEFAULT_TOKEN_FILE = os.path.join(_PROJECT_ROOT, "SECRET_GITHUB_READONLY")


def _read_token_file(path: str) -> str | None:
    """
    Read a token from *path*, returning the stripped contents or ``None``.

    A missing or unreadable file is silently ignored — token files are
    always optional.
    """
    try:
        with open(path) as fh:
            return fh.read().strip() or None
    except OSError:
        return None


class GithubReleasesSource:
    """
    Yield :class:`~common.WheelEntry` objects for every ``.whl`` asset
    in a GitHub release.

    Parameters
    ----------
    repo:
        ``owner/name`` repository slug, e.g. ``"Dao-AILab/flash-attention"``.
    tag:
        Release tag to fetch, e.g. ``"v2.8.3"``.
    token:
        GitHub personal access token string.  Optional — public repos work
        without one.  See module docstring for the full resolution order.
        When omitted the class automatically tries to read
        ``SECRET_GITHUB_READONLY`` from the project root (the directory
        that contains ``generate-binary-hashes/``), then falls back to the
        ``GITHUB_TOKEN`` environment variable, then proceeds unauthenticated.
    wheel_filter:
        Optional callable ``(filename: str) -> bool``.  When supplied only
        assets for which the filter returns ``True`` are yielded.  The
        default is to include every asset whose name ends with ``".whl"``.
    verbose:
        Print one progress line per asset to *stderr* (default: True).
    """

    def __init__(
        self,
        repo: str,
        tag: str,
        token: str | None = None,
        wheel_filter: "((str) -> bool) | None" = None,
        verbose: bool = True,
    ) -> None:
        self.repo = repo
        self.tag = tag
        self.token = (
            token
            or _read_token_file(_DEFAULT_TOKEN_FILE)
            or os.environ.get("GITHUB_TOKEN")
        ) or None  # collapse empty string → None
        self.wheel_filter = wheel_filter or (lambda name: name.endswith(".whl"))
        self.verbose = verbose

    # ------------------------------------------------------------------
    # Public interface
    # ------------------------------------------------------------------

    def fetch_wheels(self) -> Iterator[WheelEntry]:
        """
        Yield one :class:`~common.WheelEntry` for every matching wheel asset.

        The ``url`` stored on each entry has ``+`` percent-encoded as ``%2B``
        so that it is safe for use directly in a Nix ``fetchurl`` call.
        """
        assets = self._get_release_assets()
        whl_assets = [a for a in assets if self.wheel_filter(a["name"])]

        total = len(whl_assets)
        if self.verbose:
            print(
                f"  {total} matching wheel asset(s) out of {len(assets)} total "
                f"for {self.repo} @ {self.tag}",
                file=sys.stderr,
            )

        for i, asset in enumerate(whl_assets, 1):
            name = asset["name"]
            raw_url = asset["browser_download_url"]

            hexhash = self._sha256_for_asset(asset, i, total)

            # Encode '+' → '%2B' for Nix fetchurl.
            nix_url = raw_url.replace("+", "%2B")

            yield WheelEntry(name=name, url=nix_url, hexhash=hexhash)

    # ------------------------------------------------------------------
    # GitHub API helpers
    # ------------------------------------------------------------------

    def _api_headers(self) -> dict[str, str]:
        headers: dict[str, str] = {
            "Accept": "application/vnd.github+json",
            "X-GitHub-Api-Version": "2022-11-28",
            "User-Agent": "generate-binary-hashes/1.0",
        }
        if self.token:
            headers["Authorization"] = f"Bearer {self.token}"
        return headers

    def _api_get(self, url: str) -> object:
        req = Request(url, headers=self._api_headers())
        try:
            with urlopen(req) as resp:
                return json.loads(resp.read())
        except HTTPError as exc:
            body = exc.read().decode(errors="replace")
            print(
                f"GitHub API error {exc.code} fetching {url}:\n{body}",
                file=sys.stderr,
            )
            sys.exit(1)

    def _get_release_assets(self) -> list[dict]:
        """Return all asset dicts for the configured release tag."""
        url = f"{_GITHUB_API}/repos/{self.repo}/releases/tags/{self.tag}"
        release = self._api_get(url)

        assets: list[dict] = release.get("assets", [])

        # The releases endpoint inlines assets (no separate pagination for
        # the typical < 100-asset case).  Warn if truncation is possible.
        if len(assets) >= 100:
            print(
                "Warning: ≥100 assets returned — some wheels may be on a "
                "subsequent page.  Use the /releases/{id}/assets endpoint "
                "with pagination if entries appear to be missing.",
                file=sys.stderr,
            )

        return assets

    # ------------------------------------------------------------------
    # Hash computation
    # ------------------------------------------------------------------

    def _sha256_for_asset(self, asset: dict, idx: int, total: int) -> str:
        """
        Return the hex SHA-256 for *asset*, preferring the API-provided
        ``digest`` field over a streaming download.
        """
        digest_field: str = asset.get("digest", "")
        if digest_field.startswith("sha256:"):
            hexhash = digest_field[len("sha256:"):]
            if self.verbose:
                print(
                    f"  [{idx:>3}/{total}] digest   {asset['name']}",
                    file=sys.stderr,
                )
            return hexhash

        # Fallback: stream-download the file.
        if self.verbose:
            print(
                f"  [{idx:>3}/{total}] download {asset['name']}",
                file=sys.stderr,
            )
        return self._stream_sha256(asset["browser_download_url"])

    @staticmethod
    def _stream_sha256(url: str) -> str:  # noqa: E301
        """Download *url* in 1 MiB chunks and return the hex SHA-256."""
        req = Request(url, headers={"User-Agent": "generate-binary-hashes/1.0"})
        h = hashlib.sha256()
        with urlopen(req) as resp:
            while True:
                chunk = resp.read(1 << 20)
                if not chunk:
                    break
                h.update(chunk)
        return h.hexdigest()
