# Getting started

This document will try to explain how to build a functional
Takao system without diving too much in the system internals.

## Getting the code

The Takao repository is located at https://github.com/TheStr3ak5/Takao, 
from there you can clone it in your computer using git or download
a compressed image of the repository.

To clone the repository:

```shell
git clone https://github.com/TheStr3ak5/Takao.git
```

And to get a zip of the master branch from the command line:

```shell
curl -L -o takao.zip https://github.com/TheStr3ak5/Takao/zipball/master
```

## Preparing the build environment

### Create the build directory

Decompress the package and run:

```
make all builddir=<path of no existent directory>
```

To create a dir and prepare the files that will be needed in the compilation

### Building

Enter in the `builddir` directory (the one specified before) and run:

```
make all
```

### Testing

Run:

```
make test
```

This will use QEMU, OVMF and mtools depending on the target of the testing.


### Cleaning the mess

Just delete the `builddir`, and try again the build or forget about this.

Obviously, with this you will delete the output image of Takao if you dont
save it.