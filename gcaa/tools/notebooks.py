from IPython import get_ipython


def is_notebook() -> bool:
    """
    >>> is_notebook()
    False
    """
    try:
        shell = get_ipython().__class__.__name__
        if shell == 'ZMQInteractiveShell':
            return True  # Jupyter notebook or qtconsole
        elif shell == 'TerminalInteractiveShell':
            return False  # Terminal running IPython
        else:
            return False  # Another type
    except NameError:
        return False  # Probably standard Python interpreter
