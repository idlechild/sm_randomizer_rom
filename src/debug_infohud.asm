;
; Patches to display information on the infohud.
; Only enabled for debugging purposes.
;

!DEBUG_IH_ROOM = 0
!DEBUG_IH_SAMUS_XY = 0
!DEBUG_IH_START = 0

!DEBUG_IH = 0
if !DEBUG_IH_ROOM
!DEBUG_IH = 1
endif
if !DEBUG_IH_SAMUS_XY = 1
!DEBUG_IH = 1
endif
if !DEBUG_IH_START
!DEBUG_IH = 1
endif


if !DEBUG_IH

!HUD_TILEMAP = $7EC600
!IH_BLANK = #$2C0F
!IH_DECIMAL = #$0CCB


; In debug mode, apply GT code at the start
; Override GT code starting values
org $AAC91E
    LDA #$05DB    ; starting health

org $AAC927
    LDA #$0190    ; starting reserves

org $AAC930
    LDA #$00E6    ; starting missiles

org $AAC939
    LDA #$0032    ; starting supers/pbs

org $AAC942
    ; To avoid glitched beam we need to turn off spazer
    ; Combine Supers and PBs assignments to make room for the OR instruction
    STA $09CE
    STA $09D0
    LDA #$F32F    ; starting equipment
    STA $09A2
    STA $09A4
    LDA #$100B    ; starting beams
    STA $09A6
    ORA #$0004    ; collect spazer
warnpc $AAC95A

; The default HUD minimap should be cleared
org $8098BF
ih_default_HUD_row_0:
    dw #$2C0F, #$2C0F, #$2C0F, #$2C0F, #$2C0F, #$2C0F

org $8098FF
ih_default_HUD_row_1:
    dw #$2C0F, #$2C0F, #$2C0F, #$2C0F, #$2C0F, #$2C0F

org $80993F
ih_default_HUD_row_2:
    dw #$2C0F, #$2C0F, #$2C0F, #$2C0F, #$2C0F, #$2C0F

org $80997F
ih_default_HUD_row_3:
    dw #$2C0F, #$2C0F, #$2C0F, #$2C0F, #$2C0F, #$2C0F

org $809AF3      ; skip initializing minimap, apply GT code instead
    JSL $AAC91E

org $809B4C      ; hijack, HUD routine
    JSL ih_hud_code : NOP

org $90A7EE      ; skip marking minimap in boss rooms
    BRA $1A

org $90A91B      ; skip updating minimap
    RTL


org $80FD00
NumberGFXTable:
    dw #$0C09, #$0C00, #$0C01, #$0C02, #$0C03, #$0C04, #$0C05, #$0C06, #$0C07, #$0C08
    dw #$0C45, #$0C3C, #$0C3D, #$0C3E, #$0C3F, #$0C40, #$0C41, #$0C42, #$0C43, #$0C44
    dw #$0C11, #$0C11, #$0C11, #$0C11, #$0C11, #$0C11, #$0C11, #$0C11, #$0C11, #$0C11
    dw #$0C11, #$0C11, #$0C11, #$0C11, #$0C11, #$0C11, #$0C11, #$0C11, #$0C11, #$0C11
    dw #$0C11, #$0C11, #$0C11, #$0C11, #$0C11, #$0C11, #$0C11, #$0C11, #$0C11, #$0C11
    dw #$0C11, #$0C11, #$0C11, #$0C11, #$0C11, #$0C11, #$0C11, #$0C11, #$0C11, #$0C11
    dw #$0C11, #$0C11, #$0C11, #$0C11, #$0C11, #$0C11

warnpc $80FE00


org $DFF000
ih_hud_code:
{
    %ai16()

    ; fix data bank register
    PHB
    PEA $8080
    PLB
    PLB

if !DEBUG_IH_ROOM
    LDX #$002E : LDA !IH_BLANK : JSR DrawChar
    LDA $079B : JSR Draw4Hex : LDA !IH_BLANK : JSR DrawChar
    LDA $079F : JSR Draw1 : LDA !IH_BLANK : JSR DrawChar
    LDA $078D : JSR Draw4Hex : LDA !IH_BLANK : JSR DrawChar
    LDX #$006E : LDA !IH_BLANK : JSR DrawChar
    LDA $0911 : JSR Draw4Hex : LDA !IH_BLANK : JSR DrawChar
    LDA $0915 : JSR Draw4Hex : LDA !IH_BLANK : JSR DrawChar
    LDX #$00AE : LDA !IH_BLANK : JSR DrawChar
    LDA $0AF6 : AND #$FF00 : XBA : CLC
    ADC $07A1 : ASL #3 : JSR Draw3Hex : LDA !IH_BLANK : JSR DrawChar
    LDA $0AFA : AND #$FF00 : XBA : INC : CLC
    ADC $07A3 : ASL #3 : JSR Draw3Hex : LDA !IH_BLANK : JSR DrawChar
    LDA $0AFA : LSR #4 : INC #2 : JSR Draw2LSB
    LDA $0AF6 : LSR #3 : DEC : LSR : JSR Draw2LSB
endif

if !DEBUG_IH_SAMUS_XY
    LDX #$006E : LDA !IH_BLANK : JSR DrawChar
    LDA $0AF6 : JSR Draw4 : LDA !IH_DECIMAL : JSR DrawChar
    LDA $0AF8 : JSR Draw4Hex : LDA !IH_BLANK : JSR DrawChar
    LDX #$00AE : LDA !IH_BLANK : JSR DrawChar
    LDA $0AFA : JSR Draw4 : LDA !IH_DECIMAL : JSR DrawChar
    LDA $0AFC : JSR Draw4Hex : LDA !IH_BLANK : JSR DrawChar
endif

    PLB
    ; overwritten code
    LDA $7E09C0
    RTL
}

Draw1:
{
    ASL : TAY : LDA.w NumberGFXTable,Y
}

DrawChar:
{
    STA !HUD_TILEMAP+$00,X
    INX #2
    RTS
}

Draw2:
{
    STA $4204
    %a8()
    LDA #$0A : STA $4206   ; divide by 10
    %a16()
    PEA $0000 : PLA ; wait for CPU math
    LDA $4214 : STA $16

    ; Ones digit
    LDA $4216 : ASL : TAY : LDA.w NumberGFXTable,Y : STA !HUD_TILEMAP+$02,X

    ; Tens digit
    LDA $16 : BEQ .blanktens : ASL : TAY : LDA.w NumberGFXTable,Y : STA !HUD_TILEMAP+$00,X

  .done
    INX #4
    RTS

  .blanktens
    LDA !IH_BLANK : STA !HUD_TILEMAP+$00,X
    BRA .done
}

Draw2MSB:
{
    STA $12 : AND #$F000              ; get first digit (X000)
    XBA : LSR #3                      ; move it to last digit (000X) and shift left one
    TAY : LDA.w NumberGFXTable,Y      ; load tilemap address with 2x digit as index
    STA !HUD_TILEMAP+$00,X            ; draw digit to HUD

    LDA $12 : AND #$0F00              ; (0X00)
    XBA : ASL
    TAY : LDA.w NumberGFXTable,Y
    STA !HUD_TILEMAP+$02,X

    INX #4
    RTS
}

Draw2LSB:
{
    STA $12 : AND #$00F0              ; get first digit (00X0)
    LSR #3                            ; move it to last digit (000X) and shift left one
    TAY : LDA.w NumberGFXTable,Y      ; load tilemap address with 2x digit as index
    STA !HUD_TILEMAP+$00,X            ; draw digit to HUD

    LDA $12 : AND #$000F              ; (000X)
    ASL : TAY : LDA.w NumberGFXTable,Y
    STA !HUD_TILEMAP+$02,X

    INX #4
    RTS
}

Draw3:
{
    STA $4204
    %a8()
    LDA #$0A : STA $4206   ; divide by 10
    %a16()
    PEA $0000 : PLA ; wait for CPU math
    LDA $4214 : STA $16

    ; Ones digit
    LDA $4216 : ASL : TAY : LDA.w NumberGFXTable,Y : STA !HUD_TILEMAP+$04,X

    LDA $16 : BEQ .blanktens
    STA $4204
    %a8()
    LDA #$0A : STA $4206   ; divide by 10
    %a16()
    PEA $0000 : PLA ; wait for CPU math
    LDA $4214 : STA $14

    ; Tens digit
    LDA $4216 : ASL : TAY : LDA.w NumberGFXTable,Y : STA !HUD_TILEMAP+$02,X

    ; Hundreds digit
    LDA $14 : BEQ .blankhundreds : ASL : TAY : LDA.w NumberGFXTable,Y : STA !HUD_TILEMAP+$00,X

  .done
    INX #6
    RTS

  .blanktens
    LDA !IH_BLANK : STA !HUD_TILEMAP+$00,X : STA !HUD_TILEMAP+$02,X
    BRA .done

  .blankhundreds
    LDA !IH_BLANK : STA !HUD_TILEMAP+$00,X
    BRA .done
}

Draw3Hex:
{
    STA $12 : AND #$0F00              ; get first digit (0X00)
    XBA : ASL                         ; move it to last digit (000X) and shift left one
    TAY : LDA.w NumberGFXTable,Y      ; load tilemap address with 2x digit as index
    STA !HUD_TILEMAP+$00,X            ; draw digit to HUD

    LDA $12 : AND #$00F0              ; (00X0)
    LSR #3 : TAY : LDA.w NumberGFXTable,Y
    STA !HUD_TILEMAP+$02,X

    LDA $12 : AND #$000F              ; (000X)
    ASL : TAY : LDA.w NumberGFXTable,Y
    STA !HUD_TILEMAP+$04,X

    INX #6
    RTS
}

Draw4:
{
    STA $4204
    %a8()
    LDA #$0A : STA $4206   ; divide by 10
    %a16()
    PEA $0000 : PLA ; wait for CPU math
    LDA $4214 : STA $16

    ; Ones digit
    LDA $4216 : ASL : TAY : LDA.w NumberGFXTable,Y : STA !HUD_TILEMAP+$06,X

    LDA $16 : BEQ .blanktens
    STA $4204
    %a8()
    LDA #$0A : STA $4206   ; divide by 10
    %a16()
    PEA $0000 : PLA ; wait for CPU math
    LDA $4214 : STA $14

    ; Tens digit
    LDA $4216 : ASL : TAY : LDA.w NumberGFXTable,Y : STA !HUD_TILEMAP+$04,X

    LDA $14 : BEQ .blankhundreds
    STA $4204
    %a8()
    LDA #$0A : STA $4206   ; divide by 10
    %a16()
    PEA $0000 : PLA ; wait for CPU math
    LDA $4214 : STA $12

    ; Hundreds digit
    LDA $4216 : ASL : TAY : LDA.w NumberGFXTable,Y : STA !HUD_TILEMAP+$02,X

    ; Thousands digit
    LDA $12 : BEQ .blankthousands : ASL : TAY : LDA.w NumberGFXTable,Y : STA !HUD_TILEMAP+$00,X

  .done
    INX #8
    RTS

  .blanktens
    LDA !IH_BLANK : STA !HUD_TILEMAP+$00,X : STA !HUD_TILEMAP+$02,X : STA !HUD_TILEMAP+$04,X
    BRA .done

  .blankhundreds
    LDA !IH_BLANK : STA !HUD_TILEMAP+$00,X : STA !HUD_TILEMAP+$02,X
    BRA .done

  .blankthousands
    LDA !IH_BLANK : STA !HUD_TILEMAP+$00,X
    BRA .done
}

Draw4Hex:
{
    STA $12 : AND #$F000              ; get first digit (X000)
    XBA : LSR #3                      ; move it to last digit (000X) and shift left one
    TAY : LDA.w NumberGFXTable,Y      ; load tilemap address with 2x digit as index
    STA !HUD_TILEMAP+$00,X            ; draw digit to HUD

    LDA $12 : AND #$0F00              ; (0X00)
    XBA : ASL
    TAY : LDA.w NumberGFXTable,Y
    STA !HUD_TILEMAP+$02,X

    LDA $12 : AND #$00F0              ; (00X0)
    LSR #3 : TAY : LDA.w NumberGFXTable,Y
    STA !HUD_TILEMAP+$04,X

    LDA $12 : AND #$000F              ; (000X)
    ASL : TAY : LDA.w NumberGFXTable,Y
    STA !HUD_TILEMAP+$06,X

    INX #8
    RTS
}

Draw4Hundredths:
{
    STA $4204
    %a8()
    LDA #$0A : STA $4206   ; divide by 10
    %a16()
    PEA $0000 : PLA

    ; Ones digit ignored, go straight to tens digit
    LDA $4214 : BEQ .zerotens
    STA $4204
    %a8()
    LDA #$0A : STA $4206   ; divide by 10
    %a16()
    PEA $0000 : PLA ; wait for CPU math
    LDA $4214 : STA $14

    ; Tens digit
    LDA $4216 : ASL : TAY : LDA.w NumberGFXTable,Y : STA !HUD_TILEMAP+$06,X

    LDA $14 : BEQ .zerohundreds
    STA $4204
    %a8()
    LDA #$0A : STA $4206   ; divide by 10
    %a16()
    PEA $0000 : PLA ; wait for CPU math
    LDA $4214 : STA $12

    ; Hundreds digit
    LDA $4216 : ASL : TAY : LDA.w NumberGFXTable,Y : STA !HUD_TILEMAP+$04,X

    ; Thousands digit
    LDA $12 : ASL : TAY : LDA.w NumberGFXTable,Y : STA !HUD_TILEMAP+$00,X

  .done
    LDA !IH_DECIMAL : STA !HUD_TILEMAP+$02,X
    INX #8
    RTS

  .zerotens
    LDA #$0C09 : STA !HUD_TILEMAP+$00,X : STA !HUD_TILEMAP+$04,X : STA !HUD_TILEMAP+$06,X
    BRA .done

  .zerohundreds
    LDA #$0C09 : STA !HUD_TILEMAP+$00,X : STA !HUD_TILEMAP+$04,X
    BRA .done
}

endif

