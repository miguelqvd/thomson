****************************************
*              P  O  C  K              *
****************************************
               * kernel *
               **********

TEXTE  EQU    $8000   contenu du scroll
RANDOM EQU    $8A00   table du hasard
FONTE  EQU    $9000   lettres du scroll
LEVELS EQU    $90FC   gains et vitesses
DESSIN EQU    $9200   morceaux de pièces
FORME  EQU    $9344   silhouettes
CHIFF  EQU    $949A   les 9 chiffres
PIECES EQU    $94E0   7 figures de base
SYNCRO EQU    $95F5   début du code ASM
DIR    EQU    $9D     accès page direct
Z      EQU    $80     pour les variables

RAMA   EQU    $C14F
RAMB   EQU    RAMA-$2000
COULIB EQU    192     couleur segmt vide
GHOST  EQU    71      brique s'en allant
BORDER EQU    184     couleur tour carré
REBDEP EQU    4       anti-rebond direc@
REBROT EQU    9       anti-rebond rota@

       ORG    SYNCRO

       TST    $E7E7
       BPL    *-3
       TST    $E7E7
       BMI    *-3

DEFIL  LDX    #$DE3C            scroll ^
       LDU    #DIR*256+Z+23
       LDA    #5
       ASL    ,U+
       ROL    15,X
       ROL    14,X
       ROL    13,X
       ROL    12,X
       ROL    11,X
       ROL    10,X
       ROL    9,X
       ROL    8,X
       ROL    7,X
       ROL    6,X
       ROL    5,X
       ROL    4,X
       ROL    3,X
       ROL    2,X
       ROL    1,X
       ROL    ,X
       ROL    -1,X
       ROL    -2,X
       ROL    -3,X
       ROL    -4,X
       ROL    -5,X
       ROL    -6,X
       ROL    -7,X
       ROL    -8,X
       ROL    -9,X
       ROL    -10,X
       ROL    -11,X
       ROL    -12,X
       ROL    -13,X
       ROL    -14,X
       ROL    -15,X
       ROL    -16,X
       LEAX   40,X
       DECA
       BNE    DEFIL+8
       DEC    <Z+28
       BNE    DEFILN
       LDX    <Z+29
       LDB    ,X+
       BNE    *+7
       LDX    #TEXTE
       BRA    *-7
       STX    <Z+29
       LDA    #5
       MUL
       LDU    #FONTE-5
       LEAU   D,U
       PULU   D,X
       STD    <Z+23
       STX    <Z+25
       LDA    ,U
       STA    <Z+27
       LDA    #8
       STA    <Z+28

DEFILN LDA    <Z+31
       BEQ    EFFDEB
       DEC    <Z+31
       LBNE   SYNCRO
       JMP    ,Y

**** Effacement de l'objet ***

EFFDEB LDX    <Z+2    adresse écran RAMB
       LDU    <Z+4    silhouette objet
       LDA    #4
       STA    <Z+1
       LDA    #COULIB
       LDB    #4
       STB    <Z

EFFLIG LDB    ,U+
       BEQ    EFFVID
       STA    -120,X
       STA    -80,X
       STA    -40,X
       STA    ,X
       STA    40,X
       STA    80,X
       STA    120,X
       STA    160,X
EFFVID LEAX   1,X
       DEC    <Z
       BNE    EFFLIG
       LEAX   316,X
       DEC    <Z+1
       BNE    EFFLIG-4

**** Rotation de l'objet ****

       LDB    <Z+13
       BNE    ROTFIN  c'est un rebond
       LDA    $E7CD   action 0
       LDX    <Z+2
       LDU    <Z+4
       BITA   #64
       BNE    ROTFIN+2
       LDU    -2,U
       LEAS   ,U
       LDA    #4
       STA    <Z
       LDB    #4

ROTLIG LDA    ,S+
       BEQ    ROTVID
       LDA    -120,X  haut du cube
       CMPA   #COULIB
       BNE    ROTFIN+2
       LDA    160,X   bas du cube
       CMPA   #COULIB
       BNE    ROTFIN+2

ROTVID LEAX   1,X
       DECB
       BNE    ROTLIG
       LEAX   316,X
       DEC    <Z
       BNE    ROTLIG-2
       STU    <Z+4
       LDB    #REBROT
       STB    <Z+13
       BRA    *+4

ROTFIN DEC    <Z+13

**** Déplacements latéraux ****

       LDA    $E7CC   joystick 0
       LDX    <Z+2
       LDU    <Z+4
       BITA   #4
       BNE    *+6
       LEAX   -1,X
       BRA    *+8
       BITA   #8
       BNE    DEPFIN
       LEAX   1,X
       LEAY   ,X
       DEC    <Z+12
       BGT    DEPFIN+2 c'est un rebond
       LDA    #4
       STA    <Z
       LDB    #4

DEPLIG LDA    ,U+
       BEQ    DEPVID
       LDA    -120,Y  haut du cube
       CMPA   #COULIB
       BNE    DEPFIN
       LDA    160,Y   bas du cube
       CMPA   #COULIB
       BNE    DEPFIN

DEPVID LEAY   1,Y
       DECB
       BNE    DEPLIG
       LEAY   316,Y
       DEC    <Z
       BNE    DEPLIG-2
       STX    <Z+2
       LDB    #REBDEP
       STB    <Z+12
       BRA    *+4

DEPFIN CLR    <Z+12

**** Chute de l'objet ****

       LDX    <Z+2
       LDA    $E7CC
       BITA   #2
       BNE    CHUNAT
       LDA    <Z+14   flag même pression
       BNE    CHUNAT+2
       LEAX   320,X   commandée
       BRA    CHUFIN

CHUNAT CLR    <Z+14
       LDB    <Z+8    naturelle
       CLRA
       ADDD   <Z+6    vitesse de chute
       STB    <Z+8
       LDB    #40
       MUL
       LEAX   D,X
CHUFIN STX    <Z+2

**** Ajustage si fin de chute ****

       LDU    <Z+4    forme de l'objet
       LDX    <Z+2    adresse écran RAMB
       LEAS   12,U
       LEAY   1120,X
       LDA    #4
       STA    <Z
       LEAX   ,Y
       LEAU   ,S
       LDB    #4

AJUCOL LDA    ,U
       BEQ    AJUVID
       LDB    #1      fin de colonne
       LDA    ,X      bas de plancher
       CMPA   #COULIB
       BEQ    AJUVID
       STB    <Z+9    flag fin de chute
       CLRB
       LEAX   -40,X
       LDA    ,X
       INCB
       CMPA   #COULIB
       BNE    *-8
       LDA    #40
       MUL
       COMA
       NEGB
       LDX    <Z+2
       LEAX   D,X
       STX    <Z+2
       BRA    AJUFIN

AJUVID LEAX   -320,X
       LEAU   -4,U
       DECB
       BNE    AJUCOL
       LEAU   17,U
       LEAY   1,Y     colonne suivante
       LEAS   1,S
       DEC    <Z
       BNE    AJUCOL-6
AJUFIN

**** Affichage de l'objet ****

       LDX    <Z+2    adresse écran RAMB
       LEAY   $2000,X
       LDS    <Z+4    forme de l'objet
       LDA    #4
       STA    <Z+1
       LDB    #4
       STB    <Z

AFFLIG LDB    ,S+
       BEQ    AFFVID
       LDA    #6
       MUL
       LDU    #DESSIN-6
       LEAU   D,U
       PULU   D
       STA    -120,X
       STA    -80,X
       STA    -40,X
       STA    ,X
       STA    40,X
       STA    80,X
       STA    120,X
       STA    160,X
       STB    -120,Y
       PULU   D
       STA    -80,Y
       STB    -40,Y
       STB    ,Y
       STB    40,Y
       STB    80,Y
       LDD    ,U
       STA    120,Y
       STB    160,Y

AFFVID LEAX   1,X
       LEAY   1,Y
       DEC    <Z
       BNE    AFFLIG
       LEAX   316,X
       LEAY   316,Y
       DEC    <Z+1
       BNE    AFFLIG-4
       LDA    <Z+9
       LBEQ   SYNCRO

**** Ravages causés par l'objet ****

       CLR    <Z+9    aucune ligne faite
       LDU    <Z+2    cube du milieu sur
       LEAU   1,U      la ligne du haut
       LDA    #4
       STA    <Z+1
RAVCOL LEAX   ,U
       LEAY   ,U
       LDA    ,X
       CMPA   #BORDER
       LBEQ   RAVGRU  déjà => hors cadre
       LDA    ,X+
       CMPA   #COULIB
       LBEQ   RAVGRU
       CMPA   #BORDER
       BNE    *-10
       LDA    ,-Y     couleurs à gauche?
       CMPA   #COULIB
       LBEQ   RAVGRU
       CMPA   #BORDER
       BNE    *-10
       LDA    #10
       STA    <Z
       LEAX   -11,X
       LEAY   $2001,Y
       INC    <Z+9
       STX    <Z+18
RAVLIG LDA    200,X   remodelage dessin
       CMPA   #BORDER des figures pour
       BEQ    RAVSUS  cause de chute
       CLRA
       LDB    240,Y
       BEQ    *+3
       INCA
       STA    200,Y
RAVSUS LDA    -160,X
       CMPA   #BORDER
       BEQ    RAVCUB
       LDA    #$FF
       STA    -160,Y
       LDB    -160,X
       CMPB   -161,X  mm couleur gauche?
       BNE    *+8
       LDB    -241,Y
       BEQ    *+4
       LDA    #$7F    mais pas de lien .
       STA    -200,Y
RAVCUB LDA    #GHOST  blanchir la ligne
       STA    -120,X
       STA    -80,X
       STA    -40,X
       STA    ,X+
       STA    39,X
       STA    79,X
       STA    119,X
       STA    159,X
       LDD    #$103
       STA    -120,Y
       STB    -80,Y
       STB    -40,Y
       STB    ,Y+
       STB    39,Y
       STB    79,Y
       LDD    #$7FFF
       STA    119,Y
       STB    159,Y
       DEC    <Z
       LBNE   RAVLIG
RAVGRU LEAU   320,U
       DEC    <Z+1
       LBNE   RAVCOL

**** Tombée des lignes supérieures ****

       LDA    <Z+9
       LBEQ   STATUS  rien ne bouge
       LDY    #TOMDEB
       LDA    #5
       STA    <Z+31
       JMP    SYNCRO

TOMDEB LDU    <Z+18   source
       LEAU   -120,U  haut de la ligne
       LEAS   5,U     destination
TOMLIG LEAU   -320,U
       LDA    ,U
       CMPA   #BORDER haut du cadre
       BEQ    TOMDER
       CMPA   #GHOST
       BNE    TOMCPY
       BRA    TOMLIG

TOMDER LDX    #COULIB*256+COULIB
       LEAY   ,X
       LDB    #COULIB
       LDA    <Z+9
       LDU    #RAMB+50
       PSHU   Y,X,B
       PSHU   Y,X,B
       LEAU   50,U
       PSHU   Y,X,B
       PSHU   Y,X,B
       LEAU   50,U
       PSHU   Y,X,B
       PSHU   Y,X,B
       LEAU   50,U
       PSHU   Y,X,B
       PSHU   Y,X,B
       LEAU   50,U
       PSHU   Y,X,B
       PSHU   Y,X,B
       LEAU   50,U
       PSHU   Y,X,B
       PSHU   Y,X,B
       LEAU   50,U
       PSHU   Y,X,B
       PSHU   Y,X,B
       LEAU   50,U
       PSHU   Y,X,B
       PSHU   Y,X,B
       LEAU   50,U
       DECA
       BNE    *-57
       LDY    #SCOMAJ
       LDA    #5
       STA    <Z+31
       JMP    SYNCRO

TOMCPY PULU   B,X,Y   copie des couleurs
       PSHS   Y,X,B
       LEAS   45,S
       PSHS   Y,X,B
       LEAS   45,S
       PSHS   Y,X,B
       LEAS   45,S
       PSHS   Y,X,B
       LEAS   45,S
       PSHS   Y,X,B
       LEAS   45,S
       PSHS   Y,X,B
       LEAS   45,S
       PSHS   Y,X,B
       LEAS   45,S
       PSHS   Y,X,B
       LEAS   10,S
       PULU   X,Y,B
       PSHS   Y,X,B
       LEAS   -35,S
       PSHS   Y,X,B
       LEAS   -35,S
       PSHS   Y,X,B
       LEAS   -35,S
       PSHS   Y,X,B
       LEAS   -35,S
       PSHS   Y,X,B
       LEAS   -35,S
       PSHS   Y,X,B
       LEAS   -35,S
       PSHS   Y,X,B
       LEAS   -35,S
       PSHS   Y,X,B

       LEAU   $1FF6,U
       LEAS   $2000,S
       PULU   B,X,Y   copie des formes
       PSHS   Y,X,B
       LEAS   10,S
       PULU   B,X,Y
       PSHS   Y,X,B
       LEAU   30,U
       LEAS   40,S
       PULU   B,X,Y
       PSHS   Y,X,B
       LEAS   45,S
       PSHS   Y,X,B
       LEAS   45,S
       PSHS   Y,X,B
       LEAS   45,S
       PSHS   Y,X,B
       LEAS   45,S
       PSHS   Y,X,B
       PULU   B,X,Y
       LEAS   10,S
       PSHS   Y,X,B
       LEAS   -35,S
       PSHS   Y,X,B
       LEAS   -35,S
       PSHS   Y,X,B
       LEAS   -35,S
       PSHS   Y,X,B
       LEAS   -35,S
       PSHS   Y,X,B
       LEAU   190,U
       LEAS   200,S
       PULU   B,X,Y
       PSHS   Y,X,B
       LEAS   10,S
       PULU   B,X,Y
       PSHS   Y,X,B
       LEAU   30,U
       LEAS   40,S
       PULU   B,X,Y
       PSHS   Y,X,B
       LEAS   10,S
       PULU   B,X,Y
       PSHS   Y,X,B
       LEAU   -$2122,U
       LEAS   -$2258,S
       JMP    TOMLIG

SCOMAJ LDX    <Z+39   score bonifié
       LDA    <Z+9
       LDB    #6
       MUL
       LEAX   D,X
       LDU    #DIR*256+Z+39
       LDA    #6
       LDB    ,-U
       ADDB   ,-X
       CMPB   #10
       BLO    *+6
       SUBB   #10
       INC    -1,U
       STB    ,U
       DECA
       BNE    *-15
       LDA    <Z+32   au cas où 10000000
       CMPA   #10
       BLO    *+4
       CLR    <Z+32

       LDS    #$60CC
       LDB    <Z+15   lignes du level
       SUBB   <Z+9
       CMPB   #252
       BLO    NBLMAJ-2
       LDD    <Z+41   numéro du level
       LDU    <Z+39   gains associés
       LEAU   24,U
       INCB
       CMPB   #10
       BLO    *+24
       INC    <Z+43
       LDB    <Z+43
       LDX    #$CA98              vies ^
       JSR    PUTC
       LDA    <Z+41
       LDU    #LEVELS
       CLRB
       INCA
       CMPA   #10
       BLO    *+3
       CLRA
       STD    <Z+41
       PULU   D
       STD    <Z+6    vitesse associée
       STU    <Z+39
       LDX    #$D4D1             level ^
       LDB    <Z+41
       BNE    *+4
       LDB    #12
       JSR    PUTC
       LDB    <Z+42
       JSR    PUTC
       LDB    #14     lignes / level
       STB    <Z+15
NBLMAJ LDB    <Z+22   nombre de lignes
       ADDB   <Z+9
       CMPB   #9
       BHI    *+6
       STB    <Z+22
       BRA    NBLAFF
       SUBB   #10
       STB    <Z+22
       LDA    <Z+21
       INCA
       CMPA   #9
       BHI    *+6
       STA    <Z+21
       BRA    NBLAFF
       SUBA   #10
       STA    <Z+21
       INC    <Z+20
NBLAFF LDX    #$D33F             lines ^
       LDB    <Z+20
       JSR    PUTC
       LDB    <Z+21
       JSR    PUTC
       LDB    <Z+22
       JSR    PUTC

**** Status lines ****

STATUS LDU    #DIR*256+Z+39
       LDS    #$60CC
       CLRA
       LDB    ,-U
       INCB
       CMPB   #10
       BLO    *+6
       STA    ,U
       BRA    *-9
       STB    ,U
SCOAFF LDX    #$C5CA             score ^
       LDY    #DIR*256+Z+32
       LDA    #7
       STA    <Z
       LDB    ,Y+
       JSR    PUTC
       DEC    <Z
       BNE    *-7

**** Nouvel objet ****

OBJNEW CLR    <Z+9
       LDU    <Z+16   ancien "NEXT"
       STU    <Z+4    forme de l'objet
       LEAS   8,U
       LDX    #RAMB-517
       STX    <Z+2    adresse écran
       LDX    #RAMB+3
       CLR    <Z+8    ordonnée nulle
       INC    <Z+14   flag même pression
       LDA    #2
       STA    <Z
       LDB    #4

OBJLIG LDA    ,S+
       BEQ    *+11
       LDA    ,X      haut du cube
       CMPA   #COULIB
       BEQ    *+5
       JMP    BLKOBJ  l'objet est bloqué
       LEAX   1,X
       DECB
       BNE    OBJLIG
       LEAX   316,X
       DEC    <Z
       BNE    OBJLIG-2

**** Présentation du suivant ****

SUIDEB LDX    <Z+10
       LDB    ,X+
       ANDB   #7
       BNE    *+7
       LDX    #RANDOM
       BRA    *-9
       STX    <Z+10
       LDX    #PIECES-2
       ASLB
       LDU    B,X     forme du suivant
       STU    <Z+16
       LEAS   8,U
       LDX    #$B510              next ^
       LEAY   $2000,X
       LDA    #2
       STA    <Z+1
       LDB    #4
       STB    <Z

SUILIG LDB    ,S+
       BNE    SUICUB
       LDA    #COULIB
       STA    -120,X
       STA    -80,X
       STA    -40,X
       STA    ,X
       STA    40,X
       STA    80,X
       STA    120,X
       STA    160,X
       BRA    SUINEX
SUICUB LDA    #6
       MUL
       LDU    #DESSIN-6
       LEAU   D,U
       PULU   D
       STA    -120,X
       STA    -80,X
       STA    -40,X
       STA    ,X
       STA    40,X
       STA    80,X
       STA    120,X
       STA    160,X
       STB    -120,Y
       PULU   D
       STA    -80,Y
       STB    -40,Y
       STB    ,Y
       STB    40,Y
       STB    80,Y
       PULU   D
       STA    120,Y
       STB    160,Y
SUINEX LEAX   1,X
       LEAY   1,Y
       DEC    <Z
       BNE    SUILIG
       LEAX   316,X
       LEAY   316,Y
       DEC    <Z+1
       BNE    SUILIG-4
       JMP    SYNCRO

**** La figure est bloquée ****

BLKOBJ DEC    <Z
       BNE    BLKFIN
       LDX    #RAMB+123
       LDY    #RAMA+123
       LEAS   12,U
       LDA    #4
       STA    <Z

BLKLIG LDB    ,S+
       BEQ    BLKVID
       LDA    #6
       MUL
       LDU    #DESSIN-6
       LEAU   D,U
       PULU   D
       STA    -120,X
       STA    -80,X
       STA    -40,X
       STA    ,X
       STA    40,X
       STA    80,X
       STA    120,X
       STA    160,X
       STB    -120,Y
       PULU   D
       STA    -80,Y
       STB    -40,Y
       STB    ,Y
       STB    40,Y
       STB    80,Y
       PULU   D
       STA    120,Y
       STB    160,Y

BLKVID LEAX   1,X
       LEAY   1,Y
       DEC    <Z
       BNE    BLKLIG

BLKFIN LDA    #20
       STA    <Z+31
       LDY    #*+7
       JMP    SYNCRO
       DEC    <Z+43
GETRED LDS    #$60CC
       LDX    #$CA98              vies ^
       LDB    <Z+43
       JSR    PUTC
       TST    <Z+43
       BEQ    OVER
       LDX    #$CD32
       LDY    #$40C0
       LDA    #32
       LDU    ,Y++
       STU    -2,X
       LDU    ,Y++
       STU    ,X
       LDU    ,Y++
       STU    2,X
       LDU    ,Y++
       STU    4,X
       LEAX   40,X
       DECA
       BNE    *-20
       LEAS   -$24FA,X
       LDU    #GHOST*256+GHOST
       LEAX   ,U
       LEAY   ,U
       LDA    #32
       STA    <Z
       TFR    X,D
       PSHS   U,Y,X,D
       LEAS   48,S
       DEC    <Z
       BNE    *-7
       LDA    $E7CD
       BITA   #64
       BNE    *-5
       LDB    #160
       LDU    #COULIB*256+COULIB
       LDX    #RAMB+4
       STU    -4,X
       STU    -2,X
       STU    ,X
       STU    2,X
       STU    4,X
       LEAX   40,X
       DECB
       BNE    *-14
       LDS    #$60CC
       JMP    SCOAFF

OVER   LDX    #$CD33              over ^
       LDY    #$4000
       LDA    #32
       LDU    ,Y++
       STU    -2,X
       LDU    ,Y++
       STU    ,X
       LDU    ,Y++
       STU    2,X
       LEAX   40,X
       DECA
       BNE    *-16
       LEAS   -$24FC,X
       LDU    #GHOST*256+GHOST
       LEAX   ,U
       LEAY   ,U
       LDA    #32
       PSHS   U,Y,X
       LEAS   46,S
       DECA
       BNE    *-6
       LDA    $E7CD
       BITA   #64
       BNE    *-5
       LDS    #0
       RTS
PUTC   LDU    #CHIFF
       LDA    #7
       MUL
       LEAU   D,U
       PULU   D
       STA    -120,X
       STB    -80,X
       PULU   D
       STA    -40,X
       STB    ,X+
       PULU   D
       STA    39,X
       STB    79,X
       LDA    ,U
       STA    119,X
       RTS
INITAL STS    PUTC-3
       STD    <Z+41   level
       LDA    #26
       MUL
       LDU    #LEVELS
       LEAU   D,U
       PULU   D
       STD    <Z+6    vitesse
       STU    <Z+39   gains
       LDD    #0
       STD    <Z+31   score
       STD    <Z+33
       STD    <Z+35
       STD    <Z+37
       STD    <Z+20   lines
       STB    <Z+22
       STA    <Z+8    virgule
       LDB    <Z+42
       LDA    #15
       MUL
       TST    <Z+41
       BEQ    *+4
       ADDB   #150
       DECB
       STB    <Z+15   lignes / ce level
       LDA    #3
       STA    <Z+43   vies
       LDX    <Z+10
       LDB    ,X+     objet suivant
       ANDB   #7
       BNE    *+7
       LDX    #RANDOM
       BRA    *-9
       STX    <Z+10
       LDX    #PIECES-2
       ASLB
       LDU    B,X
       STU    <Z+16
       LDS    #$60CC
       LDX    #$D4D1             level ^
       LDB    <Z+41
       BNE    *+4
       LDB    #12
       JSR    PUTC
       LDB    <Z+42
       JSR    PUTC
       LDX    #$D33F             lines ^
       CLRB
       JSR    PUTC
       CLRB
       JSR    PUTC
       CLRB
       JSR    PUTC
       LDB    <Z+43
       LDX    #$CA98              vies ^
       JSR    PUTC
       JMP    GETRED

       END
