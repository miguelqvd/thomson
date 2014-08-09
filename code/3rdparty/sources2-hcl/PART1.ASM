****************************************
*                                      *
*       FORUM THOMSON 91 : PART 1      *
*                                      *
****************************************

CODE   EQU    $9800   implantation prog.
MAP    EQU    $A000     image CHR fixes
FONTS  EQU    $8800   dessin des lettres
TEXTE  EQU    $8B80   délire méga-Lô...
COMPTS EQU    $9F04    compteurs (visu)
FNTBNK EQU    10      bank des CHR fixes
DIR    EQU    $9F      accès direct au
Z      EQU    0       buffer variables
ZZ     EQU    DIR*256+Z idem en étendu
HAUT   EQU    256     taille totale (Y)
BLKHIG EQU    16      hauteur d'un bloc
TAILLE EQU    HAUT/BLKHIG


       ORG    CODE
G      ORCC   #80
       LDA    $E7E6
       PSHS   A,DP
       LDD    #32     palettes en noir
       STA    $E7DB
       STA    $E7DA
       DECB
       BNE    *-4
       LDA    #$7B
       STA    $E7DC
       CLR    $E7DD
       LDX    #MAP    décompacte fontes
       STX    $616B
       LDD    #$FF0E
       STA    $6249
       STB    $616D
       INCB
       STB    $E7E5
       LDD    #$100
       STD    $61D6
       CLR    $6288
       LDB    #69
       JSR    $EC0C

       LDA    #$60+FNTBNK traite fontes
       STA    $E7E6    lettre par lettre
       CLR    $E7E5
       LDY    #0
       LDX    #$A001
       LDD    #$500+DIR
       TFR    B,DP
       STA    <Z      5 rangées
       LDB    #8
       STB    <Z+1    8 lettres / rangée
       LDA    #37     37 lignes / lettre
       STA    <Z+2
LETTRE LDA    -1,X    5*2 octets / ligne
       STA    ,Y+
       LDD    ,X
       STD    ,Y++
       LDD    2,X
       STD    ,Y++
       LDA    $1FFF,X
       STA    ,Y+
       LDD    $2000,X
       STD    ,Y++
       LDD    $2002,X
       STD    ,Y++
       LEAX   40,X
       DEC    <Z+2
       BNE    LETTRE
       LEAX   -37*40+5,X
       DEC    <Z+1
       BNE    LETTRE-4
       LEAX   37*40,X
       DEC    <Z
       BNE    LETTRE-8

       CLR    $E7E5    début des choses
       JSR    CLRSCR     sérieuses...
       LDB    #$E7
       TFR    B,DP
       LDD    #$40A
       STD    ZZ
       CLR    ZZ+3
       LDY    #TEXTE  où dans le scroll
       LDU    #FONTS  caractère courant
RSTART LDA    #BLKHIG
       STA    <$E5    sert de compteur
       JSR    SYNCRO

GOON   LDX    #0
       JSR    VISU
       LDB    #BLKHIG
       STB    <$E5    l'horreur totale !
       DEC    ZZ
       BEQ    NEXLIG

       LDX    #314    même écran, décalé
       LEAX   -1,X
       BNE    *-2
       JMP    JOIN

NEXLIG LDA    #4
       STA    ZZ
       ABX

       LDB    #TAILLE
       LDX    #VISU+15
       LDA    EXCEPT
       SUBA   #32
       STA    EXCEPT
SCROL  LDA    -10,X
       STA    -12,X
       LDA    -8,X
       STA    -10,X
       LDA    -6,X
       STA    -8,X
       LDA    -4,X
       STA    -6,X
       LDA    -2,X
       STA    -4,X
       LDA    ,X
       STA    -2,X
       LDA    2,X
       STA    ,X
       LDA    4,X
       STA    2,X
       LDA    6,X
       STA    4,X
       LDA    8,X
       STA    6,X
       LDA    10,X
       STA    8,X
       LDA    12,X
       STA    10,X
BITST  LDA    #128
       BITA   ,U+     forme du caractère
       BNE    *+6
       LDA    #$97    bloc vide
       BRA    *+6
       LDA    #$D7    bloc plein
       BRA    *+2
       STA    12,X
       LEAX   33,X
       DECB
       BNE    SCROL
       LDA    EXCEPT
       ADDA   #32
       STA    EXCEPT

       LEAU   -TAILLE,U
       LSR    BITST+1
       DEC    ZZ+1    encore x bits
       BEQ    NEXLET
       LDX    #9
       LEAX   -1,X
       BNE    *-2
       BRA    JOIN

NEXLET LDD    #$A80
       STA    ZZ+1
       STB    BITST+1
       LDA    ,Y+     caractère suivant
       BLT    ESCAPE  affiche page texte
       BEQ    FINTXT
       TST    ,X
       PSHS   Y,X,A
       PULS   A,X,Y
       BRA    RETESC+2
FINTXT LDY    #TEXTE
       PSHS   X,A
       PULS   A,X
       ABX
RETESC LDA    ,Y+      retour de ESCAPE
       LDB    #TAILLE
       MUL
       LDU    #FONTS-16 (code de 1 à 56)
       LEAU   D,U

JOIN   LDX    #4
       LEAX   -1,X
       BNE    *-2

       LDB    ZZ+3      décalage palette
       LDX    #COLORS-9    effet de la
       LDA    <$CC    direction du JOY0
       ANDA   #3
       ADDB   A,X
       STB    ZZ+3
       LDX    #COLORS
       ABX
       CLR    <$DB
       LDA    #16     nouvelles palettes
       STA    ZZ+4
       LDD    ,X++
       STB    <$DA
       STA    <$DA
       DEC    ZZ+4
       BNE    *-9
       LDA    B,X
       TST    <$C8
       LBEQ   GOON

       LDD    #0
       STD    $E7DC
       LDA    #-1
       LDX    #NORPAL
       JSR    $EC00
       PULS   DP,A
       STA    $E7E6
       RTS

ESCAPE CMPA   #128
       BNE    AFFTXT  permutation pages:
       LDB    VISU+1    celle affichée
       EORB   #128        est 0 ou 2
       STB    VISU+1
       TST    ,X      j'V pas tt refaire
       BRA    RETESC  cette routine:26 #

AFFTXT PSHS   Y       crée nouvelle page
       CLRA
       LDB    VISU+1    on modifie la
       BNE    *+4     fenêtre qui n'est
       LDA    #2
       STA    $E7E5    pas affichée.
       JSR    CLRSCR  effacement fenêtre
       PULS   X
GETPOS LDY    -1,X    position à l'écran
       CMPY   #$A000
       BLO    FINPGE
       LEAX   1,X
GETLET LDB    ,X+     lettre à afficher
       BMI    GETPOS
       JSR    PUTC
       BRA    GETLET
FINPGE LDA    ,X+     on prépare déja le
       LDB    #TAILLE  caractère suivant
       MUL
       LDU    #FONTS-16 (code de 1 à 56)
       LEAU   D,U
       LEAY   ,X
       JMP    RSTART

SYNCRO LDA    #32
       BITA   <$E7
       BEQ    *-2
       BITA   <$E7
       BNE    *-2
       PSHS   A
       MUL
       MUL
       MUL
       MUL
       PULS   A
       BITA   <$E7
       BEQ    *-10
       MUL
       MUL
       MUL
       MUL
       MUL
       TST    <$E7
       BPL    *-7
       MUL
       MUL
       MUL
       MUL
       MUL
       TST    <$E7
       BMI    *-7
       LDX    #$276
       LEAX   -1,X
       BNE    *-2
       TST    ,X
       RTS

VISU   LDD    #$00C1
       STA    <$DD    ligne 0
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       LEAX   -1,X
       CMPX   #$FFF0
       BNE    *-31
       STA    <$DD    ligne 1
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
EXCEPT STA    $E7DD
       LEAX   1,X
       LBNE   *-29
       STA    <$DD    ligne 2
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       LEAX   1,X
       CMPX   #16
       BNE    *-31
       STA    <$DD    ligne 3
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       LEAX   -1,X
       CMPX   #0
       BNE    *-31
       STA    <$DD    ligne 4
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       LEAX   1,X
       CMPX   #16
       BNE    *-31
       STA    <$DD    ligne 5
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       LEAX   -1,X
       CMPX   #0
       BNE    *-31
       STA    <$DD    ligne 6
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       LEAX   1,X
       CMPX   #16
       BNE    *-31
       STA    <$DD    ligne 7
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       LEAX   -1,X
       CMPX   #-4
       BNE    *-31
       STA    <$DD    ligne 8
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       LEAX   1,X
       CMPX   #16
       BNE    *-31
       STA    <$DD    ligne 9
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       LEAX   -1,X
       CMPX   #0
       BNE    *-31
       STA    <$DD    ligne 10
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       LEAX   1,X
       CMPX   #16
       BNE    *-31
       STA    <$DD    ligne 11
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       LEAX   -1,X
       CMPX   #0
       BNE    *-31
       STA    <$DD    ligne 12
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       LEAX   1,X
       CMPX   #16
       BNE    *-31
       STA    <$DD    ligne 13
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       DEC    <$E5
       LBNE   *-28
       NOP
       STA    <$DD    ligne 14
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       LEAX   -1,X
       CMPX   #0
       BNE    *-31
       STA    <$DD    ligne 15
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       STA    <$DD
       LEAX   1,X
       CMPX   #16
       BNE    *-31
       STA    <$DD
       NOP
       RTS

PUTC   PSHS   X       affiche une lettre
       STS    RS1+2   (reg B) à l'écran
       LDX    #0      (reg Y). X sauvé
       LDA    #5*37
       MUL
       LEAS   D,X
       LDB    #37
CHRLIN PULS   A,X,U
       STA    -1,Y
       STX    ,Y
       STU    2,Y
       PULS   A,X,U
       STA    $1FFF,Y
       STX    $2000,Y
       STU    $2002,Y
       LEAY   40,Y
       DECB
       BNE    CHRLIN
       LEAY   -37*40+5,Y
RS1    LDS    #0
       PULS   X,PC

CLRSCR STS    RS2+2     effacement total
       LDU    #COLORS-6     de l'écran
       PULU   D,X,Y,S
       LDU    #$DF40
CLSB   FCC    /6v6v6v6v6v6v6v6v6v6v/
       FCC    /6v6v6v6v6v6v6v6v6v6v/
       FCC    /6v6v6v6v6v6v6v6v6v6v/
       FCC    /6v6v6v6v6v6v6v6v6v6v/
       CMPU   #$C000
       BNE    CLSB
       LDU    #$BF40
CLSA   FCC    /6v6v6v6v6v6v6v6v6v6v/
       FCC    /6v6v6v6v6v6v6v6v6v6v/
       FCC    /6v6v6v6v6v6v6v6v6v6v/
       FCC    /6v6v6v6v6v6v6v6v6v6v/
       CMPU   #$A000
       BNE    CLSA
RS2    LDS    #0
       RTS

       FCB    0,32,-32
       FDB    0,0,0
COLORS FDB    0,$F00,$2F,$3F,$4F,$5F,$6F
       FDB    $7F,$8F,$9F,$AF,$BF,$CF
       FDB    $DF,$EF,$800
       FDB    0,15,$222,$333,$444,$555
       FDB    $666,$777,$888,$999,$AAA
       FDB    $BBB,$CCC,$DDD,$EEE,8
NORPAL FDB    0,15,240,255,3840,3855
       FDB    4080,4095,1911
       END
