// term.d - VGA textmode terminal
// (C) 2019 the takao authors (AUTHORS.md). All rights reserved
// This code is governed by a license that can be found in LICENSE.md

module io.term;

enum Colour : ubyte {
	Black        = 0,
	Blue         = 1,
	Green        = 2,
	Cyan         = 3,
	Red          = 4,
	Magenta      = 5,
	Brown        = 6,
	LightGrey    = 7,
	DarkGrey     = 8,
	LightBlue    = 9,
	LightGreen   = 10,
	LightCyan    = 11,
	LightRed     = 12,
	LightMagenta = 13,
	LightBrown   = 14,
	White        = 15
}

immutable ubyte termWidth  = 80;
immutable ubyte termHeight = 25;

private __gshared uint   row;
private __gshared uint   column;
private __gshared ubyte  colour;
private __gshared short* buffer;

private ubyte entryColour(Colour background, Colour foreground) {
    return cast(ubyte) (foreground | background << 4);
}

private ushort createEntry(ubyte character, ubyte colour) {
    return cast(ushort) (character | colour << 8);
}

private void putEntryAt(ubyte c, ubyte colour, uint x, uint y) {
    buffer[y * termWidth + x] = createEntry(c, colour);
}

void initTerm() {
    import io.ports:         outb;
    import memory.constants: physicalMemoryOffset;

    // Disable the cursor
    outb(0x3D4, 0x0A);
    outb(0x3D5, 0x20);

    colour = entryColour(Colour.Black, Colour.LightGrey);
    buffer = cast(short*) (0xB8000 + physicalMemoryOffset);

    clearTerm();
}

void clearTerm() {
    for (auto y = 0; y < termHeight; y++) {
        for (auto x = 0; x < termWidth; x++) putEntryAt(' ', colour, x, y);
    }

    row    = 0;
    column = 0;
}

void print(ubyte character) {
    switch (character) {
        case '\t':
            print("   ");
            break;

        case '\n':
            row   += 1;
            column = -1;
            break;

        default:
            putEntryAt(character, colour, column, row);
    }

    if (++column == termWidth) {
        column = 0;
    
        if (++row == termHeight) row = 0;
    }
}

void print(string message) {
    foreach (ubyte c; message) print(c);
}

void print(string message, Colour foreground) {
    colour = entryColour(Colour.Black, foreground);
    print(message);
    colour = entryColour(Colour.Black, Colour.LightGrey);
}

void printLine(string message) {
    print(message);
    print('\n');
}

void printLine(string message, Colour foreground) {
    print(message, foreground);
    print('\n');
}

void warning(string message) {
    import system.state: halt;

    print("The kernel reported a warning: ", Colour.LightMagenta);
    printLine(message);

    printRegisters();
}

void error(string message) {
    import system.state: halt;

    print("The kernel reported an error: ", Colour.LightRed);
    printLine(message);

    printLine("The system will be halted", Colour.DarkGrey);

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
    printLine("");

    print("CR0=");
    print(toHex(cr0));
    print(", CR2=");
    print(toHex(cr2));
    print(", CR3=");
    printLine(toHex(cr3));
    print("CR4=");
    printLine(toHex(cr4));
}
