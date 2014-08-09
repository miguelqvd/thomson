****************************************
*                                      *
*  " Pour Quelques Couleurs De Plus "  *
*                                      *
****************************************
* Codé le 5-7-90 (en 8 mn!) par doc Lô *

       ORG    $A000


G      ORCC   #80
       LDA    #$E7
       EXG    A,DP
       STA    RDP+1
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
       LDX    #PRINT-8
       JSR    $EC00
       LDA    <$CD
       BITA   #64
       BNE    *-4
       LDD    #32
       STA    <$DB
       STA    <$DA
       DECB
       BNE    *-3
       LDU    #PRINT
       LDB    ,U+
       JSR    $E803
       BNE    *-5

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
       LDX    #679
       LEAX   -1,X
       BNE    *-2
       LDD    #0

HDEG   STA    <$DB
       STB    <$DA
       STA    <$DA
       STA    <$DB
       STB    <$DA
       TST    ,X++
       TST    ,--X
       LDA    #15
       STA    <$DA
       CLRA
       TST    [D,X]
       INCB
       BNE    HDEG

       STB    <$DB
       STB    <$DA
       STB    <$DA
       STB    <$DA
       STB    <$DA

       LDX    #441
       LDA    <$CC
       BITA   #1
       BNE    *+8
       LDX    #449
       NOP
       BRA    JOIN
       BITA   #2
       BEQ    *+4
       BRA    JOIN
       LDX    #433
JOIN   LDA    1,U
       CLRA
       LEAX   -1,X
       BNE    *-2
       TST    <$C8
       BEQ    HDEG
RDP    LDA    #0
       TFR    A,DP
       LDB    ,U+
       JSR    $E803
       BNE    *-5
       LDA    #255
       LEAX   ,U
       JSR    $EC00
       RTS

       FDB    0,$FF,$22,$66
PRINT  FDB    $1B5B,$0C0A,$4843,$4C00
       FCB    $1B,$5A,0
       FDB    0,15,240,255,3840,3855
       FDB    4080,4095,1911,826,931,938
       FDB    2611,2618,3815,123
MAP
       END
