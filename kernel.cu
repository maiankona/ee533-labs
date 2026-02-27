#include <cuda_bf16.h>
#include <stdlib.h>
#include <stdio.h>
#include <cublas.h>
#include <time.h>
#include <stdint.h>

// only using 1 thread so how to handle thread IDx?
// Vector Add 
__global__ void vector_add(int16_t *a, int16_t *b, int16_t *c){
	int16_t idx = threadIdx.x;
	c[idx] = a[idx] + b[idx];  
}

// Vector Sub
__global__ void vector_sub(int16_t *a, int16_t *b, int16_t *c){
	int16_t idx = threadIdx.x;
	c[idx] = a[idx] - b[idx];  
}

// Bfloat 16 Multiply
__global__ void bf16_vector_mul(__nv_bfloat16 *a, __nv_bfloat16 *b, __nv_bfloat16 *c)
{
  int16_t idx = threadIdx.x;
  c[idx] = __hmul(a[idx], b[idx]);
}

// Bfloat 16 MAC
__global__ void bf16_fma(__nv_bfloat16 *a, __nv_bfloat16 *b, __nv_bfloat16 *c, __nv_bfloat16 *d)
{
  int16_t idx = threadIdx.x;
  d[idx] = __hfma(a[idx], b[idx], c[idx]);
}


// ReLU
__global__ void ReLU(int16_t *a, int16_t *out)
{
  int16_t idx = threadIdx.x;
  out[idx] = max(0, a[idx]);
}
