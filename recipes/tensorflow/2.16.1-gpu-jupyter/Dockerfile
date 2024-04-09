FROM tensorflow/tensorflow:2.16.1-gpu-jupyter

MAINTAINER Jason Li <jasonli3@lsu.edu>

LABEL    software="Tensorflow" \ 
    base_image="tensorflow:2.16.1-gpu-jupyter" \ 
    container="Tensorflow" \ 
    about.summary="Tensorflow framework for deep learning, with GPU support, QT support, commonly used Python modules such as jupyter." \ 
    about.home="https://www.tensorflow.org/" \ 
    software.version="2.16.1"

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

RUN apt clean
RUN pip cache purge
