"""
Shared helper for computing and caching Nix fetchFromGitHub source hashes.

Each package that supports source builds keeps its source hashes in a
``source-hashes/`` subdirectory with one file per version:

    pkgs/causal-conv1d/source-hashes/
        v1.6.0.nix

Each file is a plain Nix attrset with ``rev`` and ``hash`` (SRI format).
``owner`` and ``repo`` are optional — omit them when they match the package's
well-known defaults (the consuming Nix code supplies the defaults):

    {
      rev  = "v1.6.0";
      hash = "sha256-hFaF/oMdScDpdq+zq8WppWe9GONWppEEx2pIcnaALiI=";
    }

For packages that use ``fetchFromGitHub { fetchSubmodules = true; }`` (e.g.
flash-attn, which requires the cutlass submodule), the ``hash`` field must be
the NAR hash of the git clone *with submodules*, not the tarball hash.  The
two values are different; using the wrong one causes a hash mismatch at build
time.  The generator will use :func:`fetch_github_source_hash_with_submodules`
instead of :func:`fetch_github_source_hash` when ``with_submodules=True`` is
passed to ``run_source_hashes``.

Override example (when the source lives in a fork or uses a different tag
scheme):

    {
      owner = "some-fork";
      repo  = "causal-conv1d";
      rev   = "release-1.6.0";
      hash  = "sha256-…";
    }

How the hash is computed
------------------------
``hash`` (tarball, no submodules)
    ``fetchFromGitHub`` downloads a ``.tar.gz`` archive from GitHub and unpacks
    it; the ``hash`` attribute is the NAR hash of the resulting directory tree.
    Computed via::

        nix store prefetch-file --hash-type sha256 --unpack <url>

    which downloads, extracts and NAR-hashes the archive in one step, printing
    the SRI string (``sha256-<base64>``).  Requires Nix ≥ 2.4.

``hash`` (git clone with submodules)
    When ``fetchFromGitHub { fetchSubmodules = true; }`` is used, nixpkgs
    switches from the tarball path to a ``fetchgit``-style clone that also
    initialises submodules.  The resulting NAR hash differs from the tarball
    hash.  Computed via::

        nix-prefetch-github --fetch-submodules --rev <tag> <owner> <repo>

    which clones the repository, fetches all submodules, and prints a JSON
    object whose ``hash`` field is the SRI NAR hash.  Requires
    ``nix-prefetch-github`` on PATH (add it to your nix-shell packages).
"""
from __future__ import annotations

import json
import os
import subprocess
import sys
from dataclasses import dataclass, field


# ---------------------------------------------------------------------------
# Data type
# ---------------------------------------------------------------------------

@dataclass
class SourceEntry:
    """
    A GitHub source archive with its Nix NAR hash.

    Attributes
    ----------
    version:
        Python-package version string, e.g. ``"1.6.0"``.  Used as the key
        in the output file name (``v{version}.nix``).
    tag:
        Git tag that corresponds to this version, e.g. ``"v1.6.0"``.
    hash:
        Nix SRI hash string, e.g. ``"sha256-hFaF/…="``.

        For packages that do **not** use ``fetchSubmodules`` this is the NAR
        hash of the GitHub ``.tar.gz`` tarball.

        For packages that **do** use ``fetchSubmodules = true`` (e.g.
        flash-attn) this must be the NAR hash of the git clone with
        submodules — the two values differ.  Pass ``with_submodules=True`` to
        ``run_source_hashes`` / ``run_all_hashes`` to compute the correct
        value automatically.
    owner:
        GitHub repository owner override.  Empty string means "use the
        package default".
    repo:
        GitHub repository name override.  Empty string means "use the
        package default".
    """
    version: str
    tag: str
    hash: str
    owner: str = field(default="")
    repo:  str = field(default="")


# ---------------------------------------------------------------------------
# Hash computation — tarball (no submodules)
# ---------------------------------------------------------------------------

def fetch_github_source_hash(owner: str, repo: str, tag: str) -> str:
    """
    Compute and return the Nix SRI NAR hash for the GitHub archive at *tag*.

    The returned string is in SRI format, e.g.
    ``"sha256-hFaF/oMdScDpdq+zq8WppWe9GONWppEEx2pIcnaALiI="``.

    This is the value to use for the ``hash`` attribute of
    ``fetchFromGitHub { owner; repo; tag; hash; }`` (without submodules).

    Requires ``nix`` ≥ 2.4 on PATH.

    Parameters
    ----------
    owner, repo:
        GitHub repository coordinates.
    tag:
        Git tag to fetch, e.g. ``"v1.6.0"``.

    Raises
    ------
    subprocess.CalledProcessError
        If ``nix store prefetch-file`` exits non-zero.
    """
    url = (
        f"https://github.com/{owner}/{repo}"
        f"/archive/refs/tags/{tag}.tar.gz"
    )
    print(f"  Fetching NAR hash for {owner}/{repo} @ {tag} …", file=sys.stderr)
    try:
        result = subprocess.run(
            [
                "nix", "store", "prefetch-file",
                "--hash-type", "sha256",
                "--unpack",
                "--json",
                url,
            ],
            capture_output=True,
            text=True,
            check=True,
        )
        data = json.loads(result.stdout)
        sri = data.get("hash", "")
        if not sri:
            raise RuntimeError(
                f"`nix store prefetch-file --json` returned no hash for {url}.\n"
                f"  stdout: {result.stdout!r}\n"
                f"  stderr: {result.stderr.strip()}"
            )
        print(f"    → {sri}", file=sys.stderr)
        return sri
    except subprocess.CalledProcessError as exc:
        print(
            f"Error: `nix store prefetch-file` failed for "
            f"{owner}/{repo}@{tag}:\n"
            f"  URL:    {url}\n"
            f"  stderr: {exc.stderr.strip()}",
            file=sys.stderr,
        )
        raise


# ---------------------------------------------------------------------------
# Hash computation — git clone with submodules
# ---------------------------------------------------------------------------

def fetch_github_source_hash_with_submodules(owner: str, repo: str, tag: str) -> str:
    """
    Compute and return the Nix SRI NAR hash for a git clone of *tag* that
    includes all submodules.

    This is the value to use for the ``hash`` attribute of::

        fetchFromGitHub { owner; repo; tag; fetchSubmodules = true; hash; }

    It is computed via ``nix-prefetch-github --fetch-submodules``, which
    clones the repository, recursively fetches submodules, and NAR-hashes the
    resulting tree.

    Requires ``nix-prefetch-github`` (nixpkgs package ``nix-prefetch-github``)
    on PATH.

    Parameters
    ----------
    owner, repo:
        GitHub repository coordinates.
    tag:
        Git tag to fetch, e.g. ``"v2.8.3"``.

    Returns
    -------
    str
        SRI hash string, e.g. ``"sha256-6I1O4E5K5IdbpzrXFHK06QVcOE8zuVkFE338ffk6N8M="``.

    Raises
    ------
    subprocess.CalledProcessError
        If ``nix-prefetch-github`` exits non-zero.
    RuntimeError
        If the output JSON contains no recognisable hash field.
    """
    print(
        f"  Fetching submodule NAR hash for {owner}/{repo} @ {tag} …"
        " (this clones the repo + submodules and may take a while)",
        file=sys.stderr,
    )
    try:
        result = subprocess.run(
            [
                "nix-prefetch-github",
                "--fetch-submodules",
                "--rev", tag,
                owner,
                repo,
            ],
            capture_output=True,
            text=True,
            check=True,
        )
        data = json.loads(result.stdout)

        # nix-prefetch-github >= 4.0 emits a "hash" field in SRI format.
        sri = data.get("hash", "")
        if sri:
            print(f"    → {sri}", file=sys.stderr)
            return sri

        # Older versions emit a base32 "sha256" field; convert to SRI.
        sha256_b32 = data.get("sha256", "")
        if sha256_b32:
            conv = subprocess.run(
                ["nix", "hash", "to-sri", "--type", "sha256", sha256_b32],
                capture_output=True,
                text=True,
                check=True,
            )
            sri = conv.stdout.strip()
            print(f"    → {sri}  (converted from base32)", file=sys.stderr)
            return sri

        raise RuntimeError(
            f"`nix-prefetch-github --fetch-submodules` returned no hash for "
            f"{owner}/{repo}@{tag}.\n"
            f"  stdout: {result.stdout!r}\n"
            f"  stderr: {result.stderr.strip()}"
        )
    except subprocess.CalledProcessError as exc:
        print(
            f"Error: `nix-prefetch-github --fetch-submodules` failed for "
            f"{owner}/{repo}@{tag}:\n"
            f"  stderr: {exc.stderr.strip()}",
            file=sys.stderr,
        )
        raise


# ---------------------------------------------------------------------------
# Per-version file I/O
# ---------------------------------------------------------------------------

def _source_hash_path(output_dir: str, version: str) -> str:
    """Return the path for a source-hash file, e.g. ``…/v1.6.0.nix``."""
    return os.path.join(output_dir, f"v{version}.nix")


def source_hash_exists(output_dir: str, version: str) -> bool:
    """Return True if a source-hash file already exists for *version*."""
    return os.path.isfile(_source_hash_path(output_dir, version))


def write_source_hash_file(output_dir: str, entry: SourceEntry) -> None:
    """
    Write (or overwrite) ``source-hashes/v{version}.nix`` for *entry*.

    The file is a minimal Nix attrset::

        {
          rev  = "v1.6.0";
          hash = "sha256-…";
        }

    ``owner`` and ``repo`` are emitted only when non-empty (i.e. when they
    differ from the package's well-known defaults).

    Parameters
    ----------
    output_dir:
        Directory to write into (created if absent).
    entry:
        Source entry to serialise.
    """
    os.makedirs(output_dir, exist_ok=True)
    path = _source_hash_path(output_dir, entry.version)

    lines: list[str] = [
        "# WARNING: Auto-generated file. Do not edit manually!",
        "{",
    ]
    if entry.owner:
        lines.append(f'  owner = "{entry.owner}";')
    if entry.repo:
        lines.append(f'  repo  = "{entry.repo}";')
    lines.append(f'  rev  = "{entry.tag}";')
    lines.append(f'  hash = "{entry.hash}";')
    lines.append("}")
    lines.append("")   # trailing newline

    with open(path, "w") as fh:
        fh.write("\n".join(lines))

    print(f"Wrote {path}", file=sys.stderr)
