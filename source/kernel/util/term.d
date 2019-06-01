/**
 * License: (C) 2019 the takao authors (AUTHORS.md). All rights reserved
 * This code is governed by a license that can be found in LICENSE.md
 */

module util.term;

public import core.stdc.stdarg;

import io.vbe;
import lib;

private shared(bool) termEnabled = false; /// Status of the graphical terminal

private immutable(char[]) conversionTable = "0123456789ABCDEF";

private shared(ubyte)[256*16] font;
private immutable(int)        fontHeight = 16;
private immutable(int)        fontWidth  = 8;

private shared(int) rows;
private shared(int) cols;

private shared(uint) defaultBackground;
private shared(uint) defaultForeground;
private shared(uint) textBackground;
private shared(uint) textForeground;

private __gshared int  cursorX;
private __gshared int  cursorY;
private shared(int)  savedCursorX;
private shared(int)  savedCursorY;
private shared(int)  cursorStatus;
private shared(uint) cursorBackground;
private shared(uint) cursorForeground;

private shared(char*) grid;
private shared(uint*) gridBackground;
private shared(uint*) gridForeground;

private immutable(int)              maxEscValues = 256;
private shared(int)                 controlSequence;
private shared(int)                 escape;
private __gshared int[maxEscValues] escValues;
private __gshared int               escValuesCount;
private shared(int)                 rrr;
private shared(int)                 tabSize;

private immutable(uint[]) ansiColours = [
    0x2F343F,              // black
    0x705050,              // red
    0x60B48A,              // green
    0xDFAF8F,              // brown
    0x9AB8D7,              // blue
    0xDC8CC3,              // magenta
    0x8CD0D3,              // cyan
    0xDCDCDC               // grey
];

/*private immutable(uint[]) ansiColours = [
    0x000000,              // black
    0xAA0000,              // red
    0x00AA00,              // green
    0xAA5500,              // brown
    0x0000AA,              // blue
    0xAA00AA,              // magenta
    0x00AAAA,              // cyan
    0xAAAAAA               // grey
];*/

private extern(C) void dumpVGAFont(shared(ubyte)*);

/**
 * Initialise the terminal
 */
void initTerm() {
    import memory.alloc: alloc;

    debug {
        info("Initialising TTY...");
    }

    dumpVGAFont(font.ptr);

    cols = vbeWidth  / fontWidth;
    rows = vbeHeight / fontHeight;

    defaultBackground = ansiColours[0];
    defaultForeground = ansiColours[7];
    textBackground    = defaultBackground;
    textForeground    = defaultForeground;

    cursorX          = 0;
    cursorY          = 0;
    cursorStatus     = 1;
    cursorBackground = defaultForeground;
    cursorForeground = defaultBackground;

    controlSequence = 0;
    escape          = 0;
    tabSize         = 8;

    grid           = cast(shared(char*))alloc(rows * cols);
    gridBackground = cast(shared(uint*))alloc(rows * cols * uint.sizeof);
    gridForeground = cast(shared(uint*))alloc(rows * cols * uint.sizeof);

    assert(grid && gridBackground && gridForeground);

    for (size_t i = 0; i < rows * cols; i++) {
        grid[i] = ' ';
        gridBackground[i] = textBackground;
        gridForeground[i] = textForeground;
    }

    refresh();

    termEnabled = true;

    info("Terminal ready");
}

private void plotPixel(int x, int y, uint hex) {
    size_t bufferPos = x + (vbePitch / uint.sizeof) * y;

    vbeFramebuffer[bufferPos] = hex;
}

private void plotChar(char c, int x, int y, uint hexFg, uint hexBg) {
    import lib.bit: bitTest;

    auto originalX = x;
    auto glyph     = &font[c * fontHeight];

    for (int i = 0; i < fontHeight; i++) {
        for (int j = fontWidth - 1; j >= 0; j--) {
            plotPixel(x++, y, bitTest(glyph[i], j) ? hexFg : hexBg);
        }

        y++;
        x = originalX;
    }
}

private void plotCharInGrid(char c, int x, int y, uint hexFg, uint hexBg) {
    if (grid[x + y * cols] != c || gridForeground[x + y * cols] != hexFg
        || gridBackground[x + y * cols] != hexBg) {
        plotChar(c, x * fontWidth, y * fontHeight, hexFg, hexBg);
        grid[x + y * cols] = c;
        gridForeground[x + y * cols] = hexFg;
        gridBackground[x + y * cols] = hexBg;
    }
}

private void clearCursor() {
    if (cursorStatus) {
        plotChar(grid[cursorX + cursorY * cols],
            cursorX * fontWidth, cursorY * fontHeight,
            gridForeground[cursorX + cursorY * cols],
            gridBackground[cursorX + cursorY * cols]);
    }
}

private void drawCursor() {
    if (cursorStatus) {
        plotChar(grid[cursorX + cursorY * cols],
            cursorX * fontWidth, cursorY * fontHeight,
            cursorForeground, cursorBackground);
    }
}

private void refresh() {
    for (int i = 0; i < rows * cols; i++) {
        plotChar(grid[i], (i % cols) * fontWidth, (i / cols) * fontHeight,
                 gridForeground[i], gridBackground[i]);
    }

    drawCursor();
}

private void scroll() {
    clearCursor();

    for (int i = cols; i < rows * cols; i++) {
        plotCharInGrid(grid[i], (i - cols) % cols, (i - cols) / cols,
                       gridForeground[i], gridBackground[i]);
    }

    // Clear the last line of the screen
    for (int i = rows * cols - cols; i < rows * cols; i++) {
        plotCharInGrid(' ', i % cols, i / cols, textForeground, textBackground);
    }

    drawCursor();
}

private void clear() {
    clearCursor();

    for (int i = 0; i < rows * cols; i++) {
        plotCharInGrid(' ', i % cols, i / cols, textForeground, textBackground);
    }

    cursorX = 0;
    cursorY = 0;

    drawCursor();
}

private void enableCursor() {
    cursorStatus = 1;
    drawCursor();
}

private void disableCursor() {
    clearCursor();
    cursorStatus = 0;
}

private void setCursorPosition(int x, int y) {
    clearCursor();
    cursorX = x;
    cursorY = y;
    drawCursor();
}

private void sgr() {
    int i = 0;

    if (!escValuesCount) {
        goto def;
    }

    for ( ; i < escValuesCount; i++) {
        if (!escValues[i]) {
def:
            textForeground = defaultForeground;
            textBackground = defaultBackground;
            continue;
        }

        if (escValues[i] >= 30 && escValues[i] <= 37) {
            textForeground = ansiColours[escValues[i] - 30];
            continue;
        }

        if (escValues[i] >= 40 && escValues[i] <= 47) {
            textBackground = ansiColours[escValues[i] - 40];
            continue;
        }

    }
}

private void controlSequence_parse(char c) {
    if (c >= '0' && c <= '9') {
        rrr = 1;
        escValues[escValuesCount] *= 10;
        escValues[escValuesCount] += c - '0';
        return;
    } else {
        if (rrr) {
            escValuesCount++;
            rrr = 0;
            if (c == ';')
                return;
        } else if (c == ';') {
            escValues[escValuesCount] = 1;
            escValuesCount++;
            return;
        }
    }

    // default rest to 1
    for (int i = escValuesCount; i < maxEscValues; i++) {
        escValues[i] = 1;
    }

    switch (c) {
        case 'A':
            if (escValues[0] > cursorY) {
                escValues[0] = cursorY;
            }

            setCursorPosition(cursorX, cursorY - escValues[0]);
            break;
        case 'B':
            if ((cursorY + escValues[0]) > (rows - 1)) {
                escValues[0] = (rows - 1) - cursorY;
            }

            setCursorPosition(cursorX, cursorY + escValues[0]);
            break;
        case 'C':
            if ((cursorX + escValues[0]) > (cols - 1)) {
                escValues[0] = (cols - 1) - cursorX;
            }

            setCursorPosition(cursorX + escValues[0], cursorY);
            break;
        case 'D':
            if (escValues[0] > cursorX) {
                escValues[0] = cursorX;
            }

            setCursorPosition(cursorX - escValues[0], cursorY);
            break;
        case 'E':
            if (cursorY + escValues[0] >= rows) {
                setCursorPosition(0, rows - 1);
            } else setCursorPosition(0, cursorY + escValues[0]);

            break;
        case 'F':
            if (cursorY - escValues[0] < 0) {
                setCursorPosition(0, 0);
            } else setCursorPosition(0, cursorY - escValues[0]);

            break;
        case 'H':
        case 'f':
            escValues[0] -= 1;
            escValues[1] -= 1;
            if (escValues[1] >= cols) {
                escValues[1] = cols - 1;
            }

            if (escValues[0] >= rows) {
                escValues[0] = rows - 1;
            }

            setCursorPosition(escValues[1], escValues[0]);
            break;
        case 'm':
            sgr();
            break;
        case 'J':
            switch (escValues[0]) {
                case 2:
                    clear();
                    break;
                default:
                    break;
            }

            break;
        case 's':
            savedCursorX = cursorX;
            savedCursorY = cursorY;
            break;
        case 'u':
            clearCursor();
            cursorX = savedCursorX;
            cursorY = savedCursorY;
            drawCursor();
            break;
        default:
            break;
    }

    controlSequence = 0;
    escape          = 0;
}

private void escapeParse(char c) {
    if (controlSequence) {
        controlSequence_parse(c);
        return;
    }

    switch (c) {
        case '[':
            for (int i = 0; i < maxEscValues; i++) {
                escValues[i] = 0;
            }

            escValuesCount  = 0;
            rrr             = 0;
            controlSequence = 1;
            break;
        default:
            escape = 0;
    }
}

private void vbePutChar(char c) {
    if (escape) {
        escapeParse(c);
        return;
    }
    switch (c) {
        case '\0':
            break;
        case '\x1b':
            escape = 1;
            break;
        case '\t':
            if ((cursorX / tabSize + 1) * tabSize >= cols) {
                break;
            }

            setCursorPosition((cursorX / tabSize + 1) * tabSize, cursorY);
            break;
        case '\r':
            setCursorPosition(0, cursorY);
            break;
        case '\a':
            // dummy handler for bell
            break;
        case '\n':
            if (cursorY == (rows - 1)) {
                setCursorPosition(0, (rows - 1));
                scroll();
            } else setCursorPosition(0, (cursorY + 1));

            break;
        case '\b':
            if (cursorX || cursorY) {
                clearCursor();

                if (cursorX) {
                    cursorX--;
                } else {
                    cursorY--;
                    cursorX = cols - 1;
                }

                drawCursor();
            }
            break;
        default:
            clearCursor();
            plotCharInGrid(c, cursorX++, cursorY, textForeground, textBackground);

            if (cursorX == cols) {
                cursorX = 0;
                cursorY++;
            }

            if (cursorY == rows) {
                cursorY--;
                scroll();
            }

            drawCursor();
            break;
    }
}

private void printInteger(ulong x) {
    int i;
    char[21] buf;

    buf[20] = 0;

    if (!x) {
        print('0');
        return;
    }

    for (i = 19; x; i--) {
        buf[i] = conversionTable[x % 10];
        x /= 10;
    }

    i++;
    print(cast(immutable)&buf[i]);
}

private void printHex(ulong x) {
    int i;
    char[17] buf;

    buf[16] = 0;

    if (!x) {
        print("0x0");
        return;
    }

    for (i = 15; x; i--) {
        buf[i] = conversionTable[x % 16];
        x /= 16;
    }

    i++;
    print("0x");
    print(cast(immutable)&buf[i]);
}

private shared SpinLock charLock   = unlocked;
private shared SpinLock stringLock = unlocked;
private shared SpinLock vprintLock = unlocked;
private shared SpinLock printLock  = unlocked;

void print(char c) {
    import io.qemu: qemuPutChar;

    acquireSpinlock(&charLock);

    debug {
        qemuPutChar(c);
    }

    if (termEnabled) {
        vbePutChar(c);
    }

    releaseSpinlock(&charLock);
}

void print(cstring message) {
    acquireSpinlock(&stringLock);

    for (auto i = 0; message[i]; i++) {
        print(message[i]);
    }

    releaseSpinlock(&stringLock);
}

extern(C) void vprint(cstring format, va_list args) {
    acquireSpinlock(&vprintLock);

    for (auto i = 0; format[i]; i++) {
        if (format[i] != '%') {
            print(format[i]);
            continue;
        }

        if (format[++i]) {
            switch (format[i]) {
                case 's':
                    cstring str;
                    va_arg(args, str);
                    print(str);
                    break;
                case 'x':
                    ulong h;
                    va_arg(args, h);
                    printHex(h);
                    break;
                case 'u':
                    ulong u;
                    va_arg(args, u);
                    printInteger(u);
                    break;
                default:
                    print('%');
                    print(format[i]);
            }
        } else print('%');
    }

    releaseSpinlock(&vprintLock);
}

extern(C) void print(cstring message, ...) {
    acquireSpinlock(&printLock);

    va_list args;
    va_start(args, message);

    vprint(message, args);

    releaseSpinlock(&printLock);
}
