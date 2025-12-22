; ; CS-240 World 7
;
; @file level_1.asm
; @brief Handles logic for level 1
; @author Ashkan Khilwatgar and Sasha Knoll
; @date November 12th, 2025
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

section "level_1", rom0

init_level_1:
    DisableLCD
    call init_graphics

    InitSprite SPRITE_1_X_START, SPRITE_1_Y_START, SPRITE_1, SPRITE_1_ADDRESS_TILE_1, \
    SPRITE_1_ADDRESS_TILE_2, SPRITE_1_ADDRESS_TILE_3, SPRITE_1_ADDRESS_TILE_4, \
    SPRITE_1_START_X, SPRITE_1_START_Y
    call init_player
    call update_player_from_global
    UpdateMissileFromGlobal PLAYER_MISSILE_ATTR, PLAYER_MISSILE
    UpdateMissileFromGlobal MISSILE_1, MISSILE_SPRITE_1

    UpdateSpriteFromGlobal SPRITE_1, SPRITE_1_ADDRESS_TILE_1, SPRITE_1_ADDRESS_TILE_2, \
    SPRITE_1_ADDRESS_TILE_3, SPRITE_1_ADDRESS_TILE_4

    ;init player missile
    InitMissile PLAYER_MISSILE_ATTR, PLAYER_MISSILE_TILEID, PLAYER_MISSILE_NOT_SHOT, PLAYER_MISSILE
    
    ;init enemy missile
    InitMissile MISSILE_1, SPRITE_MISSILE_TILEID, MISSILE_1_NOT_SHOT, MISSILE_SPRITE_1
    
    InitJoypad
    EnableLCDWIN9C00

    ;writes level 1 message to window
    DisableLCD
    ld hl, LEVEL_1_MESSAGE_ADDR
    ld de, LEVEL_1_MESSAGE
    call write_to_window
    EnableLCDWIN9C00
    RemoveWindowTimed

    EnableSprites
    copy [AMOUNT_ENEMIES], ROUND_1_ENEMIES
ret

level_1:
;game loop for round 1
    .loop_round_1
        ld a, [AMOUNT_ENEMIES]
        cp MINIMUM_ENEMIES
        jp z, .round_1_done
            UpdateJoypad
            AddBetter [FRAME_COUNTER_2], FRAME_INCREMENT
            call move_player

            ld a, [FRAME_COUNTER_2]
            and FRAME_MOVE_MOD
            jp nz, .dont_update
                UpdateSprite SPRITE_1, SPRITE_1_ADDRESS_TILE_1, SPRITE_1_ADDRESS_TILE_2, \
                SPRITE_1_ADDRESS_TILE_3, SPRITE_1_ADDRESS_TILE_4
            .dont_update
            
            call player_shoot
            MovePlayerMissile PLAYER_MISSILE_ATTR, PLAYER_MISSILE_NOT_SHOT
            ; makes enemy sprite shoot
            SpriteShoot SPRITE_1, MISSILE_1, MISSILE_1_NOT_SHOT, MISSILE_1_SHOT, MISSILE_SPRITE_1

            ;check collision from enemy missile to player
            CheckCollisionSpriteMissiles MISSILE_1, PLAYER, MISSILE_1_NOT_SHOT, MISSILE_SPRITE_1
            ; call check_collisions_player_missile
            CheckCollisionsPlayerMissile SPRITE_1, PLAYER_MISSILE_ATTR
        
            halt
            call update_player_flicker
            call update_HUD
            call detect_collision_with_HUD
            call detect_collision_with_wall

            UpdateMissileFromGlobal PLAYER_MISSILE_ATTR, PLAYER_MISSILE
            UpdateMissileFromGlobal MISSILE_1, MISSILE_SPRITE_1

            UpdateSpriteFromGlobal SPRITE_1, SPRITE_1_ADDRESS_TILE_1, SPRITE_1_ADDRESS_TILE_2, \
            SPRITE_1_ADDRESS_TILE_3, SPRITE_1_ADDRESS_TILE_4

            AnimateSprites SPRITE_1, SPRITE_1_ADDRESS_TILE_1

            call update_player_from_global

            ld a, [PLAYER + PLAYER_HP]
            cp MINIMUM_HP
            jr z, .round_1_done
                jp .loop_round_1

        .round_1_done
        ret

export init_level_1, level_1