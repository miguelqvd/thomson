****************************************
*   SCROLLTEXT EN BITMAP 16 COULEURS   *
****************************************
* Les autres scrolls peuvent toujours  *
* scroller, Doc Lô reste intouchable ! *
****************************************

FONTE  EQU    -HAUT*LONG*2
RAMA   EQU    $DF18-HAUT*40
RAMB   EQU    RAMA-$2000
HAUT   EQU    44      multiple de 7 ! +2
LONG   EQU    5       segments par CHR$
DIR    EQU    $9F     } début buffer
Z      EQU    0       } à accès direct
CARTOU EQU    15      page $0000-$3FFF

       ORG    DIR*256+Z
       FDB    1,TEXTE,FONTE

       ORG    $9800
G      ORCC   #80
       LDA    #DIR
       EXG    A,DP
       LDB    $E7E6
       STA    RDP+1
       STB    RDP+2
       STS    RDP-2

       LDA    #123
       STA    $E7DC
       LDD    #$260+CARTOU
       STD    $E7E5
       LDD    #0
       LDX    #$A000
       STD    ,X++
       CMPX   #$E000
       BNE    *-5
       INC    $E7E5
       STD    ,--X
       CMPX   #$A000
       BNE    *-5
       LDA    #255
       LDX    #COLORS+32
       JSR    $EC00

SYNCRO TST    $E7E7
       BPL    *-3
       TST    $E7E7
       BMI    *-3
       LDD    #$380
       STA    $E7E5   premier écran
       STB    $E7DD

       LDX    #RAMA+160
       LDU    <Z+4
       LDA    #HAUT/7
       STA    <Z
COPYA1 PULU   D
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
       BNE    COPYA1
       PULU   D
       STA    -120,X
       STB    -80,X
       STU    <Z+4

       LDA    #HAUT
       STA    <Z
       LDU    #RAMA+1
SCRLA1 PULU   D,X,Y,S
       LEAU   -1,U
       PSHU   S,Y,X,D
       LEAU   9,U
       FDB    $3776,$335F,$3676,$3349
       FDB    $3776,$335F,$3676,$3349
       FDB    $3776,$335F,$3676,$3349
       FDB    $3776,$335F,$3676,$3349
       DEC    <Z
       BNE    SCRLA1
       CLR    RAMA+HAUT*40

       DEC    <Z+1
       BNE    MEMLET

       LDA    #LONG
       STA    <Z+1
       LDX    <Z+2
       LDA    ,X+     lettre suivante
       BNE    *+7
       LDX    #TEXTE
       LDA    ,X+
       LDU    #FONTE
       LDB    #HAUT*LONG
       ASLA
       MUL
       LEAU   D,U
       STU    <Z+4
       STX    <Z+2

MEMLET LDX    #RAMB+160
       LDU    <Z+4
       LDA    #HAUT/7
       STA    <Z
COPYB1 PULU   D
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
       BNE    COPYB1
       PULU   D
       STA    -120,X
       STB    -80,X

       LDA    #HAUT
       STA    <Z
       LDU    #RAMB+1
SCRLB1 PULU   D,X,Y,S
       LEAU   -1,U
       PSHU   S,Y,X,D
       LEAU   9,U
       FDB    $3776,$335F,$3676,$3349
       FDB    $3776,$335F,$3676,$3349
       FDB    $3776,$335F,$3676,$3349
       FDB    $3776,$335F,$3676,$3349
       DEC    <Z
       BNE    SCRLB1
       CLR    RAMB+HAUT*40

       TST    $E7E7
       BPL    *-3
       TST    $E7E7
       BMI    *-3
       LDD    #$2C0
       STA    $E7E5   deuxième écran
       STB    $E7DD

       LDX    #RAMA+160
       LDU    <Z+4
       LDA    #HAUT/7
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
       PULU   D
       STA    -120,X
       STB    -80,X
       STU    <Z+4

       LDA    #HAUT
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
       CLR    RAMA+HAUT*40

       LDX    #RAMB+160
       LDU    <Z+4
       LDA    #HAUT/7
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
       PULU   D
       STA    -120,X
       STB    -80,X

       LDA    #HAUT
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
       CLR    RAMB+HAUT*40

       TST    $E7C8
       LBEQ   SYNCRO

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
       FDB    0,$FFF,$EEE,$DDD,$CCC,$BBB
       FDB    $AAA,$999,$888,$777,$666
       FDB    $555,$444,$333,$222,$111
TEXTE  FCB    1,2,3,4,5,6,7,8,9,0

       END
