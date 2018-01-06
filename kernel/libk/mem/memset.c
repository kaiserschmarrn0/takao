// File: memset.c
//
// Description: Defines the memset function.
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#include "../mem.h"

// memset : copies e to the first len characters of the string pointed to by dest.
// Ex:
// int main () {
//    char str[50];
//    strcpy(str,"This is string.h library function");
//    puts(str);
//
//    memset(str,'$',7);
//    puts(str);
//   
//    return(0);
//}
// This will output:
// This is string.h library function
// $$$$$$$ string.h library function
KABI void memset(void *dest, uint8_t e, uint64_t len) {
    uint8_t *d = dest;
    for(uint64_t i = 0; i < len; i++, d++) {
        *d = e;
    }
}