!src "src/zero_page.asm"

; single byte increment
inc_byte:
    lda RT_PARAM_1
    clc
    adc #1
    bcs return_max_byte
    sta (RT_RTN_REF),y
    rts

!src "src/primitives/limit.asm"
