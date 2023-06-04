
; Door ASM pointer (Door into small corridor before construction zone)
org $838eb4
morph_ball_room_construction_zone_door_pointer:
    dw wake_zebes

; Door ASM to set Zebes awake
org $8fff00
wake_zebes:
    lda $7ed872
    bit #$0400
    beq exit
    lda $7ed820
    ora.w #$0001
    sta $7ed820
    exit:
    rts
