****************************************
*            BOOT / Menu          v2.0 *
****************************************

       ORG    $6200

       ORCC   #80     stop interruptions
       LDS    #$60CC  init. pile système
       CLR    >$60D1  application = none
       LDX    #$6300   charge le menu
       LDY    #$0002
       LDD    #$0100   (secteur 00.02)
       BSR    DISK
       BRA    RSTART
       FCC    "HCL  Boot"
RSTART LDU    #$6300
PRINT  LDB    ,U+       et l'affiche
       JSR    $E803
       BNE    PRINT

GETKEY JSR    $E806
       CMPB   #'0     première option
       BLO    GETKEY
       LBEQ   NOBOOT  retour au BASIC
       CMPB   $62FF   dernière option
       BHI    GETKEY
       LDX    #$6280-8*'1
       LDA    #8
       MUL
       LEAX   D,X
       LDY    ,X++    Piste - Secteur
       LDD    ,X++    Nb secteurs - Face
       LDU    ,X++    Adresse exécution
       LDX    ,X      Adresse de début
       STU    LEAVE+1
       BSR    DISK    chargement ...
LEAVE  JSR    >0000     ... et exécution
       BRA    RSTART

DISK   LDU    #$6048
       STB    1,U     face          : B
       LDB    #2
       STB    ,U
       STY    3,U     piste.secteur : Y
       STX    7,U     buffer        : X
       LDB    4,U     secteur -> B
CHARGE JSR    $E004
       CMPB   #16     fin piste ?
       BNE    NXTSEC
       INC    3,U
       CLRB
NXTSEC INCB
       STB    4,U
       INC    7,U
       DECA
       BNE    CHARGE
       RTS

****************************************
* Valeur-test: "BASIC2.." complémenté: *
****************************************

       FDB    $BEBF,$ADB7,$BDCE,$0000

****************************************
* Définition d'un programme (8 octets) *
*                                      *
* Piste - Secteur                      *
* Nombre de secteurs - Face            *
* Adresse d'exécution                  *
* Adresse de début                     *
****************************************

       FDB    $0001,$2301,$93F7,$7200
       FDB    $0204,$0101,$6442,$6400
       FDB    $0605,$0701,$9000,$9000
       FDB    $060C,$0101,$6300,$6300
       FDB    0,0,0,0,0,0,0,0
       FDB    0,0,0,0,0,0,0,0
       FDB    0,0,0,0,0,0,0,0
       FDB    0,0,0,0,0,0,0,0

       ORG    $62E0
NOBOOT CLR    >0
       JSR    $2B42
       LDS    #$9FFF
       CLR    >1
       JSR    $193
       COM    <$31
       STS    $6C43
       CLR    >0
       JSR    $2D00
       JMP    $2B74

       FCB    '4      dernière option

       END
