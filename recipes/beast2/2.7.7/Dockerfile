FROM nvidia/cuda:12.6.1-devel-ubuntu22.04

MAINTAINER Jason Li <jasonli3@lsu.edu>

LABEL    software="BEAST 2" \ 
    about.summary="BEAST 2 is a cross-platform program for Bayesian phylogenetic analysis of molecular sequences. " \ 
    about.home="https://www.beast2.org/" \ 
    software.version="2.7.7"


# Install dependencies
RUN apt update
RUN apt install -y wget cmake build-essential autoconf automake libtool pkg-config openjdk-11-jdk

# Insall BEAGLE library
WORKDIR /opt
RUN wget https://github.com/beagle-dev/beagle-lib/archive/refs/tags/v4.0.1.tar.gz
RUN tar -xf v4.0.1.tar.gz && rm v4.0.1.tar.gz
RUN mkdir beagle-lib-4.0.1/build
WORKDIR beagle-lib-4.0.1/build
RUN cmake -DBUILD_OPENCL=OFF ..
RUN make -j`nproc` && make install
WORKDIR /opt
RUN rm -rf beagle-lib-4.0.1

# Get BEAST2
WORKDIR /opt
RUN wget https://github.com/CompEvol/beast2/releases/download/v2.7.7/BEAST.v2.7.7.Linux.x86.tgz
RUN tar -xf BEAST.v2.7.7.Linux.x86.tgz && rm BEAST.v2.7.7.Linux.x86.tgz
ENV PATH=/opt/beast/bin:$PATH

# Clean garage
RUN apt clean
