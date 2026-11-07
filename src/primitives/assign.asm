; set byte
set_byte:
    lda RT_PARAM_1
    sta (RT_RTN_REF),y
    rts

; set int
set_int:
    lda RT_PARAM_1
    sta (RT_RTN_REF),y
    lda RT_PARAM_1 + 1
    ldy #1
    sta (RT_RTN_REF),y
    ldy #0
    rts
