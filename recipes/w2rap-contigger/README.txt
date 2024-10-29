This is the recipe used to build the singularity container for w2rap-contigger.
If you make any changes to source code, you may need to build the image again.

After the image is built, you can run the image both interactively and in the batch job.

================================================
Interactive:

1. Start an interactive job from the head node. Make sure you are on the compute node when you run singularity.
2. You can run any coawst command like this (type this command in terminal prompt on the compute node),
   "singularity exec -B /home,/work,/project w2rap_contigger.sif <command>"
   OR
   start a shell into the cintainer image, basically you will be inside the container
   "singularity shell -B /home,/work,/project w2rap_contigger.sif"
   Once you shell into the image using the command above, you will observe a new prompt. Then you can run any
   coawst commands as usual.

================================================
Batch:

1. Prepare the job submission script as usual.
2. To run any coawst commands, add this line
   "singularity exec coawst.sif <command>"


NOTE: In case of any problems, email to sys-help@loni.org

