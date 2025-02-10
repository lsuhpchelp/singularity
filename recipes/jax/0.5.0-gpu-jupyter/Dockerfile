FROM ubuntu:22.04

MAINTAINER Jason Li <jasonli3@lsu.edu>

LABEL    software="JAX" \ 
    base_image="ubuntu:22.04" \ 
    container="JAX" \ 
    about.summary="JAX is NumPy on the CPU, GPU, and TPU, with great automatic differentiation for high-performance machine learning research." \ 
    about.home="https://github.com/google/jax" \ 
    software.version="0.5.0"

# Install dependencies
RUN apt update
RUN apt install -y wget qtbase5-dev qt5-qmake python3-dev pip libmpich-dev && apt clean
RUN ln -s /usr/bin/python3 /usr/bin/python 

# Install JAX
RUN pip install -U "jax[cuda12]"==0.5.0 -f https://storage.googleapis.com/jax-releases/jax_cuda_releases.html

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
                tqdm  && pip cache purge