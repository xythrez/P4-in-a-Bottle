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
5. When converted into a Apptainer SIF, it can be launched as a single binary
   executable.

User Tools
----------

The containers are built with several additional user tools already in place,
including but not limited to:

1. `vim`/`emacs`: text editing.
2. `git`: version control.
3. `tmux`: terminal multiplexing.
3. `tshark`/`termshark`/`tcpdump`: packets inspection.
4. `htop`: visual overview of processes.
5. `man`/`less`: documentation support.

How to Use
----------

There are two ways of launching P4-in-a-Bottle:

### Apptainer

Apptainer is a new container runtime developed specificly for software that
require low-level access to hardware (i.e. NVIDIA drivers, network devices,
etc). This is great for P4-in-a-Bottle, since Mininet requires access to
networking kernel components to work.

Unfortunately, Apptainer only works natively on Linux, so if you're on Mac or
Windows (without WSL), you're out-of-luck here and should proceed to the docker
instructions below.

To use P4-in-a-Bottle with Apptainer:
1. Install Apptainer from [GitHub](https://github.com/apptainer/apptainer/releases).
2. Clone and cd into this repository.
3. Download a pre-built image
   [p4iab.sif](https://git.inkweaver.net/inkweaver/P4-in-a-Bottle/releases)
   and place it in the same directory alongside `README.md`.
4. Run `make app-run`. A shared directory `shared/` will be created to allow
   you to move files between the container and your system.

### Docker

If you are stuck with docker, don't panic! The instructions are slightly more
complicated but everything should still work.
1. Install docker on your system. This should be pretty self-explanatory.
2. Clone and cd into this repository.
3. Download a pre-built image
   [p4iab.tar.gz](https://git.inkweaver.net/inkweaver/P4-in-a-Bottle/releases)
   and place it in the same directory alongside `README.md`.
4. Run `docker load -i p4iab.tar.gz` to import the container into docker.
5. Run `make run`. A shared directory `shared/` will be created to allow
   you to move files between the container and your system.

Regardless of which method you run the container, you will be dropped into a
shell with the user P4. The password for the P4 user account is simply `p4`.


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

# Building a Apptainer image (This depends on the docker image)
$ make p4iab.sif

# Cleanup any cached artifacts
$ make clean
```

Once you have either `p4iab.tar.gz` or `p4iab.sif`, proceed to follow the
instructions in the "How to Use" section from step 4.

