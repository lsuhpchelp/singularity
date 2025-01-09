#!/bin/bash
#SBATCH -p checkpt
#SBATCH -N 2
#SBATCH -n 96

#export SINGULARITY_BINDPATH="/usr/local/packages,/usr/local/compilers,/work,/project"
#export PATH="/project/container/image:$PATH"
module purge
module load centos7-runner/1.0
echo $PATH
export SINGULARITYENV_MODULE_FILE="$PWD/mvp2modules"

export MV2_SMP_USE_CMA=0
export MV2_ENABLE_AFFINITY=0

# this uses 1 thread per MPI process
export SINGULARITYENV_OMP_NUM_THREADS=1
srun -n96 centos7-runner.sif lmp -in in.lj -log log.omp.t1

# this uses 2 (two) threads per MPI process
export SINGULARITYENV_OMP_NUM_THREADS=2
srun -n48 centos7-runner.sif lmp -in in.lj -log log.omp.t2

