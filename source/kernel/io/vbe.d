/**
 * License: (C) 2019 the takao authors (AUTHORS.md). All rights reserved
 * This code is governed by a license that can be found in LICENSE.md
 */

module io.vbe;

import memory;
import util.lib;

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

/**
 * Initialise the VBE interface, filling the global variables in the process
 */
void initVBE() {
    import memory.virtual;

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
        log("Version: %u.%u", vbeInfo.versionMajor, vbeInfo.versionMin);
        log("OEM: %s", cast(char*)(vbeInfo.oem + physicalMemoryOffset));
        log("Graphics vendor: %s", cast(char*)(vbeInfo.vendor + physicalMemoryOffset));
        log("Product name: %s", cast(char*)(vbeInfo.productName + physicalMemoryOffset));
        log("Product revision: %s", cast(char*)(vbeInfo.productReview + physicalMemoryOffset));
    }

    edidCall();

    debug {
        log("Target resolution: %ux%u", vbeWidth, vbeHeight);
    }

    // Try to set the mode
    getVBE.vbeMode = cast(uint)(cast(size_t)&vbeMode - kernelPhysicalMemoryOffset);

    for (auto i = 0; videoModes[i] != 0xFFFF; i++) {
        getVBE.mode = videoModes[i];
        getVBEModeInfo(&getVBE);

        if (vbeMode.resX == vbeWidth && vbeMode.resY == vbeHeight && vbeMode.bpp == 32) {
            // Mode found
            debug {
                log("Found matching mode %x, attempting to set", getVBE.mode);
            }

            vbeFramebuffer = cast(uint*)(vbeMode.framebuffer + physicalMemoryOffset);
            vbePitch       = vbeMode.pitch;

            debug {
                log("Framebuffer address: %x", vbeMode.framebuffer + physicalMemoryOffset);
            }

            setVBEMode(getVBE.mode);

            // Make the framebuffer write-combining
            size_t fbPages = ((vbePitch * vbeHeight) + pageSize - 1) / pageSize;

            foreach (j; 0..fbPages) {
                remapPage(kernelPageMap, cast(size_t)vbeFramebuffer + j * pageSize, 0x03 | (1 << 7) | (1 << 3));
            }

            return;
        }
    }

    // Modeset failed, panic
    panic("VESA VBE modesetting failed");
}

private void edidCall() {
    debug {
        log("Calling EDID...");
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
        log("EDID resolution: %ux%u", vbeWidth, vbeHeight);
    }
}
