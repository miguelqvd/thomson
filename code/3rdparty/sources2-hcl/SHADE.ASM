****************************************
*            S H A D E R               *
****************************************

HAUT   EQU    160     hauteur à traiter
SIZE   EQU    1       taille de la bande
DIR    EQU    $9A
SEGMNT EQU    0        abcisse @ 8
BITTST EQU    SEGMNT+1 bit à tester
PIXOFF EQU    BITTST+1 masque effaceur
BANDE1 EQU    PIXOFF+1 nb pixels changés
BANDE2 EQU    BANDE1+1
LIGNE  EQU    BANDE2+1

       ORG    $9800
G      PSHS   U,X,DP,B,A,CC
       ORCC   #80
       LDA    #DIR
       TFR    A,DP
       CLR    $E7E5

       LDX    #$A000
       LDU    #$C000+40*(HAUT-1)
       LDA    #40
       STA    <SEGMNT
       LDA    #128

FORX   STA    <BITTST
       COMA
       STA    <PIXOFF
       LDA    #HAUT

FORY1  LDB    ,X
       BITB   <BITTST
       BNE    LIGHT1
       LDB    $2000,X
       BITB   <BITTST
       BNE    LIGHT1

*** On rencontre un pixel éteint

       CLR    <BANDE1
       BRA    NEXTY1

*** On rencontre un pixel allumé

LIGHT1 LDB    <BANDE1 la bande n'est pas
       CMPB   #SIZE   encore totalement
       BLO    COUL1      dessinéee

       TFR    A,B     le numéro de ligne
       ANDB   #31      n'indique pas un
       BNE    NEXTY1   début de lettre
       CLR    <BANDE1

COUL1  LDB    ,X
       ANDB   <PIXOFF  change de couleur
       STB    ,X
       LDB    $2000,X
       ORB    <BITTST
       STB    $2000,X
       INC    <BANDE1

NEXTY1 LEAX   40,X
       DECA
       BNE    FORY1

       LDA    #HAUT
FORY2  LDB    ,U
       BITB   <BITTST
       BNE    DARK1
       LDB    -$2000,U
       BITB   <BITTST
       BNE    DARK1
       CLR    <BANDE2
       BRA    NEXTY2
DARK1  LDB    <BANDE2
       CMPB   #SIZE
       BLO    COUL2
       TFR    A,B
       ANDB   #31
       BNE    NEXTY2
       CLR    <BANDE2
COUL2  LDB    ,U
       ANDB   <PIXOFF
       STB    ,U
       LDB    -$2000,U
       ORB    <BITTST
       STB    -$2000,U
       INC    <BANDE2
NEXTY2 LEAU   -40,U
       DECA
       BNE    FORY2

       LEAX   -HAUT*40,X
       LEAU    HAUT*40,U
       LDA    <BITTST
       LSRA
       LBNE   FORX
       LDA    #128
       LEAX   1,X
       LEAU   1,U
       DEC    <SEGMNT
       LBNE   FORX

LATRAL LDX    #$A000+(HAUT-1)*40
       LDU    #$C027+(HAUT-1)*40
       LDA    #HAUT
       STA    <LIGNE

FORY3  LDA    #40
       STA    <SEGMNT
       LDA    #1
FORX2  STA    <BITTST
       COMA
       STA    <PIXOFF

       LDB    ,U
       BITB   <BITTST
       BNE    DARK2
       LDB    -$2000,U
       BITB   <BITTST
       BNE    DARK2

       CLR    <BANDE2
       BRA    NEXTX

DARK2  LDB    <BANDE2
       CMPB   #SIZE
       BLO    COUL3

       LDB    <SEGMNT
       ANDB   #3
       BNE    NEXTX
       CMPA   #$FE
       BNE    NEXTX
       CLR    <BANDE2

COUL3  LDB    ,U
       ANDB   <PIXOFF
       STB    ,U
       LDB    -$2000,U
       ORB    <BITTST
       STB    -$2000,U
       INC    <BANDE2

NEXTX  LDA    <BITTST
       ASLA
       BNE    FORX2
       LEAU   -1,U
       LDA    #1
       DEC    <SEGMNT
       BNE    FORX2

       LDA    #40
       STA    <SEGMNT
       LDA    #128
FORX3  STA    <BITTST
       COMA
       STA    <PIXOFF

       LDB    ,X
       BITB   <BITTST
       BNE    LIGHT2
       LDB    $2000,X
       BITB   <BITTST
       BNE    LIGHT2

       CLR    <BANDE1
       BRA    NEXTX2

LIGHT2 LDB    <BANDE1
       CMPB   #SIZE
       BLO    COUL4

       LDB    <SEGMNT
       ANDB   #3
       BNE    NEXTX2
       CMPA   #$7F
       BNE    NEXTX2
       CLR    <BANDE1

COUL4  LDB    ,X
       ANDB   <PIXOFF
       STB    ,X
       LDB    $2000,X
       ORB    <BITTST
       STB    $2000,X
       INC    <BANDE1

NEXTX2 LDA    <BITTST
       LSRA
       BNE    FORX3
       LEAX   1,X
       LDA    #128
       DEC    <SEGMNT
       BNE    FORX3
       LEAX   -80,X
       DEC    <LIGNE
       LBNE   FORY3

       PULS   CC,A,B,DP,X,U,PC

       END
