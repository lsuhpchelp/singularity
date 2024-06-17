Repository for running (and if desired building) the
`OCTOPUS code <http://octopus-code.org>`__ package in a Docker container.

Use case: run Octopus (for small calculations and tutorials) conveniently in a
container, in particular on MacOS and Windows where compilation of Octopus may be non trivial.

Octopus versions 12.0 and more recent are
`available as Docker images <https://hub.docker.com/r/fangohr/octopus/tags>`__ for Intel (AMD64)
and M1/M2/M3 (ARM64) processors.


Octopus in Docker container
===========================

Quick start
-----------


1. `Install docker <https://docs.docker.com/get-docker/>`__ on your machine.

   Check to confirm: run ``docker --version``. Expected output is something like this::

     $ docker --version
     Docker version 20.10.12, build e91ed57

2. Change into the directory that contains your ``inp`` file.


3. Then run::

    docker run --rm -ti -v $PWD:/io fangohr/octopus octopus

   The first time you run this, Docker needs to download the image
   ``fangohr/octopus`` from DockerHub. This could take a while (depending on your
   internet connection, the image size is about 900MB). If we do not specify a version,
   docker will download the
   `image that is tagged as "latest" <https://hub.docker.com/r/fangohr/octopus/tags?page=1&name=latest>`__

   Meaning of the switches:

   - ``--rm`` remove docker container after it has been carried out (good practice to reduce disk usage).
   - ``-ti`` start an Interactive  pseudo-Tty shell in the container
   - ``-v $PWD:/io``: take the current working directory (``$PWD``) and mount it
     in the container in the location ``/io``. This is also the default working
     directory of the container.
   - ``fangohr/octopus`` is the name of the container image. The next
   - ``octopus`` is the name of the executable to run in the container. You can
     replace this with ``bash`` if you want to start octopus manually from inside
     the container.

   This is tested and known to work on macOS and Windows. On Linux, there is a
   permissions issue if (numerical) user id on the host system and in the
   container deviate.

   To check which Octopus version you have in the container, you can use::

      docker run --rm -ti -v $PWD:/io fangohr/octopus octopus --version

   If you want to use multiple MPI processes (for example 4), change the above line to::

       docker run --rm -ti -v $PWD:/io fangohr/octopus mpirun -np 4 octopus

   If you want to use a different Octopus version you can check the `available
   versions <https://hub.docker.com/r/fangohr/octopus/tags>`__, and then add the
   version (for example `13.0`) to the Docker image in the command line::

      docker run --rm -ti -v $PWD:/io fangohr/octopus:13.0 octopus --version

Typical workflow with Octopus in container
------------------------------------------

- edit your ``inp`` file and save it  (on the host computer)

- call Octopus (in the container) by running ::

      docker run --rm -ti -v $PWD:/io fangohr/octopus octopus

  Only the ``octopus`` command will be carried out in the
  container. Any output files are written to the current directory on the host.

- carry out data analysis on the host

If you want to work interactively *inside* the container, replace the name of the executable with ``bash``::

  docker run --rm -ti -v $PWD:/io fangohr/octopus bash

You are then the root user in the container. Octopus was compiled in ``/opt/octopus*``. There are also some trivial example input files in ``/opt/octopus-examples``.

What follows is more detailed documentation which is hopefully not needed for most people.



Documentation for advanced users and developers
===============================================

.. sectnum::

.. contents::


Introduction
------------

If you have difficulties compiling Octopus, it might be useful to be able to run
it in a container (for example on Windows or macOS).

The container provides a mini (Linux) Operating system, in which we can compile
Octopus using a recipe (this is the Dockerfile, see below).

One can then use the editor and analysis tools of your normal operating system
and computer, and carry out the running of the actual Octopus calculations
inside the container.

There are two steps required:

- Step 1: build the Docker image (only once) or download it (only once). For
  downloading a pre-compiled Docker image and using that, please see
  instructions above "Quick Start".

- Step 2: use Docker to execute Octopus inside the Docker container.

Build the Docker image on your computer
---------------------------------------

In this repository we provide a `Dockerfile <Dockerfile>`__ to compile Octopus
inside a Docker container.

To do this, first clone this repository. Then run::

  docker build -f Dockerfile --build-arg VERSION_OCTOPUS=14.0 -t octimage

to build Octopus version ``14.0`` in the container and create the Docker image with name ``octimage``.

To use the current development version of Octopus (from the `gitlab repository
<https://gitlab.com/octopus-code/octopus>`__), use ``VERSION_OCTOPUS=develop``
instead of ``VERSION_OCTOPUS=14.0``. Omitting the ``VERSION_OCTOPUS`` argument
will by default pick the ``develop`` version.

This will take some time to complete. (On Linux, you may need to prefix all
docker calls with ``sudo``.)

Use the Docker image
--------------------

To use the Docker image::

  docker run --rm -ti -v $PWD:/io octimage octopus

See Quick start section above for more details.


Information for developers: available architectures
---------------------------------------------------

The DockerHub images are available for x86 (AMD64) and M1/M2/M3 (ARM64)
architectures. Docker will download the correct one automatically. (You can use
``docker inspect fangohr/octopus | grep Arch`` to check the architecture
for which you have the image available on your machine,
or use ``uname -m`` inside the container.)


.. |stable| image:: https://github.com/fangohr/octopus-in-docker/actions/workflows/stable.yml/badge.svg
   :target: https://github.com/fangohr/octopus-in-docker/actions/workflows/stable.yml

.. |develop| image:: https://github.com/fangohr/octopus-in-docker/actions/workflows/develop.yml/badge.svg
   :target: https://github.com/fangohr/octopus-in-docker/actions/workflows/debian-develop.yml

CMAKE or autotools as the configuration and build system
--------------------------------------------------------
Octopus from 14.0 onwards supports CMake as a build system. The Dockerfile uses the build arg ``BUILD_SYSTEM`` to specify the build system.
The default value is ``autotools``. If you want to use CMake as the build system, then pass ``--build-arg BUILD_SYSTEM=cmake`` to the ``docker build`` command.
Alternatively, you can set the environment variable ``BUILD_SYSTEM`` to ``cmake``. For eg:
```
make stable BUILD_SYSTEM=cmake
```

Status
======

Status of building the Docker images:

|stable| Debian Bookworm (12), Latest Octopus release (14.0)

|develop| Debian Bookworm (12), Octopus develop branch

