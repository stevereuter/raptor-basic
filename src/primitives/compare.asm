; -------------------------- byte comparison operators
equal_byte:
    lda RT_PARAM_1
    cmp RT_PARAM_2
    bne byte_false
    beq byte_true          ; forced branch (Z=1 is guaranteed here!)

not_byte:
    lda RT_PARAM_1
    bne byte_false
    beq byte_true

not_equal_byte:
    lda RT_PARAM_1
    cmp RT_PARAM_2
    beq byte_false
    bne byte_true

gt_equal_byte:             ; PARAM_1 >= PARAM_2
    lda RT_PARAM_1
    cmp RT_PARAM_2
    bcc byte_false
    bcs byte_true

lt_equal_byte:             ; PARAM_1 <= PARAM_2
    lda RT_PARAM_2
    cmp RT_PARAM_1
    bcc byte_false
    bcs byte_true

gt_byte:                   ; PARAM_1 > PARAM_2
    lda RT_PARAM_2
    cmp RT_PARAM_1
    bcs byte_false
    bcc byte_true

lt_byte:                   ; PARAM_1 < PARAM_2
    lda RT_PARAM_1
    cmp RT_PARAM_2
    bcs byte_false
    bcc byte_true

; -------------------------- shared boolean store epilogue
byte_true:
    lda #$ff
    bne +                  ; forced 2-byte branch (A is $FF, Z=0)
byte_false:
    lda #0
+
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

