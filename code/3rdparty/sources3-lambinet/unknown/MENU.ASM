

*****  ENTETE  *****

*****  EQUATES  ****

T      EQU    $B800

COMPT  EQU    T
COMPTL EQU    T+1
COMPT1 EQU    T+2
COMPT2 EQU    T+3
GECAR  EQU    T+4
FLACLI EQU    T+6

*****  PROGRAMME  **

       ORG    $C000
G      LDX    #$9E00
       STX    GECAR
       LDX    #PARAM
       LDA    ,X+
PUTC   LDB    ,X+
       JSR    $E803
       DECA
       BNE    PUTC
       LDA    $E7C3
       ORA    #1
       STA    $E7C3
       PSHS   X
       CLR    FLACLI
       LDX    #$4000
       LDB    #80
       BSR    GRAND
       LEAX   -1,X
       BSR    P0
       LEAX   159,X
       LDD    #$38FF
       BSR    P1
       LEAX   2079,X
       BSR    P0
       LEAX   -1,X
       LDB    #79
       BSR    GRAND
       LDD    #$08FF
       BSR    P1
       LDB    #49
       LEAX   -1,X
       BSR    GRAND
       BRA    AT0

GRAND  BSR    ADRCAR
OCT    LDA    ,Y+
       LDB    #4
       STB    COMPT
NOCT   CLRB
       ROLA
       BCC    PB1
       ORB    #$F0
PB1    ROLA
       BCC    PB0
       ORB    #$F
PB0    STB    $78,X
       STB    $50,X
       STB    $28,X
       STB    ,X+
       DEC    COMPT
       BNE    NOCT
       LEAX   156,X
       DEC    COMPTL
       BNE    OCT
       LEAX   -476,X
       RTS

P0     LDD    #$080F
       BSR    P1
       LEAX   2079,X
       LDD    #$08F0
       BRA    P1
P1     STB    ,X
       LEAX   40,X
       DECA
       BNE    P1
       LEAX   -2398,X
       RTS

ADRCAR LDA    #16
       STA    COMPTL
       MUL
       ADDD   GECAR
       TFR    D,Y
       RTS

AT0    LDY    #$403A
       LDD    #$14EB
       LBSR   CADRE
       PULS   U
AT3    LDA    ,U+
       BEQ    AT5
       STA    COMPT
       LDX    ,U++
AT4    LDB    ,U+
       BSR    PETIT
       DEC    COMPT
       BNE    AT4
       BRA    AT3
PETIT  BSR    ADRCAR
MO1    LDB    ,Y+
       STB    ,X
       LEAX   40,X
       DEC    COMPTL
       BNE    MO1
       LEAX   -639,X
       RTS
AT5    LDA    ,U+
       BEQ    AT9
       STA    COMPT
       LDX    ,U++
AT6    CLR    FLACLI
       LDB    ,U+
       CMPB   #73
       BNE    AT65
       COM    FLACLI
AT65   CMPB   #46
       BEQ    AT7
MOYEN  LBSR   ADRCAR
M0     LDA    ,Y+
       STA    COMPT1
       LDA    #8
       STA    COMPT2
       CLRA
       CLRB
M1     ROL    COMPT1
       BCC    M2
       ROLB
       ORA    #$80
       ROLA
       ROLB
       ROLA
       BRA    M3
M2     LSLB
       ROLA
       LSLB
       ROLA
M3     DEC    COMPT2
       BNE    M1
       TST    FLACLI
       BNE    M4
       ANDB   #$FE
       STD    ,X
       BRA    M5
M4     RORA
       RORB
       RORA
       RORB
       RORA
       RORB
       ANDB   #$FC
       STB    ,X
M5     LEAX   40,X
       DEC    COMPTL
       BNE    M0
       TST    FLACLI
       BNE    M6
       LEAX   -638,X
       BRA    AT8
M6     LEAX   -639,X
       BRA    AT8
AT7    LBSR   PETIT
AT8    DEC    COMPT
       BNE    AT6
       BRA    AT5

AT9    LDY    #$4FA4
       LDD    #$1EE1
       BSR    CADRE
       BRA    AT10


CADRE  STB    COMPT
       LDB    #$3F
       STB    -40,Y
       STB    $C30,Y
       LDB    #$7F
       STB    $C08,Y
       STB    ,Y+
       LDB    #$FF
CA0    STB    $C30,Y
       STB    $C08,Y
       STB    -40,Y
       STB    ,Y+
       DECA
       BNE    CA0
       LDD    #$FCFE
       STA    -40,Y
       STA    $C30,Y
       STB    $C08,Y
       STB    ,Y
       LDX    #76
       LDB    COMPT
CA1    LEAY   40,Y
       LDA    #$C0
       STA    B,Y
       LDA    #3
       STA    ,Y
       LEAX   -1,X
       BNE    CA1
       RTS

AT10   CLR    FLACLI
       LDA    $E7C3
       ANDA   #$FE
       STA    $E7C3
CM1    LDU    #$5BFC
       LDA    #$F6
       COM    FLACLI
       BNE    CM2
       LDA    #$CB
CM2    TFR    A,B
       TFR    D,X
       TFR    D,Y
       LDA    #80
CM3    LEAU   -8,U
       LDB    #8
CM4    PSHU   X,Y
       DECB
       BNE    CM4
       DECA
       BNE    CM3
       TST    FLACLI
       BNE    CM5
       LDA    #$CE
       STA    ,U
       STA    31,U
       STA    40,U
       STA    71,U
       LEAU   $C30,U
       STA    ,U
       STA    31,U
       STA    40,U
       STA    71,U
CM5    LDX    #$2000
       ANDCC  #$FE
CM6    LEAX   -1,X
       BEQ    CM1
       JSR    $E809
       BCC    CM6
       JSR    $E806
       TSTB
       BEQ    CM6
       CMPB   #49
       LBEQ   EDIT    DIFFUSION
       CMPB   #51
       LBEQ   EDIT    GRAPHISME
       CMPB   #50
       BNE    CM6
EDIT   NOP

FINAL  LDB    #$1B
       JSR    $E803
       LDB    #$60
       JSR    $E803
K      NOP
PARAM  FCB    13,27,68,27,86,27,102,31
       FCB    18,20,31,32,32,12
       FCB    20,$41,$7B
       FCC    "Association pour les"
       FCB    18,$45,$3C
       FCC    "Services  Connexes"
       FCB    16,$48,$FD,132
       FCC    " l'Informatique"
       FCB    12,$4A,$03
       FCC    "Version 1.02"
       FCB    40,$4C,$80
       FCC    "Publicit"
       FCB    133
       FCC    " et Information par "
       FCC    "Ordinateur."
       FCB    40,$5C,$C0
       FCC    "ASCI Association loi 190"
       FCC    "1 Copyright 1989"
       FCB    0,20,$50,$E6
       FCC    "DIFFUSION..........1"
       FCB    22,$54,$A6
       FCC    "EDITION..............2"
       FCB    19,$58,$66
       FCC    "GRAPHISME.........3"
       FCB    0



       END
