#!/bin/bash
#SBATCH -N 2 -n 2
#SBATCH -p checkpt

# SLURM_NODELIST contains something similar to qbc00[1-2]
# unslurm.py converts that to the form qbc001,qbc002
export NODES=$(unslurm.py)

# Make sure we have to run on.
if [ "$NODES" = "" ]
then
    echo "NO NODES" >&2
    exit 2
fi

# We need to unset all the slurm variables. The reason
# is because mpich will attempt contact the srun installation.
for k in $(env | cut -d= -f1 |grep SLURM)
do
   unset $k
done

# These environment variables are used to communicate
# with pingpong.py
export SECS=2
export MAX_SIZE=15

# Make sure you don't set SING_OPTS in .bashrc, because .bashrc
# may get called win singularity is invoked.
export SING_OPTS="--bind $HOME/libmpich:/usr/lib64/mpich/lib --bind /etc/ssh/ssh_known_hosts --bind /etc/hosts --bind /etc/hostname"
singularity exec $SING_OPTS /work/sbrandt/sing-mpi.simg bash ./launch.sh
mv pingpong.txt pingpong-native.txt

export SING_OPTS="--bind /etc/ssh/ssh_known_hosts --bind /etc/hosts --bind /etc/hostname"
singularity exec $SING_OPTS /work/sbrandt/sing-mpi.simg bash ./launch.sh
mv pingpong.txt pingpong-image.txt
