## 2022.10.22 copy from examplePertur_106_1.py
##            use the neywork EMT-RACIPE net, see the result
## 2026.04.20 Clean the code - '/home/lingyu/ssd/Python/Bmodel/Code'

import os
#os.chdir('D:\E\博士\Python\Bmodel')
# os.chdir('/home/lly/Python/bmodel')
os.chdir('/home/lingyu/ssd/Python/Bmodel/ALLIES/Data/Bmodel/')

import pandas as pd     
import numpy as np
from bmodel.base import Bmodel
from pandas import DataFrame

## parameter setting
step = 10**6

## time cost only CPU  
import time
time_start = time.time()  # record CPU start time

## load the EMT-MET pathway from (Font-Clos et al, 2018)   
bmodel = Bmodel.from_library("EMT_RACIPE")
bmodel.runs(n_runs = step, fast=False)
#bmodel.steady_states
#bmodel.energies

## print, the same with no print
print(bmodel.steady_states)
print(bmodel.energies)

## Export all steady-state and energy results
stabpoint = DataFrame(bmodel.steady_states)
stabpoint.to_csv("Result/stabpointEMT_106.csv", sep=",")
stabenergy = DataFrame(bmodel.energies)
stabenergy.to_csv("Result/stabenergyEMT_106.csv", sep=",")

time_end = time.time()  # record CPU end time
time_sum = time_end - time_start  # elapsed execution time in seconds
print(time_sum)