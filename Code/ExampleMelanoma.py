## 2022.9.26 Based on 0916, add code for a custom network
## Resave as the Networkinput file; remove the original content from 0926
## Try adding perturbation
## 2022.10.21 copy from Networkinput.py, use melanoma network, copy from example0916_104.py
## 2026.04.20 Copy from HESC.py, Rename ExampleMelanoma.py, Clean the code - '/home/lingyu/ssd/Python/Bmodel/Code'


import pandas as pd    
import numpy as np
from bmodel.base import Bmodel
from pandas import DataFrame


## load pathway
import os
#os.chdir('D:/E/博士/Python/Bmodel/Data/Network')
#os.chdir('/home/lly/Python/bmodel')
os.chdir('/home/lingyu/ssd/Python/Bmodel/ALLIES/Data/Bmodel/')

## parameter setting
step = 10**4
#step = 10

import time
time_start = time.time()  # record CPU start time

## load from .csv file
bmodel = Bmodel.from_edgelist("Data/Network/melanoma.csv")    # ERROR
bmodel.runs(n_runs = step, fast=False)
## print, the same with no print
print(bmodel.steady_states)
print(bmodel.energies)


## Export all steady-state and energy results
stabpoint = DataFrame(bmodel.steady_states)
stabpoint.to_csv("Result/ResultMelanoma/stabpointMELA_104.csv", sep=",")
stabenergy = DataFrame(bmodel.energies)
stabenergy.to_csv("Result/ResultMelanoma/stabenergyMELA_104.csv", sep=",")

time_end = time.time()  # record CPU end time
time_sum = time_end - time_start  # elapsed execution time in seconds
print(time_sum)
