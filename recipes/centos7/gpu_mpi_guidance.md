### Guidance for SLURM Job script: mpi.hybrid.impi_cuda.sh

This SLURM script is designed to run a **GPU-accelerated molecular dynamics simulation** using **LAMMPS** on LONI QB3. It utilizes the **CentOS 7 runtime environment** provided by the `centos7-runner` module to ensure compatibility with the RHEL7 software stack on the upgraded RHEL 8 Operating System. Below is a detailed explanation of the script:

---

#### **1. SLURM Directives**

1. **`#SBATCH -p gpu2`**
   - Specifies the partition (queue) to use. In this case, it's the `gpu2` partition, which contains nodes equipped with GPUs.

2. **`#SBATCH -N 1`**
   - Requests a single node for the job.

3. **`#SBATCH -n 48`**
   - Requests 48 tasks (CPU cores) on the allocated node. 

4. **`#SBATCH --gres=gpu:2`**
   - Requests 2 GPUs on the allocated node. 

---

#### **2. Module Management**

1. **`module purge`**
   - Clears all loaded modules to avoid conflicts.

2. **`module load centos7-runner/1.0`**
   - Loads the `centos7-runner` module, which provides a CentOS 7 runtime environment for running RHEL7-compiled software stack on RHEL8.

---

#### **3. Loading RHEL7 Modules**

1. **`export SINGULARITYENV_MODULE_FILE="$PWD/impi.cuda.modules"`**
   - Specifies the path to the `impi.cuda.modules` file. This file contains the necessary modules for the Intel MPI (IMPI) library and CUDA tools required by LAMMPS.
   - This ensures that the required RHEL7 modules are loaded inside the Singularity container.

---

#### **4. Running the Simulation**

1. **Command**:
   ```bash
   srun -n2 centos7run lmp -sf gpu -pk gpu 2 -in in.lj -log log.gpu
   ```

2. **Explanation**:
   - **`srun -n2`**:
     - Allocates 2 MPI tasks for the simulation.
   - **`centos7run`**:
     - A wrapper for running commands inside the CentOS 7 runtime environment.
   - **`lmp -sf gpu -pk gpu 2 -in in.lj -log log.gpu`**:
     - Runs the LAMMPS simulation:
       - **`-sf gpu`**: Uses the GPU-accelerated pair styles.
       - **`-pk gpu 2`**: Allocates 2 GPUs for the simulation.
       - **`-in in.lj`**: Specifies the input file for the simulation.
       - **`-log log.gpu`**: Outputs log information to the file `log.gpu`.

---

### **How to Use This Script**

1. **Prepare the Input Files**:
   - Ensure the LAMMPS input file (`in.lj`, provided in this directory) is in the job's working directory.

2. **Customize the `impi.cuda.modules` File**:
   - The `impi.cuda.modules` file should specify the necessary RHEL7 modules for MPI and CUDA.

   Example content of `impi.cuda.modules`:
   ```bash
   #!/bin/bash
   export MODULEPATH=/usr/local/packages/Modules/modulefiles/apps:$MODULEPATH
   module purge
   module load lammps/20220324/gcc-9.3.0-cuda-intel-mpi-2019.5.281
   ```

3. **Submit the Job**:
   - Submit the job script using:
     ```bash
     sbatch run_gpu_mpi.sh
     ```

4. **Monitor the Job**:
   - Use `squeue` to check the job status.
   - Review the output in the `log.gpu` file for simulation results and performance metrics.

### **Expected Results**
1. **Optimize GPU Utilization**:
   - Ensure that the number of MPI processes matches the GPU resources effectively. For this script, 2 MPI tasks are mapped to 2 GPUs.

2. **Performance**:
   - The expected run time for this job on a QB3 Nvidia V100 node is about 1 minute.
