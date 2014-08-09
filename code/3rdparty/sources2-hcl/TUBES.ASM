           *****************
           *               *
           * DANCING PIPES *
           *               *
           *****************
             * Doctor Lô *
             *************


LOGO   EQU    $7E58
COPPER EQU    $7200
FINCOP EQU    COPPER+508
PALETS EQU    $7F00
FINPAL EQU    $8900
TEXTE  EQU    $8B00
FINTEX EQU    $8FEC
SINUS  EQU    $9000
FINSIN EQU    $9200
FONTES EQU    $9400
ECRAN  EQU    $ADC0
SCROL  EQU    $DB80
TUBE   EQU    8
PAS    EQU    26
SPEED  EQU    2
WART   EQU    160
DIR    EQU    $9F
Z      EQU    0

       ORG    $9940
G      ORCC   #80
       LDA    #DIR
       EXG    A,DP
       STA    RDP+1
       STS    RDP-2

       LDX    #PRINT
       LDB    ,X+
       BEQ    *+7
       JSR    $E803
       BRA    *-7
       LDD    #$02F8
       STA    $E7E5
       CLRA
       LDX    #$A000
       STB    ,X+
       CMPX   #$C000
       BNE    *-5
       STA    ,X+
       CMPX   #$E000
       BNE    *-5
       INC    $E7E5
       LDX    #$A000
       STB    ,X+
       CMPX   #$C000
       BNE    *-5
       STA    ,X+
       CMPX   #$E000
       BNE    *-5
       DEC    $E7E5
       LDA    #128
       STA    $E7DD

       LDX    #GRIS
       LDA    #255
       JSR    $EC00
       LDA    #100
       STA    <Z+6
       CLRB
LETSGO LDU    #LOGO
       LDX    #ECRAN
       LDA    #40
       STA    <Z+5

UNEH   STU    <Z+1
       STB    <Z
       SUBB   #40
       NEGB
       LEAU   B,U
       LEAY   40,X
       STY    <Z+3
       LEAY   $2000,X
       LEAS   $C80,U
       LDB    <Z
       BGT    *+5
       NOP
       BRA    *+6
       CMPB   #40
       BLE    REAL
       LDB    #157
       TST    [A,U]
       DECB
       BNE    *-3
       LEAX   -40,X
       JMP    WELK
REAL   LDA    ,U+
       STA    ,X+
       LDA    ,S+
       STA    ,Y+
       DECB
       BNE    REAL
       CMPX   <Z+3
       BEQ    *+10
       LDA    #$F8
       CLR    ,Y+
       STA    ,X+
       BRA    *-10
       LEAU   -80,U
       LEAX   -40,X
       LDB    <Z
       LEAU   B,U
       LEAY   -40,X
       STY    <Z+3
       LEAY   $2000,X
       LEAS   $C80,U
LAER   LDA    ,-U
       STA    ,-X
       LDA    ,-S
       STA    ,-Y
       DECB
       BNE    LAER
       CMPX   <Z+3
       BEQ    *+10
       LDA    #$F8
       CLR    ,-Y
       STA    ,-X
       BRA    *-10
WELK   LDU    <Z+1
       LEAU   -80,U
       LEAX   -40,X
       LDB    <Z
       DECB
       DEC    <Z+5
       BEQ    *+5
       JMP    UNEH
       ADDB   #41
       LDA    #153
       BITA   A,X
       DECA
       BNE    *-3
       DEC    <Z+6
       LBNE   LETSGO

       LDY    #FOND
       LDX    #SCROL-$2078
       LDA    #14
       STA    <Z
AFOND  LDA    ,Y+
       ASLA
       ASLA
       ASLA
       ORA    #128
       TFR    A,B
       TFR    D,U
       LDB    #20
       STU    ,X++
       DECB
       BNE    *-3
       DEC    <Z
       BNE    AFOND
       LDA    $E7E5
       CMPA   #3
       BEQ    *+7
       INC    $E7E5
       BRA    AFOND-11

       DEC    $E7E5
       LDS    #SCROL-$70
HELLO  LDB    ,Y+
       BEQ    FHELLO
       SUBB   #65
       LDA    #28
       MUL
       LDU    #FONTES
       LEAU   D,U
       LDA    #14
ONELET LDX    ,U++
       STX    ,S
       LEAS   40,S
       DECA
       BNE    ONELET
       LEAS   -14*40+2,S
       BRA    HELLO
FHELLO INC    $E7E5
       LDX    #LOGO-$C58
       LDU    #$A168
       LDD    ,X++
       STD    ,U++
       CMPX   #LOGO+40
       BNE    *-7
       LDU    #$C168
       LDD    ,X++
       STD    ,U++
       CMPX   #LOGO+$CA8
       BNE    *-7
       LDU    #PALETS
       LDY    #PAL
       LDX    #FINCOP
       LDA    #9
       CLR    ,X+
       DECA
       BNE    *-3
       BRA    DEGRA

       FCB    8
PRINT  FDB    $1B5B,$1B5A,$1B60,$1400
FOND   FCB    1,2,3,4,5,6,3,1,1,2,2,3,3
       FCB    4
       FCC    /HELLO[WORLDg/
GRIS   FDB    $000,$00F,$222,$333,$444
       FDB    $555,$666,$777,$888,$016
       FDB    $02B,$05F,$1BF,$6FE,$DFD
       FDB    $FFF

DEGRA  LDA    #TUBE
       STA    <Z
       LDD    ,Y
       CMPD   #$FFFF
       BEQ    FINDEG
       LDX    2,Y
       LEAS   60,U
       STX    <Z+1
       STD    <Z+3
TUYO   STX    2,U
       STX    ,S
       LEAX   D,X
       STX    ,U
       STX    2,S
       LEAX   D,X
       LEAU   4,U
       LEAS   -4,S
       DEC    PRINT-1
       BNE    TUYO
       LDA    #8
       STA    PRINT-1
       LEAU   32,U
       LDX    <Z+1
       LDD    4,Y
       LEAX   D,X
       LDD    <Z+3
       DEC    <Z
       BNE    TUYO-7
       LEAY   6,Y
       BRA    DEGRA

FINDEG LDX    #TEXTE
       STX    <Z+2
       LDX    #SCROL
       STX    <Z+4
       LDX    #$80C0
       STX    <Z+6
       LDX    #1
       STX    <Z+8

       LDA    #$E7
       TFR    A,DP
       LDS    RDP-2
       LDX    #GRIS
       LDA    #255
       JSR    $EC00
       LDX    #0
       LEAY   ,X
       CLRA
       JSR    $EC00
       MUL

       LDX    #8+312*100
WAIT   MUL
       MUL
       MUL
       MUL
       ADDD   [,U++]
       LEAX   -1,X
       BNE    WAIT
       LDX    #COPPER

GENIE  LDD    ,X++
       STD    *+7
       CLRB
       STB    <$DB
       LDD    #0
       STB    <$DA
       STA    <$DA
       CMPX   #FINCOP
       BEQ    PROG
       LDD    1,X
       MUL
       LDB    <$C8
       BITB   #1
       BEQ    GENIE

       LDS    #0
RDP    LDA    #0
       TFR    A,DP
       CLR    $E7DD
       LDA    #255
       LDX    #COLORS
       JSR    $EC00
       RTS

PROG   LDD    ,U++
       MUL

* un nbre de cycles multiple de 64
       LDU    #FINCOP
       PULU   A,B,DP,X,Y,S
       LDU    #FINCOP
       PSHU   S,Y
       FDB    $367E,$367E,$367E,$367E
       FDB    $367E,$367E,$367E,$367E
       FDB    $367E,$367E,$367E,$367E
       FDB    $367E,$367E,$367E,$367E
       FDB    $367E,$367E,$367E,$367E
       FDB    $367E,$367E,$367E,$367E
       FDB    $367E,$367E,$367E,$367E
       FDB    $367E,$367E,$367E,$367E
       FDB    $367E,$367E,$367E,$367E
       FDB    $367E,$367E,$367E,$367E
       FDB    $367E,$367E,$367E,$367E
       FDB    $367E,$367E,$367E,$367E
       FDB    $367E,$367E,$367E,$367E
       FDB    $367E,$367E,$367E,$367E
YEAH   LDX    #SINUS
       LDS    #PALETS
       LDD    #TUBE*256+DIR
       TFR    B,DP
       STA    <Z
PIPE   LDU    ,X
       FDB    $3526,$3626,$3526,$3626
       FDB    $3526,$3626,$3526,$3626
       FDB    $3526,$3626,$3526,$3626
       FDB    $3526,$3626,$3526,$3626
       FDB    $3526,$3626,$3526,$3626
       FDB    $3526,$3626,$3526,$3626
       FDB    $3526,$3626,$3526,$3626
       FDB    $3526,$3626,$3526,$3626
CNT1   FCB    48,136,PAS
       DEC    <Z
       BNE    PIPE
CNT2   LEAX   -TUBE*PAS,X
       LEAX   SPEED,X
       CMPX   #FINSIN
       BLO    *+8
       LEAX   SINUS-FINSIN,X
       BRA    *+3
       MUL
       LDD    $E7CC
       BITA   #1
       BEQ    IPAS
       BITA   #2
       BEQ    DPAS
       BITA   #8
       BEQ    ISPE
       BITA   #4
       BEQ    DSPE
       BITB   #64
       BEQ    FIRE
       ADDD   [,X++]
       ADDD   [D,X]
       ADDD   1,X
       JMP    JOIN
FIRE   LDD    YEAH+5
       CMPD   #FINPAL
       BNE    *+7
       LDD    #PALETS
       BRA    *+6
       ADDD   #TUBE*64
       NOP
       STD    YEAH+5
       ADDD   1,X
       BRA    JOIN
IPAS   LDB    CNT1+2
       CMPB   #50
       BNE    *+6
       FDB    $1212
       BRA    *+7
       ADDB   #2
       STB    CNT1+2
       BRA    ROUT1
DPAS   LDB    CNT1+2
       BNE    *+6
       FDB    $1212
       BRA    *+7
       SUBB   #2
       STB    CNT1+2
ROUT1  LDA    #TUBE
       MUL
       STD    <Z
       LDD    #0
       SUBD   <Z
       STD    CNT2+2
       BRA    JOIN
ISPE   LDB    CNT2+5
       CMPB   #14
       BNE    *+6
       FDB    $1212
       BRA    *+7
       ADDB   #2
       STB    CNT2+5
       BRA    ROUT2
DSPE   LDB    CNT2+5
       BNE    *+6
       FDB    $1212
       BRA    *+7
       SUBB   #2
       STB    CNT2+5
ROUT2  MUL
       MUL
       LDA    ,X

JOIN   STX    YEAH+1
       TST    <Z+8
       BNE    WECHS
       DEC    <Z+9
       BNE    *+6
       INC    <Z+8
       BRA    *+4
       LDD    D,X
       EXG    A,B
       LDB    #27
       NOP
       NOP
       DECB
       BNE    *-3
       JMP    BOTTOM
WECHS  LDX    <Z+2
       LDB    ,X+
       CMPX   #FINTEX
       BNE    *+7
       LDX    #TEXTE
       BRA    *+4
       BRA    *-2
       STX    <Z+2
       LDS    #FONTES
       LDA    #28
       MUL
       LDY    <Z+4
       LEAS   D,S
       PULS   D,X,U
       STD    -120,Y
       STX    -80,Y
       STU    -40,Y
       PULS   D,X,U
       STD    ,Y
       STX    40,Y
       STU    80,Y
       PULS   D,X,U
       STD    120,Y
       LEAY   7*40,Y
       STX    -120,Y
       STU    -80,Y
       PULS   D,X,U
       STD    -40,Y
       STX    ,Y
       STU    40,Y
       PULS   D,X
       STD    80,Y
       STX    120,Y
       LEAX   -7*40+2,Y
       CMPX   #SCROL+40
       BNE    SAMELI
       LDX    #SCROL
       STX    <Z+4
       LDD    <Z+6
       EXG    A,B
       STD    <Z+6
       STA    $E7DD
       ROLB
       ROLA
       ROLB
       ROLA
       ANDA   #3
       STA    $E7E5
       LDD    #WART
       STD    <Z+8
       BRA    BOTTOM
SAMELI STX    <Z+4
       MUL
       MUL
       MUL
       MUL
       LDD    ,X++
BOTTOM LDB    #5
       DECB
       BNE    *-1

       LDA    #$E7
       TFR    A,DP

* fin des 64*0 cycles

       LDX    #COPPER
       JMP    GENIE

COLORS FDB    0,15,240,255,3840,3855
       FDB    4080,4095,1911,826,931
       FDB    938,2611,2618,3815,123
PAL    FDB    16,256*7,-256
       FDB    1,16*7,-16
       FDB    256,7,-1
       FDB    256,16*7,-16
       FDB    16,7,-1
       FDB    1,256*7,-256
       FDB    $FFFF

       END
