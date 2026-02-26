#include <cuda_runtime.h>
#include <iostream>

#define TILE_WIDTH 16  // Tile width for shared memory

// CUDA kernel for convolution
__global__ void convolution_kernel(float* input, float* filters, float* output,
                                   int batch_size, int in_channels, int input_h, int input_w,
                                   int out_channels, int kernel_h, int kernel_w, int stride,
                                   int padding, int output_h, int output_w) {

    // Thread and block indices
    int b = blockIdx.x;  // Batch index
    int oc = blockIdx.y; // Output channel index
    int h = blockIdx.z * blockDim.y + threadIdx.y; // Height index in the output
    int w = blockIdx.z * blockDim.x + threadIdx.x; // Width index in the output

    if (b < batch_size && oc < out_channels && h < output_h && w < output_w) {
        float acc = 0.0f;

        for (int ic = 0; ic < in_channels; ++ic) {
            // Load the input tile and the corresponding filter values for the current output channel
            for (int kh = 0; kh < kernel_h; ++kh) {
                for (int kw = 0; kw < kernel_w; ++kw) {
                    int in_h = h * stride + kh - padding;
                    int in_w = w * stride + kw - padding;

                    if (in_h >= 0 && in_h < input_h && in_w >= 0 && in_w < input_w) {
                        // Fetch input and corresponding filter values from the input tensor and filter tensor
                        float input_value = input[b * in_channels * input_h * input_w +
                                                  ic * input_h * input_w +
                                                  in_h * input_w + in_w];
                        float filter_value = filters[oc * in_channels * kernel_h * kernel_w +
                                                     ic * kernel_h * kernel_w +
                                                     kh * kernel_w + kw];
                        acc += input_value * filter_value;
                    }
                }
            }
        }

        // Write the result to the output tensor
        output[b * out_channels * output_h * output_w +
               oc * output_h * output_w +
               h * output_w + w] = acc;
    }
}

// Wrapper for the convolution kernel
extern "C" void parallel_convolution(float* input, float* filters, float* output,
                                     int batch_size, int in_channels, int input_h, int input_w,
                                     int out_channels, int kernel_h, int kernel_w, int stride,
                                     int padding, int output_h, int output_w) {

    // Define the block and grid sizes
    dim3 blockSize(TILE_WIDTH, TILE_WIDTH);  // TILE_WIDTH x TILE_WIDTH threads per block
    dim3 gridSize(batch_size, out_channels, (output_h + TILE_WIDTH - 1) / TILE_WIDTH);

    // Launch the convolution kernel
    convolution_kernel<<<gridSize, blockSize>>>(input, filters, output,
                                                batch_size, in_channels, input_h, input_w,
                                                out_channels, kernel_h, kernel_w, stride, padding, output_h, output_w);
    cudaDeviceSynchronize();  // Ensure kernel execution completes
}
