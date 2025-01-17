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

`centos7run` only needs to be added before the executable name you intended to run:
```
centos7run <executable-name>
```
For example, to run the lammps executable named `lmp` (previously compiled on RHEL7, add `centos7run` before the `lmp` executable:
```
centos7run lmp
```
If you run the lammps program using the command `lmp <command line arguments>`, e.g.:
```
lmp -in input -log output
```
The command will simply become:
```
centos7run lmp -in input -log output
```

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
- **`cpu_mpi_guidance.md`**: Detailed guidance for running CPU-based MPI jobs.
- **`gpu_mpi_guidance.md`**: Detailed guidance for running GPU-accelerated MPI jobs.

---

## Example Usage
### Running the serial Job
```bash
sbatch run_cpu_serial.sh
```
### Running the OpenMP (multi-threaded) Job
```bash
sbatch run_cpu_omp.sh
```
### Running the CPU-Based MPI Job
```bash
sbatch run_cpu_mpi.sh
```
### Running the GPU-Based MPI Job
```bash
sbatch run_gpu_mpi.sh
```
