; ; CS-240 World 7
;
; @file main.asm
; @brief Controls the flow of the program
; @author Ashkan Khilwatgar and Sasha Knoll
; @date October 28th, 2025
; @license This file is licensed under the MIT License. See LICENSE.md for details.
;
; build with:
; make

include "src/hardware.inc"
include "src/graphics.inc"
include "src/joypad.inc"
include "src/global_vars.inc"
include "src/utils.inc"
include "src/generalized_missile_macros.inc"
include "src/generalized_sprite_missile_collisions.inc"
include "src/generalized_sprite_macros.inc"
include "src/generalized_player_macros.inc"
include "include/hUGE.inc"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

section "header", rom0[$0100]
entrypoint:
   di
   jr main
   ds ($0150 - @), 0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

section "main", rom0[$0150]
    
main:
    ; perform any initialization before starting the game loop
    DisableLCD
    call init_extra_graphics
    EnableLCDBG8000

    RemoveWindow
    call stop_music

    .game_start
        call init_level_1
        call level_1

        ld a, [PLAYER + PLAYER_HP]
        cp MINIMUM_HP
        jr z, .all_rounds_done

        call init_level_2
        call level_2

        ld a, [PLAYER + PLAYER_HP]
        cp MINIMUM_HP
        jr z, .all_rounds_done

        call init_level_3
        call level_3

        ld a, [AMOUNT_ENEMIES]
        cp MINIMUM_ENEMIES
        jr z, .all_rounds_done
        .all_rounds_done
            call game_over
            call init_song
            .loop
                halt
                call play_song
                UpdateJoypad
                ld a, [PAD_CURR]
                and PADF_A
                jr nz, .loop             
                call stop_music
                jr .game_start