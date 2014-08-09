****************************************
*                                      *
* COMPETENCE SANS FRONTIERE:L'OVERSCAN *
*                                      *
****************************************
* Codé le 10-9-90 par doc Lô           *

       ORG    $D5B2

G      ORCC   #80
       LDA    #$E7
       EXG    A,DP
       STA    RDP+2
       LDD    #32
       STA    <$DB
       STA    <$DA
       DECB
       BNE    *-3
       LDA    #$21
       STA    <$DC
       CLR    <$DD
       LDA    <$C3
       ORA    #1
       STA    <$C3
       LDX    #$4000
       CLR    ,X+
       CMPX   #$5F40
       BNE    *-5
       DEC    <$C3
       CLR    ,-X
       CMPX   #$4000
       BNE    *-5
       LDX    #MAP
       STX    $616B
       LDD    #$FF0E
       STA    $6249
       STB    $616D
       LDD    #$60B
       STD    $61D6
       CLR    $6288
       LDB    #69
       JSR    $EC0C
       LDA    #255
       LDX    #COULS
       JSR    $EC00
       LDA    <$CD
       BITA   #64
       BNE    *-4
       LDD    #32
       STA    <$DB
       STA    <$DA
       DECB
       BNE    *-3
       LDX    #$4467
       LDU    #$A000
       LDA    ,U+
       STA    ,X+
       CMPX   #$5F40
       BNE    *-7
       INC    <$C3
       LDX    #$4467
       LDA    ,U+
       STA    ,X+
       CMPX   #$5F40
       BNE    *-7
       LDA    #255
       LDX    #COULS+8
       JSR    $EC00

       LDA    #100
       LDX    #8*312
       LEAX   -1,X
       BNE    *-2
       DECA
       BNE    *-8

NORMAL LDA    #32
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
       LDB    #$5C
       TST    <$C8
       BNE    RDP
       LDA    <$CC
       BITA   #2
       BNE    NORMAL

GOON   LDA    #$7C
       STA    <$E7
       LDX    #4
       LEAX   -1,X
       BNE    *-2
       STB    <$E7
       LDX    #8
       LEAX   -1,X
       BNE    *-2
       LDA    <$C8
       BNE    RDP
       LDA    <$CC
       BITA   #1
       BNE    GOON
       BRA    NORMAL

RDP    LDD    #$FF00
       CLR    <$DC
       TFR    B,DP
       LDX    #COULS+16
       JSR    $EC00
       RTS

COULS  FDB    0,$F00,$200,$600
       FDB    0,19,40,1996
       FDB    0,15,240,255,3840,3855
       FDB    4080,4095,1911,826
MAP

       END
