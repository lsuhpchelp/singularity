# Delft3D4 Singularity Environment Usage Guide

Using a Singularity container ensures that the Delft3D4 environment is **self-contained and portable**, so your workflows remain stable and reproducible **regardless of cluster Operating System (e.g., RHEL 7 to RHEL 8) updates or scheduler (e.g., Slurm) upgrades**. This means you can always build and run Delft3D4 in a consistent environment across different HPC systems. This document explains how to use the **Singularity image** `delft3d4_142586.sif` with all the required dependencies installed. Users do **not** need to build this image themselves.

---

## 1. 🚀 Overview 

The Singularity recipe used to build this image is available here:  
[delft3d_dwaves.def](https://github.com/lsuhpchelp/singularity/blob/main/recipes/delft3d4/delft3d_dwaves.def)

The image contains the following dependencies:

- **Intel MPI** (2022.2)
- **ZLIB** (1.2.13)
- **SZIP** (2.1.1)
- **GDAL** (v3.6.2)
- **HDF5** (1.14.4.3)
- **NetCDF-C** (4.9.2)  
- **NetCDF-Fortran** (4.6.1)
- **Patchelf** (0.18.0)
- **fortranGIS** (v3.0-1)

The image is already available on LSU HPC and LONI QB3/QB4 cluster at:
```
/project/containers/images/delft3d4_142586.sif
```
---

## 2. Compiled Modules

This image has **d_hydro and Waves modules**. The binaries can be found at 
 - **d_hydro** - /opt/142586/build_delft3d4/d_hydro
 - **wave**    - /opt/142586/build_delft3d4/wave

## 4. Running delft3d4 in Serial

This is the example SLURM batch job submission script to **d_hydro** in serial mode. You can copy and save the contents below to a job script file, e.g., run_delft3d4_example.sh

```bash
#!/bin/bash
#SBATCH -p workq
#SBATCH -t 1:00:00
#SBATCH -N 1
#SBATCH -n 64
#SBATCH -o output.log

echo "This job is running on:" $(scontrol show hostname $SLURM_NODELIST)

export SIMG="/project/containers/images/delft3d4_142586.sif"
# bind the /work and /project directory to the image, or the singularity image won't be able to find your files in /work and /project
export SINGULARITY_BINDPATH="/work,/project"

module purge
cd /work/$USER/<your_directory>/
# Run d_hydro in serial
SECONDS=0
singularity exec $SIMG \
    /opt/142586/build_delft3d4/d_hydro.d_hydro \
    config_d_hydro.xml

echo "Elapsed time: $SECONDS sec"
```

## 4. Running d_hydro in parallel using MPI

Below is an example Slurm Job Script. You can copy and save the contents below to a job script file, e.g., run_delft3d4_example.sh

```bash
#!/bin/bash
#SBATCH -p workq
#SBATCH -t 1:00:00
#SBATCH -N 2
#SBATCH -n 16
#SBATCH --ntasks-per-node=8
#SBATCH --cpus-per-task=1
#SBATCH -o output.log

echo "This job is running on:" $(scontrol show hostname $SLURM_NODELIST)

export SIMG="/project/containers/images/delft3d4_142586.sif"
# bind the /work and /project directory to the image, or the singularity image won't be able to find your files in /work and /project
export SINGULARITY_BINDPATH="/work,/project"

module purge
cd /work/$USER/<your_directory>/

# Run with 16 MPI processes of coawstM inside the Singularity container
SECONDS=0

srun --mpi=pmix -n16 singularity exec $SIMG \
    /opt/142586/build_delft3d4/d_hydro.d_hydro \
    config_d_hydro.xml

echo "Elapsed time: $SECONDS sec"
```

Then submit the job script on the login node:

```bash
[kasetti@qbd2 Delft3d4]$ sbatch run_delft3d4_example.sh
```

ℹ️ Notes:

Yet to make an example.
Please refer to the official Delft3D4 User Manual for details.

On LONI QB4 compute nodes, this example run typically takes 800 - 900 seconds using 2 MPI processes (`srun -n2`).

## 4. Summary

- Use the provided image at `/project/containers/images/delft3d4_142586.sif`. There is no need to build it yourself.  
- All dependencies (**Intel MPI, HDF5, NetCDF**) are already included.  
- Run jobs through **Slurm**, binding `/work` and `/project` into the container when executing.  

---

