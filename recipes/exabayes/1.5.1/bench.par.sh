#!/bin/bash
#SBATCH -A loni_loniadmin1
#SBATCH -p workq
#SBATCH -n 48
#SBATCH -t 8:00:00

# we perform a benchmark test using 1,2,4,8,16,32,48 cores (MPI processes)
module purge
module load exabayes
mv ExaBayes_* old/
srun -n1 exabayes -f example/aln.phy -q example/aln.part  -n myRun -s $RANDOM -c example/config.nex > log/par.n01 2>&1
mv ExaBayes_* old/
srun -n2 exabayes -f example/aln.phy -q example/aln.part  -n myRun -s $RANDOM -c example/config.nex > log/par.n02 2>&1
mv ExaBayes_* old/
srun -n4 exabayes -f example/aln.phy -q example/aln.part  -n myRun -s $RANDOM -c example/config.nex > log/par.n04 2>&1
mv ExaBayes_* old/
srun -n8 exabayes -f example/aln.phy -q example/aln.part  -n myRun -s $RANDOM -c example/config.nex > log/par.n08 2>&1
mv ExaBayes_* old/
srun -n16 exabayes -f example/aln.phy -q example/aln.part  -n myRun -s $RANDOM -c example/config.nex > log/par.n16 2>&1
mv ExaBayes_* old/
srun -n32 exabayes -f example/aln.phy -q example/aln.part  -n myRun -s $RANDOM -c example/config.nex > log/par.n32 2>&1
mv ExaBayes_* old/
srun -n48 exabayes -f example/aln.phy -q example/aln.part  -n myRun -s $RANDOM -c example/config.nex > log/par.n48 2>&1

