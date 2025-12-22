; ; CS-240 World 7
;
; @file player_missile.asm
; @brief Handles player missile logic
; @author Ashkan Khilwatgar and Sasha Knoll
; @date November 12th, 2025
; @license This file is licensed under the MIT License. See LICENSE.md for details.
;
; build with:
; make

include "src/utils.inc"
include "src/wram.inc"
include "src/graphics.inc"
include "src/global_vars.inc"
include "src/generalized_missile_macros.inc"
include "src/joypad.inc"


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

section "player_missile_graphics", rom0

;allows player to shoot when A is pressed and missile is not already shot
player_shoot:
    ld a, [PLAYER + PLAYER_HP]
    cp MINIMUM_HP
    jr c, .move_missile_out_of_screen
        ld a, [PAD_CURR]
        and PADF_A
        jr nz, .dont_shoot
            ld a, [PLAYER_MISSILE_ATTR + MISSILE_SHOT_FLAG]
                cp PLAYER_MISSILE_NOT_SHOT
                jr nz, .dont_shoot
                    ld a, [PLAYER + PLAYER_X]
                    add SPRITE_WIDTH
                    copy [PLAYER_MISSILE_ATTR + MISSILE_X], a
                    
                    ld a, [PLAYER + PLAYER_Y]
                    copy [PLAYER_MISSILE_ATTR + MISSILE_Y], a

                    copy [PLAYER_MISSILE_ATTR + MISSILE_SHOT_FLAG], PLAYER_MISSILE_SHOT
                    jr .dont_shoot
    ;moves missile out of screen and resets shot flag
    .move_missile_out_of_screen
        copy [PLAYER_MISSILE_ATTR + MISSILE_X], -SPRITE_X_OFFSET
        copy [PLAYER_MISSILE_ATTR + MISSILE_Y], -SPRITE_Y_OFFSET
        copy [PLAYER_MISSILE_ATTR + MISSILE_SHOT_FLAG], PLAYER_MISSILE_SHOT

    .dont_shoot
    ret

;allows player to shoot when B is pressed and missile is not already shot
player_shoot_2:
    ld a, [PLAYER + PLAYER_HP]
    cp MINIMUM_HP
    jr c, .move_missile_out_of_screen
        ld a, [PAD_CURR]
        and PADF_B
        jr nz, .dont_shoot
            ld a, [PLAYER_MISSILE_2_ATTR + MISSILE_SHOT_FLAG]
            cp PLAYER_MISSILE_2_NOT_SHOT
            jr nz, .dont_shoot
                ld a, [PLAYER + PLAYER_X]
                add SPRITE_WIDTH
                copy [PLAYER_MISSILE_2_ATTR + MISSILE_X], a
                
                ld a, [PLAYER + PLAYER_Y]
                copy [PLAYER_MISSILE_2_ATTR + MISSILE_Y], a

                copy [PLAYER_MISSILE_2_ATTR + MISSILE_SHOT_FLAG], PLAYER_MISSILE_2_SHOT
            jr .dont_shoot
    ;moves missile out of screen and resets shot flag
    .move_missile_out_of_screen
        copy [PLAYER_MISSILE_2_ATTR + MISSILE_X], -SPRITE_X_OFFSET
        copy [PLAYER_MISSILE_2_ATTR + MISSILE_Y], -SPRITE_Y_OFFSET
        copy [PLAYER_MISSILE_2_ATTR + MISSILE_SHOT_FLAG], PLAYER_MISSILE_2_SHOT

    .dont_shoot
    ret

export player_shoot, player_shoot_2