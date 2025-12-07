import numpy as np


def hash_dict(d):
    """Generates a hash for a dictionary, including nested dictionaries."""
    # May want to use `hashlib.sha256(s).hexdigest()` in the future for reproducibility and
    # lower risk of collision
    # If the input is a dictionary, convert it to a sorted tuple of key-hash pairs
    if isinstance(d, dict):
        return hash(
            tuple(sorted((key, hash_dict(value)) for key, value in d.items())))
    # If the input is a list or tuple, hash its immutable version
    elif isinstance(d, (list, tuple)):
        return hash(tuple(hash_dict(item) for item in d))
    # For anything else, return its direct hash
    else:
        return hash(d)


def make_json_serializable(obj):
    """
    Recursively convert a Python object to a JSON-serializable form.
    Converts:
        - numpy arrays → lists
        - numpy scalars → native Python scalars
        - sets → lists
        - other objects with __dict__ → dict
    """
    if isinstance(obj, (np.ndarray, list, tuple)):
        return [make_json_serializable(x) for x in obj]
    elif isinstance(obj, (np.bool_, bool)):
        return bool(obj)
    elif isinstance(obj, (np.integer, int)):
        return int(obj)
    elif isinstance(obj, (np.floating, float)):
        return float(obj)
    elif isinstance(obj, dict):
        return {make_json_serializable(k): make_json_serializable(v) for k, v in
                obj.items()}
    elif isinstance(obj, set):
        return [make_json_serializable(x) for x in obj]
    elif hasattr(obj, "__dict__"):
        return make_json_serializable(vars(obj))
    elif obj is None or isinstance(obj, (str, int, float, bool)):
        return obj
    else:
        # fallback: convert to string
        return str(obj)
