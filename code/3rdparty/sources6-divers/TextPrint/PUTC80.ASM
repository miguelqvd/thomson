*************************
*                       *
*      PUTC80.ASM       * DISK RESEAU 1
*                       *
*************************

       ORG    $A000
       PSHS   A,B,X,Y,U,CC
       LDA    COL,PCR
       CMPA   #80
       BHS    FIN
       LDA    LIG,PCR
       CMPA   #24
       BLS    S01
FIN    LDB    #$07
       JSR    >$E803
FIN1   PULS   A,B,X,Y,U,CC
       RTS
S01    LDB    #$08    *CALCULS :
       MUL
       LDA    #$28    *NO LIG
       MUL
       ADDD   #$4000  *ADR D'AFFICHA
       TFR    D,X
       LDB    COL,PCR
       LSRB           *DIVISE COL
       ABX            *PAR 2.
       TFR    X,U
       LDX    TEX,PCR
DEBUT  LDY    POL,PCR *MODIFIE
       LDA    ,X+     *NUMERO LETTRE
       CMPA   #$1F
       BLS    FIN1
       CMPA   #$7F
       BHI    FIN1
       CMPA   #64     *TEST SI A-Z
       BLS    S02
       CMPA   #91
       BHS    S02
       SUBA   #65
       BRA    SUIT
S02    CMPA   #96     *TEST SI a-z
       BLS    S03
       CMPA   #127
       BEQ    S05
       SUBA   #45
       BRA    SUIT
S03    CMPA   #47     *TEST SI 0-9
       BLS    S04
       CMPA   #58
       BHS    S04
       SUBA   #06
       BRA    SUIT
S04    CMPA   #36     *TEST SI -#
       BHS    S05
       SUBA   #06
       BRA    SUIT
S05    LDB    #30
       PSHS   U
       LEAU   TAB,PCR
S06    CMPA   ,U+
       BEQ    S07
       INCB
       CMPB   #42
       BNE    S06
S07    TFR    B,A
       PULS   U
SUIT   LDB    #8
       STA    NUM,PCR
       LSRA
       MUL
       LEAY   D,Y
       BSR    AFFI
       INC    COL,PCR
       LDA    COL,PCR
       CMPA   #80
       BNE    S08
       CLR    COL,PCR
       INC    LIG,PCR
       LDA    LIG,PCR
       CMPA   #25
       LBEQ   FIN
       LEAU   $118,U
S08    LDA    COL,PCR
       LSRA
       LSLA
       CMPA   COL,PCR
       BNE    S09
       LEAU   $01,U
S09    LBRA   DEBUT
************************
****AFFICHAGE LETTRE****
************************
AFFI   BSR    RAMA    *PRISE EN COMPTE
       LDA    COL,PCR *COLONNE
       LSRA
       LSLA
       CMPA   COL,PCR
       BNE    S12
       LDB    #$08
S11    LDA    ,U
       ANDA   #$0F
       STA    ,U
       LDA    ,Y+
       PSHS   B
       LDB    NUM,PCR
       LSRB
       LSLB
       CMPB   NUM,PCR
       BEQ    S111
       LSLA
       LSLA
       LSLA
       LSLA
S111   PULS   B
       ANDA   #$F0
       ORA    ,U
       STA    ,U
       LEAU   $28,U
       DECB
       BNE    S11
       BRA    S13
S12    LDB    #$08
S122   LDA    ,U
       ANDA   #$F0
       STA    ,U
       LDA    ,Y+
       PSHS   B
       LDB    NUM,PCR
       LSRB
       LSLB
       CMPB   NUM,PCR
       BNE    S121
       LSRA
       LSRA
       LSRA
       LSRA
S121   PULS   B
       ANDA   #$0F
       ORA    ,U
       STA    ,U
       LEAU   $28,U
       DECB
       BNE    S122
S13    LEAU   -$140,U
       BSR    RAMB
       LDA    >$603B
       LDB    #$08
S131   STA    ,U
       LEAU   $28,U
       DECB
       BNE    S131
       LEAU   -$140,U
       RTS
************
****RAMA****
************
RAMA   LDA    >$E7C3
       ORA    #$01
       STA    >$E7C3
       RTS
************
****RAMB****
************
RAMB   LDA    >$E7C3
       ANDA   #$FE
       STA    >$E7C3
       RTS
*************
****STOCK****
*************
COL    FCB    $00
LIG    FCB    $00
TEX    FDB    $0000
POL    FDB    $0000
NUM    FCB    $00
TAB    FCC    \+-/*,\
       FCB    127
       FCC    \'?.=:$\
       END
