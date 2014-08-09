****************************************
*              V I D E O               *
*   Aujourd'hui j'ai fait joujou avec  *
*  $E7E7, et c'est follement amusant.  *
*                                      *
*  Un tube qui déforme l'écran là où   *
* il passe ? (Joystick0) It's ovcourse *
* another cool trick from Doctor Lô !  *
****************************************

       ORG    $9000
RGB    EQU    $100

G      ORCC   #80
       PSHS   DP
       LDA    #$E7
       TFR    A,DP

       LDA    #32
       BITA   <$E7
       BEQ    *-2
       BITA   <$E7
       BNE    *-2
       PSHS   A
       MUL
       MUL
       MUL
       MUL
       PULS   A
       BITA   <$E7
       BEQ    *-10
       MUL
       MUL
       MUL
       MUL
       MUL
       TST    <$E7
       BPL    *-7
       MUL
       MUL
       MUL
       MUL
       MUL
       TST    <$E7
       BMI    *-7
       LDX    #1598
       LEAX   -1,X
       BNE    *-2

       LDB    #$5C    France
       LDA    #$7C    Export

GOON   STA    <$E7

       LDX    #12
LIGHT  CLRA           2
       STA    <$DB    4
       LDD    #RGB    3
       STB    <$DA    4
       STA    <$DA    4
       ADDD   #RGB    4
       STD    LIGHT+4 6
       MUL            11
       MUL            11
       LDA    1,X     5
       LDA    #$5C    2
       LEAX   -1,X    5
       BNE    LIGHT   3

       STA    <$E7
       MUL
       MUL
       MUL
       MUL
       MUL
       NOP
       LDX    #11
DARK   CLRA           2
       STA    <$DB    4
       LDD    #10*RGB 3
       STB    <$DA    4
       STA    <$DA    4
       SUBD   #RGB    4
       STD    DARK+4  6
       MUL            11
       MUL            11
       LDA    1,X     5
       LDA    #$7C    2
       LEAX   -1,X    5
       BNE    DARK    3

       LDX    #RGB
       STX    LIGHT+4
       LDX    #10*RGB
       STX    DARK+4
       LDB    1,X
       LDX    #2296
       LDB    <$CC
       BITB   #1
       BEQ    *+5
       NOP
       BRA    *+4
       LEAX   -8,X
       BITB   #2
       BEQ    *+5
       NOP
       BRA    *+4
       LEAX   8,X
       LEAX   -1,X
       BNE    *-2
       LDB    <$C8
       BEQ    GOON

RDP
       CLRA
       LDX    #0
       LEAY   ,X
       JSR    $EC00
       PULS   DP
       SWI

       END
