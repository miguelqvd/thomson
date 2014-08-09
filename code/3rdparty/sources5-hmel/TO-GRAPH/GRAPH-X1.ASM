       TITLE  TO-GRAPH: Traitement
*      ------------------------------
       PAGE

****************************************
*                                      *
*           TO-GRAPH                   *
*                                      *
*    Traitement: GRAPH-X               *
*                                      *
****************************************


*=======================================
* S/P traitement du dessin définitif
*=======================================

DESOUT EQU    *
*---------------------------------------

DESOU0 JSR    LPIN      anti-rebond
       BCS    DESOU0    ->

       JSR    FENDES
       LDB    OUTIL
       LSLB
       ADDB   OUTIL
       LEAX   XDEOUT,PCR
       JSR    B,X
       JSR    FENACT
       LDB    #POINTE   et rebelote !!!
       STB    ETAOUT
XDF    RTS              ->>
*---------------------------------------
XDEOUT LBRA   XDF       points
       LBRA   XDLIGN
       LBRA   XDRECT
       LBRA   XDRECT    carré
       LBRA   XDELLI
       LBRA   XDELLI    cercle
       LBRA   XDCARA    caractère
       LBRA   XDF       peinture
       LBRA   XDF       gomme
       LBRA   XDF       loupe
       LBRA   XDCOUC    couper/copier
       LBRA   XDF       coller
*---------------------------------------

XDCARA JSR    RAZOUT
*-----
       RTS

XDCOUC LEAS   -2,S
*-----
MEMACT SET    0
MEMCOP SET    1

*      calculer coord. en croissant
       LDD    X0TIRE
       STD    <XT0
       LDD    X1TIRE
       STD    <XT1
       CMPD   X0TIRE
       BCC    XDCC0     ->
       STD    <XT0
       LDD    X0TIRE
       STD    <XT1
XDCC0  LDA    Y0TIRE+1
       STA    <YT0
       LDA    Y1TIRE+1
       STA    <YT1
       CMPA   Y0TIRE+1
       BCC    XDCC1     ->
       STA    <YT0
       LDA    Y0TIRE+1
       STA    <YT1

*      calcul dimensions point de la
*      zone... on ignore si trop petite
*      (erreur probable !)
XDCC1  LDA    <YT1
       SUBA   <YT0
       INCA
       CMPA   #8
       LBCS   XDCCFI    ->
       LDD    <XT1
       SUBD   <XT0
       ADDD   #1
       CMPD   #8
       LBCS   XDCCFI    ->

*      sélection du traitement appliqué
*      à la zone sélectionnée sauf en
*      copie d'album ou on ne fait que
*      "copier"
       LDA    COPALB
       STA    MEMCOP,S
       BEQ    XDCC00    ->
       CLR    COPALB    pour RAZOUT !!!
       LDA    #$43
       STA    MEMACT,S
       LBRA   XDCC05    ->

XDCC00 LDB    Y1TIRE+1
       LSRB
       LSRB
       LSRB
       LDA    #16
       CMPB   #16
       BLE    XDCC40    ->
       TFR    A,B
XDCC40 PSHS   B
       LDD    X1TIRE
       LSRA
       RORB
       LSRA
       RORB
       LSRB
       LDA    #60
       CMPB   #60
       BLE    XDCC41    ->
       TFR    A,B
XDCC41 PULS   A
       LDX    #FFCOUC
       JSR    FENOUV
       JSR    FENACT
XDCC42 JSR    FEN
       CMPB   #$03
       BEQ    XDCC43    ->
       CMPB   #$43
       BEQ    XDCC43    ->
       CMPB   #$49
       BEQ    XDCC43    ->
       CMPB   #FF
       BNE    XDCC42    ->
       CLRB
       JSR    FENFER
XDCCFI LEAS   2,S
       LEAS   2,S       RTS de XDCOUC
       JSR    FENACT
       RTS              ->>

XDCC43 STB    MEMACT,S
       CLRB
       JSR    FENFER
XDCC05 JSR    RAZOUT
       JSR    FENDES

*      acquérir le tiroir sur l'écran
       JSR    LITTIR

*      effectuer le traitement demandé
*      sur la zone sélectionnée
       LDB    MEMACT,S
       CMPB   #$03
       BEQ    XDCC50    ->
       CMPB   #$49
       LBEQ   XDCC70    ->

*      simple copie
       TST    MEMCOP,S
       BEQ    XDCCFF    ->
       LDB    #ESC      fin copie album
       JSR    PUTC
       LDB    #$60
       JSR    PUTC
       LDA    COPAOU
       STA    OUTIL
       JSR    AFFOPT
       JSR    RESTAU    restaure visu
XDCCFF LEAS   2,S       simple copie !
       RTS              ->>

*      effacement zone mise en tiroir
XDCC50 LDA    #$FF
       STA    FILFLG
       LDD    #PLEIN
       STD    MACP
       JSR    TRRAZ
       LDX    X0TIRE
       STX    XXXXXX
       LDY    Y0TIRE
       STY    YYYYYY
       LDX    X1TIRE
       LDY    Y1TIRE
       LDB    #BOX
       JSR    EXTRA
       JSR    TRNORM
       LEAS   2,S
       RTS              ->>

*      inversion zone mise en tiroir
XDCC70 LDA    #$FF
       STA    FILFLG
       LDD    #PLEIN
       STD    MACP
       JSR    TRINV
       LDX    X0TIRE
       STX    XXXXXX
       LDY    Y0TIRE
       STY    YYYYYY
       LDX    X1TIRE
       LDY    Y1TIRE
       LDB    #BOX
       JSR    EXTRA
       JSR    TRNORM
       LEAS   2,S
       RTS              ->>

*      abandon de la sélection
XDCC80 JSR    FENFER
       CLR    <FLGTIR
       LDA    TLIGN
       PSHS   A
       LDA    #1
       STA    TLIGN
       JSR    TRINV
       JSR    TRRECT
       JSR    TRINV
       JSR    TRLIGN
       PULS   A
       STA    TLIGN
       LEAS   2,S
       RTS              ->>

XDRECT EQU    *
*-----
       JSR    TRREMP
       JSR    TRRECT
       RTS

XDLIGN EQU    *
*-----
       JSR    TRLIGN
       RTS

XDELLI EQU    *
*-----
       JSR    TRREMP
       JSR    TRELLI
       RTS


*=======================================
* S/P traitement d'un clic de pointage
*     en mode POINTE
*=======================================

PTOUT  EQU    *
*---------------------------------------

       LDB    OUTIL
       CMPB   #GOMME
       BEQ    PTOUT1    ->
       CMPB   #POINTS
       BEQ    PTOUT1    ->

PTOUT0 JSR    LPIN      anti-rebond
       BCS    PTOUT0    ->

PTOUT1 JSR    FENDES
       LDB    OUTIL
       LSLB
       ADDB   OUTIL
       LEAX   XPTOUT,PCR
       JSR    B,X
       JSR    FENACT
       RTS              ->>
*---------------------------------------
XPTOUT LBRA   XPPOIN
       LBRA   XPLIGN
       LBRA   XPRECT
       LBRA   XPRECT  carré
       LBRA   XPELLI
       LBRA   XPELLI  cercle
       LBRA   XPCARA
       LBRA   XPPEIN
       LBRA   XPGOMM
       LBRA   XPLOUP
       LBRA   XPCOUC
       LBRA   XPCOLL
*---------------------------------------

XPGOMM EQU    *
*-----
       LDX    REGX
       STX    X0TIRE
       LDY    REGY
       STY    Y0TIRE
XPGFI0 STX    X1TIRE
       STY    Y1TIRE
       JSR    TRRAZ
       JSR    TRLIGN
       STX    X0TIRE
       STY    Y0TIRE

XPGFI1 JSR    GETL
       BCS    XPGFI1    ->
       JSR    LPIN
       BCS    XPGFI0    ->

       RTS

XPCARA EQU    *
*-----
       JSR    TRAMIN    tortue caractère
       LDB    TCAR
       SUBB   #TCN
       PSHS   B
       LSLB
       ADDB   ,S+
       LDX    #TABTOR
       ABX
       LDY    ,X++
       LDB    ,X

       PSHS   B         copie en RAM
       LDX    #TFORME
COPTO1 LDA    ,Y+
       STA    ,X+
       DECB
       BNE    COPTO1    ->

       PULS   B         compil sur place
       STB    FACLO
       LDX    #TFORME
       LDY    #TFORME
       LDB    #CMPTOR
       JSR    EXTRA

       LDX    REGX
       STX    TXTX
       LDY    REGY
       STY    TXTY

       LDY    #TORTXT
       LDB    #MOVE
       JSR    EXTRA
       LDA    #$FF
       LDB    #SHOW
       JSR    EXTRA
       JSR    TRAMAX

       LDA    #$FF
       STA    FLGTXT
       COMA
       STA    CLITXT
       CLR    FLGSS2

       LDA    #TIRE
       STA    ETAOUT
       CLRA            tortue std
       CLRB
       JSR    FENTOR
       COMA
       STA    STDTOR
       RTS

XPCOUC EQU    *         rfu
*-----
       LDA    TLIGN
       PSHS   A
       LDA    #1
       STA    TLIGN
       LDX    REGX
       STX    X0TIRE
       STX    X1TIRE
       LDY    REGY
       STY    Y0TIRE
       STY    Y1TIRE

       JSR    TRINV
       CLR    FILFLG
       JSR    TRRECT
       JSR    TRINV
       JSR    TRLIGN
       PULS   A
       STA    TLIGN

       LDA    #TIRE
       STA    ETAOUT
       CLRA            tortue std
       CLRB
       JSR    FENTOR
       COMA
       STA    STDTOR
       RTS

XPCOLL EQU    *
*-----
       TST    FLGTIR
       BNE    XPCOL0    ok ->
       LDX    #MTIRVI
       JSR    FENERR
       LBRA   XPCOLF    ->

XPCOL0 EQU    *
*      calculer coord. de visualisation
       LDD    <LPTTIR
       LSRA
       RORB
       PSHS   D
       LDD    REGX
       SUBD   ,S++
       PSHS   D

       CLRA             calcul +/- 32k
       LDB    <HPTTIR
       LSRA
       RORB
       PSHS   D
       LDD    REGY
       SUBD   ,S++
       PSHS   D

       LDB    #$13      mode transp. ?
       JSR    FENCH
       CLRA
       LDB    VAL,X
       CMPB   #OFF
       BNE    XPCC99    ->
       COMA
XPCC99 PULS   Y
       PULS   X
       JSR    VISTIR

XPCOLF RTS

XPPEIN EQU    *
*-----
       LDX    REGX
       LDY    REGY
       JSR    GETP
       TSTB
       BEQ    XPEIN2    pt en forme ->

       JSR    TRAMIN
       LDB    #$13
       JSR    FENCH
       LDB    VAL,X
       CMPB   #OFF
       BEQ    XPEIN0    ->
       JSR    TRTRAN    mode transparent
XPEIN0 LDX    REGX
       STX    XXXXXX
       LDY    REGY
       STY    YYYYYY
       LDB    #BKMANO   manoeuvre
       STB    BANKC
       LDD    #ZONTRA
       STD    DEBZON
       LDD    #FINTRA
       STD    FINZON
       LDU    #MOTIF
       STU    MACP
       LDU    #XPEIN2   active chien
       JSR    ACTDOG              garde
       LDB    #PAINT
       JSR    EXTRA
       CLR    FLGDOG    désactive
       TSTB
       BEQ    XPEIN2    ->
       JSR    DOSERR
XPEIN2 JSR    TRNORM
       JSR    TRAMAX
       LDB    #BKTIR    restaure bank
       STB    BANKC
       RTS

XPPOIN EQU    *
*-----
       LDX    REGX
       STX    X0TIRE
       LDY    REGY
       STY    Y0TIRE
XPPFI0 STX    X1TIRE
       STY    Y1TIRE
       JSR    TRLIGN
       STX    X0TIRE
       STY    Y0TIRE

XPPFI1 JSR    GETL
       BCS    XPPFI1    ->
       JSR    LPIN
       BCS    XPPFI0    ->

       RTS

XPRECT EQU    *
*-----
       JSR    TRINV

       LDX    REGX
       STX    X0TIRE
       STX    X1TIRE
       LDY    REGY
       STY    Y0TIRE
       STY    Y1TIRE
       CLR    FILFLG
       JSR    TRRECT

       LDA    #TIRE
       STA    ETAOUT
       CLRA            tortue std
       CLRB
       JSR    FENTOR
       COMA
       STA    STDTOR
       RTS

XPLIGN EQU    *
*-----
       JSR    TRINV

       LDX    REGX
       STX    X0TIRE
       STX    X1TIRE
       LDY    REGY
       STY    Y0TIRE
       STY    Y1TIRE
       JSR    TRLIGN

       LDA    #TIRE
       STA    ETAOUT
       CLRA            tortue std
       CLRB
       JSR    FENTOR
       COMA
       STA    STDTOR
       RTS

XPELLI EQU    *
*-----
       JSR    TRINV

       LDX    REGX
       STX    X0TIRE
       LDY    REGY
       STY    Y0TIRE
       LDA    #2
       STA    X1TIRE
       STA    Y1TIRE
       CLR    FILFLG
       JSR    TRELLI

       LDA    #TIRE
       STA    ETAOUT
       CLRA            tortue std
       CLRB
       JSR    FENTOR
       COMA
       STA    STDTOR
       RTS

XPLOUP EQU    *
*-----
       LDA    FLGLOU
       CMPA   #2
       LBEQ   XPLO50   dessin dans loupe
       CMPA   #0
       BNE    XPLO00   tracé de loupe ->
       RTS             ->>

* Tracé de la loupe à gauche ou à droite
XPLO00 LDA    #2
       STA    FLGLOU
       LDD    X0TIRE
       CMPD   #50*8
       BLT    XPLO10    ->
       LDD    #$0306
       BRA    XPLO11    ->
XPLO10 LDD    #$0338
XPLO11 STD    RNGLOU

       LDA    $E7C3     sauver 1ére page
       ORA    #1
       STA    $E7C3
       LDX    #$4000
       LEAX   40*8*3,X
       LSRB
       LEAX   B,X
       LDA    #BKMANO
       STA    BANKC
       LDY    #$A000
       LDU    #18*8
XPLO20 LDA    #9
XPLO21 LDB    ,X+
       STB    ,Y+
       DECA
       BNE    XPLO21    ->
       LEAX   31,X
       LEAU   -1,U
       CMPU   #0
       BNE    XPLO20    ->

       LDA    $E7C3     sauver 2éme page
       EORA   #1
       STA    $E7C3
       LDX    #$4000
       LEAX   40*8*3,X
       LDB    COLLOU
       LSRB
       LEAX   B,X
       LDU    #18*8
XPLO30 LDA    #9
XPLO31 LDB    ,X+
       STB    ,Y+
       DECA
       BNE    XPLO31    ->
       LEAX   31,X
       LEAU   -1,U
       CMPU   #0
       BNE    XPLO30    ->

       LDD    RNGLOU    fenêtre loupe
       LDX    #FFLOUP
       JSR    FENVIS

       LDU    #$D000    lecture zone
       LDY    Y0TIRE
       LEAY   1,Y
BLLO0  LDX    X0TIRE
       LEAX   1,X
BLLO1  JSR    GETP
       STB    ,U+
       LEAX   1,X
       CMPX   X1TIRE
       BNE    BLLO1     ->
       LEAY   1,Y
       CMPY   Y1TIRE
       BNE    BLLO0     ->

       LDU    #$D000    écriture loupe
       LDD    #PLEIN
       STD    MACP
       LDA    #$FF
       STA    FILFLG
       LDY    #4*8
BELO0  LDB    #8
       LDA    COLLOU
       INCA
       MUL
       TFR    D,X
       LDA    #32
BELO1  TST    ,U+
       BMI    BELO2     ->
       STX    XXXXXX
       STY    YYYYYY
       LEAX   3,X
       LEAY   3,Y
       LDB    #BOX
       JSR    EXTRA
       LEAX   -3,X
       LEAY   -3,Y
BELO2  LEAX   4,X
       DECA
       BNE    BELO1     ->
       LEAY   4,Y
       CMPY   #20*8
       BNE    BELO0     ->

       RTS              ->>

* Dessin dans la loupe ???
XPLO50 LDX    RNGLOU
       LDY    #$1111
       JSR    SOUDAN
       BCC    XPLO51    hors ->
       LEAX   $0101,X
       LDY    #$1010
       JSR    SOUDAN
       BCS    XPLO52    dessin ->
       RTS              ->>
XPLO51 JSR    RAZOUT
       RTS              ->>

* Dessin dans la loupe
XPLO52 JSR    TRINV
       LDD    REGX
       ANDB   #$FC
       STD    XXXXXX
       ADDD   #3
       TFR    D,X
       LDD    REGY
       ANDB   #$FC
       STD    YYYYYY
       ADDD   #3
       TFR    D,Y
       LDD    #PLEIN
       STD    MACP
       LDA    #$FF
       STA    FILFLG
       LDB    #BOX
       JSR    EXTRA

* Dessin en réel
       LDA    COLLOU
       LDB    #8
       MUL
       PSHS   D
       LDD    REGX
       SUBD   ,S++
       LSRA
       RORB
       LSRA
       RORB             2..33
       SUBD   #1
       ADDD   X0TIRE
       TFR    D,X
       LDD    REGY
       SUBD   #3*8
       LSRA
       RORB
       LSRA
       RORB             2..33
       SUBD   #1
       ADDD   Y0TIRE
       TFR    D,Y
       LDB    #PSETXY
       JSR    EXTRA
       JSR    TRNORM
       RTS              ->>


*=======================================
* S/P raz visu provisoire de l'outil
*     courant (suite à sélection ou
*     scroll dans le mode TIRE
*=======================================

RAZOUT EQU    *
*---------------------------------------
       JSR    FENDES
       JSR    TRAMAX    tortue standard
       CLRA
       CLRB
       JSR    FENTOR
       COMA
       STA    STDTOR
       JSR    FENACT

       LDA    ETAOUT
       CMPA   #TIRE
       BEQ    RAZOU0    ->
       LDA    OUTIL
       CMPA   #LOUPE
       BEQ    RAZOU0    ->
       TST    COPALB
       BEQ    RAZO00    ->
       JSR    FENDES
       JSR    XRCOU0    ->
       JSR    FENACT
RAZO00 RTS              ->>

RAZOU0 LDA    #POINTE   retour en état
       STA    ETAOUT
       JSR    FENDES
       LDB    OUTIL
       LSLB
       ADDB   OUTIL
       LEAX   XRAZOU,PCR
       JSR    B,X
       JSR    FENACT
XRF    RTS              ->>
*---------------------------------------
XRAZOU LBRA   XRF       points
       LBRA   XRLIGN
       LBRA   XRRECT
       LBRA   XRRECT    carré
       LBRA   XRELLI
       LBRA   XRELLI    cercle
       LBRA   XRCARA
       LBRA   XRF       peinture
       LBRA   XRF       gomme
       LBRA   XRLOUP
       LBRA   XRCOUC
       LBRA   XRCOLL
*---------------------------------------

XRCARA EQU    *
*-----
       JSR    TRAMIN
       LDY    #TORTXT  masque tortue car
       CLRA
       LDB    #SHOW
       JSR    EXTRA
       CLR    FLGTXT
       JSR    TRAMAX
       RTS

XRCOUC EQU    *
*-----
       LDA    TLIGN
       PSHS   A
       LDA    #1
       STA    TLIGN
       JSR    TRINV
       CLR    FILFLG
       JSR    TRRECT
       JSR    TRINV
       JSR    TRLIGN
       PULS   A
       STA    TLIGN

       TST    COPALB
       BNE    XRCOU0    ->
       RTS              ->>

XRCOU0 LDB    #ESC      fin copie album
       JSR    PUTC
       LDB    #$60
       JSR    PUTC
       LDA    COPAOU
       STA    OUTIL
       JSR    AFFOPT
       JSR    RESTAU    restaure visu
       CLR    COPALB
       RTS

XRCOLL RTS              rfu
*-----

XRRECT JSR    TRINV
*-----
       CLR    FILFLG
       JSR    TRRECT
       RTS

XRLIGN JSR    TRINV
*-----
       JSR    TRLIGN
       RTS

XRELLI JSR    TRINV
*-----
       CLR    FILFLG
       JSR    TRELLI
       RTS

XRLOUP JSR    RAZLOU
*-----


*=======================================
* S/P traitement du mode TIRE
*     (tracé provisoire)
*=======================================
TIROUT EQU    *
*---------------------------------------

       JSR    FENDES
       LDB    OUTIL
       LSLB
       ADDB   OUTIL
       LEAX   XTIOUT,PCR
       JSR    B,X
       JSR    FENACT
XTF    RTS              ->>
*---------------------------------------
XTIOUT LBRA   XTF       points
       LBRA   XTLIGN
       LBRA   XTRECT
       LBRA   XTCARR
       LBRA   XTELLI
       LBRA   XTCERC
       LBRA   XTCARA    caractère
       LBRA   XTF       peinture
       LBRA   XTF       gomme
       LBRA   XTLOUP
       LBRA   XTCOUC
       LBRA   XTCOLL
*---------------------------------------

XTCARA EQU    *
*-----
       LDB    REGB
       CMPB   #RC
       BEQ    XTCARC    RC ->
       CMPB   #RS
       LBEQ   XTCARS    RS ->
       CMPB   #1
       LBEQ   XTCAMO    motif cour. ->
       LBRA   XTCACA    code normal ->

*** frappe d'un RC (=LF+CR)
XTCARC EQU    *
       LDY    TXTY       mode caractère
       LEAY   8,Y
       LDA    TCAR
       CMPA   #TCN
       BEQ    XTCRC0    ->
       CMPA   #TCDL
       BEQ    XTCRC0    ->
       LEAY   8,Y
       CMPY   #207
       BGE    XTCRC2    ->
       BRA    XTCRC1    ->
XTCRC0 CMPY   #199
       BGE    XTCRC2    ->
XTCRC1 STY    TXTY
       BRA    XTCRC3    ->
XTCRC2 LDB    #7
       JSR    PUTC
       LBRA   XTCARF    ->

XTCRC3 LDX    #32        mode caractère
       STX    TXTX
       JSR    TRAMIN
       LDY    #TORTXT
       LDB    #MOVE
       JSR    EXTRA
       LBRA   XTCARF    ->


*** frappe d'un RS (positionnement en
*** position caractère normale ...

XTCARS LDD    TXTX
XTCRS0 BITB   #$07
       BEQ    XTCRS1    ->
       SUBD   #1
       BRA    XTCRS0    ->
XTCRS1 STD    TXTX
       LDD    TXTY
       ADDD   #1
XTCRS2 BITB   #$07
       BEQ    XTCRS3    ->
       ADDD   #1
       BRA    XTCRS2    ->
XTCRS3 SUBD   #1
       STD    TXTY
       JSR    TRAMIN
       LDY    #TORTXT
       LDB    #MOVE
       JSR    EXTRA
       LBRA   XTCARF    ->

*** frappe ctrl A (motif courant)

XTCAMO LDX    #CARMOT
       LDY    #TXTMOT
XTCAR0 LDD    ,X++
       STD    ,Y++
       CMPX   #MOTIF
       BNE    XTCAR0    ->
       BRA    XTCAR2    ->

*** frappe d'un code normal

XTCACA LDY    #TXTMOT   décodage car.
       JSR    XTRMOT
       LBCC   XTCARF    ->

XTCAR2 JSR    TRAMIN
       LDY    #TORTXT  masque tortue car
       CLRA
       LDB    #SHOW
       JSR    EXTRA

       LDX    TXTX
       LDY    TXTY
       JSR    EXPCAR    visu car.

       LEAX   8,X
       LDA    TCAR
       CMPA   #TCN
       BEQ    XTCAR3    ->
       CMPA   #TCDH
       BEQ    XTCAR3    ->
       LEAX   8,X
XTCAR3 CMPX   #623
       BCC    XTCAR4    ->
       STX    TXTX
       LDY    #TORTXT
       LDB    #MOVE
       JSR    EXTRA
       BRA    XTCARV    ->
XTCAR4 LDB    #7
       JSR    PUTC

XTCARV LDY    #TORTXT  visu tortue car
       LDA    #$FF
       LDB    #SHOW
       JSR    EXTRA

XTCARF JSR    TRAMAX   pour tortue souri
       RTS

XTCOUC EQU    *
*-----
       LDA    TLIGN
       PSHS   A
       LDA    #1
       STA    TLIGN
       JSR    TRINV     ancien tracé
       CLR    FILFLG
       JSR    TRRECT
       JSR    TRINV
       JSR    TRLIGN

       LDX    REGX      nouveau tracé
       STX    X1TIRE
       LDY    REGY
       STY    Y1TIRE
       JSR    TRINV
       JSR    TRRECT
       JSR    TRINV
       JSR    TRLIGN
       PULS   A
       STA    TLIGN
       RTS

XTCOLL RTS              rfu
*-----

XTRECT EQU    *
*-----
       JSR    TRINV     ancien tracé
       CLR    FILFLG
       JSR    TRRECT

       JSR    TRINV     nouveau tracé
       LDX    REGX
       STX    X1TIRE
       LDY    REGY
       STY    Y1TIRE
       JSR    TRRECT
       RTS

XTCARR EQU    *
*-----
       JSR    TRINV     ancien tracé
       CLR    FILFLG
       JSR    TRRECT

       JSR    TRINV     nouveau tracé
       LDD    REGX
       SUBD   X0TIRE
       PSHS   D
       TSTA
       BPL    XTCRR0    >0 ->
       LDD    #0
       SUBD   ,S
       STD    ,S
XTCRR0 LDD    REGY
       SUBD   Y0TIRE
       TSTA
       BPL    XTCRR1    >0 ->
       PSHS   D
       LDD    #0
       SUBD   ,S++
XTCRR1 CMPD   ,S
       BGT    XTCRR2    ->
       LDD    ,S
XTCRR2 STD    ,S        D = coté

       LDY    Y0TIRE
       CMPY   REGY
       BLE    XTCRR3    ->
       LDD    #0
       SUBD   ,S
XTCRR3 LEAY   D,Y
       STY    Y1TIRE

       LDD    ,S        coef rél -> larg
       STD    FACMO     convers. -> réel
       LDA    #2
       STA    VALTYP
       LDA    #4
       LDB    #FRCTYP
       JSR    EXTRA
       LDB    #MOVAF    -> ARG
       JSR    EXTRA
       LDX    #COEFMU   coefficient
       LDB    #MOVFM
       JSR    EXTRA
       LDB    #MULTGO   *
       JSR    EXTRA
       LDA    #2        convers entier
       LDB    #FRCTYP
       JSR    EXTRA
       LDD    FACMO
       STD    ,S
       LDX    X0TIRE
       CMPX   REGX
       BLE    XTCRR4    ->
       LDD    #0
       SUBD   ,S
XTCRR4 LEAX   D,X
       STX    X1TIRE
       LEAS   2,S

       JSR    TRRECT
       RTS

XTLIGN EQU    *
*-----
       JSR    TRINV     ancien tracé
       JSR    TRLIGN

       JSR    TRINV     nouveau tracé
       LDX    REGX
       STX    X1TIRE
       LDY    REGY
       STY    Y1TIRE
       JSR    TRLIGN
       RTS

XTELLI EQU    *
*-----
       JSR    TRINV     ancien tracé
       CLR    FILFLG
       JSR    TRELLI

       JSR    TRINV     nouveau tracé
       LDD    REGX
       SUBD   X0TIRE
       BPL    XTELI0    ->
       COMA             < 0
       COMB
       ADDD   #1
XTELI0 CMPD   #253
       BLE    XTELI1    ->
       LDB    #254      >254
XTELI1 STB    X1TIRE
       BNE    XTELI2    ->
       INC    X1TIRE

XTELI2 LDD    REGY
       SUBD   Y0TIRE
       BPL    XTELI3    ->
       COMA             < 0
       COMB
       ADDD   #1
XTELI3 CMPD   #253
       BLE    XTELI4    ->
       LDB    #254      >254
XTELI4 STB    Y1TIRE
       BNE    XTELI5    ->
       INC    Y1TIRE
XTELI5 JSR    TRELLI
       RTS

XTCERC EQU    *
*-----
       JSR    TRINV     ancien tracé
       CLR    FILFLG
       JSR    TRELLI

       JSR    TRINV     nouveau tracé
       LDA    #2
       STA    VALTYP
       LDD    REGX
       SUBD   X0TIRE    x au carré
       STD    FACMO
       STD    ARGMO
       LDB    #MULTGO
       JSR    EXTRA
       LDX    FACMO
       PSHS   X

       LDD    REGY      y au carré
       SUBD   Y0TIRE
       STD    FACMO
       STD    ARGMO
       LDB    #MULTGO
       JSR    EXTRA

       LDD    FACMO     racine de somme
       ADDD   ,S++
       STD    FACMO
       LDB    #SQR
       JSR    EXTRA

       LDX    #MEMREL   mémo
       LDB    #MOVMF
       JSR    EXTRA

       LDA    #2        hauteur (entier)
       LDB    #FRCTYP
       JSR    EXTRA
       LDD    FACMO
       CMPD   #127
       BLE    XTCER0    ->
       LDB    #127
XTCER0 STB    Y1TIRE
       BNE    XTCER1    ->
       INC    Y1TIRE

XTCER1 LDA    #4        mémo * coef.
       STA    VALTYP           adapt. pt
       LDX    #MEMREL
       LDB    #MOVFM
       JSR    EXTRA
       LDB    #MOVAF
       JSR    EXTRA
       LDX    #COEFMU
       LDB    #MOVFM
       JSR    EXTRA
       LDB    #MULTGO
       JSR    EXTRA

       LDA    #2        largeur (entier)
       LDB    #FRCTYP
       JSR    EXTRA
       LDD    FACMO
       CMPD   #254
       BLE    XTCER2    ->
       LDB    #254
XTCER2 STB    X1TIRE
       BNE    XTCER3    ->
       INC    X1TIRE

XTCER3 JSR    TRELLI
       RTS

XTLOUP RTS              rfu
*-----
