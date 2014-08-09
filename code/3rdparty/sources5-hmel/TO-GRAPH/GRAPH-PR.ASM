       TITLE  TO-GRAPH: Programme princ.
*      ---------------------------------
       PAGE

****************************************
*                                      *
*           TO-GRAPH                   *
*                                      *
*    Programme principal               *
*                                      *
****************************************

DEBUT  EQU    *

* Initialisations
*---------------------------------------

* Pile
       LDS    #PILE

* Initialisation DOS sur zone réservée
* (5 disques 2 fichiers)
       LDD    #$7000
       STD    SECBUF
       ADDD   #256
       STD    FATPTR
       LDA    #5
       LDB    #166
       MUL
       ADDD   FATPTR
       TFR    D,X
       LDY    #5
       LDA    #2
       LDB    #FCBINI
       JSR    EXTRA

* DP sur zone tiroir (rapidité max !!!)
       LDD    #MANTIR
       TFR    A,DP

* Vérification RAM disponible
       LDA    MAXBK
       DECA             ->nb bank disp.
       CMPA   #11
       BGE    OKRAM     ->
       LDB    #FF       'Out of memory'
       JSR    PUTC
       LDX    #MOUT
BOUT   LDB    ,X+
       BEQ    BOUT1
       JSR    PUTC
       BRA    BOUT      ->
BOUT1  JSR    GETC
       TSTB
       BEQ    BOUT1     ->
       JMP    MENU      ->>>>>>

* Car. utilisateurs
OKRAM  LDD    #CARUSR
       STD    USERAF

* Outil courant
       LDA    #POINTS
       STA    OUTIL
       LDA    #1
       STA    TLIGN
       LDA    #TCN
       STA    TCAR

* Etat courant de l'outil
       LDA    #POINTE
       STA    ETAOUT
       CLR    COPALB    pas copie album

* Tortue standard
       LDA    #$FF
       STA    STDTOR

* Motif courant
       LDX    #CARMOT   damier
       LDY    #MOTREM
       LEAY   8*13,Y
BRZMOT LDA    ,Y+
       STA    ,X+
       CMPX   #MOTIF
       BNE    BRZMOT    ->
       LDB    #$FF      plein
BFFMOT STB    ,X+
       CMPX   #PLEIN
       BNE    BFFMOT    ->

* Visualisation
       LDB    #RESETW
       JSR    EXTRA

       LDB    #ESC      80 col
       JSR    PUTC
       LDB    #$5B
       JSR    PUTC

       LDD    MEMC0
       CMPD   #$FFFF
       BNE    SUIXY0    ->
       LDA    $E7E6     autorise écritur
       ORA    #$40      cartouche
       STA    $E7E6
       LDA    #0        mémo coul. 0
       LDX    #$FFFF
       LDY    #0
       JSR    SETP
       STX    MEMC0
       LDA    #1        mémo coul. 1
       LDX    #$FFFF
       LDY    #0
       JSR    SETP
       STX    MEMC1
       LDA    $E7E6     interdit écritur
       ANDA   #$BF      cartouche
       STA    $E7E6

       LDA    #1        nouv coul. 1
       LDX    #0
       LDY    MEMC0
       JSR    SETP
       LDA    #8        nouv.coul. 0
       LDX    #$FFFF
       LDY    #0
       JSR    SETP
       LDA    #0
       TFR    X,Y
       LDX    #0
       JSR    SETP
       BRA    SUIXY0    ->

MEMC0  FDB    $FFFF     mémo palette
MEMC1  FDB    $FFFF

* Bank RAM
SUIXY0 LDA    #BKTIR
       STA    BANKC

* Pas de tiroir ni de loupe ni d'album
* courant ni de dessin courant
       CLR    FLGTIR
       CLR    FLGLOU
       LDD    #0
       STD    ALBCOU
       STD    DESCOU
       STD    DESCOU+2
       STD    DESCOU+4
       STD    DESCOU+6

* Coefficient réel de passage point
* écran -> point imprimante
       LDX    #ASCCOE
       LDY    #ZONTRA
BVERRA LDA    ,X+
       STA    ,Y+
       BNE    BVERRA    ->
       LDY    #ZONTRA
       LDB    #EXTFIN
       JSR    EXTRA
       LDX    #COEFMU
       LDB    #MOVMF
       JSR    EXTRA

* Tortue du mode caractère
       LDY    #TORTXT
       LDB    #INITOR
       JSR    EXTRA
       CLR    TXTX+2
       CLR    TXTY+2
       CLR    FLGTXT
       CLR    CLITXT

* Position de l'écran dans la feuille et
* déplacement de celle-ci dans ses banks
       LDD    #0
       STD    <ADF
       CLR    <CLDECR
       CLR    <RGDECR

* Chien de garde par IT timer
       JSR    INIDOG

* Fenêtrage
       LDX    #ZONFEN
       LDA    #PBKPIL
       LDB    #DBKPIL
       TFR    D,U
       LDA    #NOIR
       LDB    #GRIS
       JSR    FENINI

* Activation Fenêtre principale
*---------------------------------------

       LDX    #FENPR
       LDD    #0
       JSR    FENRPL

       JSR    AFFOPT  Options courantes

       JSR    VISASB  Visu ascenceurs
       JSR    VISASD

       LDX    #FENTIT Titre
       LDD    #$0606
       JSR    FENOUV

       JSR    RAZF    raz feuille
       JSR    INIALB  chargement albums

       CLRB
       JSR    FENFER

       JSR    FENACT

* Attente principale
*---------------------------------------

EXEC1  LDU    #PILFEN   mémo retour FEN
       JSR    FEN
       PSHU   CC,D,X,Y
EXEC10 CMPB   #$90
       LBEQ   XFICH     ->
       CMPB   #$91
       LBEQ   XTIROI    ->
       CMPB   #$92
       LBEQ   XCADRA    ->
       CMPB   #$93
       LBEQ   XALBU     ->
       CMPB   #$94
       LBEQ   XIMPR     ->
       CMPB   #$98
       LBEQ   XALBUF    ->
       CMPB   #$0F
       LBEQ   XOUTI     ->
       CMPB   #$10
       LBEQ   XMOTI     ->
       CMPB   #$14
       LBEQ   XCTLIG    ->
       CMPB   #$15
       LBEQ   XCTCAR    ->
       CMPB   #$05
       LBEQ   XRAZ      ->
       CMPB   #$11
       LBEQ   XRET      ->
       CMPB   #BS
       LBEQ   XSCG      ->
       CMPB   #HT
       LBEQ   XSCD      ->
       CMPB   #VT
       LBEQ   XSCH      ->
       CMPB   #LF
       LBEQ   XSCB      ->
       CMPB   #$80+BS
       LBEQ   XPG       ->
       CMPB   #$80+HT
       LBEQ   XPD       ->
       CMPB   #$80+VT
       LBEQ   XPH       ->
       CMPB   #$80+LF
       LBEQ   XPB       ->
       CMPB   #INS
       LBEQ   XINS      ->
       CMPB   #$80
       LBEQ   XASCH     ->
       CMPB   #$81
       LBEQ   XASCV     ->

***----------------------------------***
***    Gestion des tracés
***----------------------------------***

EXEC3  LDA    ETAOUT
       CMPA   #POINTE
       LBNE   XTIRE     ->

       LDA    REGCC     #Etat pointage
       TFR    A,CC
       LBCC   EXEC4     pas clic ->
       LDX    #$0104    clic !
       LDY    #$174A
       JSR    SOUDAN
       LBCC   EXEC1     pas dans écran >
       JSR    PTOUT     // pointage
       LBRA   EXEC7     ->

EXEC4  LDX    #$0104
       LDY    #$174A
       JSR    SOUDAN
       LBCS   EXEC5     dans écran ->

       TST    STDTOR    -hors écran-----
       LBNE   EXEC7     tortue ok ->
       JSR    FENDES
       JSR    TRAMAX    tortue std
       LDA    #$FF
       STA    STDTOR
       CLRA
       CLRB
       JSR    FENTOR
       JSR    FENACT
       LBRA   EXEC7     ->

EXEC5  TST    STDTOR    -dans écran-----
       LBEQ   EXEC7     tortue ok ->
       JSR    FENDES
       JSR    TRAMIN
       CLR    STDTOR
       LDA    OUTIL
       CMPA   #CARACT
       BEQ    EXEC61    ASCII ->
       CMPA   #COLLER
       BEQ    EXEC60    COLLER ->
       LDX    #TORPT    pointage
       LDB    #LTORPT   -> croix fixe
       LDA    #1
       JSR    FENTOR
       JSR    FENACT
       LBRA   EXEC7     ->

EXEC60 JSR    TORCOL    tortue fixe
       BRA    EXEC69    selon tiroir

EXEC61 LDB    TCAR      ASCII
       SUBB   #TCN      -> rect. fixe
       PSHS   B
       LSLB
       ADDB   ,S+
       LDX    #TABTOR
       ABX
       LDB    2,X
       LDX    ,X
       LDA    #1
       JSR    FENTOR
EXEC69 JSR    FENACT

EXEC7  LDA    OUTIL
       CMPA   #LOUPE
       LBEQ   EXEC80    ->
       CMPA   #CARACT
       BEQ    EXEC75    ->
       CMPA   #COLLER
       BEQ    EXEC71    ->
       TST    COPALB
       BNE    EXEC70    ->
       LBRA   EXEC1     ->

*      Copie à partir album

EXEC70 LDA    REGCC
       TFR    A,CC
       BEQ    EXEC7A    ->
       LDA    REGB
       CMPA   #FF
       LBNE   EXEC1     ->
EXEC7A JSR    RAZOUT    fin copie album
EXEC7B JSR    LPIN
       BEQ    EXEC7B    ->
       LBRA   EXEC1     ->

*      Visu temporaire tiroir

EXEC71 LDA    REGCC
       TFR    A,CC
       LBNE   EXEC1     ->
       JSR    TMPTIR
       LBRA   EXEC1     ->

*      Visu caractère en dynamique ...

EXEC75 LDX    #$0104
       LDY    #$174A
       JSR    SOUDAN
       LBCC   EXEC1     hors écran ->
       LDB    REGB
       LBEQ   EXEC1     ->
       CMPB   #1
       BNE    EXEC8     ->
       LDX    #CARMOT   ctA=>motif cour.
       LDY    #TXTMOT
BCOPT0 LDD    ,X++
       STD    ,Y++
       CMPX   #MOTIF
       BNE    BCOPT0    ->
       BRA    EXEC9     ->
EXEC8  LDY    #TXTMOT   en mode pointage
       JSR    XTRMOT    dynamiquee
       LBCC   EXEC1     ->
EXEC9  JSR    FENDES   visu car.
       LDX    REGX
       LDY    REGY
       JSR    EXPCAR
       JSR    FENACT
       LBRA   EXEC1     ->

*      Visualisation loupe si déplac.

EXEC80 LDA    FLGLOU
       BEQ    EXEC81    ->
       CMPA   #2
       LBEQ   EXEC1     ->
       TST    REGA
       LBEQ   EXEC1     ->
EXEC81 JSR    VISLOU
       LBRA   EXEC1     ->

XTIRE  LDA    REGCC
       TFR    A,CC
       BEQ    ABANTI    abandon ->
       LDB    REGB
       CMPB   #FF
       BEQ    ABANTI    abandon ->
       LDA    REGCC
       TFR    A,CC
       BCS    XTIRE6    clic ->
       LDA    OUTIL
       CMPA   #CARACT
       BEQ    XTIRE4    saisie car. ->
       LDX    #$0104    # tracé
       LDY    #$174A
       JSR    SOUDAN
       LBCC   EXEC1     hors écran ->
       TST    REGA
       BNE    XTIRE5    mouvement ->
       LBRA   EXEC1     ->
XTIRE4 TST    REGB      # mode caract.
       LBEQ   EXEC1     rien frappé ->

XTIRE5 JSR    TIROUT    // tracé avant
       LBRA   EXEC1     ->          clic

XTIRE6 JSR    DESOUT    // dessin après
       LBRA   EXEC1     ->          clic

ABANTI EQU    *         abandon
       LDA    COPALB    RAZ et clic droi
       PSHS   A         ne fait que
       CLR    COPALB    abandon partiel
*                       si copie album
       JSR    RAZOUT
       PULS   A
       STA    COPALB
ABANT0 JSR    LPIN
       BEQ    ABANT0    ->
       LBRA   EXEC1     ->


*** INS = fonction page pour le scroll
XINS   JSR    FEN
       LDU    #PILFEN   mémo retour FEN
       PSHU   CC,D,X,Y
       TSTB
       BEQ    XINS      ->
       CMPB   #BS
       LBEQ   XPG       ->
       CMPB   #HT
       LBEQ   XPD       ->
       CMPB   #VT
       LBEQ   XPH       ->
       CMPB   #LF
       LBEQ   XPB       ->
       CMPB   #RS
       LBEQ   XRS       ->
       CMPB   #FF
       LBEQ   XFF       ->
       LBRA   EXEC10    ->

*** Sélection taille lignes
XCTLIG EQU    *
       JSR    TRAMAX
       LDA    OUTIL
       CMPA   #CARACT
       BNE    XCTLI0    ->
       LDA    ETAOUT
       CMPA   #TIRE
       BNE    XCTLI0    ->
       LDX    #$0104
       LDY    #$174A
       JSR    SOUDAN
       BCC    XCTLI0    pas dans écran >
       JSR    TRAMIN

XCTLI0 JSR    FENDES
       JSR    TRAMIN
       JSR    INVLIG
       INC    TLIGN
       LDA    TLIGN
       CMPA   #4
       BLT    XCTLI1    ->
       LDA    #1
       STA    TLIGN
XCTLI1 JSR    INVLIG
       JSR    TRAMAX
       JSR    AFFOPT

       LBRA   XCTCL     ->

*** Sélection taille caractères
XCTCAR EQU    *
       JSR    TRAMAX
       LDA    OUTIL
       CMPA   #CARACT
       BNE    XCTCA0    ->
       LDA    ETAOUT
       CMPA   #TIRE
       BNE    XCTCA0    ->
       LDX    #$0104
       LDY    #$174A
       JSR    SOUDAN
       BCC    XCTCA0    pas dans écran >
       JSR    TRAMIN

XCTCA0 JSR    FENDES
       JSR    EFFCAR
       INC    TCAR
       LDA    TCAR
       CMPA   #TCDT
       BLE    XCTCA1    ->
       LDA    #TCN
XCTCA1 STA    TCAR
       JSR    AFFCAR
       JSR    TRAMAX
       JSR    AFFOPT

XCTCL  LDA    OUTIL
       CMPA   #CARACT
       BNE    XCTCA2    ->
       LDA    ETAOUT
       CMPA   #TIRE
       BEQ    XCTCA3    souris std ->
*      BRA    XCTCA4    souris car ->

XCTCA2 LDX    #$0104
       LDY    #$174A
       JSR    SOUDAN
       BCS    XCTCA4    dans écran ->

XCTCA3 JSR    TRAMAX
       JSR    FENACT
       LBRA   EXEC1     ->
XCTCA4 JSR    TRAMIN
       JSR    FENACT
       LBRA   EXEC1     ->

*** Sélection FICHIER
XFICH  EQU    *
       JSR    RAZOUT
       JSR    SPFICH
       TSTB
       LBEQ   EXEC1     ->
       LBRA   EXEC10    ->

*** Sélection TIROIR     (F2)
XTIROI EQU    *
       JSR    RAZOUT
       JSR    SPTIRO
       TSTB
       LBEQ   EXEC1     ->
       LBRA   EXEC10    ->

*** Sélection CADRAGE    (F3)
XCADRA EQU    *
       JSR    RAZOUT
       LBSR   FENDES
       LBSR   SAUVE

       CLRA
       JSR    SPCADR
       BNE    XCADRX
       TSTB
       LBEQ   EXEC1     ->
       LBRA   EXEC10    ->
XCADRX CLRB
       JSR    FENFER
       JSR    RESTAU
       JSR    FENACT
       LBRA   EXEC1     ->

*** Sélection ALBUMS     (F4)
XALBU  EQU    *
       LDD    ALBCOU
       BEQ    XALBU2    ->
       LDU    #100
XALBU1 JSR    FEN
       CMPB   #$93
       LBEQ   XALBUF    double F4 ->
       LEAU   -1,U
       CMPU   #0
       BNE    XALBU1    ->

XALBU2 JSR    RAZOUT
       JSR    SPALBU
       TSTB
       LBEQ   EXEC1     ->
       LBRA   EXEC10    ->

*** Sélection IMPRESSION (F5)
XIMPR  EQU    *
       JSR    RAZOUT
       JSR    SPIMPR
       TSTB
       LBEQ   EXEC1     ->
       LBRA   EXEC10    ->

*** Sélection OUTILS     (ctrl) O
XOUTI  EQU    *
       JSR    RAZOUT
       JSR    SPOUTI
       TSTB
       LBEQ   EXEC1     ->
       LBRA   EXEC10    ->

*** Sélection MOTIFS     (ctrl) P
XMOTI  EQU    *
       JSR    RAZOUT
       JSR    SPMOTI
       TSTB
       LBEQ   EXEC1     ->
       LBRA   EXEC10    ->

*** Sélection EFFACEMENT (DEL)
XRAZ   EQU    *
       PSHS   B
       JSR    RAZOUT
       PULS   B
       JSR    SPRAZ
       TSTB
       LBEQ   EXEC1     ->
       LBRA   EXEC10    ->

*** Sélection RETOUR     (ctrl) Q
XRET   EQU    *
       JSR    RAZOUT
       JSR    FENDES
       JSR    RESTAU
       JSR    FENACT
       LBRA   EXEC1     ->

*** Sélection scroll G   (BS)
XSCG   EQU    *
       TST    FLGTXT
       LBEQ   XSCGS      scroll ->

       LDX    TXTX       mode caractère
       LEAX   -8,X
       LDA    TCAR
       CMPA   #TCN
       BEQ    XSCGT0    ->
       CMPA   #TCDH
       BEQ    XSCGT0    ->
       LEAX   -8,X
       CMPX   #16
       BLE    XSCGT2    ->
       BRA    XSCGT1    ->
XSCGT0 CMPX   #24
       BLE    XSCGT2    ->
XSCGT1 STX    TXTX
       LBRA   VITCAR    ->
XSCGT2 LDB    #7
       JSR    PUTC
       LBRA   EXEC1     ->

XSCGS  LDA    CLDECR
       LBEQ   EXEC1     au bout ->
       JSR    RAZOUT
       JSR    FENDES
       JSR    SAUVE
       DEC    CLDECR
       JSR    RESTAU
       JSR    VISASB
       JSR    FENACT
       LBRA   EXEC1     ->

*** Sélection scroll D   (HT)
XSCD   EQU    *
       TST    FLGTXT
       LBEQ   XSCDS      scroll ->

       LDX    TXTX       mode caractère
       LEAX   8,X
       LDA    TCAR
       CMPA   #TCN
       BEQ    XSCDT0    ->
       CMPA   #TCDH
       BEQ    XSCDT0    ->
       LEAX   8,X
XSCDT0 CMPX   #623
       BCC    XSCDT1    ->
       STX    TXTX
       LBRA   VITCAR    ->
XSCDT1 LDB    #7
       JSR    PUTC
       LBRA   EXEC1     ->

XSCDS  LDA    CLDECR
       CMPA   #23
       LBGE   EXEC1     au bout ->
       JSR    RAZOUT
       JSR    FENDES
       JSR    SAUVE
       INC    CLDECR
       JSR    RESTAU
       JSR    VISASB
       JSR    FENACT
       LBRA   EXEC1     ->

*** Sélection scroll H   (VT)
XSCH   EQU    *
       TST    FLGTXT
       LBEQ   XSCHS      scroll ->

       LDY    TXTY       mode caractère
       LEAY   -8,Y
       LDA    TCAR
       CMPA   #TCN
       BEQ    XSCHT0    ->
       CMPA   #TCDL
       BEQ    XSCHT0    ->
       LEAY   -8,Y
XSCHT0 CMPY   #8
       BLT    XSCHT1    ->
       STY    TXTY
       LBRA   VITCAR    ->
XSCHT1 LDB    #7
       JSR    PUTC
       LBRA   EXEC1     ->

XSCHS  LDA    RGDECR
       LBEQ   EXEC1     au bout ->
       JSR    RAZOUT
       JSR    FENDES
       JSR    SAUVE
       DEC    RGDECR
       JSR    RESTAU
       JSR    VISASD
       JSR    FENACT
       LBRA   EXEC1     ->

*** Sélection scroll B   (LF)
XSCB   EQU    *
       TST    FLGTXT
       LBEQ   XSCBS      scroll ->

       LDY    TXTY       mode caractère
       LEAY   8,Y
       LDA    TCAR
       CMPA   #TCN
       BEQ    XSCBT0    ->
       CMPA   #TCDL
       BEQ    XSCBT0    ->
       LEAY   8,Y
       CMPY   #207
       BGE    XSCBT2    ->
       BRA    XSCBT1    ->
XSCBT0 CMPY   #199
       BGE    XSCBT2    ->
XSCBT1 STY    TXTY
       LBRA   VITCAR    ->
XSCBT2 LDB    #7
       JSR    PUTC
       LBRA   EXEC1     ->

XSCBS  LDA    RGDECR
       CMPA   #79
       LBGE   EXEC1     au bout ->
       JSR    RAZOUT
       JSR    FENDES
       JSR    SAUVE
       INC    RGDECR
       JSR    RESTAU
       JSR    VISASD
       JSR    FENACT
       LBRA   EXEC1     ->

*** Sélection page   G   (INS+BS)
XPG    EQU    *
       TST    FLGTXT
       LBEQ   XPGS       scroll ->

       LDX    #32        mode caractère
       STX    TXTX
       LBRA   VITCAR    ->

XPGS   LDA    CLDECR
       LBEQ   EXEC1     au bout ->
       JSR    RAZOUT
       JSR    FENDES
       JSR    SAUVE
       CLR    CLDECR
       JSR    RESTAU
       JSR    VISASB
       JSR    FENACT
       LBRA   EXEC1     ->

*** Sélection page   D   (INS+HT)
XPD    EQU    *
       TST    FLGTXT
       LBEQ   XPDS       scroll ->

       LDX    #616       mode caractère
       LDA    TCAR
       CMPA   #TCN
       BEQ    XPDT0     ->
       CMPA   #TCDH
       BEQ    XPDT0     ->
       LDX    #608
XPDT0  STX    TXTX
       LBRA   VITCAR    ->

XPDS   LDA    CLDECR
       CMPA   #23
       LBGE   EXEC1     au bout ->
       JSR    RAZOUT
       JSR    FENDES
       JSR    SAUVE
       LDA    #23
       STA    CLDECR
       JSR    RESTAU
       JSR    VISASB
       JSR    FENACT
       LBRA   EXEC1     ->

*** Sélection page   H   (INS+VT)
XPH    EQU    *
       TST    FLGTXT
       LBEQ   XPHS       scroll ->

       LDY    #15        mode caractère
       LDA    TCAR
       CMPA   #TCN
       BEQ    XPHT0     ->
       CMPA   #TCDL
       BEQ    XPHT0     ->
       LDY    #23
XPHT0  STY    TXTY
       LBRA   VITCAR    ->

XPHS   LDA    RGDECR
       LBEQ   EXEC1     au bout ->
       JSR    RAZOUT
       JSR    FENDES
       JSR    SAUVE
       LDA    RGDECR
       SUBA   #20
       BGE    XPHS0     ->
       CLRA
XPHS0  STA    RGDECR
       JSR    RESTAU
       JSR    VISASD
       JSR    FENACT
       LBRA   EXEC1     ->

*** Sélection page   B   (INS+LF)
XPB    EQU    *
       TST    FLGTXT
       LBEQ   XPBS       scroll ->

       LDY    #191       mode caractère
       STY    TXTY
       LBRA   VITCAR    ->

XPBS   LDA    RGDECR
       CMPA   #79
       LBGE   EXEC1     au bout ->
       JSR    RAZOUT
       JSR    FENDES
       JSR    SAUVE
       LDA    RGDECR
       ADDA   #20
       CMPA   #79
       BLE    XPBS0     ->
       LDA    #79
XPBS0  STA    RGDECR
       JSR    RESTAU
       JSR    VISASD
       JSR    FENACT
       LBRA   EXEC1     ->

*** Sélection haut d'écran (ctrl)T
XRS    EQU    *
       TST    FLGTXT
       LBNE   EXEC3      mode caract. ->

       TST    CLDECR
       BNE    XRRS0     ->
       TST    RGDECR
       BNE    XRRS0     ->
       LBRA   EXEC1     au bout ->
XRRS0  JSR    RAZOUT
       JSR    FENDES
       JSR    SAUVE
       CLR    CLDECR
       CLR    RGDECR
       JSR    RESTAU
       JSR    VISASD
       JSR    VISASB
       JSR    FENACT
       LBRA   EXEC1     ->

*** Sélection bas  d'écran (ctrl)B
XFF    EQU    *
       TST    FLGTXT
       LBNE   EXEC3      mode caract. ->

       LDA    CLDECR
       CMPA   #23
       BNE    XFFS0     ->
       LDA    RGDECR
       CMPA   #79
       BNE    XFFS0     ->
       LBRA   EXEC1     au bout ->
XFFS0  JSR    RAZOUT
       JSR    FENDES
       JSR    SAUVE
       LDA    #23
       STA    CLDECR
       LDA    #79
       STA    RGDECR
       JSR    RESTAU
       JSR    VISASD
       JSR    VISASB
       JSR    FENACT
       LBRA   EXEC1     ->

*** Clic dans ascenseur horizontal
XASCH  LDD    REGX
       SUBD   #12*8
       LSRA
       RORB
       LSRA
       RORB
       LSRB
       SUBB   #15
       BPL    XASCH0    ->
       CLRB
XASCH0 CMPB   #23
       BLE    XASCH1    ->
       LDB    #23
XASCH1 CMPB   CLDECR
       LBEQ   EXEC1     ->
       PSHS   B
       JSR    RAZOUT
       JSR    FENDES
       JSR    SAUVE
       PULS   B
       STB    CLDECR
       JSR    VISASB
       JSR    RESTAU
       JSR    FENACT
       LBRA   EXEC1     ->

*** Clic dans ascenseur vertical
XASCV  LDD    REGY
       SUBB   #4*8
       LSRB
       LSRB
       LSRB
       SUBB   #2
       BPL    XASCV0    ->
       CLRB
XASCV0 LDA    #6
       MUL
       CMPD   #79
       BLE    XASCV1    ->
       LDD    #79
XASCV1 CMPB   RGDECR
       LBEQ   EXEC1     ->
       PSHS   B
       JSR    RAZOUT
       JSR    FENDES
       JSR    SAUVE
       PULS   B
       STB    RGDECR
       JSR    VISASD
       JSR    RESTAU
       JSR    FENACT
       LBRA   EXEC1     ->

*** Visu nouvelle tortue caractère
VITCAR JSR    FENDES
       JSR    TRAMIN
       LDY    #TORTXT
       LDB    #MOVE
       JSR    EXTRA
       JSR    TRAMAX    pour tortue sour
       JSR    FENACT
       LBRA   EXEC1     ->

*** Sélection copie album courant (F9)
***                     (ou double F4)
XALBUF JSR    RAZOUT
       LDX    ALBCOU
       LBEQ   EXEC1     pas alb. cour ->

* Nb: posit. bank car CODE maintient un
*     pseudo bank courant

       PSHS   X
       LDB    #ESC      tour magenta
       JSR    PUTC
       LDB    #$65
       JSR    PUTC

       JSR    FENDES
       JSR    SAUVE
       JSR    TRAMIN    fixe écran trav

       LDA    OUTIL     outil "copier"
       STA    COPAOU      temporaire
       LDA    #$FF
       STA    COPALB
       LDA    #COUCOP
       STA    OUTIL
       JSR    AFFOPT
       PULS   X

       LDD    #$A002
       STD    DEBZON
       LDA    BANKC     mémo
       LDB    8,X
       STB    BANKC
       DECB
       STB    DEBZON+2
       LDB    #$FF
       STB    PUTFLG
       LDB    #5
       STB    X0COD
       LDB    #1
       STB    Y0COD
       LDB    #CODE
       JSR    EXTRA
       STA    BANKC

       JSR    TRAMAX
       JSR    FENACT
       LBRA   EXEC1     ->
