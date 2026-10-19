;
; just some simple test code using indirect indexed addressing
;

*=$0801
!byte $0c,$08,$b5,$07,$9e,$20,$32,$30,$36,$32,$00,$00,$00
jmp main



main
    ; simulate setup
    ldy #0
    lda #0
    sta $03
    lda #04
    sta $04
    
    ; simulate increment function
    lda #0
    sta ($03),y
    lda ($03),y
    clc
    adc #1
    sta ($03),y

+
    rts
