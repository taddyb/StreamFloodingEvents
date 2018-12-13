#include <R.h>

void peakPick(int* lag, int* y){
  for(int i = *(lag+ 1); i < 2; i++){
      y[i] = 2;
  }
}

// for (i in (lag+1):length(y)){
//   if (abs(y[i]-avgFilter[i-1]) > threshold*stdFilter[i-1]) {
//     if (y[i] > avgFilter[i-1]) {
//       signals[i] <- 1;
//     } else {
//       signals[i] <- -1;
//     }
//     filteredY[i] <- influence*y[i]+(1-influence)*filteredY[i-1]
//   } else {
//     signals[i] <- 0
//     filteredY[i] <- y[i]
//   }
//   avgFilter[i] <- mean(filteredY[(i-lag):i])
//   stdFilter[i] <- sd(filteredY[(i-lag):i])
// }
// return(list("signals"=signals,"avgFilter"=avgFilter,"stdFilter"=stdFilter))
// }
