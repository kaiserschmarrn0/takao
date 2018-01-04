// File: systemapi.h
//
// Description: a bit of our system api
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#pragma once

#define KABI __attribute__((sysv_abi))
#define NAKED __attribute__((naked))
#define INLINE inline __attribute__((always_inline))
