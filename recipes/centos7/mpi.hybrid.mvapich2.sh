#!/bin/bash
#SBATCH -p checkpt
#SBATCH -N 2
#SBATCH -n 96

module purge
#module load centos7-runner/1.0

# use mvapich2.modules to load necessary modules from rhel7 software stack
export SINGULARITYENV_MODULE_FILE="$PWD/mvapich2.modules"

export MV2_SMP_USE_CMA=0
export MV2_ENABLE_AFFINITY=0

# this uses 1 thread per MPI process
export SINGULARITYENV_OMP_NUM_THREADS=1
#srun -n96 centos7-runner.sif lmp -in in.lj -log log.omp.t1
srun -n96 ./centos7run lmp -in in.lj -log log.omp.t1

# this uses 2 (two) threads per MPI process
export SINGULARITYENV_OMP_NUM_THREADS=2
#srun -n48 centos7-runner.sif lmp -in in.lj -log log.omp.t2
srun -n48 ./centos7run lmp -in in.lj -log log.omp.t2

