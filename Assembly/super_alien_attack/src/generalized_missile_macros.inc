; ; CS-240 World 7
;
; @file generalized_missile_macros.inc
; @brief Handles generalized logic for missiles 
; @author Ashkan Khilwatgar and Sasha Knoll
; @date November 3rd, 2025
; @license This file is licensed under the MIT License. See LICENSE.md for details.
;
; build with:
; make

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;\1 = missile WRAM memory chunk address
;\2 = tile id, 56 or 57
;\3 MISSILE_X_NOT_SHOT
;\4 SPRITE OAM ADDR
macro InitMissile
    ;Professor Strash said these arguments are not magic numbers when I saw him in office hours on 10/28
    DisplaySprite \4, 0, 0, \2, 0
    copy [\1 + MISSILE_X], MISSILE_START_X - SPRITE_X_OFFSET
    copy [\1 + MISSILE_Y], MISSILE_START_Y - SPRITE_Y_OFFSET
    copy [\1 + MISSILE_SHOT_FLAG], \3
endm

;\1 = Sprite WRAM addr
;\2 = respective missile WRAM addr
;\3 respective missile NOT shot
;\4 respective missile shot
;\5 missile OAM address
macro SpriteShoot
    ld a, [\1 + SPRITE_HP_ATTR]
    cp MINIMUM_HP
    jr z, .reset_missile\@
        ld a, [\2 + MISSILE_SHOT_FLAG]
        cp \3
        jr nz, .dont_reset_coords\@

            ld a, [\1 + SPRITE_Y]
            add SPRITE_HEIGHT 
            copy [\2 + MISSILE_Y], a

            ld a, [\1 + SPRITE_X]
            copy [\2 + MISSILE_X], a

            ld a, \4
            ld [\2 + MISSILE_SHOT_FLAG], a
            jr .done\@
        
        .dont_reset_coords\@
            ld a, [\2 + MISSILE_Y]
            cp TOP_OF_HUD
            jr nz, .dont_reset_flag\@
                ld a, \3
                ld [\2 + MISSILE_SHOT_FLAG], a
                jr .done\@
            .dont_reset_flag\@
                AddBetter [\2 + MISSILE_Y], MISSILE_INCREMENT
                jr .done\@
        
        .reset_missile\@
            copy [\2 + MISSILE_X], -SPRITE_X_OFFSET
            copy [\2 + MISSILE_Y], -SPRITE_Y_OFFSET
            copy [\2 + MISSILE_SHOT_FLAG], MISSILE_1_SHOT

        .done\@
endm

;\1 = missile wram address
;2 = missile OAM address
macro UpdateMissileFromGlobal
    ld a, [rSCX]
    ld b, a
    ld a, [\1 + MISSILE_X]
    sub b
    add OAM_X_OFS 
    ld [\2 + OAMA_X], a

    ld a, [rSCY]
    ld b, a
    ld a, [\1 + MISSILE_Y]
    sub b
    add OAM_Y_OFS 
    ld [\2 + OAMA_Y], a
endm