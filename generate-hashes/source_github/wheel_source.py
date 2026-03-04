from __future__ import annotations

import sys
from typing import Iterator

from common import WheelEntry
from source_github.api import _GITHUB_API, api_get, resolve_token


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
        without one.  Resolution order: argument → ``SECRET_GITHUB_READONLY``
        file in project root → ``GITHUB_TOKEN`` env var → unauthenticated.
    wheel_filter:
        Optional callable ``(filename: str) -> bool``.  When supplied only
        assets for which the filter returns ``True`` are yielded.  The
        default is to include every asset whose name ends with ``".whl"``.
    verbose:
        Print one progress line per asset to *stderr* (default: True).

    Attributes
    ----------
    skipped_no_digest:
        List of asset filenames that were skipped because the GitHub API did
        not supply a ``digest`` field for them.  Populated after
        :meth:`fetch_wheels` completes (reset at the start of each call).
        The caller should check this list and write a warning file if it is
        non-empty.
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
        self.token = resolve_token(token)
        self.wheel_filter = wheel_filter or (lambda name: name.endswith(".whl"))
        self.verbose = verbose
        # Populated by fetch_wheels(); names of assets skipped due to absent digest.
        self.skipped_no_digest: list[str] = []

    # ------------------------------------------------------------------
    # Public interface
    # ------------------------------------------------------------------

    def fetch_wheels(self) -> Iterator[WheelEntry]:
        """
        Yield one :class:`~common.WheelEntry` for every matching wheel asset
        that has a ``digest`` field in the GitHub API response.

        Assets without a ``digest`` are **never downloaded**.  Their filenames
        are appended to :attr:`skipped_no_digest` and they are silently skipped
        in the yielded stream.  Check ``skipped_no_digest`` after the loop.

        The ``url`` stored on each entry has ``+`` percent-encoded as ``%2B``
        so that it is safe for use directly in a Nix ``fetchurl`` call.
        """
        self.skipped_no_digest = []   # reset on each call

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

            hexhash = self._digest_for_asset(asset, i, total)
            if hexhash is None:
                # No digest available — record and skip without downloading.
                self.skipped_no_digest.append(name)
                continue

            # Encode '+' → '%2B' for Nix fetchurl.
            nix_url = raw_url.replace("+", "%2B")

            yield WheelEntry(name=name, url=nix_url, hexhash=hexhash)

    # ------------------------------------------------------------------
    # GitHub API helpers
    # ------------------------------------------------------------------

    def _get_release_assets(self) -> list[dict]:
        """
        Return all asset dicts for the configured release tag.

        The ``/releases/tags/{tag}`` endpoint inlines up to 100 assets.
        When that limit is hit we paginate via ``/releases/{id}/assets``
        to retrieve the full list.
        """
        url = f"{_GITHUB_API}/repos/{self.repo}/releases/tags/{self.tag}"
        release = api_get(url, self.token)

        inline_assets: list[dict] = release.get("assets", [])

        # Fast path: fewer than 100 assets means no truncation.
        if len(inline_assets) < 100:
            return inline_assets

        # Full pagination via the dedicated assets endpoint.
        release_id: int = release["id"]
        assets: list[dict] = []
        page = 1
        while True:
            page_url = (
                f"{_GITHUB_API}/repos/{self.repo}/releases/{release_id}"
                f"/assets?per_page=100&page={page}"
            )
            page_assets: list[dict] = api_get(page_url, self.token)
            if not page_assets:
                break
            assets.extend(page_assets)
            if len(page_assets) < 100:
                break
            page += 1

        return assets

    # ------------------------------------------------------------------
    # Hash extraction
    # ------------------------------------------------------------------

    def _digest_for_asset(
        self, asset: dict, idx: int, total: int
    ) -> str | None:
        """
        Return the hex SHA-256 for *asset* from the API ``digest`` field.

        Returns ``None`` when the field is absent or null — the caller must
        skip the asset.  Assets are **never downloaded**.
        """
        # asset.get("digest", "") may return None when the key is present but
        # null in the JSON response; use `or ""` to normalise.
        digest_field: str = asset.get("digest", "") or ""
        if digest_field.startswith("sha256:"):
            hexhash = digest_field[len("sha256:"):]
            if self.verbose:
                print(
                    f"  [{idx:>3}/{total}] digest   {asset['name']}",
                    file=sys.stderr,
                )
            return hexhash

        # No digest available.
        if self.verbose:
            print(
                f"  [{idx:>3}/{total}] NO DIGEST (skipping) {asset['name']}",
                file=sys.stderr,
            )
        return None
