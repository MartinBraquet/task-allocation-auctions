def hash_dict(d):
    """Generates a hash for a dictionary, including nested dictionaries."""
    # May want to use `hashlib.sha256(s).hexdigest()` in the future for reproducibility and
    # lower risk of collision
    # If the input is a dictionary, convert it to a sorted tuple of key-hash pairs
    if isinstance(d, dict):
        return hash(tuple(sorted((key, hash_dict(value)) for key, value in d.items())))
    # If the input is a list or tuple, hash its immutable version
    elif isinstance(d, (list, tuple)):
        return hash(tuple(hash_dict(item) for item in d))
    # For anything else, return its direct hash
    else:
        return hash(d)
