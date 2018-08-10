# Simoun

An environment test script written for bash-style shell.

------------------

## Assumed Environment

* OS: Linux Based
* Platform: x86_64, Intel CPU
* Software: OpenMPI, Intel PSXE, MPICH and nVidia CUDA installed

## Script Goal

1. Environment variables test: Test environment-module's working status, check if all the installed MPI libraries work, testing commands including but not limited to env / grep, mpirun, mpicc, mpiicc (psxe specified)
2. Network bandwidth test: Run a certain MPI benchmark (OSU/Intell MPI Benchmark) between machines, hosts or host file can be specified manually.
3. CPU main frequency stress test.
4. RAM stress test.
5. Disk extreme payload read/write test.
