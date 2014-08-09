
******** EDITEUR *******

M      EQU    $C000
COMPT  EQU    M
COMPTL EQU    M+1
FLGCOM EQU    M+2
TYPPAR EQU    M+3
DEBTXT EQU    M+4
PTEXT  EQU    M+6
FINTXT EQU    M+8
LIMTXT EQU    M+10
PTRCOU EQU    M+12
GECAR  EQU    M+14
CCAR   EQU    M+16
CCOM   EQU    M+17
CPAR   EQU    M+18
CGRA   EQU    M+19
CERR   EQU    M+20
CFILET EQU    M+21
CRIEN  EQU    M+22
FLGCLI EQU    M+24
FLGMOD EQU    M+25
MCAR   EQU    M+26
MCOM   EQU    M+28
MPAR   EQU    M+30
MGRA   EQU    M+32
MACC   EQU    M+34
FLGACG EQU    M+36
PTRGRA EQU    M+37
PILEB  EQU    M+38

MEMCOU EQU    $C100   /$C2B7

******** PROGRAMME *******

       ORG    $C800
G      LDB    #$1B
       JSR    $E803
       LDB    #$60
       JSR    $E803
       LDX    #$C300
       STX    DEBTXT
       LDX    #$C328
       STX    PTEXT
       LDX    #$C350
       STX    FINTXT
       LDX    #$C7FF
       STX    LIMTXT
       LDX    #$A001
       STX    GECAR
       LDX    #$F8C3
       STX    CCAR
       LDX    #$C6D0
       STX    CPAR
       LDX    #$D1E0
       STX    CERR
       LDX    #$E000
       STX    CRIEN
       LDX    #$6000
       STX    MCAR
       LDX    #$6496
       STX    MACC
       LDX    #$631F
       STX    MCOM
       LDX    #$661E
       STX    MPAR
       LDX    #$621D
       STX    MGRA
       LDX    #0
       STX    FLGCLI
       LDA    #20
       STA    PTRGRA
       LBRA   PREPEC

INSERT LDU    FINTXT
       CMPU   LIMTXT
       LBHS   GETC
       LEAU   1,U
       STU    FINTXT
       PSHS   B
       LDX    PTEXT
       STX    INS4+2,PCR
       LEAX   40,X
       STX    INS2+2,PCR
       CMPX   FINTXT
       BHS    INS3
INS1   LEAU   -7,U
       PULU   X,Y,A,B,DP
       LEAU   1,U
       PSHU   X,Y,A,B,DP
       LEAU   -8,U
       PULU   X,Y,A,B,DP
       LEAU   1,U
       PSHU   X,Y,A,B,DP
       LEAU   -8,U
       PULU   X,Y,A,B,DP
       LEAU   1,U
       PSHU   X,Y,A,B,DP
       LEAU   -8,U
       PULU   X,Y,A,B,DP
       LEAU   1,U
       PSHU   X,Y,A,B,DP
       LEAU   -8,U
       PULU   X,Y,A,B,DP
       LEAU   1,U
       PSHU   X,Y,A,B,DP
       LEAU   -1,U
INS2   CMPU   #0
       BHI    INS1
INS3   LDA    ,-U
       STA    1,U
INS4   CMPU   #0
       BHI    INS3
       PULS   B
       LDX    PTEXT
       STB    ,X+
       STX    PTEXT
       LBRA   AFFICH

DELETE LDX    PTEXT
       CMPX   FINTXT
       LBHI   GETC
       TFR    X,U
       LDX    FINTXT
       STX    DEL4+2,PCR
       LEAX   -1,X
       STX    FINTXT
       LEAX   -39,X
       STX    DEL2+2,PCR
       STX    DEL0+2,PCR
       LEAU   1,U
DEL0   CMPU   #0000
       BHS    DEL3
DEL1   PULU   X,Y,A,B,DP
       LEAU   -1,U
       PSHU   X,Y,A,B,DP
       LEAU   8,U
       PULU   X,Y,A,B,DP
       LEAU   -1,U
       PSHU   X,Y,A,B,DP
       LEAU   8,U
       PULU   X,Y,A,B,DP
       LEAU   -1,U
       PSHU   X,Y,A,B,DP
       LEAU   8,U
       PULU   X,Y,A,B,DP
       LEAU   -1,U
       PSHU   X,Y,A,B,DP
       LEAU   8,U
       PULU   X,Y,A,B,DP
       LEAU   -1,U
       PSHU   X,Y,A,B,DP
       LEAU   8,U
DEL2   CMPU   #0
       BLO    DEL1
DEL3   LDA    ,U+
       STA    -2,U
DEL4   CMPU   #0
       BLO    DEL3
       LBRA   AFFICH

PREPEC LDA    $E7C3
       ORA    #1
       STA    $E7C3
       LDU    #$5F40
       LDX    #0
       TFR    X,Y
       LDA    #10
FOND0  LDB    #200
FOND1  PSHU   X,Y
       DECB
       BNE    FOND1
       DECA
       BNE    FOND0
       LDU    #$5F40
       LDX    #$FFFF
       TFR    X,Y
       LDA    #12
FILET0 LDB    #20
FILET1 PSHU   X,Y
       DECB
       BNE    FILET1
       LEAU   -$280,U
       DECA
       BNE    FILET0

       LDA    $E7C3
       ANDA   #$FE
       STA    $E7C3
       LDU    #$5F40
       LDA    CFILET
       TFR    A,B
       TFR    D,X
       TFR    D,Y
       LDA    #12
FILET2 LDB    #20
FILET3 PSHU   X,Y
       DECB
       BNE    FILET3
       LEAU   -$280,U
       DECA
       BNE    FILET2

AFFICH LDA    #11
       STA    COMPTL
       LDA    #40
       STA    COMPT
       LDA    $E7C3
       ORA    #1
       STA    $E7C3
       LDU    #MEMCOU
       LDY    #$40F0
       LDX    PTEXT
       LEAX   -$E0,X
       CMPX   DEBTXT
       LBHS   AT2
AT0    LDD    CRIEN
       STA    ,U+
       LDD    #$FF00
       STB    -$78,Y
       STB    -$50,Y
       STB    -$28,Y
       STA    ,Y
       STA    $28,Y
       STB    $50,Y
       STB    $78,Y
       LEAY   $118,Y
       STB    -$78,Y
       STB    -$50,Y
       STA    -$28,Y
       STA    ,Y
       STB    $28,Y
       STB    $50,Y
       STB    $78,Y
       LEAY   -$117,Y
       DEC    COMPT
       BNE    AT1
       DEC    COMPTL
       LDA    #40
       STA    COMPT
       LEAY   680,Y
AT1    LEAX   1,X
       CMPX   DEBTXT
       BLO    AT0
AT2    STU    PTRCOU
       LBRA   AT19
AT3    LDB    ,X+
       CMPB   #$90
       BLO    AT4
       SUBB   #$90
       LBRA   GRAPH
AT4    CMPB   #$20
       LBHS   CARA
AT5    LDA    FLGCOM
       BMI    AT13
       LBNE   AT18
       CMPB   #3
       BNE    AT6
       LDU    #$8300
       LBRA   COMSET
AT6    CMPB   #6
       BNE    AT7
       LDU    #$8600
       LBRA   COMSET
AT7    CMPB   #4
       BEQ    AT8
       CMPB   #5
       BEQ    AT8
       CMPB   #9
       BNE    AT9
AT8    LDU    #0
       LBRA   COMSET
AT9    CMPB   #1
       BEQ    AT10
       CMPB   #7
       BEQ    AT10
       CMPB   #22
       BNE    AT11
AT10   LDU    #$0101
       LBRA   COMSET
AT11   CMPB   #2
       BEQ    AT12
       CMPB   #11
       BEQ    AT12
       CMPB   #15
       BEQ    AT12
       CMPB   #16
       BEQ    AT12
       CMPB   #20
       BNE    ERRCOM
AT12   LDU    #$0200
       BRA    COMSET
AT13   CMPA   #$83
       BNE    AT17
       CMPB   #1
       BNE    AT15
AT14   LDU    #$0280
       BRA    COMSET
AT15   CMPB   #9
       BEQ    AT14
       CMPB   #16
       BNE    AT16
       LDU    #$1080
       BRA    COMSET
AT16   CMPB   #18
       BEQ    AT8
       CMPB   #20
       BNE    ERRCOM
       LDU    #$0180
       BRA    COMSET
AT17   CMPA   #$86
       BNE    ERRCOM
       CMPB   #1
       BEQ    AT8
       CMPB   #2
       BEQ    AT8
       BRA    ERRCOM
AT18   DEC    FLGCOM
       TST    TYPPAR
       BEQ    PARA9
       BMI    PARAF
PARA3  CMPB   #3
       BHI    ERRPAR
PARA9  CMPB   #9
       BHI    ERRPAR
PARAF  CMPB   #15
       BHI    ERRPAR
       LDA    CPAR
       BRA    PARA
GRAPH  LDA    CGRA
       CMPB   #31
       BLS    PARA
ERRPAR LDA    CERR
       LDU    #0
PARA   CMPB   #10
       BLO    PARAS
       ADDB   #7
PARAS  ADDB   #16
       BRA    CARAF
ERRCOM LDA    CERR
       LDU    #0
       BRA    CARAV
COMSET LDA    CCOM
CARAV  ADDB   #32
       BRA    CARAS
CARA   SUBB   #32
       TST    FLGCOM
       BNE    ERRCOM
       LDA    CCAR
       LDU    #0
CARAS  STU    FLGCOM
CARAF  LDU    PTRCOU
       STA    ,U+
       STU    PTRCOU
       LDA    #16
       MUL
       ADDD   GECAR
       TFR    D,U
       PULU   A,B
       STA    -$78,Y
       STB    -$50,Y
       PULU   A,B
       STA    -$28,Y
       STB    ,Y
       PULU   A,B
       STA    $28,Y
       STB    $50,Y
       PULU   A,B
       STA    $78,Y
       LEAY   $118,Y
       STB    -$78,Y
       PULU   A,B
       STA    -$50,Y
       STB    -$28,Y
       PULU   A,B
       STA    ,Y
       STB    $28,Y
       PULU   A,B
       STA    $50,Y
       STB    $78,Y
       LEAY   -$117,Y
       DEC    COMPT
       BNE    AT19
       DEC    COMPTL
       LBEQ   AFFCOU
       LDA    #40
       STA    COMPT
       LEAY   680,Y
AT19   CMPX   FINTXT
       LBLS   AT3
       LDU    PTRCOU
AT20   LDD    CRIEN
       STA    ,U+
       LDD    #$FF00
       STB    -$78,Y
       STB    -$50,Y
       STB    -$28,Y
       STA    ,Y
       STA    $28,Y
       STB    $50,Y
       STB    $78,Y
       LEAY   $118,Y
       STB    -$78,Y
       STB    -$50,Y
       STA    -$28,Y
       STA    ,Y
       STB    $28,Y
       STB    $50,Y
       STB    $78,Y
       LEAY   -$117,Y
       DEC    COMPT
       BNE    AT20
       DEC    COMPTL
       BEQ    AFFCOU
       LDA    #40
       STA    COMPT
       LEAY   680,Y
       BRA    AT20
AFFCOU LDA    $E7C3
       ANDA   #$FE
       STA    $E7C3
       LDU    #MEMCOU
       LDX    #$4055
       LDA    #11
       STA    COMPTL
AC0    LDA    #8
       STA    COMPT
AC1    PULU   A,B,Y,DP
       EXG    U,X
       PSHU   A,B,Y,DP
       LEAU   45,U
       PSHU   A,B,Y,DP
       LEAU   45,U
       PSHU   A,B,Y,DP
       LEAU   45,U
       PSHU   A,B,Y,DP
       LEAU   45,U
       PSHU   A,B,Y,DP
       LEAU   45,U
       PSHU   A,B,Y,DP
       LEAU   45,U
       PSHU   A,B,Y,DP
       LEAU   45,U
       PSHU   A,B,Y,DP
       LEAU   45,U
       PSHU   A,B,Y,DP
       LEAU   45,U
       PSHU   A,B,Y,DP
       LEAU   45,U
       PSHU   A,B,Y,DP
       LEAU   45,U
       PSHU   A,B,Y,DP
       LEAU   45,U
       PSHU   A,B,Y,DP
       LEAU   45,U
       PSHU   A,B,Y,DP
       LEAU   45,U
       PSHU   A,B,Y,DP
       LEAU   45,U
       PSHU   A,B,Y,DP
       LEAU   -590,U
       EXG    U,X
       DEC    COMPT
       BNE    AC1
       LEAX   680,X
       DEC    COMPTL
       BNE    AC0
       LBRA   GETC
CLIGNO COM    FLGCLI
       LDY    #$4EF0
       TST    FLGMOD
       LBMI   CLIPLN
       LDA    -$78,Y
       ADDA   #128
       STA    -$78,Y
       LDA    -$50,Y
       ADDA   #128
       STA    -$50,Y
       LDA    -$28,Y
       ADDA   #128
       STA    -$28,Y
       LDA    ,Y
       ADDA   #128
       STA    ,Y
       LDA    $28,Y
       ADDA   #128
       STA    $28,Y
       LDA    $50,Y
       ADDA   #128
       STA    $50,Y
       LDA    $78,Y
       ADDA   #128
       STA    $78,Y
       LDA    $A0,Y
       ADDA   #128
       STA    $A0,Y
       LDA    $C8,Y
       ADDA   #128
       STA    $C8,Y
       LDA    $F0,Y
       ADDA   #128
       STA    $F0,Y
       LDA    $118,Y
       ADDA   #128
       STA    $118,Y
       LDA    $140,Y
       ADDA   #128
       STA    $140,Y
       LDA    $168,Y
       ADDA   #128
       STA    $168,Y
       LDA    $190,Y
       ADDA   #128
       STA    $190,Y
       LDA    $1B8,Y
       ADDA   #128
       STA    $1B8,Y
       LDA    $1E0,Y
       ADDA   #128
       STA    $1E0,Y
       RTS
CLIPLN COM    -$78,Y
       COM    -$50,Y
       COM    -$28,Y
       COM    ,Y
       COM    $28,Y
       COM    $50,Y
       COM    $78,Y
       COM    $A0,Y
       COM    $C8,Y
       COM    $F0,Y
       COM    $118,Y
       COM    $140,Y
       COM    $168,Y
       COM    $190,Y
       COM    $1B8,Y
       COM    $1E0,Y
       RTS
GETC   CLR    FLGCLI
       LDA    $E7C3
       ORA    #1
       STA    $E7C3
GC0    LBSR   CLIGNO
       LDX    #$2000
GC1    ANDCC  #$FE
GC2    JSR    $E809
       BCS    GC3
       LEAX   -1,X
       BNE    GC2
       BRA    GC0
GC3    JSR    $E806
       TSTB
       BEQ    GC1
       TST    FLGCLI
       BEQ    GC4
       LBSR   CLIGNO
GC4    CMPB   #24     )
       BNE    GC4BIS  )à supprimer
K      NOP            )
GC4BIS CMPB   #1      Mode ACCENT
       BEQ    ACC
       CMPB   #22
       BNE    GC5
ACC    LDD    MACC
       BRA    MODE
GC5    CMPB   #2      Mode CARACT
       BEQ    SMCAR
       CMPB   #3
       BNE    GC6
SMCAR  LDD    MCAR
       BRA    MODE
GC6    CMPB   #4      Mode DIFFUSION
       BNE    GC7
       JMP    GC7     Saut à DIFF.
GC7    CMPB   #5      Mode ESSAI
       BNE    GC8
       JMP    GC8     Saut à ESSAI
GC8    CMPB   #6      Mode FONCTION
       BNE    GC9
       LDD    MCOM
MODE   STB    FLGMOD
       LDB    #$1B
       JSR    $E803
       TFR    A,B
       JSR    $E803
       TST    FLGACG
       BEQ    GOGET0
       CLR    FLGACG
       LBRA   DELETE
GOGET0 LBRA   GETC
GC9    CMPB   #7      Mode GRAPHISMES
       BNE    GC10
       LDD    MGRA
       BRA    MODE
GC10   CMPB   #8
       BNE    GC12
       LDX    PTEXT
       CMPX   DEBTXT
       BLS    GOGET0
       LEAX   -1,X
       STX    PTEXT
GC11   LBRA   AFFICH
GC12   CMPB   #9
       BNE    GC13
       LDX    PTEXT
       CMPX   FINTXT
       BHI    GOGET0
       LEAX   1,X
       STX    PTEXT
       BRA    GC11
GC13   CMPB   #10
       BNE    GC14
       LDX    PTEXT
       LEAX   40,X
       CMPX   FINTXT
       BHI    GOGET0
       STX    PTEXT
       BRA    GC11
GC14   CMPB   #11
       BNE    GC15
       LDX    PTEXT
       LEAX   -40,X
       CMPX   DEBTXT
       BLO    GOGET0
       STX    PTEXT
       BRA    GC11
GC15   CMPB   #13     Mémorisation
       BNE    GC16    pour tiroir ?
       JMP    GC16
GC16   CMPB   #16     Mode PARAMETRE
       BNE    GC17
       LDD    MPAR
       LBRA   MODE
GC17   CMPB   #29     DELETE
       LBEQ   DELETE
       LDA    FLGMOD
       BNE    GC20
       CMPB   #32
       BLO    GC18
       CMPB   #128
       BLO    GC19
GC18   LBRA   GETC
GC19   LBRA   INSERT
GC20   CMPB   #64
       BLO    GC205
       ANDB   #$DF
GC205  CMPA   #$96
       LBNE   GCOM
       LDX    PTEXT
       LDA    ,X
       CMPA   #99
       BNE    GC21
       CMPB   #67
       BNE    GC30
       LDA    #128
       STA    ,X
       BRA    AFFACC
GC21   CMPA   #97
       BEQ    LETA
       CMPA   #129
       BLO    GC26
       CMPA   #132
       BHI    GC26
LETA   CMPB   #65
       BNE    GC22
       LDA    #129
       BRA    AFFACC
GC22   CMPB   #67
       BNE    GC23
       LDA    #130
       BRA    AFFACC
GC23   CMPB   #84
       BNE    GC24
       LDA    #131
       BRA    AFFACC
GC24   CMPB   #71
       BNE    GC30
       LDA    #132
       BRA    AFFACC
GC26   CMPA   #101
       BEQ    LETE
       CMPA   #133
       BLO    GC31
       CMPA   #136
       BHI    GC31
LETE   CMPB   #65
       BNE    GC27
       LDA    #133
       BRA    AFFACC
GC27   CMPB   #67
       BNE    GC28
       LDA    #134
       BRA    AFFACC
GC28   CMPB   #84
       BNE    GC29
       LDA    #135
       BRA    AFFACC
GC29   CMPB   #71
       BNE    GC30
       LDA    #136
AFFACC STA    ,X
       LBRA   AFFICH
GC30   LBRA   GETC
GC31   CMPA   #105
       BEQ    LETI
       CMPA   #137
       BLO    GC33
       CMPA   #138
       BHI    GC33
LETI   CMPB   #67
       BNE    GC32
       LDA    #137
       BRA    AFFACC
GC32   CMPB   #84
       BNE    GC30
       LDA    #138
       BRA    AFFACC
GC33   CMPA   #111
       BEQ    LETO
       CMPA   #139
       BLO    GC35
       CMPA   #140
       BHI    GC35
LETO   CMPB   #67
       BNE    GC34
       LDA    #139
       BRA    AFFACC
GC34   CMPB   #84
       BNE    GC30
       LDA    #140
       BRA    AFFACC
GC35   CMPA   #117
       BEQ    LETU
       CMPA   #141
       BLO    GC37
       CMPA   #143
       BHI    GC37
LETU   CMPB   #67
       BNE    GC36
       LDA    #141
       BRA    AFFACC
GC36   CMPB   #84
       BNE    GC37
       LDA    #142
       BRA    AFFACC
GC37   CMPB   #71
       BNE    GC30
       LDA    #143
       BRA    AFFACC
GCOM   CMPA   #31
       BNE    GPAR
       SUBB   #64
       BLE    GOGET1
       CMPB   #22
       BHI    GOGET1
       CMPB   #8
       BEQ    GOGET1
       CMPB   #10
       BEQ    GOGET1
       CMPB   #17
       BEQ    GOGET1
       CMPB   #19
       BEQ    GOGET1
       CMPB   #21
       BEQ    GOGET1
       CMPB   #12
       BLO    GINS
       CMPB   #14
       BLS    GOGET1
GINS   LBRA   INSERT
GPAR   CMPA   #30
       BNE    GGRA
       SUBB   #48
       BMI    GOGET1
       CMPB   #9
       BLS    GINS
       SUBB   #7
       CMPB   #10
       BLO    GOGET1
       CMPB   #15
       BLS    GINS
GOGET1 LBRA   GETC
GGRA   CMPA   #29
       BNE    GOGET1
       SUBB   #48
       BMI    GOGET1
       CMPB   #9
       BHI    GOGET1
       COM    FLGACG
       BEQ    GGRA2
       STB    PILEB
       ADDB   #48
       BRA    GINS
GGRA2  LDX    PTEXT
       PSHS   B
       LDA    #10
       LDB    PILEB
       MUL
       ADDB   ,S+
       CMPB   PTRGRA
       BLS    GGRA3
       LEAX   -1,X
       STX    PTEXT
       LBRA   DELETE
GGRA3  ADDB   #$90
       STB    ,-X
       LBRA   AFFICH




       END
