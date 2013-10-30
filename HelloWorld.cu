#include "Utils.h"

// ===============
// The CUDA kernel
// ===============

__global__ void helloworldKernel(const int nGridSize)
{
	int gIdx = blockIdx.x * blockDim.x + threadIdx.x;

	if(gIdx >= nGridSize)
	{
		return;
	}

	printf("Hello, world! from thread(tIdx = %d, bIdx = %d, gIdx = %d)" NEW_LINE, threadIdx.x, blockIdx.x, gIdx);
}

// =================
// Run the CUDA grid
// =================

void runDeviceGrid(const int nBlocks, const int nThreads, const int nGridSize)
{
	// Launch the grid asynchronously
	helloworldKernel<<<nBlocks, nThreads>>>(nGridSize);

	// Wait for the grid to finish
	SAFE_CUDA_CALL(cudaDeviceSynchronize());
}

// =======================
// Application entry point
// =======================

int _01_Hello_World(int argCount, char ** argValues)
{
	int vGridConf[3];
	const char * vErrMessages[2] =	{"Error: The number of threads must be greater than 0.",
									 "Error: The grid size must be greater than 0."};

	// Extract and validate the number of blocks and threads to launch
	validateArguments(argCount, 2, argValues, vGridConf, vErrMessages);

	printf("Starting application (B: %d, T: %d, G: %d):" NEW_LINE, vGridConf[0], vGridConf[1], vGridConf[2]);

	// Launch the CUDA grid
	runDeviceGrid(vGridConf[0], vGridConf[1], vGridConf[2]);

	printf("The application has finished." NEW_LINE);

	WAIT_AND_EXIT(0);
}