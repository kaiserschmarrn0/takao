// File: archhandlers.h
//
// Description: Main header of all the handlers
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#pragma once

// All the arch-dependent handlers

// The "unknown" handler
#include "unknown.h"
// The "unknown_software" handler
#include "unknown_software.h"
// The "unknown_irq" handler
#include "unknown_irq.h"
// The "df" handler
#include "df.h"
// The "gp" handler
#include "gp.h"
// The "pf" handler
#include "pf.h"
// The "ud" handler
#include "ud.h"