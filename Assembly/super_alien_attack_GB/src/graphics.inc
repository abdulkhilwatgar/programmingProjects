; ; CS-240 World 7
;
; @file graphics.inc
; @brief All the macros created to handle graphics
; @author Ashkan Khilwatgar and Sasha Knoll
; @date October 28th, 2025
; @license This file is licensed under the MIT License. See LICENSE.md for details.
;
; build with:
; make

if !def(GRAPHICS_INC)
def GRAPHICS_INC equ 1

; disable the LCD
macro DisableLCD
    ; wait for the vblank
    .wait_vblank\@
        ld a, [rLY]
        cp a, SCRN_Y
        jr nz, .wait_vblank\@

    ; turn the LCD off
    xor a
    ld [rLCDC], a
endm

; clear the OAM
macro InitOAM
    ld c, OAM_COUNT
    ld hl, _OAMRAM + OAMA_Y
    ld de, sizeof_OAM_ATTRS
    .init_oam\@
        ld [hl], 0
        add hl, de
        dec c
        jr nz, .init_oam\@
endm

; set the graphics parameters and turn back LCD on
macro EnableLCD
    ld a, LCDCF_ON | LCDCF_WIN9800 | LCDCF_BG8800 | LCDCF_BG9800 \
    | LCDCF_OBJ8 | LCDCF_OBJOFF | LCDCF_BGON | LCDCF_WINON
    ld [rLCDC], a
endm

; set the graphics parameters and turn back LCD on with background set to 8000 mode
macro EnableLCDBG8000
    ld a, LCDCF_ON | LCDCF_WIN9800 | LCDCF_BG8000 | LCDCF_BG9800 \
    | LCDCF_OBJ8 | LCDCF_OBJOFF | LCDCF_BGON | LCDCF_WINON
    ld [rLCDC], a
endm

; set the graphics parameters and turn back LCD on with window set to 9C00 tilemap
macro EnableLCDWIN9C00
    ld a, LCDCF_ON | LCDCF_WIN9C00 | LCDCF_BG8800 | LCDCF_BG9800 \
    | LCDCF_OBJ8 | LCDCF_OBJOFF | LCDCF_BGON | LCDCF_WINON
    ld [rLCDC], a
endm

;remove window when start is pressed
macro RemoveWindow
   call init_song
   .start_not_pressed\@
        halt
        call play_song
        UpdateJoypad
        ld a, [PAD_CURR]
        bit 3, a
        jr nz, .start_not_pressed\@ 
            ld a, 0
            ld [rWX], a
            ld a, 144
            ld [rWY], a
            
            xor a
            ld [rTAC], a
endm

;remove window with timer instead of a button
macro RemoveWindowTimed
    ld b, WINDOW_TIMER
    .timer_not_yet_done\@
        halt
        dec b
        jr nz, .timer_not_yet_done\@
            ld a, [rWY]
            .window_descent_loop\@
                halt
                AddBetter [rWY], 1
                ld a, [rWY]
                cp BOTTOM_OF_SCREEN
                jr nz, .window_descent_loop\@
endm

;wait for timer
macro Wait
ld b, WAIT_TIMER
.timer_not_yet_done\@
    halt
    dec b
    jr nz, .timer_not_yet_done\@
endm

;enables sprites
macro EnableSprites
    halt
    ld a, [rLCDC]
    or LCDCF_OBJON
    ld [rLCDC], a
endm

;displays sprites
;\1 Sprite OAM address
;\2 x-value
;\3 y-value
;\4 tile ID
;\5 flags
macro DisplaySprite
    copy [\1 + OAMA_X], \2
    copy [\1 + OAMA_Y], \3
    copy [\1 + OAMA_TILEID], \4
    copy [\1 + OAMA_FLAGS], \5
endm

;animates sprites
;\1 Sprite WRAM address
;\2 Sprite OAM address
macro AnimateSprites
    ; update the timer
    ld a, [\1 + SPRITE_ANIMATE_TIMER]
    inc a

    and ANIMATE_SPRITE_COMPARISON
    ld [\1 + SPRITE_ANIMATE_TIMER], a

    ; based on timer, change tile for ship
    cp ANIMATE_TIMER_COMPARE_1
    jr z, .fly0\@
    cp ANIMATE_TIMER_COMPARE_2
    jr z, .fly1\@
    jr .flydone\@

    .fly0\@
        AnimateSpriteHelper \2, ANIMATE_OFFSET_1
        jr .flydone\@
    .fly1\@
        AnimateSpriteHelper \2, ANIMATE_OFFSET_2
        jr .flydone\@
    .flydone\@
endm

;helper function for animating sprites
;\1 Sprite OAM address
;\2 Tile offset
macro AnimateSpriteHelper
    ld a, [\1 + OAMA_TILEID]
    and SPRITE_MOD_TIMER
    add \2
    ld [\1 + OAMA_TILEID], a

    inc a
    ld [\1 + sizeof_OAM_ATTRS + OAMA_TILEID], a

    add ANIMATE_SPRITE_TILE_OFFSET
    ld [\1 + sizeof_OAM_ATTRS * 2 + OAMA_TILEID], a

    inc a
    ld [\1 + sizeof_OAM_ATTRS * 3 + OAMA_TILEID], a
endm

;destroys player, moves each sprite to top left of screen
macro DestroyPlayerSprite
    copy [PLAYER + PLAYER_X], -SPRITE_X_OFFSET
    copy [PLAYER + PLAYER_Y], -SPRITE_Y_OFFSET
    call update_player_from_global
endm

;initializes frame counter with 0
macro InitFrameCounter
    copy [FRAME_COUNTER], 0
    copy [FRAME_COUNTER_2], 0
endm

endc