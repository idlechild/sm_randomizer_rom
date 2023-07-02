lorom

macro a8()
    sep #$20
endmacro

macro a16()
    rep #$20
endmacro

macro i8()
    rep #$10
endmacro

macro ai8()
    sep #$30
endmacro

macro ai16()
    rep #$30
endmacro

macro i16()
    rep #$10
endmacro

org $80ffc0
game_header_name:
    ;   0              f01234
    db "      SM RANDOMIZER  "
warnpc $80ffd5

org $80ffd8
game_header_sram_size:
    db $04

org $808000                ; Disable copy protection screen
disable_copy_protection:
    db $ff

; Debug infohud patch, only used if IH_DEBUG is defined
incsrc debug_infohud.asm

; Config flags
incsrc config.asm

; Super Metroid custom Samus sprite "engine" by Artheau
incsrc sprite/sprite.asm

; These patches include their own origins and patch locations
incsrc randopatches/credits.asm
incsrc randopatches/introskip.asm
incsrc randopatches/layout.asm
incsrc randopatches/max_ammo.asm
incsrc randopatches/misc.asm
incsrc randopatches/nofanfare.asm
incsrc randopatches/seed_display.asm
incsrc randopatches/tracking.asm

; Start anywhere patch, must precede plminject.asm
incsrc startanywhere.asm

incsrc keycards.asm
incsrc items.asm
incsrc map_icons.asm
incsrc plminject.asm

; Add code to the main code bank
org $b88000
incsrc common.asm
incsrc multiworld.asm
incsrc randolive.asm
warnpc $b8cf00

org $b8cf00
incsrc seeddata.asm
warnpc $b8d000

org $b8d000
incsrc playertable.asm
warnpc $b8e000

org $b8e000
incsrc itemtable.asm

; Level data contained in separate ips patches
org $c3bd6d
level_data_moat_ips:

org $c59755
level_data_early_super_bridge_ips:

org $c684ee
level_data_red_tower_ips:

org $c6b91c
level_data_spazer_ips:

org $c6ecc9
level_data_nova_boost_platform_ips:

org $c7aa70
level_data_high_jump_ips:

