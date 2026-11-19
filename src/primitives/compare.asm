; -------------------------- compares if 2 byte values are equal
equal_byte:
    lda RT_PARAM_1
    cmp RT_PARAM_2
    bne +                  ; branch if not equal

    lda #$ff               ; return true
    sta (RT_RTN_REF),y
    rts
+
    lda #0                 ; return false
    sta (RT_RTN_REF),y
    rts

; -------------------------- compares if byte value is falsy
not_byte:
    lda RT_PARAM_1         ; get value
    bne +                  ; branch if truthy

    lda #$ff               ; true path, value is zero
    sta (RT_RTN_REF),y
    rts
+
    lda #0                 ; false path, value is not zero
    sta (RT_RTN_REF),y
    rts

; -------------------------- compares if 2 byte values are not equal
not_equal_byte:
    lda RT_PARAM_1
    cmp RT_PARAM_2
    beq +                  ; branch if not equal

    lda #$ff               ; return true
    sta (RT_RTN_REF),y
    rts
+
    lda #0                 ; return false
    sta (RT_RTN_REF),y
    rts

; -------------------------- compares if param 2 is greater than or equal param 1
gt_equal_byte:
    lda RT_PARAM_1
    cmp RT_PARAM_2
    bcs +                  ; branch if true

    lda #0                 ; return false
    sta (RT_RTN_REF),y
    rts
+
    lda #$ff               ; return true
    sta (RT_RTN_REF),y
    rts

; -------------------------- compares if param 2 is less than or equal param 1
lt_equal_byte:
    lda RT_PARAM_2
    cmp RT_PARAM_1
    bcs +                  ; branch if true

    lda #0                 ; return false
    sta (RT_RTN_REF),y
    rts
+
    lda #$ff               ; return true
    sta (RT_RTN_REF),y
    rts

; -------------------------- compares if param 2 is greater than param 1
gt_byte:
    lda RT_PARAM_2
    cmp RT_PARAM_1
    bcc +                  ; branch if true

    lda #0                 ; return false
    sta (RT_RTN_REF),y
    rts
+
    lda #$ff               ; return true
    sta (RT_RTN_REF),y
    rts

; -------------------------- compares if param 2 is less than param 1
lt_byte:
    lda RT_PARAM_1
    cmp RT_PARAM_2
    bcc +                  ; branch if less than

    lda #0                 ; return false
    sta (RT_RTN_REF),y
    rts
+
    lda #$ff               ; return true
    sta (RT_RTN_REF),y
    rts

; -------------------------- compares if 2 integer values are equal
equal_int:
    lda RT_PARAM_1
    cmp RT_PARAM_2
    bne +              ; low bytes differ -> false

    lda RT_PARAM_1 + 1
    cmp RT_PARAM_2 + 1
    bne +              ; high bytes differ -> false

    lda #$ff           ; equal -> $FFFF
    bne int_store      ; always branches (Z=0), saves 1 byte over jmp

+
    lda #0             ; not equal -> $0000

; -------------------------- compares if 2 integer values are not equal
not_equal_int:
    lda RT_PARAM_1
    cmp RT_PARAM_2
    bne +              ; low bytes differ -> true

    lda RT_PARAM_1 + 1
    cmp RT_PARAM_2 + 1
    bne +              ; high bytes differ -> true

    lda #0             ; equal, falsy
    beq int_store      ; branch to store

+
    lda #$FF           ; not equal, truthy
    bne int_store

; -------------------------- compares if integer value is falsy
not_int:
    lda RT_PARAM_1
    bne +              ; low bytes is not zero, falsy

    lda RT_PARAM_1 + 1
    bne +              ; low bytes is not zero, falsy

    lda #$ff           ; is zero
    bne int_store      ; set return

+
    lda #0             ; not zero
    ; beq int_store    ; fall through as it's below

; -------------------------- shred int store
int_store:
    sta (RT_RTN_REF),y
    iny
    sta (RT_RTN_REF),y
    dey
    rts

