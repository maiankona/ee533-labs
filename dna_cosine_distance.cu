// Cosine distance on L2-normalized vectors 

#include <cuda_runtime.h>

__global__ void f32_dot(const float *a, const float *b, float *acc, int n)
{
    if (threadIdx.x != 0 || blockIdx.x != 0)
        return;
    float s = 0.f;
    for (int k = 0; k < n; ++k)
        s = fmaf(a[k], b[k], s);
    acc[0] = s;
}

__global__ void f32_one_minus(const float *x, float *out, int len)
{
    int idx = threadIdx.x + blockIdx.x * blockDim.x;
    if (idx < len)
        out[idx] = 1.f - x[idx];
}

__global__ void f32_cosine_distance(const float *a, const float *b, float *dist_out, int n)
{
    if (threadIdx.x != 0 || blockIdx.x != 0)
        return;
    float s = 0.f;
    for (int k = 0; k < n; ++k)
        s = fmaf(a[k], b[k], s);
    dist_out[0] = 1.f - s;
}
