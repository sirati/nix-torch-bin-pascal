#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p python3 python3Packages.requests nix

"""
Generate binary-hashes.nix from PyTorch CUDA 12.6 wheel index.

This script:
1. Fetches the wheel index from https://download.pytorch.org/whl/cu126/torch/
2. Parses all torch 2.9.1 and 2.10.0 wheels with CUDA 12.6
3. Converts hex SHA256 hashes to Nix base32 format
4. Generates a properly structured binary-hashes.nix file

Structure: version -> pythonVersion -> os -> arch
"""

import re
import subprocess
import sys
from urllib.request import urlopen
from html.parser import HTMLParser


class TorchWheelParser(HTMLParser):
    """Parse PyTorch wheel index HTML to extract wheel information."""

    def __init__(self):
        super().__init__()
        self.wheels = []

    def handle_starttag(self, tag, attrs):
        if tag == 'a':
            attrs_dict = dict(attrs)
            href = attrs_dict.get('href', '')

            # Match torch 2.9.1 or 2.10.0 wheels with CUDA 12.6
            # Note: cp313-cp313t means the first cp313 is the ABI tag, cp313t is the platform tag
            match = re.match(
                r'/whl/cu126/torch-(2\.(?:9\.1|10\.0))%2Bcu126-'
                r'(cp\d+)-cp\d+(t)?-([\w_]+)\.whl#sha256=([a-f0-9]{64})',
                href
            )

            if match:
                version, cpver, is_threaded, platform, hexhash = match.groups()
                # Construct the full cpver (e.g., "cp313t" if free-threaded)
                full_cpver = cpver + ('t' if is_threaded else '')
                self.wheels.append({
                    'version': version,
                    'cpver': full_cpver,
                    'platform': platform,
                    'hexhash': hexhash
                })


def hex_to_nix_hash(hexhash):
    """Convert hex SHA256 to Nix base32 format."""
    try:
        result = subprocess.run(
            ['nix', 'hash', 'convert', '--hash-algo', 'sha256', hexhash],
            capture_output=True,
            text=True,
            check=True
        )
        return result.stdout.strip()
    except subprocess.CalledProcessError as e:
        print(f"Error converting hash {hexhash}: {e}", file=sys.stderr)
        return f"sha256:{hexhash}"


def platform_to_nix_system(platform):
    """Convert wheel platform to Nix system tuple (os, arch)."""
    if platform.startswith('manylinux'):
        # e.g., manylinux_2_28_x86_64 -> ("linux", "x86_64")
        # Extract architecture from the end of the platform string
        if platform.endswith('_x86_64'):
            return ("linux", "x86_64")
        elif platform.endswith('_aarch64'):
            return ("linux", "aarch64")
        else:
            # Fallback: try to extract last part
            parts = platform.split('_')
            arch = parts[-1]
            return ("linux", arch)
    elif platform == 'win_amd64':
        return ("windows", "x86_64")
    else:
        return ("unknown", "unknown")


def cpver_to_pyver(cpver):
    """Extract Python version from CPython version string.

    Examples:
        cp310 -> "310"
        cp313t -> "313"
    """
    return cpver.replace('cp', '').replace('t', '')


def is_freethreaded(cpver):
    """Check if CPython version is free-threaded."""
    return cpver.endswith('t')


def generate_nix_file(wheels, output_path):
    """Generate the binary-hashes.nix file."""

    # Organize wheels by version -> pyver -> os -> arch
    organized = {}

    for wheel in wheels:
        version = wheel['version']
        cpver = wheel['cpver']
        pyver = cpver_to_pyver(cpver)
        is_ft = is_freethreaded(cpver)
        os_name, arch = platform_to_nix_system(wheel['platform'])

        # Use py{ver}-freethreaded for free-threaded variants
        py_key = f"py{pyver}-freethreaded" if is_ft else f"py{pyver}"

        if version not in organized:
            organized[version] = {}
        if py_key not in organized[version]:
            organized[version][py_key] = {}
        if os_name not in organized[version][py_key]:
            organized[version][py_key][os_name] = {}

        organized[version][py_key][os_name][arch] = wheel

    # Generate Nix file
    with open(output_path, 'w') as f:
        f.write('# WARNING: Auto-generated file. Do not edit manually!\n')
        f.write('# Generated from: https://download.pytorch.org/whl/cu126/torch/\n')
        f.write('# To regenerate: nix-shell torch-bin-cu126/generate-hashes.py\n')
        f.write('#\n')
        f.write('# Structure: version -> pythonVersion -> os -> arch\n')
        f.write('#   pythonVersion: py310, py311, py312, py313, py313-freethreaded, py314, py314-freethreaded\n')
        f.write('#   os: linux, windows\n')
        f.write('#   arch: x86_64, aarch64\n')
        f.write('\n')
        f.write('version:\n')
        f.write('builtins.getAttr version {\n')

        for version in sorted(organized.keys()):
            f.write(f'  "{version}" = {{\n')

            for py_key in sorted(organized[version].keys()):
                f.write(f'    {py_key} = {{\n')

                for os_name in sorted(organized[version][py_key].keys()):
                    f.write(f'      {os_name} = {{\n')

                    for arch in sorted(organized[version][py_key][os_name].keys()):
                        wheel = organized[version][py_key][os_name][arch]

                        cpver = wheel['cpver']
                        platform = wheel['platform']
                        hexhash = wheel['hexhash']
                        nixhash = hex_to_nix_hash(hexhash)

                        wheel_name = f"torch-{version}-{cpver}-{cpver}-{platform}.whl"
                        url = (f"https://download.pytorch.org/whl/cu126/"
                               f"torch-{version}%2Bcu126-{cpver}-{cpver}-{platform}.whl#sha256={hexhash}")

                        f.write(f'        {arch} = {{\n')
                        f.write(f'          name = "{wheel_name}";\n')
                        f.write(f'          url = "{url}";\n')
                        f.write(f'          hash = "{nixhash}";\n')
                        f.write(f'        }};\n')

                    f.write(f'      }};\n')

                f.write(f'    }};\n')

            f.write('  };\n\n')

        f.write('}\n')

    print(f"Generated {output_path} with {len(wheels)} wheels")


def main():
    """Main entry point."""
    print("Fetching PyTorch wheel index...")

    # Fetch the wheel index page
    url = 'https://download.pytorch.org/whl/cu126/torch/'
    try:
        with urlopen(url) as response:
            html = response.read().decode('utf-8')
    except Exception as e:
        print(f"Error fetching {url}: {e}", file=sys.stderr)
        sys.exit(1)

    print("Parsing wheels...")
    parser = TorchWheelParser()
    parser.feed(html)

    if not parser.wheels:
        print("No wheels found!", file=sys.stderr)
        sys.exit(1)

    print(f"Found {len(parser.wheels)} wheels")

    # Generate the Nix file
    output_path = 'torch-bin-cu126/binary-hashes.nix'
    print(f"Generating {output_path}...")
    generate_nix_file(parser.wheels, output_path)

    print("Done!")


if __name__ == '__main__':
    main()
