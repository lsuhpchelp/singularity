#!/bin/bash
#SBATCH -N 2
#SBATCH -p workq
#SBATCH -t 00:05:00
#SBATCH -A hpc_hpcadmin9
#SBATCH -n 128
#SBATCH -o nw.srun.output

module purge
SIMG="/home/admin/singularity/nwchem7.2.1-openmpi.4.1.4rc2.sif"
srun --mpi=pmi2 -n $SLURM_NPROCS singularity exec --bind /work,/project ${SIMG} nwchem input.nw

