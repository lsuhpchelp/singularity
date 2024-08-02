#!/bin/bash
# This script installs all the dependencies needed for octopus
# It is assumed that the script is run as root
# example run:
# $ sudo bash install_dependencies.sh

# exit on error and print each command
set -xe

# Convenience tools (up to emacs)
# Libraries that octopus needs
# and optional dependencies (in alphabetical order)
apt-get -y update

apt-get -y install wget time nano vim emacs \
    autoconf \
    automake \
    build-essential \
    g++ \
    gcc \
    gfortran \
    git \
    libatlas-base-dev \
    libblas-dev \
    libboost-dev \
    libcgal-dev \
    libelpa-dev \
    libetsf-io-dev \
    libfftw3-dev \
    libfftw3-mpi-dev \
    libgmp-dev \
    libgsl-dev \
    liblapack-dev \
    liblapack-dev \
    libmpfr-dev \
    libnetcdff-dev \
    libnlopt-dev \
    libscalapack-mpi-dev \
    libspfft-dev \
    libtool \
    libxc-dev \
    libyaml-dev \
    openscad \
    openctm-tools \
    pkg-config \
    procps
#    libopenmpi-dev \


# Add optional packages not needed by octopus (for visualization)
apt-get -y install gnuplot

# Install OpenMPI w/ PMI2
apt-get install -y build-essential
apt-get install -y wget hwloc libpmi2-0 libpmi2-0-dev
wget https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-4.1.2.tar.gz
tar zxvf openmpi-4.1.2.tar.gz && rm openmpi-4.1.2.tar.gz
cd openmpi-4.1.2
./configure --with-hwloc=internal --with-slurm \
    --with-pmi=/usr --with-pmi-libdir=/usr/lib/x86_64-linux-gnu --without-verbs
make -j $(nproc)
make install
cd .. && rm -rf openmpi-4.1.2

# Add packages required to build via cmake
# Disabled for GPU support. CUDA base image only supports Ubuntu up to 22.04, 
#   and "libspglib-f08-dev" required by cmake is not supported as of Apr 2024. -Jason
#apt-get -y install \
#    cmake ninja-build pkgconf \
#    libsymspg-dev libspglib-f08-dev

# Clean up
apt clean
