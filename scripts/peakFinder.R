# install.packages("pracma")
# install.packages("signal")
library(pracma)
library(signal)

# Example of findpeaks
x <- seq(0, 1, len = 1024)
pos <- c(0.1, 0.13, 0.15, 0.23, 0.25, 0.40, 0.44, 0.65, 0.76, 0.78, 0.81)
hgt <- c(4, 5, 3, 4, 5, 4.2, 2.1, 4.3, 3.1, 5.1, 4.2)
wdt <- c(0.005, 0.005, 0.006, 0.01, 0.01, 0.03, 0.01, 0.01, 0.005, 0.008, 0.005)

pSignal <- numeric(length(x))
for (i in seq(along=pos)) {
  pSignal <- pSignal + hgt[i]/(1 + abs((x - pos[i])/wdt[i]))^4
}

plot(pSignal, type="l", col="navy")
grid()
x <- findpeaks(pSignal, sortstr=TRUE)
points(x[, 2], x[, 1], pch=20, col="maroon")


####
####
####
####

x <- sin(2*pi*t*2.3) + 0.25*rnorm(length(t)) # 2.3 Hz sinusoid+noise
z <- fftfilt(.6, dataList_2017) # apply 10-point averaging filter
plot(z, type = "l")
lines(z, col = "red")


##############################
# ----- C Code -----
##############################

# Example C stuff to practice
dyn.load("cuda/doubler.dll")
x = c(4:5)
.C("double_me", length(x), as.integer(x), integer(length(x)), NAOK=TRUE)

# C code:
y <- dataPass


# Data
y <- c(1,1,1.1,1,0.9,1,1,1.1,1,0.9,1,1.1,1,1,0.9,1,1,1.1,1,1,1,1,1.1,0.9,1,1.1,1,1,0.9,
       1,1.1,1,1,1.1,1,0.8,0.9,1,1.2,0.9,1,1,1.1,1.2,1,1.5,1,3,2,5,3,2,1,1,1,0.9,1,1,3,
       2.6,4,3,3.2,2,1,1,0.8,4,4,2,2.5,1,1,1)

lag       <- 30
threshold <- 5
influence <- 0

signals <- rep(0,length(y))
filteredY <- y[0:lag]
avgFilter <- rep(NULL,length(y))
stdFilter <- rep(NULL,length(y))
avgFilter[lag] <- mean(y[0:lag])
stdFilter[lag] <- sd(y[0:lag])
# lag       <- 200
# threshold <- 3.5
# influence <- 0.001

dyn.load("cuda/peakPick.dll")
.C("peak_pick", y=as.integer(y), length=as.integer(length(y)), signals=as.integer(signals),threshold=as.double(threshold), influence=as.double(influence), filteredY=as.integer(filteredY), avgFilter=as.double(avgFilter),stdFilter=as.double(stdFilter), lag=as.integer(lag))


##############################
# ----- Wappingers Data -----
##############################
# install.packages("readxl")
# install.packages("tidyverse")
library(readxl)
library(tidyverse)

data_2017 = read_excel(path="data/2017Data.xlsx")
dataList_2017 = unlist(data_2017$`Discharge (ft^3/s)`)
dataPass = (dataList_2017)

plot(dataList_2017, type="l", col="navy")
grid()
start_time <- Sys.time()
for(i in 1:29){
x <- findpeaks(dataList_2017, sortstr=TRUE,npeaks=3)
}
end_time <- Sys.time()
points(x[, 2], x[, 1], pch=20, col="maroon")
end_time - start_time


##############################
# ----- Stack Overflow Stuff -
##############################
ThresholdingAlgo <- function(y,lag,threshold,influence) {
  signals <- rep(0,length(y))
  filteredY <- y[0:lag]
  avgFilter <- NULL
  stdFilter <- NULL
  avgFilter[lag] <- mean(y[0:lag])
  stdFilter[lag] <- sd(y[0:lag])
  for (i in (lag+1):length(y)){
    if (abs(y[i]-avgFilter[i-1]) > threshold*stdFilter[i-1]) {
      if (y[i] > avgFilter[i-1]) {
        signals[i] <- 1;
      } else {
        signals[i] <- -1;
      }
      filteredY[i] <- influence*y[i]+(1-influence)*filteredY[i-1]
    } else {
      signals[i] <- 0
      filteredY[i] <- y[i]
    }
    avgFilter[i] <- mean(filteredY[(i-lag):i])
    stdFilter[i] <- sd(filteredY[(i-lag):i])
  }
  return(list("signals"=signals,"avgFilter"=avgFilter,"stdFilter"=stdFilter))
}

y <- dataPass

lag       <- 200
threshold <- 3.5
influence <- 0.001

# Run algo with lag = 30, threshold = 5, influence = 0
result <- ThresholdingAlgo(y,lag,threshold,influence)

# Plot result
par(mfrow = c(2,1),oma = c(2,2,0,0) + 0.1,mar = c(0,0,2,1) + 0.2)
plot(1:length(y),y,type="l",ylab="",xlab="") 
lines(1:length(y),result$avgFilter,type="l",col="cyan",lwd=2)
lines(1:length(y),result$avgFilter+threshold*result$stdFilter,type="l",col="green",lwd=2)
lines(1:length(y),result$avgFilter-threshold*result$stdFilter,type="l",col="green",lwd=2)
plot(result$signals,type="S",col="red",ylab="",xlab="",ylim=c(-1.5,1.5),lwd=2)

