# CKA Version scheme:
#### Author: TheStr3ak5

CKA uses a special version scheming, that consist in 4 separated numbers.
This numbers have a meaning, is the following:

Example: 
```
CKA 1-3-5-2
```
```x-x-x-2``` means Bug-fix 2, these are just version that fix some errors or include documentation, but without any substantial
change in code. This number is maintained until one 'Big release' happens.

```x-x-5-x``` means Minor release 5, these are version that add small changes to the source, like big bug fixes (bug fixes that
change a lot the code), a new functionality (serial port writing for example), etc.

```x-3-x-x``` means Big release 3, these are releases that provide substantial changes to determinated parts of the kernel, but
without making a global change, for example, support for mouse input or a big change in the memory allocation.

```1-x-x-x``` means Mayor release 1, these are huge versions that change the global behaviour of the kernel, these are rare
and imply incompatibility with binaries, dependencies and any other existent structure. For example, leaving the kernel project 
to enter into a complete OS project, making a GUI and focusing the system to it, etc.
