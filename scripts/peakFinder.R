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



