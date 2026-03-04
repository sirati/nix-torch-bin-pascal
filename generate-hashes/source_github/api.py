from __future__ import annotations

import datetime
import json
import os
import sys
from urllib.error import HTTPError
from urllib.request import Request, urlopen


# GitHub REST API base URL — override via env var for testing / GHE.
_GITHUB_API = os.environ.get("GITHUB_API_URL", "https://api.github.com")

# The project root is the parent of the generate-hashes/ directory
# that contains this file.  The token file lives there, if it exists at all.
_PROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
_DEFAULT_TOKEN_FILE = os.path.join(_PROJECT_ROOT, "SECRET_GITHUB_READONLY")


def read_token_file(path: str) -> str | None:
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


def resolve_token(token: str | None) -> str | None:
    """
    Resolve a GitHub API token from the first available source:

    1. The *token* argument (when non-empty).
    2. The ``SECRET_GITHUB_READONLY`` file in the project root.
    3. The ``GITHUB_TOKEN`` environment variable.
    4. ``None`` — unauthenticated requests (60 req/h for public repos).
    """
    return (
        token
        or read_token_file(_DEFAULT_TOKEN_FILE)
        or os.environ.get("GITHUB_TOKEN")
    ) or None


def _api_headers(token: str | None) -> dict[str, str]:
    headers: dict[str, str] = {
        "Accept": "application/vnd.github+json",
        "X-GitHub-Api-Version": "2022-11-28",
        "User-Agent": "generate-hashes/1.0",
    }
    if token:
        headers["Authorization"] = f"Bearer {token}"
    return headers


def api_get(url: str, token: str | None = None) -> object:
    """
    Perform an authenticated GET request against the GitHub REST API.

    On HTTP 403/429 (rate-limit or auth error) prints an actionable message
    including any ``Retry-After`` / ``X-RateLimit-Reset`` hint and exits
    immediately — never retries, never spams the API.

    On any other HTTP error prints the status and body and exits.
    """
    req = Request(url, headers=_api_headers(token))
    try:
        with urlopen(req) as resp:
            return json.loads(resp.read())
    except HTTPError as exc:
        body = exc.read().decode(errors="replace")

        if exc.code in (403, 429):
            retry_after = exc.headers.get("Retry-After", "")
            x_ratelimit_reset = exc.headers.get("X-RateLimit-Reset", "")
            hint = ""
            if retry_after:
                hint = f"  Retry-After:        {retry_after}\n"
            elif x_ratelimit_reset:
                try:
                    reset_dt = datetime.datetime.fromtimestamp(int(x_ratelimit_reset))
                    hint = f"  Rate limit resets:  {reset_dt}\n"
                except (ValueError, OSError):
                    hint = f"  X-RateLimit-Reset:  {x_ratelimit_reset}\n"
            print(
                f"\nGitHub API rate limit or auth error (HTTP {exc.code}) fetching:\n"
                f"  {url}\n"
                f"{hint}"
                f"Tip: set GITHUB_TOKEN or pass --token to raise the limit "
                f"from 60 to 5 000 req/h.\n"
                f"Response body: {body[:400]}",
                file=sys.stderr,
            )
            sys.exit(1)

        print(
            f"GitHub API error {exc.code} fetching {url}:\n{body}",
            file=sys.stderr,
        )
        sys.exit(1)
