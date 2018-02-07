// bootmain.h

// Description: Main function of the bootloader (header)

// Copyright 2016 The Takao Authors (AUTHORS.md). All rights reserved.
// Use of this source code is governed by a license that can be
// found in the LICENSE.md file, in the root directory of
// the source package.

#pragma once

// Bootloader function
EFI_STATUS efi_main (EFI_HANDLE ih, EFI_SYSTEM_TABLE *st);