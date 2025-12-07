import json
import tempfile
from pathlib import Path
from unittest import TestCase

from gcaa.tools.disk import (
    extend_filename,
    dump_pickle,
    load_pickle,
    dump_json,
    load_json,
    dump_txt,
    load_txt,
    mkdir,
    human_readable_size,
)


class TestDisk(TestCase):
    def test_extend_filename(self):
        # Path input
        p = Path("dir") / "file.txt"
        new_p = extend_filename(p, "_x")
        self.assertEqual(new_p.name, "file_x.txt")
        # str input returns str
        new_s = extend_filename("another.txt", "_v")
        self.assertIsInstance(new_s, str)
        self.assertTrue(new_s.endswith("another_v.txt"))

    def test_pickle_roundtrip_and_errors(self):
        data = {"a": 1, "b": [1, 2, 3]}
        with tempfile.TemporaryDirectory() as td:
            p = Path(td) / "data.pkl"
            dump_pickle(data, p)
            loaded = load_pickle(p)
            self.assertEqual(loaded, data)

            # nonexistent with raise_error=False returns None
            non = Path(td) / "nope.pkl"
            self.assertIsNone(load_pickle(non, raise_error=False))
            with self.assertRaises(FileNotFoundError):
                load_pickle(non, raise_error=True)

            # corrupt file: return None when raise_error=False, raise when True
            corrupt = Path(td) / "bad.pkl"
            corrupt.write_bytes(b"not a pickle")
            self.assertIsNone(load_pickle(corrupt, raise_error=False))
            with self.assertRaises(Exception):
                load_pickle(corrupt, raise_error=True)

    def test_json_roundtrip_and_errors(self):
        obj = {"x": 10, "y": ["a", "b"]}
        with tempfile.TemporaryDirectory() as td:
            p = Path(td) / "data.json"
            dump_json(obj, p)
            loaded = load_json(p)
            self.assertEqual(loaded, obj)

            non = Path(td) / "no.json"
            self.assertIsNone(load_json(non, raise_error=False))
            with self.assertRaises(FileNotFoundError):
                load_json(non, raise_error=True)

            bad = Path(td) / "bad.json"
            bad.write_text("}{ not json")
            self.assertIsNone(load_json(bad, raise_error=False))
            with self.assertRaises(json.JSONDecodeError):
                load_json(bad, raise_error=True)

    def test_txt_dump_and_append(self):
        with tempfile.TemporaryDirectory() as td:
            p = Path(td) / "t.txt"
            dump_txt("hello", p, mode="w")
            self.assertEqual(load_txt(p), "hello")
            dump_txt(" world", p, mode="a")
            self.assertEqual(load_txt(p), "hello world")

    def test_mkdir_and_human_readable_size(self):
        with tempfile.TemporaryDirectory() as td:
            nested = Path(td) / "a" / "b" / "c"
            # ensure it does not exist then create
            self.assertFalse(nested.exists())
            mkdir(nested)
            self.assertTrue(nested.exists())
            # human readable size checks
            self.assertTrue(human_readable_size(500).endswith("B"))
            self.assertTrue("KB" in human_readable_size(1024))
