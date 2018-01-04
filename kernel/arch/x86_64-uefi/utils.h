// File: utils.h
//
// Description: Act as glue, linking all our libraries and utilities for arch dependent things
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#pragma once

#define ASSERT_EFI_STATUS(x) {if(EFI_ERROR((x))) { return x; }}

// Include our shiny and "optimal" libk
#include "../../libk/libk.h"

//port_inb and that things
#include "../../includes/ioport.h"
