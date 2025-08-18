# COAWST Singularity Environment Usage Guide

This document explains how to use the pre-built **Singularity image** `coawst.env.sif` for compiling and running COAWST.  

The image provides a **ready-to-use environment** with all required dependencies pre-installed. Users do **not** need to build this image themselves.

---

## 1. Overview

The Singularity recipe used to build this image is available here:  
[coawst.centos8.def](https://github.com/lsuhpchelp/singularity/blob/coawst/recipes/coawst/coawst.centos8.def)

The image contains the following dependencies:

- **Intel MPI** (2021.5.1)  
- **NetCDF-C** (4.9.2)  
- **NetCDF-Fortran** (4.6.1)  
- **MCT (Model Coupling Toolkit)** (2.11)  

> ⚠️ The image only provides the **build environment and dependencies**.  
> The actual **COAWST executable (`coawstM`)** must be compiled from source by the user, and will reside in the user’s working directory (e.g., `/home` or `/project`).

The pre-built image is already available at:
```
/project/container/images/coawst.env.sif
```
---

## 2. Compiling `coawstM`

### Step 1. Enter the container

```bash
singularity shell -B /work,/project /project/container/images/coawst.env.sif
```

### Step 2. Clone the COAWST source code, note that the below commands runs inside the container, not on the host system
cd /project/$USER/
git clone https://code.usgs.gov/coawstmodel/COAWST.git
cd COAWST

### Step 3. Modify the build script 

Edit build_coawst.sh under the COAWST directory as follows:

Line 141
Change to:

```
export MY_ROOT_DIR=$PWD
# or equivalently:
# export MY_ROOT_DIR=/project/$USER/COAWST
```

Line 217–218
Switch compiler to Intel Fortran:
```
export FORT=ifort
# export FORT=gfortran
```

### Step 4. Build COAWST
./build_coawst.sh


⏳ The build process typically takes a few minutes.
If successful, a `coawstM` executable will be created in the current directory.

## 3. Running coawstM

We will use the Inlet_test example provided by COAWST.
The input file is located under the COAWST source code root directory:

Projects/Inlet_test/Coupled/coupling_inlet_test.in

Assume you have successfully built `/project/$USER/COAWST/coawstM`.

Example Slurm Job Script

```bash
#!/bin/bash
#SBATCH -p workq
#SBATCH -t 1:00:00
#SBATCH -N 1
#SBATCH -n 64
#SBATCH -o output.log

echo "This job is running on:" $(scontrol show hostname $SLURM_NODELIST)

export SIMG="/project/container/images/coawst.env.sif"
# bind the 
export SINGULARITY_BINDPATH="/work,/project"

module purge
SECONDS=0

# Run with 2 MPI processes inside the Singularity container
srun -n2 singularity exec $SIMG \
    /project/$USER/COAWST/coawstM \
    Projects/Inlet_test/Coupled/coupling_inlet_test.in

echo "Elapsed time: $SECONDS sec"
```

ℹ️ Notes:

The default Inlet_test example is configured for 2 MPI processes.
To use more processes (e.g., 32 as in the script above), you must modify the input files accordingly.
Please refer to the official COAWST User Manual for details.

On LONI QB4 compute nodes, this example run typically takes 800–900 seconds.

4. Summary

Use the provided image at /project/container/images/coawst.env.sif — no need to build it yourself.

All dependencies (Intel MPI, NetCDF, MCT) are included.

You must compile your own COAWST executable (coawstM) in your project directory.

Run jobs through Slurm, binding /work and /project into the container.
