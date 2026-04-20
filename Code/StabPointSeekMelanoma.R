## 2022.9.15 Process steady-state results from example0915
## 2022.9.16 Do not apply unique; output results directly
## 2022.9.16 Comment out the first three parts, run only 10^3/4, and check the results
## 2022.10.3 Analyze KO or OE results
## 2022.10.5 Run KO results to obtain a 1D curve
## 2022.10.5 Run the result for one gene held OFF
## 2022.10.21 Based on StabPointSeek.R, obtain melanoma results
## 2022.12.14 add noise
## 2026.04.20 Follow ExampleNetEMT.py, Clean the code, omit stabpointMELARandom or stabpointMELA


# ResultMelanoma  10^4/5/6 ----------------------------------------------------------
rm(list = ls())

# setwd("D:/E/博士/Python/bmodel/Result/ResultMelanoma")
# setwd("/Users/lilingyu/E/PhD/Python/bmodel/Result/ResultMelanoma")
setwd("/home/lingyu/ssd/Python/Bmodel/ALLIES/Data/Bmodel/Result/ResultMelanoma")


## parameter
num = 104
# num = 10000

## steady states
stabponit <- read.csv(paste("stabpointMELARandom", num, ".csv", sep=""), header=TRUE, sep = ',')[,-1]
stabponitT <- t(t(stabponit)[!duplicated(t(stabponit)),])
dim(stabponitT)
stabponitT <- t(stabponit)[!duplicated(t(stabponit)),]
which(!duplicated(t(stabponit)) == "TRUE")
length(which(!duplicated(t(stabponit)) == "TRUE"))
stabponitT0 <- -stabponitT

## energy
stabenergy <- as.data.frame(read.csv(paste("stabenergyMELA_", num, ".csv", sep=""), header=TRUE, sep = ',')[,-1])

## point and energy
potengy <- cbind(stabponit, as.matrix(stabenergy))
colnames(potengy) <- c(colnames(stabponit), "Energy")
write.csv(potengy, paste("stabMELA_", num, ".csv", sep=""), row.names = F)

which(colnames(potengy) == "MITF")    # In column 8