       TITLE  TO-SNAP:  Programme princ.
*      ---------------------------------
       PAGE

****************************************
*                                      *
*           TO-SNAP                    *
*                                      *
*    Programme principal               *
*                                      *
****************************************

* Appel par tache sous IT !!!
*---------------------------------------

XSNAP  EQU    *
       ORCC   #$50

       LDA    >$E7CB    RAZ IT éventuell
       ORA    #$40
       STA    >$E7CB
       LDA    <$E7C9
       LDA    >$E7CB    6821 pour /FIRQ
       ANDA   #$FC      par prise crayon
       STA    >$E7CB

       LDA    #$54    bk ram par $E7E5
       STA    $6081
       STA    >$E7E7

       LDD    FIRQMM  reset vecteurs
       STD    FIRQPT
       LDD    TIMEMM
       STD    TIMEPT
       LDD    IRQMM
       STD    IRQPT
       LDD    SWIMM
       STD    SWIPT
       LDD    PTGEMM
       STD    PTGENE
       LDA    RESEMM
       STA    RESETP
       LDD    RESEMM+1
       STD    RESETP+1
       LDA    SIZCMM
       STA    SIZCLV
       LDD    USERMM
       STD    USERAF
       LDD    BUFCMM
       STD    BUFCLV

       LDX    #VECTMM
       LDY    #$6000
       LDB    #22
BRSVE  LDA    ,X+
       STA    ,Y+
       DECB
       BNE    BRSVE     ->

       LDA    STATUS
       ANDA   #$DF
       STA    STATUS

       CLR    $E7E4     si page vidéo
       LDA    $E7E4     non 0 la
       ANDA   #$C0      recopier en 0
       BEQ    OKPAG0    ->
       LSRA
       LSRA
       LSRA
       LSRA
       LSRA
       LSRA
       CLRB
       LDX    #$A000
OKPAG1 STA    BANKC
       LDU    ,X
       STB    BANKC
       STU    ,X++
       CMPX   #$A000+8000
       BNE    OKPAG1    ->

       LDX    #$C000
OKPAG2 STA    BANKC
       LDU    ,X
       STB    BANKC
       STU    ,X++
       CMPX   #$C000+8000
       BNE    OKPAG2    ->

       CLR    $E7DD     page 0 et tour 0

OKPAG0 LDA    #$FF
       STA    FLGSNA

       LDA    >$E7C1    init 6846(timer)
       ANDA   #$F7
       STA    >$E7C1
       LDA    #$47
       STA    $E7C5
       LDD    #$30D3
       STD    $E7C6
       LDA    #$46
       STA    $E7C5

       LDA    STATUS
       ORA    #2        transmiss. GETC
       STA    STATUS

       ANDCC  #$2F      réactive IT

       LDB    #$F8      reset clavier
       JSR    GETC

       BRA    START0    ->
DEBUT  EQU    *
       CLR    FLGSNA

* Initialisations
*---------------------------------------

* Pile et DP
START0 LDS    #PILE
       LDA    #$E7
       TFR    A,DP

* Copie des S/P fenêtrage vers RAM
       LDU    #FENRAM
       JSR    COMBK2

* Bank manoeuvre et vidéo qui seront
* échangés
       CLRA
       STA    BKVID
       LDA    #2
       STA    BKMANO

* Vérification RAM disponible
       LDA    MAXBK
       DECA             ->nb bank disp.
       CMPA   #6
       BGE    OKRAM     ->
       LDB    #$1B      'Out of memory'
       JSR    PUTC
       LDB    #$5A
       JSR    PUTC
       LDB    #FF
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

* Initialisation numérotation photo

OKRAM  CLR    NUMPHO
       LDA    MAXBK
       DECA
       SUBA   #PBKPEL
       STA    MAXPHO
       LDX    #TABPHO
       LDB    #22
OKRAM1 CLR    ,X+
       DECB
       BNE    OKRAM1    ->
       LDX    #TABBK
       LDB    #22
       LDA    #PBKPEL
OKRAM2 STA    ,X+
       INCA
       DECB
       BNE    OKRAM2    ->

       LDD    #2
       STD    MEMTPO

* Dans le cas d'un appel sous IT,
* mémoriser l'écran courant !!!
       TST    FLGSNA
       LBEQ   START1    ->
       LDX    #MSANN    nom défaut
       LDY    #TABNOM
       LDB    #8
BNONAM LDA    ,X+
       STA    ,Y+
       DECB
       BNE    BNONAM    ->

       LDU    #PALETE   palette courante
       CLRA
BOULNP LDX    #$FFFF
       LDY    #0
       JSR    SETP
       STX    ,U++
       INCA
       CMPA   #16
       BNE    BOULNP    ->
       CLR    TOUR      dans ignorance !

       JSR    CODPHO

* Init. controleur et écran
       LDD    #0      sinon, init ctrl
       STD    $60E9   plante après load
       STD    $60ED   infograme !!!

       CLR    DKDRV
       LDA    #1
       STA    DKOPC
       JSR    DKCO
       LDA    #$10
       STA    DKOPC
       JSR    DKCO
       LDA    #$20
       STA    DKOPC
       JSR    DKCO
       JSR    INITC

* Extra moniteur pour turbo-disq
START1 LDB    #RESETC
       JSR    EXTRA

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
       LDD    #$A55A
       STD    TSTRST

* Fichier courant

       LDX    #DESCOU
       LDA    #8
RZDECO CLR    ,X+
       DECA
       BNE    RZDECO    ->

       LDX    #DESALB
       LDA    #8
       LDB    #$20
RZDECA STB    ,X+
       DECA
       BNE    RZDECA    ->
       CLR    ,X

* Init. extra. mon.
       LDB    #RESETW
       JSR    EXTRA

* Mémorisation de la palette si non
* déja fait !
       LDA    TFMEMO
       CMPA   #$FF
       LBNE   SUIXY0    ->

       CLR    $E7E4
       LDA    $E7E6     autorise écritur
       ORA    #$40      cartouche
       STA    $E7E6

       CLR    TFMEMO
       LDU    #TMEMO
       CLRA
BOULNU LDX    #$FFFF
       LDY    #0
       JSR    SETP
       STX    ,U++
       INCA
       CMPA   #16
       BNE    BOULNU    ->

       LDA    $E7E6     interdit écritur
       ANDA   #$BF      cartouche
       STA    $E7E6

SUIXY0 EQU    *

       LDB    #$1B      mode TO7
       JSR    PUTC
       LDB    #$5A
       JSR    PUTC

       LDA    #GRIS
       STA    TOUR

       LDB    #$11      réactive IT
       JSR    PUTC      (sinon, pb
       LDB    #$14      pour dérout
       JSR    PUTC      RESETP

       JSR    DEFSEL

       LDX    #PLEIN
       LDA    #8
       LDB    #$FF
BPLEIN STB    ,-X
       DECA
       BNE    BPLEIN    ->

* Bank RAM
       LDA    BKMANO
       STA    BANKC

* Memo vecteurs
       LDD    FIRQMM
       CMPD   #0
       BNE    SSOVE     deja fait ->
       CLR    $E7E4
       LDA    $E7E6     autorise écritur
       ORA    #$40      cartouche
       STA    $E7E6

       LDU    FIRQPT
       STU    FIRQMM
       LDU    TIMEPT
       STU    TIMEMM
       LDU    IRQPT
       STU    IRQMM
       LDU    SWIPT
       STU    SWIMM
       LDU    PTGENE
       STU    PTGEMM
       LDA    RESETP
       STA    RESEMM
       LDU    RESETP+1
       STU    RESEMM+1
       LDA    SIZCLV
       STA    SIZCMM
       LDU    USERAF
       STU    USERMM
       LDU    BUFCLV
       STU    BUFCMM

       LDX    #VECTMM
       LDY    #$6000
       LDB    #22
BSOVE  LDA    ,Y+
       STA    ,X+
       DECB
       BNE    BSOVE     ->

       LDA    $E7E6     interdit écritur
       ANDA   #$BF      cartouche
       STA    $E7E6

* Fenêtrage
SSOVE  LDX    #ZONFEN
       LDA    #PBKPIL
       LDB    #DBKPIL
       TFR    D,U
       LDA    #NOIR
       LDB    #GRIS
       JSR    FENINI

* Activation Fenêtre principale
*---------------------------------------

       LDX    #FENVID
       LDD    #0
       JSR    FENRPL

* En cas d'activation sous IT, visu de
* l'écran capturé
*---------------------------------------

       TST    FLGSNA
       BEQ    STARTX    ->
       JSR    DECPHO
       LBRA   DEMAR2    ->

* Visualisation du titre ou d'un
* message d'erreur si échec boot
* disquette !!!
*---------------------------------------

STARTX TST    FLGBOO
       BEQ    DEMAR1    ->
       CLR    $E7E4
       LDA    >$E7E6    autorise écrit
       ORA    #$40      cartouche
       STA    >$E7E6
       CLR    FLGBOO
       LDA    >$E7E6    interdit écrit
       ANDA   #$BF
       STA    >$E7E6
       LDX    #PASBOO
       JSR    FENERR
       BRA    DEMAR2    ->

DEMAR1 LDX    #FENTIT   Titre
       LDD    #$0606
       JSR    FENOUV

       JSR    LECAPL    lecture appli
*                       pendant titre !
       JSR    FENACT

       LDU    #400
EXEC0  JSR    FEN
       BCS    EXEC00    ->
       TSTB
       BNE    EXEC00    ->
       LEAU   -1,U
       CMPU   #0
       BNE    EXEC0     ->

EXEC00 CLRB
       JSR    FENFER
       BRA    DEMAR3    ->

DEMAR2 JSR    LECAPL    lecture appli
DEMAR3 CLRB             menu principal
       LBRA   MENPHO    ->

EXEC01 JSR    SELMOD    fixation mode
*                       vidéo selon phot

       JSR    FENACT

* Attente principale
*---------------------------------------

EXEC1  JSR    FENPOP
       TSTB
       BEQ    EXEC2     ->
       CMPB   #DEL
       LBEQ   EFFPHO    ->
       CMPB   #VT
       LBEQ   RETPHO    ->
       CMPB   #BS
       LBEQ   RETPHO    ->
       CMPB   #LF
       LBEQ   SUIPHO    ->
       CMPB   #HT
       LBEQ   SUIPHO    ->
       CMPB   #FF
       BEQ    EXEC1     ->
       LBRA   MENPHO    ->

EXEC2  LDA    REGCC     #Etat pointage
       TFR    A,CC
       BCC    EXEC1     pas clic ->
       LBRA   MENPHO    ->

*---------------------------------------
*      Effacement photo courante
*---------------------------------------
EFFPHO EQU    *
       JSR    FENDES
       JSR    SELDEF
       LDB    #$1B
       JSR    PUTC
       LDB    #$69
       JSR    PUTC
       LDB    #FF
       JSR    PUTC
       LDB    #$1B
       JSR    PUTC
       LDB    #$68
       JSR    PUTC
       LDA    NUMPHO
       JSR    DELPHO
       LBRA   EXEC01    ->

*---------------------------------------
*      Passage à la photo précedente
*---------------------------------------
RETPHO EQU    *
       JSR    PHOPRE
       JSR    FENDES
       JSR    DECPHO
       LBRA   EXEC01    ->

*---------------------------------------
*      Passage à la photo suivante
*---------------------------------------
SUIPHO EQU    *
       JSR    PHOSUI
       JSR    FENDES
       JSR    DECPHO
       LBRA   EXEC01    ->


*---------------------------------------
*      Demande de menu
*---------------------------------------
MENPHO EQU    *         demande menu
       JSR    SELDEF
       STB    MEMCOD    code frappé
*                       au niveau supér
       LDX    #FENMEN   Menu
       LDD    3,X
       JSR    POPUP
       JSR    FENOUV

       LDB    #BMBLAN
       JSR    FENCF
       CLRA
       LDB    NUMPHO
       LDX    #BUF
       JSR    BINDCG
       LDD    #$010E
       LDY    #$0102
       JSR    FENLOF
       JSR    FENEDI
       LDB    #BMCLR
       JSR    FENCF

MENU0  JSR    FENACT
       LDB    MEMCOD    traitement code
*                       saisie au niv.
*                       sup.
       BEQ    MENU1     ->
       CLR    MEMCOD
       BRA    MENU2     ->
MENU1  JSR    FENPOP
MENU2  TSTB
       BEQ    MENU1     ->
       CMPB   #$4C
       LBEQ   LANCAP    ->
       CMPB   #$44
       LBEQ   CATPHO    ->
       CMPB   #$49
       LBEQ   INFPHO    ->
       CMPB   #$46
       LBEQ   FICPHO    ->
       CMPB   #$4D
       LBEQ   MODPHO    ->
       CMPB   #$51
       LBEQ   QUIPHO    ->
       CMPB   #FF
       LBNE   MENU1     ->
       CLRB
       JSR    FENFER
       JSR    SELMOD
       JSR    FENACT
       LBRA   EXEC1     visu principale>


*   Lancement programme avec SNAP
*---------------------------------------
LANCAP EQU    *
       JSR    MENLAN
       LBRA   MENU0     ->

*   Sélection CATALOGUE
*---------------------------------------
CATPHO EQU    *
       JSR    MENCAT
       LBNE   EXEC1     ->
       LBRA   MENU0     ->

*   Sélection INFI VIDEO
*---------------------------------------
INFPHO EQU    *
       LDB    NUMPHO
       LDX    #TABPHO
       TST    B,X
       BEQ    PAINFP    ->
       JSR    MENINF
       LBNE   EXEC1     ->
       LBRA   MENU0     ->
PAINFP LDX    #MPASPH
       JSR    FENERR
       LBRA   MENU0     ->

*   Sélection FICHIER
*---------------------------------------
FICPHO EQU    *
       JSR    MENFIC
       LBNE   EXEC1     ->
       LBRA   MENU0     ->

*   Mode d'emploi
*---------------------------------------
MODPHO EQU    *
       JSR    EMPPHO
       LBRA   MENU0     ->

*   Quitter
*---------------------------------------
QUIPHO EQU    *
       LBSR   FENCH
       LBSR   FENIVD
       LDA    BKMANO    manoeuvre
       STA    BANKC
       LDX    #ZONTRA
       LDD    REGY      a cause clou !
       CMPD   #32
       BGE    QUIPH0    ->
       ADDD   #32
       STD    REGY
QUIPH0 LDA    #10
       LDB    #22
       JSR    POPUP
       LBSR   TBREAK
       BCS    FINGR     ->
       LDB    #$51
       LBSR   FENCH
       LBSR   FENIVD
       LBRA   MENU0     ->

*      Nettoyages divers
*---------------------------------------

*      Fenêtrage
FINGR  JSR    FENFIN

*      Attributs de visu.
       LDB    #ESC    40 col
       JSR    PUTC
       LDB    #$5A
       JSR    PUTC

       LDA    #$FF
       LDX    #TMEMO
       JSR    SETP

       CLR    $E7E4
       LDA    $E7E6     autorise écritur
       ORA    #$40      cartouche
       STA    $E7E6
*      CLR    TFMEMO
       LDA    $E7E6     interdit écritur
       ANDA   #$BF      cartouche
       STA    $E7E6

       JMP    MENU    ->>>>>>>


*=======================================
* S/P FEN avec mémo des param en pseudo
*     registre
*=======================================

FENPOP PSHS   U
       LDU    #PILFEN   mémo retour FEN
       JSR    FEN
       PSHU   CC,D,X,Y
       PULS   U,PC      ->>


*=======================================
* S/P préparation d'une ouverture de
*     fenètre en pop up
*
* Entrée: A : hauteur cadre
*         B : largeur cadre
* Sortie: A : coord vert.
*         B : coord horz.
*=======================================

POPUP  PSHS   D
       LEAS   -2,S
MAXH   SET    0
MAXL   SET    1
PA     SET    2
PB     SET    3
*---------------------------------------

       LDA    #24
       SUBA   PA,S
       STA    MAXH,S
       LDA    #39
       SUBA   PB,S
       STA    MAXL,S

       LDB    REGY+1
       LSRB
       LSRB
       LSRB
       LDA    MAXH,S
       CMPB   MAXH,S
       BLE    POPUP0    ->
       TFR    A,B
POPUP0 STB    PA,S
       LDD    REGX
       LSRA
       RORB
       LSRA
       RORB
       LSRB
       LDA    MAXL,S
       CMPB   MAXL,S
       BLE    POPUP1    ->
       TFR    A,B
POPUP1 STB    PB,S

       TST    PA,S
       BNE    POPUP2    ->
       INC    PA,S
POPUP2 TST    PB,S
       BNE    POPUP3    ->
       INC    PB,S
POPUP3 LEAS   2,S
       PULS   D,PC      ->>
