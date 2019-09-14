module main;

/**
 * Entrypoint of the kernel
 *
 * Entrypoint called directly by the bootloader as soon as we get a good
 * environment (long mode, a good stack, etc)
 */
extern(C) void main() {
    import io.vbe:            initVBE;
    import system.cpu:        initCPU;
    import system.interrupts: firstStageInterrupts, secondStageInterrupts;
    import system.acpi:       getACPIInfo;
    import memory:            initMemoryManagers;
    import lib.messages;

    firstStageInterrupts();

    initMemoryManagers();

    initVBE();

    info("Reached main(), booting up...                  :kongoudisgust:");

    getACPIInfo();

    secondStageInterrupts();

    initCPU();

    panic("End of the kernel");
}
