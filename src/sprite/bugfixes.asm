; These are significant typos that reference bad palettes or similar, and would
; raise assertion errors in any clean code


; Last byte should be $28, like everything else
;TM_193:
;DW $0001
;DB $F8, $01, $F8, $00, $30

org $92BEBF+6
samus_bugfix_pose_top_half_facing_right_walljump_spacejump_screwattack:
    db $28


; Last byte should be $28, like everything else
;TM_181:
;DW $0001
;DB $F8, $01, $F8, $00, $10

org $92BC7A+6
samus_bugfix_pose_top_half_facing_left_walljump_spacejump_screwattack:
    db $28


; Last byte should be $68, like everything else
;TM_0DA:
;DW $0004
;DB $FD, $01, $0F, $0A, $78

org $92AEE1+6
samus_bugfix_pose_bottom_half_facing_right_damage_boost:
    db $68


; Last byte should be $38, just like the other elevator poses
;TM_06F:
;DW $0001
;DB $F8, $01, $F8, $00, $30

; Note: This fix is overwritten by dmadata.asm
;org $92A12C+6
;samus_bugfix_pose_top_half_facing_forward:
;    db $38


