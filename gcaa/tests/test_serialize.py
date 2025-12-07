import numpy as np

from gcaa.tools.serialize import hash_dict, make_json_serializable


def test_hash_dict_order_independence_and_nesting():
    d1 = {"a": 1, "b": [1, 2, {"x": 3}]}
    d2 = {"b": [1, 2, {"x": 3}], "a": 1}  # different key order
    assert hash_dict(d1) == hash_dict(d2)

    # Changing a nested value should change the hash (very high probability)
    d3 = {"a": 1, "b": [1, 2, {"x": 4}]}
    assert hash_dict(d1) != hash_dict(d3)

    # Tuples and lists are both handled via recursive hashing
    d4 = {"a": (1, 2)}
    d5 = {"a": [1, 2]}
    # Not necessarily equal since tuple vs list are distinct types; ensure function handles both without error
    _ = hash_dict(d4)
    _ = hash_dict(d5)


class Dummy:
    def __init__(self):
        self.a = np.array([1, 2])
        self.b = np.float64(3.5)


def test_make_json_serializable_various_types():
    # numpy array -> list
    arr = np.array([[1.0, 2.0], [3.0, 4.0]])
    out = make_json_serializable(arr)
    assert out == [[1.0, 2.0], [3.0, 4.0]]

    # numpy scalars -> python scalars
    assert isinstance(make_json_serializable(np.int64(5)), int)
    assert isinstance(make_json_serializable(np.float64(2.5)), float)
    assert isinstance(make_json_serializable(np.bool_(True)), bool)

    # set -> list (order not guaranteed)
    s = {1, 2}
    out_s = make_json_serializable(s)
    assert sorted(out_s) == [1, 2]

    # dict with numpy content -> plain dict with serializable content
    d = {"k": np.array([1, 2])}
    out_d = make_json_serializable(d)
    assert out_d == {"k": [1, 2]}

    # object with __dict__ -> dict representation recursively serialized
    o = Dummy()
    out_o = make_json_serializable(o)
    assert out_o == {"a": [1, 2], "b": 3.5}

    # pass-through primitives
    assert make_json_serializable(None) is None
    assert make_json_serializable("x") == "x"
    assert make_json_serializable(3) == 3
    assert make_json_serializable(2.0) == 2.0
    assert make_json_serializable(True) is True

    # Fallback to string for unsupported types, e.g., complex
    c = complex(1, 2)
    assert make_json_serializable(c) == str(c)
