#!/bin/bash

conda create -n test python=3.12 pip -y
conda activate test
pip install torch --index-url https://download.pytorch.org/whl/cpu
pip install gcaa
python -c "from gcaa import GCAA; GCAA().run()"
echo "Installation from Pypi ran a test successfully"