****************************************
*                                      *
*            ECHOCAR.ASM               *
*                                      *
*      Contacthoms No 13 page 10       *
*                                      *
*--------------------------------------*
*                                      *
*  Programme en assembleur pour avoir  *
*  l'écho de la souris à l'écran.      *
*                                      *
****************************************

       TITLE  ECHO    DU CARACTERE

GETL   EQU    $E818   Acq. coor. X,Y
SELMEM EQU    $E7C3   Select. for/color
NBCOL  EQU    $605F   40 ou 80 colonnes
MEMECR EQU    $4000   Adr deb mem écran
*
*
*
       ORG    $DF00
ECHO00 EQU    *
       PSHS   X,Y,U,D
*
* Acquisition coordonnées point visé
*
ECHO10 EQU    *
       JSR    GETL
       BCS    ECHO99
*
* Le point visé est-il le même ?
*
       TFR    Y,D
       ANDB   #$F8
       PSHS   D
       TFR    X,D
       ANDB   #$F8
       PSHS   D
       CMPD   XPREC,PCR
       BNE    ECHO20  NON: inverse
       LDD    2,S
       CMPD   YPREC,PCR
       BNE    ECHO20  NON: inv mm point
       LEAS   4,S
       BRA    ECHO10  Attend changement
*
* Remise point prec en vidéo normal
*
ECHO20 EQU    *
       LDX    XPREC,PCR
       BMI    ECHO30  Première fois
       LDY    YPREC,PCR
       BSR    INVERS
*
* Met le point en vidéo inverse
*
ECHO30 EQU    *
       LDX    0,S
       STX    XPREC,PCR
       LDY    2,S
       STY    YPREC,PCR
       BSR    INVERS
       LEAS   4,S
ECHO99 EQU    *
       PULS   X,Y,U,D,PC
*
* Met un caractère en vidéo inverse
*
* Entrée x,y coordonnées point
* du début du caractère.
*
INVERS EQU    *
       PSHS   X,Y,U,D
*
* Calcul adresse début du caractère
* dans écran.
*
       LDU    #MEMECR
       TFR    Y,D
       LDA    #40
       MUL
       LEAU   D,U
       TFR    X,D
       LSRA
       RORB
       LSRA
       RORB
       LSRB
       LDA    #01
       ORA    >SELMEM Force plan forme
       TST    NBCOL   40 ou 80 colonnes
       BPL    INVE20
       LSRB
       BCC    INVE20  Pair-->forme
       LDA    #$FE    80 col mais col
       ANDA   >SELMEM Impair-->couleur
INVE20 EQU    *
       LEAU   B,U     U=adr deb caract
       STA    >SELMEM
*
* Met le caractère en vidéo inverse
*
       LDA    #8
INVE70 EQU    *
       COM    ,U
       LEAU   40,U
       DECA
       BNE    INVE70
*
* Fin
*
INVE99 EQU    *
       PULS   X,Y,U,D,PC
*
*
XPREC  FDB    -1
YPREC  FDB    -1
       END

****************************************
*                                      *
* PROGRAMME BASIC D'ACCOMPAGNEMENT:    *
*                                      *
* 10 BANK0:CLEAR,&HDFEF                *
* 20 LOADM"ECHOCAR.BIN"                *
* 30 CLS:LOCATE0,0,0                   *
* 40 ATTRB1:PRINT"EN 40 COLONNES"      *
* 50 GOSUB 100                         *
* 60 CONSOLE,,,,1                      *
* 70 ATTRB1:PRINT"EN 80 COLONNES"      *
* 80 GOSUB 100                         *
* 90 CONSOLE,,,,0:SCREEN4,6,6:END      *
* 100 BANK0                            *
* 110 DO                               *
* 120 EXEC &HDF00                      *
* 130 IF MTRIG(0) THEN EXIT            *
* 140 LOOP                             *
* 150 IF MTRIG(0) THEN 150             *
* 160 RETURN                           *
*                                      *
****************************************

* Un appui (prolongé !) sur le bouton
* gauche de la souris vous fait passer
* en 80 colonnes.
