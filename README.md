P4-in-a-Bottle
==============

Ready to use P4 tutorial container.


What is This?
-------------

P4-in-a-Bottle is a simple container workspace intended to replace the
[P4 Guide](https://github.com/jafingerhut/p4-guide) Ubuntu VMs. As of
2023-05-17, It contains all the tools provided in its Ubuntu 23.04 VM.


Why?
----

The provided image in the P4 Guide is specific to VirtualBox, its not the
easiest thing in the world to get it working with libvirt/QEMU/KVM. I thought
I might as well take it a step further ane make it NOT a VM at all. Having
this container also has a few other advantages:

1. It has less overhead than the original VM image.
2. It can run with a variety of setups: Docker, Podman, K8S, OpenShift, etc...
3. It can be used as a basis for other P4 runtime testing suites.
4. It's much smaller than a VM image.
5. When converted into a singularity container, it can be launched as a single
   binary executable.

How to Use
----------

There are two ways of launching P4-in-a-Bottle:

### Singularity

Singularity is a container runtime by Sylabs developed specificly for software
that require low-level access to hardware (i.e. NVIDIA drivers, network
devices). This is great for P4-in-a-Bottle, since Mininet requires access to
networking kernel components to work.

Unfortunately, Singularity only works natively on Linux, so if you're on Mac or
Windows (without WSL), you're out-of-luck here and should proceed to the docker
instructions below.

To use P4-in-a-Bottle with Singularity:
0. Clone this repository if you haven't done so already.
1. Install singularity from [GitHub](https://github.com/sylabs/singularity/releases).
2. Download a pre-built image
   [p4iab.sif](https://git.inkweaver.net/inkweaver/P4-in-a-Bottle/releases)
   and place it in the same directory alongside `README.md`. If you skip this
   step YOU WILL BUILD BOTH THE DOCKER CONTAINER AND THE SINGULARITY CONTAINER
   FROM SOURCE. (Trust me, you do NOT want to build this yourself).
3. Run `make sc-run`. A shared directory `shared/` will be created to allow
   you to move files between the container and your system.

### Docker

If you are stuck with docker, don't panic! The instructions are longer but
everything should still work.
0. Clone this repository if you haven't done so already.
1. Install docker on your system. This should be pretty self-explanatory.
2. Download a pre-built image
   [p4iab.tar.gz](https://git.inkweaver.net/inkweaver/P4-in-a-Bottle/releases)
   and place it in the same directory alongside `README.md`. Then run
   `docker load -i p4iab.tar.gz && touch .docker_build`.
   If you skip this step YOU WILL BUILD THE DOCKER CONTAINER FROM SOURCE. Do
   so only if you know what you are doing.
3. Run `make run`. A shared directory `shared/` will be created to allow
   you to move files between the container and your system.


Building from Source
--------------------

To those who are building from source, note that this WILL take a significant
amount of time and space to build. If possible, use a pre-built image instead.

Build commands:

```bash
# Building a docker image for local use
$ make .docker_build

# Building a docker image that can be imported on other machines
$ make p4iab.tar.gz

# Building a singularity image (This depends on the docker image)
$ make p4iab.sif

# Cleanup any cached artifacts
$ make clean
```

