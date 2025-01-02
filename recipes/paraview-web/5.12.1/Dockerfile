FROM ubuntu:22.04

MAINTAINER Jason Li <jasonli3@lsu.edu>

LABEL    software="JAX" \ 
    about.summary="ParaViewWeb, is a Web framework to build applications with interactive scientific visualization inside the Web browser. Those applications can leverage a VTK and/or ParaView backend for large data processing and rendering." \ 
    software.version="5.12.1"

# Install dependencies
RUN apt update && apt install -y wget libgl1-mesa-dev libopenmpi-dev && apt clean

# Obtain ParaView headless package
WORKDIR /opt
RUN wget "https://www.paraview.org/paraview-downloads/download.php?submit=Download&version=v5.12&type=binary&os=Linux&downloadFile=ParaView-5.12.1-egl-MPI-Linux-Python3.10-x86_64.tar.gz" -O ParaView-5.12.1.tar.gz && tar -xf ParaView-5.12.1.tar.gz && rm ParaView-5.12.1.tar.gz

# Fix a bug that disconnect after refreshing
RUN sed -i '15d' /opt/ParaView-5.12.1-egl-MPI-Linux-Python3.10-x86_64/share/paraview-5.12/web/visualizer/www/index.html && sed -i '14d' /opt/ParaView-5.12.1-egl-MPI-Linux-Python3.10-x86_64/share/paraview-5.12/web/divvy/www/index.html

# Setup PATH
ENV PATH=/opt/ParaView-5.12.1-egl-MPI-Linux-Python3.10-x86_64/bin:$PATH