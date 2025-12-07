import numpy as np

from gcaa.tools.basic import PrettyDict, dict_factory, check_nan


def test_prettydict_repr_and_attr_access_and_copy():
    pd = PrettyDict()
    # setattr writes as key
    pd.a = 1.0
    pd.b = 2
    # __getattr__ fetches same values
    assert pd.a == 1.0
    assert pd['b'] == 2
    # __repr__ formats with one decimal place
    rep = repr(pd)
    # Order is not guaranteed in dicts, so check parts exist
    assert 'a=1.0' in rep
    assert 'b=2.0' in rep
    # copy returns PrettyDict with same content
    pd2 = pd.copy()
    assert isinstance(pd2, PrettyDict)
    assert dict(pd2) == dict(pd)
    # ensure it's a shallow copy (distinct object)
    assert pd2 is not pd


def test_dict_factory_recursive_defaultdicts():
    d = dict_factory()
    # Accessing nested keys should auto-create nested dicts
    d['level1']['level2']['value'] = 10
    assert d['level1']['level2']['value'] == 10


def test_check_nan():
    # None is ok
    assert check_nan(None) is None
    # ndarray without NaN is ok
    ok = np.array([1, 2, 3], dtype=float)
    assert check_nan(ok) is None
    # ndarray with NaN raises
    bad = np.array([1, np.nan, 3], dtype=float)
    try:
        check_nan(bad)
    except RuntimeError as e:
        assert 'NaN detected' in str(e)
    else:
        assert False, 'Expected RuntimeError for NaN array'
