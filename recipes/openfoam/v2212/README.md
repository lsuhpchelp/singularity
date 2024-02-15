Procedure inspired from below link:

https://ciq.com/blog/integrating-site-specific-mpi-with-an-openfoam-official-apptainer-image-on-slurm-managed-hpc-environments/

#### Step 1. Build two local images, one from OpenFOAM-v2212 dockerhub, one with pmi2 enabled openmpi-4.1.2
The below commands need to be run as root on a local host (not on HPC clusters)
```
singularity build of2212.sif docker://opencfd/openfoam-dev:2212
singularity build pmi2-openmpi4.1.2.sif pmi2-openmpi4.1.2.def
```
#### Step 2. Build pmi2 enabled openfoam-v2212 image:
```
singularity build pmi2-openfoam-v2212.sif pmi2-openfoam2212.def
```

#### Step 3 (Optional). Build third-party solvers based on the pmi2-openfoam-v2212.sif
Build sedFoam on top of pmi2-openfoam-v2212.sif, we need to start from a sandbox, because sourcing /usr/lib/openfoam/openfoam2212/etc/bashrc will result in an error from singularity build command, so we workaround this by using the interactive shell
```
singularity build --sandbox pmi2-sedFoam pmi2-openfoam2212.def
singularity shell -w pmi2-sedFoam
```
Then from inside the singularity shell:
```
. /usr/lib/openfoam/openfoam2212/etc/bashrc
cd /opt
git clone --recurse-submodules https://github.com/sedfoam/sedfoam sedfoam
cd sedfoam
# use FOAM_MODULE_PREFIX to install sedFoam to OF solver directory
FOAM_MODULE_PREFIX=/usr/lib/openfoam/openfoam2212/platforms/linux64GccDPInt32Opt/ ./Allwmake
exit # exit the singularity shell terminal (sandbox)
```
Build the sandbox back to sif format image:
```
singularity build pmi2-openfoam2212-sedFoam.sif pmi2-sedFoam
```
