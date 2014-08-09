


***********************************
********  TURBODISK  pour  ********
******** PIO1  Version 1.2 ********
******** AVEC VERIFICATION ********
****************************10/10/89*

***********   EQUATES   ***********

FLGEL  EQU    FIN
FLGERR EQU    FIN+1
COMPTP EQU    FIN+2
COMPTB EQU    FIN+3
DEBZON EQU    FIN+4
ESSAI  EQU    FIN+6
FLGCNT EQU    FIN+7

***********   PROGRAM   ***********

       ORG    $8000
       PSHS   U,Y,X,DP,B,A,CC
       LDD    #$0114
       DECA
       BNE    FACE1
       INCB
       BRA    FACE0
FACE1  LDA    #$01
FACE0  STA    $6049
       STB    $604B
       LDA    #$03    No basic prem.bank
       STA    $E7E5
NEXTBK LDA    #$03
       STA    COMPTP
       INC    $E7E5
       LDX    #$A000
       STX    DEBZON
NEXTPS DEC    $6049
       BEQ    INIESS
       DEC    $604B
       LDD    #$4001
       STD    $6048
INIESS LDA    #4
       STA    ESSAI
       CLR    FLGCNT
       LDX    DEBZON
       LEAX   $1556,X
       STX    ECRZON+1,PCR
       STX    LECZON+1,PCR
       STX    CNTZON+1,PCR
NEXTES LBSR   TETE
       LDY    #0
ATT0   LDA    <$D1
       BITA   #$40
       BEQ    ATT0
ATT1   LDA    <$D3
       LDA    <$D0
       BPL    ATT1
ATT2   LDA    <$D0
       BPL    ATT2
       TST    FLGEL
       BNE    LECT
       TST    FLGCNT
       LBNE   CNTROL
       LDD    #$4EFF
       STD    <$D3
       LDB    #$04
       STB    <$D0
       LDB    #$40
ATT3   LDA    <$D0
       BPL    ATT3
       CLR    <$D3
       DECB
       BNE    ATT3
ATT4   LDA    <$D0
       BPL    ATT4
       LDD    #$A10A
       STD    <$D3
ATT5   LDB    <$D0
       BPL    ATT5
       STA    <$D3
ATT6   LDB    <$D0
       BPL    ATT6
       STA    <$D3
ATT7   LDA    <$D0
       BPL    ATT7
       LDD    #$FBFF
       STD    <$D3
       LDX    DEBZON
BECRI  LDB    <$D0
       BPL    BECRI
       LDA    ,X+
       STA    <$D3
       LEAY   A,Y
ECRZON CMPX   #$0000
       BNE    BECRI
       TFR    Y,D
       STD    CHKSUM+1,PCR
ATT8   TST    <$D0
       BPL    ATT8
       STA    <$D3
ATT9   TST    <$D0
       BPL    ATT9
       STB    <$D3
       LDA    #$10
ATT10  LDB    <$D0
       BPL    ATT10
       STA    <$D3
       DECA
       BNE    ATT10
       INC    FLGCNT
       LBRA   NEXTES
LECT   LDA    <$D3
ATT14  LDA    <$D0
       BPL    ATT14
       BITA   #$01
       BNE    LECT
       CLRB
       LDX    DEBZON
       LDA    <$D3
ATT15  LDA    <$D0
       BPL    ATT15
       LDA    <$D3
       CMPA   #$FB
       BEQ    ATT16
       DECB
       BNE    ATT15
       BRA    PBLECT
ATT16  LDA    <$D0
       BPL    ATT16
       LDA    <$D3
       STA    ,X+
       LEAY   A,Y
LECZON CMPX   #$0000
       BNE    ATT16
       TFR    Y,D
ATT17  TST    <$D0
       BPL    ATT17
       CMPA   <$D3
       BNE    PBLECT
ATT18  TST    <$D0
       BPL    ATT18
       CMPB   <$D3
       BEQ    FINPST
PBLECT DEC    ESSAI
       LBNE   NEXTES
       LDA    #$FF
       STA    FLGERR
FINPST CLR    <$D0
       LDA    #$40
       STA    <$D2
       LDX    LECZON+1,PCR
       STX    DEBZON
       DEC    COMPTP
       LBNE   NEXTPS
       DEC    COMPTB
       LBNE   NEXTBK
       PULS   CC,A,B,DP,X,Y,U,PC



TETE   JSR    $E09D
       JSR    $E0A7
       JSR    $E45A
       JSR    $E4A8
       LDB    ,Y
       LDA    <$57
       SUBB   <$4B
       BEQ    TETE2
       BPL    TETE0
       ORA    #$20
       NEGB
TETE0  STA     2,X
TETE1  ORA    #$14
       STA     2,X
       ANDA   #$EB
       STA     2,X
       JSR    $E165
       DECB
       BNE    TETE1
TETE2  BSR    TETE3
       LDB    <$4B
       STB     6,X
       STB    ,Y
       JSR    $E341
       LDB    #$18
       JSR    $E394
       LDA    #$E7
       TFR    A,DP
       RTS
TETE3  LDY    #$6052
       LDA    <$49
       ANDA   #$02
       LEAY   A,Y
       RTS


CNTROL LDA    <$D3
ATT19  LDA    <$D0
       BPL    ATT19
       BITA   #$01
       BNE    CNTROL
       CLRB
       LDX    DEBZON
       LDA    <$D3
ATT20  LDA    <$D0
       BPL    ATT20
       LDA    <$D3
       CMPA   #$FB
       BEQ    ATT21
       DECB
       BNE    ATT20
       BRA    PBCNT
ATT21  LDA    <$D0
       BPL    ATT21
       LDA    <$D3
       CMPA   ,X+
       BNE    PBCNT
CNTZON CMPX   #$0000
       BNE    ATT21
CHKSUM LDD    #0
ATT22  TST    <$D0
       BPL    ATT22
       CMPA   <$D3
       BNE    PBCNT
ATT23  TST    <$D0
       BPL    ATT23
       CMPB   <$D3
       BEQ    FP
PBCNT  CLR    FLGCNT
       DEC    ESSAI
       LBNE   NEXTES
       LDA    #$FF
       STA    FLGERR
FP     CLR    FLGCNT
       LBRA   FINPST




FIN    NOP

       END
