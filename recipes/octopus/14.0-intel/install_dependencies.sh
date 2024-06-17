#!/bin/bash
# This script installs all the dependencies needed for octopus
# It is assumed that the script is run as root
# example run:
# $ sudo bash install_dependencies.sh

# exit on error and print each command
set -xe

# Convenience tools
apt update
apt -y install wget vim autoconf libtool

# Add optional packages not needed by octopus (for visualization)
apt -y install gnuplot

# Install CUDA driver and toolkit
apt -y install nvidia-driver-550
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb
dpkg -i cuda-keyring_1.1-1_all.deb
apt update
apt -y install cuda
rm cuda-keyring_1.1-1_all.deb

# Following dependencies are compiled manually w/ Intel OneAPI because apt installed ones
# are not in conventional directories and having trouble to be found by Intel compilers

# 1. Install FFTW (3.3.10):
wget http://fftw.org/fftw-3.3.10.tar.gz && tar xf fftw-3.3.10.tar.gz && cd fftw-3.3.10
./configure CC=icx F77=ifx MPICC=mpiicx MPICXX=mpiicpx MPIFC=mpiifx --enable-mpi --enable-openmp
make -j`nproc` && make install
cd .. && rm -rf fftw*

# 2. Instal gsl (2.7.1)
wget https://mirror.ibcp.fr/pub/gnu/gsl/gsl-latest.tar.gz && tar xf gsl-latest.tar.gz && cd gsl-2.7.1/
./configure CC=icx CXX=icpx FC=ifx -disable-shared --enable-static
make -j`nproc` && make install
cd .. && rm -rf gsl*

# 3. Install libxc (6.2.2):
wget https://gitlab.com/libxc/libxc/-/archive/6.2.2/libxc-6.2.2.tar.gz && tar xf libxc-6.2.2.tar.gz && cd libxc-6.2.2
autoreconf -i && ./configure CC=icx CXX=icpx FC=ifx --prefix=/usr/local
make -j`nproc` && make check && make install
cd .. && rm -rf libxc*

# Add packages required to build via cmake
# Disabled for GPU support. CUDA base image only supports Ubuntu up to 22.04, 
#   and "libspglib-f08-dev" required by cmake is not supported as of Apr 2024. -Jason
#apt-get -y install \
#    cmake ninja-build pkgconf \
#    libsymspg-dev libspglib-f08-dev

# Clean up
apt clean
