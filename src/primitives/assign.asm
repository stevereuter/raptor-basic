; -------------------------- set byte reference value
assign_byte:
    lda RT_PARAM_1
    sta (RT_RTN_REF),y
    rts

; -------------------------- set integer reference value
assign_int:
    lda RT_PARAM_1      ; low byte
    sta (RT_RTN_REF),y
    lda RT_PARAM_1 + 1  ; high byte
    ldy #1
    sta (RT_RTN_REF),y
    ldy #0
    rts

; -------------------------- ternary byte
assign_byte_ternary:
    lda RT_PARAM_1          ; comparison param 1
    beq +                   ; if zero branch
                  
    lda RT_PARAM_2          ; true path
    sta (RT_RTN_REF),y      ; return param 2
    rts
+                 
    lda RT_PARAM_3          ; false path
    sta (RT_RTN_REF),y      ; return param 3
    rts

; -------------------------- strings
assign_string:
    lda (RT_PARAM_1),y      ; get the length of the incoming string
    tax                     ; store it in x for the loop

    ldy #1
    lda (RT_RTN_REF),y      ; get the size of the variable
    sta RT_TEMP             ; store it in temp
    cpx RT_TEMP             ; compare to x

    bcc +                   ; if the incoming length (param 2) is less than the size (x), use length
    ldx RT_TEMP             ; use the variable size
+
    ldy #0
    txa
    sta (RT_RTN_REF),y      ; set the new length
    beq .string_assign_done ; exit early for zero length, this is based on txa

    ldy #2                  ; data start

.assign_string_loop:
    lda (RT_PARAM_1),y      ; get the param char
    sta (RT_RTN_REF),y      ; store it to the ref
    iny
    dex
    bne .assign_string_loop

.string_assign_done:
    ldy #0
    rts

; -------------------------- assign byte array (partial copy)
; Memory layout at pointers:
;   +0: size low byte
;   +1: size high byte
;   +2: data[0] ...
; Inputs:
;   RT_RTN_REF = pointer to target size
;   RT_PARAM_1 = pointer to source size
;   Y = 0
; Exit:
;   Y = 0

assign_byte_array:
    ; --- 1. Determine min(dest_size, src_size) -> store in RT_TEMP ---
    ldy #1
    lda (RT_RTN_REF),y      ; target size high byte
    cmp (RT_PARAM_1),y      ; compare with source size high byte
    bcc .use_dest           ; target_hi < src_hi -> target is smaller
    bne .use_src            ; target_hi > src_hi -> source is smaller

    ; High bytes are equal, compare low bytes
    dey                     ; Y = 0
    lda (RT_RTN_REF),y      ; target size low byte
    cmp (RT_PARAM_1),y      ; compare with source size low byte
    bcc .use_dest_lo        ; target_lo < src_lo -> target is smaller

.use_src:
    ldy #0
    lda (RT_PARAM_1),y
    sta RT_TEMP
    iny                     ; Y = 1
    lda (RT_PARAM_1),y
    sta RT_TEMP + 1
    jmp .advance_pointers

.use_dest:
    dey                     ; Y = 0
    lda (RT_RTN_REF),y
.use_dest_lo:
    sta RT_TEMP
    iny                     ; Y = 1
    lda (RT_RTN_REF),y
    sta RT_TEMP + 1

    ; --- 2. Advance RT_RTN_REF and RT_PARAM_1 by +2 past size header ---
.advance_pointers:
    clc
    lda RT_RTN_REF
    adc #2
    sta RT_RTN_REF
    bcc +
    inc RT_RTN_REF + 1
+
    clc
    lda RT_PARAM_1
    adc #2
    sta RT_PARAM_1
    bcc +
    inc RT_PARAM_1 + 1
+
    ; --- 3. Two-phase 16-bit block copy using RT_TEMP ---
    ldy #0
    ldx RT_TEMP + 1         ; X = full 256-byte pages
    beq .copy_remainder

.page_loop:
    lda (RT_PARAM_1),y
    sta (RT_RTN_REF),y
    iny
    bne .page_loop

    inc RT_PARAM_1 + 1
    inc RT_RTN_REF + 1
    dex
    bne .page_loop

.copy_remainder:
    ldx RT_TEMP             ; X = remaining bytes (< 256)
    beq .done

.rem_loop:
    lda (RT_PARAM_1),y
    sta (RT_RTN_REF),y
    iny
    dex
    bne .rem_loop

    ldy #0                  ; restore Y = 0 invariant
.done:
    rts
