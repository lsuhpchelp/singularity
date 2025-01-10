#!/bin/bash
#SBATCH -p checkpt
#SBATCH -N 1
#SBATCH -n 48

module purge
# load the centos7-runner module
module load centos7-runner/1.0

# use mvapich2.modules to load necessary modules from rhel7 software stack
export SINGULARITYENV_MODULE_FILE="$PWD/mvapich2.modules"

# this command runs the executable 'lmp' using the centos7run wrapper
centos7run lmp -in in.ser.lj
