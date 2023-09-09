
; Fix for scroll offset misalignment when going down through door
org $80ADB5
    JSR layout_fix_custom_door_scroll_down_offsets

; Fix for scroll offset misalignment
org $80AE29
    JSR layout_fix_custom_door_scroll_offsets

; Crab Shaft save station load point
org $80C995
maridia_save_station_9:
    db #$A3, #$D1, #$68, #$A4, #$00, #$00, #$00, #$00, #$00, #$02, #$78, #$00, #$60, #$00

; Main Street save station load point
org $80C9A3
maridia_save_station_10:
    db #$C9, #$CF, #$D8, #$A3, #$00, #$00, #$00, #$01, #$00, #$05, #$78, #$00, #$10, #$00



org $80D200

layout_fix_custom_door_scroll_offsets:
{
    ; Custom doors are defined for incompatible door alignment,
    ; which sometimes breakings the scroll offsets
    ; These door definitions begin at 83:C000,
    ; so BIT #$4000 can be used to detect them
    LDA $078D : BIT #$4000 : BNE .fix
    LDA $B1 : SEC
    RTS

.fix
    LDA $B3 : AND #$FF00 : STA $B3
    LDA $B1 : AND #$FF00
    SEC
    RTS
}

layout_fix_custom_door_scroll_down_offsets:
{
    ; Same fix as above, except $B3 must end in #$20
    LDA $078D : BIT #$4000 : BNE .fix
    LDA $B1 : SEC
    JMP $AE2C

.fix
    LDA $B3 : AND #$FF00 : ORA #$0020 : STA $B3
    LDA $B1 : AND #$FF00
    SEC
    JMP $AE2C
}

layout_set_picky_chozo_event_and_enemy_speed:
{
    LDA #$0001 : STA $0FB4
    LDA #$000C : JMP $81FA
}

warnpc $80D400



; Crab Shaft save station map icon location
org $82CA17
maridia_save_station_map_icon_9:
    db #$90, #$00, #$50, #$00

; Main Street save station map icon location
org $82CA1B
maridia_save_station_map_icon_10:
    db #$58, #$00, #$78, #$00

; Hijack loading destination room CRE
org $82E1D9
    JSR layout_loading_room_CRE

; Hijack room transition between loading level data and setting up scrolling
org $82E387
    LDA #layout_after_load_level_data



org $82F710

layout_loading_room_CRE:
{
    ; Implement part of the $82:DDF1 routine here
    ; If this is one of our doors, force load CRE bitset
    PHB : PHX
    PEA $8F00 : PLB : PLB
    LDX $078D
    LDA $830000,X : TAX
    CMP #$B000 : BPL .forceLoad

    ; Normal transition, jump back to vanilla
    JMP $DE00

.forceLoad
    LDA $07B3 : STA $07B1
    LDA $0008,X : AND #$00FF

    ; Ensure either BIT #$0004 or #$0002 are set
    ; so that the CRE is loaded or reloaded
    BIT #$0004 : BNE .storeBitset
    ORA #$0002

.storeBitset
    STA $07B3
    PLX : PLB : RTS
}

layout_after_load_level_data:
{
    ; Check if we need to mirror or flip Samus horizontally to fix the door
    LDA $078D : CMP #$B000 : BMI .checkRoom
    LDA $0791 : AND #$0003 : BEQ .checkSwapToRight
    CMP #$0001 : BNE .checkRoom

    LDA $0AF6 : BIT #$0080 : BEQ .checkRoom
    JSL layout_swap_left_right
    BRA .checkRoom

.checkSwapToRight
    LDA $0AF6 : BIT #$0080 : BNE .checkRoom
    JSL layout_swap_left_right

.checkRoom
    ; Below Botwoon E-Tank needs to be handled before the door scroll
    LDA $079B : CMP #$D6FD : BNE .done
    LDA config_arearando : BEQ .done
    JSL layout_asm_below_botwoon_etank_external

.done
    JMP $E38E
}

warnpc $82F800



; Statues Hallway left door
org $838C5C
green_pirates_shaft_tourian_door_pointer:
    dw #layout_asm_g4_door

; Construction Zone left door
org $838EB4
morph_ball_room_construction_zone_door_pointer:
    dw #layout_asm_wake_zebes

; Caterpillars middle-left door
org $839094
hellway_caterpillars_door_pointer:
    ; Use same asm as elevator door, freeing up asm at $BE1A
    dw $BA21

; Caterpillars top-left door
org $8390E8
beta_pbs_caterpillars_door_pointer:
    dw #layout_asm_caterpillars_no_scrolls

; East Tunnel bottom-right door
org $839238
warehouse_east_tunnel_door_pointer:
    ; Use same asm as bottom-left door
    dw $E345

; Caterpillars near-right door
org $839274
red_tower_save_caterpillars_door_pointer:
    dw #layout_asm_caterpillars_no_scrolls

; Crab Shaft left door
org $83A472
mt_everest_crab_shaft_door_pointer:
    dw #layout_asm_crab_shaft_no_scrolls

; Crab Shaft top door
org $83A4EA
fake_plasma_spark_crab_shaft_door_pointer:
    dw #layout_asm_crab_shaft_no_scrolls

; East Tunnel top-right door
org $83A51A
crab_hole_east_tunnel_door_pointer:
    dw #layout_asm_east_tunnel_no_scrolls

; West Sand Hall left door
org $83A53E
west_sand_hall_tunnel_west_sand_hall_door_pointer:
    dw #layout_asm_west_sand_hall

; West Sand Hall unused door
west_sand_hall_below_botwoon_etank_door_definition:
org $83A654
    dw #$D6FD
    db #$00, #$05, #$3E, #$06, #$03, #$00
    dw #$8000
    dw #$0000

; West Sand Hall right door
org $83A66A
oasis_west_sand_hall_door_pointer:
    dw #layout_asm_west_sand_hall

; East Sand Hall unused door
org $83A69C
below_botwoon_etank_west_sand_hall_door_definition:
    dw #$D461
    db #$00, #$04, #$01, #$06, #$00, #$00
    dw #$8000
    dw #layout_asm_west_sand_hall

; West Sand Hall top sand door
org $83A6BE
west_sand_hole_west_sand_hall_door_pointer:
    dw #layout_asm_west_sand_hall



org $83B000

; Aligned door definitions, must be between $83B000 and $83C000
; Includes the overwritten asm pointer
door_aligned_89CA_west_ocean_door0:
    dw $95FF   ; Moat
    db $00, $05, $1E, $06, $01, $00
    dw $8000, #layout_door_aligned_asm
    dw $0000

door_aligned_8A42_crateria_kihunters_door2:
    dw $962A   ; Red Brinstar Elevator
    db $00, $06, $06, $02, $00, $00
    dw $8000, #layout_door_aligned_asm
    dw $0000

door_aligned_8AA2_forgotten_highway_elbow_door0:
    dw $957D   ; Crab Maze
    db $00, $04, $01, $16, $00, $01
    dw $8000, #layout_door_aligned_asm
    dw $0000

door_aligned_8AAE_crab_maze_door1:
    dw $95A8   ; Forgotten Highway Elbow
    db $00, $05, $0E, $06, $00, $00
    dw $8000, #layout_door_aligned_asm
    dw $0000

door_aligned_8AEA_moat_door1:
    dw $93FE   ; West Ocean
    db $00, $04, $01, $46, $00, $04
    dw $8000, #layout_door_aligned_asm
    dw $0000

door_aligned_8AF6_red_brinstar_elevator_door0:
    dw $948C   ; Crateria Kihunters
    db $00, $07, $16, $2D, $01, $02
    dw $01C0, #layout_door_aligned_asm
    dw #layout_asm_crateria_kihunters_bottom_door

door_aligned_8BFE_green_brinstar_elevator_door0:
    dw $9969   ; Lower Mushrooms
    db $00, $04, $01, $06, $00, $00
    dw $8000, #layout_door_aligned_asm
    dw $0000

door_aligned_8C22_lower_mushrooms_door1:
    dw $9938   ; Green Brinstar Elevator
    db $00, $05, $0E, $06, $00, $00
    dw $8000, #layout_door_aligned_asm
    dw $0000

door_aligned_8C52_green_pirates_shaft_door2:
    dw $A5ED   ; Statues Hallway
    db $00, $04, $01, $06, $00, $00
    dw $8000, #layout_door_aligned_asm
    dw #layout_asm_g4_door

door_aligned_8E86_green_hill_zone_door1:
    dw $9E9F   ; Morph Ball
    db $00, $04, $01, $26, $00, $02
    dw $8000, #layout_door_aligned_asm
    dw $0000

door_aligned_8E9E_morph_ball_door0:
    dw $9E52   ; Green Hill Zone
    db $00, $05, $1E, $06, $01, $00
    dw $8000, #layout_door_aligned_asm
    dw $0000

door_aligned_8F0A_noob_bridge_door1:
    dw $A253   ; Red Tower
    db $00, $04, $01, $46, $00, $04
    dw $8000, #layout_door_aligned_asm
    dw $0000

door_aligned_902A_red_tower_door1:
    dw $9FBA   ; Noob Bridge
    db $00, $05, $5E, $06, $05, $00
    dw $8000, #layout_door_aligned_asm
    dw $0000

door_aligned_90C6_caterpillars_door4:
    dw $D104   ; Red Fish Room
    db $40, $04, $01, $06, $00, $00
    dw $8000, #layout_door_aligned_asm
    dw $BDAF

door_aligned_913E_warehouse_zeela_door0:
    dw $A6A1   ; Warehouse Entrance
    db $00, $05, $2E, $06, $02, $00
    dw $8000, #layout_door_aligned_asm
    dw $BD3F

door_aligned_91B6_kraid_eye_door_door1:
    dw $A59F   ; Kraid Room
    db $00, $04, $01, $16, $00, $01
    dw $8000, #layout_door_aligned_asm
    dw $0000

door_aligned_91CE_kraid_door0:
    dw $A56B   ; Kraid Eye Door Room
    db $00, $05, $1E, $16, $01, $01
    dw $8000, #layout_door_aligned_asm
    dw $0000

door_aligned_91E6_statues_hallway_door0:
    dw $99BD   ; Green Pirates Shaft
    db $00, $05, $0E, $66, $00, $06
    dw $8000, #layout_door_aligned_asm
    dw $0000

door_aligned_922E_warehouse_entrance_door0:
    dw $CF80   ; East Tunnel
    db $40, $05, $0E, $16, $00, $01
    dw $8000, #layout_door_aligned_asm
    dw $E345

door_aligned_923A_warehouse_entrance_door1:
    dw $A471   ; Warehouse Zeela
    db $00, $04, $01, $06, $00, $00
    dw $8000, #layout_door_aligned_asm
    dw $0000

door_aligned_93D2_crocomire_speedway_door4:
    dw $A98D   ; Crocomire's Room
    db $00, $06, $36, $02, $03, $00
    dw $8000, #layout_door_aligned_asm
    dw $0000

door_aligned_93EA_crocomire_door1:
    dw $A923   ; Crocomire Speedway
    db $00, $07, $C6, $2D, $0C, $02
    dw $01C0, #layout_door_aligned_asm
    dw #layout_asm_clear_bg2_vram_flag

door_aligned_95FA_single_chamber_door4:
    dw $B656   ; Three Musketeers
    db $00, $04, $11, $06, $01, $00
    dw $8000, #layout_door_aligned_asm
    dw $0000

door_aligned_967E_kronic_boost_door2:
    dw $AF14   ; Lava Dive
    db $00, $05, $3E, $06, $03, $00
    dw $8000, #layout_door_aligned_asm
    dw $0000

door_aligned_96D2_lava_dive_door0:
    dw $AE74   ; Kronic Boost
    db $00, $04, $11, $26, $01, $02
    dw $8000, #layout_door_aligned_asm
    dw $0000

door_aligned_98BE_ridley_door1:
    dw $B37A   ; Lower Norfair Farming
    db $00, $04, $01, $06, $00, $00
    dw $8000, #layout_door_aligned_asm
    dw $0000

door_aligned_98CA_lower_norfair_farming_door0:
    dw $B32E   ; Ridley Room
    db $00, $05, $0E, $06, $00, $00
    dw $8000, #layout_door_aligned_asm
    dw $0000

door_aligned_9A4A_three_musketeers_door0:
    dw $AD5E   ; Single Chamber
    db $00, $05, $5E, $06, $05, $00
    dw $8000, #layout_door_aligned_asm
    dw $0000

door_aligned_A2AC_basement_door2:
    dw $CD13   ; Phantoon Room
    db $00, $04, $01, $06, $00, $00
    dw $8000, #layout_door_aligned_asm
    dw $0000

door_aligned_A2C4_phantoon_door0:
    dw $CC6F   ; Basement
    db $00, $05, $4E, $06, $04, $00
    dw $8000, #layout_door_aligned_asm
    dw $E1FE

door_aligned_A330_glass_tunnel_door0:
    dw $CFC9   ; Main Street
    db $00, $07, $16, $7D, $01, $07
    dw $0200, #layout_door_aligned_asm
    dw #layout_asm_clear_bg2_vram_flag

door_aligned_A384_east_tunnel_door1:
    dw $A6A1   ; Warehouse Entrance
    db $40, $04, $01, $06, $00, $00
    dw $8000, #layout_door_aligned_asm
    dw $0000

door_aligned_A390_east_tunnel_door2:
    dw $D21C   ; Crab Hole
    db $00, $04, $01, $16, $00, $01
    dw $8000, #layout_door_aligned_asm
    dw $E356

door_aligned_A39C_main_street_door0:
    dw $CEFB   ; Glass Tunnel
    db $00, $06, $06, $02, $00, $00
    dw $0170, #layout_door_aligned_asm
    dw $0000

door_aligned_A480_red_fish_door1:
    dw $A322   ; Caterpillars
    db $40, $05, $2E, $36, $02, $03
    dw $8000, #layout_door_aligned_asm
    dw $E367

door_aligned_A4C8_crab_shaft_door2:
    dw $D5A7   ; Aqueduct
    db $00, $04, $01, $16, $00, $01
    dw $8000, #layout_door_aligned_asm
    dw $0000

door_aligned_A510_crab_hole_door2:
    dw $CF80   ; East Tunnel
    db $00, $05, $3E, $06, $03, $00
    dw $8000, #layout_door_aligned_asm
    dw #layout_asm_east_tunnel_no_scrolls

door_aligned_A708_aqueduct_door0:
    dw $D1A3   ; Crab Shaft
    db $00, $05, $1E, $36, $01, $03
    dw $8000, #layout_door_aligned_asm
    dw $E398

door_aligned_A840_precious_door1:
    dw $DA60   ; Draygon Room
    db $00, $05, $1E, $06, $01, $00
    dw $8000, #layout_door_aligned_asm
    dw $0000

door_aligned_A96C_draygon_door0:
    dw $D78F   ; Precious Room
    db $00, $04, $01, $26, $00, $02
    dw $8000, #layout_door_aligned_asm
    dw $E3D9

warnpc $83C000



org $83C000

; Custom door definitions, must be on or after $83C000
; Includes Samus X and Y and the overwritten asm pointer
door_custom_89CA_west_ocean_door0:
    dw $95FF   ; Moat
    db $00, $05, $1E, $06, $01, $00
    dw $8000, #layout_door_custom_asm
    dw $01CF, $0088, $0000

door_custom_8A42_crateria_kihunters_door2:
    dw $962A   ; Red Brinstar Elevator
    db $00, $06, $06, $02, $00, $00
    dw $8000, #layout_door_custom_asm
    dw $0080, $0058, $0000

door_custom_8AA2_forgotten_highway_elbow_door0:
    dw $957D   ; Crab Maze
    db $00, $04, $01, $16, $00, $01
    dw $8000, #layout_door_custom_asm
    dw $0034, $0188, $0000

door_custom_8AAE_crab_maze_door1:
    dw $95A8   ; Forgotten Highway Elbow
    db $00, $05, $0E, $06, $00, $00
    dw $8000, #layout_door_custom_asm
    dw $00D1, $0088, $0000

door_custom_8AEA_moat_door1:
    dw $93FE   ; West Ocean
    db $00, $04, $01, $46, $00, $04
    dw $8000, #layout_door_custom_asm
    dw $0034, $0488, $0000

door_custom_8AF6_red_brinstar_elevator_door0:
    dw $948C   ; Crateria Kihunters
    db $00, $07, $16, $2D, $01, $02
    dw $01C0, #layout_door_custom_asm
    dw $014C, $02B8, $B9F1

door_custom_8BFE_green_brinstar_elevator_door0:
    dw $9969   ; Lower Mushrooms
    db $00, $04, $01, $06, $00, $00
    dw $8000, #layout_door_custom_asm
    dw $0036, $0088, $0000

door_custom_8C22_lower_mushrooms_door1:
    dw $9938   ; Green Brinstar Elevator
    db $00, $05, $0E, $06, $00, $00
    dw $8000, #layout_door_custom_asm
    dw $00CC, $0088, $0000

door_custom_8C52_green_pirates_shaft_door2:
    dw $A5ED   ; Statues Hallway
    db $00, $04, $01, $06, $00, $00
    dw $8000, #layout_door_custom_asm
    dw $0034, $0088, #layout_asm_g4_door

door_custom_8E86_green_hill_zone_door1:
    dw $9E9F   ; Morph Ball
    db $00, $04, $01, $26, $00, $02
    dw $8000, #layout_door_custom_asm
    dw $0034, $0288, $0000

door_custom_8E9E_morph_ball_door0:
    dw $9E52   ; Green Hill Zone
    db $00, $05, $1E, $06, $01, $00
    dw $8000, #layout_door_custom_asm
    dw $01C7, $0088, $0000

door_custom_8F0A_noob_bridge_door1:
    dw $A253   ; Red Tower
    db $00, $04, $01, $46, $00, $04
    dw $8000, #layout_door_custom_asm
    dw $002F, $0488, $0000

door_custom_902A_red_tower_door1:
    dw $9FBA   ; Noob Bridge
    db $00, $05, $5E, $06, $05, $00
    dw $8000, #layout_door_custom_asm
    dw $05CE, $0088, $0000

door_custom_90C6_caterpillars_door4:
    dw $D104   ; Red Fish Room
    db $40, $04, $01, $06, $00, $00
    dw $8000, #layout_door_custom_asm
    dw $0034, $0088, $BDAF

door_custom_913E_warehouse_zeela_door0:
    dw $A6A1   ; Warehouse Entrance
    db $00, $05, $2E, $06, $02, $00
    dw $8000, #layout_door_custom_asm
    dw $02C7, $0098, $BD3F

door_custom_91E6_statues_hallway_door0:
    dw $99BD   ; Green Pirates Shaft
    db $00, $05, $0E, $66, $00, $06
    dw $8000, #layout_door_custom_asm
    dw $00CC, $0688, $0000

door_custom_922E_warehouse_entrance_door0:
    dw $CF80   ; East Tunnel
    db $40, $05, $0E, $16, $00, $01
    dw $8000, #layout_door_custom_asm
    dw $00CE, $0188, $E345

door_custom_923A_warehouse_entrance_door1:
    dw $A471   ; Warehouse Zeela
    db $00, $04, $01, $06, $00, $00
    dw $8000, #layout_door_custom_asm
    dw $0034, $0088, $0000

door_custom_93D2_crocomire_speedway_door4:
    dw $A98D   ; Crocomire's Room
    db $00, $06, $36, $02, $03, $00
    dw $8000, #layout_door_custom_asm
    dw $0383, $0098, $0000

door_custom_93EA_crocomire_door1:
    dw $A923   ; Crocomire Speedway
    db $00, $07, $C6, $2D, $0C, $02
    dw $01C0, #layout_door_custom_asm
    dw $0C57, $02B8, $0000

door_custom_95FA_single_chamber_door4:
    dw $B656   ; Three Musketeers
    db $00, $04, $11, $06, $01, $00
    dw $8000, #layout_door_custom_asm
    dw $0134, $0088, $0000

door_custom_967E_kronic_boost_door2:
    dw $AF14   ; Lava Dive
    db $00, $05, $3E, $06, $03, $00
    dw $8000, #layout_door_custom_asm
    dw $03D0, $0088, $0000

door_custom_96D2_lava_dive_door0:
    dw $AE74   ; Kronic Boost
    db $00, $04, $11, $26, $01, $02
    dw $8000, #layout_door_custom_asm
    dw $0134, $0288, $0000

door_custom_9A4A_three_musketeers_door0:
    dw $AD5E   ; Single Chamber
    db $00, $05, $5E, $06, $05, $00
    dw $8000, #layout_door_custom_asm
    dw $05CF, $0088, $0000

door_custom_A330_glass_tunnel_door0:
    dw $CFC9   ; Main Street
    db $00, $07, $16, $7D, $01, $07
    dw $0200, #layout_door_custom_asm
    dw $014A, $07A8, $0000

door_custom_A384_east_tunnel_door1:
    dw $A6A1   ; Warehouse Entrance
    db $40, $04, $01, $06, $00, $00
    dw $8000, #layout_door_custom_asm
    dw $0034, $0088, $0000

door_custom_A390_east_tunnel_door2:
    dw $D21C   ; Crab Hole
    db $00, $04, $01, $16, $00, $01
    dw $8000, #layout_door_custom_asm
    dw $0028, $0188, $E356

door_custom_A39C_main_street_door0:
    dw $CEFB   ; Glass Tunnel
    db $00, $06, $06, $02, $00, $00
    dw $0170, #layout_door_custom_asm
    dw $0081, $0078, $0000

door_custom_A480_red_fish_door1:
    dw $A322   ; Caterpillars
    db $40, $05, $2E, $36, $02, $03
    dw $8000, #layout_door_custom_asm
    dw $02CD, $0388, $E367

door_custom_A4C8_crab_shaft_door2:
    dw $D5A7   ; Aqueduct
    db $00, $04, $01, $16, $00, $01
    dw $8000, #layout_door_custom_asm
    dw $0034, $0188, $0000

door_custom_A510_crab_hole_door2:
    dw $CF80   ; East Tunnel
    db $00, $05, $3E, $06, $03, $00
    dw $8000, #layout_door_custom_asm
    dw $03C6, $0088, #layout_asm_east_tunnel_no_scrolls

door_custom_A708_aqueduct_door0:
    dw $D1A3   ; Crab Shaft
    db $00, $05, $1E, $36, $01, $03
    dw $8000, #layout_door_custom_asm
    dw $01CA, $0388, $E398

layout_swap_pose_table:
{
    db $00  ; Facing forward - power suit
    db $02  ; Facing right - normal
    db $01  ; Facing left  - normal
    db $04  ; Facing right - aiming up
    db $03  ; Facing left  - aiming up
    db $06  ; Facing right - aiming up-right
    db $05  ; Facing left  - aiming up-left
    db $08  ; Facing right - aiming down-right
    db $07  ; Facing left  - aiming down-left
    db $0A  ; Moving right - not aiming
    db $09  ; Moving left  - not aiming
    db $0C  ; Moving right - gun extended
    db $0B  ; Moving left  - gun extended
    db $0E  ; Moving right - aiming up (unused)
    db $0D  ; Moving left  - aiming up (unused)
    db $10  ; Moving right - aiming up-right
    db $0F  ; Moving left  - aiming up-left
    db $12  ; Moving right - aiming down-right
    db $11  ; Moving left  - aiming down-left
    db $14  ; Facing right - normal jump - not aiming - not moving - gun extended
    db $13  ; Facing left  - normal jump - not aiming - not moving - gun extended
    db $16  ; Facing right - normal jump - aiming up
    db $15  ; Facing left  - normal jump - aiming up
    db $18  ; Facing right - normal jump - aiming down
    db $17  ; Facing left  - normal jump - aiming down
    db $1A  ; Facing right - spin jump
    db $19  ; Facing left  - spin jump
    db $1C  ; Facing right - space jump
    db $1B  ; Facing left  - space jump
    db $41  ; Facing right - morph ball - no springball - on ground
    db $1F  ; Moving right - morph ball - no springball - on ground
    db $1E  ; Moving left  - morph ball - no springball - on ground
    db $20  ; Unused
    db $21  ; Unused
    db $22  ; Unused
    db $23  ; Unused
    db $24  ; Unused
    db $26  ; Facing right - turning - standing
    db $25  ; Facing left  - turning - standing
    db $28  ; Facing right - crouching
    db $27  ; Facing left  - crouching
    db $2A  ; Facing right - falling
    db $29  ; Facing left  - falling
    db $2C  ; Facing right - falling - aiming up
    db $2B  ; Facing left  - falling - aiming up
    db $2E  ; Facing right - falling - aiming down
    db $2D  ; Facing left  - falling - aiming down
    db $30  ; Facing right - turning - jumping
    db $2F  ; Facing left  - turning - jumping
    db $32  ; Facing right - morph ball - no springball - in air
    db $31  ; Facing left  - morph ball - no springball - in air
    db $33  ; Unused
    db $34  ; Unused
    db $36  ; Facing right - crouching transition
    db $35  ; Facing left  - crouching transition
    db $38  ; Facing right - morphing transition
    db $37  ; Facing left  - morphing transition
    db $39  ; Unused
    db $3A  ; Unused
    db $3C  ; Facing right - standing transition
    db $3B  ; Facing left  - standing transition
    db $3E  ; Facing right - unmorphing transition
    db $3D  ; Facing left  - unmorphing transition
    db $3F  ; Unused
    db $40  ; Unused
    db $1D  ; Facing left  - morph ball - no springball - on ground
    db $42  ; Unused
    db $44  ; Facing right - turning - crouching
    db $43  ; Facing left  - turning - crouching
    db $45  ; Unused
    db $46  ; Unused
    db $47  ; Unused
    db $48  ; Unused
    db $4A  ; Facing left  - moonwalk
    db $49  ; Facing right - moonwalk
    db $4C  ; Facing right - normal jump transition
    db $4B  ; Facing left  - normal jump transition
    db $4E  ; Facing right - normal jump - not aiming - not moving - gun not extended
    db $4D  ; Facing left  - normal jump - not aiming - not moving - gun not extended
    db $50  ; Facing left  - damage boost
    db $4F  ; Facing right - damage boost
    db $52  ; Facing right - normal jump - not aiming - moving forward
    db $51  ; Facing left  - normal jump - not aiming - moving forward
    db $54  ; Facing right - knockback
    db $53  ; Facing left  - knockback
    db $56  ; Facing right - normal jump transition - aiming up
    db $55  ; Facing left  - normal jump transition - aiming up
    db $58  ; Facing right - normal jump transition - aiming up-right
    db $57  ; Facing left  - normal jump transition - aiming up-left
    db $5A  ; Facing right - normal jump transition - aiming down-right
    db $59  ; Facing left  - normal jump transition - aiming down-left
    db $5B  ; Unused
    db $5C  ; Unused
    db $5D  ; Unused
    db $5E  ; Unused
    db $5F  ; Unused
    db $60  ; Unused
    db $61  ; Unused
    db $62  ; Unused
    db $63  ; Unused. Related to movement type Dh
    db $64  ; Unused. Related to movement type Dh
    db $65  ; Unused. Related to movement type Dh
    db $66  ; Unused. Related to movement type Dh
    db $68  ; Facing right - falling - gun extended
    db $67  ; Facing left  - falling - gun extended
    db $6A  ; Facing right - normal jump - aiming up-right
    db $69  ; Facing left  - normal jump - aiming up-left
    db $6C  ; Facing right - normal jump - aiming down-right
    db $6B  ; Facing left  - normal jump - aiming down-left
    db $6E  ; Facing right - falling - aiming up-right
    db $6D  ; Facing left  - falling - aiming up-left
    db $70  ; Facing right - falling - aiming down-right
    db $6F  ; Facing left  - falling - aiming down-left
    db $72  ; Facing right - crouching - aiming up-right
    db $71  ; Facing left  - crouching - aiming up-left
    db $74  ; Facing right - crouching - aiming down-right
    db $73  ; Facing left  - crouching - aiming down-left
    db $76  ; Facing left  - moonwalk - aiming up-left
    db $75  ; Facing right - moonwalk - aiming up-right
    db $78  ; Facing left  - moonwalk - aiming down-left
    db $77  ; Facing right - moonwalk - aiming down-right
    db $7A  ; Facing right - morph ball - spring ball - on ground
    db $79  ; Facing left  - morph ball - spring ball - on ground
    db $7C  ; Moving right - morph ball - spring ball - on ground
    db $7B  ; Moving left  - morph ball - spring ball - on ground
    db $7E  ; Facing right - morph ball - spring ball - falling
    db $7D  ; Facing left  - morph ball - spring ball - falling
    db $80  ; Facing right - morph ball - spring ball - in air
    db $7F  ; Facing left  - morph ball - spring ball - in air
    db $82  ; Facing right - screw attack
    db $81  ; Facing left  - screw attack
    db $84  ; Facing right - wall jump
    db $83  ; Facing left  - wall jump
    db $86  ; Facing right - crouching - aiming up
    db $85  ; Facing left  - crouching - aiming up
    db $88  ; Facing right - turning - falling
    db $87  ; Facing left  - turning - falling
    db $8A  ; Facing right - ran into a wall
    db $89  ; Facing left  - ran into a wall
    db $8C  ; Facing right - turning - standing - aiming up
    db $8B  ; Facing left  - turning - standing - aiming up
    db $8E  ; Facing right - turning - standing - aiming down-right
    db $8D  ; Facing left  - turning - standing - aiming down-left
    db $90  ; Facing right - turning - in air - aiming up
    db $8F  ; Facing left  - turning - in air - aiming up
    db $92  ; Facing right - turning - in air - aiming down/down-right
    db $91  ; Facing left  - turning - in air - aiming down/down-left
    db $94  ; Facing right - turning - falling - aiming up
    db $93  ; Facing left  - turning - falling - aiming up
    db $96  ; Facing right - turning - falling - aiming down/down-right
    db $95  ; Facing left  - turning - falling - aiming down/down-left
    db $98  ; Facing right - turning - crouching - aiming up
    db $97  ; Facing left  - turning - crouching - aiming up
    db $9A  ; Facing right - turning - crouching - aiming down/down-right
    db $99  ; Facing left  - turning - crouching - aiming down/down-left
    db $9B  ; Facing forward - varia/gravity suit
    db $9D  ; Facing right - turning - standing - aiming up-right
    db $9C  ; Facing left  - turning - standing - aiming up-left
    db $9F  ; Facing right - turning - in air - aiming up-right
    db $9E  ; Facing left  - turning - in air - aiming up-left
    db $A1  ; Facing right - turning - falling - aiming up-right
    db $A0  ; Facing left  - turning - falling - aiming up-left
    db $A3  ; Facing right - turning - crouching - aiming up-right
    db $A2  ; Facing left  - turning - crouching - aiming up-left
    db $A5  ; Facing right - landing from normal jump
    db $A4  ; Facing left  - landing from normal jump
    db $A7  ; Facing right - landing from spin jump
    db $A6  ; Facing left  - landing from spin jump
    db $A9  ; Facing right - grappling
    db $A8  ; Facing left  - grappling
    db $AB  ; Facing right - grappling - aiming down-right
    db $AA  ; Facing left  - grappling - aiming down-left
    db $AD  ; Unused. Facing right - grappling - in air
    db $AC  ; Unused. Facing left  - grappling - in air
    db $AF  ; Unused. Facing right - grappling - in air - aiming down
    db $AE  ; Unused. Facing left  - grappling - in air - aiming down
    db $B1  ; Unused. Facing right - grappling - in air - aiming down-right
    db $B0  ; Unused. Facing left  - grappling - in air - aiming down-left
    db $B3  ; Facing clockwise     - grapple - in air
    db $B2  ; Facing anticlockwise - grapple - in air
    db $B5  ; Facing right - grappling - crouching
    db $B4  ; Facing left  - grappling - crouching
    db $B7  ; Facing right - grappling - crouching - aiming down-right
    db $B6  ; Facing left  - grappling - crouching - aiming down-left
    db $B9  ; Facing left  - grapple wall jump pose
    db $B8  ; Facing right - grapple wall jump pose
    db $EC  ; Facing left  - grabbed by Draygon - not moving - not aiming
    db $ED  ; Facing left  - grabbed by Draygon - not moving - aiming up-left
    db $EE  ; Facing left  - grabbed by Draygon - firing
    db $EF  ; Facing left  - grabbed by Draygon - not moving - aiming down-left
    db $F0  ; Facing left  - grabbed by Draygon - moving
    db $C0  ; Facing right - moonwalking - turn/jump left
    db $BF  ; Facing left  - moonwalking - turn/jump right
    db $C2  ; Facing right - moonwalking - turn/jump left  - aiming up-right
    db $C1  ; Facing left  - moonwalking - turn/jump right - aiming up-left
    db $C4  ; Facing right - moonwalking - turn/jump left  - aiming down-right
    db $C3  ; Facing left  - moonwalking - turn/jump right - aiming down-left
    db $C5  ; Unused
    db $C6  ; Unused
    db $C8  ; Facing right - vertical shinespark windup
    db $C7  ; Facing left  - vertical shinespark windup
    db $CA  ; Facing right - shinespark - horizontal
    db $C9  ; Facing left  - shinespark - horizontal
    db $CC  ; Facing right - shinespark - vertical
    db $CB  ; Facing left  - shinespark - vertical
    db $CE  ; Facing right - shinespark - diagonal
    db $CD  ; Facing left  - shinespark - diagonal
    db $D0  ; Facing right - ran into a wall - aiming up-right
    db $CF  ; Facing left  - ran into a wall - aiming up-left
    db $D2  ; Facing right - ran into a wall - aiming down-right
    db $D1  ; Facing left  - ran into a wall - aiming down-left
    db $D4  ; Facing right - crystal flash
    db $D3  ; Facing left  - crystal flash
    db $D6  ; Facing right - x-ray - standing
    db $D5  ; Facing left  - x-ray - standing
    db $D8  ; Facing right - crystal flash ending
    db $D7  ; Facing left  - crystal flash ending
    db $DA  ; Facing right - x-ray - crouching
    db $D9  ; Facing left  - x-ray - crouching
    db $DB  ; Unused
    db $DC  ; Unused
    db $DD  ; Unused
    db $DE  ; Unused
    db $DF  ; Unused. Related to Draygon
    db $E1  ; Facing right - landing from normal jump - aiming up
    db $E0  ; Facing left  - landing from normal jump - aiming up
    db $E3  ; Facing right - landing from normal jump - aiming up-right
    db $E2  ; Facing left  - landing from normal jump - aiming up-left
    db $E5  ; Facing right - landing from normal jump - aiming down-right
    db $E4  ; Facing left  - landing from normal jump - aiming down-left
    db $E7  ; Facing right - landing from normal jump - firing
    db $E6  ; Facing left  - landing from normal jump - firing
    db $E9  ; Facing right - Samus drained - crouching/falling
    db $E8  ; Facing left  - Samus drained - crouching/falling
    db $EB  ; Facing right - Samus drained - standing
    db $EA  ; Facing left  - Samus drained - standing
    db $BA  ; Facing right - grabbed by Draygon - not moving - not aiming
    db $BB  ; Facing right - grabbed by Draygon - not moving - aiming up-right
    db $BC  ; Facing right - grabbed by Draygon - firing
    db $BD  ; Facing right - grabbed by Draygon - not moving - aiming down-right
    db $BE  ; Facing right - grabbed by Draygon - moving
    db $F2  ; Facing right - crouching transition - aiming up
    db $F1  ; Facing left  - crouching transition - aiming up
    db $F4  ; Facing right - crouching transition - aiming up-right
    db $F3  ; Facing left  - crouching transition - aiming up-left
    db $F6  ; Facing right - crouching transition - aiming down-right
    db $F5  ; Facing left  - crouching transition - aiming down-left
    db $F8  ; Facing right - standing transition - aiming up
    db $F7  ; Facing left  - standing transition - aiming up
    db $FA  ; Facing right - standing transition - aiming up-right
    db $F9  ; Facing left  - standing transition - aiming up-left
    db $FC  ; Facing right - standing transition - aiming down-right
    db $FB  ; Facing left  - standing transition - aiming down-left
    db $FD  ; Unused
    db $FE  ; Unused
    db $FF  ; If FFFF indicates pose variable is invalid
}

macro layout_swap_pose_direction_table_entry(offset)
    db <offset>+$00  ; Facing forward
    db <offset>+$01  ; Facing forward (unused)
    db <offset>+$02  ; Facing forward (unused)
    db <offset>+$03  ; Facing forward (unused)
    db <offset>+$08  ; Facing left
    db <offset>+$09  ; Facing left (unused)
    db <offset>+$0A  ; Facing left (unused)
    db <offset>+$0B  ; Facing left (unused)
    db <offset>+$04  ; Facing right
    db <offset>+$05  ; Facing right (unused)
    db <offset>+$06  ; Facing right (unused)
    db <offset>+$07  ; Facing right (unused)
    db <offset>+$0C  ; Unused
    db <offset>+$0D  ; Unused
    db <offset>+$0E  ; Unused
    db <offset>+$0F  ; Unused
endmacro

layout_swap_pose_direction_table:
{
    %layout_swap_pose_direction_table_entry($00)
    %layout_swap_pose_direction_table_entry($10)
    %layout_swap_pose_direction_table_entry($20)
    %layout_swap_pose_direction_table_entry($30)
    %layout_swap_pose_direction_table_entry($40)
    %layout_swap_pose_direction_table_entry($50)
    %layout_swap_pose_direction_table_entry($60)
    %layout_swap_pose_direction_table_entry($70)
    %layout_swap_pose_direction_table_entry($80)
    %layout_swap_pose_direction_table_entry($90)
    %layout_swap_pose_direction_table_entry($A0)
    %layout_swap_pose_direction_table_entry($B0)
    %layout_swap_pose_direction_table_entry($C0)
    %layout_swap_pose_direction_table_entry($D0)
    %layout_swap_pose_direction_table_entry($E0)
    %layout_swap_pose_direction_table_entry($F0)
}

macro layout_swap_pose(address)
    LDA <address> : TAX
    LDA.l layout_swap_pose_table,X : STA <address>
endmacro

macro layout_swap_pose_direction(address)
    LDA <address> : TAX
    LDA.l layout_swap_pose_direction_table,X : STA <address>
endmacro

layout_swap_left_right:
{
    PHX : PHP
    LDA $0AF6 : EOR #$00FF : INC : STA $0AF6
    LDA $0AF8 : EOR #$FFFF : STA $0AF8

    TDC : %ai8()
    %layout_swap_pose($0A1C)
    %layout_swap_pose_direction($0A1E)
    %layout_swap_pose($0A20)
    %layout_swap_pose_direction($0A22)
    %layout_swap_pose($0A24)
    %layout_swap_pose_direction($0A26)
    %layout_swap_pose($0A28)
    %layout_swap_pose($0A2A)
    %layout_swap_pose($0A2C)

    PLP : PLX
    RTL
}



; Allow debug save stations to be used
org $848D0C
    AND #$000F

; Ignore picky chozo
org $84D18F
layout_picky_chozo:
{
    LDA config_arearando : BNE .skip_picky_chozo
    LDA $09A4 : AND #$0200 : BEQ layout_picky_chozo_end
.skip_picky_chozo
    ; Shift existing logic nine bytes down
    LDA $0B02 : AND #$000F : CMP #$0003 : BNE layout_picky_chozo_end
    LDA $0A1C : CMP #$001D : BEQ .start_chozo_event
    CMP #$0079 : BEQ .start_chozo_event : CMP #$007A : BNE layout_picky_chozo_end
.start_chozo_event
    ; Make up for overridden code
    JSL layout_set_picky_chozo_event_and_enemy_speed
}
warnpc $84D1C1

org $84D1DE
layout_picky_chozo_end:



; Crateria Kihunters
org $8F94B1
crateria_kihunters_room_setup_asm_pointer:
    dw #layout_asm_crateria_kihunters

; East Ocean
org $8F9522
east_ocean_room_setup_asm_pointer:
    dw #layout_asm_east_ocean

; Forgotten Highway Elbow
org $8F95CD
asm_forgotten_highway_elbow_room_setup_asm_pointer:
    dw #layout_asm_forgotten_highway_elbow

; Green Hill Zone
org $8F9E77
green_hill_zone_room_setup_asm_pointer:
    dw #layout_asm_green_hill_zone

; Moat
org $8F9624
moat_room_setup_asm_pointer:
    dw #layout_asm_moat

; Green Pirates Shaft
org $8F99E2
green_pirates_shaft_room_setup_asm_pointer:
    dw #layout_asm_green_pirates_shaft

; Morph Ball
org $8F9EE3
morph_ball_room_setup_asm_pointer:
    dw #layout_asm_morph_ball

; Noob Bridge
org $8F9FDF
noob_bridge_room_setup_asm_pointer:
    dw #layout_asm_noob_bridge

; Warehouse Kihunters
org $8FA4FF
warehouse_kihunters_room_setup_asm_pointer:
    dw #layout_asm_warehouse_kihunters

; Crocomire Speedway
org $8FA948
croc_speedway_room_setup_asm_pointer:
    dw #layout_asm_croc_speedway

; Crocomire
org $8FA9B7
croc_room_setup_asm_pointer:
    dw #layout_asm_croc

; Single Chamber
org $8FAD83
single_chamber_room_setup_asm_pointer:
    dw #layout_asm_single_chamber

; Kronic Boost
org $8FAE99
kronic_boost_room_setup_asm_pointer:
    dw #layout_asm_kronic_boost

; Caterpillars elevator and middle-left door asm
org $8FBA26
    ; Replace STA with jump to STA
    JMP layout_asm_caterpillars_update_scrolls

; Caterpillars bottom-left door asm
org $8FBE18
    ; Overwrite PLP : RTS with jump
    ; Okay to overwrite $BE1A since we freed up that space
    JMP layout_asm_caterpillars_after_scrolls

; Wrecked Ship Main Shaft
org $8FCB20
wrecked_ship_main_shaft_room_setup_asm_pointer:
    dw #layout_asm_wrecked_ship_main_shaft

; Wrecked Ship Save
org $8FCEB4
wrecked_ship_save_room_setup_asm_pointer:
    dw layout_asm_wrecked_ship_save

; Main Street
org $8FCFEE
main_street_room_setup_asm_pointer:
    dw #layout_asm_main_street

; Crab Tunnel
org $8FD0AF
crab_tunnel_room_setup_asm_pointer:
    dw #layout_asm_crab_tunnel

; West Sand Hall Tunnel
org $8FD277
west_sand_hall_tunnel_room_setup_asm_pointer:
    dw #layout_asm_west_sand_hall_tunnel

; Aqueduct
org $8FD5CC
aqueduct_room_setup_asm_pointer:
    dw #layout_asm_aqueduct

; Butterfly
org $8FD611
butterfly_room_setup_asm_pointer:
    dw #layout_asm_butterfly

; Below Botwoon E-Tank
org $8FD706
below_botwoon_etank_door_list_pointer:
    dw #layout_asm_below_botwoon_etank_door_list

; Halfie Climb
org $8FD938
halfie_climb_room_setup_asm_pointer:
    dw #layout_asm_halfie_climb

; East Tunnel bottom-left and bottom-right door asm
org $8FE34E
    ; Optimize existing logic by one byte
    INC : STA $7ECD24
    ; Overwrite extra byte : PLP : RTS with jump
    JMP layout_asm_east_tunnel_after_scrolls

; Caterpillars far-right door asm
org $8FE370
    ; Optimize existing logic by one byte
    INC : STA $7ECD2A
    ; Overwrite extra byte : PLP : RTS with jump
    JMP layout_asm_caterpillars_after_scrolls

; Crab Shaft right door asm
org $8FE39D
    ; Replace STA with jump to STA
    JMP layout_asm_crab_shaft_update_scrolls

; Fix Morph and Missiles room state
org $8FE652
layout_asm_morph_missiles:
    LDA $7ED873
    BEQ .no_items
    BRA .items
warnpc $8FE65F

org $8FE65F
.items

org $8FE666
.no_items



org $8FEA00

layout_door_aligned_asm:
{
    ; Give Samus 128 I-Frames
    LDA #$0080 : STA $18A8

    ; Execute another door asm if necessary
    LDA $83000C,X : BEQ .done
    STA $12 : JMP ($0012)

.done
    RTS
}

layout_door_custom_asm:
{
    ; Cancel movement
    STZ $0B2C : STZ $0B2E
    STZ $0B32 : STZ $0B34
    STZ $0B36
    STZ $0B42 : STZ $0B44
    STZ $0B46 : STZ $0B48
    STZ $092B : STZ $092D

    LDA $0A1C : CMP #$00C7 : BMI .resetPose
    CMP #$00CF : BPL .resetPose

    ; Clear shine timer and type if previously in shinespark or windup
    STZ $0B3F : STZ $0A68 : STZ $0ACC

.resetPose
    ; Force Samus to elevator pose
    STZ $0A1C : STZ $0A1E
    STZ $0A20 : STZ $0A22
    STZ $0A24 : STZ $0A26

    ; Set pose transition values to FFFF
    LDA #$FFFF : STA $0A28
    STA $0A2A : STA $0A2C

    ; Clear potential pose flags
    STZ $0A2E : STZ $0A30 : STZ $0A32

    ; Reset animation timer and contact damage index
    STZ $0A96 : STZ $0A6E

    ; Reset elevator flags
    STZ $0E16 : STZ $0E18

    ; Unlock Samus
    LDA #$E695 : STA $0A42
    LDA #$E725 : STA $0A44
    LDA #$A337 : STA $0A58
    LDA #$E913 : STA $0A60

    ; Set Samus position
    LDA $83000C,X : STA $0AF6
    LDA $83000E,X : STA $0AFA

    ; Give Samus 128 I-Frames
    LDA #$0080 : STA $18A8

    ; Clear BG2 VRAM flag in case we are exiting croc
    STZ $0E1E

    ; Execute another door asm if necessary
    LDA $830010,X : BEQ .done
    STA $12 : JMP ($0012)

.done
    RTS
}

layout_asm_crateria_kihunters_bottom_door:
{
    ; Perform same scroll asm as vanilla
    PHP
    %a8()
    LDA #$02 : STA $7ECD21 : STA $7ECD24
    PLP

    ; Fall through to next method to clear BG2 VRAM flag
}

layout_asm_clear_bg2_vram_flag:
{
    ; Clear BG2 VRAM flag in case we are exiting croc
    STZ $0E1E
    RTS
}

layout_asm_g4_door:
{
    ; Door ASM to set the G4 open event bit if all major bosses are killed
    LDA $7ED828
    BIT #$0100
    BEQ .exit
    LDA $7ED82C
    BIT #$0001
    BEQ .exit
    LDA $7ED82A
    AND #$0101
    CMP #$0101
    BNE .exit
    LDA $7ED820
    ORA #$0400
    STA $7ED820
.exit
    RTS
}

layout_asm_wake_zebes:
{
    ; Door ASM to wake zebes if morph ball item collected
    LDA $7ED872
    BIT #$0400
    BEQ .exit
    LDA $7ED820
    ORA #$0001
    STA $7ED820
.exit
    RTS
}

layout_asm_caterpillars_no_scrolls:
    PHP
    BRA layout_asm_caterpillars_after_scrolls

layout_asm_caterpillars_update_scrolls:
    STA $7ECD26

layout_asm_caterpillars_after_scrolls:
{
    %a16()
    LDA config_arearando : BEQ .done

    ; Decorate gap with blocks
    LDA #$8562 : STA $7F145E : STA $7F1460 : STA $7F151E : STA $7F1520

    ; Fix wall decoration below blocks
    LDA #$8543 : STA $7F157E : LDA #$8522 : STA $7F1580

    ; Create visible gap in wall
    LDA #$00FF : STA $7F14BE : STA $7F14C0

    ; Remove gate and block next to gate
    STA $7F142C : STA $7F142E : STA $7F1430
    STA $7F148E : STA $7F14EE : STA $7F154E : STA $7F15AE

    ; Clear gate projectile
    LDA #$0000 : STA $19B9

    ; Delete gate PLMs
    LDA #$AAE3 : STA $1D6B : STA $1D6D

    ; Normal BTS for gate tiles
    %a8()
    LDA #$00 : STA $7F6E17 : STA $7F6E18 : STA $7F6E19
    STA $7F6E48 : STA $7F6E78 : STA $7F6EA8 : STA $7F6ED8

.done:
}

layout_asm_east_tunnel_done:
    PLP
    RTS

layout_asm_east_tunnel_no_scrolls:
    PHP

layout_asm_east_tunnel_after_scrolls:
{
    %a16()
    LDA config_arearando : BEQ layout_asm_east_tunnel_done

    ; Clear gate projectile
    LDA #$0000 : STA $19B9

    ; Delete gate PLMs
    LDA #$AAE3 : STA $1D6B : STA $1D6D

    ; Remove gate tiles
    LDA #$00FF : STA $7F02AE : STA $7F02B0
    STA $7F032E : STA $7F03AE : STA $7F042E : STA $7F04AE

    ; Remove blocks from vertical shaft
    STA $7F078C : STA $7F088C : STA $7F090C
    STA $7F098C : STA $7F0A0C : STA $7F0A8C
    ; Careful with the block that is also a scroll block
    LDA #$30FF : STA $7F080C

    ; Normal BTS for gate tiles
    %a8()
    LDA #$00 : STA $7F6558 : STA $7F6559
    STA $7F6598 : STA $7F65D8 : STA $7F6618 : STA $7F6658

    ; Decorate vertical shaft
    LDA #$22 : STA $7F070A : STA $7F070E
    STA $7F078A : STA $7F078E : STA $7F080A : STA $7F080E
    STA $7F088A : STA $7F088E : STA $7F090A : STA $7F090E
    STA $7F098A : STA $7F098E : STA $7F0A0A : STA $7F0A0E
    LDA #$85 : STA $7F078B : STA $7F080B : STA $7F088B
    STA $7F090B : STA $7F098B : STA $7F0A0B
    STA $7F0A8A : STA $7F0A8E
    LDA #$8D : STA $7F0A8B

    PLP
    RTS
}

layout_asm_crab_shaft_no_scrolls:
    PHP
    BRA layout_asm_crab_shaft_after_scrolls

layout_asm_crab_shaft_update_scrolls:
    STA $7ECD26

layout_asm_crab_shaft_after_scrolls:
{
    %a16()
    LDA config_arearando : BEQ .done

    ; Set green door as already opened
    LDA $7ED8C0 : ORA #$8000 : STA $7ED8C0

    ; Clear space above save station
    LDA #$00FF : STA $7F095C : STA $7F095E

    ; Add save station PLM
    %ai16()
    PHX : LDX #layout_asm_crab_shaft_plm_data
    JSL $84846A : PLX

.done
    PLP
    RTS
}

layout_asm_crab_shaft_plm_data:
    db #$6F, #$B7, #$0D, #$29, #$09, #$00

layout_asm_west_sand_hall:
{
    PHP
    %a16()
    LDA config_arearando : BEQ .done

    ; Change left door BTS to previously unused door
    %a8()
    LDA #$02 : STA $7F6582 : STA $7F65C2 : STA $7F6602 : STA $7F6642

.done
    PLP
    RTS
}

layout_asm_crateria_kihunters:
{
    PHP
    %a16()
    LDA config_arearando : BEQ .done

    ; Set yellow door as already opened
    LDA $7ED8B0 : ORA #$4000 : STA $7ED8B0

.done
    PLP
    RTS
}

layout_asm_east_ocean:
{
    PHP
    %a16()
    LDA config_arearando : BEQ .done

    ; Add platforms for ease of access to right door
    LDA #$8100 : STA $7F4506 : STA $7F4876
    INC : STA $7F4508 : STA $7F4878
    LDA #$8501 : STA $7F450A : STA $7F487A
    DEC : STA $7F450C : STA $7F487C
    LDA #$1120 : STA $7F45E6 : STA $7F4956
    INC : STA $7F45E8 : STA $7F4958
    LDA #$1521 : STA $7F45EA : STA $7F495A
    DEC : STA $7F45EC : STA $7F495C

    ; Slope BTS for platform bottoms
    %a8()
    LDA #$94 : STA $7F86F4 : STA $7F88AC
    INC : STA $7F86F5 : STA $7F88AD
    LDA #$D5 : STA $7F86F6 : STA $7F88AE
    DEC : STA $7F86F7 : STA $7F88AF

.done
    PLP
    ; Original logic for scrolling sky
    JSL $88A800
    RTS
}

layout_asm_forgotten_highway_elbow:
{
    PHP
    %a16()
    LDA config_arearando : BEQ .done

    ; Set yellow door as already opened
    LDA $7ED8B0 : ORA #$8000 : STA $7ED8B0

.done
    PLP
    RTS
}

layout_asm_green_hill_zone:
{
    PHP
    %a16()
    LDA config_arearando : BEQ .done

    ; Set yellow door as already opened
    LDA $7ED8B6 : ORA #$0001 : STA $7ED8B6

    ; Remove gate and corner tile next to gate
    LDA #$00FF : STA $7F37C8 : STA $7F37CA : STA $7F37CC
    STA $7F38CA : STA $7F39CA : STA $7F3ACA : STA $7F3BCA

    ; Clear gate projectile
    LDA #$0000 : STA $19B9

    ; Delete gate PLMs
    LDA #$AAE3 : STA $1D73 : STA $1D75

    ; Remove ledge overhang for ease of access to top-right door
    LDA #$00FF : STA $7F0A2A : STA $7F0B2A

    ; Move corner tiles next to gate up one
    %a8()
    LDA #$78 : STA $7F36CA
    LDA #$79 : STA $7F36CC

    ; Normal BTS for gate tiles
    LDA #$00 : STA $7F7FE5 : STA $7F7FE6
    STA $7F8066 : STA $7F80E6
    STA $7F8166 : STA $7F81E6

.done
    PLP
    RTS
}

layout_asm_moat:
{
    PHP
    %a16()
    LDA config_arearando : BEQ .done

    ; Use shootable blocks on the moat pillar
    %a8()
    LDA #$C0 : STA $7F059F : STA $7F061F
    LDA #$BE : STA $7F05DE
    LDA #$D0 : STA $7F05DF

    ; Set BTS so the top block is 1x2
    LDA #$02 : STA $7F66D0
    LDA #$FF : STA $7F66F0

.done
    PLP
    RTS
}

layout_asm_green_pirates_shaft:
{
    PHP
    %a16()
    LDA config_arearando : BEQ .done

    ; Set red door as already opened
    LDA $7ED8B2 : ORA #$4000 : STA $7ED8B2

.done
    PLP
    RTS
}

layout_asm_morph_ball:
{
    PHP
    %a16()
    LDA config_arearando : BEQ .done

    ; Set grey door as already opened
    LDA $7ED8B6 : ORA #$0002 : STA $7ED8B6

.done
    PLP
    RTS
}

layout_asm_noob_bridge:
{
    PHP
    %a16()
    LDA config_arearando : BEQ .done

    ; Set green door as already opened
    LDA $7ED8B6 : ORA #$0008 : STA $7ED8B6

.done
    PLP
    RTS
}

layout_asm_warehouse_kihunters:
{
    PHP
    %a16()
    LDA config_arearando : BEQ .done

    ; Use shootable block
    %a8()
    LDA #$C5 : STA $7F064F

.done
    PLP
    RTS
}

layout_asm_croc_speedway:
{
    PHP
    %a16()
    LDA config_arearando : BEQ .done

    ; Set green door as already opened
    LDA $7ED8B8 : ORA #$4000 : STA $7ED8B8

.done
    PLP
    RTS
}

layout_asm_croc:
{
    PHP
    %a16()
    LDA config_arearando : BEQ .done

    ; Set grey door as already opened
    LDA $7ED8B8 : ORA #$8000 : STA $7ED8B8

.done
    PLP
    RTS
}

layout_asm_single_chamber:
{
    PHP
    %a16()
    LDA config_arearando : BEQ .done

    ; Move right wall back one to create a ledge
    LDA #$810C : STA $7F06E0 : STA $7F0A9E
    LDA #$8507 : STA $7F07A0 : STA $7F0920
    LDA #$8505 : STA $7F0860 : STA $7F09E0

    ; Clear out the ledge
    LDA #$00FF : STA $7F06DE : STA $7F079E
    STA $7F085E : STA $7F091E : STA $7F09DE

    ; Remove crumble blocks from vertical shaft
    STA $7F05E0 : STA $7F05E2
    STA $7F06A0 : STA $7F06A2 : STA $7F0760 : STA $7F0762

    ; Remove blocks from horizontal shaft
    STA $7F061E : STA $7F0620 : STA $7F0624
    ; Careful with the block that is also a scroll block
    LDA #$30FF : STA $7F0622

    ; Normal BTS for crumble blocks
    %a8()
    LDA #$00 : STA $7F66F1 : STA $7F66F2
    STA $7F6751 : STA $7F6752 : STA $7F67B1 : STA $7F67B2

.done:
    PLP
    RTS
}

layout_asm_kronic_boost:
{
    PHP
    %a16()
    LDA config_arearando : BEQ .done

    ; Set yellow door as already opened
    LDA $7ED8BA : ORA #$0100 : STA $7ED8BA

.done
    PLP
    RTS
}

layout_asm_wrecked_ship_main_shaft:
{
    PHP
    %a16()
    LDA config_arearando : BEQ .done

    ; Set grey door as already opened
    LDA $7ED8C0 : ORA #$0008 : STA $7ED8C0

.done
    PLP
    RTS
}

layout_asm_wrecked_ship_save:
{
    PHP
    %a16()
    LDA config_arearando : BEQ .done

    ; Activate save station
    JSL $8483D7
    dw $0B07, $B76F

.done
    PLP
    RTS
}

layout_asm_main_street:
{
    PHP
    %a16()
    LDA config_arearando : BEQ .done

    ; Add save station PLM
    %ai16()
    PHX : LDX #layout_asm_main_street_plm_data
    JSL $84846A : PLX

.done
    PLP
    RTS
}

layout_asm_main_street_plm_data:
    db #$6F, #$B7, #$18, #$59, #$0A, #$00

layout_asm_crab_tunnel:
{
    PHP
    %a16()
    LDA config_arearando : BEQ .done

    ; Replace top of gate with slope tiles
    LDA #$1D87 : STA $7F039C : LDA #$1194 : STA $7F039E

    ; Fix tiles to the right of the gate
    LDA #$89A0 : STA $7F03A0 : LDA #$811D : STA $7F0320

    ; Remove remaining gate tiles
    LDA #$00FF : STA $7F041E : STA $7F049E : STA $7F051E : STA $7F059E

    ; Clear gate projectile
    LDA #$0000 : STA $19B9

    ; Delete gate PLMs
    LDA #$AAE3 : STA $1D73 : STA $1D75

    ; Slope BTS for top of the gate tiles
    %a8()
    LDA #$D2 : STA $7F65CF : LDA #$92 : STA $7F65D0

    ; Normal BTS for remaining gate tiles
    LDA #$00 : STA $7F6610 : STA $7F6650 : STA $7F6690 : STA $7F66D0

.done
    PLP
    RTS
}

layout_asm_west_sand_hall_tunnel:
{
    PHP
    %a16()
    LDA config_arearando : BEQ .done

    ; Add grey door PLM
    %ai16()
    PHX : LDX #layout_asm_west_sand_hall_tunnel_plm_data
    JSL $84846A : PLX

.done
    PLP
    RTS
}

layout_asm_west_sand_hall_tunnel_plm_data:
    db #$42, #$C8, #$0E, #$06, #$0B, #$90

layout_asm_aqueduct:
{
    PHP
    %a16()
    LDA config_arearando : BEQ .done

    ; Replace power bomb blocks with bomb blocks
    LDA #$F09D : STA $7F1690 : STA $7F18D0
    LDA #$F49D : STA $7F1692 : STA $7F18D2

    ; Replace BTS
    %a8()
    LDA #$04 : STA $7F6F49 : STA $7F6F4A
    STA $7F7069 : STA $7F706A

.done
    PLP
    RTS
}

layout_asm_butterfly:
{
    PHP
    %a16()
    LDA config_arearando : BEQ .done

    ; Set grey door as already opened
    LDA $7ED8C2 : ORA #$0080 : STA $7ED8C2

.done
    PLP
    RTS
}

layout_asm_below_botwoon_etank_door_list:
    dw #$A7D4, #below_botwoon_etank_west_sand_hall_door_definition

layout_asm_below_botwoon_etank_external:
{
    ; Place door BTS
    %a8()
    LDA #$40 : STA $7F65C0 : LDA #$FF : STA $7F6600
    DEC : STA $7F6640 : DEC : STA $7F6680 : LDA #$01
    STA $7F65C1 : STA $7F6601 : STA $7F6641 : STA $7F6681

    ; Move right wall one to the left
    %a16()
    LDA #$8A09 : STA $7F01FE : LDA #$820E : STA $7F067E
    LDA #$820A : STA $7F027E : STA $7F05FE
    LDA #$8A0B : STA $7F02FE : LDA #$8A07 : STA $7F0300
    LDA #$820B : STA $7F057E : LDA #$8207 : STA $7F0580

    ; Fill in area behind the wall
    LDA #$8210 : STA $7F0200 : STA $7F0280 : STA $7F0600 : STA $7F0680

    ; Place the door
    LDA #$C00C : STA $7F037E : LDA #$9040 : STA $7F0380
    LDA #$D02C : STA $7F03FE : LDA #$9060 : STA $7F0400
    LDA #$D82C : STA $7F047E : LDA #$9860 : STA $7F0480
    LDA #$D80C : STA $7F04FE : LDA #$9840 : STA $7F0500
    RTL
}

layout_asm_halfie_climb:
{
    PHP
    %a16()
    LDA config_arearando : BEQ .done

    ; Set grey door as already opened
    LDA $7ED8C2 : ORA #$1000 : STA $7ED8C2

.done
    PLP
    RTS
}

warnpc $8FF700

