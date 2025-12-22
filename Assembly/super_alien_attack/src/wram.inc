; ; CS-240 World 7
;
; @file wram.inc
; @brief WRAM Variable locations
; @author Ashkan Khilwatgar and Sasha Knoll
; @date October 28th, 2025
; @license This file is licensed under the MIT License. See LICENSE.md for details.
;
; build with:
; make 

if !def(WRAM_INC)
def WRAM_INC equ 1

rsset _RAM
; WRAM variables for joypad
def PAD_CURR                    rb 1
def PAD_PREV                    rb 1
def PAD_PRSS                    rb 1
def PAD_RLSE                    rb 1

;WRAM variables for player
def PLAYER                      rb 9

; WRAM variables for sprites
def SPRITE_1_PALETTE_TIMER      rb 1
def ALL_NPC_DIMENSIONS          rb 1

;WRAM variables for sprite 1
def SPRITE_1                    rb 7
 
;WRAM variables for sprite 2
def SPRITE_2                    rb 7

;WRAM variables for sprite 3
def SPRITE_3                    rb 7

;WRAM variables for sprite 4
def SPRITE_4                    rb 7

;WRAM variables for missiles
def ALL_MISSILE_DIMENSIONS      rb 1

;WRAM variables for player missile 1
def PLAYER_MISSILE_ATTR         rb 3

;WRAM variables for player missile 2
def PLAYER_MISSILE_2_ATTR       rb 3

;WRAM variables for sprite missile 1
def MISSILE_1                   rb 3

;WRAM variables for sprite missile 2
def MISSILE_2                   rb 3

;WRAM variables for sprite missile 3
def MISSILE_3                   rb 3

;WRAM variables for sprite missile 4
def MISSILE_4                   rb 3

;WRAM variables for frame counter
def FRAME_COUNTER               rb 1
def FRAME_COUNTER_2             rb 1

;WRAM variables for song counter
def SONG_TICKER_COUNTER         rb 2

;WRAM variable for all enemies
def AMOUNT_ENEMIES              rb 1

def WRAM_END                    rb 0

def WRAM_USAGE equ (WRAM_END - _RAM)
println "WRAM usage: {d:WRAM_USAGE} bytes"
assert WRAM_USAGE <= $2000, "Too many bytes used in WRAM"

endc