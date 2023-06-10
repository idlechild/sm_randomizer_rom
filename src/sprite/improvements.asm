; --- QoL improvements ---

; This bug prevents left and right morphball from being different.
; Also fixes the tilemaps
;$E508
;AFP_T31:    ;Midair morphball facing right without springball
;AFP_T32:    ;Midair morphball facing left without springball

; Note: This fix is overwritten by dmadata.asm
;org $92D9B2
;samus_improvement_animation_midair_morphball_facing_left:
;   dw $E530

; Note: This fix is overwritten by dmadata.asm
;samus_improvement_upper_tilemap_midair_morphball_facing_left:
;org $9292C7
;    dw $071A

; Note: This fix is overwritten by dmadata.asm
;org $9294C1
;samus_improvement_lower_tilemap_midair_morphball_facing_left:
;    dw $071A


; The second byte here is probably supposed to be $10, just like the previous
; animation. $F0 is a terminator which is only ever be invoked here (besides
; there being a pose in this spot!)
;$B361
;FD_6D:    ;Falling facing right, aiming upright
;FD_6E:    ;Falling facing left, aiming upleft
;FD_6F:    ;Falling facing right, aiming downright
;FD_70:    ;Falling facing left, aiming downleft
;DB $02, $F0, $10, $FE, $01

org $91B361+1
animation_delay_falling_angling:
    db $10


; The second byte here is supposed to be $00, but because it is not, the
; missile port is rendered behind Samus's left fist during elevator pose.
;$c9db
;XY_P00:    ;00:;Facing forward, ala Elevator pose (power suit)
;XY_P9B:    ;9B:;Facing forward, ala Elevator pose (Varia and/or Gravity Suit)
;DB $00, $02

org $90C9DC
cannon_drawing_data_facing_forward_arm_cannon_drawing_mode:
    db $00


; --- Cannon ports ---

; Cannon port position is mostly left intact, but the set of downwards aiming
; ports are super broken.

; Redirects to new XY lists

org $90C80F
cannon_drawing_data_facing_left_normal_jump_aiming_down_pointer:
    dw cannon_drawing_data_facing_left_aiming_down

org $90C839
cannon_drawing_data_facing_right_falling_aiming_down_pointer:
    dw cannon_drawing_data_facing_right_aiming_down

org $90C83B
cannon_drawing_data_facing_left_falling_aiming_down_pointer:
    dw cannon_drawing_data_facing_left_aiming_down


; New XY lists

org $90CAC5
cannon_drawing_data_facing_right_aiming_down:
    db $83, $01, $84, $01, $0B, $01, $00, $0D

warnpc $90CAD1

org $90CB31
cannon_drawing_data_facing_left_aiming_down:
    db $86, $01, $85, $01, $ED, $01, $F7, $0D

warnpc $90CB3D


; The set of the right-facing jump begin/land missile port placements is
; inconsistent across the animations and even omitted in many animations.
; We choose to make it consistent by always omitting it.

org $90CAD1
cannon_drawing_data_facing_right_normal_jump:
    db $00, $00

org $90CBF9
cannon_drawing_data_facing_right_landing_from_normal_jump:
    db $00, $00

org $90CC05
cannon_drawing_data_facing_right_landing_from_spin_jump:
    db $00, $00


; In these cases the cannon was actually placed onto the gun port backwards...
;$CBA5
;XY_P49:    ;49:;Moonwalk, facing left
;DB $02, $01
;DB $F1, $FD, $F1, $FC, $F1, $FC, $F1, $FD, $F1, $FC, $F1, $FC
;$CBB3
;XY_P4A:    ;4A:;Moonwalk, facing right
;DB $07, $01
;DB $07, $FD, $07, $FC, $07, $FC, $07, $FD, $07, $FC, $07, $FC

org $90CBA5
cannon_drawing_data_facing_left_moonwalk:
    db $07, $01, $ED, $FD, $ED, $FC, $ED, $FC, $ED, $FD, $ED, $FC, $ED, $FC

warnpc $90CBB3

org $90CBB3
cannon_drawing_data_facing_right_moonwalk:
    db $02, $01, $0B, $FD, $0B, $FC, $0B, $FC, $0B, $FD, $0B, $FC, $0B, $FC

warnpc $90CBC1

