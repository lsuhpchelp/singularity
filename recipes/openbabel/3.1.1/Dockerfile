FROM ubuntu:22.04

MAINTAINER Jason Li <jasonli3@lsu.edu>

LABEL    software="OpenBabel" \ 
    base_image="ubuntu:22.04" \ 
    about.summary="Open Babel is a chemical toolbox designed to speak the many languages of chemical data. It’s an open, collaborative project allowing anyone to search, convert, analyze, or store data from molecular modeling, chemistry, solid-state materials, biochemistry, or related areas." \ 
    about.home="https://openbabel.org/" \ 
    software.version="3.1.1"

RUN apt update
RUN apt install -y openbabel=3.1.1* openbabel-gui=3.1.1*
RUN apt clean
