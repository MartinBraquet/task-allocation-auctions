import os
import time
from datetime import datetime

FILE_DATE_FMT = "%Y%m%d_%H%M%S"
READABLE_DATE_FMT = '%Y-%m-%d %H:%M:%S'


def get_now(human_readable=True, fmt=FILE_DATE_FMT):
    now = datetime.now()
    if human_readable:
        now = now.strftime(fmt)
    return now


def get_file_modified_time(filepath, fmt=READABLE_DATE_FMT):
    return time.strftime(
        fmt,
        time.localtime(os.path.getmtime(filepath))
    )
