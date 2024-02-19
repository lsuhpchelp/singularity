FROM ubuntu:22.04

MAINTAINER Jason Li <jasonli3@lsu.edu>

LABEL    software="JAX" \ 
    base_image="ubuntu:22.04" \ 
    container="JAX" \ 
    about.summary="JAX is NumPy on the CPU, GPU, and TPU, with great automatic differentiation for high-performance machine learning research." \ 
    about.home="https://github.com/google/jax" \ 
    software.version="0.4.23"

# Update apt
RUN apt update
RUN apt install -y wget qtbase5-dev qt5-qmake

# Install miniconda
WORKDIR /opt
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
RUN chmod u+x Miniconda3-latest-Linux-x86_64.sh
RUN ./Miniconda3-latest-Linux-x86_64.sh -b -p /opt/conda
RUN rm Miniconda3-latest-Linux-x86_64.sh

# Install jax
ENV PATH=/opt/conda/bin:$PATH
RUN CONDA_OVERRIDE_CUDA=12.3 conda install -y jaxlib=0.4.23=*cuda* jax cuda-nvcc -c conda-forge -c nvidia

# Install additional packages
RUN pip install pyqt5 \
                jupyterlab \
                Cython \
                dask \
                nltk \
                numba \
                numexpr \
                pandas \
                regex \
                seaborn \
                scikit-image \
                scikit-learn \
                scikit-learn-intelex \
                scipy \
                statsmodels \
                sympy \
                tqdm 

# Clean cache
RUN apt clean
RUN pip cache purge
RUN conda clean -a -y
