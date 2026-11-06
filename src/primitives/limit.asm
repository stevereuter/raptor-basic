
; return max byte
return_max_byte:
    lda #$ff
    sta (RT_RTN_REF),y
    rts
