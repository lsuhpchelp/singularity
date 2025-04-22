* More Information from this link: https://jsdokken.com/dolfinx-tutorial/fem.html
  
* How to build
  
`sudo singularity build fenics.sif fenics.def`

* example from this link: https://docs.fenicsproject.org/dolfinx/v0.9.0/python/demos/demo_poisson.html
* How to run (Here we are using two MPI processes, tested can use multiple nodes)
  
`srun -n2 singularity exec -B /work,/project ./fenics.sif python3 demo_poisson.py`
