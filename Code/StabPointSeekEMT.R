## 2022.9.15 Process steady-state results from example0915
## 2022.9.16 Do not apply unique; output results directly
## 2022.9.16 Comment out the first three parts, run only 10^3/4, and check the results
## 2022.10.3 Analyze KO or OE results
## 2022.10.5 Run KO results to obtain a 1D curve
## 2022.10.5 Run the result for one gene held OFF
## 2022.10.22 Copy from StabPointSeek.R and test how EMT_ACIPE results look
## 2022.12.10 See the EMT probability when each node OE, stable perburtation
              # compute the Freq of Ecadhin node's -1 (M state)
## 2026.04.20 Clean the code - '/home/lingyu/ssd/R/Landscape/R'


# EMT_RACIP  10^6 ----------------------------------------------------------
rm(list = ls())

# setwd("D:/E/PhD/Python/bmodel/Result")
# setwd("/home/lly/Python/bmodel/Result/ResultEMT2")
setwd("/home/lingyu/ssd/Python/Bmodel/ALLIES/Data/Bmodel/Result/")

## parameter
num = 106
# num = 10000

## steady states
stabponit <- read.csv(paste("stabpointEMT_", num, ".csv", sep=""), header=TRUE, sep = ',')[,-1]

## energy
stabenergy <- as.data.frame(read.csv(paste("stabenergyEMT_", num, ".csv", sep=""), header=TRUE, sep = ',')[,-1])

## point and energy
potengy <- cbind(stabponit, as.matrix(stabenergy))
colnames(potengy) <- c(colnames(stabponit), "Energy")
write.csv(potengy, paste("stabEMT_", num, ".csv", sep=""), row.names = F)

which(colnames(potengy) == "Ecadherin")     # In column 12
which(colnames(potengy) == "SNAI1")     # In column 5
## SNAI1 -1  E    
## SNAI1 +1  M



# 2022.10.5 Handling steady state and energy after perturbation. examplePertur_106_1.py neg keeps OFF ------------------------------------
rm(list = ls())

# setwd("D:/E/PhD/Python/bmodel/ResultPertur")
# setwd("/home/lly/Python/bmodel/ResultPertur")
setwd("/Users/lilingyu/E/PhD/Python/bmodel/ResultEMTPertur")

## parameter
# per = "pos"
per = "neg"
num = "1000000"

## steady states
stabponit <- read.csv(paste("sspointEMT", per, num, ".csv", sep=""), header=TRUE, sep = ',')[,-1]
which(colnames(stabponit) == "SNAI1")

## energy
stabenergy <- as.data.frame(read.csv(paste("energyEMT", per, num,".csv", sep=""), header=TRUE, sep = ',')[,-1])
# View(stabenergy[1:10,])

## point and energy
potengy <- cbind(stabponit, as.matrix(stabenergy))
colnames(potengy) <- c(colnames(stabponit), "Energy")
write.csv(potengy, paste("perturEMT", per, num, ".csv", sep=""), row.names = F)



##############################################################################
# 2023.1.10 Compute the EMT transition probability  SNAI1 OE --------------------
## When SNAI1 OE, statistic the Freq where Ecadherin is not OE (-1), 
## it means the estimated EMT probability via SNAI1 over-expression.


lab <- "Ecadherin"
colnames(stabponit)
k <- which(colnames(stabponit) == lab)
sum(stabponit[, k] == -1)/nrow(stabponit)



##############################################################################
# 2023.1.10 Compute the EMT transition probability Each node OE ----------------
## When Each node OE, statistic the Freq where Ecadherin is not OE (-1), 
## it means the estimated EMT probability via Each node over-expression.



rm(list = ls())

setwd('/home/lly/Python/bmodel/Data/EMTPerturData/sspoint')
stabponit = read.csv(file = "OEstable/sspointEMTpos100000.csv", header = T, sep = ",")



setwd('/home/lly/Python/bmodel/Data/EMTPerturData/sspoint')
myfile = list.files("OEstable")                # list.files reads all file names in the input folder
dir = paste("./OEstable/", myfile, sep = "")     # use paste to build the path variable dir
n = length(dir)                                  # length of dir, i.e., number of files in the folder



library(stringr)
prob <- c()
node <- c()
lab <- "Ecadherin"

for (i in 1:n) {
  # i <- 70
  stabponit = read.csv(file = dir[i], header = T, sep = ",")[,-1]
  prob <- rbind(prob, sum(stabponit[, which(colnames(stabponit) == lab)] == -1)/nrow(stabponit))
  
  name <- dir[i]
  name1 <- str_split_fixed(name, "EMT", 2)
  name2 <- str_split_fixed(name1[2], "10000", 2)
  name3 <- str_split_fixed(name2[2], "[.]", 2)
  name4 <- as.numeric(name3[1])
  # name5 <- str_c("Feature13_", name4)
  node <- c(node, colnames(stabponit)[i])
  
}  

pro <- cbind(node, prob)
colnames(pro) <- c("Node", "Probability")
pro <- as.data.frame(pro)
pro$Probability <- apply(as.matrix(pro[,2]), 2, as.numeric)
pro[1,2]

## save
# write.csv(pro, "EMTprob.csv", row.names = F)

## descending order
prob1 <- pro[order(pro[,2]), ]
# rownames(prob1) <- pro[,1]
prob2 <- prob1[,-1]
rownames(prob2) <- prob1[,1]

prob2[1,1]
## dot 
dotchart(prob2)

# pdf("EMTprob.pdf", width = 4, height = 12)
# dotchart(prob2)
# dev.off()


##############################################################################
# 2023.1.10 nodes activity #####################################################
## see 75 nodes 's activity, compute the probility

ave <- c()
for (k in 1:ncol(stabponit)) {
  ave <- cbind(ave, sum(stabponit[,k] == 1)/nrow(stabponit))
}
colnames(ave) <- colnames(stabponit)
ave <- as.numeric(ave)
View(t(ave))
## line
plot(ave, type = 'o', col = 'blue', xlab = "Node", ylab = "Probability")
half <- as.numeric(rep(0.5, ncol(stabponit)))
lines(half, col = "red")
## dot 
dotchart(ave)
p <- dotchart(ave)

# png("ave.png", width = 400, height = 1200)
# dotchart(ave)
# dev.off()

# pdf("ave.pdf", width = 5, height = 18)
# dotchart(ave)
# dev.off()


##############################################################################
# 2023.1.10 energy probability ################################################
## see all steady state 's energy, compute the probability

aa <- as.data.frame(table(stabenergy))
colnames(aa) <- c("Energy", "Freq")
aa$Freq <- as.numeric(aa[,2])/nrow(stabenergy)
aa[1,1]
aa[1,2]

## line
plot(aa, type = 'o', col = 'blue', xlab = "Energy", ylab = "Probability")


##############################################################################
# 2023.1.10 probability distribution ##########################################
## see all steady state 's probability distribution, using f1 and f2
# alpha <- 1.82; 

function1 <- function(x, alpha, lanmbda, a, mu){
  alpha <- 2; lambda = 10^3.19; s = 2.02; mu = -0.06
  # x <- -168
  f1 <- exp(-(x/lambda)^2)/(x^alpha)
  return(f1)
}

function2 <- function(x, alpha, lanmbda, a, mu){
  alpha <- 2; lambda = 10^3.19; s = 2.02; mu = -0.06
  # x <- 168
  f2 <- (1/x)*exp(-(1/2)*((log(x)-mu)/s)^2)
  return(f2)
}


xx <- apply(as.matrix(aa[,1]), 2, as.numeric)

## For f1 + and - are the same, For f2 it should be -
f1 <- function1(-xx)*10^3
f2 <- function2(-xx)*10^2

aa1 <- cbind(xx, f1)
aa2 <- cbind(xx, f2)
## line

plot(aa1, type = 'o', col = 'blue', xlab = "Energy", ylab = "Probability")
plot(aa2, type = 'o', col = 'red', xlab = "Energy", ylab = "Probability")




##############################################################################
# 2023.1.10 Cycle four files ####################################################
# 2023.1.10 Compute the EMT transition probability Each node OE ----------------
## When Each node OE, statistic the Freq where Ecadherin is not OE (-1), 
## it means the estimated EMT probability via Each node over-expression.
## 2023.1.10 Cycle four files "OEstable", "OEtransient", "KDstable", "KDtransient"


rm(list = ls())

## see the example
setwd('/home/lly/Python/bmodel/Data/EMTPerturData/sspoint')
stabponit = read.csv(file = "OEstable/sspointEMTpos100000.csv", header = T, sep = ",")

## define the file selecton
filename <- c("OEstable", "OEtransient", "KDstable", "KDtransient")

## difine the fix case file

for (l in 1:4) {
  # l = 1
  
  ## load data
  setwd('/home/lly/Python/bmodel/Data/EMTPerturData/sspoint')
  myfile = list.files(filename[l])                # list.files reads all file names in the input folder
  dir = paste("./",filename[l] ,"/", myfile, sep = "")     # use paste to build the path variable dir
  n = length(dir)                                  # length of dir, i.e., number of files in the folder
  
  
  
  library(stringr)
  prob <- c()
  node <- c()
  lab <- "Ecadherin"
  
  for (i in 1:n) {
    # i <- 7
    stabponit = read.csv(file = dir[i], header = T, sep = ",")[,-1]
    
    if (l == 1|l == 2){
      ## EMT, others +1, see E-cadherin is -1 (M) Freq 
      prob <- rbind(prob, sum(stabponit[, which(colnames(stabponit) == lab)] == -1)/nrow(stabponit))
    }else{
      ## MET, others -1, see E-cadherin is +1 (E) Freq 
      prob <- rbind(prob, sum(stabponit[, which(colnames(stabponit) == lab)] == 1)/nrow(stabponit))
    }
    
    name <- dir[i]
    name1 <- str_split_fixed(name, "EMT", 2)
    name2 <- str_split_fixed(name1[2], "10000", 2)
    name3 <- str_split_fixed(name2[2], "[.]", 2)
    name4 <- as.numeric(name3[1])
    # name5 <- str_c("Feature13_", name4)
    node <- c(node, colnames(stabponit)[i])
    
  }  
  
  pro <- cbind(node, prob)
  colnames(pro) <- c("Node", "Probability")
  pro <- as.data.frame(pro)
  pro$Probability <- apply(as.matrix(pro[,2]), 2, as.numeric)
  pro[1,2]
  
  ## save
  write.csv(pro, paste("EMTprob",filename[l],".csv", sep = ""), row.names = F)
  
  ## descending order
  prob1 <- pro[order(pro[,2]), ]
  # rownames(prob1) <- pro[,1]
  prob2 <- prob1[,-1]
  rownames(prob2) <- prob1[,1]
  
  prob2[1,1]
  ## dot 
  dotchart(prob2)
  
  ## plot and save
  pdf(paste("EMTprob",filename[l],".pdf", sep = ""), width = 4, height = 12)
  dotchart(prob2)
  dev.off()
  
  print(l)
  
}


##############################################################################
## 2023.1.20 Four files merge to one ###########################################


rm(list = ls())

## see the example
setwd('/home/lly/Python/bmodel/Data/EMTPerturData/sspoint')
prob1 = read.csv(file = "EMTprobOEstable.csv", header = T, sep = ",")

## define the file selecton
filename <- c("OEstable", "OEtransient", "KDstable", "KDtransient")

## difine the fix case file

Prob <- prob1
for (l in 2:4) {
  # l = 1
  prob <- read.csv(paste("EMTprob",filename[l],".csv", sep = ""), header = T, sep = ",")[,2]
  Prob <- cbind(Prob, prob)
}

rownames(Prob) <- prob1[,1]
Prob <- Prob[,-1]
colnames(Prob) <- c("OEstable", "OEtransient", "KDstable", "KDtransient")
Prob[1,3]


data <- Prob
data$time = row.names(data)
mydata = melt(data, id = "time")
colnames(mydata)


# install.packages('ggprism')
library(ggprism)
## plot zhexian figure https://zhuanlan.zhihu.com/p/479361842
p = ggplot(data = mydata, 
           aes(x = time, 
               y = value, group = variable,
               color = variable,
               shape = variable))+
  geom_point()+
  geom_line()+
  xlab("Node")+
  ylab("Probability")+
  theme_bw()+
  theme_test(base_size = 12) +
  theme(panel.grid.major = element_line(colour = NA),
        panel.background = element_rect(fill = "transparent", colour = NA),
        plot.background = element_rect(fill = "transparent", colour = NA),
        panel.grid.minor =  element_blank(),    # the code above removes grid lines while keeping axis borders
        # text = element_text(family = "Tu'er"),  # set display of Chinese font
        legend.position = "top",    # change legend position to the upper-left inside the plot # c(.060, .655), 
        legend.box.background = element_rect(color = NA),
        panel.border = element_rect(size=2,fill = 'transparent'),
        axis.text = element_text(color='black'),
        axis.text.x = element_text(color='black', angle = 45, hjust = 0.5, vjust = 0.5)
        )   # add a border line for the legend

p


## save figure
ggsave(p, filename = 'Prob.pdf', width = 15, height = 5, device = cairo_pdf)
