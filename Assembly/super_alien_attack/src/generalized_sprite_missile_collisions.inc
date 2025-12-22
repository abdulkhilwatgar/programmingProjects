; ; CS-240 World 7
;
; @file generalized_sprite_missile_collisions.inc
; @brief Handles generalized logic for collision detection for missile
; @author Ashkan Khilwatgar and Sasha Knoll
; @date November 12th, 2025
; @license This file is licensed under the MIT License. See LICENSE.md for details.
;
; build with:
; make

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;\1 WRAM address of missile
;\2 player's global address
;\3 Missile X not shot
;\4 Missile OAM address
macro CheckCollisionSpriteMissiles
    ld a, [PLAYER + PLAYER_FLICKER]
    cp 0 
    jp nz, .no_collision_detected\@
        ;if player is to the left of the missile
        ld a, [\1 + MISSILE_X]
        ld b, a
        ld a, [\2 + PLAYER_X]
        add PLAYER_WIDTH_COLLISIONS
        cp b
        jr c, .no_collision_detected\@
            ;if player is to the right of missile
            ld a, [\2 + PLAYER_X]
            ld b, a
            ld a, [\1 + MISSILE_X]
            add SPRITE_WIDTH_COLLISIONS
            cp b
            jr c, .no_collision_detected\@
                ;if player is above missile
                ld a, [\1 + MISSILE_Y]
                ld b, a
                ld a, [\2 + PLAYER_Y]
                add PLAYER_HEIGHT_COLLISIONS
                cp b
                jr c, .no_collision_detected\@
                    ;if player is below missile
                    ld a, [\2 + PLAYER_Y]
                    ld b, a
                    ld a, [\1 + MISSILE_Y]
                    cp b
                    jr c, .no_collision_detected\@
                        ;  play noise if hit
                        copy [rNR10], $36
                        copy [rNR11], $10
                        copy [rNR12], $54
                        copy [rNR13], $C8
                        copy [rNR14], $C6
                        
                        AddBetter [\2 + PLAYER_HP], HP_DECREMENT
                        ld a, PLAYER_FLICKER_DURATION
                        ld [\2 + PLAYER_FLICKER], a

                        ld a, [\2 + PLAYER_HP]
                        cp MINIMUM_HP
                        jr nz, .dont_destroy_sprite\@
                            ;destroys sprite if HP = 0
                            DestroyPlayerSprite
                            jr .no_collision_detected\@

                        .dont_destroy_sprite\@
                            ;sets flags accordingly
                            copy [\1 + MISSILE_SHOT_FLAG], \3
                            copy [\1 + MISSILE_X], MISSILE_START_X - SPRITE_X_OFFSET
                            copy [\1 + MISSILE_Y], MISSILE_START_Y - SPRITE_Y_OFFSET

    .no_collision_detected\@
endm