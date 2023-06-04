
; Set door asm pointer (Door going into the corridor before G4)
org $838c5c
green_pirates_shaft_door_pointer:
    dw g4_door

; Door ASM to set the G4 open event bit if all major bosses are killed
org $8ffe00
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

warnpc $8fff00

