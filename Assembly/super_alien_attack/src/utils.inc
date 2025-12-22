; ; CS-240 World 7
;
; @file utils.inc
; @brief General utility macros
; @author Ashkan Khilwatgar and Sasha Knoll
; @date October 28th, 2025
; @license This file is licensed under the MIT License. See LICENSE.md for details.
;
; build with:
; make

if !def(UTILS_INC)
def UTILS_INC equ 1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

include "src/hardware.inc"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; copy \2 into \1 through (a)
; example: copy [$FF84], 10
macro copy
    ld a, \2
    ld \1, a
endm

macro AddBetter
    ld a, \1
    add a, \2
    ld \1, a
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

endc

