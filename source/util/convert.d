// convert.d - Convert things to other datatypes
// (C) 2019 the takao authors (AUTHORS.md). All rights reserved
// This code is governed by a license that can be found in LICENSE.md

module util.convert;

immutable char[] conversionTable = "0123456789ABCDEF";

__gshared char[19] hexBuffer;
__gshared char[21] decimalBuffer;
__gshared char[67] binaryBuffer;

char* toHex(ulong number){
    hexBuffer[0] = '0';
    hexBuffer[1] = 'x';

    for (auto i = 17; i >= 2; i--) {
        hexBuffer[i] = conversionTable[number % 16];
        number /= 16;
    }

    hexBuffer[18] = '\0';

    return &hexBuffer[0];
}

char* toDecimal(ulong number){
    for (auto i = 19; i >= 0; i--) {
        decimalBuffer[i] = conversionTable[number % 10];
        number /= 10;
    }

    decimalBuffer[20] = '\0';

    return &decimalBuffer[0];
}

char* toBinary(ulong number){
    binaryBuffer[0] = '0';
    binaryBuffer[1] = 'b';

    for (auto i = 65; i >= 2; i--) {
        binaryBuffer[i] = conversionTable[number % 2];
        number /= 2;
    }

    binaryBuffer[66] = '\0';

    return &binaryBuffer[0];
}
