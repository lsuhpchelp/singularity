# HybPiper

HybPiper is a suite of Python scripts that wrap and organize bioinformatics tools for target sequence extraction from high-throughput sequencing reads. 

The code can be found here:
[https://github.com/mossmatters/HybPiper](https://github.com/mossmatters/HybPiper)

In the Singularity image, HybPiper is installed under /opt/HybPiper. To run the main script `reads_first.py`, the command should be:

`singularity exec -B <paths to bind> <path to the Singularity image> python /opt/HybPiper/reads_first.py <options>`

For instance, on the LSU HPC SuperMIC cluster, the command looks like this:

`singularity exec -B /work,/project /home/admin/singularity/hybpiper-1.2-centos7.sif python /opt/HybPiper/reads_first.py -b test_targets.fasta -r EG30_R*_test.fastq --prefix EG30 --bwa`
