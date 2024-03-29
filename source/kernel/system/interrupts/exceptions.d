/**
 * Exceptions are classified as:
 *
 * - Faults: Can be corrected and the program can continue as if nothing
 *           happened.
 *
 * - Traps:  Reported immediately after the execution of the instruction.
 *
 * - Aborts: Some severe unrecoverable error.
 *
 * Some exceptions will push a 32-bit "error code" on to the top of the
 * stack, which provides additional information about the error. This value
 * must be pulled from the stack before returning control back to the currently
 * running program. (i.e. before calling IRET)
 */

module system.interrupts.exceptions;

/**
 * A Fault (#DE)
 *
 * Occurs when dividing any number by 0 using the DIV or IDIV instructions.
 *
 * The saved instruction pointer points to the DIV or IDIV instruction which
 * caused the exception.
 *
 * Error Code: None
*/
void DEHandler() {
    asm {
        naked;

        mov RDI, 0;
        mov RSI, 0;
        call exceptionEntry;
    }
}

/**
 * A Fault/Trap (#DB)
 *
 * Occurs on the following conditions:
 *
 *   - Instruction fetch breakpoint (Fault)
 *
 *   - General detect condition (Fault)
 *
 *   - Data read or write breakpoint (Trap)
 *
 *   - I/O read or write breakpoint (Trap)
 *
 *   - Single-step (Trap)
 *
 *   - Task-switch (Trap)
 *
 * When the exception is a fault, the saved instruction pointer points to the
 * instruction which caused the exception. When the exception is a trap, the
 * saved instruction pointer points to the instruction after the instruction
 * which caused the exception.
 *
 * Error Code: None. However, exception information is provided in the debug
 * registers.
 */
void DBHandler() {
    asm {
        naked;

        mov RDI, 1;
        mov RSI, 0;
        call exceptionEntry;
    }
}

/**
 * A normal interrupt (A Non Maskable Interrupt) (#NMI)
 *
 * Occurs for RAM errors and unrecoverable hardware problems.
 *
 * Error Code: None.
 */
void NMIHandler() {
    asm {
        naked;

        mov RDI, 2;
        mov RSI, 0;
        call exceptionEntry;
    }
}

/**
 * A Trap (#BP)
 *
 * Occurs at the execution of the INT3 instruction.
 *
 * Some debug software replace an instruction by the INT3 instruction. When the
 * breakpoint is trapped, it replaces the INT3 instruction with the original
 * instruction, and decrements the instruction pointer by one.
 *
 * The saved instruction pointer points to the byte after the INT3 instruction.
 *
 * Error Code: None.
 */
void BPHandler() {
    asm {
        naked;

        mov RDI, 3;
        mov RSI, 0;
        call exceptionEntry;
    }
}

/**
 * A Trap (#OF)
 *
 * Occurs when the INTO instruction is executed while the overflow bit in
 * RFLAGS is set to 1, or when the result of div/idiv insructions is bigger
 * than 64/32/16/8bit depending on the instruction operand size.
 * (only if it's bigger).
 *
 * The saved instruction pointer points to the instruction after the INTO, or
 * when an div/idiv is the cause of the exception.
 *
 * Error Code: None.
 */
void OFHandler() {
    asm {
        naked;

        mov RDI, 4;
        mov RSI, 0;
        call exceptionEntry;
    }
}

/**
 * A Fault (#BR)
 *
 * Can occur when the BOUND instruction is executed. The BOUND instruction
 * compares an array index with the lower and upper bounds of an array. When
 * the index is out of bounds, the exception occurs.
 *
 * The saved instruction pointer points to the BOUND instruction which caused
 * the exception.
 *
 * Error Code: None.
 */
void BRHandler() {
    asm {
        naked;

        mov RDI, 5;
        mov RSI, 0;
        call exceptionEntry;
    }
}

/**
 * A Fault (#UD)
 *
 * Occurs when the processor tries to execute an invalid or undefined opcode,
 * or an instruction with invalid prefixes. It also occurs when an instruction
 * exceeds 15 bytes, but this only occurs with redundant prefixes.
 *
 * The saved instruction pointer points to the instruction which caused the
 * exception.
 *
 * The saved instruction pointer points to the BOUND instruction which caused
 * the exception.
 *
 * Error Code: None.
 */
void UDHandler() {
    asm {
        naked;

        mov RDI, 6;
        mov RSI, 0;
        call exceptionEntry;
    }
}

/**
 * A Fault (#NM)
 *
 * Occurs when an FPU instruction is attempted but there is no FPU. This is not
 * likely, as modern processors have built-in FPUs. However, there are flags in
 * the CR0 register that disable the FPU/MMX/SSE instructions, causing this
 * exception when they are attempted. This feature is useful because the
 * operating system can detect when a user program uses the FPU or XMM
 * registers and then save/restore them appropriately when multitasking.
 *
 * The saved instruction pointer points to the instruction that caused the
 * exception.
 *
 * Error Code: None.
 */
void NMHandler() {
    asm {
        naked;

        mov RDI, 7;
        mov RSI, 0;
        call exceptionEntry;
    }
}

/**
 * An Abort (#DF)
 *
 * Occurs when an exception is unhandled or when an exception occurs while the
 * CPU is trying to call an exception handler. Normally, two exception at the
 * same time are handled one after another, but in some cases that is not
 * possible. For example, if a page fault occurs, but the exception handler is
 * located in a not-present page, two page faults would occur and neither can
 * be handled. A double fault would occur.
 *
 * The saved instruction pointer is undefined. A double fault cannot be
 * recovered. The faulting process must be terminated.
 * In several starting hobby OSes, a double fault is also quite often a
 * misdiagnosed IRQ0 in the cases where the PIC hasn't been reprogrammed yet.
 *
 * Error Code: Always generates an error code with a value of zero.
 */
void DFHandler() {
    asm {
        naked;

        mov RDI, 8;
        mov RSI, 0;
        call exceptionEntry;
    }
}

/**
 * A Fault (CSO)
 *
 * When the FPU was still external to the processor, it had separate segment
 * checking in protected mode. Since the 486 this is handled by a GPF instead
 * like it already did with non-FPU memory accesses.
 *
 * Error Code: None.
 */
void CSOHandler() {
    asm {
        naked;

        mov RDI, 9;
        mov RSI, 0;
        call exceptionEntry;
    }
}

/**
 * A Fault (#TS)
 *
 * Occurs when an invalid segment selector is referenced as part of a task
 * switch, or as a result of a control transfer through a gate descriptor,
 * which results in an invalid stack-segment reference using an SS selector in
 * the TSS.
 *
 * Error Code: Sets an error code, which is a selector index.
 */
void TSHandler() {
    asm {
        naked;

        mov RDI, 0xA;
        mov RSI, 1;
        call exceptionEntry;
    }
}

/**
 * A Fault (#NP)
 *
 * Occurs when an invalid segment selector is referenced as part of a task
 * switch, or as a result of a control transfer through a gate descriptor,
 * which results in an invalid stack-segment reference using an SS selector in
 * the TSS.
 *
 * Occurs when trying to load a segment or gate which has it's Present-bit set
 * to 0. However when loading a stack-segment selector which references a
 * descriptor which is not present, a #SS occurs.
 *
 * The saved instruction pointer points to the instruction which caused the
 * exception.
 *
 * Error Code: The selector index of the segment descriptor which caused the
 * exception.
 */
void NPHandler() {
    asm {
        naked;

        mov RDI, 0xB;
        mov RSI, 1;
        call exceptionEntry;
    }
}

/**
 * A Fault (#SS)
 *
 * Occurs when:
 *
 * - Loading a stack-segment referencing a segment descriptor which is not
 *   present.
 *
 * - Any PUSH or POP instruction or any instruction using ESP or EBP as a base
 *   register is executed, while the stack address is not in canonical form.
 *
 * - When the stack-limit check fails.
 *
 * This exception is not part of segment not present exception because of the
 * need to push eip,cs,eflags,esp,ss. The stack is no longer valid because
 * the ss's gdt entry (or the ss itself) had to be buggy in the first place for
 * this exception to occur, so one must declare this exception as a task switch
 * interrupt and setting up tss for it.
 *
 * The saved instruction pointer points to the instruction which caused the
 * exception.
 *
 * Error Code: Stack segment selector index when a non-present segment
 * descriptor was referenced. Otherwise, 0.
 */
void SSHandler() {
    asm {
        naked;

        mov RDI, 0xC;
        mov RSI, 1;
        call exceptionEntry;
    }
}

/**
 * A Fault (#GP)
 *
 * May occur for various reasons. The most common are:
 *
 * - Segment error (privilege, type, limit, read/write rights).
 *
 * - Executing a privileged instruction while CPL != 0.
 *
 * - Writing a 1 in a reserved register field.
 *
 * - Referencing or accessing a null-descriptor.
 *
 * - Trying to access an unimplemented register (like: mov cr6, eax).
 *
 * The saved instruction pointer points to the instruction which caused the
 * exception.
 *
 * Error Code: The segment selector index when the exception is segment
 * related. Otherwise, 0.
 */
void GPHandler() {
    asm {
        naked;

        mov RDI, 0xD;
        mov RSI, 1;
        call exceptionEntry;
    }
}

/**
 * A Fault (#PF)
 *
 * Occurs when:
 *
 * - A page directory or table entry is not present in physical memory.
 *
 * - Attempting to load the instruction TLB with a translation for a non-
 * executable page.
 *
 * - A protection check (privileges, read/write) failed.
 *
 * - A reserved bit in the page directory or table entries is set to 1.
 *
 * Error Code:
 *             31              4               0
 *            +---+--  --+---+---+---+---+---+---+
 *            |   Reserved   | I | R | U | W | P |
 *            +---+--  --+---+---+---+---+---+---+
 * P = When set, the page fault was caused by a page-protection violation. When
 *     not set, it was caused by a non-present page.
 *
 * W = When set, the page fault was caused by a page write. When not set, it
 *     was caused by a page read.
 *
 * U = When set, the page fault was caused while CPL = 3. This does not
 *     necessarily mean that the page fault was a privilege violation.
 *
 * R = When set, the page fault was caused by writing a 1 in a reserved field.
 *
 * I = When set, the page fault was caused by an instruction fetch.
 */
void PFHandler() {
    asm {
        naked;

        mov RDI, 0xE;
        mov RSI, 1;
        call exceptionEntry;
    }
}

/**
 * A Fault (#MF)
 *
 * Occurs when the FWAIT or WAIT instruction, or any waiting floating-point
 * instruction is executed, and the following conditions are true:
 *
 * - CR0.NE is 1
 *
 * - An unmasked x87 floating point exception is pending (i.e. the exception
 *   bit in the x87 floating point status-word register is set to 1).
 *
 * The saved instruction pointer points to the instruction which is about to be
 * executed when the exception occurred. The x87 instruction pointer register
 * contains the address of the last instruction which caused the exception.
 *
 * Error Code: None. However, one can use the x87 status word register.
 */
void MFHandler() {
    asm {
        naked;

        mov RDI, 0x10;
        mov RSI, 0;
        call exceptionEntry;
    }
}

/**
 * A Fault (#AC)
 *
 * Occurs when alignment checking is enabled and an unaligned memory data
 * reference is performed. Alignment checking is only performed in CPL 3.
 *
 * Alignment checking is disabled by default. To enable it, set the CR0.AM and
 * RFLAGS.AC bits both to 1.
 *
 * The saved instruction pointer points to the instruction which caused the
 * exception.
 *
 * Error Code: None.
 */
void ACHandler() {
    asm {
        naked;

        mov RDI, 0x11;
        mov RSI, 0;
        call exceptionEntry;
    }
}

/**
 * An Abort (#MC)
 *
 * Is model specific and processor implementations are not required to support
 * it. It uses model-specific registers to provide error information.
 *
 * It is disabled by default. To enable it, set the CR4.MCE bit to 1.
 *
 * Machine check exceptions occur when the processor detects internal
 * errors, such as bad memory, bus errors, cache errors, etc.
 *
 * The value of the saved instruction pointer depends on the implementation and
 * the exception.
 *
 * Error Code: None.
 */
void MCHandler() {
    asm {
        naked;

        mov RDI, 0x12;
        mov RSI, 0;
        call exceptionEntry;
    }
}

/**
 * A Fault (#XF)
 *
 * Occurs when an unmasked 128-bit media floating-point exception occurs and
 * the CR4.OSXMMEXCPT bit is set to 1. If the OSXMMEXCPT flag is not set, then
 * SIMD floating-point exceptions will cause an Undefined Opcode exception
 * instead of this.
 *
 * The saved instruction pointer points to the instruction which caused the
 * exception.
 *
 * Error Code: None. However, one can use the MXCSR register.
 */
void XFHandler() {
    asm {
        naked;

        mov RDI, 0x13;
        mov RSI, 0;
        call exceptionEntry;
    }
}

/**
 * A Fault (#VE)
 *
 * Occurs when ???
 *
 * Error Code: None.
 */
void VEHandler() {
    asm {
        naked;

        mov RDI, 0x14;
        mov RSI, 0;
        call exceptionEntry;
    }
}

/**
 * A ??? (#SX)
 *
 * Occurs when ???
 *
 * Error Code: None.
 */
void SXHandler() {
    asm {
        naked;

        mov RDI, 0x1E;
        mov RSI, 0;
        call exceptionEntry;
    }
}

import lib;

private struct ExceptionStackState {
    ulong errorCode;
    ulong rip;
    ulong cs;
    ulong rflags;
    ulong rsp;
    ulong ss;
}

private immutable(cstring[]) exceptionName = [
    "Division By 0 (#UD)",
    "Debug (#DE)",
    "Non Maskable Interrupt (NMI)",
    "Breakpoint (#BP)",
    "Overflow (#OF)",
    "Bound Range (#BR)",
    "Invalid Opcode (#UD)",
    "Device Not Available (#NM)",
    "Double Fault (#DF)",
    "Coprocessor Segment Overrun (CSO)",
    "Invalid TSS (#TS)",
    "Segment Not Present (#NP)",
    "Stack-Segment Fault (#SS)",
    "General Protection Fault (#GP)",
    "Page Fault (#PF)",
    "Reserved (15)",
    "x87 Floating-Point (#MF)",
    "Alignment Check (#AC)",
    "Machine Check (#MC)",
    "SIMD Floating-Point Exception (#XF)",
    "Virtualization Exception (#VE)",
    "Reserved (0x15)",
    "Reserved (0x16)",
    "Reserved (0x17)",
    "Reserved (0x18)",
    "Reserved (0x19)",
    "Reserved (0x1A)",
    "Reserved (0x1B)",
    "Reserved (0x1C)",
    "Reserved (0x1D)",
    "Security Exception (#SX)",
    "Reserved (0x1F)"
];

private extern(C) void exceptionEntry(uint exceptionNumber, bool hasErrorCode) {
    asm {
        naked;

        pop RAX;

        test SIL, SIL;
        jnz end;
        push 0;

    end:;
        mov ESI, EDI;
        mov RDI, RSP;
        call exceptionInner;
    }
}

private extern(C) void exceptionInner(ExceptionStackState* stack, uint exception) {
    log("SS:         %x", stack.ss);
    log("RSP:        %x", stack.rsp);
    log("RFLAGS:     %x", stack.rflags);
    log("CS:         %x", stack.cs);
    log("RIP:        %x", stack.rip);
    log("Error code: %x", stack.errorCode);

    cstring exceptionSpace = stack.cs & 0b111 ? "userspace" : "kernelspace";

    panic("%s in %s", exceptionName[exception], exceptionSpace);
}
