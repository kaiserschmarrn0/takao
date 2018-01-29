// File: rtlock.c
//
// Description: Implements FLOCK
//
// License: Intel open source license, a BSD license variant.


#include "../lib.h"



#ifndef __GNUC__
	#pragma RUNTIME_CODE(RtAcquireLock)
#endif

// RtAcquireLock : Raising to the task priority level of the mutual exclusion lock, and 
//   then acquires ownership of the lock. 
VOID RtAcquireLock(IN FLOCK *Lock)
{
	if (BS) {
		if (BS->RaiseTPL != NULL) {
			Lock->OwnerTpl = uefi_call_wrapper(BS->RaiseTPL, 1, Lock->Tpl);
		} 
	}
	else {
		if (LibRuntimeRaiseTPL != NULL) {
			Lock->OwnerTpl = LibRuntimeRaiseTPL(Lock->Tpl);
		}
	}
	
	Lock->Lock += 1;
	
	ASSERT(Lock->Lock == 1);
}


#ifndef __GNUC__
	#pragma RUNTIME_CODE(RtAcquireLock)
#endif

// RtReleaseLock : Releases ownership of the mutual exclusion lock, and restores 
//   the previous task priority level.
VOID RtReleaseLock(IN FLOCK *Lock)
{
	EFI_TPL Tpl;

	Tpl = Lock->OwnerTpl;
    
	ASSERT(Lock->Lock == 1);
	Lock->Lock -= 1;
	if (BS) {
		if (BS->RestoreTPL != NULL) {
			uefi_call_wrapper(BS->RestoreTPL, 1, Tpl);
		} 
	} 
	else {
		if (LibRuntimeRestoreTPL != NULL) {
			LibRuntimeRestoreTPL(Tpl);
		}
	}
}
