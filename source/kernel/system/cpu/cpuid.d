/**
 * License: (C) 2019 the takao authors (AUTHORS.md). All rights reserved
 * This code is governed by a license that can be found in LICENSE.md
 */

module system.cpu.cpuid;

enum CPUIDinRCXwithRAX1 : ulong {
    SSE3        = 1 << 0,  // SSE3 (PNI)
    // CLMUL       = 1 << 1,  // CLMUL instruction set extension
    // DTES64      = 1 << 2,  // 64-bit debug store (RDX bit 21)
    // MONITOR     = 1 << 3,  // MONITOR and MWAIT instructions (SSE3)
    // CPL_DS      = 1 << 4,  // CPL qualified debug store
    // VMX         = 1 << 5,  // Virtual Machine eXtensions
    // SMX         = 1 << 6,  // Safer Mode eXtensions (LaGrande Technology)
    // EST         = 1 << 7,  // Enhanded SpeedStep
    // TM2         = 1 << 8,  // Thermal Monitor 2
    // SSSE3       = 1 << 9,  // Supplemental SSE3 instructions
    // CNXTID      = 1 << 10, // L1 Context ID
    // SDBG        = 1 << 11, // Silicon Debug interface
    // FMA         = 1 << 12, // Fused multiply-add (FMA3)
    // CX16        = 1 << 13, // CMPXCHG16B instruction
    // ETPRD       = 1 << 14, // Can disable sending task priority messages
    // PDCM        = 1 << 15, // Perfmon & debug capability
    // RESERVED    = 1 << 16, // Reserved
    // PCID        = 1 << 17, // Process context identifiers (CR4 bit 17)
    // DCA         = 1 << 18, // Direct cache access for DMA writes
    // SSE41       = 1 << 19, // SSE4.1 instructions
    // SSE42       = 1 << 20, // SSE4.2 instructions
    // x2APIC      = 1 << 21, // x2APIC support
    // MOVBE       = 1 << 22, // MOVBE instruction (big-endian)
    // POPCNT      = 1 << 23, // POPCNT instruction
    // TSCDEADLINE = 1 << 24, // APIC implements oneshot operation using a TSC
    // AES         = 1 << 25, // AES instruction set
    // XSAVE       = 1 << 26, // XSAVE, XRESTOR, XSETBV, XGETBV
    // OSXSAVE     = 1 << 27, // XSAVE enabled by OS
    // AVX         = 1 << 28, // Advanced Vector eXtensions
    // F16C        = 1 << 29, // F16C (half-precision) FP feature
    // RDRND       = 1 << 30, // RDRAND (on-chip random number generator)
    // RESERVED    = 1 << 32  // Not reserved, but it's always 0 so...
}

/* enum CPUIDinRCXwithRAX0x80000001 : ulong {
    // LAHF_LM       = 1 << 0,  // LAHF/SAHF in long mode
    // CMP_LEGACY    = 1 << 1,  // Hyperthreading not valid
    // SVM           = 1 << 2,  // Secure virtual machine
    // EXTAPIC       = 1 << 3,  // Extended APIC space
    // CR8           = 1 << 4,  // CR8 is present
    // ABM           = 1 << 5,  // Advanced bit manipulation (lzcnt and popcnt)
    // SSE4A         = 1 << 6,  // SSE4A support
    // MISALIGNSSE   = 1 << 7,  // Misaligned SSE mode
    // 3DNOWPREFETCH = 1 << 8,  // 3DNow! PREFETCH and PREFETCHW instructions
    // OSVW          = 1 << 9,  // OS Visible Workaround
    // IBS           = 1 << 10, // Instruction Based Sampling
    // XOP           = 1 << 11, // XOP Instruction Set
    // SKINIT        = 1 << 12, // SKINIT/STGI instructions
    // WDT           = 1 << 13, // Watchdog timer
    // RESERVED      = 1 << 14, // Reserved
    // LWP           = 1 << 15, // Light Weight Profiling
    // FMA4          = 1 << 16, // 4 operands fused multiply-add
    // TCE           = 1 << 17, // Translation Cache Extension
    // RESERVED      = 1 << 18, // Reserved
    // NODEIDMSR     = 1 << 19, // NodeID MSR
    // RESERVED      = 1 << 20, // Reserved
    // TBM           = 1 << 21, // Trailing bit manipulation
    // TOPOEXT       = 1 << 22, // Topology extensions
    // PERFCTRCORE   = 1 << 23, // Core performance counter extensions
    // PERFCTRNB     = 1 << 24, // NB performance counter extensions
    // RESERVED      = 1 << 25, // Reserved
    // DBX           = 1 << 26, // Data breakpoint extensions
    // PERFTSC       = 1 << 27, // Performance TSC
    // PCXL2I        = 1 << 28, // L2I perf counter extensions
    // RESERVED      = 1 << 29, // Reserved
    // RESERVED      = 1 << 30, // Reserved
    // RESERVED      = 1 << 31, // Reserved
}*/

enum CPUIDinRDXwithRAX1 : ulong {
    // FPU      = 1 << 0,  // Onboard x87 FPU
    // VME      = 1 << 1,  // Virtual 8086 mode extensions (like VIF, VIP, PIV)
    // DE       = 1 << 2,  // Debugging extensions (CR4 bit 3)
    // PSE      = 1 << 3,  // Page Size Extension
    // TSC      = 1 << 4,  // Time Stamp Counter
    MSR      = 1 << 5,  // Model-Specific Registers
    // PAE      = 1 << 6,  // Physical Address Extension
    // MCE      = 1 << 7,  // Machine Check Exception
    // CX8      = 1 << 8,  // CMPXCHG8 (compare-and-swap) instruction
    // APIC     = 1 << 9,  // Onboard Advanced Programmable Interrupt Controller
    // RESERVED = 1 << 10, // Reserved
    // SYSCALL  = 1 << 11, // SYSENTER and SYSEXIT instructions
    // MTRR     = 1 << 12, // Memory Type Range Registers
    // PGE      = 1 << 13, // Page Global Enable bit in CR4
    // MCA      = 1 << 14, // Machine check architecture
    // CMOV     = 1 << 15, // Conditional move and FCMOV instructions
    PAT      = 1 << 16, // Page Attribute Table
    // PSE36    = 1 << 17, // 36-bit page size extension
    // PSN      = 1 << 18, // Processor Serial Number
    // CLF      = 1 << 19, // CLFLUSH instruction (SSE2)
    // RESERVED = 1 << 20, // Reserved
    // DS       = 1 << 21, // Debug store: save trace of executed jumps
    // ACPI     = 1 << 22, // Onboard thermal control MSRs for ACPI
    // MMX      = 1 << 23, // MMX instructions
    // FXSR     = 1 << 24, // FXSAVE, FXRESTOR instructions, CR4 bit 9
    // SSE      = 1 << 25, // SSE instructions (a.k.a. Katmai New Instructions)
    SSE2     = 1 << 26, // SSE2 instructions
    // SS       = 1 << 27, // CPU cache implements self-snoop
    // HTT      = 1 << 28, // Hyper-threading
    // TM       = 1 << 29, // Thermal monitor automatically limits temperature
    // IA64     = 1 << 30, // IA64 processor emulating x86
    // PBE      = 1 << 31  // Pending Break Enable (PBE# pin) wakeup capability
}

enum CPUIDinRDXwithRAX0x80000001 : ulong {
    // FPU      = 1 << 0,  // Onboard x87 FPU
    // VME      = 1 << 1,  // Virtual 8086 mode extensions (like VIF, VIP, PIV)
    // DE       = 1 << 2,  // Debugging extensions (CR4 bit 3)
    // PSE      = 1 << 3,  // Page Size Extension
    // TSC      = 1 << 4,  // Time Stamp Counter
    // MSR      = 1 << 5,  // Model-Specific Registers
    // PAE      = 1 << 6,  // Physical Address Extension
    // MCE      = 1 << 7,  // Machine Check Exception
    // CX8      = 1 << 8,  // CMPXCHG8 (compare-and-swap) instruction
    // APIC     = 1 << 9,  // Onboard Advanced Programmable Interrupt Controller
    // RESERVED = 1 << 10, // Reserved
    SYSCALL  = 1 << 11, // SYSENTER and SYSEXIT instructions
    // MTRR     = 1 << 12, // Memory Type Range Registers
    // PGE      = 1 << 13, // Page Global Enable bit in CR4
    // MCA      = 1 << 14, // Machine check architecture
    // CMOV     = 1 << 15, // Conditional move and FCMOV instructions
    // PAT      = 1 << 16, // Page Attribute Table
    // PSE36    = 1 << 17, // 36-bit page size extension
    // RESERVED = 1 << 18, // Reserved
    // MP       = 1 << 19, // Multiprocessor Capable
    // NX       = 1 << 20, // NX bit
    // RESERVED = 1 << 21, // Reserved
    // EXMMX    = 1 << 22, // Extended MMX
    // MMX      = 1 << 23, // MMX instructions
    // FXSR     = 1 << 24, // FXSAVE, FXRESTOR instructions, CR4 bit 9
    // FXSROPT  = 1 << 25, // FXSAVE/FXRSTOR optimizations
    // PDPE1GiB = 1 << 26, // 1GiB pages
    // RDTSCP   = 1 << 27, // RDTSCP instruction
    // LM       = 1 << 29, // Long mode
    // EX3DNOW  = 1 << 30, // Extended 3DNow!
    // 3DNOW    = 1 << 31, // 3DNow!
}

/// CPUID information per cores
struct CPUID {
    bool hasSSE3;
    bool hasMSR;
    bool hasPAT;
    bool hasSSE2;
    bool hasSYSCALL;
}

/**
 * Report CPUID information and check/enable what is needed or can be done.
 *
 * Params:
 *     cpuid = The CPUID info struct to act on.
 */
void checkCPUID(CPUID* cpuid) {
    size_t c, d, d2;

    asm {
        mov RAX, 1;
        cpuid;
        mov c, RCX;
        mov d, RDX;

        mov RAX, 0x80000001;
        cpuid;
        mov d2, RDX;
    }

    cpuid.hasSSE3    = (c & CPUIDinRCXwithRAX1.SSE3)              != 0;
    cpuid.hasMSR     = (d & CPUIDinRDXwithRAX1.MSR)               != 0;
    cpuid.hasPAT     = (d & CPUIDinRDXwithRAX1.PAT)               != 0;
    cpuid.hasSSE2    = (d & CPUIDinRDXwithRAX1.SSE2)              != 0;
    cpuid.hasSYSCALL = (d2 & CPUIDinRDXwithRAX0x80000001.SYSCALL) != 0;

    checkFeatures(cpuid);
    enableFeatures(cpuid);
}

private void checkFeatures(CPUID* cpuid) {
    assert(cpuid.hasMSR);
    assert(cpuid.hasPAT);
    assert(cpuid.hasSSE2);
    assert(cpuid.hasSYSCALL);
}

private void enableFeatures(CPUID* cpuid) {
    // We know at least SSE2 is present, so we enable SSE and if its SSE3 we win
    // that
    asm {
        mov RAX, CR0;     // To set up SSE:
        mov RBX, 1 << 2;
        not RBX;          // CRO = (CRO & ~(1 << 2)) |  1 << 1
        and RAX, RBX;     //     1 << 2 = CR0.EM bit (bit 2)
        or RAX, 1 << 1;   //     1 << 1 = CR0.MP bit (bit 1)
        mov CR0, RAX;

        mov RAX, CR4;     // CR4 = CR4 | 1 << 9 | 1 << 10 = CR4 | 3 << 9
        or RAX, 3 << 9;   //     1 << 9  = CR4.OSFXSR bit (bit 9)
        mov CR4, RAX;     //     1 << 10 = CR4.OSXMMEXCPT bit (bit 10)
    }

    // We know the PAT is present, so we enable it
    asm {
        mov RCX, 0x277;
        rdmsr;
        mov EDX, 0x0105; // Write-protect and write-combining
        wrmsr;
    }

    // We know syscalls do exist, so we enable it too
    asm {
        mov RCX, 0xC0000080; // Enable it in the EFER
        rdmsr;
        or AL, 1;
        wrmsr;

        // Setup syscall MSRs
        mov RAX, 0x00000000;
        mov RCX, 0xC0000081;
        mov RDX, 0x00130008;
        wrmsr;

        mov RAX, 0x00000000; // TODO: syscallEntry instead of 0 once it exists
        mov RCX, 0xC0000082; // with all the mechanism of syscall, and etc.
        mov RDX, RAX;
        shr RDX, 32;
        mov EAX, EAX;
        wrmsr;

        mov RCX, 0xC0000084;
        mov RAX, ~0x002;
        xor RDX, RDX;
        not RDX;
        wrmsr;
    }
}
