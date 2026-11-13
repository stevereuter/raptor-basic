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

    lda #31              ; comparison
    sta RT_PARAM_1

    ; lda #31             ; truthy value
    ; sta RT_PARAM_2

    ; lda #0             ; falsy value
    ; sta RT_PARAM_3

    jsr print_byte

; core subroutines
!src "src/primitives/assign.asm"
!src "src/primitives/math.asm"
!src "src/primitives/compare.asm"
!src "src/subroutines/print.asm"
