#!/bin/bash

conda create -n test python=3.12 pip -y
conda activate test
pip install gcaa
python -c "import gcaa; gcaa.optimal_control_dta()"
echo "Installation from Pypi ran a test successfully"