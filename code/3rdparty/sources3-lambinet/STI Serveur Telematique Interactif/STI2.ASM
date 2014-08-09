***************************************
*                                     *
* ***** ***** *   Serveur Télématique *
* *       *       Interactif ver. 1.4 *
* *       *   * ***    * du 02/05/92  *
* *****   *   *   *   **    A.S.C.I.  *
*     *   *   * ***    *    NANCY     *
*     *   *   * *      *    1991/1992 *
* *****   *   * *** * ***   Copyright *
*                                     *
***************************************


       ORG    $8800

TAMPON RMB    $180

HEURE  FCB    0
MINUT  FCB    0
SECON  FCB    0
DIXIE  FCB    0
FLGPAL FCB    0

LIRE   JMP    DECOMP  lit et décompacte
     * un message depuis le secteur 4,P
     * ([$604B]),S([$604C]) pour la par-
     * tie 0/1 selon la valeur de TAMPON
     * le message est en clair sur les
     * 127 premiers octets du secteur
     * (4,20,1) sur le premier RAM-DISK.

SAUVE  JMP    SAUV    cherche une place
     * libre sur le disque (optimisée),
     * et l'inscrit en $604B/C et TAMPON
     * puis saute à ECRIRE.

ECRIRE JMP    COMPAC  compacte le texte
     * écrit en TAMPON+1 et l'enregistre
     * sur les disks 1 puis 4 en fonct.
     * de $604B/$604C et TAMPON (0/1).

RECHER JMP    CHERCH  recherche tous les
     * messages pour le No inscrit en
     * TAMPON et en dresse la liste à
     * partir de $A002 sur la bank cou-
     * rante (2octets=Piste & Sect/Part)
     * nombre de messages en $A000

PAGTEL JMP    PTEL    affiche un fichier
     * .TEL dont le nom est en $624F

LIT5   JMP    LIRE5   lit le secteur 5'
     * de no contenu en $6AB2/3 (N%)

ECR5   JMP    ECRI5   écrit (voir haut)

AFF5   JMP    AFFIC5  affiche une page
     * type tel depuis le 5'1/4

INIT   PSHS   A,B,CC,DP,X,Y,U
       CLR    $87FE
       CLR    $87FF
       LDX    $6027
       STX    ANCTI+1
       LDX    #TIMER
       STX    $6027
       LDA    $6019
       ORA    #$20
       STA    $6019
       LDX    #INTER
       STX    $67C1
       LDA    #$7E
       STA    $67C0
       PULS   A,B,CC,DP,X,Y,U,PC

HORPLU PSHS   A,CC
       BRA    HP
HORLOG PSHS   A,CC
       LDA    #10
       STA    DIXIE
       INC    SECON
       LDA    SECON
       CMPA   #60
       BLO    PALETT
HP     CLR    SECON
       INC    MINUT
       LDA    MINUT
       CMPA   #60
       BLO    PALETT
       CLR    MINUT
       INC    HEURE
       LDA    HEURE
       CMPA   #24
       BLO    PALETT
       CLR    HEURE
       INC    $607C
       LDA    $607C
       CMPA   #32
       BEQ    MOISUI
       CMPA   #31
       BNE    FEVBIS
       LDA    $607D
       CMPA   #4
       BEQ    MOISUI
       CMPA   #6
       BEQ    MOISUI
       CMPA   #9
       BEQ    MOISUI
       CMPA   #11
       BEQ    MOISUI
       BRA    PALETT
FEVBIS CMPA   #30
       BNE    FEVNOR
       LDA    $607D
       CMPA   #2
       BNE    PALETT
       LDA    $607E
       ANDA   #3
       BEQ    MOISUI
       BRA    PALETT
FEVNOR CMPA   #29
       BNE    PALETT
       LDA    $607D
       CMPA   #2
       BNE    PALETT
       LDA    $607E
       ANDA   #3
       BEQ    PALETT
MOISUI LDA    #1
       STA    $607C
       INC    $607D
       LDA    $607D
       CMPA   #13
       BNE    PALETT
       LDA    #1
       STA    $607D
       INC    $607E
PALETT PULS   A,CC,PC

TIMER  PSHS   A,CC
       DEC    DIXIE
       BNE    SORTIM
       PSHS   B,X,Y
       LBSR   HORLOG
       LDX    #PAL
       LDA    $6AD6
       CMPA   #1
       BNE    SORPAL
       LDA    FLGPAL
       INCA
       ANDA   #1
       STA    FLGPAL
       BEQ    PAL0
       LEAX   16,X
PAL0   TST    $E7E7
       BPL    PAL0
PAL1   TST    $E7E7
       BMI    PAL1
       LDY    #$200
PAL2   LEAY   -1,Y
       BNE    PAL2
       LDY    #$E7DA
       CLR    1,Y
       LDB    #32
PAL3   LDA    ,X+
       STA    ,Y
       DECB
       BNE    PAL3
SORPAL PULS   B,X,Y
SORTIM PULS   A,CC
ANCTI  JMP    $FFFF

PAL    FDB    $0000,$0F00,$F000,$FF00
       FDB    $000F,$0F0F,$F00F,$FF0F
       FDB    $0000,$0F00,$F000,$FF00
       FDB    $000F,$0F0F,$F00F,$FF0F
       FDB    $0000,$0000,$0000,$0000
       FDB    $0000,$0000,$0000,$0000

INTER  PSHS   CC,X
       CMPA   #$AB    =PRINT
       BNE    QUIT
       LDX    $61C7
       LDX    1,X
       CMPX   #$2330  APPEL EMISSION
       BEQ    MODEM         CANAL 0
       CMPX   #$2322  RETOUR D'EMISSION
       BEQ    PRINT
       CMPX   #$2323  EMISSION CANAL 1
       BNE    QUIT
       LDX    SAVPTR
       STX    $61C7
QUIT   PULS   CC,X,PC

MODEM  PULS   CC,X
       PSHS   A,B,CC,DP,X,Y,U
       LDX    #ZONE
       LDY    #POKE
       BSR    COPIE
       LDX    $61C7
       LEAX   4,X
       CLRB
AUTRE  LDA    ,X+
       BEQ    M2
       CMPA   #$22
       BNE    M0
       COMB
M0     TSTB
       BNE    M1
       CMPA   #$3A
       BEQ    M2
M1     STA    ,Y+
       BRA    AUTRE
M2     LEAX   -3,X
       LDA    1,X
       CMPA   #$3B
       BNE    ERROR
       STX    SAVPTR
       LDX    #ZONE+11
       LEAY   -1,Y
       BSR    COPIE
       LDX    #POKE-1
       STX    $61C7
       LDX    #TAMPON
BLANC  CLR    ,X+
       CMPX   #TAMPON+300
       BLO    BLANC
ERROR  PULS   A,B,CC,DP,X,Y,U,PC

COPIE  LDA    ,X+
       BEQ    FINCOP
       STA    ,Y+
       BRA    COPIE
FINCOP RTS

PRINT  PULS   CC,X
       PSHS   A,B,CC,DP,X,Y,U
       LDY    #POKE-1
       STY    $61C7
       LEAY   1,Y
       LDX    #ZONE+16
       BSR    COPIE
       LDX    #TAMPON
       LDA    $6AD6
       CMPA   #2
       BNE    MODIF
       CLR    ,Y+
       CLR    ,Y+
MODIF  LDA    ,X+
       LBEQ   FINMOD
       CMPA   #$5C    \ escape
       BEQ    ESCAPE
       CMPA   #$16
       BNE    CARAC
       LDB    $6AD6
       CMPB   #1
       BEQ    CARAC
       ADDA   #3
CARAC  STA    ,Y+
       BRA    MODIF

ESCSUI LDA    ,X+
       LBEQ   FINMOD
       CMPA   #$3A
       BEQ    ESC0
       CMPA   #$5C
       BNE    ESCSUI
       BRA    MODIF

ESCAPE LDA    ,X+
       LBEQ   FINMOD
       CMPA   #$5C    \ si \\ alors \
       BEQ    CARAC
       BRA    ESC1
ESC0   LDA    ,X+
       LBEQ   FINMOD
       CMPA   #$5C    \ sortie ESCAPE
       BEQ    MODIF
ESC1   CMPA   #$41    A (ATTRB)
       BNE    ESC2
       LBSR   PARA
       LDB    $6A58
       LDU    #PARA1
       LDA    ,U+
       BMI    ATT2
       BEQ    ATT1
       ORB    #2
       BRA    ATT2
ATT1   ANDB   #1
ATT2   TST    ,U+
       BMI    ATT4
       BEQ    ATT3
       ORB    #1
       BRA    ATT4
ATT3   ANDB   #2
ATT4   ANDB   #3
       STB    $6A58
       ADDB   #$4C
       LDA    #$1B
       STD    ,Y++
       LDB    ,U+
       BMI    ATT7
       ANDB   #1
       STB    $6AAC
       BEQ    ATT5
       LDB    #$58
       BRA    ATT6
ATT5   LDB    #$5F
ATT6   STD    ,Y++
ATT7   LDB    ,U+
       BMI    ATT8
       LBRA   LIGNA

ESC2   CMPA   #$42    B (Beep)
       BNE    ESC3
       LDB    #7
       STB    ,Y+
ATT8   LBRA   ESCSUI

ESC3   CMPA   #$43    C (Couleurs)
       BNE    ESC4
       LBSR   PARA
       LDU    #PARA1
       LDB    ,U+
       BMI    CO0
       ANDB   #$7
       STB    $6A66
       ADDB   #$40
       LDA    $6AD6
       ANDA   #1
       BEQ    CO00
       TST    $6A9E
       BEQ    CO00
       ADDB   #$30
CO00   LDA    #$1B
       STD    ,Y++
CO0    LDB    ,U+
       BMI    CO1
       ANDB   #$7
       STB    $6A7B
       ADDB   #$50
       LDA    $6AD6
       ANDA   #1
       BEQ    CO10
       TST    $6A9E
       BEQ    CO10
       ADDB   #$28
CO10   LDA    #$1B
       STD    ,Y++
CO1    LDB    ,U+
       BMI    CO2
       ANDB   #1
       STB    $6A90
       SUBB   #$5D
       NEGB
       LDA    #$1B
       STD    ,Y++
CO2    LDB    ,U+
       BMI    CO3
       ANDB   #1
       LBRA   KLI1
CO3    LBRA   ESCSUI

ESC4   CMPA   #$44    D=Démasquage total
       BNE    ESC5
       LDD    #$1B23
       STD    ,Y++
       LDD    #$205F
       STD    ,Y++
       LBRA   ESCSUI

ESC5   CMPA   #$45    E=Effacement
       BNE    ESC6
       LDA    #$0C
       STA    ,Y+
       LBRA   ESCSUI

ESC6   CMPA   #$46    F=Masquage total
       BNE    ESC7
       LDD    #$1B23
       STD    ,Y++
       LDD    #$2058
       STD    ,Y++
       LBRA   ESCSUI

ESC7   CMPA   #$47    G=Générateur de
       BNE    ESC8    caractères
       LBSR   PARA
       LDA    PARA1
       ANDA   #1
       STA    $6A82
       BNE    GEN0
       LDA    #$0F
       BRA    GEN1
GEN0   LDA    #$0E
GEN1   STA    ,Y+
ESC7F  LBRA   ESCSUI

ESC8   CMPA   #$48
       BNE    ESC9
       LDA    #$1E
       BRA    GEN1

ESC9   CMPA   #$49    I=Insertion
       BNE    ESC69
       LDA    ,X
       CMPA   #$4C    L=Ligne
       BNE    ESC91
       LDD    #$1B5B
       STD    ,Y++
       LDB    #$4C
       STB    ,Y+
       BRA    ESC94
ESC91  CMPA   #$43    C=Caractère début
       BNE    ESC92
       LDB    #$68
       BRA    ESC93
ESC92  CMPA   #$46    F=Fin d'insertion
       BNE    ESC7F   de caractères
       LDB    #$6C
ESC93  LDA    #$1B
       STA    ,Y+
       LDA    #$5B
       STA    ,Y+
       LDA    #$34
       STD    ,Y++
ESC94  LEAX   1,X
       BRA    ESC7F

ESC69  CMPA   #$69
       BNE    ESCB
       LDB    $6A90
       ANDB   #1
       INCB
       ANDB   #1
       STB    $6A90
       SUBB   #$5D
       NEGB
       LDA    #$1B
       STD    ,Y++
       LBRA   ESCSUI

ESCB   CMPA   #$4B    K=Klignotement
       BNE    ESCC
       LDB    $6A9E
       ANDB   #1
       INCB
       ANDB   #1
KLI1   STB    $6A9E
       LDA    $6AD6
       ANDA   #1
       BNE    KLITO
       SUBB   #$49
       NEGB
       LDA    #$1B
       STD    ,Y++
KLI2   LBRA   ESCSUI
KLITO  LDA    #$1B
       LDB    $6A66
       ANDB   #7
       ADDB   #$40
       TST    $6A9E
       BEQ    KLIT1
       ADDB   #$30
KLIT1  STD    ,Y++
       LDB    $6A7B
       ANDB   #$7
       ADDB   #$50
       TST    $6A9E
       BEQ    KLIT2
       ADDB   #$28
KLIT2  STD    ,Y++
       BRA    KLI2

ESCC   CMPA   #$4C    L=Locate
       BNE    ESC4D
       LBSR   PARA
       LDU    #PARA1
       LDD    ,U++
       CMPD   #$FFFF
       BEQ    LO4
       PSHS   A
       TSTB
       BPL    LO0
       LDB    $6B00
LO0    CMPB   #25
       BLO    LO1
       CLRB
LO1    STB    $6B00
       ADDB   #$40
       LDA    #$1F
       STD    ,Y++
       PULS   B
       TSTB
       BPL    LO2
       LDB    $6AF9
LO2    CMPB   #40
       BLS    LO3
       CLRB
LO3    STB    $6AF9
       ADDB   #$41
       STB    ,Y+
LO4    LDB    ,U+
       BMI    LO7
       ANDB   #1
       STB    $6AEB
       BEQ    LO5
       LDB    #$11
       BRA    LO6
LO5    LDB    #$14
LO6    STB    ,Y+
LO7    LDB    ,U+     LIGNAGE EN MODE
       BMI    LO8     GRAPH SOULIGNAGE
LIGNA  ANDB   #1      EN MODE NORMAL
       STB    $6AA5
       LDA    $6AD6
       ANDA   #1
       BNE    LO8     Lignage SIMUL
       ADDB   #$59
       LDA    #$1B
       STD    ,Y++
LO8    LBRA   ESCSUI

ESC4D  CMPA   #$4D    M=Mode
       LBNE   ESC4E
       LDA    ,X
       CMPA   #$53    S=Scroll
       BNE    ESC4D1
       LDB    #$69
       BRA    ESC4D2
ESC4D1 CMPA   #$50    P=Page
       BNE    ESC4D3
       LDB    #$6A
ESC4D2 LEAX   1,X
       LDA    #$1B
       STA    ,Y+
       LDA    #$3A
       STD    ,Y++
       LDA    #$43
       STA    ,Y+
ESC4D3 LBRA   ESCSUI

ESC4E  CMPA   #$4E    N=nouvelle ligne
       BNE    ESC52
       LDD    #$0A0D
       STD    ,Y++
       LDB    $6A66
       ADDB   #$40
       LDA    $6AD6
       ANDA   #1
       BEQ    EO00
       TST    $6A9E
       BEQ    EO00
       ADDB   #$30
EO00   LDA    #$1B
       STD    ,Y++
       LDB    $6A7B
       ADDB   #$50
       LDA    $6AD6
       ANDA   #1
       BEQ    EO10
       TST    $6A9E
       BEQ    EO10
       ADDB   #$28
EO10   LDA    #$1B
       STD    ,Y++
       LDB    $6A58
       ADDB   #$4C
       STD    ,Y++
       LDA    #$20
       STA    ,Y+
E020   BRA    ESC4D3

ESC52  CMPA   #$52    R=Répétition
       BNE    ESC53
       LBSR   PARA
       LDB    PARA1
       CMPB   #63
       BHI    E020
       LDA    #$12    rep
       ADDB   #$40
       STD    ,Y++
       BRA    E020

ESC53  CMPA   #$53    S=Suppression
       BNE    ESC58
       LDA    ,X
       CMPA   #$4C    Ligne
       BNE    ESC531
       LDB    #$4D
       BRA    ESC532
ESC531 CMPA   #$43    Caractère
       BNE    ESC4D3
       LDB    #$50
ESC532 LEAX   1,X
       LDA    #$1B
       STA    ,Y+
       LDA    #$5B
       STD    ,Y++
       BRA    ESC4D3

ESC58  CMPA   #$58    X=effacement de
       BNE    ESC5E   la fin de la ligne
       LDA    #$18
       STA    ,Y+
       BRA    E020

ESC5E  CMPA   #$5E    ^ Déplacements
       BNE    ESCN
DEA    LDA    ,X+
       LBEQ   FINMOD
       CMPA   #$3A    :
       BEQ    DE0
       CMPA   #$5C    \
       BNE    DE1
DE0    LEAX   -1,X
       LBRA   ESCSUI
DE1    ANDA   #$5F
       CMPA   #$42    B=bas
       BNE    DE3
       LDA    #10
       BRA    DEX
DE3    CMPA   #$44    D=droite
       BNE    DE4
       LDA    #9
       BRA    DEX
DE4    CMPA   #$47    G=gauche
       BNE    DE5
       LDA    #8
       BRA    DEX
DE5    CMPA   #$48    H=haut
       BNE    DE6
       LDA    #11
       BRA    DEX
DE6    CMPA   #$4E    N=Nouvelle ligne
       BNE    DE8
DE7    LDA    #10
DEX    STA    ,Y+
       BRA    DEA
DE8    CMPA   #$52    R=Retour chariot
       BNE    DEA
       LDA    #13
       STA    ,Y+
       BRA    DE7

ESCN   LBRA   ESC0


FINMOD LDX    #POKE+4
       LDA    $6AD6
       CMPA   #2
       BEQ    AFMINI  Affichage MINITEL
AFTOMO CLR    ,Y      Affichage TO+MODEM
AFTM0  LDB    ,X+
       BEQ    EXITEL
       TST    $6AD6
       BNE    AFTO
AFTM1  LDA    $E7FE
       BITA   #2
       BEQ    AFTM1
       STB    $E7FF
       BRA    AFTM0
AFTO   JSR    $E803
       BRA    AFTM0
AFMINI LBSR   TEL
EXITEL LDY    #POKE
       LDX    #ZONE+22
FINMAX LBSR   COPIE
       PULS   A,B,CC,DP,X,Y,U,PC

PARA   PSHS   Y,U     Recherche des
       LDY    #PARA1  paramètres (4 max)
       LDD    #$FFFF
       STD    ,Y
       STD    2,Y
       CLRB

PAR0   LDA    ,X+
       BEQ    SORPAR
       CMPA   #$3A    :
       BEQ    AUTPAR
       CMPA   #$5C    \
       BEQ    AUTPAR
       CMPA   #$2C    ,
       BEQ    AUTPAR
       CMPA   #$30    0
       BLO    AUTPAR
       CMPA   #$39    9
       BHI    VAR
       SUBA   #$30
       LDB    ,Y
       BPL    PAR1
       CLRB
       STB    ,Y
PAR1   ASLB
       ASLB
       ASLB
       ADDB   ,Y
       ADDB   ,Y
       STB    ,Y
       ADDA   ,Y
       STA    ,Y
       BRA    PAR0

VAR    CMPA   #$41    A
       BLO    AUTPAR
       CMPA   #$5A    Z
       BLS    VAR0
       CMPA   #$61    a
       BLO    AUTPAR
       CMPA   #$7A    z
       BHI    AUTPAR
       SUBA   #$20
VAR0   SUBA   #$41
       STA    ,Y
       ASLA
       ASLA
       ASLA
       SUBA   ,Y
       LDU    #$6A58
       TFR    A,B
       CLRA
       LEAU   D,U
       LDB    ,U
       STB    ,Y
       BRA    PAR0

AUTPAR CMPA   #$2C
       BNE    SORPAR
       LEAY   1,Y
       CMPY   #PARA4
       BHI    SORPAR
       CLRB
       BRA    PAR0

SORPAR LEAX   -1,X
       PULS   U,Y,PC

PTEL   PSHS   U,Y,X,DP,B,A,CC
       LDD    #$1003
       STA    $624B
       JSR    $EC0C
       LDX    #$A000
       TFR    X,Y
       CLR    ,Y+
       CLR    ,Y+
       LDA    #$61
       TFR    A,DP
INPUT  LDB    #5
       JSR    $EC0C
       LDA    $6AD6
       BNE    PT1
PT0    LDA    $E7FE
       BITA   #2
       BEQ    PT0
       LDA    <$96
       STA    $E7FF
       BRA    PT2
PT1    LDA    <$96
       STA    ,Y+
       CMPY   #$DFFF
       BHI    CPTEL
PT2    TST    <$78
       BEQ    INPUT
CPTEL  LEAY   -1,Y
       LDB    #6
       JSR    $EC0C
       LDA    $6AD6
       BEQ    FPTEL
       CMPA   #2
       BEQ    COMBLE
       LDB    #$FF
       STB    ,Y+
PT3    LDB    ,X+
       BMI    FPTEL
       CMPB   #19
       BNE    PT4
       LDB    #22
PT4    JSR    $E803
       BRA    PT3
FPTEL  PULS   U,Y,X,DP,B,A,CC,PC

TEL    PSHS   U,Y,X,DP,B,A,CC
COMBLE LDD    #$1B3A
       STD    ,Y++
       LDD    #$6AFE
       STD    ,Y++
       LDD    #$E7FD
       TFR    A,DP
       STB    <$C2
       TFR    X,U
       LBSR   ROUT1
       LDX    #$1000
TEMP1  LEAX   -1,X
       BNE    TEMP1
       CLRB
       ORCC   #$50
TOMI0  LDA    #$07
       STA    ,S
       BSR    ROUT1
       LDX    #$0060
       STX    <$C6
       LDA    #$A2
       STA    <$C5
       CLRA
       BSR    ROUT2
TOMI1  LSRB
       BCC    TOMI2
       BSR    ROUT1
       INCA
       BRA    TOMI3
TOMI2  BSR    ROUT2
TOMI3  DEC    ,S
       BNE    TOMI1
       BITA   #$01
       BNE    TOMI4
       BSR    ROUT2
       BRA    TOMI5
TOMI4  BSR    ROUT1
TOMI5  LDB    ,U+
       BPL    TOMI0
       PULS   CC,A,B,DP,X,Y,U,PC

ROUT1  PSHS   X,A
       LDA    <$C5
       ORA    #$80
       BRA    TOMI6
ROUT2  PSHS   X,A
       LDA    <$C5
       ANDA   #$7F
       BRA    TOMI6
TOMI6  STA    <$C5
       LDX    #$0061
TEMP2  LEAX   -1,X
       BNE    TEMP2
       PULS   A,X,PC

CHERCH PSHS   A,B,DP,CC,X,Y,U
       LDX    TAMPON
       STX    VAL+1
       LDY    #$A002
       LDA    $E7E5
       TFR    A,DP
       LDA    #$10
CH0    STA    $E7E5
       LDU    #$A000
       LDB    #$80
CH1    LDX    ,U
VAL    CMPX   #$0000  VALEUR CHERCHEE
       BNE    CH2
       LDX    2,U
       STX    POKE
       LDX    4,U
       STX    POKE+2
       LDX    6,U
       STX    POKE+4
       PSHS   A,B
       PSHS   U
       EXG    A,DP
       STA    $E7E5
       EXG    DP,A
       ANDA   #$0F
       LSLB
       LSLB
       ROLA
       LSLB
       ROLA
       LSRB
       LSRB
       LSRB
       LDU    #TABLE
       LDA    A,U
       STD    ,Y++
       LDD    POKE
       STD    ,Y++
       LDD    POKE+2
       STD    ,Y++
       LDA    POKE+4
       CLRB
       STD    ,Y++
       PULS   U
       PULS   A,B
       STA    $E7E5
CH2    LEAU   128,U
       INCB
       BNE    CH1
       INCA
       CMPA   #$20
       BLO    CH0
CH3    TFR    DP,A
       STA    $E7E5
       LEAX   ,Y
       STX    LIMTR1+2
       LEAX   -8,X
       STX    LIMTR0+1
       LEAX   -$A002,Y
       TFR    X,D
       LSRA
       RORB
       LSRA
       RORB
       LSRA
       RORB
       STD    $A000
       CMPD   #$0002
       BLO    TRI4
       LDX    VAL+1
       BEQ    TRI4
       LDX    #$A002
TRI0   LEAY   8,X
TRI1   LDB    #4
TRI2   LDA    B,X
       CMPA   B,Y
       BHI    PERM
       BLO    TRI3
       INCB
       CMPB   #7
       BLO    TRI2
       BRA    TRI3
PERM   LDB    #6
PERM0  LDA    B,X
       TFR    A,DP
       LDA    B,Y
       STA    B,X
       TFR    DP,A
       STA    B,Y
       DECB
       BPL    PERM0
TRI3   LEAY   8,Y
LIMTR1 CMPY   #$0000
       BLO    TRI1
       LEAX   8,X
LIMTR0 CMPX   #$0000
       BLO    TRI0
TRI4   PULS   A,B,DP,CC,X,Y,U,PC

SAUV   PSHS   A,B,DP,CC,X,Y,U
       LDA    $E7E5
       TFR    A,DP
       LDX    #$FFFF
       LDY    #POKE
       STX    ,Y
       STX    2,Y
       LDA    #$10
EC0    STA    $E7E5
       LDU    #$A000
       LDB    #$80
EC1    LDX    ,U
       CMPX   #$0000  VALEUR VIDE
       BNE    EC6
       PSHS   A,B,U
       ANDA   #$0F
       LSLB
       LSLB
       ROLA
       LSLB
       ROLA
       LSRB
       LSRB
       LSRB
       LDU    #TABLE
       LDA    A,U
       STD    4,Y
       SUBA   $6052
       BPL    EC2
       NEGA
EC2    STA    6,Y
       CMPA   2,Y
       BHI    EC5
       BEQ    EC3
       LDA    #$FF
       STA    3,Y
EC3    LDA    4,Y
       SUBA   #20
       BPL    EC4
       NEGA
EC4    STA    7,Y
       CMPA   3,Y
       BHS    EC5
       LDX    4,Y
       STX    ,Y
       LDX    6,Y
       STX    2,Y
EC5    PULS   A,B,U
EC6    LEAU   128,U
       INCB
       BNE    EC1
       INCA
       CMPA   #$20
       BLO    EC0
       TFR    DP,A
       STA    $E7E5
       CLR    TAMPON
       LDD    ,Y
       LSRB
       BCC    EC7
       COM    TAMPON
EC7    INCB
       STD    $604B
       BRA    EC8

COMPAC PSHS   A,B,DP,CC,X,Y,U
EC8    LDD    $604B
       CMPA   #63
       LBHI   COMP2
       DECB
       CMPB   #15
       LBHI   COMP2
       LDY    #POKE
       STY    $604F
       LDA    #$94
       STA    $60CD
       LDD    #$0204
       STD    $6048
       JSR    $E004
       LBSR   HORPLU
       LDD    #$2804
       PSHS   A
       LDX    #TAMPON
       LDA    ,X+
       BEQ    COMP0
       LEAY   128,Y
COMP0  LDA    ,X+
       STA    ,Y+
       DECB
       BNE    COMP0
       LDD    $607D
       SUBB   #90
       CMPB   #10
       BLO    DAT0
       ADDB   #100
DAT0   LSLA
       LSLA
       LSLA
       LSLA
       LSLA
       ROLB
       LSLA
       ROLB
       LSLA
       ROLB
       LSLA
       ROLB
       STB    ,Y+
       LDA    $607C
       LDB    HEURE
       LSLB
       LSLB
       LSLB
       LSLB
       ROLA
       LSLB
       ROLA
       LSLB
       ROLA
       STA    ,Y+
       LDA    MINUT
       LSLA
       LSLA
       LSLB
       PSHS   CC
       LSLB
       RORA
       PULS   CC
       RORA
       STA    ,Y+
COMP1  LDA    ,X+
       SUBA   #$20
       LDB    ,X+
       SUBB   #$20
       LSLB
       LSLB
       LSLB
       ROLA
       LSLB
       ROLA
       STA    ,Y+
       LSLB
       ROLA
       LSLB
       ROLA
       LSLB
       ROLA
       LSLB
       ROLA
       LDB    ,X+
       SUBB   #$20
       LSLB
       LSLB
       LSLB
       ROLA
       LSLB
       ROLA
       LSLB
       ROLA
       LSLB
       ROLA
       STA    ,Y+
       LSLB
       ROLA
       LSLB
       ROLA
       LDB    ,X+
       SUBB   #$20
       LSLB
       LSLB
       LSRA
       RORB
       LSRA
       RORB
       STB    ,Y+
       DEC    ,S
       BNE    COMP1
       PULS   B
       LDD    #$0801
       STD    $6048
       LDX    #POKE
       STX    $604F
       JSR    $E004
       LDD    #$0482
       STA    $6049
       JSR    $E004
       STB    $60CD
       BRA    COMP3
COMP2  LDA    #$FF
       STA    $604E
COMP3  BSR    DIROK
       PULS   A,B,DP,CC,X,Y,U,PC

DIROK  LDY    #$C000
       LDD    #$0820
DIR0   STB    ,Y+
       DECA
       BNE    DIR0
       RTS

DECOMP PSHS   A,B,DP,CC,X,Y,U
       LDA    $E7E5
       TFR    A,DP
       LDA    #$0F
       STA    $E7E5
       LDD    $604B
       CMPA   #63
       LBHI   DECO2
       DECB
       CMPB   #15
       LBHI   DECO2
       LDA    #$94
       STA    $60CD
       LDD    #$0204
       STD    $6048
       LDX    #TAMPON+1
       STX    $604F
       JSR    $E004
       TST    $604E
       LBNE   DECO3
       BSR    DIROK
       LDD    #$2804
       PSHS   A
       LDA    TAMPON
       BEQ    DECO0
       LEAX   128,X
DECO0  LDA    ,X+
       STA    ,Y+
       DECB
       BNE    DECO0
       LDA    ,X
       LSRA
       LSRA
       LSRA
       LSRA
       ADDA   #90
       CMPA   #100
       BLO    DAT2
       SUBA   #100
DAT2   STA    ,Y+
       LDA    ,X+
       ANDA   #$0F
       STA    ,Y+
       LDA    ,X
       LSRA
       LSRA
       LSRA
       STA    ,Y+
       LDA    ,X+
       ANDA   #7
       LDB    ,X
       LSLB
       ROLA
       LSLB
       ROLA
       STA    ,Y+
       LDA    ,X+
       ANDA   #$3F
       STA    ,Y+
DECO1  LDA    ,X
       LSRA
       RORB
       LSRA
       RORB
       ADDA   #$20
       STA    ,Y+
       LDD    ,X+
       ANDA   #3
       LSLB
       ROLA
       LSLB
       ROLA
       LSLB
       ROLA
       LSLB
       ROLA
       ADDA   #$20
       STA    ,Y+
       LDD    ,X++
       ANDA   #15
       LSLB
       ROLA
       LSLB
       ROLA
       ADDA   #$20
       LSRB
       LSRB
       ADDB   #$20
       STD    ,Y++
       DEC    ,S
       BNE    DECO1
       TFR    DP,A
       STA    $E7E5
       PULS   A
       BRA    DECO3
DECO2  LDA    #$FF
       STA    $604E
DECO3  LDA    #$82
       STA    $60CD
       PULS   A,B,DP,CC,X,Y,U,PC

AFFIC5 PSHS   A,B,DP,CC,X,Y,U
       LDA    #5
       STA    $E7E5
       LDD    $6AB2
       CMPD   #0053
       LBHI   FAFF5
       LDA    #2
       MUL
       STD    $6AB2
       LDA    #2
       LDX    #$A000
       LBSR   PREPA5
       INC    $6AB3
       LDA    #2
       LDX    #$A200
       LBSR   PREPA5
       LDX    #$A000
       LDY    #$A400
       LDD    #0
       STD    ,Y++
       STD    ,Y++
       LDD    #$0C14
       STD    ,Y++
       LDA    #25
       STA    LIGNE
NOUVLI DEC    LIGNE
       BEQ    PRINT5
       LDA    #40
       STA    COLON
OCTSUI LDA    ,X+
       CMPX   #$A400
       BHI    PRINT5
       CMPA   #$0D
       BNE    ESTAFF
       LDB    ,X+
       DEC    COLON
       BMI    NOUVLI
AFFD   LDD    #$0D0A
       STD    ,Y++
       BRA    NOUVLI
ESTAFF CMPA   #32
       BLO    OCTSUI
       CMPA   #128
       BLO    OCTAFF
       CMPA   #161
       BHI    OCTSUI
       SUBA   #128
       LDB    #3
       MUL
       LDU    #TABPC
       LEAU   B,U
       LDD    ,U++
       STD    ,Y++
       LDA    ,U
OCTAFF DEC    COLON
       BMI    OCTSUI
       STA    ,Y+
       BRA    OCTSUI

PRINT5 LDU    #$A400
       LDD    #$1F41
       STA    -1,Y
       STB    ,Y+
       STB    ,Y+
       LDA    $6AD6
       CMPA   #1
       LBEQ   COMBLE
       LDB    #255
       STB    ,Y++
       TSTA
       BNE    ECRAN
ATTMOD LDA    $E7FE
       BITA   #2
       BEQ    ATTMOD
       LDA    ,U+
       BEQ    ATTMOD
       BMI    FAFF5
       STA    $E7FF
       BRA    ATTMOD
ECRAN  LDB    ,U+
       BEQ    ECRAN
       BMI    FAFF5
       CMPB   #$13
       BNE    ECOK
       LDB    #$16
ECOK   JSR    $E803
       BRA    ECRAN

FAFF5  PULS   A,B,DP,CC,X,Y,U,PC

PREPA5 STA    $6048
       STX    $604F
       LDX    $6AB2
       BMI    PB5
       CMPX   #719
       BHI    PB5
       LDA    #2
       STA    LIGNE
AGIR5  LDA    #$D4
       STA    $E7E7
       LDX    $E000
       CMPX   #$444B
       BEQ    OK5
       LDA    #$54
       STA    $E7E7
PB5    LDX    #$FFFF
       STX    $6AB2
       LEAS   2,S
       PULS   A,B,DP,CC,X,Y,U,PC
OK5    LDA    $6052
       LDB    $6054
       STA    $6054
       STB    $6052
       CLR    $6058
       LDX    $6AB2
       LDA    #$FF
TEST5  INCA
       LEAX   -9,X
       CMPX   #0
       BPL    TEST5
       LEAX   10,X
       STX    $604B
       PSHS   A
       ANDA   #1
       STA    $6049
       PULS   A
       LSRA
       STA    $604B
       JSR    $E004
       LDA    #$54
       STA    $E7E7
       LDA    $6052
       LDB    $6054
       STA    $6054
       STB    $6052
       CLR    $6058
       LDA    $604E
       BEQ    SOROK5
       DEC    LIGNE
       BEQ    SPB5
       LDA    $6048
       LDB    $6052
       PSHS   A,B
       CLR    $6052
       CLR    $6054
       LDD    #$D420
       STA    $E7E7
       STB    $6048
       JSR    $E004
       LDD    #$5401
       STB    $6048
       JSR    $E004
       STA    $E7E7
       PULS   A,B
       STA    $6048
       STB    $6052
       LBRA   AGIR5
SPB5   LDX    #999
       STX    $6AB2
SOROK5 RTS

LIRE5  PSHS   A,B,DP,CC,X,Y,U
       LDA    #2
       LDX    #$9800
       LBSR   PREPA5
       LDD    #$0804
       STD    $6048
       LDD    #$1401
       STD    $604B
       JSR    $E004
       PULS   A,B,DP,CC,X,Y,U,PC

ECRI5  PSHS   A,B,DP,CC,X,Y,U
       LDA    #8
       LDX    #$9800
       LBSR   PREPA5
       PULS   A,B,DP,CC,X,Y,U,PC

LIGNE  FCB    0
COLON  FCB    0

SAVPTR FCB    0,0

PARA1  FCB    0
PARA2  FCB    0
PARA3  FCB    0
PARA4  FCB    0

TABPC  FCB    $1B,$48,32,$13,$48,$75
       FCB    $13,$42,$65,$13,$43,$61
       FCB    $13,$48,$61,$13,$41,$61
       FCB    0,32,0,$13,$4B,$63
       FCB    $13,$43,$65,$13,$48,$65
       FCB    $13,$41,$65,$13,$48,$69
       FCB    $13,$43,$69,$1B,$5D,32
       FCB    0,32,0,0,32,0,0,32,0
       FCB    $1B,$4C,32,$1B,$4D,32
       FCB    $13,$43,$6F,$13,$48,$6F
       FCB    $13,$41,$6F,$13,$43,$75
       FCB    $13,$41,$75,0,32,0,0,32,0
       FCB    0,32,0,$1B,$49,32,22,23,0
       FCB    0,32,0,0,32,0,0,32,0
       FCB    $13,$42,$61,$1B,$5C,32

TABLE  FCB    62,63,60,61,58,59,56,57
       FCB    54,55,52,53,50,51,48,49
       FCB    46,47,44,45,42,43,40,41
       FCB    38,39,36,37,34,35,32,33
       FCB    30,31,28,29,26,27,24,25
       FCB    22,23,19,21,17,18,15,16
       FCB    13,14,11,12,9,10,7,8
       FCB    5,6,3,4,1,2,20,0

ZONE   FCB    $3B,$3A,$AA,$26,$48,$38
       FCB    $38,$30,$30,$2C,0

       FCB    $3A,$AB,$23,$22,0

       FCB    $23,$31,$2C,$22,0

       FCB    $22,$3B,$3A,$AB,$23,$23,0

POKE   RMB    300

FIN    FCB    0

       END
