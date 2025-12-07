from unittest import TestCase

from gcaa.core.dta import optimal_control_dta


class TestDTA(TestCase):
    def setup(self):
        ...

    def test(self):
        results = optimal_control_dta(
            n_rounds=20,
        )
        print(results)
