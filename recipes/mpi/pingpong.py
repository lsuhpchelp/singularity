from mpi4py import MPI
from time import time
import os
import sys

secs = float(os.environ.get("SECS","3"))
min_size = int(os.environ.get("MIN_SIZE","5"))
max_size = int(os.environ.get("MAX_SIZE","20"))
start_tok = b'S'
end_tok = b'E'
print("config:",secs,min_size,max_size)

def main():
    comm = MPI.COMM_WORLD
    rank = comm.Get_rank()

    if rank == 0:
        fname = "pingpong-pid%d.txt" % os.getpid()
        with open(fname, "w") as fd:
            for i in range(min_size, max_size):
                data_base = bytes(2**i-1)
                data_start = start_tok + data_base
                data_end = end_tok + data_base
                t1 = t2 = time()
                n_reps = 0
                while True:
                    if t2 - t1 < secs:
                        data = data_start
                    else:
                        data = data_end
                    comm.send(data, dest=1)
                    d = comm.recv(source=1)
                    t2 = time()
                    n_reps += 1
                    assert len(d) == len(data)
                    if data[0] == end_tok[0]:
                        break
                delt = (t2 - t1)/n_reps
                print(i,t2-t1, n_reps, delt)
                sys.stdout.flush()
                print(i, delt, file=fd)
    elif rank == 1:
        for i in range(min_size, max_size):
            while True:
                data = comm.recv(source=0)
                comm.send(data, dest=0)
                if data[0] == end_tok[0]:
                    break

main()
