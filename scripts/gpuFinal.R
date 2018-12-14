######################
# GPU FINAL
# Author: Tadd Bindas 
# inspiration from:
# https://stackoverflow.com/questions/22583391/peak-signal-detection-in-realtime-timeseries-data
######################


###############
# C - Interface
###############


#######
# Test Data
#######
y <- c(1,1,1.1,1,0.9,1,1,1.1,1,0.9,1,1.1,1,1,0.9,1,1,1.1,1,1,1,1,1.1,0.9,1,1.1,1,1,0.9,
       1,1.1,1,1,1.1,1,0.8,0.9,1,1.2,0.9,1,1,1.1,1.2,1,1.5,1,3,2,5,3,2,1,1,1,0.9,1,1,3,
       2.6,4,3,3.2,2,1,1,0.8,4,4,2,2.5,1,1,1)

lag       <- 30
threshold <- 5
influence <- 0

signals <- rep(0,length(y))
filteredY <- rep(0, length(y))
filteredY[0:lag] <- y[0:lag]
avgFilter <- rep(0,length(y))
stdFilter <- rep(0,length(y))
avgFilter[lag] <- mean(y[0:lag])
stdFilter[lag] <- sd(y[0:lag])

# For windows:
# dyn.load("cuda/peakPick.dll")
# For Mac:
dyn.load("cuda/peakPick.so")

cResult = .C("peak_pick", y=as.double(y), length=as.integer(length(y)), 
             signals=as.double(signals),threshold=as.double(threshold), 
             influence=as.double(influence), filteredY=as.double(filteredY),
             avgFilter=as.double(avgFilter),stdFilter=as.double(stdFilter), 
             lag=as.integer(lag))


# Plot result
par(mfrow = c(2,1),oma = c(2,2,0,0) + 0.1,mar = c(0,0,2,1) + 0.2)
plot(1:length(y),y,type="l",ylab="",xlab="") 
lines(1:length(y),cResult$avgFilter,type="l",col="cyan",lwd=2)
lines(1:length(y),cResult$avgFilter+threshold*cResult$stdFilter,type="l",col="green",lwd=2)
lines(1:length(y),cResult$avgFilter-threshold*cResult$stdFilter,type="l",col="green",lwd=2)
plot(cResult$signals,type="S",col="red",ylab="",xlab="",ylim=c(-1.5,1.5),lwd=2)

#######
# Wappingers Data
#######

# If you do not have this package, install here
# install.packages("readxl")
library(readxl)
data_2017 = read_excel(path="data/2017Data.xlsx")
dataList_2017 = unlist(data_2017$`Discharge (ft^3/s)`)

lag       <- 200
threshold <- 3.5
influence <- 0.01

signals <- rep(0,length(dataList_2017))
filteredY <- rep(0, length(dataList_2017))
filteredY[0:lag] <- dataList_2017[0:lag]
avgFilter <- rep(0,length(dataList_2017))
stdFilter <- rep(0,length(dataList_2017))
avgFilter[lag] <- mean(dataList_2017[0:lag])
stdFilter[lag] <- sd(dataList_2017[0:lag])

# For windows:
# dyn.load("cuda/peakPick.dll")
# For Mac:
dyn.load("cuda/peakPick.so")

start_time = Sys.time()
for(i in 1:40){
  cResult = .C("peak_pick", y=as.double(dataList_2017), length=as.integer(length(y)), 
               signals=as.double(signals),threshold=as.double(threshold), 
               influence=as.double(influence), filteredY=as.double(filteredY),
               avgFilter=as.double(avgFilter),stdFilter=as.double(stdFilter), 
               lag=as.integer(lag))
}
end_time = Sys.time()

print("Time elapsed: ")
print(end_time - start_time)

# Plot result
par(mfrow = c(2,1),oma = c(2,2,0,0) + 0.1,mar = c(0,0,2,1) + 0.2)
plot(1:length(dataList_2017),dataList_2017,type="l",ylab="",xlab="") 
lines(1:length(dataList_2017),cResult$avgFilter,type="l",col="cyan",lwd=2)
lines(1:length(dataList_2017y),cResult$avgFilter+threshold*cResult$stdFilter,type="l",col="green",lwd=2)
lines(1:length(dataList_2017),cResult$avgFilter-threshold*cResult$stdFilter,type="l",col="green",lwd=2)
plot(cResult$signals,type="S",col="red",ylab="",xlab="",ylim=c(-1.5,1.5),lwd=2)

###############
# R - Interface
###############


ThresholdingAlgo <- function(y,lag,threshold,influence) {
  sumMeanArray <- rep(as.double(0),length(y))
  sumStdArray <- rep(as.double(0),length(y))
  signals <- rep(as.double(0),length(y))
  filteredY <- rep(as.double(0), length(y))
  filteredY[0:lag] <- y[0:lag]
  avgFilter <- rep(as.double(0),length(y))
  stdFilter <- rep(as.double(0),length(y))
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
    
    sumMeanArray[i] <- sum(filteredY[(i-lag):i])
    sumStdArray[i] <- sum(filteredY[(i-lag):i] - mean(filteredY[(i-lag):i]))
    
    avgFilter[i] <- mean(filteredY[(i-lag):i])
    stdFilter[i] <- sd(filteredY[(i-lag):i])
  }
  return(list("signals"=signals,"avgFilter"=avgFilter,"stdFilter"=stdFilter,
              "sumMeanArray"=sumMeanArray, "sumStdArray"=sumStdArray, 
              "filteredY"=filteredY))
}




lag       <- 200
threshold <- 3.5
influence <- 0.001

start_time = Sys.time()
for(i in 1:40){
  result <- ThresholdingAlgo(dataList_2017,lag,threshold,influence)
}
end_time = Sys.time()

print("Time elapsed: ")
print(end_time - start_time)


# Plot result
par(mfrow = c(2,1),oma = c(2,2,0,0) + 0.1,mar = c(0,0,2,1) + 0.2)
plot(1:length(dataList_2017),dataList_2017,type="l",ylab="",xlab="") 
lines(1:length(dataList_2017),cResult$avgFilter,type="l",col="cyan",lwd=2)
lines(1:length(dataList_2017y),cResult$avgFilter+threshold*cResult$stdFilter,type="l",col="green",lwd=2)
lines(1:length(dataList_2017),cResult$avgFilter-threshold*cResult$stdFilter,type="l",col="green",lwd=2)
plot(result$signals,type="S",col="red",ylab="",xlab="",ylim=c(-1.5,1.5),lwd=2)

