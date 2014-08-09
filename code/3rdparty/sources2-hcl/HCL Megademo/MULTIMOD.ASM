****************************************
*                                      *
****       M U L T I M O D          ****
*HCL*                              *HCL*
****************************************
* J'ai honte ! Pourtant c'est bien moi *


       ORG    $A000
MAP2   EQU    $A477


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
       LDX    #DATAS-8
       JSR    $EC00
       LDA    <$CD
       BITA   #64
       BNE    *-4
       LDD    #32
       STA    <$DB
       STA    <$DA
       DECB
       BNE    *-3
       LDX    #MAP2
       STX    $616B
       LDD    #$FF0E
       STA    $6249
       STB    $616D
       LDD    #$100
       STD    $61D6
       CLR    $6288
       LDB    #69
       JSR    $EC0C

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
       LDX    #892
       LEAX   -1,X
       BNE    *-2
       TST    ,X
       LDU    #DATAS

       PULU   X
WAIT   MUL
       MUL
       MUL
       MUL
       TST    ,Y++
       LEAX   -1,X
       BEQ    *+4
       BRA    WAIT
       LDX    #7
COULS  LDA    ,U+
       ASLA
       STA    <$DB
       PULU   D
       STB    <$DA
       STA    <$DA
       TST    1,Y
       MUL
       MUL
       LEAX   -1,X
       BNE    COULS
MODE   LDA    ,U+
       NOP
       STA    <$DC
       CMPU   #FINDAT
       BEQ    *+4
       BRA    *+5
       LDU    #DATAS
       MUL
       MUL
       ABX
       TST    <$C8
       BEQ    WAIT-2
RDP    LDA    #0
       TFR    A,DP
       LDB    #12
       JSR    $E803
       LDA    #255
       LDX    #FINDAT
       JSR    $EC00
       RTS

       FDB    0,$F0,$20,$60
DATAS  FDB     64,$10F,4,$0016,0,6,$2B
       FDB    0,8,$5F,0,$2A
       FDB     32,$102,$2202,$555,$30F
       FDB    $FF0A,$1BF,0,$C,$6FE,0,$21
       FDB     40,0,2,$2,0,$E,$DFD,0,0,0
       FDB    0,$7B
       FDB     40,$103,3,$1B,$601,$6F08
       FDB    $777,$A00,$400C,$841,$E0F
       FDB    $9400
       FDB     96,$501,$2407,$FFF,$0901
       FDB    $150B,$049F,$0D01,$3E00,0
       FDB    0,0

FINDAT FDB    0,15,240,255,3840,3855
       FDB    4080,4095,1911,826,931,938
       FDB    2611,2618,3815,123
MAP
       END
