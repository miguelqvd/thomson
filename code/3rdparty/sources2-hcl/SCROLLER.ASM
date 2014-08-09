****************************************
*                                      *
*  MEGASCROLLER BY DOCTOR LO FROM HCL  *
*                                      *
****************************************
* Taille 42*6

PALETS EQU    TEXTE-224
TEXTE  EQU    $7800
TAMP   EQU    $9E60
FONTES EQU    $9F08
RAMA   EQU    $DF18-42*40
RAMB   EQU    RAMA-$2000
DIR    EQU    $9E
Z      EQU    $58
ZZ     EQU    DIR*256+Z


       ORG    $9800
G      ORCC   #80
       LDA    #$E7
       EXG    A,DP
       STA    RDP+1
       STS    RDP-2

       LDU    #ZZ
       CLR    ,U+
       LDD    #TEXTE
       STD    ,U++
       LDA    #6
       STA    ,U
       LDX    #TAMP
       CLR    ,X+
       CMPX   #$A000
       BNE    *-5
       LDY    #COLORS-14
       LDU    #PALETS
       LDX    #15
       LDA    #16
       STA    ZZ
       LDD    ,Y++
       BEQ    *+13
       STX    ,U++
       DEC    ZZ
       BEQ    *-14
       LEAX   D,X
       BRA    *-9

       LDA    #$21
       STA    <$DC
       LDA    #2
       STA    <$E5
       LDD    #0
       LDX    #$A000
       STD    ,X++
       CMPX   #$E000
       BNE    *-5
       INC    <$E5
       STD    ,--X
       CMPX   #$A000
       BNE    *-5
       LDA    #128
       STA    <$DD
       LDB    #2
       LDA    #32
       BITA   $E7E7
       BEQ    *-3
       BITA   $E7E7
       BNE    *-3
       TST    [D,X]
       TST    [D,X]
       TST    [D,X]
       TST    [D,X]
       ABX
       BITA   $E7E7
       BEQ    *-12
       TST    <$E7
       BPL    *-2
       TST    <$E7
       BMI    *-2

       LDX    #311*64/16
       TST    ,U+
       LEAX   -1,X
       BNE    *-4

       MUL
       MUL
       MUL
       LDA    #DIR
       TFR    A,DP
       TST    ,U++

DEBUT  LDX    #RAMA+160
       LDU    #TAMP
       LDA    #6
       STA    <Z
COPYA  PULU   D
       STA    -120,X
       STB    -80,X
       PULU   D
       STA    -40,X
       STB    ,X
       PULU   D
       STA    40,X
       STB    80,X
       PULU   A
       STA    120,X
       LEAX   280,X
       DEC    <Z
       BNE    COPYA

       LDA    #42
       STA    <Z
       LDU    #RAMA+1
SCROLA PULU   D,X,Y,S
       LEAU   -1,U
       PSHU   S,Y,X,D
       LEAU   9,U
       FDB    $3776,$335F,$3676,$3349
       FDB    $3776,$335F,$3676,$3349
       FDB    $3776,$335F,$3676,$3349
       FDB    $3776,$335F,$3676,$3349
       DEC    <Z
       BNE    SCROLA
       CLR    RAMA+42*40

       LDX    #RAMB+160
       LDU    #TAMP+42
       LDA    #6
       STA    <Z
COPYB  PULU   D
       STA    -120,X
       STB    -80,X
       PULU   D
       STA    -40,X
       STB    ,X
       PULU   D
       STA    40,X
       STB    80,X
       PULU   A
       STA    120,X
       LEAX   280,X
       DEC    <Z
       BNE    COPYB

       LDA    #42
       STA    <Z
       LDU    #RAMB+1
SCROLB PULU   D,X,Y,S
       LEAU   -1,U
       PSHU   S,Y,X,D
       LEAU   9,U
       FDB    $3776,$335F,$3676,$3349
       FDB    $3776,$335F,$3676,$3349
       FDB    $3776,$335F,$3676,$3349
       FDB    $3776,$335F,$3676,$3349
       DEC    <Z
       BNE    SCROLB
       CLR    RAMB+42*40

BANK   LDA    #4
       STA    $E7E5
       LDU    #FONTES
       LDX    <Z+1
       LDA    <Z+3
       CMPA   #6
       BEQ    *+6
       TST    D,X
       BRA    *+7
       LEAX   0,X     *  1,X
       CLRA
       TST    <Z+3    * CLR
       LDB    #84
       MUL
       LEAU   D,U
       TST    <Z+3    * INC
       LDA    ,X
       BRA    *+9     * BPL
       LDY    #XCEPT-2
       NEGA
       JMP    [A,Y]
       LDB    #30
COGIT2 DECB           * label COGITO
       BNE    *-1
       LDX    <Z+1    * STX
       LDB    #252
       MUL
       LEAS   D,U
       LDU    #TAMP+84
       FCC    /5>6>5>6>/
       JMP    TEMPO
       LDB    #40
       DECB
       BNE    *-1
BCKTEM LDX    #PALETS
       LDD    #$24E7
       STA    ZZ
       TFR    B,DP

FBUF   LDD    ,X++
       STD    *+8
       LDB    #6
       STB    <$DB
       LDD    #0
       STB    <$DA
       STA    <$DA
RPF6   CMPX   #PALETS+72
       BEQ    *+4
       BRA    *+5
RPD6   LDX    #PALETS
       MUL
       NOP
       DEC    ZZ
       BNE    FBUF
       LDA    <$C8
       BEQ    *+5
       JMP    RDP-4
       FCC    /5>6>5>6>5>6>5>6>5>6>/
       FCC    /5>6>5>6>5>6>5>6>5>6>/
       NOP
       NOP
       LDD    #$300+DIR *  #$200+DIR
       STA    $E7E5
       TFR    B,DP
REVIT  JMP    *+3     *  DEBUT
       LDA    #192
       STA    $E7DD
       LDX    #RAMA+160
       LDU    #TAMP+84
       LDA    #6
       STA    <Z
COPYA2 PULU   D
       STA    -120,X
       STB    -80,X
       PULU   D
       STA    -40,X
       STB    ,X
       PULU   D
       STA    40,X
       STB    80,X
       PULU   A
       STA    120,X
       LEAX   280,X
       DEC    <Z
       BNE    COPYA2

       LDA    #42
       STA    <Z
       LDU    #RAMA+1
SCRLA2 PULU   D,X,Y,S
       LEAU   -1,U
       PSHU   S,Y,X,D
       LEAU   9,U
       FDB    $3776,$335F,$3676,$3349
       FDB    $3776,$335F,$3676,$3349
       FDB    $3776,$335F,$3676,$3349
       FDB    $3776,$335F,$3676,$3349
       DEC    <Z
       BNE    SCRLA2
       CLR    RAMA+42*40

       LDX    #RAMB+160
       LDU    #TAMP+126
       LDA    #6
       STA    <Z
COPYB2 PULU   D
       STA    -120,X
       STB    -80,X
       PULU   D
       STA    -40,X
       STB    ,X
       PULU   D
       STA    40,X
       STB    80,X
       PULU   A
       STA    120,X
       LEAX   280,X
       DEC    <Z
       BNE    COPYB2

       LDA    #42
       STA    <Z
       LDU    #RAMB+1
SCRLB2 PULU   D,X,Y,S
       LEAU   -1,U
       PSHU   S,Y,X,D
       LEAU   9,U
       FDB    $3776,$335F,$3676,$3349
       FDB    $3776,$335F,$3676,$3349
       FDB    $3776,$335F,$3676,$3349
       FDB    $3776,$335F,$3676,$3349
       DEC    <Z
       BNE    SCRLB2
       CLR    RAMB+42*40

BANK2  LDA    #5
       STA    $E7E5
       LDU    #FONTES
       LDX    <Z+1
       LDA    <Z+3
       CMPA   #6
       BEQ    *+6
       TST    D,X
       BRA    *+7
       LEAX   1,X
       CLRA
       CLR    <Z+3
       LDB    #84
       MUL
       LEAU   D,U
       INC    <Z+3
       LDA    ,X
       BPL    *+9
       LDY    #XCEPT-2
       NEGA
       JMP    [A,Y]
       LDB    #30
COGITO DECB
       BNE    *-1
       STX    <Z+1
       LDB    #252
       MUL
       LEAS   D,U
       LDU    #TAMP+168
       FCC    /5>6>5>6>/
       LDD    #40
       DECB
       BNE    *-1
BCKTM2 LDX    #PALETS
       LDD    #$24E7
       STA    ZZ
       TFR    B,DP

FBUF2  LDD    ,X++
       STD    *+8
       LDB    #6
       STB    <$DB
       LDD    #0
       STB    <$DA
       STA    <$DA
RPF5   CMPX   #PALETS+72
       BEQ    *+4
       BRA    *+5
RPD5   LDX    #PALETS
       MUL
       NOP
       DEC    ZZ
       BNE    FBUF2
       FCC    /5>6>5>6>5>6>5>6>5>6>/
       FCC    /5>6>5>6>5>6>5>6>5>6>/
       LDA    #128
       STA    $E7DD
       NOP
       NOP
       LDD    #$200+DIR
       STA    $E7E5
       TFR    B,DP
       JMP    DEBUT

TEMPO  JMP    BCKTEM-5
ROT    LDX    BCKTEM+1
       LEAX   2,X
       CMPX   RPF1+1
       BEQ    *+4
       BRA    *+5
RPD4   LDX    #PALETS
       STX    BCKTEM+1
       LEAX   2,X
       CMPX   RPF1+1
       BEQ    *+4
       BRA    *+5
RPD3   LDX    #PALETS
       STX    BCKTM2+1
       LDD    #29
       JMP    BCKTEM-3

ONROT  LDD    #ROT
       STD    BCKTEM-7
       LEAX   1,X
       LDA    ,X
       LDB    #22
       LBRA   RENVOI
OFROT  LDD    #TEMPO
       STD    BCKTEM-7
       LDD    BCKTM2+1
       STD    BCKTEM+1
       LEAX   1,X
       LDD    ,X
       NOP
       LDB    #19
       LBRA   RENVOI
WAIT   LDY    1,X
       STX    <Z+1
       LDX    BCKTEM+1
       STX    W2-19
W1     LDD    BCKTEM-7
       LDX    W2-19
       CMPD   #ROT
       BEQ    *+5
       NOP
       BRA    *+4
       LEAX   1,X
RPF2   CMPX   #PALETS+72
       BEQ    *+4
       BRA    *+5
RPD2   LDX    #PALETS
       STX    W2-19
       LDB    #0
       LDB    #66
       DECB
       BNE    *-1
       LDX    #PALETS
       TFR    X,D
       ANDB   #254
       TFR    D,X
       LDD    #$24E7
       STA    ZZ
       TFR    B,DP
       STX    BCKTEM+1
W2     LDD    ,X++
       STD    *+8
       LDB    #6
       STB    <$DB
       LDD    #0
       STB    <$DA
       STA    <$DA
RPF1   CMPX   #PALETS+72
       BEQ    *+4
       BRA    *+5
RPD1   LDX    #PALETS
       MUL
       NOP
       DEC    ZZ
       BNE    W2
       TST    <$C8
       BEQ    *+5
       JMP    RDP-4
       LDX    #2152
       LEAX   -1,X
       BNE    *-2
       TST    ,X+
       TST    ,X+
       LEAY   -1,Y
       BNE    W1
       LDD    #DIR
       TFR    B,DP
       LDX    W2-19
       LDD    BCKTEM-7
       CMPD   #ROT
       BEQ    *+5
       NOP
       BRA    *+4
       LEAX   2,X
       STX    BCKTM2+1
       LDX    <Z+1
       LEAX   3,X
       LDA    ,X
       LDB    #10
       LBRA   RENVOI
FIN    LDX    #TEXTE
       LDD    ,X
       LDB    #24
       LBRA   RENVOI
BANK4  LEAX   1,X
       LDD    #$405
       STA    BANK+1
       STB    BANK2+1
       LDD    ,X
       LDB    #21
       LBRA   RENVOI
BANK6  LEAX   1,X
       LDD    #$607
       STA    BANK+1
       STB    BANK2+1
       LDD    ,X
       LDB    #21
       LBRA   RENVOI
TEINTS LDD    1,X
       LEAX   3,X
       STX    RPD1+1
       STX    RPD2+1
       STX    RPD3+1
       STX    RPD4+1
       STX    RPD5+1
       STX    RPD6+1
       STX    BCKTM2+1
       STX    BCKTEM+1
       LEAX   D,X
       STX    RPF1+1
       STX    RPF2+1
       STX    RPF5+1
       STX    RPF6+1
       BRA    *+2
       LDA    ,X
       LDB    #6
       LBRA   RENVOI
SPEED8 LEAX   1,X
       LDD    #DEBUT
       STD    REVIT+1
       LDD    #$29F
       STA    REVIT-7
       STB    COGIT2+3
       LDD    #COGIT2
       STD    RENVOI+1
       LDD    #$10F
       STA    BANK+21
       STB    BANK+23
       LDD    #$C2A
       STA    BANK+30
       STB    BANK+34
       LDD    #$2000
       STD    RPD1+24
       LDA    #$84
       STA    RPD1+27
       LDD    #$6D83
       STD    RPD2+6
       LDA    #2
       STA    RPF2-1
       LDA    ,X
       LDB    #7
       JMP    COGITO
SPEED4 LEAX   1,X
       LDD    #REVIT+3
       STD    REVIT+1
       LDD    #$39E
       STA    REVIT-7
       STB    COGIT2+3
       LDD    #COGITO
       STD    RENVOI+1
       LDD    #13
       STA    BANK+21
       STB    BANK+23
       LDD    #$D20
       STA    BANK+30
       STB    BANK+34
       LDD    #$6D80
       STD    RPD1+24
       STD    RPD1+26
       LDD    #$C600
       STD    RPD2+6
       LDA    #1
       STA    RPF2-1
       INC    $E7E5
       LDD    ,X
       LDB    #7
       JMP    COGITO
RELIEF LDA    #2
       STA    $E7DB
       LDD    1,X
       STB    $E7DA
       STA    $E7DA
       LDD    3,X
       STB    $E7DA
       STA    $E7DA
       LEAX   5,X
       LDA    ,X
       LDB    #16
       LBRA   RENVOI
SPEPAL LDD    1,X
       STD    RPD1+1
       STD    RPD2+1
       STD    RPD3+1
       STD    RPD4+1
       STD    RPD5+1
       STD    RPD6+1
       STD    BCKTM2+1
       STD    BCKTEM+1
       LDD    3,X
       STD    RPF1+1
       STD    RPF2+1
       STD    RPF5+1
       STD    RPF6+1
       LEAX   5,X
       LDA    ,X
       LDB    #7
       LBRA   RENVOI

XCEPT  FDB    FIN,ONROT,OFROT,WAIT
       FDB    BANK4,BANK6,TEINTS
       FDB    SPEED8,SPEED4,RELIEF
       FDB    SPEPAL

RENVOI JMP    COGITO

       LDS    #0
RDP    LDA    #0
       TFR    A,DP
       CLR    $E7DD
       CLR    $E7DC
       LDA    #255
       LDX    #COLORS
       JSR    $EC00
       RTS

       FDB    $0010,$FFFF,$0100,$FFF0
       FDB    $0001,$0010,$FEF0
COLORS FDB    0,15,240,255,3840,3855
       FDB    4080,4095,1911,826,931
       FDB    938,2611,2618,3815,123

       END
