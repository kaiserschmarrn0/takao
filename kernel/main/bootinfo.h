// File: bootinfo.h
//
// Description: Defines the main kernel function struct
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#pragma once

#include <inttypes.h>
#include <stdbool.h>
#include <stddef.h>

struct graphics_buffer {
	void*    buffer_base;
	uint64_t buffer_size;
	int      height;
	int      width;
};
	
struct bootinfo {
	struct graphics_buffer graphics_buffer;
};