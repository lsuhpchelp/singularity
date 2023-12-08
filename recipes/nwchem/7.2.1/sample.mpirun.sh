#!/bin/bash
#SBATCH -N 2
#SBATCH -p workq
#SBATCH -t 00:05:00
#SBATCH -A hpc_hpcadmin9
#SBATCH -n 128
#SBATCH -o nw.output.mpirun

module purge
#export SINGULARITYENV_NWCHEM_BASIS_LIBRARY="/opt/nwchem/share/libraries/"
#export SLURM_OVERLAP=1
SIMG="/home/admin/singularity/nwchem7.2.1-openmpi.4.1.4rc2.sif"
#srun --mpi=pmi2 -n $SLURM_NPROCS singularity exec --bind /work ${SIMG} nwchem input.nw
module load openmpi
DIR="/ddnA/work/fchen14/user_errs/sgiri"
export OMP_NUM_THREADS=1
#mpirun -n 64 -npernode 32 --wdir $PWD singularity exec --bind /work ${SIMG} nwchem $DIR/input.nw
#mpirun -n 128 singularity --wdir $PWD exec --bind /work ${SIMG} nwchem $DIR/input.nw
#mpirun -n 64 -npernode 32 --wdir $DIR singularity exec --bind /work ${SIMG} nwchem input.nw
mpirun -n 128 singularity exec --bind /ddnA/work ${SIMG} nwchem input.nw
#mpirun -n 128 singularity exec --bind /ddnA/work ${SIMG} nwchem input.nw
#mpirun -n 128 singularity exec --bind /ddnA/work ${SIMG} nwchem input.nw
#singularity exec nwchems.img mpirun --version
#singularity exec nwchems.img ompi_info
