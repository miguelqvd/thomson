****************************************
*            OVERSCROLLER              *
****************************************


FONTS  EQU    $8800   dessin des lettres
TEXTE  EQU    $8000   délire méga-Lô...
ZZ     EQU    $9F00      variables
COMPTS EQU    $9F02    compteurs (visu)
HAUT   EQU    256     taille totale (Y)
BLKHIG EQU    16      hauteur d'un bloc
TAILLE SET    HAUT/BLKHIG

       ORG    TEXTE
       FCB    8,5,12,12,15,0,23,15,18,12
       FCB    4,0,0,-1

       ORG    $9000
G      ORCC   #80
       PSHS   DP
       LDA    #$E7
       TFR    A,DP
       LDD    #$3E4   page 3 en rouge
       STA    <$E5
       LDX    #$A000
       STB    ,X+
       CMPX   #$BF40
       BNE    *-5

* constitution de la routine d'affichage

       LDU    #COMPTS
       LDY    #VISU+3
       LDX    #TAILLE
MKPRG  LDD    #$97DD
       STD    ,Y++
       STD    ,Y++
       STD    ,Y++
       STD    ,Y++
       STD    ,Y++
       STD    ,Y++
       STD    ,Y++
       STD    ,Y++
       STD    ,Y++
       STD    ,Y++
       STD    ,Y++
       STD    ,Y++
       STD    ,Y++
       LDD    #$127A
       STD    ,Y++
       STU    ,Y++
       LDD    #$26E0
       STD    ,Y++
       LDA    #BLKHIG
       STA    ,U+
       LEAX   -1,X
       BNE    MKPRG
       LDD    #$0FDD
       STD    ,Y++
       LDA    #$39
       STA    ,Y+

       LDD    #$40A
       STD    ZZ
       LDU    #FONTS  caractère courant
       LDY    #TEXTE  où dans le scroll
       JSR    SYNCRO
GOON   JSR    VISU
       LDD    #TAILLE*256+BLKHIG
       LDX    #COMPTS
       STB    ,X+
       DECA
       BNE    *-3

       DEC    ZZ
       BEQ    NEXLIG
       LDX    #$1A4   même écran, décalé
       LEAX   -1,X
       BNE    *-2
       ABX
       BRA    GOON

NEXLIG LDA    #4
       STA    ZZ

       LDB    #TAILLE
       LDX    #VISU+15
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
       LEAX   32,X
       DECB
       BNE    SCROL
       LEAU   -TAILLE,U
       LSR    BITST+1
       DEC    ZZ+1    encore x bits
       BEQ    NEXLET
       LDX    #6
       LEAX   -1,X
       BNE    *-2
       NOP
       BRA    JOIN

NEXLET LDD    #$A80
       STA    ZZ+1
       STB    BITST+1
       LDA    ,Y+     caractère suivant
       BLT    FINTXT
       TST    A,X
       BRA    *+8
FINTXT LDY    #TEXTE
       LDA    ,Y+
       LDB    #TAILLE
       MUL
       LDU    #FONTS
       LEAU   D,U

JOIN   LDX    #$6E
       LEAX   -1,X
       BNE    *-2
       NOP
       NOP
       TST    <$C8
       LBEQ   GOON

       PULS   DP
       SWI

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
       LDX    #$2B7
       LEAX   -1,X
       BNE    *-2
       NOP
       RTS

VISU   LDD    #$00C4

       END
