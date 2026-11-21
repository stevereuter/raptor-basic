; -------------------------- STR(byte) convert byte to string
byte_to_string:
    ldx #0                  ; for counting each step
    ldy #1                  ; get the size
    lda (RT_RTN_REF),y
    ldy #2                  ; set y to the data
    sta RT_TEMP + 1         ; save the size
    lda RT_PARAM_1          ; load the value
-                           ; count 100s
    sec
    sbc #100              ; subtract 100
    bcc +                   ; jump out if negative

    inx                     ; increment 100 counter
    jmp -                   ; repeat
+
    adc #100              ; get back to positive
    sta RT_TEMP             ; hold the remainder

    lda RT_TEMP + 1         ; get the size
    cmp #3                  ; check if less than 3
    bcc +                   ; skip 100s

    txa                     ; load the 100s count
    beq +                   ; skip if zero
    clc
    adc #48                 ; convert to PETSCII
    sta (RT_RTN_REF),y      ; store the 100s
    iny                     ; increment pointer
+
    lda RT_TEMP             ; restore the remainder
    ldx #0                  ; reset counter
-                           ; count 10s
    sec
    sbc #10                 ; subtract 10
    bcc +                   ; jump if negative

    inx                     ; increment 10 count
    jmp -                   ; repeat
+
    adc #10                 ; get back to positive
    sta RT_TEMP             ; hold the remainder 1s

    lda RT_TEMP + 1         ; get the size
    cmp #2                  ; check if less than 2
    bcc +                   ; skip 10s

    txa                     ; transfer the 10s
    bne .write_10s          ; write 10s if not zero
    cpy #2                  ; check if there were no 100s
    beq +                   ; prevent leading zero
.write_10s:
    clc
    adc #48                 ; convert to PETSCII
    sta (RT_RTN_REF),y      ; store the 10s
    iny                     ; increment pointer
+
    ; store the 1s
    lda RT_TEMP             ; restore the remainder
    adc #48                 ; convert to PETSCII
    sta (RT_RTN_REF),y      ; store it
    tya                     ; get the pointer offset
    sec
    sbc #1                  ; convert it to length
    ldy #0
    sta (RT_RTN_REF),y      ; store the length
    rts
