#!/bin/bash
#SBATCH -N 2
#SBATCH -p workq
#SBATCH -t 00:05:00
#SBATCH -A hpc_hpcadmin9
#SBATCH -n 128
#SBATCH -o nw.output.mpirun

module purge
SIMG="/home/admin/singularity/nwchem7.2.1-openmpi.4.1.4rc2.sif"
module load openmpi
export SINGULARITY_BIND="/ddnA/work,/ddnA/project"
export OMP_NUM_THREADS=1
mpirun -n 128 singularity exec ${SIMG} nwchem input.nw
