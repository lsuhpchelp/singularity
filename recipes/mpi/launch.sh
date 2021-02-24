export LD_LIBRARY_PATH=/usr/lib64/mpich/lib

# The options to launcher and launcher-exec make it possible for mpi to
# ssh into another singularity image on another node.
mpirun -launcher ssh -launcher-exec /usr/local/bin/singssh -np 2 -machines ${NODES} python3 /usr/local/bin//pingpong.py
