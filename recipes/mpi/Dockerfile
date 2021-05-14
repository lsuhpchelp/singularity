FROM fedora
RUN dnf install -y make wget gcc gcc-c++ git gcc-gfortran \
  patch flex vim curl openssh-server python3 python3-pip bzip2 \
  findutils xz mpich mpich-devel python3-devel

ENV PATH /usr/lib64/mpich/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
RUN pip3 install mpi4py
RUN mkdir -p /work

ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
ENV LANGUAGE C.UTF-8

COPY singssh /usr/local/bin
COPY pingpong.py /usr/local/bin
COPY unslurm.py /usr/local/bin
COPY run-launch.sh /usr/local/bin
COPY launch.sh /usr/local/bin
RUN chmod 755 /usr/local/bin/*
