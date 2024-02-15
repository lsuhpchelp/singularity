# procedure inspired from below link:
# https://ciq.com/blog/integrating-site-specific-mpi-with-an-openfoam-official-apptainer-image-on-slurm-managed-hpc-environments/
# below commands need to be run as root on a local host (not on HPC clusters)
singularity build of2212.sif docker://opencfd/openfoam-dev:2212
singularity build pmi2-openmpi4.1.2.sif pmi2-openmpi4.1.2.def 
# to build pmi2 enabled openfoam-v2212 image:
singularity build pmi2-openfoam-v2212.sif pmi2-openfoam2212.def

# to build sedFoam on top of pmi2-openfoam-v2212.sif
# need to start from a sandbox, because sourcing openfoam etc/bashrc will result in error from singularity
singularity build --sandbox pmi2-sedFoam pmi2-openfoam2212.def
singularity shell -w pmi2-sedFoam

