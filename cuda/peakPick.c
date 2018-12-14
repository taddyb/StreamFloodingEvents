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

  // Loops through the time series data starting one spot ahead of the lag value
  for (i = *lag; i < *length; i++) {
    // Determines if the time series data is above the threshold and is a peak value
    if (fabs(y[i] - avgFilter[i-1]) > (*threshold * stdFilter[i-1])) {
      if (y[i] > avgFilter[i-1]) {
        signals[i] = 1;
      } else {
        signals[i] = - 1;
      }

      filteredY[i] = (*influence) * (y[i]) + (1 - *influence) * filteredY[i-1];
    } else {
        signals[i] = 0;
        filteredY[i] = y[i];
      }

    // Calculates new mean of point
    for (j = i - *lag; j <= i; j++) {
      sumAvg += filteredY[j];
    }

    // Adds 1 to the original length to get the true lag
    mean = sumAvg / (*lag + 1);

    //Calculates new Standard Deviation of point
    for(j = i - *lag; j <= i; j++) {
      sumStd += ((filteredY[j] - mean) * (filteredY[j] - mean));
    }

    //  Adds 1 to the original length to get the true lag
    std = sqrt(sumStd / (*lag - 1));

    avgFilter[i] = mean;
    stdFilter[i] = std;

    sumAvg = 0;
    sumStd = 0;
  }

}
