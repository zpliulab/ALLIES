## 2022.10.2 Perturb EMT
## 2022.10.3 Run the EMT perturbation program and analyze the results
## 2022.10.6 Based on the local examplePerturtTest, modify the code to obtain perturbation results from many random initial states
## 2026.04.20 Clean the code - '/home/lingyu/ssd/Python/Bmodel/Code'

import os
#os.chdir('D:\E\博士\Python\Bmodel')
# os.chdir('/home/lly/Python/bmodel')
# os.chdir('/Users/lilingyu/E/PhD/Python/bmodel')
os.chdir('/home/lingyu/ssd/Python/Bmodel/ALLIES/Data/Bmodel/')


import pandas as pd   
import numpy as np
from bmodel.base import Bmodel
from pandas import DataFrame


## parameter setting
step = 10**6
# step = 10

import time
time_start = time.time()  # record CPU start time

## load the EMT-MET pathway from (Font-Clos et al, 2018)   
bmodel = Bmodel.from_library("EMT_MET")
#bmodel.runs(n_runs = step, fast=False)
#bmodel.steady_states
#bmodel.energies

## Use the modified function perturbelly to perturb SNAI1    --    default is n_runs = 100
## switch and Keep    ---- All 1 in steady state
bmodel.perturbelly(label="SNAI1 OFF hold True",
                node_to_switch="SNAI1",
                switch_to="OFF",
                hold=True,    ## True   problem   base.py Line 224
                allow_non_steady_state=True,
                n_runs=step)

## output
#bmodel._perturbations_ic
#bmodel._perturbations_ss
#bmodel._perturbations_meta

## energy
J = bmodel.J
#J.shape    ## (72, 72)
s = np.array(bmodel._perturbations_ss)
## Cannot multiply matrices directly, need to multiply one sample at a time
#H = -1*s@(J@s)    

s0 = np.array(bmodel._perturbations_ss)[0,:]
e = -1*s0@(J@s0)
H = [e]

#for x in range(step):    ## range(0, 10)
for x in range(1,step):    ## range(1, 10)
    ## cycle
    e = -1*s[x,]@(J@s[x,])
    H.append(e)     # H is a list   need to press enter when running line by line, otherwise it will be...


np.array(bmodel._perturbations_ss)[:,53]
#aa = np.array(bmodel._perturbations_ic)
#aa[:,53]

## save
icpoint = DataFrame(bmodel._perturbations_ic)
icpoint.to_csv("ResultEMTPertur/icpointEMTneg"+ str(step)+".csv", sep=",")

sspoint = DataFrame(bmodel._perturbations_ss)
sspoint.to_csv("ResultEMTPertur/sspointEMTneg"+ str(step)+".csv", sep=",")

metapoint = DataFrame(bmodel._perturbations_meta)
metapoint.to_csv("ResultEMTPertur/metapointEMTneg"+ str(step)+".csv", sep=",")

energy = DataFrame(H)
energy.to_csv("ResultEMTPertur/energyEMTneg"+ str(step)+".csv", sep=",")

time_end = time.time()  # record CPU end time
time_sum = time_end - time_start  # elapsed execution time in seconds
print(time_sum)
