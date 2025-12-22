; ; CS-240 World 7
;
; @file player_graphics.asm
; @brief Handles code pertaining to player graphics
; @author Ashkan Khilwatgar and Sasha Knoll
; @date November 2nd, 2025
; @license This file is licensed under the MIT License. See LICENSE.md for details.
;
; build with:
; make

include "src/utils.inc"
include "src/wram.inc"
include "src/graphics.inc"
include "src/global_vars.inc"
include "src/generalized_player_macros.inc"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

section "player_graphics", rom0

;initalizes player display and coordinates
init_player:
    ;Professor Strash said these arguments are not magic numbers when I saw him in office hours on 10/28
    DisplaySprite PLAYER_ADDRESS_TILE_1, 40, 120, 64, 0
    DisplaySprite PLAYER_ADDRESS_TILE_2, 48, 120, 65, 0
    DisplaySprite PLAYER_ADDRESS_TILE_3, 56, 120, 66, 0
    DisplaySprite PLAYER_ADDRESS_TILE_4, 40, 128, 80, 0
    DisplaySprite PLAYER_ADDRESS_TILE_5, 48, 128, 81, 0
    DisplaySprite PLAYER_ADDRESS_TILE_6, 56, 128, 82, 0

    copy [PLAYER + PLAYER_X], PLAYER_START_X - SPRITE_X_OFFSET
    copy [PLAYER + PLAYER_Y], PLAYER_START_Y - SPRITE_Y_OFFSET
    copy [PLAYER + PLAYER_HP], PLAYER_1_START_HP
    copy [PLAYER + PLAYER_HEIGHT], PLAYER_1_HEIGHT
    copy [PLAYER + PLAYER_WIDTH], PLAYER_1_WIDTH
    copy [PLAYER + PLAYER_FLICKER], 0
    ret

;initalizes health power from previous level
init_prev_hp:
    copy [PLAYER + PLAYER_PREV_HP], [PLAYER + PLAYER_HP]
    ret

;intializes current health power
init_curr_hp:
    copy [PLAYER + PLAYER_HP], [PLAYER + PLAYER_PREV_HP]
    ret

;handles translation for sprite 0 
move_player:
    ld a, [PLAYER + PLAYER_HP]
    cp MINIMUM_HP
    jr z, .dont_move
        ld a, [PAD_CURR]
        and PADF_LEFT | PADF_RIGHT | PADF_UP | PADF_DOWN
        cp PADF_LEFT | PADF_RIGHT| PADF_UP | PADF_DOWN
        jr z, .done_move
            ld a, [PAD_CURR]
            and PADF_LEFT
            jr nz, .left_checked
                ld a, [PLAYER + PLAYER_X]
                AddBetter [PLAYER + PLAYER_X], PLAYER_DECREMENT
            .left_checked
                ld a, [PAD_CURR]
                and PADF_RIGHT
                jr nz, .right_checked
                    ld a, [PLAYER + PLAYER_X]
                    AddBetter [PLAYER + PLAYER_X], PLAYER_INCREMENT
                .right_checked
                    ld a, [PAD_CURR]
                    and PADF_UP
                    jr nz, .up_checked
                        ld a, [PLAYER + PLAYER_Y]
                        AddBetter [PLAYER + PLAYER_Y], PLAYER_DECREMENT
                    .up_checked
                        ld a, [PAD_CURR]
                        and PADF_DOWN
                        jr nz, .down_checked
                            ld a, [PLAYER + PLAYER_X]
                            AddBetter [PLAYER + PLAYER_Y], PLAYER_INCREMENT
                            .down_checked
                                jr .done_move
    .dont_move
        copy [PLAYER + PLAYER_X], -SPRITE_X_OFFSET 
        copy [PLAYER + PLAYER_Y], -SPRITE_Y_OFFSET

    .done_move
    ret

;updates player coordinates from global coordinates
update_player_from_global:
    ; subtract scroll coordinate and add 8 to transform to screen x-coordinate
    ld a, [rSCX]
    ld b, a
    ld a, [PLAYER + PLAYER_X]
    sub b
    add OAM_X_OFS

    ld [PLAYER_ADDRESS_TILE_1 + OAMA_X], a
    ld [PLAYER_ADDRESS_TILE_4 + OAMA_X], a
    add SPRITE_WIDTH
    ld [PLAYER_ADDRESS_TILE_2 + OAMA_X], a
    ld [PLAYER_ADDRESS_TILE_5 + OAMA_X], a
    add SPRITE_WIDTH
    ld [PLAYER_ADDRESS_TILE_3 + OAMA_X], a
    ld [PLAYER_ADDRESS_TILE_6 + OAMA_X], a

    ld a, [rSCY]
    ld b, a
    ld a, [PLAYER + PLAYER_Y]
    sub b
    add OAM_Y_OFS 

    ld [PLAYER_ADDRESS_TILE_1 + OAMA_Y], a
    ld [PLAYER_ADDRESS_TILE_2 + OAMA_Y], a 
    ld [PLAYER_ADDRESS_TILE_3 + OAMA_Y], a 
    add SPRITE_HEIGHT
    ld [PLAYER_ADDRESS_TILE_4 + OAMA_Y], a
    ld [PLAYER_ADDRESS_TILE_5 + OAMA_Y], a 
    ld [PLAYER_ADDRESS_TILE_6 + OAMA_Y], a 

    ret

;detects collisions with HUD    
detect_collision_with_HUD:
    ld a, [PLAYER + PLAYER_Y]
    add PLAYER_HEIGHT * 2
    dec a
    cp TOP_OF_HUD
    jr nz, .no_contact_detected
        AddBetter [PLAYER + PLAYER_Y], PLAYER_DECREMENT
    .no_contact_detected
    ret

;checks for collisions with the left, right, and top boundaries of window
detect_collision_with_wall:
    ld a, [PLAYER + PLAYER_X]
    inc a
    cp LEFT_OF_SCREEN
    jr nz, .no_contact_detected_left
        AddBetter [PLAYER + PLAYER_X], PLAYER_INCREMENT
        jr .done
    .no_contact_detected_left
        add PLAYER_WIDTH * PLAYER_MULTIPLY_WIDTH_OFFSET
        add PLAYER_WIDTH / PLAYER_DIVIDE_WIDTH_OFFSET 
        cp RIGHT_OF_SCREEN
        jr nz, .no_contact_detected_right
            AddBetter [PLAYER + PLAYER_X], PLAYER_DECREMENT
            jr .done
    .no_contact_detected_right
        ld a, [PLAYER + PLAYER_Y]
        inc a
        cp TOP_OF_SCREEN
        jr nz, .done
            AddBetter [PLAYER + PLAYER_Y], PLAYER_INCREMENT
    .done
    ret

;inverts the player if hit. 
update_player_flicker:
    ld a, [PLAYER + PLAYER_FLICKER]
    cp 0 
    jr z, .done_flickering
        ld a, [PLAYER + PLAYER_FLICKER]
        dec a
        ld [PLAYER + PLAYER_FLICKER], a

        and FLICKER_COMPARISON
        jr nz, .no_toggle
            InvertPlayer PLAYER_ADDRESS_TILE_1
            jr .done_flickering
        
        .no_toggle
            ld a, [PLAYER + PLAYER_FLICKER]
            cp 0 
            jr nz, .done_flickering
                InvertPlayer PLAYER_ADDRESS_TILE_1
    .done_flickering
    RevertPlayer PLAYER_ADDRESS_TILE_1
    ret

export init_player, move_player, update_player_from_global, init_prev_hp, init_curr_hp, \ 
detect_collision_with_HUD, detect_collision_with_wall, update_player_flicker