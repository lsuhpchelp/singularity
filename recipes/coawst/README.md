# COAWST Singularity Environment Usage Guide

Using a Singularity container ensures that the COAWST environment is **self-contained and portable**, so your workflows remain stable and reproducible **regardless of cluster Operating System (e.g., RHEL 7 to RHEL 8) updates or scheduler (e.g., Slurm) upgrades**. This means you can always build and run COAWST in a consistent environment across different HPC systems. This document explains how to use the pre-built **Singularity image** `coawst.env.sif` for compiling and running COAWST. The image provides a **ready-to-use environment** with all required dependencies pre-installed. Users do **not** need to build this image themselves.

---

## 1. 🚀 Overview 

The Singularity recipe used to build this image is available here:  
[coawst.centos8.def](https://github.com/lsuhpchelp/singularity/blob/coawst/recipes/coawst/coawst.centos8.def)

The image contains the following dependencies:

- **Intel MPI** (2021.5.1)  
- **NetCDF-C** (4.9.2)  
- **NetCDF-Fortran** (4.6.1)  
- **MCT (Model Coupling Toolkit)** (2.11)  

> ⚠️ The image only provides the **build environment and dependencies**.  
> The actual **COAWST executable (`coawstM`)** must be compiled from source by the user, and will reside in the user’s working directory (e.g., `/home` or `/project`), please refrain from compiling your coawstM in /work as /work directory is subject to purge on LSU and LONI HPC clusters.

The pre-built image is already available at:
```
/project/container/images/coawst.env.sif
```
---

## 2. Compiling `coawstM`

### Step 1. Clone the COAWST source code from the official USGS GitLab repository. 
```
cd /project/$USER/
git clone https://code.usgs.gov/coawstmodel/COAWST.git
cd COAWST # enter the coawst source code directory
```

### Step 2. Modify the build script 

Edit the file `build_coawst.sh` (the source code used to build `coawstM` under the COAWST directory as follows:

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

### Step 3. Start an interactive job and enter the coawst.env.sif container image

```bash
[fchen14@qbd2 coawst]$ salloc -A loni_loniadmin1 -N1 -p workq -t 8:00:00
salloc: 865767.93 SUs available in loni_loniadmin1
salloc: 512.00 SUs estimated for this job.
salloc: Pending job allocation 345473
salloc: lua: Submitted job 345473
salloc: job 345473 queued and waiting for resources
salloc: job 345473 has been allocated resources
salloc: Granted job allocation 345473
salloc: Waiting for resource configuration
salloc: Nodes qbd354 are ready for job
# Below command enters the coawst image environment
[fchen14@qbd354 coawst]$ singularity shell -B /work,/project /project/containers/images/coawst.env.sif
INFO:    Mounting image with FUSE.
WARNING: terminal is not fully functional
-  (press RETURN)Loading icc version 2021.4.0
Loading compiler-rt version 2021.4.0

Loading icc/latest
  Loading requirement: compiler-rt/latest

Loading mpi version 2021.4.0
Singularity> cd /project/fchen14/COAWST

```

### Step 4. Build `coawstM` inside the singularity image

```bash
Singularity> pwd
/project/fchen14/COAWST
Singularity> ./build_coawst.sh
$gitrev is f755f2749f1e6960e959e91d2a9ef490c7eb8db7
rm -f -r core *.ipo ./Build_roms /home/fchen14/make_macros.mk
$gitrev is f755f2749f1e6960e959e91d2a9ef490c7eb8db7
cp -f /usr/local/include/netcdf.mod ./Build_roms
cp -f /usr/local/include/typesizes.mod ./Build_roms
    ...lots of output...
ranlib Build_roms/libROMS.a
/opt/intel/oneapi/mpi/2021.4.0/bin/mpiifort -fp-model precise -fc=ifort ...
/project/fchen14/singularity/recipes/coawst/COAWST.cts8/SWAN/build/lib/libswan41.45.a -L/usr/local/lib -lmct -lmpeu
rm -f -r /home/fchen14/make_macros.mk
Singularity>
```

⏳ The build process typically takes a few minutes.
If successful, a `coawstM` executable will be created in the current source directory.

```bash
Singularity> ls -latrh coawstM
-rwxr-xr-x 1 fchen14 nobody 18M Aug 18 16:54 coawstM
```

## 3. Running coawstM in parallel using MPI

We will then use the Inlet_test example as input provided by COAWST repository. Assume you have successfully built `/project/$USER/COAWST/coawstM`. 
The input file is located under the COAWST source code root directory:
```
Projects/Inlet_test/Coupled/coupling_inlet_test.in
```

Below is an example Slurm Job Script

```bash
#!/bin/bash
#SBATCH -p workq
#SBATCH -t 1:00:00
#SBATCH -N 1
#SBATCH -n 64
#SBATCH -o output.log

echo "This job is running on:" $(scontrol show hostname $SLURM_NODELIST)

export SIMG="/project/container/images/coawst.env.sif"
# bind the /work and /project directory to the image, or singularity image won't be able to find your files in /work and /project
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
To use more processes (e.g., 32), you must modify the input files accordingly.
Please refer to the official COAWST User Manual for details.

On LONI QB4 compute nodes, this example run typically takes 800 - 900 seconds using 2 MPI processes (`srun -n2`).

## 4. Summary

- Use the provided image at `/project/container/images/coawst.env.sif`. There is no need to build it yourself.  
- All dependencies (**Intel MPI, NetCDF, MCT**) are already included.  
- You must **compile your own COAWST executable (`coawstM`)** in your project directory (e.g., `/project/$USER/COAWST`).  
- Run jobs through **Slurm**, binding `/work` and `/project` into the container when executing.  

---

