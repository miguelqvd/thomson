******************************
*                            *
* DUPLEX : Système d'échange *
*           de données entre *
*            TO8, TO8D, TO9+ *
*             et Minitel, en *
*              un seul sens *
* Michel        à la fois. *
* SAINT-BRIANT   ASCI (c) *
*                        *  version
*************************  du 15/7/93


* Les accents sont transcodés dans les
* deux sens.


       ORG    $9000


* EMISSION DE DONNEES A 1200 BAUDS
* DONNEES SUR 7 bits, 1 bit start
* 1 bit stop, parité paire
* compatible MINITEL
* les données sont inscrites sur la
* bank courante depuis $A000 et ter-
* minées par un code supérieur à $7F
* ($FF ou 255 par exemple)

EMIT   PSHS   U,Y,X,DP,B,A,CC
       ORCC   #$50
       LDD    #$E7FD
       TFR    A,DP
       STB    <$C2
       LDB    <$C5
       PSHS   B,A
       LDU    #$A000
       CLRB
EMIT0  LDA    #$07
       STA    ,S
       LDX    #$61
       STX    <$C6
       LDA    #$A2
       STA    <$C5
       CLRA
       BSR    ROUT2
EMIT1  LSRB
       BCS    EMIT2
       BSR    ROUT2
       BRA    EMIT3
EMIT2  BSR    ROUT1
       INCA
EMIT3  DEC    ,S
       BNE    EMIT1
       BITA   #$01
       BNE    EMIT4
       BSR    ROUT2
       BRA    EMIT5
EMIT4  BSR    ROUT1
EMIT5  LDA    #10
EMIT6  DECA
       BNE    EMIT6
       BSR    ROUT1
       LDB    ,U+
       BMI    FINEMI
       CMPB   #$16
       BNE    EMIT0
       LDB    #$19
       BRA    EMIT0
FINEMI LDA    <$C5
       ORA    #$80
       STA    <$C5
       LDX    #$0033
EMIT7  LEAX   -1,X
       BNE    EMIT7
       PULS   A,B
       STB    <$C5
       LDD    #$1800
       STD    <$C6
       PULS   CC,A,B,DP,X,Y,U,PC


ROUT1  PSHS   X,A
       LDX    #$0061
TEMPO1 LEAX   -1,X
       BNE    TEMPO1
       LDA    <$C5
       ORA    #$80
       BRA    FINROU
ROUT2  PSHS   X,A
       LDX    #$0061
TEMPO2 LEAX   -1,X
       BNE    TEMPO2
       LDA    <$C5
       ANDA   #$7F
       BRA    FINROU
FINROU STA    <$C5
       PULS   A,X,PC



* RECEPTION DE DONNEES A 1200 BAUDS
* DONNEES SUR 7 bits, 1 bit start
* 1 bit stop, parité paire
* compatible MINITEL
* les données sont inscrites sur la
* bank courante depuis $A000 tant que
* la touche 'Envoi' n'est pas pressée.
* -> code 0 pour la fin des données.


RECEIV PSHS   U,Y,X,DP,B,A,CC
       LDU    #$A000
       LDA    #$E7
       PSHS   A
       TFR    A,DP
RECE1  LDA    #$08
       STA    ,S
       LDA    <$CA
       ANDA   #$C4
       STA    <$CA
       LDA    <$C8
       LDY    #$0000
       LDB    #$1E
TEMPO3 LEAY   -1,Y
       BNE    RECE2
       DECB
       BEQ    RECE10
       LDY    #$0000
RECE2  LDA    <$CA
       BITA   #$40
       BEQ    TEMPO3
       ANDCC  #$FE
       LDX    #$0013
RECE4  LEAX   -1,X
       BNE    RECE4
RECE5  BCC    RECE7
       BSR    RECE12
       BCS    RECE6
       RORB
       ANDCC  #$FE
       BRA    RECE9
RECE6  RORB
       ORCC   #$01
       BRA    RECE9
RECE7  BSR    RECE14
       BCC    RECE8
       RORB
       ORCC   #$01
       BRA    RECE9
RECE8  RORB
       ANDCC  #$FE
       BRA    RECE9
RECE9  DEC    ,S
       BNE    RECE5
       ANDB   #$7F
       BRA    RECE11
RECE10 LDB    #$FF
RECE11 LDA    -1,U
       CMPD   #$1341
       BEQ    FINREC
       CMPB   #$19
       BNE    ECRIRE
       LDB    #$16
ECRIRE STB    ,U+
       BRA    RECE1
FINREC CLR    -1,U
       PULS   A
       PULS   CC,A,B,DP,X,Y,U,PC

RECE12 LDA    <$CA
       ANDA   #$C4
       STA    <$CA
       LDA    <$C8
       BSR    TEMPO4
       LDA    <$CA
       ANDA   #$40
       BNE    RECE15
RECE13 ORCC   #$01
       RTS
RECE14 LDA    <$CA
       ORA    #$10
       STA    <$CA
       LDA    <$C8
       BSR    TEMPO4
       LDA    <$CA
       ANDA   #$40
       BNE    RECE13
RECE15 ANDCC  #$FE
       RTS
TEMPO4 LDX    #$005E
TEMPO5 LEAX   -1,X
       BNE    TEMPO5
       RTS

       END
