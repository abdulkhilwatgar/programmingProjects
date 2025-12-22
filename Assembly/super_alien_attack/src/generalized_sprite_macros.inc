; CS-240 World 7
;
; @file generalized_sprite_macros.inc
; @brief Handles generalized logic for sprites
; @author Ashkan Khilwatgar and Sasha Knoll
; @date November 12th, 2025
; @license This file is licensed under the MIT License. See LICENSE.md for details.
;
; build with:
; make

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;\1 is x position
;\2 is y position
;\3 sprite WRAM address
;\4 Tile address 1
;\5 Tile address 2
;\6 Tile address 3
;\7 Tile address 4
;\8 sprite X start x offset
;\9 sprite X start y offset
macro InitSprite
    ;Professor Strash said these arguments are not magic numbers when I saw him in office hours on 10/28
    DisplaySprite \4, \1, \2, 0, 0
    DisplaySprite \5, \1 + SPRITE_WIDTH, \2, 1, 0
    DisplaySprite \6, \1, \2 + SPRITE_HEIGHT, 16, 0
    DisplaySprite \7, \1 + SPRITE_WIDTH, \2 + SPRITE_HEIGHT, 17, 0

    copy [\3 + SPRITE_MOVEMENT_FLAG], SPRITE_MOVE_RIGHT
    copy [\3 + SPRITE_X], \8 - SPRITE_X_OFFSET
    copy [\3 + SPRITE_Y], \9 - SPRITE_Y_OFFSET
    copy [\3 + SPRITE_HP_ATTR], SPRITE_HP
    copy [\3 + SPRITE_ANIMATE_TIMER], ANIMATE_INIT_VALUE
    copy [ALL_NPC_DIMENSIONS], SPRITE_HEIGHT * 2
endm

;\1 Sprite WRAM address
;\2 Sprite address tile 1
;\3 Sprite address tile 2
;\4 Sprite address tile 3
;\5 Sprite address tile 4
macro UpdateSprite
    ld a, [\1 + SPRITE_HP_ATTR]
    cp MINIMUM_HP
    jp z, .dont_update\@
        ;if flag is 0, move right, else move left
        ld a, [\1 + SPRITE_MOVEMENT_FLAG]
        cp SPRITE_MOVE_RIGHT
        jr z, .move_sprite_right\@
            ld a, [\1 + SPRITE_X]
            AddBetter [\1 + SPRITE_X], SPRITE_DECREMENT
            jr .check_coordinates\@

        .move_sprite_right\@
            ld a, [\1 + SPRITE_X]
            AddBetter [\1 + SPRITE_X], SPRITE_INCREMENT

        ;checks if the sprite is at the top of the screen and sets flags accordingly
        .check_coordinates\@
            ld a, [\1 + SPRITE_X]
            cp SCRN_X - SPRITE_EDGES_OFFSET
            jr z, .change_flag_to_1\@
                ld a, [\1 + SPRITE_X]
                cp LEFT_OF_SCREEN + SPRITE_EDGES_OFFSET
                jr z, .change_flag_to_0\@
                    jr .done\@
        
        .change_flag_to_1\@
            ld a, SPRITE_MOVE_LEFT
            ld [\1 + SPRITE_MOVEMENT_FLAG], a
            jr .done\@
        
        .change_flag_to_0\@
            ld a, SPRITE_MOVE_RIGHT
            ld [\1 + SPRITE_MOVEMENT_FLAG], a
            jr .done\@
    
    .dont_update\@
        copy [\1 + SPRITE_X], -SPRITE_X_OFFSET
        copy [\1 + SPRITE_Y], -SPRITE_Y_OFFSET
    .done\@
endm

;\1 Sprite WRAM address
macro DestroySprite
    copy [\1 + SPRITE_X], -SPRITE_X_OFFSET
    copy [\1 + SPRITE_Y], -SPRITE_Y_OFFSET
endm

;\1 Sprite WRAM address
;\2 Sprite address tile 1
;\3 Sprite address tile 2
;\4 Sprite address tile 3
;\5 Sprite address tile 4
macro UpdateSpriteFromGlobal
    ; subtract scroll coordinate and add 8 to transform to screen x-coordinate
    ld a, [rSCX]
    ld b, a
    ld a, [\1 + SPRITE_X]
    sub b
    
    ld [\2 + OAMA_X], a
    ld [\4 + OAMA_X], a
    add SPRITE_WIDTH
    ld [\3 + OAMA_X], a
    ld [\5 + OAMA_X], a

    ld a, [rSCY]
    ld b, a
    ld a, [\1 + SPRITE_Y]
    sub b
    add OAM_Y_OFS 

    ld [\2 + OAMA_Y], a
    ld [\3 + OAMA_Y], a 
    add SPRITE_HEIGHT
    ld [\4 + OAMA_Y], a
    ld [\5 + OAMA_Y], a 
endm