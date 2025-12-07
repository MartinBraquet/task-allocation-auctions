[![Release](https://img.shields.io/pypi/v/gcaa?label=Release&style=flat-square)](https://pypi.org/project/gcaa/)
[![CI](https://github.com/MartinBraquet/task-allocation-auctions/actions/workflows/ci.yml/badge.svg)](https://github.com/MartinBraquet/task-allocation-auctions/actions/workflows/ci.yml)
[![CD](https://github.com/MartinBraquet/task-allocation-auctions/actions/workflows/cd.yml/badge.svg)](https://github.com/MartinBraquet/task-allocation-auctions/actions/workflows/cd.yml)
[![Coverage](https://codecov.io/gh/MartinBraquet/task-allocation-auctions/branch/master/graph/badge.svg)](https://codecov.io/gh/MartinBraquet/task-allocation-auctions)
[![Downloads](https://static.pepy.tech/badge/gcaa)](https://pepy.tech/project/gcaa) 
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

# Task Allocation using Auctions

Dynamic decentralized task allocation algorithms for multi-agent systems using a greedy auction algorithm. It's available in Matlab and Python.

Official GitHub repository: https://github.com/MartinBraquet/task-allocation-auctions.

Master's research at The University of Texas at Austin in the research group of Efstathios Bakolas.

The paper resulting from these simulations has been published at the Modeling, Estimation, and Control Conference (MECC 2021).

To cite this work: 

> Braquet, M. and Bakolas E., "Greedy Decentralized Auction-based Task Allocation for Multi-Agent Systems", *Modeling, Estimation and Control Conference (MECC)*, 2021.

Official paper link: https://doi.org/10.1016/j.ifacol.2021.11.249.

## Demo

2D map of the dynamic task allocation (10 agents and 10 tasks) with associated reward, cost, and utility

With communication limitation:

![Alt Text](https://martinbraquet.com/wp-content/uploads/Dynamic-Task-Agent-Allocation.gif)

Without communication limitation:

![Alt Text](https://martinbraquet.com/wp-content/uploads/Dynamic-Task-Agent-Allocation-noLimit.gif)

## Matlab

In the [matlab](matlab) folder.

* For the dynamic task allocation, run `OptimalControl_DTA.m`.
* For the sensitivity analysis of the parameters, run `optimalControlParametersAnalysis.m`.

To run the code in Matlab online: https://drive.matlab.com/sharing/f36a058f-99a4-4e38-a08e-0af800bd4ce8.

## Python

In the [gcaa](gcaa) folder.

### Installation

The Python package works on any major OS (Linux, Windows, and macOS) and with Python >= 3.11.

The most straightforward way is to simply install it from PyPI via:
```bash
pip install gcaa
```

If you want to install it from source, which is necessary for development, follow the instructions [here](docs/installation.md).

If some dependencies release changes that break the code, you can install the project from its lock file—which fixes the dependency versions to ensure reproducibility:
```bash
pip install -r requirements.txt
```

### Usage

For the dynamic task allocation, run:
```python
import gcaa
gcaa.optimal_control_dta(
    nt=4, # number of tasks
    na=5, # number of agents
    uniform_agents=False, # whether agents have an initial speed
    n_rounds=100, # number of simulation rounds (precision vs compute time)
    limited_communication=True, # whether communication is limited (True, False, or 'both')
)
```

The sensitivity analysis of the parameters isn't available in Python.

### Tests

```shell
pytest gcaa
```

### Feedback

For any issue / bug report / feature request, open an [issue](https://github.com/MartinBraquet/task-allocation-auctions/issues).

### Contributions

To provide upgrades or fixes, open a [pull request](https://github.com/MartinBraquet/task-allocation-auctions/pulls).