// convert.d - Convert things to other datatypes
// (C) 2019 the takao authors (AUTHORS.md). All rights reserved
// This code is governed by a license that can be found in LICENSE.md

module util.convert;

immutable char[] conversionTable = "0123456789ABCDEF";

__gshared char[18] hexBuffer;
__gshared char[20] decimalBuffer;
__gshared char[66] binaryBuffer;

string toHex(ulong number){
    hexBuffer[0] = '0';
    hexBuffer[1] = 'x';

    for (auto i = 17; i >= 2; i--) {
        hexBuffer[i] = conversionTable[number % 16];
        number /= 16;
    }

    return cast(string) hexBuffer;
}

string toDecimal(ulong number){
    for (auto i = 19; i >= 0; i--) {
        decimalBuffer[i] = conversionTable[number % 10];
        number /= 10;
    }

    return cast(string) decimalBuffer;
}

string toBinary(ulong number){
    binaryBuffer[0] = '0';
    binaryBuffer[1] = 'b';

    for (auto i = 65; i >= 2; i--) {
        binaryBuffer[i] = conversionTable[number % 2];
        number /= 2;
    }

    return cast(string) binaryBuffer;
}
