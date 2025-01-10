#!/bin/bash
#SBATCH -p gpu2
#SBATCH -N 1
#SBATCH -n 48
#SBATCH --gres=gpu:2

module purge
module load centos7-runner/1.0

# use mvapich2.modules to load necessary modules from rhel7 software stack
export SINGULARITYENV_MODULE_FILE="$PWD/impi.cuda.modules"

# this uses 1 thread per MPI process
srun -n2 centos7run lmp -sf gpu -pk gpu 2 -in in.lj -log log.gpu

