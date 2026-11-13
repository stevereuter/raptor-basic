; set byte
assign_byte:
    lda RT_PARAM_1
    sta (RT_RTN_REF),y
rts

; set int
assign_int:
    lda RT_PARAM_1
    sta (RT_RTN_REF),y
    lda RT_PARAM_1 + 1
    ldy #1
    sta (RT_RTN_REF),y
    ldy #0
rts

; ternary byte
assign_byte_ternary:
    lda RT_PARAM_1  ; comparison
    beq +               ; if zero jump
                        ; true path
    lda RT_PARAM_2
    sta (RT_RTN_REF),y  ; return param 2
    rts
+                       ; false path
    lda RT_PARAM_3
    sta (RT_RTN_REF),y  ; return param 3
    rts

; strings
assign_string:
    ldy #1
    lda (RT_PARAM_1),y      ; get the length of the incoming string
    tax                     ; store it in x for the loop

    ldy #2
    lda (RT_RTN_REF),y      ; get the size of the variable
    sta RT_TEMP             ; store it in temp
    cpx RT_TEMP             ; compare to x

    bcc +                   ; incoming length (param 2) is less than the size (x), use length
    ldx RT_TEMP             ; use the variable size
+
    ldy #1
    txa
    sta (RT_RTN_REF),y      ; set the new length
    beq .string_assign_done ; exit early for zero length, this is based on txa

    ldy #3                  ; data start

.assign_string_loop:
    lda (RT_PARAM_1),y
    sta (RT_RTN_REF),y
    iny
    dex
    bne .assign_string_loop

.string_assign_done:
    ldy #0
    rts
