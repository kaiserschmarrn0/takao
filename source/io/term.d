// term.d - VGA textmode terminal
// (C) 2019 the takao authors (AUTHORS.md). All rights reserved
// This code is governed by a license that can be found in LICENSE.md

module io.term;

import memory.constants;

private immutable auto termColumns = 80 * 2;
private immutable auto termRows    = 25;
private immutable auto videoBottom = (termRows * termColumns) - 1;
private immutable auto tabSize     = 4;

private __gshared char* videoMemory   = cast(char*)(cast(size_t)0xB8000 + physicalMemoryOffset);
private __gshared uint  cursorOffset  = 0;
private __gshared bool  cursorEnabled = true;
private __gshared ubyte textPalette   = 0x07;
private __gshared ubyte cursorPalette = 0x70;
private __gshared bool  escape        = false;
private __gshared int   escValue0     = 0;
private __gshared int   escValue1     = 0;
private __gshared int*  escValue      = &escValue0;
private __gshared int   escDefault0   = 1;
private __gshared int   escDefault1   = 1;
private __gshared int*  escDefault    = &escDefault0;

void initTerm() {
    import io.ports: outb;

    outb(0x3D4, 0x0A);
    outb(0x3D5, 0x20);
    clearTerm();
}

private void clearCursor() {
    videoMemory[cursorOffset + 1] = textPalette;
}

private void drawCursor() {
    if (cursorEnabled) videoMemory[cursorOffset + 1] = cursorPalette;
}

private void scroll() {
    // Move the text up by one row
    for (size_t i = 0; i <= videoBottom - termColumns; i++)
        videoMemory[i] = videoMemory[i + termColumns];
    // Clear the last line of the screen
    for (size_t i = videoBottom; i > videoBottom - termColumns; i -= 2) {
        videoMemory[i]     = textPalette;
        videoMemory[i - 1] = ' ';
    }
}

void clearTerm() {
    clearCursor();

    for (auto i = 0; i < videoBottom; i += 2) {
        videoMemory[i]     = ' ';
        videoMemory[i + 1] = textPalette;
    }

    cursorOffset = 0;
    drawCursor();
}

private void clearTermNoMove() {
    clearCursor();

    for (auto i = 0; i < videoBottom; i += 2) {
        videoMemory[i]     = ' ';
        videoMemory[i + 1] = textPalette;
    }

    drawCursor();
}

void enableCursor() {
    cursorEnabled = true;
    drawCursor();
}

void disableCursor() {
    cursorEnabled = false;
    clearCursor();
}

private const ubyte[] ansiColours = [0, 4, 2, 6, 1, 5, 3, 7];

private void sgr() {
    if (escValue0 >= 30 && escValue0 <= 37) {
        ubyte pal = getTextPalette();
        pal = (pal & cast(ubyte)0xF0) | ansiColours[escValue0 - 30];
        setTextPalette(pal);
    } else if (escValue0 >= 40 && escValue0 <= 47) {
        ubyte pal = getTextPalette();
        pal = (pal & cast(ubyte)0x0F) |
              cast(ubyte)(ansiColours[escValue0 - 40] << 4);
        setTextPalette(pal);
    }
}

private void escape_parse(char c) {
    if (c >= '0' && c <= '9') {
        *escValue  *= 10;
        *escValue  += c - '0';
        *escDefault = 0;
        return;
    }

    switch (c) {
        case '[':
            return;
        case ';':
            escValue   = &escValue1;
            escDefault = &escDefault1;

            return;
        case 'A':
            if (escDefault0) escValue0 = 1;

            if (escValue0 > getCursorPositionY()) {
                escValue0 = getCursorPositionY();
            }

            setCursorPosition(getCursorPositionX(),
                              getCursorPositionY() - escValue0);
            break;
        case 'B':
            if (escDefault0) escValue0 = 1;

            if (getCursorPositionY() + escValue0 > termRows - 1) {
                escValue0 = (termRows - 1) - getCursorPositionY();
            }

            setCursorPosition(getCursorPositionX(),
                              getCursorPositionY() + escValue0);
            break;
        case 'C':
            if (escDefault0)
                escValue0 = 1;
            if ((getCursorPositionX() + escValue0) > (termColumns / 2 - 1))
                escValue0 = (termColumns / 2 - 1) - getCursorPositionX();
            setCursorPosition(getCursorPositionX() + escValue0,
                                getCursorPositionY());
            break;
        case 'D':
            if (escDefault0)
                escValue0 = 1;
            if (escValue0 > getCursorPositionX())
                escValue0 = getCursorPositionX();
            setCursorPosition(getCursorPositionX() - escValue0,
                                getCursorPositionY());
            break;
        case 'H':
            escValue0--;
            escValue1--;

            if (escDefault0) escValue0 = 0;

            if (escDefault1) escValue1 = 0;

            if (escValue1 >= termColumns / 2) escValue1 = (termColumns / 2) - 1;

            if (escValue0 >= termRows) escValue0 = termRows - 1;

            setCursorPosition(escValue1, escValue0);

            break;
        case 'm':
            sgr();
            break;
        case 'J':
            switch (escValue0) {
                case 2:
                    clearTermNoMove();
                    break;
                default:
                    break;
            }
            break;
        default:
            print('?');
    }

    escValue    = &escValue0;
    escValue0   = 0;
    escValue1   = 0;
    escDefault  = &escDefault0;
    escDefault0 = 1;
    escDefault1 = 1;
    escape      = false;
}

void setCursorPalette(ubyte c) {
    cursorPalette = c;
    drawCursor();
}

ubyte getCursorPalette() {
    return cursorPalette;
}

void setTextPalette(ubyte c) {
    textPalette = c;
}

ubyte getTextPalette() {
    return textPalette;
}

int getCursorPositionX() {
    return (cursorOffset % termColumns) / 2;
}

int getCursorPositionY() {
    return cursorOffset / termColumns;
}

void setCursorPosition(int x, int y) {
    clearCursor();
    cursorOffset = y * termColumns + x * 2;
    drawCursor();
}

void print(char c) {
    if (escape) {
        escape_parse(c);
        return;
    }

    switch (c) {
        case '\t':
            if ((getCursorPositionX() / tabSize + 1) * tabSize >= termColumns)
                break;
            setCursorPosition((getCursorPositionX() / tabSize + 1) * tabSize,
                              getCursorPositionY());
            break;
        case 0x00:
            break;
        case 0x1B:
            escape = true;

            return;
        case 0x0A:
            if (getCursorPositionY() == (termRows - 1)) {
                clearCursor();
                scroll();
                setCursorPosition(0, termRows - 1);
            } else setCursorPosition(0, (getCursorPositionY() + 1));

            break;
        case 0x08:
            if (cursorOffset) {
                clearCursor();
                cursorOffset -= 2;
                videoMemory[cursorOffset] = ' ';
                drawCursor();
            }

            break;
        default:
            clearCursor();
            videoMemory[cursorOffset] = cast(ubyte)c;

            if (cursorOffset >= (videoBottom - 1)) {
                scroll();
                cursorOffset = videoBottom - (termColumns - 1);
            } else cursorOffset += 2;

            drawCursor();
    }
}

void print(string message) {
    foreach (ubyte c; message) print(c);
}

void printLine(string message) {
    print(message);
    print('\n');
}

void warning(string message) {
    import system.state: halt;

    print("\x1b[35mThe kernel reported a warning\x1b[37m: ");
    printLine(message);

    printRegisters();
}

void error(string message) {
    import system.state: halt;

    print("\x1b[31mThe kernel reported an error\x1b[37m: ");
    printLine(message);

    printLine("The system will be halted");

    printRegisters();

    halt();
}

void printRegisters() {
    import util.convert: toHex;

    ulong rbp, rsp, cr0, cr2, cr3, cr4;

    asm {
        mov rbp, RBP;
        mov rsp, RSP;
        mov RAX, CR0;
        mov cr0, RAX;
        mov RAX, CR2;
        mov cr2, RAX;
        mov RAX, CR3;
        mov cr3, RAX;
        mov RAX, CR4;
        mov cr4, RAX;
    }

    print("RBP=");
    print(toHex(rbp));
    print(", RSP=");
    printLine(toHex(rsp));

    print("CR0=");
    print(toHex(cr0));
    print(", CR2=");
    print(toHex(cr2));
    print(", CR3=");
    printLine(toHex(cr3));

    print("CR4=");
    printLine(toHex(cr4));
}
