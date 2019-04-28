/**
 * License: (C) 2019 the takao authors (AUTHORS.md). All rights reserved
 * This code is governed by a license that can be found in LICENSE.md
 */

module io.vbe;

import memory;
import util.term;

/**
 * VBE information as found in hardware
 */
struct VBEInfo {
    align(1):

    ubyte  versionMin;
    ubyte  versionMajor;
    uint   oem;            /// Is a 32 bit pointer to char
    uint   capabilities;
    uint   videoModes;     /// Is a 32 bit pointer to ushort
    ushort videoMemBlocks;
    ushort revision;
    uint   vendor;         /// Is a 32 bit pointer to char
    uint   productName;    /// Is a 32 bit pointer to char
    uint   productReview;  /// Is a 32 bit pointer to char
}

/**
 * EDID information reported by the real mode calls
 */
struct EDIDInfo {
    align(1):

    ubyte[8]  padding;
    ushort    manufacturerID;
    ushort    edidIDCode;
    uint      serialNumber;
    ubyte     manWeek;
    ubyte     manYear;
    ubyte     edidVersion;
    ubyte     edidRevision;
    ubyte     videoInputType;
    ubyte     maxHorSize;
    ubyte     maxVerSize;
    ubyte     gammaFactor;
    ubyte     dpmsFlags;
    ubyte[10] chromaInfo;
    ubyte     estTimings1;
    ubyte     estTimings2;
    ubyte     manResTiming;
    ushort[8] stdTimingID;
    ubyte[18] detTimingDesc1;
    ubyte[18] detTimingDesc2;
    ubyte[18] detTimingDesc3;
    ubyte[18] detTimingDesc4;
    ubyte     unused;
    ubyte     checksum;
}

/**
 * Information about the VBE modes
 */
struct VBEModeInfo {
    align(1):

    ubyte[16]  pad0;
    ushort     pitch;
    ushort     resX;
    ushort     resY;
    ubyte[3]   pad1;
    ubyte      bpp;
    ubyte[14]  pad2;
    uint       framebuffer;
    ubyte[212] pad3;
}

/**
 * Returned from the real mode calls
 */
struct GetVBE {
    uint   vbeMode; /// Is a 32 bit pointer to VBEModeInfo
    ushort mode;
}

private extern(C) void getVBEInfo(VBEInfo*);
private extern(C) void getEDIDInfo(EDIDInfo*);
private extern(C) void getVBEModeInfo(GetVBE*);
private extern(C) void setVBEMode(ushort);

private __gshared VBEInfo      vbeInfo;
private __gshared EDIDInfo     edidInfo;
private __gshared VBEModeInfo  vbeMode;
private __gshared GetVBE       getVBE;
private __gshared ushort[1024] videoModes;

__gshared uint* vbeFramebuffer; /// The VBE framebuffer reported by initVBE
__gshared int   vbeWidth;       /// VBE selected mode width in pixels
__gshared int   vbeHeight;      /// VBE selected mode height in pixels
__gshared int   vbePitch;       /// The pitch of the mode

private void edidCall() {
    debug {
        print("\tCalling EDID...\n");
    }

    getEDIDInfo(&edidInfo);

    vbeWidth   = edidInfo.detTimingDesc1[2];
    vbeWidth  += (edidInfo.detTimingDesc1[4] & 0xF0) << 4;
    vbeHeight  = edidInfo.detTimingDesc1[5];
    vbeHeight += (edidInfo.detTimingDesc1[7] & 0xF0) << 4;

    if (!vbeWidth || !vbeHeight) {
        warning("EDID returned 0, defaulting to 1024x768");
        vbeWidth  = 1024;
        vbeHeight = 768;
    }

    debug {
        print("\tEDID resolution: %ux%u\n", vbeWidth, vbeHeight);
    }
}

/**
 * Initialise the VBE interface, filling the global variables in the process
 */
void initVBE() {
    import memory.virtual: pageMap, mapPage;
    import util.lib:       areEquals;

    info("Initialising VBE");

    getVBEInfo(&vbeInfo);

    // Copy the video mode array somewhere else because it might get overwritten
    for (auto i = 0; ; i++) {
        videoModes[i] = (cast(ushort*)(vbeInfo.videoModes + physicalMemoryOffset))[i];

        if ((cast(ushort*)vbeInfo.videoModes)[i + 1] == 0xFFFF) {
            videoModes[i + 1] = 0xFFFF;
            break;
        }
    }

    debug {
        print("\tVersion: %u.%u\n", vbeInfo.versionMajor, vbeInfo.versionMin);
        print("\tOEM: %s\n", cast(char*)(vbeInfo.oem + physicalMemoryOffset));
        print("\tGraphics vendor: %s\n", cast(char*)(vbeInfo.vendor + physicalMemoryOffset));
        print("\tProduct name: %s\n", cast(char*)(vbeInfo.productName + physicalMemoryOffset));
        print("\tProduct revision: %s\n", cast(char*)(vbeInfo.productReview + physicalMemoryOffset));
    }

    edidCall();

    debug {
        print("\tTarget resolution: %ux%u\n", vbeWidth, vbeHeight);
    }

    // Try to set the mode
    getVBE.vbeMode = cast(uint)(cast(size_t)&vbeMode - kernelPhysicalMemoryOffset);

    for (auto i = 0; videoModes[i] != 0xFFFF; i++) {
        getVBE.mode = videoModes[i];
        getVBEModeInfo(&getVBE);

        if (vbeMode.resX == vbeWidth && vbeMode.resY == vbeHeight
            && vbeMode.bpp == 32) {
            // Mode found
            debug {
                print("\tFound matching mode %x, attempting to set.\n", getVBE.mode);
            }

            vbeFramebuffer = cast(uint*)(vbeMode.framebuffer + physicalMemoryOffset);
            vbePitch       = vbeMode.pitch;

            debug {
                print("\tFramebuffer address: %x\n", vbeMode.framebuffer + physicalMemoryOffset);
            }

            setVBEMode(getVBE.mode);

            return;
        }
    }

    // Modeset failed, panic
    panic("VESA VBE modesetting failed");
}
