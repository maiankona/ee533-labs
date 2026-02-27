#include <cuda_bf16.h>
__global__ void vector_add(int *a, int *b, int *c){
    c[0] = a[0] + b[0];
}
