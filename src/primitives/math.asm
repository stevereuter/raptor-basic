; single byte increment
inc_byte:
    lda RT_PARAM_1
    clc
    adc #1
    bcs return_max_byte
    sta (RT_RTN_REF),y
    rts

; single int increment

; single byte decrement
dec_byte:
    lda RT_PARAM_1
    sec
    sbc #1
    bcc return_min_byte
    sta (RT_RTN_REF),y
    rts

; single int increment

; add byte
add_byte:
    lda RT_PARAM_1
    clc
    adc RT_PARAM_2
    bcs return_max_byte
    sta (RT_RTN_REF),y
    rts

; add int

; subtract byte
sub_byte:
    lda RT_PARAM_1
    sec
    sbc RT_PARAM_2
    bcc return_min_byte
    sta (RT_RTN_REF),y
    rts

; subtract int
