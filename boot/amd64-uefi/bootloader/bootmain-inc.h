// File: bootmain-inc.h
//
// Description: Includes of bootmain.c
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.
#pragma once

#include "graphics.h"
#include "uefifunc.h"
#include "utils.h"

// A struct for storing some info
struct bootmain {
	struct uefi uefi;
	struct graphics graphics;
};