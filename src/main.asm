!src "src/zero_page.asm"

*=$0801
!byte $0c,$08,$b5,$07,$9e,$20,$32,$30,$36,$32,$00,$00,$00


jmp main

main
    ; simulate setup
    ; set the return pointer
    ldy #0
    lda #0
    sta RT_RTN_REF
    lda #04
    sta RT_RTN_REF + 1
    ; set the parameter value
    lda #5
    sta RT_PARAM_1
    lda #5
    sta RT_PARAM_2
    
    ; simulate increment function
    jsr not_equal_byte

rts

; shared subroutines
!src "src/primitives/limit.asm"

; core subroutines
!src "src/primitives/assign.asm"
!src "src/primitives/math.asm"
!src "src/primitives/compare.asm"
