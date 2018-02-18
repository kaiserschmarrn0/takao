// graphicsmode.c

// Description: Set graphic mode

// Copyright 2018 The Takao Authors (AUTHORS.md). All rights reserved.
// Use of this source code is governed by a license that can be
// found in the LICENSE.md file, in the root directory of
// the source package.

#include "graphicsmode.h"

EFI_STATUS select_mode(struct graphics_info *gs, uint32_t *mode);

void graph_memcpy(void *dest, const void *src, uint64_t len) {
	uint8_t *d = dest;
	const uint8_t *s = src;
	for(uint64_t i = 0; i < len; i++, d++, s++) {
		*d = *s;
	}
}

EFI_STATUS init_graphics(const struct uefi *uefi, struct graphics_info *gs)
{

	EFI_GUID graphics_proto = EFI_GRAPHICS_OUTPUT_PROTOCOL_GUID;
	EFI_STATUS status = uefi->system_table->BootServices->LocateProtocol(&graphics_proto, NULL,
																		 (void **)&gs->protocol);
	ASSERT_EFI_STATUS(status);

	UINT32 new_mode = gs->protocol->Mode->Mode;
	status = select_mode(gs, &new_mode);
	ASSERT_EFI_STATUS(status);
	status = gs->protocol->SetMode(gs->protocol, new_mode);
	ASSERT_EFI_STATUS(status);

	gs->buffer_base = (void*)gs->protocol->Mode->FrameBufferBase;
	gs->buffer_size = gs->protocol->Mode->FrameBufferSize;

	return EFI_SUCCESS;
}

EFI_STATUS select_mode(struct graphics_info *gs, uint32_t *mode)
{
	EFI_GRAPHICS_OUTPUT_MODE_INFORMATION most_appropriate_info;
	EFI_GRAPHICS_OUTPUT_MODE_INFORMATION *info;
	UINTN size;

	// Initialize info of current mode
	EFI_STATUS status = gs->protocol->QueryMode(gs->protocol, *mode, &size, &info);
	ASSERT_EFI_STATUS(status);
	graph_memcpy(&most_appropriate_info, info, sizeof(EFI_GRAPHICS_OUTPUT_MODE_INFORMATION));

	// Look for a better mode
	for(UINT32 i = 0; i < gs->protocol->Mode->MaxMode; i += 1) {
		// Find out the parameters of the mode we’re looking at
		EFI_STATUS status = gs->protocol->QueryMode(gs->protocol, i, &size, &info);
		ASSERT_EFI_STATUS(status);
		// We only accept RGB or BGR 8 bit colorspaces.
		if(info->PixelFormat != PixelRedGreenBlueReserved8BitPerColor &&
		   info->PixelFormat != PixelBlueGreenRedReserved8BitPerColor) {
			continue;
		}
		// If either of resolutions exceed appropriate w/h we cannot use the mode.
		if(info->HorizontalResolution > GRAPHICS_MOST_APPROPRIATE_W ||
		   info->VerticalResolution > GRAPHICS_MOST_APPROPRIATE_H) {
			continue;
		}
		// Obviously the best mode!
		if(info->VerticalResolution == GRAPHICS_MOST_APPROPRIATE_H &&
		   info->HorizontalResolution == GRAPHICS_MOST_APPROPRIATE_W) {
			graph_memcpy(&most_appropriate_info, info, sizeof(EFI_GRAPHICS_OUTPUT_MODE_INFORMATION));
			*mode = i;
			break;
		}
		// Otherwise we have an arbitrary preferece to get as much vertical resolution as possible.
		if(info->VerticalResolution > most_appropriate_info.VerticalResolution) {
			graph_memcpy(&most_appropriate_info, info, sizeof(EFI_GRAPHICS_OUTPUT_MODE_INFORMATION));
			*mode = i;
		}
	}
	gs->height = info->VerticalResolution;
	gs->width = info->HorizontalResolution;
	graph_memcpy(&gs->output_mode, &most_appropriate_info, sizeof(EFI_GRAPHICS_OUTPUT_MODE_INFORMATION));
	return EFI_SUCCESS;
}