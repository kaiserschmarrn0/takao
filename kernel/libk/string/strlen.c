//File distributed under the LICENSE of the package (GNU GPL V3)
//Check LICENSE for more information

#include "../string.h"

// strlen : computes the length of the string str up to, but not including the terminating 
// null character.
// Ex:
// int main()
// {
//     char a[20]="Program";
//     char b[20]={'P','r','o','g','r','a','m','\0'};
//     char c[20];
//
//     printf("Enter string: ");
//     gets(c);
//
//     printf("Length of string a = %d \n",strlen(a));
//
//     //calculates the length of string before null charcter.
//     printf("Length of string b = %d \n",strlen(b));
//     printf("Length of string c = %d \n",strlen(c));
//
//     return 0;
// }
// This will print:
// Enter string: String
// Length of string a = 7
// Length of string b = 7
// Length of string c = 6
KABI uint64_t strlen(const char *data) {
    uint64_t r;
    for(r = 0; *data != '\0'; data++, r++);
    return r;
}
