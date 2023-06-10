; Removes Gravity Suit heat protection
org $8de37c
    and #$0001

; Grants acid damage reduction to Varia instead of Gravity
org $90e9dc
    bit #$0001

; Suit acquisition animation skip
org $848717
    nop : nop : nop : nop

; Mother brain cutscene edits
org $a98823
    lda #$0001

org $a98847
    lda #$0001

org $a98866
    lda #$0001

org $a9887e
    lda #$0001

org $a9897c
    lda #$0010

org $a989ae
    lda #$0010

org $a989e0
    lda #$0010

org $a98a08
    lda #$0010

org $a98a30
    lda #$0010

org $a98a62
    lda #$0010

org $a98a94
    lda #$0010

org $a98b33
mother_brain_main_tube_falling_parameter:
    dw #$0010

org $a98b8c
    adc #$0012

org $a98bda
    adc #$0004

org $a98d73
    lda #$0000

org $a98d85
    lda #$0000

org $a98dae
; no change from vanilla
;    lda #$0100

org $a98dc6
    bcs $23

org $a98e50
    and #$0001

org $a98eee
    lda #$000a

org $a98f0e
    lda #$0060

org $a9af0c
    lda #$000a

org $a9af4d
    lda #$000a

org $a9b00c
    lda #$0000

org $a9b131
    adc #$0040

org $a9b16c
    lda #$0000

org $a9b19e
    lda #$0020

org $a9b1b1
    lda #$0030

org $a9b20b
    lda #$0003

org $a9b939
; no change from vanilla
;    lda #$0100


; Fix Morph & Missiles room state
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

; Fix heat damage speed echoes bug
org $91b629
pose_definitions_table:
    db $01

; Disable GT Code
org $aac91c
    bra $3f

; Disable Space/time
org $82b174
    ldx #$0001

; Fix Morph Ball Hidden/Chozo PLM's
org $84e8ce
morph_ball_chozo_plm_equipment:
    dw $0004

org $84ee02
morph_ball_hidden_plm_equipment:
    dw $0004

; Fix Screw Attack selection in menu
org $82b4c4
    cpx #$000c

