// package.d - CPU functions
// (C) 2019 the takao authors (AUTHORS.md). All rights reserved
// This code is governed by a license that can be found in LICENSE.md

module system.cpu;

void initCPU() {
    import system.cpu.cpuid: getCPUID, checkFeatures, enableFeatures;
    import util.term:        print;

    print("CPU: Obtaining information and enabling features...\n");

    getCPUID();

    debug {
        print("\tChecking for key features...\n");
    }

    checkFeatures();

    debug {
        print("\tEnabling features...\n");
    }

    enableFeatures();
}
