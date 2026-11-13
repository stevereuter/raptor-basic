; single byte increment
inc_byte:
    lda (RT_RTN_REF),y
    clc
    adc #1
    bcs +
    ; happy path
    sta (RT_RTN_REF),y
    rts
+
    ; overflow limit
    lda #$ff
    sta (RT_RTN_REF),y
    rts
; single int increment

; single byte decrement
dec_byte:
    lda (RT_RTN_REF),y
    sec
    sbc #1
    bcc +
    ; happy path
    sta (RT_RTN_REF),y
    rts
+
    ; overflow limit
    lda #0
    sta (RT_RTN_REF),y
    rts

; single int increment

; add byte
add_byte:
    lda (RT_RTN_REF),y
    clc
    adc RT_PARAM_1
    bcs +
    ; happy path
    sta (RT_RTN_REF),y
    rts
+
    ; overflow limit
    lda #$ff
    sta (RT_RTN_REF),y
    rts
; add int

; subtract byte
sub_byte:
    lda (RT_RTN_REF),y
    sec
    sbc RT_PARAM_1
    bcc +
    ; happy path
    sta (RT_RTN_REF),y
    rts
+
    ; overflow limit
    lda #0
    sta (RT_RTN_REF),y
    rts

; subtract int
