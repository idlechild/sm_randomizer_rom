;
; Patches to support starting at any given location in the game
; by injecting a save station at X/Y coordinates in the specified room.
;
; Requires adding a new save station with ID: 7 for the correct region in the save station table as well.
;

!START_ROOM_ID = $9FBA
!START_ROOM_REGION = $0001
!START_ROOM_DOOR = $8E92
!START_ROOM_SCREEN_X = $0400
!START_ROOM_SCREEN_Y = $0000
!START_ROOM_SAMUS_Y = $00A8
!START_ROOM_SAMUS_X_OFFSET = $FFF0
!START_ROOM_MAP_X = $00F8
!START_ROOM_MAP_Y = $0070
!START_ROOM_TILE_XY = $0C46

!START_SAVESTATION_ID = $0007

org $80c527
crateria_start_load_station:
    dw !START_ROOM_ID
    dw !START_ROOM_DOOR
    dw $0000
    dw !START_ROOM_SCREEN_X
    dw !START_ROOM_SCREEN_Y
    dw !START_ROOM_SAMUS_Y
    dw !START_ROOM_SAMUS_X_OFFSET

org $80c631
brinstar_start_load_station:
    dw !START_ROOM_ID
    dw !START_ROOM_DOOR
    dw $0000
    dw !START_ROOM_SCREEN_X
    dw !START_ROOM_SCREEN_Y
    dw !START_ROOM_SAMUS_Y
    dw !START_ROOM_SAMUS_X_OFFSET

org $80c73b
norfair_start_load_station:
    dw !START_ROOM_ID
    dw !START_ROOM_DOOR
    dw $0000
    dw !START_ROOM_SCREEN_X
    dw !START_ROOM_SCREEN_Y
    dw !START_ROOM_SAMUS_Y
    dw !START_ROOM_SAMUS_X_OFFSET

org $80c87d
wrecked_ship_start_load_station:
    dw !START_ROOM_ID
    dw !START_ROOM_DOOR
    dw $0000
    dw !START_ROOM_SCREEN_X
    dw !START_ROOM_SCREEN_Y
    dw !START_ROOM_SAMUS_Y
    dw !START_ROOM_SAMUS_X_OFFSET

org $80c979
maridia_start_load_station:
    dw !START_ROOM_ID
    dw !START_ROOM_DOOR
    dw $0000
    dw !START_ROOM_SCREEN_X
    dw !START_ROOM_SCREEN_Y
    dw !START_ROOM_SAMUS_Y
    dw !START_ROOM_SAMUS_X_OFFSET

org $80ca91
tourian_start_load_station:
    dw !START_ROOM_ID
    dw !START_ROOM_DOOR
    dw $0000
    dw !START_ROOM_SCREEN_X
    dw !START_ROOM_SCREEN_Y
    dw !START_ROOM_SAMUS_Y
    dw !START_ROOM_SAMUS_X_OFFSET

org $80cb8d
ceres_start_load_station:
    dw !START_ROOM_ID
    dw !START_ROOM_DOOR
    dw $0000
    dw !START_ROOM_SCREEN_X
    dw !START_ROOM_SCREEN_Y
    dw !START_ROOM_SAMUS_Y
    dw !START_ROOM_SAMUS_X_OFFSET

org $80cc7b
debug_start_load_station:
    dw !START_ROOM_ID
    dw !START_ROOM_DOOR
    dw $0000
    dw !START_ROOM_SCREEN_X
    dw !START_ROOM_SCREEN_Y
    dw !START_ROOM_SAMUS_Y
    dw !START_ROOM_SAMUS_X_OFFSET

org $82c86f
crateria_map_icon_save_point_start:
    dw !START_ROOM_MAP_X
    dw !START_ROOM_MAP_Y

org $82c8d9
brinstar_map_icon_save_point_start:
    dw !START_ROOM_MAP_X
    dw !START_ROOM_MAP_Y

org $82c93f
norfair_map_icon_save_point_start:
    dw !START_ROOM_MAP_X
    dw !START_ROOM_MAP_Y

org $82c9ad
wrecked_ship_map_icon_save_point_start:
    dw !START_ROOM_MAP_X
    dw !START_ROOM_MAP_Y

org $82ca0f
maridia_map_icon_save_point_start:
    dw !START_ROOM_MAP_X
    dw !START_ROOM_MAP_Y

org $82ca6d
tourian_map_icon_save_point_start:
    dw !START_ROOM_MAP_X
    dw !START_ROOM_MAP_Y

org $82804e
    jsr start_anywhere

org $8ffd00
startroom_region:
    dw $0000
startroom_id:
    dw $0000

org $82fd00
start_anywhere:
if !DEBUG_IH_START
    lda #!START_ROOM_ID
else
    lda startroom_id
endif
    beq .ret

    ; Make sure game mode is 1f
    lda $7e0998
    cmp.w #$001f
    bne .ret

if !DEBUG_IH_START
else
    ; Check if samus saved energy is 00, if it is, run startup code
    lda $7ed7e2
    bne .ret
endif

if !DEBUG_IH_START
    lda #!START_ROOM_REGION
else
    lda startroom_region
endif
    sta $079f
    lda #!START_SAVESTATION_ID
    sta $078b

.ret
    jmp $819b

warnpc $82fe00

