// cpu.d - CPU state and features
// (C) 2019 the takao authors (AUTHORS.md). All rights reserved
// This code is governed by a license that can be found in LICENSE.md

module system.cpu;

public import system.cpu.cpuid: CPUID;

struct CPU {
    CPUID cpuid;

    void enableFeatures() {
        import io.term: printLine;

        if (cpuid.hasSSE3) {
            // How does one SSE3 lul
            printLine("SSE3 was detected and enabled successfully");
        } else if (cpuid.hasSSE2) {
            asm {
                mov RAX, CR0;     // To set up SSE2:
                mov RBX, 1 << 2;
                not RBX;          // CRO = (CRO & ~(1 << 2)) |  1 << 1
                and RAX, RBX;     //     1 << 2 = CR0.EM bit (bit 2)
                or RAX, 1 << 1;   //     1 << 1 = CR0.MP bit (bit 1)
                mov CR0, RAX;
                                  // CR4 = CR4 | 1 << 9 | 1 << 10
                mov RAX, CR4;     //     = CR4 | 3 << 9
                or RAX, 3 << 9;   //     1 << 9  = CR4.OSFXSR bit (bit 9)
                mov CR4, RAX;     //     1 << 10 = CR4.OSXMMEXCPT bit (bit 10)
            }

            printLine("SSE2 was detected and enabled successfully");
        }
    }

    void checkDependencies() {
        import io.term: error;

        if (!cpuid.hasMSR) {
            error("No MSR wont allow enabling certain features");
        }

        if (!cpuid.hasAPIC && !cpuid.hasx2APIC) {
            error("x2APIC/APIC is needed for interrupts");
        }
    }

    void print() {
        import io.term: printLine;

        printLine("CPU Information:");
        cpuid.print;
    }
}

CPU getInfo() {
    import system.cpu.cpuid: getCPUID;

    CPU cpu = {
        cpuid: getCPUID() 
    };

    return cpu;
}
