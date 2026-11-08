; equal byte
equal_byte:
    lda RT_PARAM_1
    cmp RT_PARAM_2
    bne +
    ; true path
    lda #$ff
    sta (RT_RTN_REF),y
    rts
+
    ; false path
    lda #0
    sta (RT_RTN_REF),y
    rts

; equal int

; not byte
not_byte:
    lda RT_PARAM_1
    cmp #0
    bne +
    ; true path
    lda #$ff
    sta (RT_RTN_REF),y
    rts
+
    ; false path
    lda #0
    sta (RT_RTN_REF),y
    rts

; not int

; not equal byte
not_equal_byte:
    lda RT_PARAM_1
    cmp RT_PARAM_2
    beq +
    ; true path
    lda #$ff
    sta (RT_RTN_REF),y
    rts
+
    ; false path
    lda #0
    sta (RT_RTN_REF),y
    rts

; not equal int

; greater than or equal to
gt_equal_byte:
    lda RT_PARAM_1
    cmp RT_PARAM_2
    bcs +
    ; false path
    lda #0
    sta (RT_RTN_REF),y
    rts
+
    ; true path
    lda #$ff
    sta (RT_RTN_REF),y
    rts

; less than or equal to
lt_equal_byte:
    lda RT_PARAM_2
    cmp RT_PARAM_1
    bcs +
    ; false path
    lda #0
    sta (RT_RTN_REF),y
    rts
+
    ; true path
    lda #$ff
    sta (RT_RTN_REF),y
    rts

; greater than
gt_byte:
    lda RT_PARAM_2
    cmp RT_PARAM_1
    bcc +    ; branch on less than
    ; false path
    lda #0
    sta (RT_RTN_REF),y
    rts
+
    ; true path
    lda #$ff
    sta (RT_RTN_REF),y
    rts

; less than
lt_byte:
    lda RT_PARAM_1
    cmp RT_PARAM_2
    bcc +
    ; false path
    lda #0
    sta (RT_RTN_REF),y
    rts
+
    ; true path
    lda #$ff
    sta (RT_RTN_REF),y
    rts
