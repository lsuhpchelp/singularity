# CentOS 7 Runner Singularity Image

## Overview

The **CentOS 7 Runner** provides a CentOS 7 runtime environment for running RHEL7-compiled software on upgraded RHEL8. This containerized approach ensures compatibility with legacy software compiled on the old operating system.

This repository includes example SLURM scripts and guidance documents for running **MPI-based applications** using the CentOS 7 runtime with Singularity.

---

## Getting Started

## `centos7run` Wrapper Script 

We have provided the centos7run wrapper script. This script simplifies running applications within the Singularity container by automatically enabling GPU support (if available) and binding necessary host paths. It ensures a streamlined experience when using the CentOS 7 runtime for RHEL7 software. To load the wrapper script, load the centos7-runner/1.0 module via the command:
```
module load centos7-runner/1.0
```
The command `centos7run` will then become available to your command line.

### How to use `centos7run`

#### General Usage (Serial Programs)

Normally, for serial programs that do not require parallelization, `centos7run` only needs to be added before the executable name you intended to run:
```
centos7run <executable-name>
```
For example, to run the lammps executable named `lmp` (previously compiled on RHEL7), add `centos7run` before the `lmp` executable:
```
centos7run lmp
```
If you run the lammps program using the command `lmp <command line arguments>` on the previous RHEL7 OS, e.g.:
```
lmp -in input -log output
```
The command will become the below on the current RHEL8 OS:
<pre>
<b>centos7run</b> lmp -in input -log output
</pre>

#### OpenMP Programs
For shared memory programs that utilize OpenMP, it is essential to specify the number of threads by setting the `OMP_NUM_THREADS` environment variable inside the container image. To achieve this, you can export the following environment variable before running `centos7run`:
<pre>
export <b>SINGULARITYENV_OMP_NUM_THREADS</b>=&lt;number of threads&gt;
</pre>
Based on this \<number of threads> value, the `centos7run` script will automatically set the `OMP_NUM_THREADS` variable within the container.

#### MPI Programs
Similarly, for MPI programs previously run using `srun`, e.g., 
```
srun -n8 lmp -in input -log output
```
add `centos7run` before the MPI executable name:
<pre>
srun -n8 <b>centos7run</b> lmp -in input -log output
</pre>

---

## How to Run MPI Jobs

This repository includes two example SLURM scripts for running MPI-based jobs:
1. **CPU-Only MPI Job**: Demonstrates running MPI jobs on CPU nodes.
2. **GPU-Accelerated MPI Job**: Demonstrates running MPI jobs with GPUs.

### Guidance Documents

To learn how to run these jobs effectively, please refer to the following guidance:
1. **[CPU-Based MPI Job Guidance](cpu_mpi_guidance.md)**:
   - Explains how to run MPI-based jobs on CPU-only nodes.
   - Includes details about environment variables, module configurations, and running on two compute nodes.

2. **[GPU-Accelerated MPI Job Guidance](gpu_mpi_guidance.md)**:
   - Details on how to run GPU-accelerated MPI jobs.

---

## Repository Structure

- **`centos7-runner.def`**: Singularity recipe for the CentOS 7 runtime.
- **`run_cpu_serial.sh`**: SLURM script for a serial job.
- **`run_cpu_omp.sh`**: SLURM script for a multi-threaded OpenMP job.
- **`run_cpu_mpi.sh`**: SLURM script for CPU-based MPI jobs.
- **`run_gpu_mpi.sh`**: SLURM script for GPU-accelerated MPI jobs.
- **`run_gpu_cpu_mpi.sh`**: SLURM example of running two tasks (first an MPI GPU task, then an MPI CPU task) in the same script using different environment modules.
- **`cpu_mpi_guidance.md`**: Detailed guidance for running CPU-based MPI jobs.
- **`gpu_mpi_guidance.md`**: Detailed guidance for running GPU-accelerated MPI jobs.

---

## Example Usage
### Submit the serial Job
```bash
sbatch run_cpu_serial.sh
```
### Submit the OpenMP (multi-threaded) Job
```bash
sbatch run_cpu_omp.sh
```
### Submit the CPU-Based MPI Job
```bash
sbatch run_cpu_mpi.sh
```
### Submit the GPU-Based MPI Job
```bash
sbatch run_gpu_mpi.sh
```
