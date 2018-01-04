//File distributed under the LICENSE of the package (GNU GPL V3)
//Check LICENSE for more information

#pragma once

#define KABI __attribute__((sysv_abi))
#define NAKED __attribute__((naked))
#define INLINE inline __attribute__((always_inline))
