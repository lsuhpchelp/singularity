## Running exabayes in parallel using MPI

The following Slurm script is adapted from the ExaBayes documentation (see: https://cme.h-its.org/exelixis/web/software/exabayes/manual/index.html#sec-4-2
).

Instead of the traditional `mpirun` command:

```bash
mpirun -np 16  ./exabayes -f aln.phy -q aln.part  -n myRun -s $RANDOM -c config.nex
```

we make use of Slurm’s native srun launcher, which allows the workload to run seamlessly across multiple compute nodes:

```bash
srun -n16 exabayes -f aln.phy -q aln.part  -n myRun -s $RANDOM -c config.nex
```

Assuming your input files are already prepared: `aln.phy`, `aln.part`, and `config.nex` (we included them in the `example` directory of this repository). You can submit your job using the following sample Slurm script. Save the content below into a file such as `run_exabayes.sh`.

```bash
#!/bin/bash
#SBATCH -A your_allocation_name
#SBATCH -p single
#SBATCH -n 16

module purge
module load exabayes
mv ExaBayes_* old/
srun -n16 exabayes -f example/aln.phy -q example/aln.part  -n myRun -s $RANDOM -c example/config.nex #> log.par.n16.mr 2>&1
```

Then submit the job script on the login node:

```bash
[fchen14@qbd2 exabayes/1.5.1]$ sbatch run_exabayes.sh
```
