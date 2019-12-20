Sparkler
========

## Overview

The Sparkler miniapp computes a specialized dense matrix-matrix product
C = A^T A for small integer elements of the matrix A.
This operation mimics the matrix product operation used to compute the
Custom Corellation Coefficient (CCC) in the CoMet computational genomics code.

## Building

The build requires MPI and make.  The default build requires CUDA 9.2 or
higher for NVIDIA GPUs.  An alternative build path for CPU-only execution
requires an installed BLAS library, preferably multithreaded if the runs
use more than one core per MPI rank.

To build for a cluster, modify the Makefile to reflect your MPI and CUDA
installs and then type "make" (GPU case) or "env USE_GPU=NO make"
(CPU-only case).

## Running

Running the GPU executable requires one or more NVIDIA GPUs.
Volta V100 or later (compute capability 7.0 or higher) GPUs are preferred;
older GPUs will run much slower due to lack of tensor core hardware.

A run is composed of a series of iterations, each representing a global dense
matrix-matrix product.  A single iteration is composed of steps,
each corresponding to a single GEMM executed on each GPU.

Command-line options:

```
    --num_vector - number of vectors (half the number of columns of matrix A)

    --num_field - number of fields (the number of rows of A)

    --num_iterations - number of (global) matrix products done
```

Example:

```
mpirun -n 2 ./exec.cpu --num_vector 1000 --num_field 2000 --num_iterations 2
```

Reported values are:

TF - teraflops, total number of GEMM floating point operations

GEMM sec - total time spent in GPU GEMM operations

GEMM TF/sec - GEMM teraflop rate, ratio of TF to GEMM sec

total sec - total runtime

hash - a hash of the results computed, for evaluating correctness

## Competition Test Cases:

There are 9 test cases, and total 30 scores.

| Score | num_vector | num_field | Iteration |
| ----- | ---------- | --------- | --------- |
| 2     | 6000       | 21600     | 100       |
| 2     | 2000       | 12800     | 2560      |
| 3     | 3200       | 50000     | 100       |
| 3     | 2000       | 32000     | 600       |
| 2     | 1000       | 192000    | 300       |
| 1     | 1000       | 57600     | 200       |
| 1     | 800        | 5500      | 1024      |
| 6     | 1000       | 7500      | 768       |
| 10    | 6000       | 1250      | 512       |

Sample output:
```
summit-batch4$ mpirun -np 4 ./exec.cpu --num_vector 4000 --num_field 90000 --num_iterations 400
num_vector 4000 num_field 90000 num_iterations 400 num_proc 1
Iteration 1 of 400, step 1 of 1, elapsed sec XXXXXX: setup... GEMM... check...
Iteration 2 of 400, step 1 of 1, elapsed sec XXXXXX: setup... GEMM... check...
Iteration 4 of 400, step 1 of 1, elapsed sec XXXXXX: setup... GEMM... check...
Iteration 8 of 400, step 1 of 1, elapsed sec XXXXXX: setup... GEMM... check...
Iteration 16 of 400, step 1 of 1, elapsed sec XXXXXX: setup... GEMM... check...
Iteration 32 of 400, step 1 of 1, elapsed sec XXXXXX: setup... GEMM... check...
Iteration 64 of 400, step 1 of 1, elapsed sec XXXXXX: setup... GEMM... check...
Iteration 128 of 400, step 1 of 1, elapsed sec XXXXXX: setup... GEMM... check...
Iteration 256 of 400, step 1 of 1, elapsed sec XXXXXX: setup... GEMM... check...
Iteration 400 of 400, step 1 of 1, elapsed sec XXXXXX: setup... GEMM... check...
TF 4608.000 GEMM sec XXXXXX GEMM TF/sec XXXXXX total sec XXXXXX hash 435999930709XXXXXX
```
