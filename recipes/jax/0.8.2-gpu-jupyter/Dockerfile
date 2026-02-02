FROM ubuntu:24.04

MAINTAINER Jason Li <jasonli3@lsu.edu>

LABEL    software="JAX" \ 
    base_image="ubuntu:24.04" \ 
    container="JAX" \ 
    about.summary="JAX is NumPy on the CPU, GPU, and TPU, with great automatic differentiation for high-performance machine learning research." \ 
    about.home="https://github.com/google/jax" \ 
    software.version="0.8.2"

# Install dependencies (MPI and QT backend)
RUN apt update
RUN DEBIAN_FRONTEND=noninteractive apt install -y wget libmpich-dev qt6-base-dev qt6-tools-dev libxcb-cursor0 libxkbcommon-x11-0 libxcb-icccm4 libxcb-image0 libxcb-keysyms1 libxcb-render-util0 libxcb-xinerama0 libxcb-xinput0 libxcb-shape0 && apt clean

# Install Miniforge
WORKDIR /opt
RUN wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh && \
    bash Miniforge3-Linux-x86_64.sh -b -p /opt/miniforge3/ && \
    rm Miniforge3-Linux-x86_64.sh && \
    /opt/miniforge3/bin/conda init bash && \
    . /opt/miniforge3/bin/activate
ENV PATH /opt/miniforge3/bin:$PATH
    
# Install Tensorflow and other common packages
RUN pip install jax[cuda13]==0.8.2
RUN pip install matplotlib \
            pyqt5 \
            jupyterlab \
            Cython \
            dask \
            mpi4py \
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
            tqdm  &&  pip cache purge