FROM ubuntu:22.04

MAINTAINER Jason Li <jasonli3@lsu.edu>

LABEL    software="OpenBabel" \ 
    base_image="ubuntu:22.04" \ 
    about.summary="A DSL for data-driven computational pipelines." \ 
    about.home="https://www.nextflow.io/" \ 
    software.version="23.10.1"

RUN apt update
RUN apt install -y default-jdk curl
WORKDIR /usr/local/bin
RUN curl -sL https://github.com/nextflow-io/nextflow/releases/download/v23.10.1/nextflow | bash
RUN chmod 755 nextflow
RUN apt clean
ENV NXF_JAVA_HOME /usr
