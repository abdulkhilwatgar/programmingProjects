; ; CS-240 World 7
;
; @file global_vars.inc
; @brief Contains all of the global variables used in the program
; @author Ashkan Khilwatgar and Sasha Knoll
; @date October 28th, 2025
; @license This file is licensed under the MIT License. See LICENSE.md for details.
;
; build with:
; make

def TILES_COUNT                     equ (384)
def BYTES_PER_TILE                  equ (16)
def TILES_BYTE_SIZE                 equ (TILES_COUNT * BYTES_PER_TILE)

def TILEMAPS_COUNT                  equ (2)
def BYTES_PER_TILEMAP               equ (1024)
def TILEMAPS_BYTE_SIZE              equ (TILEMAPS_COUNT * BYTES_PER_TILEMAP)

def GRAPHICS_DATA_SIZE              equ (TILES_BYTE_SIZE + TILEMAPS_BYTE_SIZE)
def GRAPHICS_DATA_ADDRESS_END       equ ($8000)
def GRAPHICS_DATA_ADDRESS_START     equ (GRAPHICS_DATA_ADDRESS_END - GRAPHICS_DATA_SIZE)

def DEFAULT_PALETTE                 equ (%11100100)
def DEFAULT_PALETTE_INVERTED        equ (%00011011)

def TOP_OF_SCREEN                   equ (0)      
def LEFT_OF_SCREEN                  equ (0)
def RIGHT_OF_SCREEN                 equ (160)
def BOTTOM_OF_SCREEN                equ(144)
def TOP_OF_HUD                      equ 108

def PLAYER_ADDRESS_TILE_1           equ (_OAMRAM)
def PLAYER_ADDRESS_TILE_2           equ (_OAMRAM + sizeof_OAM_ATTRS)
def PLAYER_ADDRESS_TILE_3           equ (_OAMRAM + sizeof_OAM_ATTRS * 2) 
def PLAYER_ADDRESS_TILE_4           equ (_OAMRAM + sizeof_OAM_ATTRS * 3)
def PLAYER_ADDRESS_TILE_5           equ (_OAMRAM + sizeof_OAM_ATTRS * 4)
def PLAYER_ADDRESS_TILE_6           equ (_OAMRAM + sizeof_OAM_ATTRS * 5)

def SPRITE_1_ADDRESS_TILE_1         equ (_OAMRAM + sizeof_OAM_ATTRS * 6)
def SPRITE_1_ADDRESS_TILE_2         equ (_OAMRAM + sizeof_OAM_ATTRS * 7)
def SPRITE_1_ADDRESS_TILE_3         equ (_OAMRAM + sizeof_OAM_ATTRS * 8)
def SPRITE_1_ADDRESS_TILE_4         equ (_OAMRAM + sizeof_OAM_ATTRS * 9)

def SPRITE_2_ADDRESS_TILE_1         equ (_OAMRAM + sizeof_OAM_ATTRS * 10)
def SPRITE_2_ADDRESS_TILE_2         equ (_OAMRAM + sizeof_OAM_ATTRS * 11)
def SPRITE_2_ADDRESS_TILE_3         equ (_OAMRAM + sizeof_OAM_ATTRS * 12)
def SPRITE_2_ADDRESS_TILE_4         equ (_OAMRAM + sizeof_OAM_ATTRS * 13)

def SPRITE_3_ADDRESS_TILE_1         equ (_OAMRAM + sizeof_OAM_ATTRS * 14)
def SPRITE_3_ADDRESS_TILE_2         equ (_OAMRAM + sizeof_OAM_ATTRS * 15)
def SPRITE_3_ADDRESS_TILE_3         equ (_OAMRAM + sizeof_OAM_ATTRS * 16)
def SPRITE_3_ADDRESS_TILE_4         equ (_OAMRAM + sizeof_OAM_ATTRS * 17)

def PLAYER_MISSILE                  equ (_OAMRAM + sizeof_OAM_ATTRS * 18)
def PLAYER_MISSILE_2                equ (_OAMRAM + sizeof_OAM_ATTRS * 19)

def MISSILE_SPRITE_1                equ (_OAMRAM + sizeof_OAM_ATTRS * 20)
def MISSILE_SPRITE_2                equ (_OAMRAM + sizeof_OAM_ATTRS * 21)
def MISSILE_SPRITE_3                equ (_OAMRAM + sizeof_OAM_ATTRS * 22)
def MISSILE_SPRITE_4                equ (_OAMRAM + sizeof_OAM_ATTRS * 23)

def SPRITE_4_ADDRESS_TILE_1         equ (_OAMRAM + sizeof_OAM_ATTRS * 24)
def SPRITE_4_ADDRESS_TILE_2         equ (_OAMRAM + sizeof_OAM_ATTRS * 25)
def SPRITE_4_ADDRESS_TILE_3         equ (_OAMRAM + sizeof_OAM_ATTRS * 26)
def SPRITE_4_ADDRESS_TILE_4         equ (_OAMRAM + sizeof_OAM_ATTRS * 27)


def PLAYER_START_X                  equ 90
def PLAYER_START_Y                  equ 100
def PLAYER_1_START_HP               equ 3
def PLAYER_1_HEIGHT                 equ 16
def PLAYER_1_WIDTH                  equ 24
def PLAYER_MULTIPLY_WIDTH_OFFSET    equ 3
def PLAYER_DIVIDE_WIDTH_OFFSET      equ 6

def SPRITE_X_OFFSET                 equ 8
def SPRITE_Y_OFFSET                 equ 16

def SPRITE_1_START_X                equ 70
def SPRITE_1_START_Y                equ 40
def SPRITE_1_FIRE_TIMER             equ 110

def SPRITE_2_START_X                equ 50
def SPRITE_2_START_Y                equ 56
def SPRITE_2_FIRE_TIMER             equ 80

def SPRITE_3_START_X                equ 30
def SPRITE_3_START_Y                equ 72
def SPRITE_3_FIRE_TIMER             equ 50

def SPRITE_4_START_X                equ 90
def SPRITE_4_START_Y                equ 24
def SPRITE_4_FIRE_TIMER             equ 140

def MISSILE_START_X                 equ 16
def MISSILE_START_Y                 equ 8

def PLAYER_MISSILE_SHOT             equ 1
def PLAYER_MISSILE_NOT_SHOT         equ 0

def PLAYER_MISSILE_2_SHOT           equ 1
def PLAYER_MISSILE_2_NOT_SHOT       equ 0

def MISSILE_1_NOT_SHOT              equ 1
def MISSILE_1_SHOT                  equ 0

def MISSILE_2_NOT_SHOT              equ 1
def MISSILE_2_SHOT                  equ 0

def MISSILE_3_NOT_SHOT              equ 1
def MISSILE_3_SHOT                  equ 0

def MISSILE_4_NOT_SHOT              equ 1
def MISSILE_4_SHOT                  equ 0

def SPRITE_1_HEIGHT_OFFSET          equ 16
def SPRITE_MOVE_OFFSET              equ 8
def SPRITE_MOD_TIMER                equ 8
def SPRITE_EDGES_OFFSET             equ 4

def SPRITE_WIDTH                    equ 8
def SPRITE_HEIGHT                   equ 8

def SPRITE_WIDTH_OFFSET             equ 16
def SPRITE_HEIGHT_OFFSET            equ 16

def MISSILE_WIDTH                   equ 8
def MISSILE_HEIGHT                  equ 8

def DISTANCE_TO_EDGE_X              equ 20
def DISTANCE_TO_EDGE_Y              equ 20

def SPRITE_HP                       equ 1
def MINIMUM_HP                      equ 0

def SPRITE_MOVE_RIGHT               equ 0
def SPRITE_MOVE_LEFT                equ 1

def PLAYER_MIDWAY_PT_X              equ 12
def PLAYER_MIDWAY_PT_Y              equ 8

def SPRITE_MIDWAY_PT_X              equ 8
def SPRITE_MIDWAY_PT_Y              equ 8

def PLAYER_INVERT_TIMER             equ 10
def SPRITE_1_INVERT_TIMER           equ 10
def SPRITE_2_INVERT_TIMER           equ 10
def SPRITE_3_INVERT_TIMER           equ 10
def SPRITE_4_INVERT_TIMER           equ 10

def SPRITE_1_DESTROYED              equ 1
def SPRITE_1_NOT_DESTROYED          equ 0

def SPRITE_2_DESTROYED              equ 1
def SPRITE_2_NOT_DESTROYED          equ 0

def SPRITE_3_DESTROYED              equ 1
def SPRITE_3_NOT_DESTROYED          equ 0

def SPRITE_4_DESTROYED              equ 1
def SPRITE_4_NOT_DESTROYED          equ 0

def ROUND_1_ENEMIES                 equ 1
def ROUND_2_ENEMIES                 equ 3
def ROUND_3_ENEMIES                 equ 4

def MINIMUM_ENEMIES                 equ 0

def PLANET_OVERWRITE_ADDRESS        equ $9D8B
def PLANET_OVERWRITE_TILE_1         equ $E0
def PLANET_OVERWRITE_TILE_2         equ $F2

def WINDOW_TIMER                    equ 60
def WAIT_TIMER                      equ 60

def HUD_START_ADDR_LINE_1           equ $99C0
def HUD_START_ADDR_LINE_2           equ $99E0
def HUD_START_ADDR_LINE_3           equ $9A00
def HUD_START_ADDR_LINE_4           equ $9A20

def ANIMATE_SPRITE_COMPARISON       equ %00011111
def ANIMATE_SPRITE_TILE_OFFSET      equ 15
def ANIMATE_INIT_VALUE              equ 32

def MISSILE_COMPARISION             equ 0
def MISSILE_INCREMENT               equ 1
def MISSILE_DECREMENT               equ -1

def PLAYER_INCREMENT                equ 1
def PLAYER_DECREMENT                equ -1

def SPRITE_INCREMENT                equ 1
def SPRITE_DECREMENT                equ -1

def HP_DECREMENT                    equ -1
def ENEMIES_DECREMENT               equ -1

def PLAYER_FLICKER_DURATION         equ 32
def FLICKER_COMPARISON              equ %00000100

def TILE_OFFSET_NUMBERS             equ $50
def TILESET_OFFSET_CHAR             equ $61
def ADDR_HEALTH_IN_MAP              equ $99EC
def ADDR_ENEMIES_IN_MAP             equ $9A0D

def LEVEL_3_MESSAGE_ADDR            equ $9CE6
def LEVEL_2_MESSAGE_ADDR            equ $9CE6
def LEVEL_1_MESSAGE_ADDR            equ $9CE6
def GAME_OVER_MESSAGE_ADDR          equ $9CE5
def WIN_MESSAGE_ADDR                equ $9D26
def LOSE_MESSAGE_ADDR               equ $9D26
def PLAY_AGAIN_MESSAGE_ADDR         equ $9D64
def CLICK_MESSAGE_ADDR              equ $9DA9

def EXTRA_TILESET_SIZE              equ 2625
def TILEMAP_SIZE                    equ 1024
def HUD_HEALTH_MESSAGE_ADDR         equ $99E5
def HUD_ENEMY_MESSAGE_ADDR          equ $9A05

def FRAME_MOVE_MOD                  equ %00000001
def FRAME_DETECT_MOD                equ %00000010

def MISSILE_X                       equ 0
def MISSILE_Y                       equ 1
def MISSILE_SHOT_FLAG               equ 2

def SPRITE_X                        equ 0
def SPRITE_Y                        equ 1
def SPRITE_PREV_X                   equ 2
def SPRITE_PREV_Y                   equ 3
def SPRITE_HP_ATTR                  equ 4
def SPRITE_MOVEMENT_FLAG            equ 5
def SPRITE_ANIMATE_TIMER            equ 6

def PLAYER_X                        equ 0
def PLAYER_Y                        equ 1
def PLAYER_PREV_X                   equ 2
def PLAYER_PREV_Y                   equ 3
def PLAYER_HP                       equ 4
def PLAYER_PREV_HP                  equ 5
def PLAYER_HEIGHT                   equ 6
def PLAYER_WIDTH                    equ 7
def PLAYER_FLICKER                  equ 8

def PLAYER_MISSILE_TILEID           equ 56
def SPRITE_MISSILE_TILEID           equ 57

def SONG_LENGTH_TICKS               equ 640
def SONG_TICK_RESET                 equ 0

def SPRITE_HEIGHT_COLLISIONS        equ 8
def SPRITE_WIDTH_COLLISIONS         equ 4
def MISSILE_WIDTH_COLLISIONS        equ 8

def PLAYER_WIDTH_COLLISIONS         equ 22
def PLAYER_HEIGHT_COLLISIONS        equ 16

def SONG_INCREMENT                  equ 1
def SONG_TIMER_INIT                 equ 0
def SONG_FREQ                       equ 4

def ANIMATE_TIMER_COMPARE_1         equ 0
def ANIMATE_TIMER_COMPARE_2         equ 8

def ANIMATE_OFFSET_1                equ 0
def ANIMATE_OFFSET_2                equ 2

def SPRITE_1_X_START                equ 70
def SPRITE_1_Y_START                equ 34

def SPRITE_2_X_START                equ 50
def SPRITE_2_Y_START                equ 64

def SPRITE_3_X_START                equ 90
def SPRITE_3_Y_START                equ 94

def SPRITE_4_X_START                equ 30
def SPRITE_4_Y_START                equ 14

def FRAME_INCREMENT                 equ 1