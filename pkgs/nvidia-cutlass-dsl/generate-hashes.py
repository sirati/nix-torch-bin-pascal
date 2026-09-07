"""
nvidia-cutlass-dsl generate-hashes configuration module.

Imported by the shared entry point ``generate-hashes/main.py``.
Do NOT add a main() here.

CuTeDSL wheels are distributed exclusively via PyPI (originType "pypi"),
split across several projects:

  nvidia-cutlass-dsl            – metadata-only meta wheel (py3-none-any)
  nvidia-cutlass-dsl-libs-base  – the compiled package (per-CPython manylinux)
  nvidia-cutlass-dsl-libs-core  – the pure-Python frontend (4.6.0+, py3-none-any)
  nvidia-cutlass-dsl-libs-cu12  – CUDA 12 toolkit flavor + runtime (4.6.0+)
  nvidia-cutlass-dsl-libs-cu13  – CUDA 13 toolkit flavor / extra libs (optional)

plus the cuda-python / cuda-bindings / cuda-pathfinder runtime chain, which
is not packaged in nixpkgs and is therefore pinned here as well.

Layouts: up to 4.5.x libs-base carries the Python frontend (the ``cutlass``
package) and the cu12 runtime.  From 4.6.0 libs-base ships only the compiled
MLIR libraries; the frontend is the libs-core wheel, the toolkit flavor
(``_cutlass_ir.cu1N`` + runtime) is libs-cu12 / libs-cu13, and libs-core
requires the nvidia-cuda-nvdisasm wheel (nvdisasm binary for SASS dumps),
pinned here to the newest release satisfying that requirement.

Outputs:
  binary-hashes/v{version}.nix       – { _version; meta; base; core?; cu12?; cu13?; nvdisasm? }
  binary-hashes/cuda-deps-cu12.nix   – pinned cuda-python 12.x chain
  binary-hashes/cuda-deps-cu13.nix   – pinned cuda-python 13.x chain

Invocation (from project root):
  nix run .#default.nvidia-cutlass-dsl.gen-hashes
  nix run .#default.nvidia-cutlass-dsl.gen-hashes -- --tag 4.4.2
  nix run .#default.nvidia-cutlass-dsl.gen-hashes -- --regen-cuda-deps

Options:
  --tag VERSION       Process only this version (always overwrites its file).
  --regen-cuda-deps   Regenerate the cuda-deps pin files even if they exist
                      (this silently bumps the cuda-python pins to the latest
                      releases — review the diff).
"""

import argparse
import os
import re
import sys

_GENERATE_HASHES_DIR = os.path.join(
    os.path.dirname(os.path.abspath(__file__)), "../..", "generate-hashes"
)
if _GENERATE_HASHES_DIR not in sys.path:
    sys.path.insert(0, _GENERATE_HASHES_DIR)

from common import sort_pyver_key_ft, sort_version_key
from source_pypi import (
    collect_pyver_wheels,
    cp_tag_to_pyver,
    fetch_pypi_requires_dist,
    fetch_pypi_versions,
    fetch_pypi_wheels,
    iter_linux_wheels,
    manylinux_rank,
)

NVDISASM_PROJECT = "nvidia-cuda-nvdisasm"

# ORIGIN_TYPE ("pypi") is injected by makeGenHashesApp from the HLD.

_HERE = os.path.dirname(os.path.abspath(__file__))
OUTPUT_DIR = os.path.join(_HERE, "binary-hashes")

# Versions below 4.4.0 predate the meta/libs-base wheel split (they shipped
# monolithic per-CPython wheels under the nvidia-cutlass-dsl name) and are
# not supported by overlay-bin.nix.
MIN_VERSION = "4.4.0"

# cuda-python major line per CUDA label family.  cu13 pins are kept on the
# 13.0 series to match the cudaPackages set used for the cu130 label.
CU12_CUDA_PYTHON_PREFIX = "12."
CU13_CUDA_PYTHON_PREFIX = "13.0."

HEADER = """\
# WARNING: Auto-generated file. Do not edit manually!
# Source:  https://pypi.org/project/nvidia-cutlass-dsl/
# To regenerate: nix run .#default.nvidia-cutlass-dsl.gen-hashes [-- --tag {version}]
#
# nvidia-cutlass-dsl {version} binary-wheel hashes.
#
# Structure:
#   meta = {{ name, url, hash }}                  (metadata-only meta wheel)
#   base = pyVer -> os -> arch -> {{ name, url, hash }}   (libs-base wheels)
#   cu12 = pyVer -> os -> arch -> {{ name, url, hash }}   (libs-cu12, 4.6.0+)
#   cu13 = pyVer -> os -> arch -> {{ name, url, hash }}   (libs-cu13, optional)
#   core = {{ name, url, hash }}                  (libs-core frontend wheel, 4.6.0+)
#   nvdisasm = os -> arch -> {{ name, url, hash }}   (nvidia-cuda-nvdisasm, 4.6.0+)"""

CUDA_DEPS_HEADER = """\
# WARNING: Auto-generated file. Do not edit manually!
# Source:  https://pypi.org/project/cuda-python/
# To regenerate: nix run .#default.nvidia-cutlass-dsl.gen-hashes -- --regen-cuda-deps
#
# Pinned cuda-python dependency chain for nvidia-cutlass-dsl ({family}).
# nixpkgs does not package cuda-python, so overlay-bin.nix installs these
# wheels alongside the CuTeDSL wheels.
#
# Structure:
#   cuda-python     = {{ name, url, hash }}     (py3-none-any meta wheel)
#   cuda-pathfinder = {{ name, url, hash }}     (py3-none-any wheel)
#   cuda-bindings   = pyVer -> os -> arch -> {{ name, url, hash }}"""


# ---------------------------------------------------------------------------
# Nix emitters (the mixed leaf/nested structure does not fit the shared
# nix_writer schema walker, so the files are written locally)
# ---------------------------------------------------------------------------

def _write_leaf(f, leaf: dict, depth: int) -> None:
    pad = "  " * depth
    f.write("{\n")
    for k in ("name", "url", "hash"):
        f.write(f'{pad}  {k} = "{leaf[k]}";\n')
    f.write(f"{pad}}};\n")


def _write_pyver_section(f, section: dict, depth: int) -> None:
    """section: pyVer -> os -> arch -> leaf"""
    pad = "  " * depth
    f.write("{\n")
    for py in sorted(section.keys(), key=sort_pyver_key_ft):
        attr = f'"{py}"' if "-" in py else py
        f.write(f"{pad}  {attr} = {{\n")
        for os_name in sorted(section[py].keys()):
            f.write(f"{pad}    {os_name} = {{\n")
            for arch in sorted(section[py][os_name].keys()):
                f.write(f"{pad}      {arch} = ")
                _write_leaf(f, section[py][os_name][arch], depth + 3)
            f.write(f"{pad}    }};\n")
        f.write(f"{pad}  }};\n")
    f.write(f"{pad}}};\n")


# ---------------------------------------------------------------------------
# Wheel collection
# ---------------------------------------------------------------------------

def _any_wheel_leaf(project: str, version: str) -> dict | None:
    """Return the leaf for the single py3-none-any wheel, or None."""
    for entry in fetch_pypi_wheels(project, version):
        if entry.name.endswith("-py3-none-any.whl"):
            return entry.to_leaf()
    return None


def _platform_wheels(project: str, version: str) -> dict:
    """os -> arch -> leaf of the pure-Python per-platform wheels (newest glibc wins)."""
    best: dict[tuple[str, str], tuple[int, dict]] = {}
    for entry, parsed, os_name, arch in iter_linux_wheels(project, version):
        if cp_tag_to_pyver(parsed["py"], parsed["abi"]) != "any":
            continue
        rank = manylinux_rank(parsed["platform"])
        if (os_name, arch) not in best or rank > best[(os_name, arch)][0]:
            best[(os_name, arch)] = (rank, entry.to_leaf())
    section: dict = {}
    for (os_name, arch), (_, leaf) in sorted(best.items()):
        section.setdefault(os_name, {})[arch] = leaf
    return section


_SPEC_CLAUSE_RE = re.compile(r"(<=|>=|==|!=|<|>)\s*([\w.]+)")


def _requirement_clauses(project: str, version: str, dependency: str) -> list[tuple[str, str]]:
    """The version clauses *project* *version* declares on *dependency*."""
    for req in fetch_pypi_requires_dist(project, version):
        name = re.split(r"[\s<>=!;\[]", req, maxsplit=1)[0]
        if name.lower().replace("_", "-") != dependency:
            continue
        spec = req.split(";", 1)[0][len(name):]
        clauses = _SPEC_CLAUSE_RE.findall(spec)
        if "".join(op + v for op, v in clauses) != re.sub(r"[\s,]", "", spec):
            print(f"Error: unsupported version specifier {spec!r} on {dependency}.",
                  file=sys.stderr)
            sys.exit(1)
        return clauses
    print(f"Error: {project} {version} declares no requirement on {dependency}.",
          file=sys.stderr)
    sys.exit(1)


def _satisfies(candidate: str, clauses: list[tuple[str, str]]) -> bool:
    key = sort_version_key(candidate)
    checks = {
        "<": lambda b: key < b, "<=": lambda b: key <= b,
        ">": lambda b: key > b, ">=": lambda b: key >= b,
        "==": lambda b: key == b, "!=": lambda b: key != b,
    }
    return all(checks[op](sort_version_key(bound)) for op, bound in clauses)


def _nvdisasm_wheels(version: str) -> dict:
    """os -> arch -> leaf of the newest nvidia-cuda-nvdisasm release libs-core accepts."""
    clauses = _requirement_clauses("nvidia-cutlass-dsl-libs-core", version, NVDISASM_PROJECT)
    candidates = [
        v for v in fetch_pypi_versions(NVDISASM_PROJECT) if _satisfies(v, clauses)
    ]
    if not candidates:
        print(f"Error: no {NVDISASM_PROJECT} release satisfies {clauses}.", file=sys.stderr)
        sys.exit(1)
    chosen = max(candidates, key=sort_version_key)
    wheels = _platform_wheels(NVDISASM_PROJECT, chosen)
    if not wheels:
        print(f"Error: {NVDISASM_PROJECT} {chosen} has no Linux wheels.", file=sys.stderr)
        sys.exit(1)
    print(f"  {NVDISASM_PROJECT}: {chosen} ({', '.join(f'{o}/{a}' for o in wheels for a in wheels[o])})")
    return wheels


# ---------------------------------------------------------------------------
# Per-version file generation
# ---------------------------------------------------------------------------

def _generate_version(version: str) -> None:
    print(f"nvidia-cutlass-dsl {version}: fetching wheel metadata …")

    meta = _any_wheel_leaf("nvidia-cutlass-dsl", version)
    if meta is None:
        print(f"  no meta wheel for {version} — skipping.", file=sys.stderr)
        return

    base = collect_pyver_wheels("nvidia-cutlass-dsl-libs-base", version)
    if not base:
        print(f"  no libs-base wheels for {version} — skipping.", file=sys.stderr)
        return

    cu12 = collect_pyver_wheels("nvidia-cutlass-dsl-libs-cu12", version)
    cu13 = collect_pyver_wheels("nvidia-cutlass-dsl-libs-cu13", version)
    core = _any_wheel_leaf("nvidia-cutlass-dsl-libs-core", version)
    nvdisasm = _nvdisasm_wheels(version) if core is not None else None

    path = os.path.join(OUTPUT_DIR, f"v{version}.nix")
    with open(path, "w") as f:
        f.write(HEADER.format(version=version) + "\n\n")
        f.write("{\n")
        f.write(f'  _version = "{version}";\n')
        f.write("  meta = ")
        _write_leaf(f, meta, 1)
        if core is not None:
            f.write("  core = ")
            _write_leaf(f, core, 1)
        f.write("  base = ")
        _write_pyver_section(f, base, 1)
        if cu12:
            f.write("  cu12 = ")
            _write_pyver_section(f, cu12, 1)
        if cu13:
            f.write("  cu13 = ")
            _write_pyver_section(f, cu13, 1)
        if nvdisasm is not None:
            f.write("  nvdisasm = {\n")
            for os_name in sorted(nvdisasm.keys()):
                f.write(f"    {os_name} = {{\n")
                for arch in sorted(nvdisasm[os_name].keys()):
                    f.write(f"      {arch} = ")
                    _write_leaf(f, nvdisasm[os_name][arch], 3)
                f.write("    };\n")
            f.write("  };\n")
        f.write("}\n")
    n = sum(1 for py in base.values() for o in py.values() for _ in o.values())
    print(f"Wrote {path}  ({n} libs-base wheel entries; cu12: {'yes' if cu12 else 'no'}; "
          f"cu13: {'yes' if cu13 else 'no'}; frontend: "
          f"{'libs-core' if core is not None else 'in libs-base'})")


# ---------------------------------------------------------------------------
# cuda-deps pin files
# ---------------------------------------------------------------------------

def _generate_cuda_deps(family: str, prefix: str, force: bool) -> None:
    path = os.path.join(OUTPUT_DIR, f"cuda-deps-{family}.nix")
    if os.path.isfile(path) and not force:
        print(f"  {os.path.basename(path)} already exists — skipping "
              "(use --regen-cuda-deps to refresh).", file=sys.stderr)
        return

    cp_versions = [
        v for v in fetch_pypi_versions("cuda-python") if v.startswith(prefix)
    ]
    if not cp_versions:
        print(f"Error: no cuda-python versions matching {prefix!r}.", file=sys.stderr)
        sys.exit(1)
    cuda_python_version = max(cp_versions, key=sort_version_key)

    # cuda-bindings releases in lockstep with cuda-python (same version).
    bindings_version = cuda_python_version
    pathfinder_version = max(
        fetch_pypi_versions("cuda-pathfinder"), key=sort_version_key
    )

    print(f"cuda-deps-{family}: cuda-python {cuda_python_version}, "
          f"cuda-pathfinder {pathfinder_version}")

    cuda_python = _any_wheel_leaf("cuda-python", cuda_python_version)
    pathfinder = _any_wheel_leaf("cuda-pathfinder", pathfinder_version)
    bindings = collect_pyver_wheels("cuda-bindings", bindings_version)
    if cuda_python is None or pathfinder is None or not bindings:
        print(f"Error: incomplete cuda-python chain for {family}.", file=sys.stderr)
        sys.exit(1)

    with open(path, "w") as f:
        f.write(CUDA_DEPS_HEADER.format(family=family) + "\n\n")
        f.write("{\n")
        f.write(f'  _cudaPythonVersion     = "{cuda_python_version}";\n')
        f.write(f'  _cudaBindingsVersion   = "{bindings_version}";\n')
        f.write(f'  _cudaPathfinderVersion = "{pathfinder_version}";\n')
        f.write("  cuda-python = ")
        _write_leaf(f, cuda_python, 1)
        f.write("  cuda-pathfinder = ")
        _write_leaf(f, pathfinder, 1)
        f.write("  cuda-bindings = ")
        _write_pyver_section(f, bindings, 1)
        f.write("}\n")
    print(f"Wrote {path}")


# ---------------------------------------------------------------------------
# run() — called by the shared main for pypi packages
# ---------------------------------------------------------------------------

def run() -> None:
    p = argparse.ArgumentParser(
        description="Generate binary-hashes for nvidia-cutlass-dsl (PyPI wheels)."
    )
    p.add_argument("--tag", default=None, metavar="VERSION",
                   help="Process only this version (always overwrites).")
    p.add_argument("--regen-cuda-deps", action="store_true",
                   help="Regenerate the cuda-deps pin files (bumps pins).")
    args = p.parse_args()

    os.makedirs(OUTPUT_DIR, exist_ok=True)

    if args.tag:
        versions = [args.tag.lstrip("v")]
    else:
        versions = fetch_pypi_versions("nvidia-cutlass-dsl", min_version=MIN_VERSION)
        print(f"{len(versions)} nvidia-cutlass-dsl version(s) >= {MIN_VERSION}: "
              + ", ".join(versions))

    for version in versions:
        path = os.path.join(OUTPUT_DIR, f"v{version}.nix")
        if not args.tag and os.path.isfile(path):
            print(f"  binary-hashes/v{version}.nix already exists — skipping.",
                  file=sys.stderr)
            continue
        plain = re.match(r"^\d+\.\d+\.\d+$", version) is not None
        dev = re.match(r"^\d+\.\d+\.\d+\.dev\d+$", version) is not None
        if not plain and not (dev and args.tag):
            print(f"  {version}: not a plain x.y.z version — skipping "
                  "(dev builds are generated only when named with --tag).",
                  file=sys.stderr)
            continue
        _generate_version(version)

    _generate_cuda_deps("cu12", CU12_CUDA_PYTHON_PREFIX, args.regen_cuda_deps)
    _generate_cuda_deps("cu13", CU13_CUDA_PYTHON_PREFIX, args.regen_cuda_deps)
