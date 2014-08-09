DSKO   EQU    $E82A
DKOPC  EQU    $6048
DKDRV  EQU    $6049
DKTRK  EQU    $604A
DKSEC  EQU    $604C
DKNUM  EQU    $604D
DKSTA  EQU    $604E
DKBUF  EQU    $604F

       ORG    $9000
DEBUT  LEAY   TEXT2,PCR
       LBSR   ECRA1
DEB1   JSR    $E806
       ANDB   #$DF
       TSTB
       BEQ    DEB1
       CMPB   #$59
       BEQ    YETI
       CMPB   #$50
       BEQ    PULSAR
       CMPB   #$45
       BNE    DEB1
ELIM   LBSR   ECRAN
       LDX    #$7000
       PSHS   X
       LDA    #1
       BSR    FIXE
ELIM1  LDA    #0
       LDB    #4
       LDX    #$9000
       BSR    LISSEC
       JMP    $9000
YETI   LBSR   ECRAN
       LDA    #4
YETI2  LDX    #$A000
       PSHS   X
       BSR    LOADBA
       BRA    ELIM1
PULSAR LBSR   ECRAN
       LDA    #8
       BRA    YETI2







***************************************
*        LECTURE D'UN SECTEUR         *
* A=PISTE B=SECTEUR X=@BUFFER         *
***************************************
LISSEC PSHS   Y
       LDY    #DKOPC
       CLR    2,Y     NUMERO DE
       STA    3,Y     PISTE
       STB    4,Y     SECTEUR
       CLR    1,Y     DRIVE 0
       STX    7,Y     @BUFFER
       LDA    #2
       STA    ,Y
       JSR    DSKO
       PULS   Y,PC


****************************************
* LECTURE D'UN FICHIER BINAIRE         *
* POUR LA BANQUE FIXE DE $7000 à$9FFF  *
* DANS LES PISTES 1-2-3                *
****************************************
FIXE
       LDX    #$7000
       TFR    A,B
       ADDB   #3
       STB    COM+1,PCR
       LDB    #1
BOU1   PSHS   X,D
       BSR    LISSEC
       PULS   X,D
       LEAX   256,X
       INCB
       CMPB   #17
       BNE    BOU1
       LDB    #1
       INCA
COM    CMPA   #4
       BNE    BOU1

       RTS



***************************************
* CHARGEMENT D'UNE BANQUE             *
* A=NUMERO DELA 1ERE PISTE            *
***************************************
LOADBA LDX    #$A000
       TFR    A,B
       ADDB   #4
       STB    COMPT+1,PCR
       LDB    #1
BOU2   PSHS   X,D
       BSR    LISSEC
       PULS   X,D
       LEAX   256,X
       INCB
       CMPB   #17
       BNE    BOU2
       LDB    #1
       INCA
COMPT  CMPA   #5
       BNE    BOU2
       RTS

ECRAN

       LEAY   TEXTE,PCR

ECRA1  LDB    ,Y+
       BEQ    FIN
       JSR    $E803
       BRA    ECRA1
FIN    RTS
TEXTE  FCB    $1B,$64,$1B,$47,27,$54,$C
       FCC    ''
       FCC    'Copyright Loriciels 1986'
       FCB    10,13,10,10,10,10
       FCB    0
TEXT2  FCB    $1B,$54,$1B,$64,$47,$0C
       FCB    $1B,$4F,$1F,$48,$4A,$1B
       FCB    $5C
       FCC    'Y'
       FCB    $1B,$4E,$1B,$5C
       FCC    'ETI'
       FCB    $1F,$4B,$4A,$1B,$4F,$1B
       FCB    $5C
       FCC    'P'
       FCB    $1B,$4E,$1B,$5C
       FCC    'ULSAR'
       FCB    $1F,$4E,$4A,$1B,$5C,$1B
       FCB    $4F
       FCC    'E'
       FCB    $1B,$4E,$1B,$5C
       FCC    'LIMINATOR'
       FCB    $1B,$4C,0


       END
