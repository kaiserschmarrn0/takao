// File: memcpy.c
//
// Description: Defines the memcpy function.
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.
#include "../string.h"

// memcpy : copies the number specified by len from memory src to dest, being
// src and dest pointers
// Ex: 
// int main () {
//    const char src[6] = "hello";
//    char dest[6];
//    printf("Before memcpy dest = %s\n", dest);
//    memcpy(dest, src, strlen(src)+1);
//    printf("After memcpy dest = %s\n", dest);
//    return(0);
// }
// This will output:
// Before memcpy dest =
// After memcpy dest = hello
KABI void memcpy(void *dest, const void *src, uint64_t len) {
    uint8_t *d = dest;
    const uint8_t *s = src;
    for(uint64_t i = 0; i < len; i++, d++, s++) {
        *d = *s;
    }
}