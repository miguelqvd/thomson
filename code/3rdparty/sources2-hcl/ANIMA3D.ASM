****************************************
*                                      *
*      3D fil de fer by Doctor Lô      *
*                                      *
***************31-10-90*****************
*             et 19-1-91               *
*         éditeur le 26-1-91           *
****************************************


TEXTE  EQU    $7200
OBJETS EQU    $7300
EXEC   EQU    $89E0
CENTRE EQU    $8A00
SINUS  EQU    $8E00
FONTES EQU    $9080
LINKS  EQU    $917A
CODE   EQU    $926A
DIR    EQU    $9E
Z      EQU    $D8
CORDOS EQU    $9F00
ECRAN  EQU    $C000-31*40
ECRTXT EQU    $DE7A   adresse à l'écran
HAUT   EQU    192
QUAD   EQU    128
NN     EQU    $8000   masque "non nul"


       ORG    EXEC    procédure d'appel
       ORCC   #80
       LDD    #$20E
       BSR    COPBNK
       JSR    G
       LDD    #$E02
COPBNK LDX    #$A000  copie de la bank 2
       STA    $E7E5   (basic) en bank 14
       LDU    ,X
       STB    $E7E5
       STU    ,X++
       CMPX   #$E000
       BLO    *-13
       RTS

       ORG    LINKS
       FDB    $25B,$B02,NN+12,ARETES
       FCB    11,12,1,12
       FDB    $373,$B00,0,COLOUR
       FCB    0,13,2,13
       FDB    $4E8,$200,0,SCROLL
       FCB    1,14,3,14
       FDB    $675,$800,OBJETS,NOBJ
       FCB    2,3,4,3
       FDB    $78D,$800,0,NOBJ
       FCB    3,15,5,4
       FDB    $8A5,$800,0,NOBJ
       FCB    4,16,6,15
       FDB    $9BD,$800,0,NOBJ
       FCB    5,17,7,16
       FDB    $AD5,$800,0,NOBJ
       FCB    6,7,8,17
       FDB    $BED,$800,0,NOBJ
       FCB    7,8,9,8
       FDB    $D80,$200,0,SCROLL
       FCB    8,9,10,9
       FDB    $151E,$A00,1,CENTR1
       FCB    9,10,11,10
       FDB    $1636,$A01,4,CENTR2
       FCB    10,18,0,11
       FDB    $274,$A03,511,ANGLES
       FCB    19,0,13,0
       FDB    $38C,$A03,511,ANGLES
       FCB    12,1,14,1
       FDB    $4A4,$A03,511,ANGLES
       FCB    13,2,15,2
       FDB    $7E8,$E03,511,SPEEDS
       FCB    14,5,16,4
       FDB    $900,$E03,511,SPEEDS
       FCB    15,6,17,5
       FDB    $A18,$E03,511,SPEEDS
       FCB    16,7,18,6
       FDB    $18F3,$A03,NN+999,WAITS
       FCB    17,18,19,11
       FDB    $1A0B,$A04,NN+9999,WAITS
       FCB    18,19,12,19

       ORG    CODE
G      LDA    #$E7
       EXG    A,DP
       LDB    <$E6
       STD    RDP+1
       LDA    #$60    écran $4000-$5F40
       STA    <$E6     (de l'éditeur)
       CLR    <$DC      en cartouche

       LDD    #32
       STA    <$DB
       STA    <$DA
       DECB
       BNE    *-3
       LDX    #MAP    décompacte image
       STX    $616B
       LDD    #$FF0E
       STA    $6249
       STB    $616D
       INCB
       STB    <$E5
       LDD    #$100
       STD    $61D6
       CLR    $6288
       LDB    #69
       JSR    $EC0C

       LDB    #2      copie fond éditeur
COPICT STB    <$E5      dans écran démo
       LDX    #$DF40
       CLR    ,-X
       CMPX   #$C000
       BNE    *-5
       LDX    #$A000
       LDU    #$2000
       LDA    ,U
       LDB    #40
       STA    ,X+
       DECB
       BNE    *-3
       LEAU   40,U
       CMPX   #$BF40
       BNE    *-15
       LDB    <$E5
       INCB
       CMPB   #4
       BNE    COPICT
       LDD    ,--U
       STD    ,--X
       CMPX   #$BDD8
       BNE    *-7
       LDX    #$DDD8
       LDU    #$1DD8
       LDD    ,U++
       STD    ,X++
       CMPX   #$DF40
       BNE    *-7
       LDX    #$DE7A
       LDY    #TEXTE
       LDB    ,Y+
       JSR    PUTC
       CMPX   #$DE9E
       BNE    *-8

       LDA    #DIR
       TFR    A,DP
       LDD    #TEXTE  initialisations
       STD    <Z+34
       LDD    #ECRTXT
       STD    <Z+36
       LDD    #100      latence du texte
       STD    WAITXT+1
       STD    <Z+32
       LDU    #OBJETS
       JSR    DEFOBJ
       LDA    #128
       STA    $E7DD
       LDA    #1
       LDX    #256
BLUES  TST    $E7E7   apparition 'fondu'
       BMI    *-3
       TST    $E7E7
       BPL    *-3
       TFR    A,B
       LEAY   ,X
       JSR    $EC00
       INCA
       CMPA   #7
       BNE    *-8
       TFR    B,A
       LEAX   256,X
       INCA
       CMPA   #7
       BNE    BLUES
       LDA    #15
       LDX    #-1
       LEAY   1,X
       JSR    $EC00
       STX    MAP-34
       LDX    #MAP-64
       LDA    #-1
       JSR    $EC00

       LDA    #$62    scroll de la barre
       STA    $E7E6
       LDX    #$3DFF-40
       STX    <Z
       LDA    #1
SONIA  STA    <Z+2
       TST    $E7E7
       BPL    *-3
       TST    $E7E7
       BMI    *-3
       LDB    #9
       STB    <Z+3
       LDU    #$BDD8-40
       STU    <Z+4
HELENE LDX    <Z
       LEAX   40,X
       STX    <Z
       LDU    <Z+4
       LEAU   40,U
       STU    <Z+4
       LDB    <Z+2
       LDA    ,U+
       STA    ,X+
       LDA    $1FFF,U
       STA    -$2001,X
       DECB
       BNE    *-13
       DEC    <Z+3
       BNE    HELENE
       LDX    <Z
       LEAX   -361,X
       STX    <Z
       LDA    <Z+2
       INCA
       CMPA   #41
       BNE    SONIA
       LDA    #$60
       STA    $E7E6

BIGBCL LDD    #$2C0   boucle principale
       STA    $E7E5
       STB    $E7DD
       BSR    IMAGE
       LDD    #$380
       STA    $E7E5
       STB    $E7DD
       BSR    IMAGE
       TST    $E7C8
       BEQ    BIGBCL
       JSR    $E806
       CMPB   #$99    sortie avec 'F10'
       LBNE   EDITOR

RDP    LDD    #0      retour au basic
       TFR    A,DP
       STB    $E7E6
       CLR    $E7DD
       LDX    #MAP-32
       LDA    #255
       JSR    $EC00
       RTS

IMAGE  STS    RS+2       génère un écran
       LDA    #HAUT/12-1
       STA    <Z
       LDU    #VIDE    effacement total
       PULU   D,X,Y,S
       LDU    #ECRAN+(HAUT+28)*40-8
RUB    FCC    /6v6v6v3P6v6v6v3P/
       FCC    /6v6v6v3P6v6v6v3P/
       FCC    /6v6v6v3P6v6v6v3P/
       FCC    /6v6v6v3P6v6v6v3P/
       FCC    /6v6v6v3P6v6v6v3P/
       FCC    /6v6v6v3P6v6v6v3P/
       DEC    <Z
       BNE    RUB
       FCC    /6v6v6v3P6v6v6v/

       LDX    <Z+32   affiche une lettre
       BEQ    *+8
       LEAX   -1,X
       STX    <Z+32
       BRA    FAFTEX
       LDY    <Z+34   où dans le texte
       LDB    ,Y
       LDA    #5
       MUL
       LDU    #FONTES
       LEAU   D,U
       LDX    <Z+36   position à l'écran
       PULU   D
       STA    -80,X
       STB    -40,X
       PULU   D
       STA    ,X
       STB    40,X
       LDA    ,U
       STA    80,X
       INC    <Z+31
       LDA    #1
       BITA   <Z+31
       BEQ    WAITXT+5
       LEAX   1,X
       LEAY   1,Y
       LDB    ,Y
       BPL    *+6
       LDY    #TEXTE
       CMPX   #ECRTXT+36
       BNE    *+10
       LDX    #ECRTXT
WAITXT LDD    #0
       STD    <Z+32
       STX    <Z+36
       STY    <Z+34

FAFTEX LDX    <Z+38
       LEAX   -1,X
       STX    <Z+38
       BNE    *+13
       LDX    <Z+29
       LDU    10,X
       LDS    RS+2
       JSR    DEFOBJ  objet suivant

       LDU    <Z+18
       LDA    ,U+     nbre de points
       STA    <Z+14
       LDS    #CORDOS
       LDX    <Z+27   abcisse du centre
       LDA    ,X
       ANDA   #7
       ADDA   #92
       STA    ABCENT+1
       LDB    ,X
       LSRB
       LSRB
       LSRB
VITCEN LEAX   7,X
       CMPX   #CENTRE+512
       BLO    *+6
       LEAX   -512,X
       STX    <Z+27
       LDX    #ECRAN
       ABX
       STX    LINE1-28
       STX    LINE2-26
       STX    LINE3-28
       STX    LINE4-26
       LDX    #ECRAN+(HAUT+22)*40+24
       ABX
       STX    RUB-2

**** rotation autour de (zz') ****
COORD  LDX    <Z+8    pointe sur cos (a)
       LDA    ,U      abcisse (X)
       LDB    ,X
       ANDA   #127
       ANDB   #127
       MUL
       STD    <Z+4     ABS ( X * cos a )
       LDA    ,U
       EORA   ,X
       BPL    *+9
       LDD    #0
       SUBD   <Z+4
       STD    <Z+4

       LDA    1,U     ordonnée (Y)
       LDB    QUAD,X
       ANDA   #127
       ANDB   #127
       MUL
       STD    <Z+6     ABS ( Y * sin a )
       LDA    1,U
       EORA   QUAD,X
       BPL    *+9
       LDD    #0
       SUBD   <Z+6
       STD    <Z+6

       LDD    <Z+4
       SUBD   <Z+6
       ASLB
       ROLA
       BCC    *+11
       STD    <Z+4
       LDD    #0
       SUBD   <Z+4
       ORA    #128
       STA    <Z      X' = Xcosa - Ysina

       LDA    ,U      abcisse (X)
       LDB    QUAD,X
       ANDA   #127
       ANDB   #127
       MUL
       STD    <Z+4     ABS ( X * sin a )
       LDA    ,U+
       EORA   QUAD,X
       BPL    *+9
       LDD    #0
       SUBD   <Z+4
       STD    <Z+4

       LDA    ,U      ordonnée (Y)
       LDB    ,X
       ANDA   #127
       ANDB   #127
       MUL
       STD    <Z+6     ABS ( Y * cos a )
       LDA    ,U+
       EORA   ,X
       BPL    *+9
       LDD    #0
       SUBD   <Z+6
       STD    <Z+6

       LDD    <Z+4
       ADDD   <Z+6
       ASLB
       ROLA
       BCC    *+11
       STD    <Z+4
       LDD    #0
       SUBD   <Z+4
       ORA    #128
       STA    <Z+1    Y' = Xsina + Ycosa

**** rotation autour de (yy') ****

       LDX    <Z+10   pointe sur cos (b)
       LDA    ,U      cote (Z)
       LDB    ,X
       ANDA   #127
       ANDB   #127
       MUL
       STD    <Z+4     ABS ( Z * cos b )
       LDA    ,U
       EORA   ,X
       BPL    *+9
       LDD    #0
       SUBD   <Z+4
       STD    <Z+4

       LDA    <Z      abcisse (X)
       LDB    QUAD,X
       ANDA   #127
       ANDB   #127
       MUL
       STD    <Z+6     ABS ( X * sin b )
       LDA    <Z
       EORA   QUAD,X
       BPL    *+9
       LDD    #0
       SUBD   <Z+6
       STD    <Z+6

       LDD    <Z+4
       SUBD   <Z+6
       ASLB
       ROLA
       BCC    *+11
       STD    <Z+4
       LDD    #0
       SUBD   <Z+4
       ORA    #128
       STA    <Z+15   Z' = Zcosb - Xsinb

       LDA    ,U      cote (Z)
       LDB    QUAD,X
       ANDA   #127
       ANDB   #127
       MUL
       STD    <Z+4     ABS ( Z * sin b )
       LDA    ,U+
       EORA   QUAD,X
       BPL    *+9
       LDD    #0
       SUBD   <Z+4
       STD    <Z+4

       LDA    <Z      abcisse (X)
       LDB    ,X
       ANDA   #127
       ANDB   #127
       MUL
       STD    <Z+6     ABS ( X * cos b )
       LDA    <Z
       EORA   ,X
       BPL    *+9
       LDD    #0
       SUBD   <Z+6
       STD    <Z+6

       LDD    <Z+4
       ADDD   <Z+6
       ASLB
       ROLA
       BCC    *+11
       STD    <Z+4
       LDD    #0
       SUBD   <Z+4
       ORA    #128
       STA    <Z+16   X' = Zsinb + Xcosb

**** rotation autour de (xx') ****

       LDX    <Z+12   pointe sur cos (c)
       LDA    <Z+1    ordonnée (Y)
       LDB    ,X
       ANDA   #127
       ANDB   #127
       MUL
       STD    <Z+4     ABS ( Y * cos c )
       LDA    <Z+1
       EORA   ,X
       BPL    *+9
       LDD    #0
       SUBD   <Z+4
       STD    <Z+4

       LDA    <Z+15   cote (Z)
       LDB    QUAD,X
       ANDA   #127
       ANDB   #127
       MUL
       STD    <Z+6     ABS ( Z * sin c )
       LDA    <Z+15
       EORA   QUAD,X
       BPL    *+9
       LDD    #0
       SUBD   <Z+6
       STD    <Z+6

       LDD    <Z+4
       SUBD   <Z+6
       ASLB
       ROLA
       BCC    *+11
       STD    <Z+4
       LDD    #0
       SUBD   <Z+4
       ORA    #128
       STA    <Z+17   Y' = Ycosc - Zsinc

       LDD    <Z+16
       ANDA   #127
       CMPA   <Z+16
       BEQ    *+3
       NEGA
ABCENT ADDA   #0      x centre écran
       ANDB   #127
       CMPB   <Z+17
       BEQ    *+3
       NEGB
       ADDB   #124    y centre écran

       STD    ,S++    remplit table des
       DEC    <Z+14   coordonnées écran
       LBNE   COORD
RS     LDS    #0

       LDA    <Z+26   nbre de segments
       STA    <Z+14
       LDY    #VIDE-8
TRACE  LDX    #CORDOS
       LDB    ,U+
       LDD    B,X
       STD    <Z+6
       LDB    ,U+
       LDD    B,X     trace les segments
       BSR    DRAW     entre différentes
       DEC    <Z+14   coordonnées écran
       BNE    TRACE

       LDD    <Z+8
       ADDD   <Z+20
       CMPD   #SINUS+4*QUAD
       BLO    *+5
       SUBD   #4*QUAD
       STD    <Z+8
       LDD    <Z+10
       ADDD   <Z+22
       CMPD   #SINUS+4*QUAD
       BLO    *+5
       SUBD   #4*QUAD
       STD    <Z+10
       LDD    <Z+12
       ADDD   <Z+24
       CMPD   #SINUS+4*QUAD
       BLO    *+5
       SUBD   #4*QUAD
       STD    <Z+12
       RTS


DRAW   STD    <Z+4
       CMPA   <Z+6    si x1 > x2 alors
       BLS    *+10      permutation
       LDX    <Z+6
       STX    <Z+4
       STD    <Z+6
       LDB    <Z+5

       CMPB   <Z+7
       LBHI   MONTEE  quand y1 < y2

       LDD    <Z+6
       SUBA   <Z+4    A = (dx)
       STA    <Z+1
       SUBB   <Z+5    B = (dy)
       CMPB   <Z+1
       LBHI   VERTI1  quand (dy) > (dx)

       TFR    B,A
       CLRB           (dy) / (dx) = 0.?
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #128
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #64
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #32
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #16
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #8
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #4
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #2
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #1
       STB    MMSEG1+1

       LDX    #ECRAN
       LDA    #40
       LDB    <Z+5
       MUL
       LEAX   D,X
       LDB    <Z+4
       LSRB
       LSRB
       LSRB
       ABX
       LDB    <Z+4
       ANDB   #7
       LDA    B,Y
       STA    <Z
       INC    <Z+1
       CLRB

       LDA    ,X
LINE1  ORA    <Z
       DEC    <Z+1
       BNE    *+5
       STA    ,X
       RTS
       LSR    <Z
       BNE    MMSEG1
       ROR    <Z
       STA    ,X+
       LDA    ,X
MMSEG1 ADDB   #0
       BCC    LINE1
       STA    ,X
       LEAX   40,X
       BRA    LINE1-2

VERTI1 STB    <Z+1
       CLRB           (dx) / (dy) = 0.?
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #128
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #64
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #32
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #16
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #8
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #4
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #2
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #1
       STB    VIRG1+1

       LDX    #ECRAN
       LDA    #40
       LDB    <Z+5
       MUL
       LEAX   D,X
       LDB    <Z+4
       LSRB
       LSRB
       LSRB
       ABX
       LDB    <Z+4
       ANDB   #7
       LDA    B,Y
       STA    <Z
       INC    <Z+1
       CLRB

LINE2  LDA    ,X
       ORA    <Z
       STA    ,X
       LEAX   40,X
       DEC    <Z+1
       BNE    *+3
       RTS
VIRG1  ADDB   #0
       BCC    LINE2
       LSR    <Z
       BNE    LINE2
       ROR    <Z
       LEAX   1,X
       BRA    LINE2

MONTEE LDD    <Z+6
       SUBA   <Z+4    A = (dx)
       STA    <Z+1
       LDB    <Z+5
       SUBB   <Z+7    B = (dy)
       CMPB   <Z+1
       LBHI   VERTI2  quand (dy) > (dx)

       TFR    B,A
       CLRB           (dy) / (dx) = 0.?
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #128
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #64
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #32
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #16
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #8
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #4
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #2
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #1
       STB    MMSEG2+1

       LDX    #ECRAN
       LDA    #40
       LDB    <Z+5
       MUL
       LEAX   D,X
       LDB    <Z+4
       LSRB
       LSRB
       LSRB
       ABX
       LDB    <Z+4
       ANDB   #7
       LDA    B,Y
       STA    <Z
       INC    <Z+1
       CLRB

       LDA    ,X
LINE3  ORA    <Z
       DEC    <Z+1
       BNE    *+5
       STA    ,X
       RTS
       LSR    <Z
       BNE    MMSEG2
       ROR    <Z
       STA    ,X+
       LDA    ,X
MMSEG2 ADDB   #0
       BCC    LINE3
       STA    ,X
       LEAX   -40,X
       BRA    LINE3-2

VERTI2 STB    <Z+1
       CLRB           (dx) / (dy) = 0.?
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #128
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #64
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #32
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #16
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #8
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #4
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #2
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #1
       STB    VIRG2+1

       LDX    #ECRAN
       LDA    #40
       LDB    <Z+5
       MUL
       LEAX   D,X
       LDB    <Z+4
       LSRB
       LSRB
       LSRB
       ABX
       LDB    <Z+4
       ANDB   #7
       LDA    B,Y
       STA    <Z
       INC    <Z+1
       CLRB

LINE4  LDA    ,X
       ORA    <Z
       STA    ,X
       LEAX   -40,X
       DEC    <Z+1
       BNE    *+3
       RTS
VIRG2  ADDB   #0
       BCC    LINE4
       LSR    <Z
       BNE    LINE4
       ROR    <Z
       LEAX   1,X
       BRA    LINE4

       FDB    $8040,$2010,$0804,$0201
VIDE   FDB    0,0,0,0

DEFOBJ STU    <Z+29
       LDX    12,U    couleur de l'objet
       LEAY   ,X
       LDA    #15
       JSR    $EC00
       LDX    #CENTRE
       LDA    14,U
       BMI    *+5
       LDX    #CENTRE+512
       STX    <Z+27    type déplacement
       LEAX   512,X
       STX    VITCEN+3      et
       ANDA   #127
       STA    VITCEN+1 vitesse du centre
       LEAU   15,U
       PULU   D,X,Y
       STD    <Z+8    angle A
       STX    <Z+10   angle B
       STY    <Z+12   angle C
       PULU   D,X,Y
       STD    <Z+20   vit-A
       STX    <Z+22   vit-B
       STY    <Z+24   vit-C
       LDA    ,U+
       STA    <Z+26   nombre de segments
       PULU   X
       STX    <Z+38   attente objet
       STU    <Z+18
NEWSCR BSR    VIDECR
       LDA    $E7E5
       EORA   #1
       STA    $E7E5
       BSR    VIDECR
       LDA    $E7E5
       EORA   #1
       STA    $E7E5
       RTS

VIDECR STS    EDITOR-3
       LDA    #HAUT/12-1
       STA    <Z
       LDU    #VIDE
       PULU   D,X,Y,S
       LDU    #ECRAN+(HAUT+28)*40
KILALL FCC    /6v6v6v6v6v6v6v6v6v6v/
       FCC    /6v6v6v6v6v6v6v6v6v6v/
       FCC    /6v6v6v6v6v6v6v6v6v6v/
       FCC    /6v6v6v6v6v6v6v6v6v6v/
       FCC    /6v6v6v6v6v6v6v6v6v6v/
       FCC    /6v6v6v6v6v6v6v6v6v6v/
       DEC    <Z
       BNE    KILALL
       FCC    /6v6v6v6v6v6v6v6v6v6v/
       LDS    #0
       RTS

EDITOR LDA    #$C0
       STA    $E7DD
       LDX    #$2000  couleur Editeur
       LDA    ,X+
       ANDA   #120
       CMPA   #56
       BNE    *+10
       LDA    $9FFF,X forme Démo
       STA    $DFFF,X forme Editeur
       CMPX   #$3DD8
       BNE    EDITOR+8
       LDA    #10
       STA    <Z+6
       LDX    #$274   angles
       LDU    <Z+12
       LEAU   -SINUS,U
       LDA    #3
       JSR    WRITE
       LDX    #$38C
       LDU    <Z+10
       LEAU   -SINUS,U
       LDA    #3
       JSR    WRITE
       LDX    #$4A4
       LDU    <Z+8
       LEAU   -SINUS,U
       LDA    #3
       JSR    WRITE
       LDX    #$18F3  attentes
       LDU    <Z+32
       LDA    #3
       JSR    WRITE
       LDX    #$1A0B
       LDU    <Z+38
       LDA    #4
       JSR    WRITE
       LDX    #$1636  vitesse centre
       LDB    VITCEN+1
       CLRA
       TFR    D,U
       LDA    #1
       JSR    WRITE
       INC    <Z+6
       LDX    #$25B   nombre de segments
       LDB    <Z+26
       CLRA
       TFR    D,U
       LDA    #2
       JSR    WRITE
       LDU    <Z+18
       LDB    -3,U
       STB    LINKS+5
       LDB    #14
       STB    <Z+6
       LDX    #$7E8   vitesses rotation
       LDU    <Z+24
       LDA    #3
       JSR    WRITE
       LDX    #$900
       LDU    <Z+22
       LDA    #3
       JSR    WRITE
       LDX    #$A18
       LDU    <Z+20
       LDA    #3
       JSR    WRITE
       LDX    #$151F  type dplcmt centre
       LDY    #CENTR2-19
       CLR    LINKS+125
       LDU    VITCEN+3
       CMPU   #CENTRE+512
       BEQ    *+7
       INC    LINKS+125
       LEAY   10,Y
       LDB    ,Y+
       BMI    *+7
       JSR    PUTC
       BRA    *-7
       LDX    #$48B   objet courant
       LDY    <Z+29
       LDB    ,Y+
       JSR    PUTC
       CMPX   #$493
       BNE    *-8
       LDX    #$675   liste objets
       LDY    #LINKS+40
       LDU    ,Y
       STS    ZEBEST+2
       LDA    #6
       STA    <Z+1
       STU    ,Y
       LDA    #8
       STA    <Z
NOMOBJ LDB    ,U+
       LDS    #FONTES
       LDA    #5
       MUL
       LEAS   D,S
       PULS   D
       STA    -80,X
       STB    -40,X
       PULS   D
       STA    ,X+
       STB    39,X
       LDA    ,S
       STA    79,X
       DEC    <Z
       BNE    NOMOBJ
       LEAX   272,X
       LEAY   12,Y
       LDU    2,U
       DEC    <Z+1
       BNE    NOMOBJ-6
ZEBEST LDS    #0
       LDA    #15
       LDX    #-1
       LEAY   1,X
       JSR    $EC00
       STX    <Z
       LDX    #$37B   palette
       LDB    <Z
       ANDB   #15
       ADDB   #12
       JSR    PUTC
       LDB    <Z+1
       LSRB
       LSRB
       LSRB
       LSRB
       ADDB   #12
       JSR    PUTC
       LDB    <Z+1
       ANDB   #15
       ADDB   #12
       JSR    PUTC
       CLR    $E7DD
       LDB    #0
       STB    <Z+14
       LDA    <Z+14
ARROWS LDY    #LINKS
       STA    <Z+14
       LDB    #12
       MUL
       LEAY   D,Y
       LDX    ,Y
       LDA    2,Y
       STA    <Z+6
       BSR    INVERS
       LDA    <Z+6
CLAV   JSR    $E806
       CMPB   #13
       BNE    NOEXIT
       BSR    INVERS
       LDA    3,Y
       BEQ    NOEXIT-3
       LDX    ,Y
       LDU    4,Y
       JSR    READ
       JMP    [6,Y]
NOEXIT CMPB   #2
       BNE    *+15
       LDB    <Z+14
       STB    ARROWS-5
       BSR    INVERS
       JSR    NEWSCR
       JMP    BIGBCL
       SUBB   #8
       CMPB   #3
       BHI    CLAV
       BSR    INVERS
       TSTB
       BNE    *+6
       LDA    11,Y
       BRA    ARROWS
       CMPB   #1
       BNE    *+6
       LDA    9,Y
       BRA    ARROWS
       CMPB   #2
       BNE    *+6
       LDA    10,Y
       BRA    ARROWS
       LDA    8,Y
       BRA    ARROWS

INVERS PSHS   X
       TST    $E7E7
       BPL    *-3
       TST    $E7E7
       BMI    *-3
       COM    -120,X
       COM    -80,X
       COM    -40,X
       COM    ,X+
       COM    39,X
       COM    79,X
       COM    119,X
       DECA
       BNE    INVERS+12
       PULS   X,PC

COLOUR LDX    #$37E
       LDA    #3
       LEAX   -1,X
       CLRB
       STB    -80,X
       STB    -40,X
       STB    ,X
       STB    40,X
       LDB    #127
       STB    80,X
       DECA
       BNE    COLOUR+5
       LDY    #DIR*256+Z
GETKEY JSR    $E806
       SUBB   #48
       CMPB   #10
       BLO    *+12
       SUBB   #7
       CMPB   #10
       BLO    GETKEY
       CMPB   #15
       BHI    GETKEY
       STB    ,Y+
       ADDB   #12
       JSR    PUTC
       CMPY   #DIR*256+Z+3
       BNE    GETKEY
       LDB    <Z+1
       ASLB
       ASLB
       ASLB
       ASLB
       ADDB   <Z+2
       LDA    <Z
       TFR    D,X
       LEAY   ,X
       LDA    #15
       JSR    $EC00
       JMP    ARROWS-2
NOBJ   LDU    4,Y
       JSR    DEFOBJ
       JMP    BIGBCL
SCROLL LDX    #$675
       LDY    #LINKS+3*12+4
       STS    ARETES-5
       LDA    <Z+14
       LDS    ,Y      premier actuel
       LDU    8,S        précédent
       CMPA   #9
       BNE    *+4
       LDU    10,S        suivant
       LDA    #6
       STA    <Z+1
       TST    $E7E7
       BPL    *-3
       TST    $E7E7
       BMI    *-3
       STU    ,Y
       LDA    #8
       STA    <Z
AFNAME LDB    ,U+
       LDS    #FONTES
       LDA    #5
       MUL
       LEAS   D,S
       PULS   D
       STA    -80,X
       STB    -40,X
       PULS   D
       STA    ,X+
       STB    39,X
       LDA    ,S
       STA    79,X
       DEC    <Z
       BNE    AFNAME
       LEAX   272,X
       LEAY   12,Y
       LDU    2,U
       DEC    <Z+1
       BNE    AFNAME-6
       LDS    #0
       JMP    ARROWS-2
ARETES STB    <Z+26
       JMP    ARROWS-2
WAITS  TFR    D,U
       LDA    <Z+14
       CMPA   #19
       BNE    *+7
       STU    <Z+38
       JMP    ARROWS
       LDX    <Z+32
       BEQ    *+4
       STU    <Z+32
       STU    WAITXT+1
       JMP    ARROWS
CENTR1 INC    5,Y
       LDA    5,Y
       LDY    #CENTR2-19
       LDU    #CENTRE
       LEAX   1,X
       BITA   #1
       BEQ    *+7
       LEAY   10,Y
       LDU    #CENTRE+512
       STU    <Z+27
       LEAU   512,U
       STU    VITCEN+3
       TST    $E7E7
       BPL    *-3
       TST    $E7E7
       BMI    *-3
       LDB    ,Y+
       BMI    *+7
       JSR    PUTC
       BRA    *-7
       JMP    ARROWS-2
       FCB    37,30,35,28,0,37,36,35,28
       FCB    $F7     pingpong/sinusoïde
       FCB    40,30,35,42,40,36,30,25,26
CENTR2 STB    VITCEN+1
       JMP    ARROWS-2
ANGLES LDU    #SINUS
       LEAU   D,U
       LDB    <Z+14
       ASLB
       NEGB
       SUBB   #220
       LDX    #DIR*256+Z
       ABX
       STU    ,X
       JMP    ARROWS-2
SPEEDS TFR    D,U
       LDB    <Z+14
       ASLB
       NEGB
       SUBB   #202
       LDX    #DIR*256+Z
       ABX
       STU    ,X
       JMP    ARROWS-2

PUTC   LDU    #FONTES
       LDA    #5
       MUL
       LEAU   D,U
       PULU   D
       STA    -80,X
       STB    -40,X
       PULU   D
       STA    ,X+
       STB    39,X
       LDA    ,U
       STA    79,X
       RTS

READ   PSHS   X,Y
       STA    <Z+7
       STU    <Z
       LDB    <Z+6
       ABX
EFF    LEAX   -1,X
       CLRB
       STB    -80,X
       STB    -40,X
       STB    ,X
       STB    40,X
       LDB    #127
       STB    80,X
       DECA
       BNE    EFF

       CLR    <Z+2
       CLR    <Z+3
       CLR    <Z+4
       LDY    #DIR*256+Z
       LDA    #6
       SUBA   <Z+7
       LEAY   A,Y
INKEY  JSR    $E806
       SUBB   #48
       CMPB   #9
       BHI    INKEY
       STB    ,Y+
       ADDB   #12
       JSR    PUTC
       CMPY   #DIR*256+Z+6
       BNE    INKEY

       LDA    <Z+2
       LDB    #10
       MUL
       ADDB   <Z+3
       LDA    #100
       MUL
       STD    <Z+2
       LDA    <Z+4
       LDB    #10
       MUL
       ADDB   <Z+5
       ADDD   <Z+2
       STD    <Z+2

       LDD    <Z
       BITA   #128
       BEQ    *+10
       ANDA   #127    si nul -> égal à 1
       LDX    <Z+2
       BNE    *+4
       INC    <Z+3
       CMPD   <Z+2
       BHI    *+4
       STD    <Z+2
       PULS   X,Y
       LDU    <Z+2
       LDA    <Z+7

WRITE  PSHS   X,Y
       STU    <Z
       CLR    <Z+2
       CLR    <Z+3
       CLR    <Z+4
       STA    <Z+7
       TFR    U,D
MIL    CMPD   #1000
       BLO    CENT
       SUBD   #1000
       INC    <Z+2
       BRA    MIL
CENT   CMPD   #100
       BLO    DIX
       SUBD   #100
       INC    <Z+3
       BRA    CENT
DIX    CMPB   #10
       BLO    *+8
       SUBB   #10
       INC    <Z+4
       BRA    DIX
       STB    <Z+5

       LDB    <Z+6
       SUBB   <Z+7
       ABX
       LDY    #DIR*256+Z
       LDA    #6
       SUBA   <Z+7
       LEAY   A,Y
       LDB    ,Y
       BNE    ECHO
       CMPY   #DIR*256+Z+5
       BEQ    ECHO
       JSR    PUTC
       LEAY   1,Y
       BRA    *-15
ECHO   LDB    ,Y+
       ADDB   #12
       JSR    PUTC
       CMPY   #DIR*256+Z+6
       BNE    *-11
       LDD    <Z
       PULS   PC,X,Y

       FDB    0,256,512,768,$400,$500
       FDB    $600,273,546,819,239,207
       FDB    175,143,111,4095
       FDB    0,15,240,255,3840
       FDB    3855,4080,4095,1911,826
       FDB    931,938,2611,2618,3815,123
MAP
       END
