#include <R.h>
#include <Rmath.h>

void peak_pick(double* y, int* length, double* signals, double* threshold,
                double* influence, double* filteredY, double* avgFilter,
                  double* stdFilter, int* lag) {

  unsigned int i = 0;
  unsigned int j = 0;
  double sumAvg = 0;
  double sumStd = 0;
  double mean = 0;
  double std = 0;

  // for (i = 0; i < *length; i++) {
  //   Rprintf("avgFilter: %f\n", avgFilter[i]);
  // }

  // Loops through the time series data starting one spot ahead of the lag value
  for (i = (*lag + 1); i < *length; i++) {
    // Determines if the time series data is above the threshold and is a peak value
    if (fabs(y[i] - avgFilter[i-1]) > (*threshold * stdFilter[i-1])) {
      if (y[i] > avgFilter[i-1]) {
        signals[i] = 1;
      } else {
        signals[i] = - 1;
      }
      filteredY[i] = *influence * y[i] + (1 - *influence) * filteredY[i-1];
    } else {
        signals[i] = 0;
        filteredY[i] = y[i];
      }

    // Calculates new mean of point
    for (j = (i - *lag); j < i; j++) {
      sumAvg += filteredY[j];
    }

    mean = sumAvg / *lag;

    //Calculates new Standard Deviation of point
    for(j = (i - *lag); j < i; j++) {
      sumStd += (filteredY[j] - mean);
    }

    std = sqrt(fabs(sumStd / *lag));

    avgFilter[i] = mean;
    stdFilter[i] = std;

    sumAvg = 0;
    sumStd = 0;
  }

}


///////////////////////
// CODE TO TURN INTO C
///////////////////////
// ThresholdingAlgo <- function(y,lag,threshold,influence) {
//   signals <- rep(0,length(y))
//   filteredY <- y[0:lag]
//   avgFilter <- NULL
//   stdFilter <- NULL
//   avgFilter[lag] <- mean(y[0:lag])
//   stdFilter[lag] <- sd(y[0:lag])
//   for (i in (lag+1):length(y)){
//     if (abs(y[i]-avgFilter[i-1]) > threshold*stdFilter[i-1]) {
//       if (y[i] > avgFilter[i-1]) {
//         signals[i] <- 1;
//       } else {
//         signals[i] <- -1;
//       }
//       filteredY[i] <- influence*y[i]+(1-influence)*filteredY[i-1]
//     } else {
//       signals[i] <- 0
//       filteredY[i] <- y[i]
//     }
//     avgFilter[i] <- mean(filteredY[(i-lag):i])
//     stdFilter[i] <- sd(filteredY[(i-lag):i])
//   }
//   return(list("signals"=signals,"avgFilter"=avgFilter,"stdFilter"=stdFilter))
// }
