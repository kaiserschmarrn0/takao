// utils.h

// Description: UEFI bootloader utils

// Copyright 2016 The Takao Authors (AUTHORS.md). All rights reserved.
// Use of this source code is governed by a license that can be
// found in the LICENSE.md file, in the root directory of
// the source package.

#pragma once

#define ASSERT_EFI_STATUS(x) {if(EFI_ERROR((x))) { return x; }}

// Include our shiny and "optimal" libk
#include <libk/libk.h>
