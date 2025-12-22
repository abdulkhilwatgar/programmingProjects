; ; CS-240 World 7
;
; @file game_song.asm
; @brief Contains the notes for the song
; @author Ashkan Khilwatgar and Sasha Knoll
; @date November 18th, 2025
; @license This file is licensed under the MIT License. See LICENSE.md for details.

; build with:
; make

include "hUGE.inc"

SECTION "track_1 Song Data", ROMX

track_1::
db 10
dw order_cnt
dw order1, order2, order3, order4
dw duty_instruments, wave_instruments, noise_instruments
dw routines
dw waves

order_cnt: db 2
order1: dw P0
order2: dw P1
order3: dw P2
order4: dw P3

P0:
 dn E_4,4,$000
 dn ___,0,$000
 dn G_4,4,$000
 dn ___,0,$000
 dn A_4,4,$000
 dn ___,0,$000
 dn G_4,4,$000
 dn ___,0,$000
 dn ___,0,$000
 dn D_4,4,$000
 dn ___,0,$000
 dn B_3,4,$000
 dn ___,0,$000
 dn D_4,4,$000
 dn ___,0,$000
 dn E_4,4,$000
 dn ___,0,$000
 dn ___,0,$000
 dn G_4,4,$000
 dn ___,0,$000
 dn A_4,4,$000
 dn ___,0,$000
 dn B_4,4,$000
 dn ___,0,$000
 dn A_4,4,$000
 dn ___,0,$000
 dn ___,0,$000
 dn G_4,4,$000
 dn ___,0,$000
 dn E_4,4,$000
 dn ___,0,$000
 dn D_4,4,$000
 dn ___,0,$000
 dn E_4,4,$000
 dn ___,0,$000
 dn ___,0,$000
 dn G_4,4,$000
 dn A_4,4,$000
 dn B_4,4,$000
 dn D_5,4,$000
 dn B_4,4,$000
 dn A_4,4,$000
 dn G_4,4,$000
 dn E_4,4,$000
 dn E_4,4,$000
 dn ___,0,$000
 dn G_4,4,$000
 dn A_4,4,$000
 dn B_4,4,$000
 dn D_4,4,$000
 dn B_4,4,$000
 dn A_5,4,$000
 dn G_5,4,$000
 dn E_5,4,$000
 dn E_5,4,$000
 dn ___,0,$000
 dn B_5,4,$000
 dn C_5,4,$000
 dn G_6,4,$000
 dn F#6,4,$000
 dn D_6,4,$000
 dn C_5,4,$000
 dn B_5,4,$000
 dn E_6,4,$B00

P1:
 dn G_4,6,$000
 dn ___,0,$000
 dn B_4,6,$000
 dn ___,0,$000
 dn C_4,6,$000
 dn ___,0,$000
 dn B_4,6,$000
 dn ___,0,$000
 dn ___,0,$000
 dn F#4,6,$000
 dn ___,0,$000
 dn D_4,6,$000
 dn ___,0,$000
 dn F#4,6,$000
 dn ___,0,$000
 dn G_4,6,$000
 dn ___,0,$000
 dn ___,0,$000
 dn B_4,6,$000
 dn ___,0,$000
 dn C_4,6,$000
 dn ___,0,$000
 dn D_5,6,$000
 dn ___,0,$000
 dn C_4,6,$000
 dn ___,0,$000
 dn ___,0,$000
 dn B_4,6,$000
 dn ___,0,$000
 dn G_4,6,$000
 dn ___,0,$000
 dn F#4,6,$000
 dn ___,0,$000
 dn G_4,6,$000
 dn ___,0,$000
 dn ___,0,$000
 dn E_4,6,$000
 dn F#4,6,$000
 dn G_4,6,$000
 dn B_4,6,$000
 dn G_4,6,$000
 dn F#4,6,$000
 dn E_4,6,$000
 dn C_3,6,$000
 dn C_3,6,$000
 dn ___,0,$000
 dn E_4,6,$000
 dn F#4,6,$000
 dn G_4,6,$000
 dn B_4,6,$000
 dn G_4,6,$000
 dn F#5,6,$000
 dn E_5,6,$000
 dn C_4,6,$000
 dn C_4,6,$000
 dn ___,0,$000
 dn G_5,6,$000
 dn A_5,6,$000
 dn B_5,6,$000
 dn D_5,6,$000
 dn B_5,6,$000
 dn A_5,6,$000
 dn G_5,6,$000
 dn C_5,6,$B00

P2:
 dn B_4,0,$000
 dn ___,0,$000
 dn D_4,0,$000
 dn ___,0,$000
 dn E_5,0,$000
 dn ___,0,$000
 dn D_4,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn A_4,0,$000
 dn ___,0,$000
 dn F#4,0,$000
 dn ___,0,$000
 dn A_4,0,$000
 dn ___,0,$000
 dn B_4,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn D_4,0,$000
 dn ___,0,$000
 dn E_5,0,$000
 dn ___,0,$000
 dn F#5,0,$000
 dn ___,0,$000
 dn E_5,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn D_4,0,$000
 dn ___,0,$000
 dn B_4,0,$000
 dn ___,0,$000
 dn A_4,0,$000
 dn ___,0,$000
 dn B_4,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn B_4,0,$000
 dn C_4,0,$000
 dn D_4,0,$000
 dn F#5,0,$000
 dn C_4,0,$000
 dn C_4,0,$000
 dn B_4,0,$000
 dn G_4,0,$000
 dn G_4,0,$000
 dn ___,0,$000
 dn B_4,0,$000
 dn C_4,0,$000
 dn D_4,0,$000
 dn F#5,0,$000
 dn D_4,0,$000
 dn C_5,0,$000
 dn B_5,0,$000
 dn G_5,0,$000
 dn G_5,0,$000
 dn ___,0,$000
 dn D_6,0,$000
 dn E_6,0,$000
 dn F#6,0,$000
 dn A_6,0,$000
 dn F#6,0,$000
 dn E_6,0,$000
 dn G_6,0,$000
 dn G_6,0,$B00

P3:
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000

duty_instruments:
itSquareinst1:
db 8
db 0
db 240
dw 0
db 128

itSquareinst2:
db 8
db 64
db 240
dw 0
db 128

itSquareinst3:
db 8
db 128
db 240
dw 0
db 128

itSquareinst4:
db 8
db 192
db 240
dw 0
db 128

itSquareinst5:
db 8
db 0
db 241
dw 0
db 128

itSquareinst6:
db 8
db 64
db 241
dw 0
db 128



wave_instruments:


noise_instruments:


routines:
__hUGE_Routine_0:

__end_hUGE_Routine_0:
ret

__hUGE_Routine_1:

__end_hUGE_Routine_1:
ret

__hUGE_Routine_2:

__end_hUGE_Routine_2:
ret

__hUGE_Routine_3:

__end_hUGE_Routine_3:
ret

__hUGE_Routine_4:

__end_hUGE_Routine_4:
ret

__hUGE_Routine_5:

__end_hUGE_Routine_5:
ret

__hUGE_Routine_6:

__end_hUGE_Routine_6:
ret

__hUGE_Routine_7:

__end_hUGE_Routine_7:
ret

__hUGE_Routine_8:

__end_hUGE_Routine_8:
ret

__hUGE_Routine_9:

__end_hUGE_Routine_9:
ret

__hUGE_Routine_10:

__end_hUGE_Routine_10:
ret

__hUGE_Routine_11:

__end_hUGE_Routine_11:
ret

__hUGE_Routine_12:

__end_hUGE_Routine_12:
ret

__hUGE_Routine_13:

__end_hUGE_Routine_13:
ret

__hUGE_Routine_14:

__end_hUGE_Routine_14:
ret

__hUGE_Routine_15:

__end_hUGE_Routine_15:
ret

waves:
wave0: db 0,0,255,255,255,255,255,255,255,255,255,255,255,255,255,255

