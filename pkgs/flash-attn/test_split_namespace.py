"""The namespace split must never modify the original wheel or native code."""

import csv
from pathlib import Path
import tempfile
import unittest

from split_namespace import split_namespace


class NamespaceSplitTest(unittest.TestCase):
    def test_split_preserves_original_and_native_extension(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            source, output = root / "source", root / "output"
            cute = output / "flash_attn" / "cute"
            cute.mkdir(parents=True)
            metadata = output / "flash_attn-2.8.3.dist-info"
            metadata.mkdir()
            source.mkdir()
            native = source / "flash_attn_2_cuda.so"
            native.write_bytes(b"unchanged native extension")
            (output / native.name).symlink_to(native)
            module = source / "interface.py"
            module.write_text("old cute")
            (cute / module.name).symlink_to(module)
            record = source / "RECORD"
            rows = [["flash_attn/cute/interface.py", "", ""],
                    ["flash_attn_2_cuda.so", "", ""]]
            with record.open("w", newline="") as stream:
                csv.writer(stream).writerows(rows)
            (metadata / "RECORD").symlink_to(record)
            split_namespace(output)
            self.assertFalse(cute.exists())
            self.assertEqual((output / native.name).resolve(), native)
            self.assertEqual(module.read_text(), "old cute")
            with record.open(newline="") as stream:
                self.assertEqual(list(csv.reader(stream)), rows)
            with (metadata / "RECORD").open(newline="") as stream:
                self.assertEqual(list(csv.reader(stream)), rows[1:])
            split_namespace(output)


if __name__ == "__main__":
    unittest.main()
