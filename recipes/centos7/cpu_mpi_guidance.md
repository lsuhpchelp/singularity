### Guidance for SLURM Job script: run_cpu_mpi.sh

This SLURM script is designed to run a molecular dynamics simulation using **LAMMPS** on a cluster. It leverages a **CentOS 7 runtime environment** via the `centos7-runner` module and Singularity to run applications built for **RHEL7** software stack on the upgraded RHEL 8 Operating System. Below is a detailed explanation of the script:

---

#### **1. SLURM Directives**

1. **`#SBATCH -p checkpt`**
   - Specifies the job queue (the `checkpt` partition) to use.

2. **`#SBATCH -N 2`**
   - Requests 2 nodes for the job.

3. **`#SBATCH -n 96`**
   - Requests 96 tasks across the 2 nodes (48 tasks per node).

---

#### **2. Module Management**

1. **`module purge`**
   - Clears all previously loaded modules to avoid conflicts.

2. **`module load centos7-runner/1.0`**
   - Loads the `centos7-runner` module, which provides the CentOS 7 runtime environment for running RHEL7-compiled applications.

---

#### **3. Loading RHEL7 Modules**
1. **`export SINGULARITYENV_MODULE_FILE="$PWD/mvapich2.modules"`**
   - Sets the path to the `mvapich2.modules` file, which specifies the necessary modules for the RHEL7 software stack inside the container. This file is loaded by Singularity when the container image runs.

---

#### **4. Environment Variables**

1. **`export MV2_SMP_USE_CMA=0`**
   - Disables CMA (Cross Memory Attach) based intra-node communication at run time.

2. **`export MV2_ENABLE_AFFINITY=0`**
   - Disables process affinity, which prevents MPI processes from being pinned to specific CPUs. This is important for avoiding resource contention when running hybrid MPI-OpenMP mode using Mvapich2.

3. **`export SINGULARITYENV_OMP_NUM_THREADS=1`**
   - Sets the number of OpenMP threads per MPI process inside the container to 1. This ensures that each MPI process runs on a single thread.

---

#### **5. Running the Simulation**

1. **Single-threaded MPI Processes**
   - Command:
     ```bash
     srun -n96 centos7run lmp -in in.lj -log log.omp.t1
     ```
   - Runs the `lmp` (LAMMPS) executable using 96 MPI processes (`-n96`) with 1 thread per process. 
   - Input file: `in.lj`
   - Log file: `log.omp.t1`

2. **Multi-threaded MPI Processes**
   - Command:
     ```bash
     export SINGULARITYENV_OMP_NUM_THREADS=2
     srun -n48 centos7run lmp -in in.lj -log log.omp.t2
     ```
   - Sets the number of threads per MPI process to 2 (`SINGULARITYENV_OMP_NUM_THREADS=2`).
   - Runs the `lmp` executable using 48 MPI processes (`-n48`), distributing resources evenly across the nodes.
   - Input file: `in.lj`
   - Log file: `log.omp.t2`

---

### **How to Use This Script**

1. **Prepare the Input Files**:
   - Ensure the LAMMPS input file (`in.lj`) and any other required files are available in the job's working directory.

2. **Customize the `mvapich2.modules` File**:
   - The `mvapich2.modules` file (provided in this folder) should specify the RHEL7 modules needed for LAMMPS and MPI to run inside the CentOS 7 container.
   Example content of `mvapich2.modules`:
   ```bash
   #!/bin/bash
   export MODULEPATH=/usr/local/packages/Modules/modulefiles/apps:$MODULEPATH
   module purge
   module load lammps/20200303/intel-19.0.5-mvapich-2.3.3
   ```
3. **Submit the Job**:
   - Submit the job using:
     ```
     sbatch run_cpu_mpi.sh
     ```

4. **Monitor the Job**:
   - Check the job status using `squeue` and examine the output files (e.g., `log.omp.t1`, `log.omp.t2`) for simulation results.

---

### **Expected Results**
- The script runs the same simulation twice:
  - First with 96 single-threaded MPI processes. The expected run time for this run on two compute nodes is about 35 seconds.
  - Then with 48 multi-threaded MPI processes, each using 2 threads. The expected run time for this run on two compute nodes is about 90 seconds.
- Note that this example simply demonstrate how to run the MPI jobs using different threads and MPI processes, we do not try to optimize the performance. 

This script efficiently demonstrates how to leverage Singularity containers and MPI for running legacy RHEL7 software on upgraded RHEL 8 Operating System.
