#!/bin/bash
singularity build --build-arg CLUSTER_SUFFIX=lonihpc \
  /project/containers/images/vasp-6.5.1_lic-gpu.nvhpc.sif vasp-6.5.1-gpu.nvhpc.def
