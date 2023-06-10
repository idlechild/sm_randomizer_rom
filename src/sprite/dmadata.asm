
org $92D91E
samus_spritemaps_prim_table:
incbin "data/_main_dma_prim_table.bin" -> $92D91E

org $92D600
samus_spritemaps_sec_lower_table:
incbin "data/_main_dma_sec_lower_table.bin" -> $92D600

org $92C580
samus_spritemaps_sec_upper_table:
incbin "data/_main_dma_sec_upper_table.bin" -> $92C580

org $92D94E
samus_spritemaps_afp_prim_table:
incbin "data/_main_dma_afp_prim_table.bin" -> $92D94E

org $92B800
samus_spritemaps_afp_sec_table_B800:
incbin "data/_main_dma_afp_sec_table_B800.bin" -> $92B800

org $92DB48
samus_spritemaps_afp_sec_table_DB48:
incbin "data/_main_dma_afp_sec_table_DB48.bin" -> $92DB48

org $929263
samus_spritemaps_prim_upper_table:
incbin "data/_main_dma_tilemap_prim_upper_table_at_00.bin" -> $929263+(2*$00)
incbin "data/_main_dma_tilemap_prim_upper_table_at_0F.bin" -> $929263+(2*$0F)
incbin "data/_main_dma_tilemap_prim_upper_table_at_25.bin" -> $929263+(2*$25)
incbin "data/_main_dma_tilemap_prim_upper_table_at_35.bin" -> $929263+(2*$35)
incbin "data/_main_dma_tilemap_prim_upper_table_at_3B.bin" -> $929263+(2*$3B)
incbin "data/_main_dma_tilemap_prim_upper_table_at_41.bin" -> $929263+(2*$41)
incbin "data/_main_dma_tilemap_prim_upper_table_at_43.bin" -> $929263+(2*$43)
incbin "data/_main_dma_tilemap_prim_upper_table_at_49.bin" -> $929263+(2*$49)
incbin "data/_main_dma_tilemap_prim_upper_table_at_67.bin" -> $929263+(2*$67)
incbin "data/_main_dma_tilemap_prim_upper_table_at_B2.bin" -> $929263+(2*$B2)
incbin "data/_main_dma_tilemap_prim_upper_table_at_C7.bin" -> $929263+(2*$C7)
incbin "data/_main_dma_tilemap_prim_upper_table_at_E0.bin" -> $929263+(2*$E0)

org $92945D
samus_spritemaps_prim_lower_table:
incbin "data/_main_dma_tilemap_prim_lower_table_at_00.bin" -> $92945D+(2*$00)
incbin "data/_main_dma_tilemap_prim_lower_table_at_0F.bin" -> $92945D+(2*$0F)
incbin "data/_main_dma_tilemap_prim_lower_table_at_25.bin" -> $92945D+(2*$25)
incbin "data/_main_dma_tilemap_prim_lower_table_at_35.bin" -> $92945D+(2*$35)
incbin "data/_main_dma_tilemap_prim_lower_table_at_3B.bin" -> $92945D+(2*$3B)
incbin "data/_main_dma_tilemap_prim_lower_table_at_41.bin" -> $92945D+(2*$41)
incbin "data/_main_dma_tilemap_prim_lower_table_at_43.bin" -> $92945D+(2*$43)
incbin "data/_main_dma_tilemap_prim_lower_table_at_49.bin" -> $92945D+(2*$49)
incbin "data/_main_dma_tilemap_prim_lower_table_at_67.bin" -> $92945D+(2*$67)
incbin "data/_main_dma_tilemap_prim_lower_table_at_B2.bin" -> $92945D+(2*$B2)
incbin "data/_main_dma_tilemap_prim_lower_table_at_C7.bin" -> $92945D+(2*$C7)
incbin "data/_main_dma_tilemap_prim_lower_table_at_E0.bin" -> $92945D+(2*$E0)

org $928091
samus_spritemaps_sec_table_8091:
incbin "data/_main_dma_tilemap_sec_table_8091.bin" -> $928091

org $9283C1
samus_spritemaps_sec_table_83C1:
incbin "data/_main_dma_tilemap_sec_table_83C1.bin" -> $9283C1

org $9283E7
samus_spritemaps_sec_table_83E7:
incbin "data/_main_dma_tilemap_sec_table_83E7.bin" -> $9283E7

org $928A0D
samus_spritemaps_sec_table_8A0D:
incbin "data/_main_dma_tilemap_sec_table_8A0D.bin" -> $928A0D

org $929663
samus_spritemaps:
incbin "data/_main_dma_tilemaps.bin" -> $929663

org $92EDD0
samus_spritemaps_death_prim_table:
incbin "data/_death_dma_prim_table.bin":0-2 -> $92EDDB
incbin "data/_death_dma_prim_table.bin":2-0 -> $92EDD0

org $92B001
samus_spritemaps_death_sec_table:
incbin "data/_death_dma_sec_table.bin" -> $92B001

