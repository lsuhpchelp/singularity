FROM pytorch/pytorch:2.6.0-cuda12.4-cudnn9-runtime

MAINTAINER Jason Li <jasonli3@lsu.edu>

LABEL    software="PyTorch" \ 
    base_image="pytorch/pytorch:2.6.0-cuda12.4-cudnn9-runtime" \ 
    container="PyTorch" \ 
    about.summary="PyTorch framework for deep learning, with GPU support, QT support, commonly used Python modules such as jupyter." \ 
    about.home="https://pytorch.org/" \ 
    software.version="2.6.0"

RUN apt update
RUN apt install -y qtbase5-dev qt5-qmake libmpich-dev && apt clean
RUN pip install matplotlib \
                pyqt5 \
                jupyterlab \
                Cython \
                dask \
                nltk \
                mpi4py \
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
                tqdm  &&  pip cache purge
                