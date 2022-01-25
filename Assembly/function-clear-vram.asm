.include "x16.inc"
.include "vera.inc"

.org $0400
.segment "STARTUP"
.segment "INIT"
.segment "ONCE"
.segment "CODE"

jmp start

;FOR X=0 TO 10240: REM CLEAR MAP DATA
;VPOKE $0,$4000+(X*2),$20: VPOKE $0,$4000+(X*2)+1,$00
;NEXT X

;Configure VERA dataport to start at address $4000 with auto increament by 1

start: 

configure_vera:
	lda #$00
	sta VERA_ADDR_LOW
	lda #$40
	sta VERA_ADDR_MID
	lda #%00010000
	sta VERA_ADDR_HIGH

fill_vram:
	; set our counter to 10240
	ldx #$28
	ldy #$00
@write:
	jsr write_data
	dey
	bne @write
@update_counter: 
	ldy #$ff
	dex
	bne @write
@exit:
	jmp end

write_data:
	lda #$00
	sta VERA_DATA0
	lda #$00
	sta VERA_DATA0
	rts
	
end:
	