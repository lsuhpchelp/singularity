#!/bin/bash
#SBATCH -N 2
#SBATCH -n 128
#SBATCH -A hpc_hpcadmin9
#SBATCH -p checkpt
#SBATCH -t 00:15:00
#SBATCH -o output.slurm

module purge
IMG="/home/admin/singularity/openfoam-v2212-openmpi.4.1.2-pmi2.sif"
# pre-processing, create mesh
singularity run -B /work ${IMG} blockMesh
cp -r 0_org 0
# create parallel domains
singularity run -B /work ${IMG} decomposePar -force
SECONDS=0
# call icoFoam using srun, suggested
srun --overlap -n 128 singularity run --pwd $PWD --bind /work ${IMG} sedFoam_rbgh -parallel
#below lines uses mpirun
#module load openmpi
#mpirun -n 128 singularity run --pwd $PWD --bind /work ${IMG} sedFoam_rbgh -parallel
echo "srun took $SECONDS sec."
