#!/bin/bash
# This script prepares the download of octopus in the right location given the version number, location to untar / clone and install prefix
# example run:
# $ ./install_octopus.sh --version 13.0 --download_dir /opt/octopus --install_dir /home/user/octopus-bin --build_system autotools
# $ ./install_octopus.sh --version main --download_dir /opt/octopus --build_system cmake
# Consider running install_dependencies.sh first to install all the dependencies on a debian based system

# Function to display script usage
usage() {
  echo "Usage: $0 [--version <version_number>] [--download_dir <download_location>] [--install_dir <install_prefix>] [--build_system <autotools|cmake>]"
  echo "Options:"
  echo "  --version <version_number>      Specify the version number / branch name of Octopus (e.g., 13.0, main, test-branch-a)"
  echo "  --download_dir <download_location>   Specify the download location for Octopus source (default: current directory)"
  echo "  --install_dir <install_prefix>   Specify the install prefix for Octopus (default: /usr/local)"
  echo "  --build_system <autotools|cmake> Specify the build system to use (default: autotools)"
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
    --download_dir)
      location="$2"
      shift
      shift
      ;;
    --install_dir)
      prefix="$2"
      shift
      shift
      ;;
    --build_system)
      build_system="$2"
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


if [ -z "$location" ]; then
  echo "No download location provided, using current directory"
  location=$(pwd)
fi

if [ -z "$prefix" ]; then
  echo "No install prefix provided using default location"
  prefix="/usr/local"
fi

if [ -z "$build_system" ]; then
  echo "No build system provided, using autotools as default"
  build_system="autotools"
else
  if [ "$build_system" != "autotools" ] && [ "$build_system" != "cmake" ]; then
    echo "Invalid build system provided"
    usage
  fi
fi

## MAIN ##
# exit on error and print each command
set -xe
# make the location if it does not exist
mkdir -p "$location"

cd "$location"


# decide if we are using a branch from source or a release
# Rule: if the version number is numeric then it is a release (e.g., 13.0, 11.3, 14.1 etc.).
#       Anything else is then a branch (e.g., develop, test-branch-a, main etc.)
# then perform 3 steps:
# 1. download / clone  the source
# 2. unpack the source / checkout the branch
# 2. record the metadata of the source (release version / branch commit hash, date)

date=$(date)
if [[ $version =~ ^[0-9]+(\.[0-9]+)$ ]]; then
  echo "Downloading Octopus release version '$version'"
  # download the tar file
  wget https://octopus-code.org/download/${version}/octopus-${version}.tar.gz
  tar -xvf octopus-${version}.tar.gz
  mv octopus-$version/* .
  rm -rf octopus-$version
  # rm octopus-$version.tar.gz

  # Record which version we are using
  echo "octopus-source-version: $version " > octopus-source-version
  echo "octopus-source-download-date: $date " >> octopus-source-version
else
  echo "Cloning Octopus branch '$version'"
  git clone https://gitlab.com/octopus-code/octopus.git .
  git checkout $version

  # Record which version we are using
  git show > octopus-source-version
  echo "octopus-source-clone-date: $date " >> octopus-source-version
fi

# Force disable GPU by default. -Jason
# Explanation: GPU is not always advatangeous for current settings, but will be enabled by 
#    default if Octopus is compiled with CUDA. Forcing it to disable, and only enable when
#    user explicitly indicated.
sed -ie "s/'DisableAccel', default/'DisableAccel', .true./" src/basic/accel.F90


# Build octopus
if [ $build_system == "cmake" ]; then

  # Patch spglib packaging issues
  echo "Requires: spglib" >> /usr/lib/x86_64-linux-gnu/pkgconfig/spglib_f08.pc

  # Remove libxc CMake files because they are not packaged correctly
  rm -rf /usr/share/cmake/Libxc/

  # configure
  cmake --preset default -DOCTOPUS_OpenMP=ON -DOCTOPUS_MPI=ON -DOCTOPUS_ScaLAPACK=ON -G Ninja --install-prefix "$prefix"

  # check that no external libs are required
  # ls cmake-build-release/_deps

  # build
  cmake --build --preset default -j $(nproc)

  # TODO: test the build ( before clean)
  # ctest --test-dir cmake-build-release -L short-run -j $(nproc)  # check short
  # ctest --test-dir cmake-build-release -LE short-run -j $(nproc) # check long
  # ctest --test-dir cmake-build-release -j $(nproc) # check
  cmake --install cmake-build-release

  # clean build
  cmake --build cmake-build-release --target clean

elif [ $build_system == "autotools" ]; then
  mkdir _build
  pushd _build
  autoreconf -i ..

  # We need to set FCFLAGS_ELPA as the octopus m4 has a bug
  # see https://gitlab.com/octopus-code/octopus/-/issues/900
  export FCFLAGS_ELPA="-I/usr/include -I/usr/include/elpa/modules -fallow-argument-mismatch "
  # configure
  ../configure --enable-mpi --enable-openmp --enable-cuda --with-cuda-prefix=/usr/local/cuda --with-blacs="-lscalapack-openmpi" --prefix="$prefix"

  # Which optional dependencies are missing?
  cat config.log | grep WARN > octopus-configlog-warnings
  cat octopus-configlog-warnings

  # build
  make -j
  make install
  make clean
  make distclean
  popd
fi
