; ; CS-240 World 7
;
; @file level_3.asm
; @brief Handles logic for level 3
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

section "level_3", rom0

init_level_3:
    call init_prev_hp

    DisableLCD
    call init_graphics

    call init_player

    ;init sprite 1
    InitSprite SPRITE_1_X_START, SPRITE_1_Y_START, SPRITE_1, SPRITE_1_ADDRESS_TILE_1, \
    SPRITE_1_ADDRESS_TILE_2, SPRITE_1_ADDRESS_TILE_3, SPRITE_1_ADDRESS_TILE_4, \
    SPRITE_1_START_X, SPRITE_1_START_Y

    AddBetter [SPRITE_1 + SPRITE_HP_ATTR], SPRITE_INCREMENT

    ;init sprite 2
    InitSprite SPRITE_2_X_START, SPRITE_2_Y_START, SPRITE_2, SPRITE_2_ADDRESS_TILE_1, \
    SPRITE_2_ADDRESS_TILE_2, SPRITE_2_ADDRESS_TILE_3, SPRITE_2_ADDRESS_TILE_4, \
    SPRITE_2_START_X, SPRITE_2_START_Y

    AddBetter [SPRITE_2 + SPRITE_HP_ATTR], SPRITE_INCREMENT

    ;init sprite 3
    InitSprite SPRITE_3_X_START, SPRITE_3_Y_START, SPRITE_3, SPRITE_3_ADDRESS_TILE_1, \
    SPRITE_3_ADDRESS_TILE_2, SPRITE_3_ADDRESS_TILE_3, SPRITE_3_ADDRESS_TILE_4, \
    SPRITE_3_START_X, SPRITE_3_START_Y

    AddBetter [SPRITE_3 + SPRITE_HP_ATTR], SPRITE_INCREMENT

    ;init sprite 4
    InitSprite SPRITE_4_X_START, SPRITE_4_Y_START, SPRITE_4, SPRITE_4_ADDRESS_TILE_1, \
    SPRITE_4_ADDRESS_TILE_2, SPRITE_4_ADDRESS_TILE_3, SPRITE_4_ADDRESS_TILE_4, \
    SPRITE_4_START_X, SPRITE_4_START_Y

    AddBetter [SPRITE_4 + SPRITE_HP_ATTR], SPRITE_INCREMENT

    ;init player missile
    InitMissile PLAYER_MISSILE_ATTR, PLAYER_MISSILE_TILEID, PLAYER_MISSILE_NOT_SHOT, PLAYER_MISSILE
    InitMissile PLAYER_MISSILE_2_ATTR, PLAYER_MISSILE_TILEID, PLAYER_MISSILE_2_NOT_SHOT, PLAYER_MISSILE_2

    ;init missile 1,2,3
    InitMissile MISSILE_1, SPRITE_MISSILE_TILEID, MISSILE_1_NOT_SHOT, MISSILE_SPRITE_1
    InitMissile MISSILE_2, SPRITE_MISSILE_TILEID, MISSILE_2_NOT_SHOT, MISSILE_SPRITE_2
    InitMissile MISSILE_3, SPRITE_MISSILE_TILEID, MISSILE_3_NOT_SHOT, MISSILE_SPRITE_3
    InitMissile MISSILE_4, SPRITE_MISSILE_TILEID, MISSILE_4_NOT_SHOT, MISSILE_SPRITE_4

    call update_player_from_global
    UpdateMissileFromGlobal PLAYER_MISSILE_ATTR, PLAYER_MISSILE
    UpdateMissileFromGlobal PLAYER_MISSILE_2_ATTR, PLAYER_MISSILE_2

    UpdateMissileFromGlobal MISSILE_1, MISSILE_SPRITE_1
    UpdateMissileFromGlobal MISSILE_2, MISSILE_SPRITE_2
    UpdateMissileFromGlobal MISSILE_3, MISSILE_SPRITE_3
    UpdateMissileFromGlobal MISSILE_4, MISSILE_SPRITE_4
    
    UpdateSpriteFromGlobal SPRITE_1, SPRITE_1_ADDRESS_TILE_1, SPRITE_1_ADDRESS_TILE_2, \
    SPRITE_1_ADDRESS_TILE_3, SPRITE_1_ADDRESS_TILE_4
    UpdateSpriteFromGlobal SPRITE_2, SPRITE_2_ADDRESS_TILE_1, SPRITE_2_ADDRESS_TILE_2, \
    SPRITE_2_ADDRESS_TILE_3, SPRITE_2_ADDRESS_TILE_4
    UpdateSpriteFromGlobal SPRITE_3, SPRITE_3_ADDRESS_TILE_1, SPRITE_3_ADDRESS_TILE_2, \
    SPRITE_3_ADDRESS_TILE_3, SPRITE_3_ADDRESS_TILE_4
    UpdateSpriteFromGlobal SPRITE_4, SPRITE_4_ADDRESS_TILE_1, SPRITE_4_ADDRESS_TILE_2, \
    SPRITE_4_ADDRESS_TILE_3, SPRITE_4_ADDRESS_TILE_4

    InitJoypad
    EnableLCDWIN9C00

    ;writes level 2 message to window
    DisableLCD
    ld hl, LEVEL_3_MESSAGE_ADDR
    ld de, LEVEL_3_MESSAGE
    call write_to_window
    EnableLCDWIN9C00
    RemoveWindowTimed

    EnableSprites
    ;init the HP to be the HP of the previous rounds
    call init_curr_hp
    InitFrameCounter
    copy [AMOUNT_ENEMIES], ROUND_3_ENEMIES

ret

level_3:
    .loop_round_3
        UpdateJoypad
        ld a, [AMOUNT_ENEMIES]
        cp MINIMUM_ENEMIES
        jp z, .round_3_done
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

                UpdateSprite SPRITE_4, SPRITE_4_ADDRESS_TILE_1, SPRITE_4_ADDRESS_TILE_2, \
                SPRITE_4_ADDRESS_TILE_3, SPRITE_4_ADDRESS_TILE_4    
            .skip_sprite_updates

            call player_shoot
            call player_shoot_2
            MovePlayerMissile PLAYER_MISSILE_ATTR, PLAYER_MISSILE_NOT_SHOT
            MovePlayerMissile PLAYER_MISSILE_2_ATTR, PLAYER_MISSILE_2_NOT_SHOT

            SpriteShoot SPRITE_1, MISSILE_1, MISSILE_1_NOT_SHOT, MISSILE_1_SHOT, MISSILE_SPRITE_1
            SpriteShoot SPRITE_2, MISSILE_2, MISSILE_2_NOT_SHOT, MISSILE_2_SHOT, MISSILE_SPRITE_2
            SpriteShoot SPRITE_3, MISSILE_3, MISSILE_3_NOT_SHOT, MISSILE_3_SHOT, MISSILE_SPRITE_3
            SpriteShoot SPRITE_4, MISSILE_4, MISSILE_4_NOT_SHOT, MISSILE_4_SHOT, MISSILE_SPRITE_4

            ld a, [FRAME_COUNTER]
            and FRAME_DETECT_MOD
            jp nz, .dont_detect
                CheckCollisionsPlayerMissile SPRITE_1, PLAYER_MISSILE_ATTR
                CheckCollisionsPlayerMissile SPRITE_2, PLAYER_MISSILE_ATTR
                CheckCollisionsPlayerMissile SPRITE_3, PLAYER_MISSILE_ATTR
                CheckCollisionsPlayerMissile SPRITE_4, PLAYER_MISSILE_ATTR

                CheckCollisionsPlayerMissile SPRITE_1, PLAYER_MISSILE_2_ATTR
                CheckCollisionsPlayerMissile SPRITE_2, PLAYER_MISSILE_2_ATTR
                CheckCollisionsPlayerMissile SPRITE_3, PLAYER_MISSILE_2_ATTR
                CheckCollisionsPlayerMissile SPRITE_4, PLAYER_MISSILE_2_ATTR

                CheckCollisionSpriteMissiles MISSILE_1, PLAYER, MISSILE_1_NOT_SHOT, MISSILE_SPRITE_1
                CheckCollisionSpriteMissiles MISSILE_2, PLAYER, MISSILE_2_NOT_SHOT, MISSILE_SPRITE_2
                CheckCollisionSpriteMissiles MISSILE_3, PLAYER, MISSILE_3_NOT_SHOT, MISSILE_SPRITE_3
                CheckCollisionSpriteMissiles MISSILE_4, PLAYER, MISSILE_4_NOT_SHOT, MISSILE_SPRITE_4

            .dont_detect
                halt
                call update_player_flicker
                call update_HUD
                call detect_collision_with_HUD
                call detect_collision_with_wall

                UpdateMissileFromGlobal PLAYER_MISSILE_ATTR, PLAYER_MISSILE
                UpdateMissileFromGlobal PLAYER_MISSILE_2_ATTR, PLAYER_MISSILE_2
                UpdateMissileFromGlobal MISSILE_1, MISSILE_SPRITE_1
                UpdateMissileFromGlobal MISSILE_2, MISSILE_SPRITE_2
                UpdateMissileFromGlobal MISSILE_3, MISSILE_SPRITE_3
                UpdateMissileFromGlobal MISSILE_4, MISSILE_SPRITE_4

                UpdateSpriteFromGlobal SPRITE_1, SPRITE_1_ADDRESS_TILE_1, SPRITE_1_ADDRESS_TILE_2, \
                SPRITE_1_ADDRESS_TILE_3, SPRITE_1_ADDRESS_TILE_4
                UpdateSpriteFromGlobal SPRITE_2, SPRITE_2_ADDRESS_TILE_1, SPRITE_2_ADDRESS_TILE_2, \
                SPRITE_2_ADDRESS_TILE_3, SPRITE_2_ADDRESS_TILE_4
                UpdateSpriteFromGlobal SPRITE_3, SPRITE_3_ADDRESS_TILE_1, SPRITE_3_ADDRESS_TILE_2, \
                SPRITE_3_ADDRESS_TILE_3, SPRITE_3_ADDRESS_TILE_4
                UpdateSpriteFromGlobal SPRITE_4, SPRITE_4_ADDRESS_TILE_1, SPRITE_4_ADDRESS_TILE_2, \
                SPRITE_4_ADDRESS_TILE_3, SPRITE_4_ADDRESS_TILE_4

                AnimateSprites SPRITE_1, SPRITE_1_ADDRESS_TILE_1
                AnimateSprites SPRITE_2, SPRITE_2_ADDRESS_TILE_1
                AnimateSprites SPRITE_3, SPRITE_3_ADDRESS_TILE_1
                AnimateSprites SPRITE_4, SPRITE_4_ADDRESS_TILE_1

                call update_player_from_global

            call update_HUD
            ld a, [PLAYER + PLAYER_HP]
            cp MINIMUM_HP
            jp nz, .loop_round_3
    .round_3_done
    ret

export init_level_3, level_3
