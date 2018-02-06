# Takao internals

Takao, as any system, is divided in different parts with different functions that
collaborate between them with the finality of making a functional and efficient system.

In this document this parts will be explained in the surface without diving a lot in
all and without diving into programming concepts, as an introduction to the Takao internals.

As this is a simple and vague explanation of the parts of Takao, more complex
explanations can be found in the documentation.

## The architectures problem

Takao is designed to be ported to different structures with ease, but all architectures
offer different things that we just can't forget for the sake of efficiency, like
paging or different benefits that different firmwares provide, like UEFI and it's boot
services.

To be able to use this all, the project has been divided in 2 parts, the kernel and the
bootloader. The kernel has been divided too in different parts to accomplish our 
objective.

## The bootloader

This part of the kernel is the most chaotic one, since it's not standardized for now,
this means that the bootloader can do practically what they want to in order to boot
the kernel.

The only restriction they have is that they need to pass the same information to the 
kernel in the same format, no matter the host architecture, 
for the moment this information is passed in a structure since bootloader and kernel 
are linked together, but in the future this may change with a separate bootloader for
example.

## The kernel

The kernel is divided in several parts:

### The architecture dependent kernel:

All the things that will depend on the architecture of the host system.

Here happens something similar to the bootloader, since this is part is not 
standardized since different architectures will require different things, but with
a big difference, the functions that the kernel directly use, like the ones refereed
to memory management that are absolutely architecture dependent are called using
the same arguments, no matter the architecture.

Doing this, we ensure that the behavior of the functions and the calling is the same,
no matter the host architecture.

### The common/main kernel:

This part is the main kernel and all the things that don't depend in the host
architecture, following the same 'function rules' than in the architecture dependent
kernel. 
