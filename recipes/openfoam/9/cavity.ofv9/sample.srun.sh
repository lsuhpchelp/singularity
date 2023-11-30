#!/bin/bash
#SBATCH -N 2
#SBATCH -n 128
#SBATCH -A hpc_hpcadmin9
#SBATCH -p checkpt
#SBATCH -t 00:05:00
#SBATCH -o output.slurm

module purge
IMG="/home/admin/singularity/openfoam9.sdfibm-openmpi.4.0.3-pmi2.sif"
# pre-processing, create mesh
singularity exec -B /work ${IMG} blockMesh
# create parallel domains
singularity exec -B /work ${IMG} decomposePar -force
SECONDS=0
# call icoFoam using srun
srun --overlap -n 4 singularity exec --pwd $PWD --bind /work ${IMG} icoFoam -parallel
echo "srun took $SECONDS sec."
