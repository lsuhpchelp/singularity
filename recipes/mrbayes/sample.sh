#!/bin/bash
#SBATCH -J mrbayes_run
#SBATCH -p single
#SBATCH -N 1
#SBATCH -n 8
#SBATCH --time=00:05:00
#SBATCH -o mb.output

# Run MrBayes with srun in parallel
module purge
module load mrbayes/3.2.7a
# mb-mpi is just an alias to mb
# hymfossil.nex is downloaded from https://github.com/NBISweden/MrBayes/blob/develop/examples/hymfossil.nex
srun -n8 mb-mpi hymfossil.nex

