import tempfile
from unittest import TestCase

from gcaa.tools.logs import logger, gcaa_logger


class Test(TestCase):
    def setUp(self):
        ...

    def test(self):
        logger.setup(loglevel='DEBUG', section=['gcaa', 'main'])
        logger.debug('test')
        logger.info('test')
        gcaa_logger.warn('test')
        gcaa_logger.error('test')
        gcaa_logger.critical('test')
        with tempfile.NamedTemporaryFile(delete=False) as tmp:
            logger.dump_history(tmp.name, clear=True)
        logger.clear_history()
        logger.setup(loglevel='DEBUG', section='gcaa')

        with logger.context_info('hello'):
            logger.info('test context info')

        with logger.setup_in_context():
            logger.info('test context setup_in_context')
