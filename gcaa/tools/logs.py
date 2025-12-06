import logging
import sys
from contextlib import contextmanager
from logging import Logger
from pathlib import Path
from typing import Optional


class ColorFormatter(logging.Formatter):
    RESET = "\033[0m"
    COLORS = {
        logging.DEBUG: "\033[34m",  # Blue
        logging.WARNING: "\033[31m",  # Red
    }

    def format(self, record):
        color = self.COLORS.get(record.levelno, "")
        message = super().format(record)
        return f"{color}{message}{self.RESET}" if color else message


class StdoutFilter(logging.Filter):
    def filter(self, record):
        return record.levelno < logging.ERROR  # DEBUG, INFO, WARNING


class StderrFilter(logging.Filter):
    def filter(self, record):
        return record.levelno >= logging.ERROR  # ERROR, CRITICAL


def get_stdout_handler(formatter):
    # Stdout handler (DEBUG, INFO, WARNING)
    stdout_handler = logging.StreamHandler(sys.stdout)
    stdout_handler.setLevel(logging.DEBUG)
    stdout_handler.addFilter(StdoutFilter())
    stdout_handler.setFormatter(formatter)
    return stdout_handler


def get_stderr_handler(formatter):
    # Stderr handler (ERROR, CRITICAL)
    stderr_handler = logging.StreamHandler(sys.stderr)
    stderr_handler.setLevel(logging.ERROR)
    stderr_handler.addFilter(StderrFilter())
    stderr_handler.setFormatter(formatter)
    return stderr_handler


class logger:  # noqa
    client: Optional[Logger] = None
    section = 'main'
    ENABLED_SECTIONS = {
        'main': True,
        'game': True,
        'monte_carlo': True,
        'alpha_beta': True,
        'training': True,
        'benchmark': True,
    }
    history = []

    @classmethod
    def setup(
        cls,
        name: str = None,
        loglevel: str = 'INFO',
        section: str | list = None,
    ):
        """
        Sets up the logger.

        :param name: Name of the logger
        :param loglevel: log level (default: INFO)
        :param section: sections of the logger to render (default: all)
        """
        cls.set_section(section)

        if cls.client is not None and cls.client.level == logging.INFO:
            return
        cls.client = logging.getLogger(name)
        cls.client.setLevel(loglevel)

        formatter = ColorFormatter(
            # '%(asctime)s - '
            # '%(name)s - '
            # '%(levelname)s - '
            '%(message)s'
        )

        stdout_handler = get_stdout_handler(formatter)
        stderr_handler = get_stderr_handler(formatter)

        cls.client.handlers = []
        cls.client.addHandler(stdout_handler)
        cls.client.addHandler(stderr_handler)

    @classmethod
    @contextmanager
    def setup_in_context(cls, *args, **kwargs):
        cls.setup(*args, **kwargs)
        enabled_sections = logger.ENABLED_SECTIONS
        try:
            yield
        finally:
            cls.stop()
            logger.ENABLED_SECTIONS = enabled_sections
            cls.clear_history()

    @classmethod
    def stop(cls):
        logger.client = None

    @classmethod
    def set_section(cls, section: str | list) -> None:
        """
        Sets the sections of the logger.

        :param section: Section of the logger to render (default: all)
        """
        if not section:
            return
        if isinstance(section, str):
            section = [section]
        for s in section:
            assert s in cls.ENABLED_SECTIONS, f"Section {s} not in {list(cls.ENABLED_SECTIONS.keys())}"
        for k, v in cls.ENABLED_SECTIONS.items():
            cls.ENABLED_SECTIONS[k] = k in section

    @classmethod
    def clear_history(cls) -> None:
        logger.history = []

    @classmethod
    def dump_history(cls, path: Path | str = None, mode='a', clear=False) -> None:
        """
        Dump log history to a text file.

        :param path: Path to the text file (default: None)
        :param mode: How to handle if the file exists (default: 'a')
        :param clear: Whether to clear the history after dumping (default: False)
        """
        if cls.client is None:
            return
        text = '\n'.join(logger.history) + '\n'
        with open(path, mode=mode) as f:
            f.write(text)
        if clear:
            cls.clear_history()

    @classmethod
    def log(cls, msg, level=logging.INFO, **kwargs):
        if (
            cls.client is not None
            and (cls.ENABLED_SECTIONS[cls.section] or level > logging.INFO)
            and cls.client.isEnabledFor(level)
        ):
            cls.client.log(msg=msg, level=level, stacklevel=3, **kwargs)
            logger.history.append(str(msg))

    @classmethod
    def debug(cls, msg, **kwargs):
        cls.log(msg=msg, level=logging.DEBUG, **kwargs)

    @classmethod
    def info(cls, msg, **kwargs):
        cls.log(msg=msg, **kwargs)

    @classmethod
    def warn(cls, msg, **kwargs):
        cls.log(msg=msg, level=logging.WARNING, **kwargs)

    @classmethod
    def error(cls, msg, **kwargs):
        cls.log(msg=msg, level=logging.ERROR, **kwargs)

    @classmethod
    def critical(cls, msg, **kwargs):
        cls.log(msg=msg, level=logging.CRITICAL, **kwargs)

    @classmethod
    @contextmanager
    def context_info(cls, msg: str):
        """
        Log start and end of the block
        """
        cls.info(msg)
        yield
        cls.info(f'... {msg} done')


class game_logger(logger):  # noqa
    section = 'game'


class monte_carlo_logger(logger):  # noqa
    section = 'monte_carlo'


class alpha_beta_logger(logger):  # noqa
    section = 'alpha_beta'


class training_logger(logger):  # noqa
    section = 'training'


class benchmark_logger(logger):  # noqa
    section = 'benchmark'
