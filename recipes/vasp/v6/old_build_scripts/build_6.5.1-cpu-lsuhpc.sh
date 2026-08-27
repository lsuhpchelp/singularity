#!/bin/bash
sudo singularity build --build-arg CLUSTER_SUFFIX=lsuhpc \
  /project/containers/images/vasp-6.5.1_lic-cpu.impi.sif vasp-6.5.1_lic-cpu.impi.def

