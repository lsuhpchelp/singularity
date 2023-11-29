#!/bin/bash
#PBS -l nodes=2:ppn=20
#PBS -l walltime=00:05:00
#PBS -A hpc_hpcadmin9
#PBS -q workq
#PBS -j oe
#PBS -o output.mpirun

export IMG="/home/admin/singularity/openfoam9.sdfibm-openmpi.4.0.3-pmi2.sif"

module purge
module load openmpi
# pre-processing, create mesh
cd $PBS_O_WORKDIR
singularity exec -B /work ${IMG} blockMesh
# create parallel domains
singularity exec -B /work ${IMG} decomposePar -force
module load openmpi/4.1.3/gcc-9.3.0
# ** important: on PBS clusters, SuperMIC or QB2,
# ** important: make sure openmpi/4.1.3/gcc-9.3.0 is loaded either in your ~/.bashrc or ~/.modules
# or you might see the error below when using more than one node:
#bash: orted: command not found
#--------------------------------------------------------------------------
#ORTE was unable to reliably start one or more daemons.
#This usually is caused by:
#
#* not finding the required libraries and/or binaries on
#  one or more nodes. Please check your PATH and LD_LIBRARY_PATH
#  settings, or configure OMPI with --enable-orterun-prefix-by-default
#
#* lack of authority to execute on one or more specified nodes.
#  Please verify your allocation and authorities.
#
#* the inability to write startup files into /tmp (--tmpdir/orte_tmpdir_base).
#  Please check with your sys admin to determine the correct location to use.
#..

SECONDS=0
# call icoFoam with mpirun
mpirun -hostfile $PBS_NODEFILE -n 4 -npernode 2 \
    singularity exec --pwd $PWD --bind /work ${IMG} icoFoam -parallel
echo "mpirun took $SECONDS sec."

