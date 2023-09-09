
; Config flags (multiworld, area rando, etc.)
org $CEFF00
config_flags:

config_multiworld: ; $CEFF00
    dw $0000

config_sprite: ; $CEFF02
    dw $0000
    dw $0000

config_keysanity: ; $CEFF06
    dw $0000

config_arearando: ; $CEFF08
if !DEBUG_IH_START
    dw $0001
else
    dw $0000
endif


; Custom sprite engine flags
org $B4F500
config_screwattack: ; $B4F500
    dw #$0000
