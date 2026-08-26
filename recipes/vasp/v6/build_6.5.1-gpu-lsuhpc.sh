#!/bin/bash
singularity build --build-arg CLUSTER_SUFFIX=lsuhpc \
  /project/containers/images/vasp-6.5.1_lic-gpu.nvhpc.sif vasp-6.5.1-gpu.nvhpc.def

