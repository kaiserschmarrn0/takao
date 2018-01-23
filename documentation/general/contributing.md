# Contributing

CKA is in heavy development, and the API can change from a day
to another, so the source base is very unstable, however, if you
want to help CKA, all kind of help is welcome.

Here are some general guidelines that should be considered when
contributing to CKA. 

This list is very incomplete and will be expanded over time.

## Coding style

When helping with code, this should be read before submitting code.

### Headers

Headers must contain only the essential things needed by the header,
without the things that the scripts that include them use (talking
about other headers, definitions and that things can be included).

Too, talking about include guards, I personally prefer using the 
`#pragma once` method, but I dont think this causes a lot of trouble, 
is easy to rewrite and adjust if needed.

Examples:

This is wrong.
```c
#pragma once

#include "header1.h" // Used in the header as dependency
#include "header2.h" // Used by foo.c that includes this

void foo(int integer, char character);

(...)

```
And this is well written
```c
#pragma once

#include "header1.h" // USed by the header

#define CONST1 12

void foo(int integer, char character);

(...)

```

### Line width

120 characters, is a good number, arguments for this can be:

- Good size for modern displays, 80 chars rule is useless in my opinion.
- Improves readability and the indentation levels you can use.
- Fits perfectly modern editors like visual studio code and sublime text.

### Indentation

Tabs are a must, sorry if you code using spaces, but I find better using
tabs than spaces, I have no interest in reviving this old battle.
(And with some tools that we have nowadays, you can just
translate all spaces to tabs in 1 click, so it shouldn't be a problem)

## Documentation

### Format

Documentation should be in markdown files, to ease rendering and diffusion via
github.

### Updating

All changes made in code, changes in design and similar things should be 
correctly documented in the documentation folder.
