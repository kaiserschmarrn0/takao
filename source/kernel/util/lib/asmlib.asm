; asmlib.asm - Library ASM wrappers
; (C) 2019 the takao authors (AUTHORS.md). All rights reserved
; This code is governed by a license that can be found in LICENSE.md

[bits 64]

global rdrandWrapper:function (rdrandWrapper.end - rdrandWrapper)

rdrandWrapper:
    rdrand rax
    ret
.end:
