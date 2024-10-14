FROM intel/hpckit:2024.2.1-0-devel-ubuntu22.04

MAINTAINER Jason Li <jasonli3@lsu.edu>

LABEL    software="Intel HPC kit + CUDA" \ 
    base_image="intel/hpckit:2024.2.1-0-devel-ubuntu22.04" \ 
    about.summary="Intel HPC kit (including Intel OneAPI compilers and pmi supported Intel MPI) and CUDA tool kits." \ 
    software.version="2024.2.1-0 (Intel) + 12.6 (CUDA)"


# Install CUDA driver and toolkit
WORKDIR /opt
#RUN apt update && apt -y install nvidia-driver-550
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb && dpkg -i cuda-keyring_1.1-1_all.deb && rm cuda-keyring_1.1-1_all.deb
RUN apt update && apt -y install cuda-12-6 && apt clean
ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH
#ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64:/usr/local/cuda-12.6/compat/:$LD_LIBRARY_PATH
