from __future__ import annotations

from source_github.api import _GITHUB_API, api_get, resolve_token


def list_release_info(
    repo: str,
    token: str | None = None,
    include_prereleases: bool = False,
) -> list[dict]:
    """
    Return release metadata for *repo*, newest-first.

    Each element is a dict with at minimum:

    * ``tag_name``     — the release tag string, e.g. ``"v1.6.0"``
    * ``published_at`` — ISO-8601 timestamp string, e.g. ``"2024-03-15T12:00:00Z"``
      (empty string when the field is absent from the API response)

    Parameters
    ----------
    repo:
        ``owner/name`` repository slug, e.g. ``"Dao-AILab/causal-conv1d"``.
    token:
        Optional GitHub personal-access token.  Resolved via the standard
        order: argument → ``SECRET_GITHUB_READONLY`` file → ``GITHUB_TOKEN``
        env var → unauthenticated.
    include_prereleases:
        When ``False`` (default) pre-releases are excluded.

    Returns
    -------
    list[dict]
        Newest-first list of release info dicts.
    """
    resolved_token = resolve_token(token)

    infos: list[dict] = []
    page = 1
    while True:
        url = f"{_GITHUB_API}/repos/{repo}/releases?per_page=100&page={page}"
        releases = api_get(url, resolved_token)
        if not isinstance(releases, list) or not releases:
            break
        for r in releases:
            if include_prereleases or not r.get("prerelease", False):
                tag = r.get("tag_name", "")
                if tag:
                    infos.append({
                        "tag_name":     tag,
                        "published_at": r.get("published_at", "") or "",
                    })
        if len(releases) < 100:
            break
        page += 1

    return infos


def list_release_tags(
    repo: str,
    token: str | None = None,
    include_prereleases: bool = False,
) -> list[str]:
    """
    Return all release tag names for *repo*, newest-first.

    Parameters
    ----------
    repo:
        ``owner/name`` repository slug, e.g. ``"Dao-AILab/causal-conv1d"``.
    token:
        Optional GitHub personal-access token.  Resolved via the standard
        order: argument → ``SECRET_GITHUB_READONLY`` file → ``GITHUB_TOKEN``
        env var → unauthenticated.
    include_prereleases:
        When ``False`` (default) pre-releases are excluded.

    Returns
    -------
    list[str]
        Tag name strings, e.g. ``["v1.6.0", "v1.5.0", …]``, newest first.
    """
    return [
        info["tag_name"]
        for info in list_release_info(repo, token, include_prereleases)
    ]
