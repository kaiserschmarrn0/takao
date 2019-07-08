module io.qemu;

/**
 * Sends a character to the QEMU debug port, accesible thru 0xE9
 *
 * Params:
 *     c = The character requested for sending
 */
void qemuPutChar(char c) {
    import io.ports: outb;

    outb(0xE9, c);
}
