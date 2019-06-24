# Takao

![forthebadge](https://forthebadge.com/images/badges/contains-cat-gifs.svg)

Welcome to the Takao source code! Development branch!

# Building

To build the kernel, run `./configure`, it will guide thru the rest of building.
To put it in a nutshell, it will explain how to configure the build, prepare the
environment and signal the required `make` commands

# Requirements

* `bash`, `zsh` or another POSIX compliant shell that answers as `/bin/sh`.
* `make`, or any POSIX alternative, mind it for the commands!
* `ldc` and `lld`, both are refered as `ldc2` and `ld.lld`, as these are the
most common names for them, but in systems like FreeBSD this is not true, this
can be changed by prefixing the `./configure` commands with `DC=<ldc name>` and
`LD=<lld name>`.
