CHROUT = $ffd2              ; KERNEL CHROUT register

; -------------------------- prints the contents of a string, PETSCII array
print_string:
    lda (RT_PARAM_1),y      ; get the string length, first variable reference byte
    beq .print_done         ; quit if length is zero

    tax                     ; move the length to x for the loop
    ldy #3                  ; move to the data register, ref + 3

.print_loop:
    lda (RT_PARAM_1),y      ; Grab current character byte using Y data offset
    jsr CHROUT              ; Call KERNEL CHROUT
    iny                     ; Advance Y to the next character in the string buffer
    dex                     ; Decrement our length counter in X
    bne .print_loop         ; Loop until X reaches 0

.print_done:
    ldy #0                  ; reset y register
    rts

; -------------------------- prints a single character from a byte, PETSCII
print_char:
    lda RT_PARAM_1          ; expects a byte value to be passed
    jsr CHROUT              ; Call KERNEL CHROUT
    rts

; -------------------------- prints a single byte value as a string
print_byte:
    ldx #0
    lda RT_PARAM_1
    ; process 100s
-
    sec
    sbc #100
    bcc .write_100s
    inx
    jmp -

.write_100s:
    adc #100
    sta RT_TEMP
    txa
    beq +
    clc
    adc #$30
    jsr CHROUT
+
    lda RT_TEMP
    ldx #0
    ; process 10s
-
    sec
    sbc #10
    bcc .write_10s
    inx
    jmp -

.write_10s:
    adc #10
    sta RT_TEMP
    txa
    bne +
                    ; check if we need to skip the zero
    lda RT_PARAM_1
    cmp #100
    bcc .write_1s
+
    txa
    clc
    adc #$30
    jsr CHROUT
.write_1s:
    lda RT_TEMP
    clc
    adc #$30
    jsr CHROUT
    rts
