; ; CS-240 World 7
;
; @file level_2.asm
; @brief Handles logic for level 2
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

section "level_2", rom0

init_level_2:
    call init_prev_hp

    DisableLCD
    call init_graphics

    call init_player

    ;init sprite 1
    InitSprite SPRITE_1_X_START, SPRITE_1_Y_START, SPRITE_1, SPRITE_1_ADDRESS_TILE_1, \
    SPRITE_1_ADDRESS_TILE_2, SPRITE_1_ADDRESS_TILE_3, SPRITE_1_ADDRESS_TILE_4, \
    SPRITE_1_START_X, SPRITE_1_START_Y

    ;init sprite 2
    InitSprite SPRITE_2_X_START, SPRITE_2_Y_START, SPRITE_2, SPRITE_2_ADDRESS_TILE_1, \
    SPRITE_2_ADDRESS_TILE_2, SPRITE_2_ADDRESS_TILE_3, SPRITE_2_ADDRESS_TILE_4, \
    SPRITE_2_START_X, SPRITE_2_START_Y

    ;init sprite 3
    InitSprite SPRITE_3_X_START, SPRITE_3_Y_START, SPRITE_3, SPRITE_3_ADDRESS_TILE_1, \
    SPRITE_3_ADDRESS_TILE_2, SPRITE_3_ADDRESS_TILE_3, SPRITE_3_ADDRESS_TILE_4, \
    SPRITE_3_START_X, SPRITE_3_START_Y

    ;init player missile
    InitMissile PLAYER_MISSILE_ATTR, PLAYER_MISSILE_TILEID, PLAYER_MISSILE_NOT_SHOT, PLAYER_MISSILE

    ;init missile 1,2,3
    InitMissile MISSILE_1, SPRITE_MISSILE_TILEID, MISSILE_1_NOT_SHOT, MISSILE_SPRITE_1
    InitMissile MISSILE_2, SPRITE_MISSILE_TILEID, MISSILE_2_NOT_SHOT, MISSILE_SPRITE_2
    InitMissile MISSILE_3, SPRITE_MISSILE_TILEID, MISSILE_3_NOT_SHOT, MISSILE_SPRITE_3

    call update_player_from_global
    UpdateMissileFromGlobal PLAYER_MISSILE_ATTR, PLAYER_MISSILE
    UpdateMissileFromGlobal MISSILE_1, MISSILE_SPRITE_1
    UpdateMissileFromGlobal MISSILE_2, MISSILE_SPRITE_2
    UpdateMissileFromGlobal MISSILE_3, MISSILE_SPRITE_3

    UpdateSpriteFromGlobal SPRITE_1, SPRITE_1_ADDRESS_TILE_1, SPRITE_1_ADDRESS_TILE_2, \
    SPRITE_1_ADDRESS_TILE_3, SPRITE_1_ADDRESS_TILE_4
    UpdateSpriteFromGlobal SPRITE_2, SPRITE_2_ADDRESS_TILE_1, SPRITE_2_ADDRESS_TILE_2, \
    SPRITE_2_ADDRESS_TILE_3, SPRITE_2_ADDRESS_TILE_4
    UpdateSpriteFromGlobal SPRITE_3, SPRITE_3_ADDRESS_TILE_1, SPRITE_3_ADDRESS_TILE_2, \
    SPRITE_3_ADDRESS_TILE_3, SPRITE_3_ADDRESS_TILE_4

    InitJoypad
    EnableLCDWIN9C00

    ;writes level 2 message to window
    DisableLCD
    ld hl, LEVEL_2_MESSAGE_ADDR
    ld de, LEVEL_2_MESSAGE
    call write_to_window
    EnableLCDWIN9C00
    RemoveWindowTimed

    EnableSprites
    ;init the HP to be the HP of the previous rounds
    call init_curr_hp
    InitFrameCounter
    copy [AMOUNT_ENEMIES], ROUND_2_ENEMIES

    ret

level_2:
    .loop_round_2
        ld a, [AMOUNT_ENEMIES]
        cp MINIMUM_ENEMIES
        jp z, .round_2_done
            UpdateJoypad
            AddBetter [FRAME_COUNTER], FRAME_INCREMENT
            call detect_collision_with_HUD
            call detect_collision_with_wall
            call move_player

            ld a, [FRAME_COUNTER]
            and FRAME_MOVE_MOD
            jp nz, .skip_sprite_updates
                UpdateSprite SPRITE_1, SPRITE_1_ADDRESS_TILE_1, SPRITE_1_ADDRESS_TILE_2, \
                SPRITE_1_ADDRESS_TILE_3, SPRITE_1_ADDRESS_TILE_4

                UpdateSprite SPRITE_2, SPRITE_2_ADDRESS_TILE_1, SPRITE_2_ADDRESS_TILE_2, \
                SPRITE_2_ADDRESS_TILE_3, SPRITE_2_ADDRESS_TILE_4

                UpdateSprite SPRITE_3, SPRITE_3_ADDRESS_TILE_1, SPRITE_3_ADDRESS_TILE_2, \
                SPRITE_3_ADDRESS_TILE_3, SPRITE_3_ADDRESS_TILE_4
            .skip_sprite_updates

            call player_shoot
            MovePlayerMissile PLAYER_MISSILE_ATTR, PLAYER_MISSILE_NOT_SHOT

            SpriteShoot SPRITE_1, MISSILE_1, MISSILE_1_NOT_SHOT, MISSILE_1_SHOT, MISSILE_SPRITE_1
            SpriteShoot SPRITE_2, MISSILE_2, MISSILE_2_NOT_SHOT, MISSILE_2_SHOT, MISSILE_SPRITE_2
            SpriteShoot SPRITE_3, MISSILE_3, MISSILE_3_NOT_SHOT, MISSILE_3_SHOT, MISSILE_SPRITE_3

            ld a, [FRAME_COUNTER]
            and FRAME_DETECT_MOD
            jp nz, .dont_detect
                CheckCollisionsPlayerMissile SPRITE_1, PLAYER_MISSILE_ATTR
                CheckCollisionsPlayerMissile SPRITE_2, PLAYER_MISSILE_ATTR
                CheckCollisionsPlayerMissile SPRITE_3, PLAYER_MISSILE_ATTR
                CheckCollisionSpriteMissiles MISSILE_1, PLAYER, MISSILE_1_NOT_SHOT, MISSILE_SPRITE_1
                CheckCollisionSpriteMissiles MISSILE_2, PLAYER, MISSILE_2_NOT_SHOT, MISSILE_SPRITE_2
                CheckCollisionSpriteMissiles MISSILE_3, PLAYER, MISSILE_3_NOT_SHOT, MISSILE_SPRITE_3
            .dont_detect

            halt
            call update_player_flicker
            call update_HUD
            call detect_collision_with_HUD
            call detect_collision_with_wall

            UpdateMissileFromGlobal PLAYER_MISSILE_ATTR, PLAYER_MISSILE
            UpdateMissileFromGlobal MISSILE_1, MISSILE_SPRITE_1
            UpdateMissileFromGlobal MISSILE_2, MISSILE_SPRITE_2
            UpdateMissileFromGlobal MISSILE_3, MISSILE_SPRITE_3

            UpdateSpriteFromGlobal SPRITE_1, SPRITE_1_ADDRESS_TILE_1, SPRITE_1_ADDRESS_TILE_2, \
            SPRITE_1_ADDRESS_TILE_3, SPRITE_1_ADDRESS_TILE_4
            UpdateSpriteFromGlobal SPRITE_2, SPRITE_2_ADDRESS_TILE_1, SPRITE_2_ADDRESS_TILE_2, \
            SPRITE_2_ADDRESS_TILE_3, SPRITE_2_ADDRESS_TILE_4
            UpdateSpriteFromGlobal SPRITE_3, SPRITE_3_ADDRESS_TILE_1, SPRITE_3_ADDRESS_TILE_2, \
            SPRITE_3_ADDRESS_TILE_3, SPRITE_3_ADDRESS_TILE_4

            AnimateSprites SPRITE_1, SPRITE_1_ADDRESS_TILE_1
            AnimateSprites SPRITE_2, SPRITE_2_ADDRESS_TILE_1
            AnimateSprites SPRITE_3, SPRITE_3_ADDRESS_TILE_1

            call update_player_from_global

            call update_HUD
            ld a, [PLAYER + PLAYER_HP]
            cp MINIMUM_HP
            jp nz, .loop_round_2
    .round_2_done
    ret

export init_level_2, level_2
