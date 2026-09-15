"""Remove FA2's vendored CuTe namespace without touching its native kernels."""

import csv
from pathlib import Path
import shutil
import sys


def split_namespace(site_packages: Path) -> None:
    cute = site_packages / "flash_attn" / "cute"
    if cute.is_symlink():
        cute.unlink()
    elif cute.exists():
        shutil.rmtree(cute)
    for record in site_packages.glob("flash_attn-*.dist-info/RECORD"):
        with record.open(newline="") as stream:
            rows = list(csv.reader(stream))
        retained = [row for row in rows if not row[0].startswith("flash_attn/cute/")]
        if retained != rows:
            record.unlink()
            with record.open("w", newline="") as stream:
                csv.writer(stream).writerows(retained)


if __name__ == "__main__":
    split_namespace(Path(sys.argv[1]))
