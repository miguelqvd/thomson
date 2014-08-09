****************************************
*                                      *
* - BOOTINI : CHARGEMENT AUTOMATIQUE - *
*                                      *
* - SUR LA PISTE 0 ET ET LE SECTEUR 1  *
*                                      *
* - INITIALISATION  EFFACEMENT TITRE - *
*                                      *
****************************************

* DISQUE RESEAU 1

* TITRE DU LOGICIEL ... : 49144/49151

* ADR. DEB.LOG. MOINS 5 : à la suite +1

* ADR. DE FIN LOGICIEL  : à la suite +1

* ADR. D'EXECUTION LOG. : à la suite +1


ZDEBUT EQU    49000

       ORG    ZDEBUT


       JSR    59392
       LEAU   TABINI,PCR
BCLINI LDB    ,U+
       JSR    59395
       CMPB   #67     Fin Initialisation
       BNE    BCLINI
       LEAU   TABNOM,PCR
BCLNOM LDB    ,U+     C'est ici que le
       TSTB           programme BASIC
       BEQ    SUITE1  implante le titre
       JSR    59395   du Logiciel
       BRA    BCLNOM

SUITE1 LDB    #27
       JSR    59395   Rétablissement de
       LDB    #76     l' ATTRB 0,0
       JSR    59395

       LDX    ,U++    Déb.Log. MOINS 5
       LDD    #21     A = 0  B = 21
       STD    24650   Piste = 21

BOUCLE STX    24655   Buffer Début Log.
       INCA           Début A = 1
       CMPA   #16     Secteur No.16  ?
       BHI    SUIBCL
       STA    24652   Registre de Sect.
       LDB    #2
       STB    24648   Mot de Lecture
       JSR    59434   Routine DSK
       LEAX   255,X
       CMPX   ,U      Adr. Fin du Log.
       BLO    BOUCLE

       LEAU   2,U
       LDX    ,U
       JMP    ,X

SUIBCL CLRA
       INC    24651   Registre de Piste
       BRA    BOUCLE

TABINI FCB    20,27,80,27,96,12,31,76,81
       FCB    27,77,27,67,0,0,0,0,0,0,0
       FCB    0,0,0,0,0,0,0,0,0,0,0,0,0
       FCB    0,0,0,0,0,0,0,0,0,0,0,0,0
       FCB    0,0,0,0,0,0,0,0,0,0,0

TABNOM FCB    0,0,0,0,0,0,0,0,0,0,0,0
       FCB    0,0,0,0,0,0,0,0,0,0,0,0
       FCB    0,0,0,0,0,0,0,0,0,0,0,0
       FCB    0,0,0,0,0,0,0,0,0,0,0,0
       FCC    *BOOTSTRAP REALISE PAR JR*
       FCC    *.QUIROZ - NOVEMBRE 1989 *
       FCB    0,0,0,0,0,0,0,0,0,0,0,0,0
       FCB    0,0,0,0,0,0,0,0,0,0,0,0,0
ZZZFIN FCB    0

       END    ZDEBUT
