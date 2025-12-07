import numpy as np

from gcaa.tools.arrays import box, unbox, array2string


def test_box_with_scalar_and_list():
    # scalar becomes single-item list
    assert box(5) == [5]
    # list is returned as-is (same object)
    l = [1, 2]
    out = box(l)
    assert out is l


def test_unbox_behaviour():
    # single-element list gets unboxed
    assert unbox([42]) == 42
    # multi-element list stays untouched
    data = [1, 2]
    assert unbox(data) is data
    # non-list input is returned untouched
    assert unbox(10) == 10


def test_array2string_two_decimals():
    arr = np.array([1.234, -2.2, 3.0], dtype=float)
    s = array2string(arr)
    # Expect bracketed space-separated numbers with two decimals
    assert s.startswith('[') and s.endswith(']')
    # Ensure each component formatted to two decimals
    for token in ['1.23', '-2.20', '3.00']:
        assert token in s
