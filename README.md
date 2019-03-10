# Takao

![forthebadge](https://forthebadge.com/images/badges/contains-cat-gifs.svg)

Welcome to the Takao source code!

Takao is a hobbyist kernel project that helps me to understand how computers
work, learn about it and, in the future, represent how I think they
should work.

Takao now is in alpha phase where big changes and design decisions will
happen, so it doesn't have a specific version number.

## Building the source code

Make sure you have installed:

* `git` (only if you are using it to download the source)
* `dmd`
* `make`
* `binutils` (doesn't need an specific version)

With all of that covered, just clone the source with `git` if you dont
have it already with:

```bash
git clone https://github.com/TheStr3ak5/takao.git
cd takao
```

And next lets build the source with:

```bash
make all
```

One can clean the build tree with `make clean` and even test the kernel with
`make test`, this last command will require `qemu`.

## Documentation

This is a non-comprehensive index of the Takao documentation.

+ [Authors](AUTHORS.md)
+ [License](LICENSE.md)
