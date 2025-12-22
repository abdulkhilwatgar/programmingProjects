; ; CS-240 World 7
;
; @file audio.asm
; @brief Functions for audio
; @author Ashkan Khilwatgar and Sasha Knoll
; @date November 18th, 2025
; @license This file is licensed under the MIT License. See LICENSE.md for details.

; build with:
; make

include "include/hUGE.inc"
include "src/hardware.inc"
include "src/graphics.inc"
include "src/joypad.inc"
include "src/global_vars.inc"
include "src/utils.inc"


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

section "Audio", rom0

;clears timer, volume, and interrupts, then reenables audio for sound effects
stop_music:
    ld a, 0
    ldh [rTAC], a

    xor a
    ldh [rNR52], a

    xor a
    ldh [rIF], a

    ;reenable sound for sound effects
    copy [rNR52], AUDENA_ON
    copy [rNR50], $77
    copy [rNR51], $FF

    ret

;initializes the correct timer and registers for audio, then calls the song
init_song:
    copy [SONG_TICKER_COUNTER], 0
    copy [SONG_TICKER_COUNTER + 1], 0
    
    copy [rNR52], AUDENA_ON
    copy [rNR50], $77
    copy [rNR51], $FF

    ld hl, track_1
    call hUGE_init

    ld a, SONG_TIMER_INIT 
    ldh [rTMA], a
    ld a, SONG_FREQ
    ldh [rTAC], a
    ret

;calls hUGE_dosound
;increments timer to check if the song has reached its end.
play_song:        
        push af
        push bc
        push de
        push hl
        call hUGE_dosound
        AddBetter [SONG_TICKER_COUNTER], SONG_INCREMENT
        jr nz, .no_overflow
            AddBetter [SONG_TICKER_COUNTER + 1], SONG_INCREMENT
        .no_overflow
            ld a, [SONG_TICKER_COUNTER + 1]
            ld h, a
            ld a, [SONG_TICKER_COUNTER]
            ld l, a

            ld de, SONG_LENGTH_TICKS
            ld a, h
            cp d
            jr nz, .dont_restart_song
            ld a, l
            cp e
            jr nz, .dont_restart_song
            
                ld hl, track_1
                call hUGE_init
                copy [SONG_TICKER_COUNTER], SONG_TICK_RESET
                copy [SONG_TICKER_COUNTER + 1], SONG_TICK_RESET

    .dont_restart_song
        pop hl
        pop de
        pop bc
        pop af
    ret
export play_song, init_song, stop_music