
; Door going into the corridor before G4
org $838c5c
green_pirates_shaft_tourian_door_pointer:
    dw g4_door

; Door into small corridor before construction zone
org $838eb4
morph_ball_room_construction_zone_door_pointer:
    dw wake_zebes


; Fix Morph and Missiles room state
org $8fe652
morph_missiles:
    lda.l $7ed873
    beq .no_items
    bra .items
warnpc $8fe65f

org $8fe65f
.items

org $8fe666
.no_items


org $8fea00

; Door ASM to set the G4 open event bit if all major bosses are killed
g4_door:
    lda $7ed828
    bit.w #$0100
    beq +
    lda $7ed82c
    bit.w #$0001
    beq +
    lda $7ed82a
    and.w #$0101
    cmp.w #$0101
    bne +
    lda $7ed820
    ora.w #$0400
    sta $7ed820
+
    rts

; Door ASM to wake zebes if morph ball item collected
wake_zebes:
    lda $7ed872
    bit #$0400
    beq exit
    lda $7ed820
    ora.w #$0001
    sta $7ed820
    exit:
    rts

