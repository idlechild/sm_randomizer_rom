;
; Code for injecting PLM's into rooms at runtime.
; This is done to minimize the amount of big room edits needed where a lot of room header information would need to be shuffled around otherwise.
;

; Hijack room loading to be able to inject arbitrary PLM:s into a room
org $82e8d5
    jsl inject_plms

org $82eb8b
    jsl inject_plms

org $8ff700
inject_plms:
    ldx #plm_table

-
    ; Check if the PLM goes in this room, if the table is $0000 then exit
    lda $0000, x
    beq .end

    cmp $079b
    bne .next

    ; Ok, Spawn the PLM
    inx
    inx
    jsl $84846a

.next
    inx #6
    bra -

.end
    jml $8FE8A3  ; Execute door ASM
warnpc $8ff800

org $8ff800
plm_table:
;   room,   plm,  yyxx,  args
dw !START_ROOM_ID, $b76f, !START_ROOM_TILE_XY, !START_SAVESTATION_ID
dw $0000, $0000, $0000, $0000       ; End of table

warnpc $8ffe00

