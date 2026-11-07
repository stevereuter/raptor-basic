; equal byte
equal_byte:
    lda RT_PARAM_1
    cmp RT_PARAM_2
    bne return_min_byte
    lda #$ff
    sta (RT_RTN_REF),y
    rts

; equal int

; not byte
not_byte:
    lda RT_PARAM_1
    cmp #0
    bne return_min_byte
    lda #$ff
    sta (RT_RTN_REF),y
    rts

; not int

; not equal byte
not_equal_byte:
    lda RT_PARAM_1
    cmp RT_PARAM_2
    beq return_min_byte
    lda #$ff
    sta (RT_RTN_REF),y
    rts

; not equal int
