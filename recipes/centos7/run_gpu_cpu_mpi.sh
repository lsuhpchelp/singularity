#!/bin/bash
#SBATCH -p gpu2
#SBATCH -N 1
#SBATCH -n 48
#SBATCH --gres=gpu:2

module purge
module load centos7-runner/1.0

# use mvapich2.modules to load necessary modules from rhel7 software stack
export SINGULARITYENV_MODULE_FILE="$PWD/impi.cuda.modules"

# this uses 2 gpus
srun -n2 centos7run lmp -sf gpu -pk gpu 2 -in in.lj -log log.gpu

# this uses 1 thread per MPI process
srun -n48 centos7run lmp -in in.lj -log log.omp.impi

module purge

# use mvapich2.modules to load necessary modules from rhel7 software stack
export SINGULARITYENV_MODULE_FILE="$PWD/mvapich2.modules"

export MV2_SMP_USE_CMA=0
export MV2_ENABLE_AFFINITY=0

# this uses 1 thread per MPI process
export SINGULARITYENV_OMP_NUM_THREADS=1
#srun -n96 centos7-runner.sif lmp -in in.lj -log log.omp.t1
srun -n48 centos7run lmp -in in.lj -log log.omp.mvp2

## this uses 2 (two) threads per MPI process
#export SINGULARITYENV_OMP_NUM_THREADS=2
##srun -n48 centos7-runner.sif lmp -in in.lj -log log.omp.t2
#srun -n24 ./centos7run lmp -in in.lj -log log.omp.t2

