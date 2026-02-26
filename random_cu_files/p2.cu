#include <stdio.h>
#include <stdlib.h> // For atoi
#include <cuda_runtime.h>
#include <assert.h>

#define N 1024
#define BLOCK_SIZE 16

inline cudaError_t checkCuda(cudaError_t result) {
    if (result != cudaSuccess) {
        fprintf(stderr, "CUDA Runtime Error: %s\n", cudaGetErrorString(result));
        assert(result == cudaSuccess);
    }
    return result;
}

__global__ void MMTile(float *A, float *B, float *C, int n, int offset) {
    int row = offset + blockIdx.y * BLOCK_SIZE + threadIdx.y;
    int col = blockIdx.x * BLOCK_SIZE + threadIdx.x;

    if (row < n && col < n) {
        float value = 0;
        for (int k = 0; k < n; ++k) {
            value += A[row * n + k] * B[k * n + col];
        }
        C[row * n + col] = value;
    }
}

int main(int argc, char **argv) {
    if (argc < 2) {
        printf("Usage: %s <nStreams>\n", argv[0]);
        return 1;
    }

    int nStreams = atoi(argv[1]); // Get nStreams from command-line input
    if (nStreams <= 0 || nStreams > N) {
        printf("Error: nStreams must be between 1 and %d\n", N);
        return 1;
    }

    const int streamSize = N / nStreams;
    const int streamBytes = streamSize * N * sizeof(float);
    const int bytes = N * N * sizeof(float);

    float *A, *B, *C, *d_a, *d_b, *d_c;

    // host pinned memory
    checkCuda(cudaMallocHost((void **)&A, bytes));
    checkCuda(cudaMallocHost((void **)&B, bytes));
    checkCuda(cudaMallocHost((void **)&C, bytes));

    // device memory
    checkCuda(cudaMalloc((void **)&d_a, bytes));
    checkCuda(cudaMalloc((void **)&d_b, bytes));
    checkCuda(cudaMalloc((void **)&d_c, bytes));

    for (int i = 0; i < N; ++i) {
        for (int j = 0; j < N; ++j) {
            A[i * N + j] = i;  // A[i][j] = i
            B[i * N + j] = j;  // B[i][j] = j
        }
    }

    // create events and streams
    cudaStream_t *streams = (cudaStream_t *)malloc(nStreams * sizeof(cudaStream_t));
    for (int i = 0; i < nStreams; ++i) {
        checkCuda(cudaStreamCreate(&streams[i]));
    }

    checkCuda(cudaMemcpy(d_b, B, bytes, cudaMemcpyHostToDevice));

    cudaEvent_t startEvent, stopEvent;
    checkCuda(cudaEventCreate(&startEvent));
    checkCuda(cudaEventCreate(&stopEvent));

    checkCuda(cudaEventRecord(startEvent, 0));

    // asynchronous memory copy for tiles of A
    for (int i = 0; i < nStreams; ++i) {
        int offset = i * streamSize;
        checkCuda(cudaMemcpyAsync(&d_a[offset * N], &A[offset * N], streamBytes, cudaMemcpyHostToDevice, streams[i]));
    }

    // kernel calls for tiles of C
    for (int i = 0; i < nStreams; ++i) {
        int offset = i * streamSize;
        dim3 block(BLOCK_SIZE, BLOCK_SIZE);
        dim3 grid(N / BLOCK_SIZE, streamSize / BLOCK_SIZE);
        MMTile<<<grid, block, 0, streams[i]>>>(d_a, d_b, d_c, N, offset);
    }

    // asynchronous memory copy for tiles of C back to host
    for (int i = 0; i < nStreams; ++i) {
        int offset = i * streamSize;
        checkCuda(cudaMemcpyAsync(&C[offset * N], &d_c[offset * N], streamBytes, cudaMemcpyDeviceToHost, streams[i]));
    }

    for (int i = 0; i < nStreams; ++i) {
        checkCuda(cudaStreamSynchronize(streams[i]));
    }

    checkCuda(cudaEventRecord(stopEvent, 0));
    checkCuda(cudaEventSynchronize(stopEvent));

    float ms = 0;  // elapsed time in milliseconds
    checkCuda(cudaEventElapsedTime(&ms, startEvent, stopEvent));
    printf("Execution time (ms): %f\n", ms);

    printf("C[451][451] = %f\n", C[451 * N + 451]);

    for (int i = 0; i < nStreams; ++i) {
        checkCuda(cudaStreamDestroy(streams[i]));
    }

    free(streams);
    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);
    cudaFreeHost(A);
    cudaFreeHost(B);
    cudaFreeHost(C);
    checkCuda(cudaEventDestroy(startEvent));
    checkCuda(cudaEventDestroy(stopEvent));

    return 0;
}

