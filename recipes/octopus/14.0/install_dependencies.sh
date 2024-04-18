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
    libgmp-dev \
    libgsl-dev \
    liblapack-dev \
    liblapack-dev \
    libmpfr-dev \
    libnetcdff-dev \
    libnlopt-dev \
    libopenmpi-dev \
    libscalapack-mpi-dev \
    libspfft-dev \
    libtool \
    libxc-dev \
    libyaml-dev \
    openscad \
    openctm-tools \
    pkg-config \
    procps


# Add optional packages not needed by octopus (for visualization)
apt-get -y install gnuplot

# Add packages required to build via cmake
#apt-get -y install \
#    cmake ninja-build pkgconf \
#    libsymspg-dev libspglib-f08-dev
