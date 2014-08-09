****************************************
*    scrolling segment par segment.    *
****************************************
*      EN MODE BITMAP 16 COULEURS      *
****************************************
* This masterpiece was of course coded *
*         BY DOCTOR LO OF HCL          *
****** un soir d'ennui profond... ******

FONTE  EQU    -HAUT*LONG*2
RAMA   EQU    $DF18-HAUT*40
RAMB   EQU    RAMA-$2000
HAUT   EQU    48      multiple de 8 !
LONG   EQU    5       segments par CHR$
DIR    EQU    $9F     } début buffer
Z      EQU    0       } à accès direct
CARTOU EQU    15      page $0000-$3FFF

       ORG    DIR*256+Z
       FDB    1,TEXTE,FONTE

       ORG    $9800
G      ORCC   #80
       LDA    #$E7
       EXG    A,DP
       LDB    <$E6
       STA    RDP+1
       STB    RDP+2
       STS    RDP-2

       LDA    #123
       STA    <$DC
       LDD    #$360+CARTOU
       STD    <$E5
       LDD    #0
       LDX    #$A000
       STD    ,X++
       CMPX   #$E000
       BNE    *-5
       LDD    #$C000+DIR
       STA    <$DD
       TFR    B,DP


SYNCRO TST    $E7E7
       BPL    *-3
       TST    $E7E7
       BMI    *-3

       LDD    #15
       STA    $E7DB   pour voir le temps
       STB    $E7DA    CPU qu'il reste.
       STA    $E7DA

       LDX    #RAMA+160
       LDU    <Z+4
       LDA    #HAUT/8
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
       PULU   D
       STA    120,X
       STB    160,X
       LEAX   280,X
       DEC    <Z
       BNE    COPYA
       PULU   D
       STU    <Z+4

       LDA    #HAUT
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
       CLR    RAMA+HAUT*40

       LDX    #RAMB+160
       LDU    <Z+4
       LDA    #HAUT/8
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
       PULU   D
       STA    120,X
       STB    160,X
       LEAX   280,X
       DEC    <Z
       BNE    COPYB
       STU    <Z+4

       LDA    #HAUT
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
       CLR    RAMB+HAUT*40

       LDD    #0
       STA    $E7DB   pour voir le temps
       STB    $E7DA    CPU qu'il reste.
       STA    $E7DA

       TST    $E7C8
       BNE    RDP-4
       DEC    <Z+1
       LBNE   SYNCRO

       LDA    #LONG
       STA    <Z+1
       LDX    <Z+2    lettre suivante
       LDA    ,X+
       BNE    *+7
       LDA    #38
       LDX    #TEXTE
       LDU    #FONTE
       LDB    #HAUT*LONG
       ASLA
       MUL
       LEAU   D,U
       STU    <Z+4
       STX    <Z+2
       JMP    SYNCRO

       LDS    #0
RDP    LDD    #0
       TFR    A,DP
       STB    $E7E6
       CLR    $E7DD
       CLR    $E7DC
       LDA    #255
       LDX    #COLORS
       JSR    $EC00
       SWI

COLORS FDB    0,15,240,255,3840,3855
       FDB    4080,4095,1911,826,931
       FDB    938,2611,2618,3815,123
TEXTE

       END
