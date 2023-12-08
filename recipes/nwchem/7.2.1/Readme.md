singularity image nwchem7.2.1-openmpi.4.1.4rc2.sif directory pulled using the below command with no changes, 

```
singularity pull -F --name nwchem7.2.1-openmpi.4.1.4rc2.sif oras://ghcr.io/edoapra/nwchem-singularity/nwchem-dev.ompi41x:latest
```
Reference: https://nwchemgit.github.io/Containers.html

Example script on SuperMike3:

- Use sample.srun.sh to run NWChem in parallel using srun (Recommended)

- Use sample.mpirun.sh to run NWChem in parallel using mpirun
