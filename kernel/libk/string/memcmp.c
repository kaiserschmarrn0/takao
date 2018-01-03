//File distributed under the LICENSE of the package (GNU GPL V3)
//Check LICENSE for more information

#include "../string.h"

// memcmp: returns a negative, zero, or positive integer depending on whether the 
// first n characters of the object pointed to by s1 are less than, equal to, or greater than 
// the first n characters of the object pointed to by s2.
// Ex:
// int main () {
//    char str1[15];
//    char str2[15];
//    int ret;
//
//   memcpy(str1, "abcdef", 6);
//   memcpy(str2, "ABCDEF", 6);

//   ret = memcmp(str1, str2, 5);

//   if(ret > 0) {
//      printf("str2 is less than str1");
//   } else if(ret < 0) {
//      printf("str1 is less than str2");
//   } else {
//      printf("str1 is equal to str2");
//   }
//   
//   return(0);
//}
KABI int memcmp(const void *d1, const void *d2, uint64_t len) 
{
    const uint8_t *d1_ = d1, *d2_ = d2;
    for(uint64_t i = 0; i < len; i += 1, d1_++, d2_++){
        if(*d1_ != *d2_) return *d1_ < *d2_ ? -1 : 1;
    }
    return 0;
}