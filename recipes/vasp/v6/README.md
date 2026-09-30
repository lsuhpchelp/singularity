# VASP 6 container recipes

This directory contains Singularity/Apptainer definition files for building VASP 6 images. The names identify the VASP version, CPU or GPU target, and toolchain: `impi` uses Intel oneAPI/Intel MPI, while `nvhpc` uses the NVIDIA HPC SDK and Open MPI.

| Recipe | Purpose |
| --- | --- |
| [`vasp-6.5.1-cpu.impi.def`](vasp-6.5.1-cpu.impi.def) | Legacy VASP 6.5.1 CPU build using Intel oneAPI/Intel MPI. |
| [`vasp-6.5.1-gpu.nvhpc.def`](vasp-6.5.1-gpu.nvhpc.def) | Legacy VASP 6.5.1 GPU build using NVIDIA HPC SDK and Open MPI. |
| [`vasp-6.5.1_lic-cpu.impi.def`](vasp-6.5.1_lic-cpu.impi.def) | VASP 6.5.1 CPU build with automatic personal license validation. |
| [`vasp-6.5.1_lic-gpu.nvhpc.def`](vasp-6.5.1_lic-gpu.nvhpc.def) | VASP 6.5.1 GPU build with automatic personal license validation. |
| [`vasp-6.6.1-cpu.impi.def`](vasp-6.6.1-cpu.impi.def) | Standard VASP 6.6.1 CPU build with HDF5 and automatic license validation. |
| [`vasp-6.6.1-gpu.nvhpc.def`](vasp-6.6.1-gpu.nvhpc.def) | Standard VASP 6.6.1 GPU build with HDF5 and automatic license validation. |
| [`vasp-6.6.1.tpc-cpu.impi.def`](vasp-6.6.1.tpc-cpu.impi.def) | VASP 6.6.1 CPU build with HDF5, Wannier90, DFT-D4, VTST, VASPsol, Libxc, and libbeef. It also includes automatic license validation. |
| [`vasp-6.6.1.tpc-gpu.nvhpc.def`](vasp-6.6.1.tpc-gpu.nvhpc.def) | VASP 6.6.1 GPU build with HDF5, Wannier90, and VTST, plus automatic license validation. It does **not** include every integration in the CPU TPC recipe. |

The `_lic` suffix distinguishes the VASP 6.5.1 recipes with built-in license validation from the older 6.5.1 recipes. All VASP 6.6.1 recipes here include that validation even though their filenames do not contain `_lic`. The validating recipes accept `CLUSTER_SUFFIX=lsuhpc` or `lonihpc` at build time and use the cluster's revoked-keys file at runtime.

[`build_vasp.sh`](build_vasp.sh) is a wrapper that chooses a recipe and output image for a requested version, CPU/GPU target, and site. Its current filename pattern matches the 6.5.1 `_lic` standard recipes; the 6.6.1 and `tpc` filenames in this directory use different patterns, so those builds require selecting the `.def` file directly or updating the wrapper.

These recipes require the licensed VASP source archives referenced in their `%files` sections. This README covers only the files directly in this directory.
