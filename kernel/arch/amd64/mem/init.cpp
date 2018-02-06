// File: init.cpp
//
// Description: Init all memory related things before any allocation
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#include <mem/init.hpp>
#include "paging.hpp"

namespace mem {
	void init(void)
	{
		// Init paging (paging.cpp/hpp)
		paging_init();
	}
}
