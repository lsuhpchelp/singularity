FROM tensorflow/tensorflow:2.15.0.post1-gpu-jupyter

MAINTAINER Jason Li <jasonli3@lsu.edu>

LABEL    software="JAX" \ 
    base_image="tensorflow/tensorflow:2.15.0.post1-gpu-jupyter" \ 
    container="JAX" \ 
    about.summary="JAX is NumPy on the CPU, GPU, and TPU, with great automatic differentiation for high-performance machine learning research." \ 
    about.home="https://github.com/google/jax" \ 
    software.version="0.4.24"

RUN apt update
RUN apt install -y qtbase5-dev qt5-qmake
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
RUN pip install -U "jax[cuda12_pip]" -f https://storage.googleapis.com/jax-releases/jax_cuda_releases.html

RUN apt clean
RUN pip cache purge
