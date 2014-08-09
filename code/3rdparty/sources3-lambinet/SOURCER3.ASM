****************************************
*                                      *
* SOURCER pour CODEVIEW    version 3.1 *
*                                      *
* par Michel SAINT-BRIANT * 28/02/1992 *
*                                      *
* (c)    A.S.C.I.    Copyright    1992 *
*                                      *
****************************************

* cette routine permet de recalculer les
* adresses depuis des données mémorisées
* sous CODEVIEW et sort le résultat dans
* un fichier .ASM compacté directement
* utilisable sous 'ASSEMBLER' de Micro-
* soft(après avoir été retaillé si néces
* saire car taille maxi=24 Ko )

* on peut aller 10000 lignes de code
* (nécessité d'une extension RAM 256Ko)
* ou 4499 lignes sans extension.
* (on peut compter 400 à 500 lignes par
* Ko de code)

* Les flags 1,2 et 3 permettent d'éviter
* le traitement de la recherche d'adres-
* ses décalées du type:
*         LDX    #TABLE+2

* Pas d'affolement si l'écran se remplit
* de signes bizarres: il est utilisé
* pour les lignes 3276 à 4875

* les 4 derniers octets en bas à droite
* de l'écran clignotent au rythme des
* 'passes' de recherche et aident à pa-
* tienter... (pour 10000 lignes + les
* trois recherches décalées prévoir
* plusieurs heures--> 400 millions
* de combinaisons possibles à étudier!)

BANK1  EQU    5       =BANK4 EN BASIC
* LES BANKS 1 ET 2 ETANT OCCUPEES APRES
* bank 4 utilisée pour le code initial

       ORG    $7000   a ne pas changer!

       PSHS   A,B,CC,DP,X,Y,U
       LDX    #1
       STX    PTRP
       LDA    #BANK1
       STA    $E7E5
       LDX    #$A000
       LDU    #1

       LDX    #CALCUL
AFFIC1 LDB    ,X+
       BEQ    ONYVA
       JSR    $E803
       BRA    AFFIC1


ONYVA  PSHS   CC
       ORCC   #$50
       LDD    FINPTR  initialisé par
       STD    COMPT   le BASIC
       TFR    D,X
       LEAX   D,X
       LEAX   D,X
       LEAX   D,X
       LEAX   D,X
       CMPX   #24380
       BLO    PETIT
       LDA    #1
       STA    PARTIE
       LEAX   $1CAC,X
PETIT  STX    FINTAB

       LDB    #$14
       JSR    $E803
       LDA    $E7C3
       ORA    #$01
       STA    $E7C3
       LDA    #$62
       STA    $E7E6
       LDA    #BANK1
       STA    $E7E5
       LDX    #$A000
       LDY    #0
ADRESS LDA    ,X
       BPL    CODEFF
       LEAU   1,X
       BSR    CVINT
       LDA    15,X
       BPL    CODE0F
       LDA    #$24    '$'
       STA    15,X
       LEAU   16,X
       BSR    CVINT
       CLR    ,Y+
       BRA    FINLEC
CODE0F LDD    #$000F
       STA    ,Y+
       STD    ,Y++
       BRA    FINLEC
CODEFF LDD    #$0000
       STD    ,Y++
       STD    ,Y++
       DECA
       STA    ,Y+
FINLEC LEAX   40,X
       CMPX   #$DFE8
       BLO    MBANK2
       INC    $E7E5
       LDX    #$A000
MBANK2 DEC    COMPT+1
       BNE    PART0
       DEC    COMPT
       BMI    CROISE
PART0  TST    PARTIE
       BEQ    PART2
PART1  CMPY   #24380
       BLO    ADRESS
       DEC    PARTIE
       INC    $E7E6
       LDY    #$7BE8
       BRA    ADRESS
PART2  CMPY   #$A000
       BNE    ADRESS
       LDY    #0
       BRA    ADRESS

CVINT  LDB    #2
BCVINT LDA    ,U+
       SUBA   #$30
       CMPA   #$A
       BLO    CHIF1
       SUBA   #7
CHIF1  ASLA
       ASLA
       ASLA
       ASLA
       STA    ,Y
       LDA    ,U+
       SUBA   #$30
       CMPA   #$A
       BLO    CHIF2
       SUBA   #7
CHIF2  ORA    ,Y
       STA    ,Y+
       DECB
       BNE    BCVINT
       RTS

CROISE LDD    #$0362
       STD    $E7E5
       LDX    #$A000
       LEAY   $2000,X
BOCROI LDU    ,X
       LDD    ,Y
       STU    ,Y++
       STD    ,X++
       CMPX   #$C000
       BNE    BOCROI

ANALYS LDX    #0
       STX    $5F3C
       STX    $5F3E
       LDX    FINTAB
ANA    LEAX   3,X
       STX    FINTAC
       LDY    #0      TAB:XXXX,YYYY,ZZ
ANAL0  LDX    #$FFFE  XXXX>ADR.GAUCHE
       LDA    4,Y     YYYY>ADR.CENTRE
       BMI    ANA2    ZZ>FLAG GAUC/CENT.
ANA0   LDD    ,Y      0 NON AFFECTE
ANA1   LEAX   5,X     1 AFFECTE
       CMPX   #24383
       BNE    ANAC0
       LDX    #$7BEB
ANAC0  CMPX   FINTAC  F NON AFFECTABLE
       BHS    ANA2
       LDA    1,X
       ANDA   #$0F
       BNE    ANA1
       CMPB   ,X
       BNE    ANA1
       LDA    ,Y
       CMPA   -1,X
       BNE    ANA1
       LDA    4,Y
       ORA    #$10
       STA    4,Y
       LDA    1,X
       ORA    #$01
       STA    1,X
       STY    -1,X
       BRA    ANA1
ANA2   COM    $5F3C
       LEAY   5,Y
       CMPY   #24380
       BNE    ANAK0
       LDY    #$7BE8
ANAK0  CMPY   FINTAB
       BLO    ANAL0

       LDU    #TEMPO
       TST    FLAG1
       LBEQ   ETIK
       LDY    #0
ANAL1  LDX    #$FFFE
       LDA    4,Y
       BMI    ANA5
ANA3   LDD    ,Y
       ADDD   #1
       STA    ,U
ANA4   LEAX   5,X
       CMPX   #24383
       BNE    ANAC1
       LDX    #$7BEB
ANAC1  CMPX   FINTAC
       BHS    ANA5
       LDA    1,X
       ANDA   #$0F
       BNE    ANA4
       CMPB   ,X
       BNE    ANA4
       LDA    ,U
       CMPA   -1,X
       BNE    ANA4
       LDA    4,Y
       ORA    #$10
       STA    4,Y
       LDA    1,X
       ORA    #$02
       STA    1,X
       STY    -1,X
       BRA    ANA4
ANA5   COM    $5F3D
       LEAY   5,Y
       CMPY   #24380
       BNE    ANAK1
       LDY    #$7BE8
ANAK1  CMPY   FINTAB
       BLO    ANAL1

       TST    FLAG1
       LBEQ   ETIK
       LDY    #0
ANAL2  LDX    #$FFFE
       LDA    4,Y
       BMI    ANA8
ANA6   LDD    ,Y
       ADDD   #2
       STA    ,U
ANA7   LEAX   5,X
       CMPX   #24383
       BNE    ANAC2
       LDX    #$7BEB
ANAC2  CMPX   FINTAC
       BHS    ANA8
       LDA    1,X
       ANDA   #$0F
       BNE    ANA7
       CMPB   ,X
       BNE    ANA7
       LDA    ,U
       CMPA   -1,X
       BNE    ANA7
       LDA    4,Y
       ORA    #$10
       STA    4,Y
       LDA    1,X
       ORA    #$03
       STA    1,X
       STY    -1,X
       BRA    ANA7
ANA8   COM    $5F3E
       LEAY   5,Y
       CMPY   #24380
       BNE    ANAK2
       LDY    #$7BE8
ANAK2  CMPY   FINTAB
       BLO    ANAL2

       TST    FLAG3
       BEQ    ETIK
       LDY    #0
ANAL3  LDX    #$FFFE
       LDA    4,Y
       BMI    ANA11
ANA9   LDD    ,Y
       ADDD   #3
       STA    ,U
ANA10  LEAX   5,X
       CMPX   #24383
       BNE    ANAC3
       LDX    #$7BEB
ANAC3  CMPX   FINTAC
       BHS    ANA11
       LDA    1,X
       ANDA   #$0F
       BNE    ANA10
       CMPB   ,X
       BNE    ANA10
       LDA    ,U
       CMPA   -1,X
       BNE    ANA10
       LDA    4,Y
       ORA    #$10
       STA    4,Y
       LDA    1,X
       ORA    #$04
       STA    1,X
       STY    -1,X
       BRA    ANA10
ANA11  COM    $5F3F
       LEAY   5,Y
       CMPY   #24380
       BNE    ANAK3
       LDY    #$7BE8
ANAK3  CMPY   FINTAB
       BLO    ANAL3

ETIK   LDX    ETIQ0
       LDB    PAS
       LDY    #0
AFF1   LDA    4,Y
       ANDA   #$F0
       BLE    AFF2
       STX    ,Y
       ABX
AFF2   LEAY   5,Y
       CMPY   #24380
       BNE    AFFC0
       LDY    #$7BE8
AFFC0  CMPY   FINTAB
       BLO    AFF1

       CMPX   #9999
       LBHI   TOOBIG

       LDA    #BANK1
       STA    BANK
       LDY    #0
       LDX    #$A000
AFF3   LDA    #3
       STA    $E7E5
       LDA    4,Y
       ANDA   #$F0
       BEQ    AFF4
       BMI    AFF5
       LDD    ,Y
       TFR    X,U
       BSR    CVDEC
       BRA    AFF5
AFF4   LDA    BANK
       STA    $E7E5
       LDD    #$2020
       STD    ,X
       STD    2,X
       STA    4,X
AFF5   LDA    #3
       STA    $E7E5
       LDA    4,Y
       ANDA   #$0F    SI 0 OU F RIEN
       BEQ    AFF7
       CMPA   #$0F
       BEQ    AFF7
       DECA
       BEQ    AFF6
       ADDA   #$30
       PSHS   A
       LEAU   24,X
       LDA    BANK
       STA    $E7E5
       LDA    #$3D    '='
       STA    ,U+
       LDA    #3
       STA    $E7E5
       LDD    [2,Y]
       BSR    CVDEC
       LDA    #$2B    '+'
       PULS   B
       STD    ,U
       BRA    AFF7
AFF6   LEAU   15,X
       LDD    [2,Y]
       BSR    CVDEC
AFF7   LEAX   40,X
       CMPX   #$DFE8
       BLO    MBANK3
       INC    BANK
       LDX    #$A000
MBANK3 LEAY   5,Y
       CMPY   #24380
       BNE    AFFK0
       LDY    #$7BE8
AFFK0  CMPY   FINTAB
       LBLO   AFF3
       BRA    SAVE


CVDEC  PSHS   X
       TFR    D,X
       LDA    BANK
       STA    $E7E5
       LDA    ETIQ
       STA    ,U+
       LDD    #$3030
CVD1   CMPX   #1000
       BLO    CVD2
       INCA
       LEAX   -1000,X
       BRA    CVD1
CVD2   CMPX   #100
       BLO    CVD3
       INCB
       LEAX   -100,X
       BRA    CVD2
CVD3   STD    ,U++
       LDD    #$3030
CVD4   CMPX   #10
       BLO    CVD5
       INCA
       LEAX   -10,X
       BRA    CVD4
CVD5   LEAX   D,X
       STX    ,U++
       PULS   X,PC

SAVE   LDX    #SAUVE
AFFIC2 LDB    ,X+
       BEQ    SAV1
       JSR    $E803
       BRA    AFFIC2

SAV1   CLR    $E7E6
       PULS   CC
       LDX    #$8600
       STX    $6197
       LDX    #$8C00
       STX    $6199
       LDX    #$9400
       LDY    #5
       LDD    #$0402
       JSR    $EC0C
       LDX    #FILE
       LDA    ,X++
       SUBA   #$30
       STA    $6049
       LDU    #$624B
       LDD    #$2003
       STD    ,U++
       LDA    #$FF
       STA    ,U++
       LDB    #8
COPS   LDA    ,X+
       STA    ,U+
       DECB
       BNE    COPS
       LDD    #$4153  'AS'
       STD    ,U++
       LDD    #$4D09  'M'+8 octets
COPC   STA    ,U+
       LDA    ,X+
       DECB
       BNE    COPC
       LDB    #3      CODE DE OPEN
       JSR    $EC0C   OUVERTURE

       LDX    #$A000
       LDA    #BANK1
       STA    $E7E5
       LDY    FINPTR
       LEAY   -1,Y

LIGNE  LDU    16,X
       CMPU   26,X
       BNE    SAV2
       LDU    18,X
       CMPU   28,X
       BNE    SAV2
       LDD    #$2020
       STD    23,X
       STD    25,X
       STD    27,X
       STD    29,X
SAV2   LEAU   40,X
       LDD    #$2029
BCLFL  DECB
       LBEQ   FINLIN
       CMPA   ,-U
       BEQ    BCLFL
       TFR    X,U
       PSHS   B
       LDA    ,X
       CMPA   #$2A    '*'
       BNE    PASCOM
BCLCOM LDA    ,U+
       LDB    #4
       JSR    $EC0C
       DEC    ,S
       BNE    BCLCOM
       LBRA   FINLI0

PASCOM LDA    #$F7
       PSHS   A
BOUETI LDB    #4
       LDA    ,U+
       CMPA   #$20
       BEQ    FINETI
       DEC    ,S
       JSR    $EC0C
       BRA    BOUETI
FINETI PULS   A
       LDB    #4
       JSR    $EC0C

MNEMO  LDA    ,S
       CMPA   #7
       BLO    FINLI0
       LDA    #$F7
       PSHS   A
       LEAU   7,X
BOUMNE LDB    #4
       LDA    ,U+
       CMPA   #$20
       BEQ    FINMNE
       DEC    ,S
       JSR    $EC0C
       BRA    BOUMNE
FINMNE PULS   A
       LDB    #4
       JSR    $EC0C

OPERA  LDA    ,S
       CMPA   #14
       BLO    FINLI0
       SUBA   #14
       STA    ,S
       LEAU   14,X
       LDA    #$20
BOUESP CMPA   ,U
       BNE    BOUOPE
       LEAU   1,U
       DEC    ,S
       BRA    BOUESP
BOUOPE LDB    #4
       LDA    ,U+
       JSR    $EC0C
       DEC    ,S
       BNE    BOUOPE

FINLI0 PULS   A

FINLIN LDD    #$0D04
       JSR    $EC0C
       LEAX   40,X
       CMPX   #$DFE8
       BLO    MBANK4
       LDX    #$A000
       INC    $E7E5
MBANK4 LEAY   -1,Y
       LBNE   LIGNE
       LDB    #6
       JSR    $EC0C
       BRA    FIN

TOOBIG LDX    #TOMUCH
AFFIC3 LDB    ,X+
       BEQ    FIN
       JSR    $E803
       BRA    AFFIC3

FIN    PULS   A,B,DP,CC,X,Y,U,PC

COMPT  FDB    0       compteur
PARTIE FCB    0
BANK   FCB    0       SAUVEGARDE BANK
PTRP   FDB    0
FINPTR FDB    0
FINTAB FDB    0
FINTAC FDB    0
TEMPO  FCB    0
SAUVE  FCB    12
       FCC    #SAUVEGARDE EN COURS...#
       FCB    0
CALCUL FCB    12,31,24,1
       FCC    #CALCULS EN COURS...#
       FCB    0
TOMUCH FCB    12
       FCC    #PARAMETRES INCORRECTS#
       FCB    0
FLAG1  FCB    0
FLAG2  FCB    0
FLAG3  FCB    0
ETIQ   FCC    #B#
PAS    FCB    1
ETIQ0  FDB    0
FILE   FCC    #4:ESSAI   #
COMMEN FCC    #ASourcer#


       END
