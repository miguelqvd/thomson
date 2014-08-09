IMAGE  EQU    $4014
SINUS  EQU    $8000
HIGHST EQU    $9900
DIR    EQU    $9A
Z      EQU    $40
PAS    EQU    1

       ORG    $9C00

G      ORCC   #80
       LDA    #DIR
       EXG    A,DP
       STA    SORTIE+1
       LDA    #20
       STA    <Z+6
       CLR    <Z+4
       LDY    #IMAGE+40*160

BOUC   LDD    #$380
       STA    $E7E5
       STB    $E7DD
       BSR    FRAME
       LDD    #$2C0
       STA    $E7E5
       STB    $E7DD
       TST    $E7C8
       BNE    SORTIE
       BSR    FRAME
       TST    $E7C8
       BEQ    BOUC

SORTIE LDA    #0
       TFR    A,DP
       CLR    $E7DD
       RTS

FRAME  CLRB
       JSR    $E806
       CMPB   #48
       BLO    FRAME
       CMPB   #57
       BHI    FRAME

       SUBB   #48
       BNE    *+3
       RTS
       CMPB   #7
       BLO    D1
       LEAY   -320*PAS,Y
D1     CMPB   #3
       BHI    D2
       LEAY   320*PAS,Y
D2     CMPB   #3
       BLS    D3
       SUBB   #3
       CMPB   #3
       BLS    D3
       SUBB   #3
D3     CMPB   #1
       BNE    D4
       LEAY   -PAS,Y
D4     CMPB   #3
       BNE    AFFICH
       LEAY   PAS,Y

AFFICH LDU    #$DF40
       LDD    #0
       LDX    #0
       PSHU   D,X
       FDB    $3616,$3616,$3616,$3616
       FDB    $3616,$3616,$3616,$3616
       PSHU   D,X
       CMPU   #$C000
       BNE    *-24
       LDU    #$BF40
       PSHU   D,X
       FDB    $3616,$3616,$3616,$3616
       FDB    $3616,$3616,$3616,$3616
       PSHU   D,X
       CMPU   #$A000
       BNE    *-24

       LDA    $E7C3
       ORA    #1
       STA    $E7C3
       LDX    #$C000
       BSR    MAPPER
       DEC    $E7C3
       LDX    #$A000

MAPPER STX    ECRAN+1
       PSHS   Y
       LDD    #80
       STD    <Z
       STD    <Z+2
       LDX    #HIGHST
       LDA    #112
       STA    ,X+
       STA    ,X+
       INCA
       CMPX   #HIGHST+160
       BNE    *-8
       STA    ,X+
       STA    ,X+
       DECA
       CMPX   #HIGHST+320
       BNE    *-8

CALCUL LDA    <Z+1
       BPL    *+3
       NEGA
       TFR    A,B
       MUL
       STD    <Z+8
       LDA    <Z+3
       BPL    *+3
       NEGA
       TFR    A,B
       MUL
       ADDD   <Z+8
       CMPD   #6400
       BLO    *+6
       CLR    <Z+5
       BRA    *+9
       LDX    #SINUS
       LDB    D,X
       STB    <Z+5

       LDD    <Z
       ADDD   <Z+2
       ASRA
       RORB
       SUBD   <Z+4
       ADDD   #112
       STB    <Z+7

       LDD    <Z+2
       SUBD   <Z
       ADDD   #160
       STD    <Z+8

       LDX    #HIGHST
       LEAX   D,X
       LDA    ,X
       CMPA   <Z+7
       BLS    KEDALL
       LDB    <Z+7
       STB    ,X
       STA    <Z+5
BITEST LDA    #128
       BITA   ,Y
       BEQ    KEDALL
       LDD    <Z+8
       LSRA
       RORB
       LSRB
       LSRB
ECRAN  LDX    #0
       ABX
       LDB    <Z+7
       LDA    #40
       MUL
       LEAX   D,X
       LDB    <Z+9
       ANDB   #7
       LDU    #DECALG
       LDA    B,U
       STA    PIXEL+1
       LDB    <Z+5
       SUBB   <Z+7
PIXEL  LDA    #0
       ORA    ,X
       STA    ,X
       LEAX   40,X
       DECB
       BNE    PIXEL

KEDALL LSR    BITEST+1
       BNE    MEMSEG
       LDA    #128
       STA    BITEST+1
       LEAY   1,Y
       DEC    <Z+6
       BNE    MEMSEG
       LDA    #20
       STA    <Z+6
       LEAY   -60,Y
MEMSEG LDX    <Z
       LEAX   -1,X
       STX    <Z
       CMPX   #-80
       LBNE   CALCUL
       LDX    #80
       STX    <Z
       LDX    <Z+2
       LEAX   -1,X
       STX    <Z+2
       CMPX   #-80
       LBNE   CALCUL
       PULS   Y
       RTS

DECALG FDB    $8040,$2010,$0804,$0201
       END
