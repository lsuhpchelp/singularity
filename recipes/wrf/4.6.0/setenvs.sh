#! /bin/bash

# This file should no longer be needed. Just leave here for bookkeeping

# Compilation time
export CC=icx
export FC=ifx
export F90=ifx
export CXX=icpx
export LDFLAGS=-L/usr/local/lib
export CPPFLAGS=-I/usr/local/include

# Execution time
export NETCDF=/usr/local
export HDF5=/usr/local
export JASPERLIB=/usr/local/lib/
export JASPERINC=/usr/local/include/
export WRF_DIR=/opt/WRF
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
export PATH=$WRF_DIR/main:$WRF_DIR/WPS:/usr/local/bin:$PATH