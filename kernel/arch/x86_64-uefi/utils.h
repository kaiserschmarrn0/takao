//File distributed under the LICENSE of the package (GNU GPL V3)
//Check LICENSE for more information

#pragma once

#define ASSERT_EFI_STATUS(x) {if(EFI_ERROR((x))) { return x; }}

// Include our shiny and "optimal" libk
#include "../../libk/libk.h"

//port_inb and that things
#include "../../includes/ioport.h"
