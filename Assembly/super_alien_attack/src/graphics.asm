; ; CS-240 World 7

; @file graphics.asm
; @brief Handles graphics logic
; @author Ashkan Khilwatgar and Sasha Knoll
; @date October 28th, 2025
; @license This file is licensed under the MIT License. See LICENSE.md for details.
;
; build with:
; make

include "src/utils.inc"
include "src/wram.inc"
include "src/graphics.inc"
include "src/global_vars.inc"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section "vblank_interrupt", rom0[$0040]
    reti  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; load the graphics data from ROM to VRAM
macro LoadGraphicsDataIntoVRAM
    ld de, GRAPHICS_DATA_ADDRESS_START
    ld hl, _VRAM8000
    .load_tile\@
        ld a, [de]
        inc de
        ld [hli], a
        ld a, d
        cp a, high(GRAPHICS_DATA_ADDRESS_END)
        jr nz, .load_tile\@
endm

; load extra graphcs data from ROM to VRAM
macro LoadExtraDataIntoVRAM
    .load_tiles\@
        copy [hl], [de]
        inc hl
        inc de
        dec bc 
        ld a, b
        or c
        jr nz, .load_tiles\@
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

section "graphics", rom0

;initializes the extra graphics
init_extra_graphics:
    ld a, DEFAULT_PALETTE
    ld [rBGP], a
    ld [rOBP0], a
    ld a, DEFAULT_PALETTE_INVERTED
    ld [rOBP1], a

    ld de, TILESET ;source
    ld hl, _VRAM8000 ;destination
    ld bc, EXTRA_TILESET_SIZE ;size
    LoadExtraDataIntoVRAM 

    ld de, TILEMAP ;source
    ld hl, _SCRN0 ;destination
    ld bc, TILEMAP_SIZE ;size
    LoadExtraDataIntoVRAM 

    ; enable the vblank interrupt
    ld a, IEF_VBLANK
    ldh [rIE], a
    ei

    ld a, 7
    ld [rWX], a
    ld a, 0
    ld [rWY], a

    ret

;main initialize graphics
init_graphics:
    ; init the palettes
    ld a, DEFAULT_PALETTE
    ld [rBGP], a
    ld [rOBP0], a
    ld a, DEFAULT_PALETTE_INVERTED
    ld [rOBP1], a

    ; enable the vblank interrupt
    ld a, IEF_VBLANK 
    ldh [rIE], a
    ei

    ; init graphics/OAM data
    InitOAM
    LoadGraphicsDataIntoVRAM

    ; ld de, HUD_START_TILE_INDEX -- delete this?
    ;initalizes writes to window info
    ld hl, HUD_START_ADDR_LINE_1
    ld de, HUD_TILE_INDICES_FIRST_LINE
    call write_to_window_HUD

    ld hl, HUD_START_ADDR_LINE_2
    ld de, HUD_TILE_INDICES_SECOND_LINE
    call write_to_window_HUD

    ld hl, HUD_START_ADDR_LINE_3
    ld de, HUD_TILE_INDICES_THIRD_LINE
    call write_to_window_HUD

    ld hl, HUD_START_ADDR_LINE_4
    ld de, HUD_TILE_INDICES_FOURTH_LINE
    call write_to_window_HUD

    ld de, HUD_HEALTH_MESSAGE
    ld hl, HUD_HEALTH_MESSAGE_ADDR
    call write_to_window

    ld de, HUD_ENEMIES_MESSAGE
    ld hl, HUD_ENEMY_MESSAGE_ADDR
    call write_to_window

    ; place the window at the top of the LCD
    ld a, 7
    ld [rWX], a
    ld a, 0
    ld [rWY], a

    ; set the background position
    xor a
    ld [rSCX], a
    ld [rSCY], a
    ret 

; de = address of data to read
; hl = address of destination
;write to window with our ASCII offset
write_to_window:
    .loop
        ld a, [de]  
        ;compares for null-terminated string     
        cp 0               
        jr z, .done
            sub "A"            
            add TILESET_OFFSET_CHAR          
            ld [hl], a        
            inc hl
            inc de
            jr .loop    
    .done
        ret

;write to window for heads up display
write_to_window_HUD:
    .loop
        ld a, [de]
        cp 0
        jr z, .done
            copy [hl], [de]
            inc hl
            inc de
            jr .loop
    .done
    ret

;updates heads up display
update_HUD:
    ld a, [PLAYER + PLAYER_HP]
    add TILE_OFFSET_NUMBERS 
    ld hl, ADDR_HEALTH_IN_MAP
    ld [hl], a

    ld a, [AMOUNT_ENEMIES]
    add TILE_OFFSET_NUMBERS
    ld hl, ADDR_ENEMIES_IN_MAP
    ld [hl], a
    ret

export init_graphics, init_extra_graphics, write_to_window, update_HUD, LEVEL_1_MESSAGE, \
LEVEL_2_MESSAGE, GAME_OVER_MESSAGE, PLAY_AGAIN_MESSAGE, CLICK_MESSAGE, PLANET_OVERWRITE, \
WIN_MESSAGE, LOST_MESSAGE, play_again, HUD_HEALTH_MESSAGE, HUD_ENEMIES_MESSAGE, LEVEL_3_MESSAGE

section "graphics_data", rom0[GRAPHICS_DATA_ADDRESS_START]
incbin "assets/master_tileset.chr"
incbin "assets/background.tlm"
incbin "assets/centered_window.tlm"

section "extra_graphics_data", rom0
TILESET:
incbin "assets/astro_tileset.chr"
TILEMAP:
incbin "assets/astro_tilemap.tlm"

section "text_data", rom0
LEVEL_1_MESSAGE:
    db "LEVEL:1\0" 

LEVEL_2_MESSAGE:
    db "LEVEL:2\0"

LEVEL_3_MESSAGE:
    db "LEVEL:3\0"

GAME_OVER_MESSAGE:
    db "GAME OVER\0"

PLAY_AGAIN_MESSAGE:
    db "PLAY AGAIN?\0"

CLICK_MESSAGE:
    db "A\0"

PLANET_OVERWRITE:
    db $E0, $F2, $00

WIN_MESSAGE:
    db "YOU WON!\0"

LOST_MESSAGE:
    db "YOU LOST\0"

HUD_HEALTH_MESSAGE:
    db "HEALTH:\0"

HUD_ENEMIES_MESSAGE:
    db "ENEMIES:\0"

HUD_TILE_INDICES_FIRST_LINE:
    db $80, $80, $80, $81, $82, $83, $84, $85, $83, $87, $88, $83, $84, $85, \
    $83, $8D, $8E, $80, $80, $80, $00

HUD_TILE_INDICES_SECOND_LINE:
    db $90, $90, $90, $91, $92, $40, $40, $40, $40, $40, $40, $40, $40, $40, \
    $40, $9D, $9E, $90, $90, $90, $00

HUD_TILE_INDICES_THIRD_LINE:
    db $90, $90, $90, $91, $92, $40, $40, $40, $40, $40, $40, $40, $40, $40, \
    $40, $9D, $9E, $90, $90, $90, $00

HUD_TILE_INDICES_FOURTH_LINE:
    db $B0, $B0, $B0, $B1, $B2, $B3, $B3, $B3, $B3, $B3, $B3, $B3, $B3, $B3, \
    $B3, $BD, $BE, $B0, $B0, $B0