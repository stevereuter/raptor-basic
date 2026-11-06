!src "src/zero_page.asm"
;
; just some simple test code using indirect indexed addressing
;

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
    lda #0
    sta RT_PARAM_1
    
    ; simulate increment function
    jsr inc_byte
+

rts

!src "src/primitives/increment.asm"
