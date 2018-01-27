# Getting started

This document will try to explain how to build a functional
CKA system without diving too much in the system internals.

## Getting the code

The CKA repository is located at https://github.com/TheStr3ak5/CKA, 
from there you can clone it in your computer using git or download
a compressed image of the repository.

To clone the repository:

```shell
git clone https://github.com/TheStr3ak5/CKA.git
```

And to get a zip of the master branch from the command line:

```shell
curl -L -o CKA.zip https://github.com/TheStr3ak5/CKA/zipball/master
```

## Preparing the build environment

### Toolchains 

CKA, using command line arguments, can be built with different C
compilers and linkers. 
This have a requirement attached, chosen compilers and linkers must have 
a 'GCC like' flag system, in order to dont require further modification
into the makefiles to fit a new compiler.

Having this in mind, we recommend 2 options when choosing a toolchain:

- LLVM toolchain:

```shell
C compiler = clang
Linker = ld.lld-5.0
```
Consisting in Clang and lld, this will be the one used when no C compiler 
or linker is specified. This is the main toolchain used during development.

- GNU toolchain: Tested but have some inconsistencies with binutils ld.
If you want to use GNU utils, we recommend 2 options inside this one:

1:

```shell
C compiler = gcc (cross-compiler)
Linker = ld.lld-5.0
``` 

This one should work, but building a separate cross compiler is needed, if you
want to do this there are tons of tutorials in google for example.

2:

```shell
C compiler = gcc (cross-compiler)
Linker = ld (cross-compiler)
``` 

Only for brave people, this will lead to errors probably, but should be faster in
practice, you decide if you want to run the risk, an unbootable image or a fast
system.

### Getting the things

We will cover how to get the default utilities (clang and lld), the other ones
have tons of tutorial on internet if you want to use them.

#### Ubuntu
```shell
apt-get install clang-5.0 lldb-5.0
```

## Building CKA:

CKA should be built with the following command:

```shell
make all
```

This will build a x86_64 (amd64) UEFI image, using command line arguments you
will be able to output any arch you want or change the compilers, for example:

```shell
make all arch=amd64-uefi builddir=output ccompiler=gcc linker=ld.lld-5.0
```

The list of available flags is:

```shell
arch -> change target architecture, usage : arch=x , by default is amd64-uefi.
builddir -> change the output directory, usage : builddir=x , by default is output.
ccompiler -> change the C compiler, usage : ccompiler=x, by default is clang.
linker -> change the linker, usage : linker=x, by default is lld.
archiver -> change the archiver, usage : archiver=x, by default is llvm-ar.
objcopy -> change the objcopy program, usage : objcopy=x, by default is objcopy.
```

```
NOTE = if the arch is not available the makefile will fail, the flags can be used
as u want, you can call ccompiler and not linker for example.
```

More info about the build system can be found in the correspondent documentation.

You finished building CKA! The output image will be in the chosen output directory.

## Testing CKA

This will require QEMU and OVMF, that can be installed via your favorite package manager:

```shell
make test-qemu
```

## Cleaning the mess

THIS WILL REMOVE THE OUTPUT IMAGE IF YOU DONT SAVE IT.

To clean the source code and prepare it for another build, with the same or different
options:

```shell
make clean
```