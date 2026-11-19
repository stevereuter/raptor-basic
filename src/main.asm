!src "src/zero_page.asm"

*=$0801
!byte $0c,$08,$b5,$07,$9e,$20,$32,$30,$36,$32,$00,$00,$00


jmp main

main
    ; simulate setup
    ; target
    lda #0            ; low byte
    sta RT_RTN_REF
    lda #4            ; high byte
    sta RT_RTN_REF + 1

    lda #0
    sta RT_PARAM_1
    sta RT_PARAM_1 + 1

    jsr not_int

rts
; core subroutines
!src "src/primitives/assign.asm"
!src "src/primitives/math.asm"
!src "src/primitives/compare.asm"
!src "src/subroutines/print.asm"
