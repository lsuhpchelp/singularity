#!/bin/bash
#SBATCH -p checkpt
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 48

module purge
# load the centos7-runner module
module load centos7-runner/1.0

# use mvapich2.modules to load necessary modules from rhel7 software stack
export SINGULARITYENV_MODULE_FILE="$PWD/mvapich2.modules"

# set the OMP_NUM_THREADS environmental variable inside the container
export SINGULARITYENV_OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
centos7run lmp -in in.ser.lj -sf omp

