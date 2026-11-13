CHROUT = $ffd2

; print strings
print_string:
    ; var ref: type, length, size, ...data (x size)
    ; load the string ref from param 1, this would be the type
    ldy #1                  ; offset to get the string length, ref + 1
    lda (RT_PARAM_1),y      ; get the string length
    beq .print_done                   ; quit if length is zero
    tax                     ; move the length to x for the loop
    ldy #3                  ; move to the data register, ref + 3

.print_loop:
    lda (RT_PARAM_1),y      ; Grab current character byte using Y data offset
    jsr CHROUT              ; Call KERNEL CHROUT
    iny                     ; Advance Y to the next character in the string buffer
    dex                     ; Decrement our length counter in X
    bne .print_loop         ; Loop until X reaches 0

.print_done:
    ldy #0
    rts


; print numbers
print_byte:
    lda RT_PARAM_1
    jsr CHROUT
    rts
