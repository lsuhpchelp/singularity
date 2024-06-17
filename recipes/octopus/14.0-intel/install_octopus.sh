#!/bin/bash

##########################################################
# Options
##########################################################

# Function to display script usage
usage() {
  echo "Usage: $0 [--version <version_number>] [--prefix <install_prefix>]"
  echo "Options:"
  echo "  --version <version_number>      Specify the version number / branch name of Octopus (e.g., 14.0)"
  echo "  --prefix <install_prefix>       Specify the install prefix for Octopus (default: /usr/local)"
  echo "  -h, --help                      Display this help message"
  exit 1
}

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    --version)
      version="$2"
      shift
      shift
      ;;
    --prefix)
      prefix="$2"
      shift
      shift
      ;;
    -h|--help)
      usage
      ;;
    *)
      echo "Invalid option: $1"
      usage
      ;;
  esac
done

# Check if the version number and location is provided
if [ -z "$version" ]; then
  echo "No version number provided"
  usage
fi


if [ -z "$prefix" ]; then
  echo "No install prefix provided using default location"
  prefix="/usr/local"
fi


##########################################################
# Main
##########################################################

# Exit on error and print each command
set -xe

# Set paths
#export COMPDIR=/opt/intel/oneapi/mpi/latest/bin
export MKLDIR=/opt/intel/oneapi/mkl/latest/lib/intel64

# Download
echo "Downloading Octopus release version '$version'"
wget https://octopus-code.org/download/${version}/octopus-${version}.tar.gz
tar -xvf octopus-${version}.tar.gz
rm octopus-$version.tar.gz
cd octopus-$version

# Force disable GPU by default. -Jason
# Explanation: GPU is not always advatangeous for current settings, but will be enabled by 
#    default if Octopus is compiled with CUDA. Forcing it to disable, and only enable when
#    user explicitly indicated.
sed -ie "s/'DisableAccel', default/'DisableAccel', .true./" src/basic/accel.F90

# Build octopus
autoreconf -i
  # We need to set FCFLAGS_ELPA as the octopus m4 has a bug
  # see https://gitlab.com/octopus-code/octopus/-/issues/900
CC=mpiicx FC=mpiifx CXX=mpiicpx CFLAGS="-O3" CXXFLAGS="-O3" FCFLAGS_ELPA="-I/usr/include -I/usr/include/elpa/modules" \
  ./configure --enable-mpi --enable-openmp --enable-cuda --with-cuda-prefix=/usr/local/cuda \
    --with-blas="-L$MKLDIR -Wl,-Bstatic -Wl,--start-group -lmkl_intel_lp64 -lmkl_sequential -lmkl_core -Wl,--end-group -Wl,-Bdynamic -lpthread -lm -ldl"  \
    --with-blacs="-L$MKLDIR -Wl,-Bstatic -lmkl_blacs_intelmpi_lp64"  \
    --with-scalapack="-L$MKLDIR -Wl,-Bstatic -lmkl_scalapack_lp64"  \
    --prefix="$prefix"
make -j`nproc`
make install
cd .. && rm -rf octopus-$version
