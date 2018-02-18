// cxa_pure_virtual.cpp

// Description: __cxa_pure_virtual function, needed by GCC and other compiler
//              if we want to use pure virtual functions, despite it is empty
//              almost always, and does not need headers, just needs to be
//              linked.

// Copyright 2018 The Takao Authors (AUTHORS.md). All rights reserved.
// Use of this source code is governed by a license that can be
// found in the LICENSE.md file, in the root directory of
// the source package.

extern "C" void __cxa_pure_virtual()
{
    // Do nothing
}
