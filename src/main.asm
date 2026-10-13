;
; Example
;

*=$0801
!byte $0c,$08,$b5,$07,$9e,$20,$32,$30,$36,$32,$00,$00,$00
jmp main

.hellotext
    !scr "hello, raptor basic!",0
    !set ofs = 10

main
    ldy #0

hello
    lda .hellotext,y
    beq +
    sta $400+ofs,y
    lda #5
    sta $d800+ofs,y
    iny
    jmp hello
+
    rts
