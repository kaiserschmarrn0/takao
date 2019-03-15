// lib.d - Some useful functions
// (C) 2019 the takao authors (AUTHORS.md). All rights reserved
// This code is governed by a license that can be found in LICENSE.md

module util.lib;

bool areEquals(const char* dst, const char* src, ulong count) {
    foreach (i; 0..count) {
        if (dst[i] != src[i]) {
            return false;
        }
    }

    return true;
}
