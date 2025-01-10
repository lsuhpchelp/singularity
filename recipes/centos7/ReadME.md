# CentOS 7 Runner Singularity Image

## Overview
The **CentOS 7 Runner** provides a CentOS 7 runtime environment for running RHEL7-compiled software on upgraded RHEL8. This containerized approach ensures compatibility with legacy software compiled on old operating system.

This repository includes example SLURM scripts and guidance documents for running **MPI-based applications** using the CentOS 7 runtime with Singularity.

---

## Getting Started

### Prerequisites
1. **Singularity**: Ensure Singularity is installed on your system. Refer to the [Singularity Documentation](https://sylabs.io/guides/) for installation instructions.
2. **Cluster Environment**: Access to a cluster with SLURM workload manager and necessary modules (e.g., MPI, GPU drivers).

---

## How to Run MPI Jobs

This repository includes two example SLURM scripts for running MPI-based jobs:
1. **CPU-Only MPI Job**: Demonstrates running MPI jobs without GPU acceleration.
2. **GPU-Accelerated MPI Job**: Demonstrates using GPUs for accelerated computations.

### Guidance Documents

To learn how to run these jobs effectively, please refer to the following guidance:
1. **[CPU-Based MPI Job Guidance](cpu_mpi_guidance.md)**:
   - Explains how to run MPI-based jobs on CPU-only nodes.
   - Includes details about environment variables, module configurations, and scaling.

2. **[GPU-Accelerated MPI Job Guidance](gpu_mpi_guidance.md)**:
   - Details how to run GPU-accelerated MPI jobs.
   - Covers GPU-related environment variables, CUDA setup, and performance optimization.

---

## Repository Structure

- **`centos7-runner.def`**: Singularity recipe for the CentOS 7 runtime.
- **`run_cpu_mpi.sh`**: SLURM script for CPU-based MPI jobs.
- **`run_gpu_mpi.sh`**: SLURM script for GPU-accelerated MPI jobs.
- **`cpu_mpi_guidance.md`**: Detailed guidance for running CPU-based MPI jobs.
- **`gpu_mpi_guidance.md`**: Detailed guidance for running GPU-accelerated MPI jobs.

---

## Example Usage

### Running the CPU-Based MPI Job
```bash
sbatch run_cpu_mpi.sh

### Running the GPU-Based MPI Job
```bash
sbatch run_gpu_mpi.sh
