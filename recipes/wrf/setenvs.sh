# Compilation time
export CC=icx
export FC=ifx
export F90=ifx
export CXX=icpx

# Execution time
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
export PATH=/usr/local/bin:$PATH
export LDFLAGS=-L/usr/local/lib
export CPPFLAGS=-I/usr/local/include

export NETCDF=/usr/local
export HDF5=/usr/local
export JASPERLIB=/usr/local/lib/
export JASPERINC=/usr/local/include/
