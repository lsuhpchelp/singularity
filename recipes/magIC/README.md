# MagIC 6.3 on SuperMike III

[MagIC](https://magic-sph.github.io) is a code for simulating fluid dynamics in a
spherical shell (geodynamo, convection). The `magic/6.3` module provides:

- `magic.exe`: MagIC built for MPI + OpenMP with SHTns, MKL and Intel oneAPI
- `python3`: Python with the MagIC post-processing module (`import magic`), numpy,
  scipy, matplotlib and basemap
- MagIC samples in `/opt/magic/samples` and a post-processing example script in
  `/opt/magic/examples/magic_postproc_example.py`. These paths are only
  visible to `magic.exe` and `python3`.

The example below runs the MagIC dynamo benchmark (Christensen et al. 2001, case 1)
on 4 MPI ranks and then makes plots with the MagIC python post-processing module.
It has been tested on SuperMike III.

## 1. Load the module and get the sample input

Start an interactive job first (`salloc`) and run all the steps below inside it.

```bash
module load magic/6.3

git clone https://github.com/magic-sph/magic
cd magic/samples/dynamo_benchmark
```

## 2. Adjust the input

```bash
# SHTns AVX-512 kernels need >= 32 latitudes; with l_max=16 this needs nalias=15
sed -i 's/nalias *=20/nalias      =15/' input.nml

# Run longer (to t=3) and write snapshots and spectra for the plots
sed -i -e 's/n_time_steps=1000/n_time_steps=30000/' \
       -e 's/n_log_step *=1,/n_log_step  =20,/' \
       -e 's/n_graphs *=1,/n_graphs    =4,\n n_specs     =4,/' input.nml
```

> **Why `nalias=15`?** MagIC uses `n_theta = 30*l_max/nalias` latitudes. The
> sample has `l_max=16, nalias=20`, which gives only 24 latitudes, and MagIC then stops with
> `nlat is too small! try setting nlat>=32`. Only very small grids
> (`l_max` < 22) hit this limit. Lowering `nalias` only makes the physical grid finer and keeps the spectral resolution unchanged.

## 3. Run MagIC

```bash
export SINGULARITYENV_OMP_NUM_THREADS=1     # 1 OpenMP thread per MPI rank
srun -n 4 magic.exe input.nml
```

A successful run ends with:

```
 !!! regular end of program MagIC !!!
  ...
  !---- THANK YOU FOR USING MAGIC ----!
```

The output files (`log.test`, `e_kin.test`, `e_mag_oc.test`, `G_*.test`,
`kin_spec_*.test`, `mag_spec_*.test`, ...) are written to the current directory.

> If the thread count is not set, each MPI rank starts one thread per core, and the
> node gets heavily oversubscribed. Check the line `Number of OMP threads:` near the top
> of `log.test`. For hybrid MPI + OpenMP runs, set `SINGULARITYENV_OMP_NUM_THREADS` equal to
> `--cpus-per-task`.

## 4. Post-process

Run this in the same directory:

```bash
python3 /opt/magic/examples/magic_postproc_example.py
```

Expected output:

```
f2py
reading ./kin_spec_4.test
reading ./mag_spec_4.test
Saved:
   figs/timeseries_energy.png
   figs/surf_Br_moll.png
   figs/surf_Br_ortho.png
   figs/equat_temperature.png
   figs/equat_vr.png
   figs/avg_Bphi.png
   figs/spectra_1.png
   figs/spectra_2.png
   figs/spectra_3.png
   figs/spectra_4.png
```

(The `f2py` line is printed by the `magic` module on import and can be ignored.)

| Figure | Content | MagIC class |
|---|---|---|
| `timeseries_energy.png` | kinetic and magnetic energy vs. time | `MagicTs` |
| `surf_Br_moll.png`, `surf_Br_ortho.png` | radial magnetic field at r = 0.9 r_o (Mollweide / orthographic) | `Surf.surf` + basemap |
| `equat_temperature.png`, `equat_vr.png` | temperature and radial velocity in the equatorial plane | `Surf.equat` |
| `avg_Bphi.png` | azimuthally averaged B_phi | `Surf.avg` |
| `spectra_1..4.png` | kinetic / magnetic energy spectra vs. degree l and order m | `MagicSpectrum` |

At t = 3 the benchmark is still in its initial transient, so the energies have not
reached the benchmark's saturated values yet. This run tests the setup only.

More details on post-processing: <https://magic-sph.github.io/postProc.html>.
