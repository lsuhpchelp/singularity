## Running exabayes commands not using MPI

The following instructions and Slurm scripts are adapted from the ExaBayes documentation (see: https://cme.h-its.org/exelixis/web/software/exabayes/manual/index.html#sec-4-2
). 

To run ExaBayes utilities that do not use MPI (such as `yggdrasil`), simply load the `exabayes` module and call the tool directly on a compute node. For example, to run `yggdrasil`:

```bash
[fchen14@qbc003 1.5.1]$ module load exabayes


[ Help information ]

1. This module only works on computing nodes (not available on head nodes). Make sure you start a job!

2. Below executables are available:

consense        credibleSet     exabayes        extractBips     parser          postProcParam   sdsf            yggdrasil

[fchen14@qbc003 1.5.1]$ mv ExaBayes_* old
[fchen14@qbc003 1.5.1]$ yggdrasil -f example/aln.phy -m DNA -n myRun -s $RANDOM
INFO:    Mounting image with FUSE.

This is Yggdrasil, the multi-threaded variant of ExaBayes (version 1.5.1),
a tool for Bayesian MCMC sampling of phylogenetic trees, build with the
Phylogenetic Likelihood Library (version 1.0.0, September 2013).

This software has been released on 2020-06-08 21:00:06
(git commit id:1dca14203d774e0e74ec41745c932c40a0cb29c6)

        by Andre J. Aberer, Kassian Kobert and Alexandros Stamatakis

Please send any bug reports, feature requests and inquiries to exabayes-at-googlegroups-dot-com

The program was called as follows:
/usr/local/bin/yggdrasil -f example/aln.phy -m DNA -n myRun -s 10065

================================================================
You provided an alignment file in phylip format. Trying to parse it...
```

## Running exabayes in parallel using MPI

For parallel `exabayes` utilizing MPI, instead of the traditional `mpirun` command:

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
[fchen14@qbc2 exabayes/1.5.1]$ sbatch run_exabayes.sh
```

## Parallel Performance

This repository includes a benchmark script that tests ExaBayes with 1, 2, 4, 8, 16, 32, and 48 MPI processes on a single LONI QB3 compute node. Please note that this parallel benchmark only reflects the specific example provided in the ExaBayes manual (https://cme.h-its.org/exelixis/web/software/exabayes/manual/index.html#sec-4-2
) and the measurements taken on a single QB3 compute node; it does not represent the overall parallel performance of ExaBayes. 

You can submit the benchmark job with:

```bash
[fchen14@qbc2 exabayes/1.5.1]$ sbatch bench.par.sh
```
The job will generate output under the log directory. To view the results, run:

```bash
[fchen14@qbc4 1.5.1]$ grep 'walltime' log/*
log/par.n01:Total walltime elapsed:     2055.25 seconds  or 00:34:15.25 (hh:mm:ss).
log/par.n02:Total walltime elapsed:     1329.55 seconds  or 00:22:9.55 (hh:mm:ss).
log/par.n04:Total walltime elapsed:     974.01 seconds  or 00:16:14.01 (hh:mm:ss).
log/par.n08:Total walltime elapsed:     817.03 seconds  or 00:13:37.03 (hh:mm:ss).
log/par.n16:Total walltime elapsed:     905.01 seconds  or 00:15:5.01 (hh:mm:ss).
log/par.n32:Total walltime elapsed:     1086.82 seconds  or 00:18:6.82 (hh:mm:ss).
log/par.n48:Total walltime elapsed:     1298.55 seconds  or 00:21:38.55 (hh:mm:ss).
```

Relative to the single-process runtime (2055 seconds), the best performance is achieved with 8 MPI processes, completing in 817 seconds. Using additional cores does not improve performance further, likely due to communication overhead between processes.

Keep in mind that parallel efficiency is highly problem-dependent; more cores do not always translate into faster execution.

