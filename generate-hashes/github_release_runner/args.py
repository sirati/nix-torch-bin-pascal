from __future__ import annotations

import argparse
import os
import sys


def strip_nix_shell_dashdash() -> None:
    """
    Remove bare ``--`` entries from ``sys.argv``.

    When a script is invoked as ``nix-shell script.py -- --flag``, nix-shell
    passes ``--`` as a literal positional argument to the Python interpreter.
    argparse does not expect it there and raises "unrecognized arguments: --".
    Stripping it here before argparse runs fixes the issue transparently.
    """
    sys.argv = [sys.argv[0]] + [a for a in sys.argv[1:] if a != "--"]


def add_common_args(parser: argparse.ArgumentParser) -> None:
    """
    Add the arguments shared by every GitHub-release hash generator.

    Arguments added
    ---------------
    ``--tag TAG``
        Process only this one release tag.  When omitted all releases are
        processed.
    ``--prereleases``
        Include pre-releases in the all-releases listing.
    ``--token TOKEN``
        GitHub personal-access token.  Also read from ``$GITHUB_TOKEN``.
    ``--cutoff-year YEAR``
        Skip releases published in YEAR or earlier (default: 2022).
    ``--skip-source``
        Skip source-hash generation (binary hashes only).  Only relevant for
        packages that produce source hashes; silently ignored for packages
        that do not.
    ``--source-only``
        Only generate source hashes; skip binary-wheel hash generation.
        Mutually exclusive with ``--skip-source``.
    """
    parser.add_argument(
        "--tag",
        metavar="TAG",
        default=None,
        help=(
            "Process only this specific release tag (e.g. v1.6.0). "
            "By default all releases are processed."
        ),
    )
    parser.add_argument(
        "--prereleases",
        action="store_true",
        help="Include pre-releases when fetching all releases.",
    )
    parser.add_argument(
        "--token",
        default=os.environ.get("GITHUB_TOKEN"),
        help=(
            "GitHub personal access token. "
            "Also read from $GITHUB_TOKEN. "
            "Optional but raises the API rate limit from 60 to 5 000 req/h."
        ),
    )
    parser.add_argument(
        "--cutoff-year",
        dest="cutoff_year",
        type=int,
        default=2022,
        metavar="YEAR",
        help=(
            "Skip releases published in YEAR or earlier (default: 2022). "
            "These pre-date GitHub's digest feature and are recorded in "
            "missing-digests.txt as 'too old'. Use 0 to disable the filter."
        ),
    )
    parser.add_argument(
        "--skip-source",
        dest="skip_source",
        action="store_true",
        help=(
            "Skip source-hash generation (binary hashes only). "
            "Only relevant for packages that also produce source hashes."
        ),
    )
    parser.add_argument(
        "--source-only",
        dest="source_only",
        action="store_true",
        help=(
            "Only generate source hashes; skip binary-wheel hash generation. "
            "Cannot be combined with --skip-source."
        ),
    )
