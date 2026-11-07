; return max byte
return_max_byte:
    lda #$ff
    sta (RT_RTN_REF),y
    rts

; return max int

; return min byte
return_min_byte:
    lda #0
    sta (RT_RTN_REF),y
    rts

; return min int
