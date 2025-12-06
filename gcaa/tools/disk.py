import json
import pickle
from pathlib import Path


def extend_filename(file_path: str | Path, s: str) -> Path:
    """
    Extends the filename of a file with a string.
    :param file_path:
    :param s:
    :return:

    Example:
    >>> Path(extend_filename("path/to/file.txt", "_new")).as_posix()
    'path/to/file_new.txt'

    >>> extend_filename(Path("file.txt"), "_old").as_posix()
    'file_old.txt'
    """
    is_string = isinstance(file_path, str)
    file_path = Path(file_path)
    file_path_new = file_path.with_name(file_path.stem + s + file_path.suffix)
    if is_string:
        file_path_new = str(file_path_new)
    return file_path_new


def dump_pickle(obj, file_path: str | Path):
    """
    Dumps an object to a file using pickle.
    :param obj:
    :param file_path:
    :return:
    """

    with open(file_path, 'wb') as f:
        pickle.dump(obj, f)  # noqa


def load_pickle(file_path: str | Path, raise_error=True):
    """
    Loads an object from a file using pickle.
    :param file_path:
    :param raise_error: If True, raises an error if the file doesn't exist. If False, returns None.
    :return:
    """
    if not Path(file_path).exists():
        if raise_error:
            raise FileNotFoundError(f"File {file_path} not found.")
        return None

    try:
        with open(file_path, 'rb') as f:
            return pickle.load(f)
    except (EOFError, pickle.UnpicklingError):
        if raise_error:
            raise
        return None


def dump_json(obj, file_path: str | Path):
    """
    Dumps an object to a file using pickle.
    :param obj:
    :param file_path:
    :return:
    """
    with open(file_path, 'w') as f:
        json.dump(obj, f)


def load_json(file_path: str | Path, raise_error=True):
    """
    Loads an object from a file using pickle.
    :param file_path:
    :param raise_error: If True, raises an error if the file doesn't exist. If False, returns None.
    :return:
    """
    if not Path(file_path).exists():
        if raise_error:
            raise FileNotFoundError(f"File {file_path} not found.")
        return None

    try:
        with open(file_path, 'r') as f:
            return json.load(f)
    except json.JSONDecodeError:
        if raise_error:
            raise
        return None


def load_txt(file_path: str | Path):
    """
    Loads an object from a file using pickle.
    :param file_path:
    :return:
    """
    with open(file_path, 'r') as f:
        return f.read()


def dump_txt(obj, file_path: str | Path, mode='w'):
    """
    Dumps an object to a file.
    :param obj:
    :param file_path:
    """
    with open(file_path, mode=mode) as f:
        f.write(obj)


def mkdir(path: str | Path):
    """
    Creates a directory if it doesn't exist.
    :param path:
    """
    Path(path).mkdir(parents=True, exist_ok=True)


def human_readable_size(size_in_bytes):
    for unit in ['B', 'KB', 'MB', 'GB']:
        if size_in_bytes < 1024:
            return f"{size_in_bytes:.2f} {unit}"
        size_in_bytes /= 1024
    return f"{size_in_bytes:.2f} TB"
