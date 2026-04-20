## 2022.9.15 Process steady-state results from example0915
## 2022.9.16 Do not apply unique; output results directly
## 2022.9.16 Comment out the first three parts, run only 10^3/4, and check the results
## 2022.10.3 Analyze KO or OE results
## 2022.10.5 Run KO results to obtain a 1D curve
## 2022.10.5 Run the result for one gene held OFF
## 2022.10.21 Based on StabPointSeek.R, obtain melanoma results
## 2022.12.5 copy from StabPointSeekMelanoma.R, and test SERGIO Pertur results
## 2022.12.6 add the steay-state random result 
## 2026.04.20 Clean the code


# ResultSERGIO with Random initial value 10^4/5/6 ----------------------------------------------------------
rm(list = ls())

# setwd("/Users/lilingyu/E/PhD/R/Landscape/Data/SERGIOdata/ResultSERGIORandom")
setwd("/home/lingyu/ssd/Python/Bmodel/ALLIES/Data/R/Landscape/Data/SERGIOdata/ResultSERGIORandom")

## parameter
# num = 106
num = 10000

## steady states
stabponit <- read.csv(paste("stabpointSERGIORandom", num, ".csv", sep=""), header=TRUE, sep = ',')[,-1]


########################################################################################################
## repeat colums
stabponitT <- t(t(stabponit)[!duplicated(t(stabponit)),])
dim(stabponitT)    # 9886   33 
# write.csv(stabponitT, paste("stabSERGIORandomT", num, ".csv", sep=""), row.names = F)

which(!duplicated(t(stabponit)) == "TRUE")
length(which(!duplicated(t(stabponit)) == "TRUE"))

## repeat rows
stabponitT0 <- stabponitT
stabponitT0 <- stabponitT0[!duplicated(stabponitT0),]
dim(stabponitT0)    ## 5354   33
# write.csv(stabponitT0, paste("stabSERGIORandomT0", num, ".csv", sep=""), row.names = F)
########################################################################################################

## energy
stabenergy <- as.data.frame(read.csv(paste("stabenergySERGIORandom", num, ".csv", sep=""), header=TRUE, sep = ',')[,-1])

## point and energy
potengy <- cbind(stabponit, as.matrix(stabenergy))
colnames(potengy) <- c(colnames(stabponit), "Energy")
dim(potengy)    ## 9886  101
# write.csv(potengy, paste("stabSERGIORandom", num, ".csv", sep=""), row.names = F)

## only delete repeated rows and save
potengydup <- potengy[!duplicated(potengy),]
# write.csv(potengydup, paste("stabSERGIORandom", num, ".csv", sep=""), row.names = F)

which(colnames(potengy) == "MITF")    # In column 8
