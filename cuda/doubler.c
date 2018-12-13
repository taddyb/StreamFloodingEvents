#include <R.h>
void double_me(int *nrak, int *ranking, int *rr) {
  for (int i=0; i < *nrak; i++)
      rr[i] = R_NaInt == ranking[i] ? -1 : ranking[i];
}
