#include <stdio.h>
#include <stdlib.h>
#include <R.h>

__global__ void add(float *a, float *b, float *c){
  *c = *b + *a;
}

extern "C" void gpuadd(float *a, float *b, float *c){
  float *da, *db, *dc;

  cudaMalloc( (void**)&da, sizeof(float) );
  cudaMalloc( (void**)&db, sizeof(float) );
  cudaMalloc( (void**)&dc, sizeof(float) );

  cudaMemcpy( da, a, sizeof(float), cudaMemcpyHostToDevice);
  cudaMemcpy( db, b, sizeof(float), cudaMemcpyHostToDevice);

  add<<<1,1>>>(da, db, dc);

  cudaMemcpy(c, dc, sizeof(float), cudaMemcpyDeviceToHost);

  cudaFree(da);
  cudaFree(db);
  cudaFree(dc);

  Rprintf("%.0f + %.0f = %.0f\n", *a, *b, *c);
}
