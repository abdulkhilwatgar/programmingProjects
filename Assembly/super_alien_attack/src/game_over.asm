; ; CS-240 World 7
;
; @file game_over.asm
; @brief Handles logic for when the game is over
; @author Ashkan Khilwatgar and Sasha Knoll
; @date November 2nd, 2025
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

section "game_over", rom0

game_over:
    DisableLCD
    ;writes game over message to window
    ld a, SCB_SOURCE
    ld [rWY], a
    ld a, SCB_START
    ld [rWX], a
    ld hl, GAME_OVER_MESSAGE_ADDR
    ld de, GAME_OVER_MESSAGE
    call write_to_window

    ;check hp level for win/lose display
    ld a, [PLAYER + PLAYER_HP]
    cp MINIMUM_HP
    jr z, .display_lost_message
        ;writes you won message to window
        ld hl, WIN_MESSAGE_ADDR
        ld de, WIN_MESSAGE
        call write_to_window
        jr .dont_display_lost_message
        
    ;writes you lost message to window
    .display_lost_message
        ld hl, WIN_MESSAGE_ADDR
        ld de, LOST_MESSAGE
        call write_to_window

    .dont_display_lost_message
        ;writes play again message to window
        ld hl, PLAY_AGAIN_MESSAGE_ADDR
        ld de, PLAY_AGAIN_MESSAGE
        call write_to_window

        ;overwrites tiles on window to get rid of a half planet
        ld hl, PLANET_OVERWRITE_ADDRESS
        ld [hl], PLANET_OVERWRITE_TILE_1
        
        inc hl
        ld [hl], PLANET_OVERWRITE_TILE_2

        ;writes press A to replay message to window
        ld hl, CLICK_MESSAGE_ADDR
        ld de, CLICK_MESSAGE
        call write_to_window

        EnableLCDWIN9C00
        ret

export game_over