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

; -------------------------- prints a single byte, PETSCII
print_byte:
    lda RT_PARAM_1          ; expects a byte value to be passed
    jsr CHROUT              ; Call KERNEL CHROUT
    rts
