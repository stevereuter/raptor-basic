!src "src/zero_page.asm"

*=$0801
!byte $0c,$08,$b5,$07,$9e,$20,$32,$30,$36,$32,$00,$00,$00


jmp main

main
    ; simulate setup
    ; target
    lda #$f4            ; low byte
    sta RT_RTN_REF
    lda #$05            ; high byte
    sta RT_RTN_REF + 1

    ldy #0
    lda #$f2
    sta (RT_RTN_REF),y

    ldy #1
    lda #01        
    sta (RT_RTN_REF),y

    ; last postion
    lda #$51            ; solid ball character
    sta $05f3           ; 498th data byte of source ($0402 + 497)

    ; source
    lda #0            ; low byte
    sta RT_PARAM_1
    lda #4            ; high byte
    sta RT_PARAM_1 + 1

    ldy #0
    lda #$F2
    sta (RT_PARAM_1),y

    ldy #1
    lda #01         
    sta (RT_PARAM_1),y

    ldy #0
    jsr assign_byte_array

rts
; core subroutines
!src "src/primitives/assign.asm"
!src "src/primitives/math.asm"
!src "src/primitives/compare.asm"
!src "src/subroutines/print.asm"
