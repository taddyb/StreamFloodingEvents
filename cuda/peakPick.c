#include <R.h>
#include <Rmath.h>

void peak_pick(int *y, int* length, int* signals, double* threshold,
                double* influence, int* filteredY, double* avgFilter,
                  double* stdFilter, int* lag) {
  int i, j, k;
  int sumAvg = 0;
  int sumStd = 0;
  int mean = 0;
  int std = 0;

  Rprintf("%f\n",avgFilter[50]);

  for (i = *(lag + 1); i < *length; i++) {
    if (abs(y[i] - avgFilter[i-1]) > (*threshold * stdFilter[i-1])) {
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

    for (j = (i - *lag); j < i; j++) {
      sumAvg = sumAvg + filteredY[j];
    }

    mean = sumAvg / *lag;

    for(k = (i - *lag); k < i; k++) {
      sumStd = sumStd + (filteredY[k] - mean);
    }

    std = sqrt(sumStd / *lag);

    avgFilter[i] = mean;
    stdFilter[i] = std;
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
