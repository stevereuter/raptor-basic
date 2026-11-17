; -------------------------- single byte increment
inc_byte:
    lda (RT_RTN_REF),y      ; load the target value
    clc
    adc #1
    bcc +                   ; jump to write if valid
    
    lda #$ff                ; if we're here, the value overflowed, set it to the max
+
    sta (RT_RTN_REF),y      ; write the value to the variable
    rts

; -------------------------- single int increment
inc_int:
    lda (RT_RTN_REF),y      ; load the target low byte
    clc
    adc #1
    sta (RT_RTN_REF),y      ; write the low byte
    
    bcc .inc_int_end        ; no carry, jump to the end as we don't need to update the high byte
    
    ldy #1
    lda (RT_RTN_REF),y      ; load the target high byte
    clc
    adc #1

    bcc +                   ; no carry, jump to the end

    lda #$ff                ; if we're here, the value overflowed, set it to the max $FFFF
    sta (RT_RTN_REF),y      ; high byte
    ldy #0
    sta (RT_RTN_REF),y      ; low byte
    rts
+
    sta (RT_RTN_REF),y      ; high byte happy path
    ldy #0
.inc_int_end:
    rts

; -------------------------- single byte decrement
dec_byte:
    lda (RT_RTN_REF),y
    sec
    sbc #1
    bcc +                   ; branch if overflow
    
    sta (RT_RTN_REF),y      ; happy path
    rts
+
    lda #0                  ; overflow limit, return min
    sta (RT_RTN_REF),y
    rts

; -------------------------- single int increment

; -------------------------- add byte
add_byte:
    lda (RT_RTN_REF),y
    clc
    adc RT_PARAM_1
    bcs +                   ; branch if overflow
    
    sta (RT_RTN_REF),y      ; happy path
    rts
+
    lda #$ff                ; overflow limit, return max
    sta (RT_RTN_REF),y
    rts
; -------------------------- add int

; -------------------------- subtract byte
sub_byte:
    lda (RT_RTN_REF),y
    sec
    sbc RT_PARAM_1
    bcc +                   ; branch on overflow
    
    sta (RT_RTN_REF),y      ; happy path
    rts
+
    lda #0                  ; overflow limit, return min
    sta (RT_RTN_REF),y
    rts

; -------------------------- subtract int
