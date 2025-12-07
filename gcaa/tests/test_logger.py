import tempfile
from unittest import TestCase

from gcaa.tools.logs import logger, gcaa_logger


class Test(TestCase):
    def setUp(self):
        ...

    def test(self):
        logger.setup(loglevel='DEBUG', section=['gcaa', 'main'])
        logger.debug('test')
        logger.log('test')
        gcaa_logger.warn('test')
        gcaa_logger.error('test')
        with tempfile.NamedTemporaryFile(delete=False) as tmp:
            logger.dump_history(tmp.name)
