; ; CS-240 World 7
;
; @file generalized_player_macros.inc
; @brief Handles generalized logic for player
; @author Ashkan Khilwatgar and Sasha Knoll
; @date November 13th, 2025
; @license This file is licensed under the MIT License. See LICENSE.md for details.
;
; build with:
; make

;\1 = sprite WRAM address
;\2 = player missile WRAM address
macro CheckCollisionsPlayerMissile
    ;if sprite is to the left of missile
    ld a, [\2 + MISSILE_X]
    ld b, a
    ld a, [\1 + SPRITE_X]
    add SPRITE_WIDTH_COLLISIONS
    cp b
    jr c, .no_collision_detected\@
        ;if sprite is to the right of missile
        ld a, [\1 + SPRITE_X]
        ld b, a
        ld a, [\2 + MISSILE_X]
        add MISSILE_WIDTH_COLLISIONS ;missile_width_collisions
        cp b
        jr c, .no_collision_detected\@
            ;if sprite is above missile
            ld a, [\2 + MISSILE_Y]
            ld b, a
            ld a, [\1 + SPRITE_Y]
            add SPRITE_HEIGHT_COLLISIONS
            cp b
            jr c, .no_collision_detected\@
                ;if sprite is below of missile
                ld a, [\1 + SPRITE_Y]
                ld b, a
                ld a, [\2 + MISSILE_Y]
                cp b
                jr c, .no_collision_detected\@
                    ;play noise if hits
                    copy [rNR10], $36
                    copy [rNR11], $08
                    copy [rNR12], $64
                    copy [rNR13], $C4
                    copy [rNR14], $C6

                    AddBetter [\1 + SPRITE_HP_ATTR], HP_DECREMENT
                    ld a, [\1 + SPRITE_HP_ATTR]
                    cp 0 
                    jr nz, .dont_delete\@
                        AddBetter [AMOUNT_ENEMIES], ENEMIES_DECREMENT
                        DestroySprite \1
                    .dont_delete\@
                        copy [\2 + MISSILE_SHOT_FLAG], PLAYER_MISSILE_NOT_SHOT
                        copy [\2 + MISSILE_X], MISSILE_START_X - SPRITE_X_OFFSET
                        copy [\2 + MISSILE_Y], MISSILE_START_Y - SPRITE_Y_OFFSET
        .no_collision_detected\@
endm

;\1 Missile X WRAM address
;\2 Missile X not shot
macro MovePlayerMissile
    ld a, [PLAYER_HP]
    cp MINIMUM_HP
    jr c, .missile_not_shot\@
        ld a, [\1 + MISSILE_SHOT_FLAG]
        cp \2
        jr z, .missile_not_shot\@
            ld a, [\1 + MISSILE_Y]
            AddBetter [\1 + MISSILE_Y], MISSILE_DECREMENT
            ld a, [\1 + MISSILE_Y]
            cp MISSILE_COMPARISION
            jr nz, .missile_not_shot\@
                ld a, TOP_OF_SCREEN - SPRITE_Y_OFFSET
                ld [\1 + MISSILE_Y], a
                ld a, MISSILE_COMPARISION
                ld [\1 + MISSILE_X], a
                copy [\1 + MISSILE_SHOT_FLAG], \2
    .missile_not_shot\@
    endm

;\1 Player OAM address
macro InvertPlayer
    ld a, [\1 + OAMA_FLAGS]
    xor OAMF_PAL1
    ld [\1 + OAMA_FLAGS], a
    ld [\1 + sizeof_OAM_ATTRS + OAMA_FLAGS], a
    ld [\1 + sizeof_OAM_ATTRS * 2 + OAMA_FLAGS], a
    ld [\1 + sizeof_OAM_ATTRS * 3 + OAMA_FLAGS], a
    ld [\1 + sizeof_OAM_ATTRS * 4 + OAMA_FLAGS], a
    ld [\1 + sizeof_OAM_ATTRS * 5 + OAMA_FLAGS], a
endm

;\1 Player OAM address
macro RevertPlayer
    ld a, [\1 + OAMA_FLAGS]
    ld [\1 + OAMA_FLAGS], a
    ld [\1 + sizeof_OAM_ATTRS + OAMA_FLAGS], a
    ld [\1 + sizeof_OAM_ATTRS * 2 + OAMA_FLAGS], a
    ld [\1 + sizeof_OAM_ATTRS * 3 + OAMA_FLAGS], a
    ld [\1 + sizeof_OAM_ATTRS * 4 + OAMA_FLAGS], a
    ld [\1 + sizeof_OAM_ATTRS * 5 + OAMA_FLAGS], a
endm