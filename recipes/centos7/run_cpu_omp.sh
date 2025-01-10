#!/bin/bash
#SBATCH -p checkpt
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 48

module purge
module load centos7-runner/1.0

# use mvapich2.modules to load necessary modules from rhel7 software stack
export SINGULARITYENV_MODULE_FILE="$PWD/mvapich2.modules"

export SINGULARITYENV_OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
/usr/bin/time centos7run lmp -in in.ser.lj -sf omp

