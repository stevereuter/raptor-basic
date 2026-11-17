!src "src/zero_page.asm"

*=$0801
!byte $0c,$08,$b5,$07,$9e,$20,$32,$30,$36,$32,$00,$00,$00


jmp main

main
    ; simulate setup
    lda #0              ; return reg
    sta RT_RTN_REF
    lda #4
    sta RT_RTN_REF + 1

    ldy #0
    lda #$FF
    sta (RT_RTN_REF),y

    ldy #1
    lda #$FF          
    sta (RT_RTN_REF),y

    ; lda #0             ; falsy value
    ; sta RT_PARAM_3

    ldy #0
    jsr inc_int
    rts
; core subroutines
!src "src/primitives/assign.asm"
!src "src/primitives/math.asm"
!src "src/primitives/compare.asm"
!src "src/subroutines/print.asm"
