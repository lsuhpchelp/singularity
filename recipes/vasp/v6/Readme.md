#### Only if you need to build the image by yourself: for GPU version, using nvhpc
```
sudo singularity build vasp.gpu.nvhpc.sif vasp.gpu.nvhpc.def
```

#### Only if you need to build the image by yourself: for CPU version, using intel-mpi
```
sudo singularity build vasp6.cpu.impi.sif vasp.cpu.impi.def
```

#### Notes:
The VASP source code needs to be present at src/vasp.6.5.1.tgz under the current directory. You need to be an authorized user to get the source code.

#### How to run VASP - CPU version using Intel-MPI:
Example Slurm job script on LONI QB4
```
#!/bin/bash
#SBATCH -p workq
#SBATCH -N 2
#SBATCH -n 128
#SBATCH -c 1
#SBATCH -t 12:00:00
#SBATCH -A your_allocation
#SBATCH -J vasp.cpu
#SBATCH -o vasp.cpu.%j.out

module purge
module load vasp6/6.5.1-cpu
SECONDS=0
export SINGULARITYENV_OMP_NUM_THREADS=1
# This command uses 128 MPI processes on two nodes
srun -n128 vasp_std
echo "took $SECONDS sec."
```

#### How to run VASP - GPU version using NVHPC:
Example Slurm job script on LONI QB4
```
#!/bin/bash
#SBATCH -p gpu2
#SBATCH -N 1
#SBATCH -n 32
#SBATCH -t 00:20:00
#SBATCH -A your_allocation
#SBATCH -J vasp.gpu
#SBATCH -o vasp.gpu.%j.out

module purge
SECONDS=0
export SINGULARITYENV_OMP_NUM_THREADS=1
module load vasp6/6.5.1-gpu
# This command starts VASP using 1 GPU
srun -n1 vasp_std
echo "took $SECONDS sec."

```
