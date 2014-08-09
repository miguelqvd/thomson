       TITLE  TO-GRAPH:Menusderoulants
*      ---------------------------------
       PAGE

****************************************
*                                      *
*           Menu déroulants            *
*                                      *
****************************************

*=======================================
* S/P Prise en compte commandes fenêtre
*     principale
*
* Entrée: X  ad. traitement retour
*         Y  ad. traitement RAZ
*         A  code RAZ en plus FF
*         B  car. saisie
* Sortie: U  ad. exec. (0 si non filtré)
*=======================================

ABORT  PSHS   A
PA     SET    0
*---------------------------------------
       CMPB   #FF
       LBEQ   ABORTZ    ->
       CMPB   PA,S
       LBEQ   ABORTZ    ->
       CMPB   #$90
       LBEQ   ABORTR    ->
       CMPB   #$91
       LBEQ   ABORTR    ->
       CMPB   #$92
       LBEQ   ABORTR    ->
       CMPB   #$93
       LBEQ   ABORRR    ->
       CMPB   #$94
       LBEQ   ABORTR    ->
       CMPB   #$98
       LBEQ   ABORTR    ->
       CMPB   #$0F
       LBEQ   ABORTR    ->
       CMPB   #$10
       LBEQ   ABORTR    ->
       CMPB   #$11
       BEQ    ABORTR    ->
       CMPB   #$12
       BEQ    ABORTR    ->
       CMPB   #$13
       BEQ    ABORTR    ->
       CMPB   #$14
       BEQ    ABORTR    ->
       CMPB   #$15
       BEQ    ABORTR    ->
       CMPB   #$05
       BEQ    ABORTR    ->
       CMPB   #BS
       BEQ    ABORTR    ->
       CMPB   #HT
       BEQ    ABORTR    ->
       CMPB   #VT
       BEQ    ABORTR    ->
       CMPB   #LF
       BEQ    ABORTR    ->
       CMPB   #$80+BS
       BEQ    ABORTR    ->
       CMPB   #$80+HT
       BEQ    ABORTR    ->
       CMPB   #$80+VT
       BEQ    ABORTR    ->
       CMPB   #$80+LF
       BEQ    ABORTR    ->
       CMPB   #RS
       BEQ    ABORTR    ->
       CMPB   #INS
       BEQ    ABORTR    ->
       CMPB   #$80
       BEQ    ABORTR    ->
       CMPB   #$81
       BEQ    ABORTR    ->
       LDU    #0
       PULS   A,PC
ABORTZ TFR    Y,U
       PULS   A,PC      ->>

ABORRR PSHS   X
       LDU    #100
ABORR0 JSR    FEN
       CMPB   #$93
       BEQ    ABORR1    ->
       LEAU   -1,U
       CMPU   #0
       BEQ    ABORR2    ->
       BRA    ABORR0    ->

ABORR1 PULS   X
       LDB    #$98      double clic
       TFR    X,U
       PULS   A,PC      ->>

ABORR2 PULS   X
       LDB    #$93

ABORTR TFR    X,U
       PULS   A,PC      ->>


*=======================================
* S/P affichage de 4 occurences d'un
*     caractère de motif pointé dans
*     le carreau courant (FENTXT)
*
* Entrée: Y  pointe motif du car.
*=======================================

PUTMOT FCB    $20,$20,$20,$20,0
AF4MOT PSHS   D,X,Y,U
*---------------------------------------
       LDU    PTGENE
       STY    PTGENE
       LEAX   PUTMOT,PCR
       JSR    FENTXT
       STU    PTGENE
       PULS   D,X,Y,U,PC ->


*=======================================
* S/P affichage options de tracé sur
*     fenêtre principale inactive !!!
*=======================================

AFFOPT EQU    *
*---------------------------------------
       LDA    OUTIL     outil courant
       LSLA
       LDX    #TMOUTI
       LDX    A,X
       LDD    #$0101
       LDY    #$0202
       JSR    FENLOC
       JSR    FENTXT

       LDD    #$0401    motif remplis.
       LDY    #$0202
       JSR    FENLOC
       LDY    #CARMOT
       JSR    AF4MOT

       LDB    #$14      taille lignes
       JSR    FENCH
       LDA    TLIGN
       DECA
       LDB    #5
       MUL
       LDX    #MLIGN1
       ABX
       JSR    FENTXT

       LDB    #$15      taille caractère
       JSR    FENCH
       LDA    TCAR
       SUBA   #$4C
       LSLA
       LDX    #TMMT
       LDX    A,X
       JSR    FENTXT
       RTS


*=======================================
* S/P affichage d'un caractère motif en
*     loupe
*
* Entrée: A,B coordonnées loupe (absolu)
*         Y   pt motif
*=======================================

LPMOTI PSHS   D,X,Y,U
       LEAS   -5,S
CPTL   SET    0
CPTC   SET    1
MOTL   SET    2
RNGLP  SET    3
COLLP  SET    4
*---------------------------------------
       TFR    Y,U

       LDY    #$0808
       JSR    FENLOC
       JSR    FENFON
       ADDA   #7
       STD    RNGLP,S

       LDA    #8
       STA    CPTL,S
BLPML  LDA    ,U+
       STA    MOTL,S
       LDA    #8
       STA    CPTC,S
BLPMC  LSL    MOTL,S
       BCC    LLPMC     ->
       LDD    RNGLP,S
       LDY    #$0101
       JSR    FENLOC
       JSR    FENIVD
LLPMC  INC    COLLP,S
       DEC    CPTC,S
       BNE    BLPMC     ->
       LDA    COLLP,S
       SUBA   #8
       STA    COLLP,S
       DEC    RNGLP,S
       DEC    CPTL,S
       BNE    BLPML     ->

       LEAS   5,S
       PULS   D,X,Y,U,PC


*=======================================
* S/P menu déroulant de gestion albums
*
* Sortie: B  code menu principal sélect.
*=======================================

SPALBU EQU    *
*---------------------------------------

       LDX    #FALBUM
       LDD    #$022D
       JSR    FENOUV

EXECA1 JSR    FENACT
EXECA2 JSR    FEN
       TSTB
       BEQ    EXECA2    ->
       LDU    #PILFEN
       PSHU   CC,D,X,Y
       CMPB   #$43      C
       LBEQ   XACON     ->
       CMPB   #$41      A
       LBEQ   XALEC     ->
       CMPB   #$45      E
       LBEQ   XECAL     ->
       CMPB   #$56      V
       LBEQ   XALVIS    ->
       CMPB   #$53      S
       LBEQ   XALSUP    ->
       LDA    #$93
       LDX    #XARET
       LDY    #XARETZ
       JSR    ABORT
       CMPU   #0
       BEQ    EXECA2    ->
       JMP    ,U

*** Copie -> Tiroir
XACON  EQU    *
       LBSR   FENCH     Inverser pouss.
       LBSR   FENIVD

       LDD    #$0806
       LDY    #1
       JSR    SELALB
       BCS    XACONF    raz ->
       STX    ALBCOU

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
       CLRB
       RTS              ->>

XACONF LDB    #$43      Inverser pouss.
       LBSR   FENCH
       LBSR   FENIVD
       LBRA   EXECA1    ->

*** Album -> Ecran
XALEC  EQU    *
       LBSR   FENCH     Inverser pouss.
       LBSR   FENIVD

       LDD    #$0806
       LDY    #1
       JSR    SELALB
       BCS    XALECF    raz ->
       STX    ALBCOU

*      décodage image
* Nb: posit. bank car CODE maintient un
*     pseudo bank courant

       JSR    FENDES
       JSR    SAUVE
       JSR    TRAMIN    fixe écran trav

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

       JSR    TRAMAX  restaure écr trav
       JSR    FENACT
       CLRB
       RTS            ->>

XALECF LDB    #$41      Inverser pouss.
       LBSR   FENCH
       LBSR   FENIVD
       LBRA   EXECA1    ->

*** Ecran -> Album
XECAL  EQU    *
       LBSR   FENCH     Inverser pouss.
       LBSR   FENIVD

       LDD    #$081E
       LDX    #FILNAM
       JSR    CZIALB
       BCS    XAECRF    raz ->
       JSR    CHALB
       BCS    XAECRF    pas de place ->
       STX    ALBCOU

       CLRB
       JSR    FENFER

*      codage image
*

       LDD    #$A002
       STD    DEBZON
       LDA    BANKC     mémo
       LDB    8,X
       STB    BANKC
       DECB
       STB    DEBZON+2
       CLR    PUTFLG
       LDB    #$FF
       STB    PASSCD
       LDB    #5
       STB    X0COD
       LDB    #1
       STB    Y0COD
       LDB    #78
       STB    X1COD
       LDB    #23
       STB    Y1COD
       LDB    #CODE
       JSR    EXTRA

       LDY    LSTBYT
       LEAY   -$A002,Y
       STY    $A000
       STA    BANKC

       JSR    FENACT
       RTS

XAECRF LDB    #$45      Inverser pouss.
       LBSR   FENCH
       LBSR   FENIVD
       LBRA   EXECA1    ->

*** Voir liste
XALVIS EQU    *
       LBSR   FENCH     Inverser pouss.
       LBSR   FENIVD

       LDD    #$0806
       LDY    #0
       LDX    #0
       JSR    SELALB

       LDB    #$56      Inverser pouss.
       LBSR   FENCH
       LBSR   FENIVD
       LBRA   EXECA1    ->

*** Supprimer album
XALSUP EQU    *
       LBSR   FENCH     Inverser pouss.
       LBSR   FENIVD

       LDD    #$0806
       LDY    #0
       JSR    SELALB
       BCS    XALSUF    raz ->
       NEG    8,X
       DEC    NBALB
       CMPX   ALBCOU
       BNE    XALSUF    ->
       LDD    #0        plus album cour.
       STD    ALBCOU

XALSUF LDB    #$53      Inverser pouss.
       LBSR   FENCH
       LBSR   FENIVD
       LBRA   EXECA1    ->


* Fin menu albums
*---------------------------------------

XARETZ CLRB
XARET  PSHS   B
       CLRB
       JSR    FENFER
       JSR    FENACT
       PULS   B
       RTS

*=======================================
* S/P menu déroulant de gestion fichier
*
* Sortie: B  code menu principal sélect.
*=======================================

SPFICH EQU    *
       LEAS   -2,S
ADFSOV SET    0
*---------------------------------------

       JSR    FENDES   pour cadrage
       JSR    SAUVE    éventuel
       LDD    <ADF
       STD    ADFSOV,S

       LDX    #FENFIC
       LDD    #$0205
       JSR    FENOUV

EXECF0 LDB    #ESC
       JSR    PUTC
       LDB    #$4F
       JSR    PUTC
       LDD    #$0222   Disque courant
       LDY    #$0202
       JSR    FENLOF
       LDB    DKDRV
       ADDB   #$30
       JSR    PUTC
       LDB    #ESC
       JSR    PUTC
       LDB    #$4C
       JSR    PUTC

EXECF1 JSR    FENACT


EXECF2 JSR    FEN
       TSTB
       BEQ    EXECF2    ->
       LDU    #PILFEN
       PSHU   CC,D,X,Y
       CMPB   #$50      P
       LBEQ   XFUNIT    ->
       CMPB   #$49      I
       LBEQ   XFINIT    ->
       CMPB   #$43      C
       LBEQ   XFCATA    ->
       CMPB   #$52      R
       LBEQ   XFRENO    ->
       CMPB   #$53      S
       LBEQ   XFSUPR    ->
       CMPB   #$44      D
       LBEQ   XFDUPL    ->
       CMPB   #$4C      L
       LBEQ   XFLIRE    ->
       CMPB   #$45      E
       LBEQ   XFECRI    ->
       CMPB   #$41      A
       LBEQ   XALBF     ->
       CMPB   #$46      F
       LBEQ   XFALB     ->
       CMPB   #$51      Q
       LBEQ   XFQUIT    ->
       LDA    #$90
       LDX    #XFRET
       LDY    #XFRETZ
       JSR    ABORT
       CMPU   #0
       LBEQ   EXECF2    ->
       JMP    ,U

*** Préciser unité
XFUNIT EQU    *
       LBSR   FENCH     Inverser pouss.
       LBSR   FENIVD
       LDX    #FENVID   sélection
       LDD    #$0518
       LBSR   FENOUV
       LDA    #BKMANO   manoeuvre
       STA    BANKC
       LDX    #ZONTRA
       LDY    #LGZTRA
       LDU    #$FFFF
       LBSR   DOSSEL
       LDA    #BKTIR    restaure
       STA    BANKC
       CLRB
       LBSR   FENFER
       LDB    #$50      Inverser pouss.
       LBSR   FENCH
       LBSR   FENIVD
       LBRA   EXECF0    ->

*** Initialiser
XFINIT EQU    *
       LBSR   FENCH     Inverser pouss.
       LBSR   FENIVD
       LDX    #FENVID   sélection
       LDD    #$0518
       LBSR   FENOUV
       LDA    #BKMANO   manoeuvre
       STA    BANKC
       LDX    #ZONTRA
       LDY    #LGZTRA
       LBSR   DOSINI
       LDA    #BKTIR    restaure
       STA    BANKC
       CLRB
       LBSR   FENFER
       LDB    #$49      Inverser pouss.
       LBSR   FENCH
       LBSR   FENIVD
       LBRA   EXECF1    ->
       LBRA   EXECF1    ->

*** Catalogue
XFCATA EQU    *
       LBSR   FENCH     Inverser pouss.
       LBSR   FENIVD
       LDX    #FENVID   sélection
       LDD    #$0218
       LBSR   FENOUV
       LDA    #BKMANO   manoeuvre
       STA    BANKC
       LDX    #ZONTRA
       LDY    #LGZTRA
       LBSR   DOSCAT
       LDA    #BKTIR    restaure
       STA    BANKC
       CLRB
       LBSR   FENFER
       LDB    #$43      Inverser pouss.
       LBSR   FENCH
       LBSR   FENIVD
       LBRA   EXECF1    ->

*** Renommer fichier
XFRENO EQU    *
       LBSR   FENCH     Inverser pouss.
       LBSR   FENIVD
       LDX    #FENVID   sélection
       LDD    #$0518
       LBSR   FENOUV
       LDA    #BKMANO   manoeuvre
       STA    BANKC
       LDX    #ZONTRA
       LDY    #LGZTRA
       LBSR   DOSREN
       LDA    #BKTIR    restaure
       STA    BANKC
       CLRB
       LBSR   FENFER
       LDB    #$52      Inverser pouss.
       LBSR   FENCH
       LBSR   FENIVD
       LBRA   EXECF1    ->

*** Supprimer fichier
XFSUPR EQU    *
       LBSR   FENCH     Inverser pouss.
       LBSR   FENIVD
       LDX    #FENVID   sélection
       LDD    #$0518
       LBSR   FENOUV
       LDA    #BKMANO   manoeuvre
       STA    BANKC
       LDX    #ZONTRA
       LDY    #LGZTRA
       LBSR   DOSSUP
       LDA    #BKTIR    restaure
       STA    BANKC
       CLRB
       LBSR   FENFER
       LDB    #$53      Inverser pouss.
       LBSR   FENCH
       LBSR   FENIVD
       LBRA   EXECF1    ->

*** Dupliquer fichier
XFDUPL EQU    *
       LBSR   FENCH     Inverser pouss.
       LBSR   FENIVD
       LDX    #FENVID   Sélection
       LDD    #$0518
       LBSR   FENOUV
       LDA    #BKMANO   manoeuvre
       STA    BANKC
       LDX    #ZONTRA
       LDY    #LGZTRA
       LBSR   DOSDUP
       LDA    #BKTIR    restaure
       STA    BANKC
       CLRB
       LBSR   FENFER
       LDB    #$44      Inverser pouss.
       LBSR   FENCH
       LBSR   FENIVD
       LBRA   EXECF1    ->

*** Lire fichier
XFLIRE EQU    *
       LBSR   FENCH     Inverser pouss.
       LBSR   FENIVD

       LDX    #FILNAM   filtre .MAP
XLIRZ  CLR    ,X+
       CMPX   #FILNAM+8
       BNE    XLIRZ     ->
       LDD    #$4D41
       STD    ,X++
       LDA    #$50
       STA    ,X+
       LDX    #FENVID   sélection
       LDD    #$0518
       LBSR   FENOUV
       LDA    #BKMANO   manoeuvre
       STA    BANKC
       LDX    #ZONTRA
       LDY    #LGZTRA
       LDU    #MLIRE
       LBSR   DOSFIL
       PSHS   CC
       LDA    #BKTIR    restaure
       STA    BANKC
       PULS   CC
       BEQ    XLIRZ9    RAZ    ->
       BCS    XLIRZ9    erreur ->

       LDX    #FILNAM   fich cour.
       LDY    #DESCOU
BMEMFC LDA    ,X+
       STA    ,Y+
       CMPX   #FILNAM+8
       BNE    BMEMFC    ->

       JSR    LECDES    lecture dessin
       TSTB
       BNE    XLIRZ9    ->

       LDB    #1        visu charg.
       JSR    FENFER
       JSR    RESTAU
       JSR    FENACT
       CLRB
       LEAS   2,S
       RTS              ->>

XLIRZ9 CLRB
       LBSR   FENFER
       LDB    #$4C      Inverser pouss.
       LBSR   FENCH
       LBSR   FENIVD
       LBRA   EXECF1    ->

*** Ecrire fichier
XFECRI EQU    *
       JSR    FENCH
       JSR    FENIVD
       LDA    #1        sélection +
       JSR    SPCADR    cadrage feuille
       BEQ    XFECRF    raz ->
       EXG    A,B
       CMPB   #ON
       BNE    XFECR0    ->
       CLR    CADRNG    pleine page
       CLR    CADCOL
       LDA    #102
       STA    CADHAU
       LDA    #120
       STA    CADLAR
XFECR0 JSR    ECRDES
       CLRB
       JSR    FENFER

XFECRF LDB    #$45
       JSR    FENCH
       JSR    FENIVD
       LBRA   EXECF1    ->

*** Fichier -> Album
XFALB  EQU    *
       LBSR   FENCH     Inverser pouss.
       LBSR   FENIVD

       LDX    #FILNAM   filtre .ALB
XLIRA0 CLR    ,X+
       CMPX   #FILNAM+8
       BNE    XLIRA0    ->
       LDD    #$414C
       STD    ,X++
       LDA    #$42
       STA    ,X+
       LDX    #FENVID   sélection
       LDD    #$0518
       LBSR   FENOUV
       LDA    #BKMANO   manoeuvre
       STA    BANKC
       LDX    #ZONTRA
       LDY    #LGZTRA
       LDU    #MLIRE
       LBSR   DOSFIL
       PSHS   CC
       LDA    #BKTIR    restaure
       STA    BANKC
       PULS   CC
       BEQ    XLIRAX    RAZ    ->
       BCS    XLIRAX    erreur ->

       LDX    #FILNAM   trouver un alb.
       JSR    CHALB
       BCS    XLIRAX    pas de place ->

       JSR    CHAALB    charger l'album
       BCS    XLIRAX    erreur ->
       STX    ALBCOU

XLIRAX CLRB
       LBSR   FENFER

XLIRAF LDB    #$46      Inverser pouss.
       LBSR   FENCH
       LBSR   FENIVD
       LBRA   EXECF1    ->

*** Album -> Fichier
XALBF  EQU    *
       LBSR   FENCH
       LBSR   FENIVD

       LDD    #$0810
       LDX    #$FFFF
       LDY    #$FFFF
       JSR    SELALB
       BCS    XECAF     ->
       JSR    FENDES
       JSR    ECRALB    écriture album>
       CLRB
       JSR    FENFER
       JSR    FENACT

XECAF  LDB    #$41      Inverser pouss.
       LBSR   FENCH
       LBSR   FENIVD
       LBRA   EXECF1    ->

*** Quitter
XFQUIT EQU    *
       LBSR   FENCH
       LBSR   FENIVD
       LDA    #BKMANO   manoeuvre
       STA    BANKC
       LDX    #ZONTRA
       LDD    #$0D20
       LBSR   TBREAK
       BCS    FINGR     ->
       LDA    #BKTIR    restaure
       STA    BANKC
       LDB    #$51
       LBSR   FENCH
       LBSR   FENIVD
       LBRA   EXECF1    ->

*      Nettoyages divers
*---------------------------------------

*      Fenêtrage
FINGR  JSR    FENFIN

*      Attributs de visu.
       LDB    #ESC    40 col
       JSR    PUTC
       LDB    #$5A
       JSR    PUTC

       LDA    #0
       LDX    #0
       LDY    MEMC0
       JSR    SETP
       LDA    #1
       LDX    #0
       LDY    MEMC1
       JSR    SETP

       LDA    $E7E6     autorise écritur
       ORA    #$40      cartouche
       STA    $E7E6
       LDD    #$FFFF
       STD    MEMC0
       STD    MEMC1
       LDA    $E7E6     interdit écritur
       ANDA   #$BF      cartouche
       STA    $E7E6

       JMP    MENU    ->>>>>>>

* Fin menu fichier
*---------------------------------------

XFRETZ CLRB
XFRET  PSHS   B
       CLRB
       JSR    FENFER
       LDD    <ADF
       CMPD   ADFSOV,S
       BEQ    XFRET0    ->
       JSR    RESTAU    cadrage
XFRET0 JSR    FENACT
       PULS   B
       LEAS   2,S
       RTS


*=======================================
* S/P menu déroulant de sélection outils
*
* Sortie: B  code menu principal sélect.
*=======================================

SPOUTI EQU    *
*---------------------------------------

       LDX    #FENOUT
       LDD    #$0205
       JSR    FENOUV
       JSR    FENACT

EXECO1 JSR    FEN
       TSTB
       BEQ    EXECO1    ->
       LDU    #PILFEN
       PSHU   CC,D,X,Y
       CMPB   #$41
       BCS    EXECO2    ->
       CMPB   #$4D
       BCC    EXECO2    ->
       BRA    EXECO3    ->
EXECO2 LDA    #$0F
       LDX    #XORET
       LDY    #XORETZ
       JSR    ABORT
       CMPU   #0
       BEQ    EXECO1    ->
       JMP    ,U

*** Visualiser nouvel outil
EXECO3 TFR    B,A
       CLRB
       JSR    FENFER
       SUBA   #$41
       CMPA   #11
       BNE    EXECO4    ->
       TST    FLGTIR
       BNE    EXECO4    ok ->
       LDX    #MTIRVI
       JSR    FENERR
       BRA    EXECOF    ->
EXECO4 STA    OUTIL
       JSR    AFFOPT
       CLR    FLGSS2

*** Sauvegarder écran courant
       JSR    SAUVE

EXECOF JSR    FENACT
       CLRB
       RTS             ->>

* Fin menu outil
*---------------------------------------

XORETZ CLRB
XORET  PSHS   B
       CLRB
       JSR    FENFER
       JSR    FENACT
       PULS   B
       RTS


*=======================================
* S/P de gestion tiroir
*
* Sortie: B  code menu principal sélect.
*=======================================

FFTIRO FCB    FLOCA,1,4,23,74
       FCB    FCOMF,FF,OFF
       FCB    FCALL
       FDB    MENUD
       FCB    FSTOP

SPTIRO EQU    *
*---------------------------------------

       TST    FLGTIR
       BNE    SPTI0     ok ->
       LDX    #MTIRVI
       JSR    FENERR
       JSR    FENACT
       RTS              ->>

SPTI0  LEAX   FFTIRO,PCR
       LDD    #0
       JSR    FENOUV

* Visualisation du tiroir
       LDB    #ESC      tour magenta
       JSR    PUTC
       LDB    #$65
       JSR    PUTC
       LDD    #$0104    fond tramé
       LDY    #$174A
       JSR    FENLOC
       JSR    FENTRA
       LDX    #32       delimite tiroir
       LDY    #8
       LDA    #1
       JSR    VISTIR

* Travail sur le tiroir

       JSR    FENACT

EXECT1 JSR    FEN
       LDU    #PILFEN
       PSHU   CC,D,X,Y
       TSTB
       BEQ    EXECT2    ->
       CMPB   #$0D
       BEQ    ROTIR     ->
       LDA    #$91
       LDX    #XTRET
       LDY    #XTRETZ
       JSR    ABORT
       CMPU   #0
       BEQ    EXECT1    ->
       JMP    ,U

*** Tester la gestion souris


EXECT2 LDA    REGCC
       TFR    A,CC
       LBCC   EXECT1    ->
ROTIR0 JSR    LPIN
       BCS    ROTIR0    ->

*** Gestion du tiroir
ROTIR  EQU    *
       LBSR   MODTIR
       LBRA   EXECT1    ->

* Fin traitement tiroir
*---------------------------------------

XTRETZ CLRB
XTRET  PSHS   B
       LDB    #ESC      tour normal
       JSR    PUTC
       LDB    #$60
       JSR    PUTC
       CLRB
       JSR    FENFER
       JSR    FENACT
       PULS   B
       RTS


*=======================================
* S/P menu déroulant de gestion motifs
*
* Sortie: B  code menu principal sélect.
*=======================================

SPMOTI LEAS   -18,S
MEMCC  SET    0
RNGLP  SET    1
COLLP  SET    2
HAULP  SET    3
LARLP  SET    4
LOCX   SET    5
LOCY   SET    7
STORE  SET    9       mode store
MOTTRA SET    10      8 oct.
*---------------------------------------

       CLR    FLGSS2
       CLR    STORE,S

       LDX    #FENMOT
       LDD    #$0205
       JSR    FENOUV

*      Visualiser le motif courant

       LDX    #CARMOT
       LEAY   MOTTRA,S
BCOPM0 LDD    ,X++
       STD    ,Y++
       CMPX   #CARMOT+8
       BNE    BCOPM0    ->

       LEAY   MOTTRA,S
       JSR    VISMOT

*      Renseigner les 32 codes equiv des
*      poussoirs motifs

       LDA    #233
       LDB    #255
BCODEQ JSR    FENCH
       STA    CODEQU,X
       DECA
       CMPA   #201
       BNE    BCODEQ    ->

*      Visualiser les 32 codes equiv des
*      poussoirs motifs haut vers bas

       LDB    #202
       LDY    #MOTREM+16
BCODQ0 JSR    FENCH
       TFR    Y,X
       JSR    AF4MOT
       JSR    FENTI
       LEAY   8,Y
       INCB
       CMPB   #234
       BNE    BCODQ0    ->

*      Acquérir les coordonnées de la
*      zone loupe

       LDB    #254
       JSR    FENCH
       LDD    RNG,X
       STD    RNGLP,S
       LDD    HAUT,X
       STD    HAULP,S

       JSR    FENACT

EXECM1 JSR    FEN
       TFR    CC,A
       STA    MEMCC,S
       STX    LOCX,S
       STY    LOCY,S

       TSTB
       BEQ    EXECM4    ->
       CMPB   #RC
       LBEQ   XRMOT     ->
       CMPB   #199
       LBEQ   XMMOT     ->
       CMPB   #200
       BCS    EXECM2    ->
       CMPB   #234
       BCC    EXECM2    ->
       BRA    XPMOT     ->

EXECM2 LDA    #$10
       LDX    #XMRET
       LDY    #XMRETZ
       JSR    ABORT
       CMPU   #0
       LBEQ   XCMOT   ->
       JMP    ,U

EXECM4 LDA    MEMCC,S
       TFR    A,CC
       LBCC   EXECM1    ->
       LDX    RNGLP,S   clic
       LDY    HAULP,S
       JSR    SOUDAN
       LBCC   EXECM1    ->

*** Clic dans loupe
       TST    STORE,S
       LBNE   EXECM1    mode store ->
       CLR    FLGSS2
ATRB0  JSR    LPIN
       BCS    ATRB0     anti-rebond ->
       LDD    LOCX,S    coord. car.
       LSRA
       RORB
       LSRA
       RORB
       LSRB
       LDA    LOCY+1,S
       LSRA
       LSRA
       LSRA
       LDY    #$0101    visu loupe
       JSR    FENLOC
       JSR    FENIVD
       STD    LOCX,S    mémo bit
       LDA    RNGLP,S
       ADDA   #7
       SUBA   LOCX,S
       LEAX   MOTTRA,S
       LDB    LOCX+1,S
       SUBB   COLLP,S
       SUBB   #7
       NEGB
       LDY    #TBITS
       LDB    B,Y
       EORB   A,X
       STB    A,X
       LEAY   MOTTRA,S  visu motif
       JSR    VISMOO

       LBRA   EXECM1    ->

*** Présélection d'un motif
*** ou rangement (store) d'un motif

XPMOT  EQU    *
       TST    STORE,S
       BNE    XPMOTS    store ->
       CLR    FLGSS2
       SUBB   #200
       LDA    #8
       MUL
       LDY    #MOTREM
       LEAY   D,Y
       JSR    VISMOT
       LDB    #8
       LEAX   MOTTRA,S
BCOPM1 LDA    ,Y+
       STA    ,X+
       DECB
       BNE    BCOPM1    ->
       LBRA   EXECM1    ->

XPMOTS JSR    FENCH
       SUBB   #200
       LDA    #8
       MUL
       LDX    #MOTREM
       LEAX   D,X
       LEAY   MOTTRA,S
       JSR    AF4MOT
       JSR    FENTI
       LDA    $E7E6     autorise écritur
       ORA    #$40      cartouche
       STA    $E7E6
       LDB    #8
BCOPS1 LDA    ,Y+
       STA    ,X+
       DECB
       BNE    BCOPS1    ->
       LDA    $E7E6     interdit écritur
       ANDA   #$BF      cartouche
       STA    $E7E6
       LDB    #199      revenir en non
       JSR    FENCH     "store"
       JSR    FENIVD
       LDA    #OFF
       STA    VAL,X
       BRA    FINSTO    ->

*** Mémorisation d'un motif (inverseur)
*** Nb: FENDES inutile car sélection par
***     clavier impossible

XMMOT  EQU    *
       CLR    FLGSS2
       JSR    FENCH
       LDA    VAL,X
       STA    STORE,S
       CMPA   #ON
       BEQ    ACTSTO    passage store ->
FINSTO LDA    #OFF      réautorisation
       LDB    #RC
       JSR    FENCH
       STA    VAL,X
       LDB    #200
       JSR    FENCH
       STA    VAL,X
       LDB    #201
       JSR    FENCH
       STA    VAL,X
       CLR    STORE,S
       LBRA   EXECM1    ->

ACTSTO LDA    #INTERD   interdictions
       LDB    #RC
       JSR    FENCH
       STA    VAL,X
       LDB    #200
       JSR    FENCH
       STA    VAL,X
       LDB    #201
       JSR    FENCH
       STA    VAL,X
       LBRA   EXECM1    ->

*** Motif saisie au clavier

XCMOT  EQU    *
       TST    STORE,S
       LBNE   EXECM1    mode store ->
       LEAY   MOTTRA,S
       JSR    XTRMOT
       LBCC   EXECM1    ->
       JSR    VISMOT
       LBRA   EXECM1    ->

* Fin menu motif avec sélection
*---------------------------------------

XRMOT  EQU    *
       LDX    #CARMOT
       LEAY   MOTTRA,S
BCOPM3 LDD    ,Y++
       STD    ,X++
       CMPX   #MOTIF
       BNE    BCOPM3    ->

       CLRB
       JSR    FENFER
       JSR    AFFOPT    visu. nouv. mot.
       JSR    FENACT
       CLRB
       BRA    XMRET0    ->
       RTS

* Fin menu motif sans sélection
*---------------------------------------

XMRETZ CLRB
XMRET  PSHS   B
       CLRB
       JSR    FENFER
       JSR    FENACT
       PULS   B
XMRET0 LEAS   18,S
       RTS


*=======================================
* S/P menu déroulant de gestion impress.
*
* Sortie: B  code menu principal sélect.
*=======================================

SPIMPR EQU    *
       LEAS   -2,S
ADFSOV SET    0
*---------------------------------------

       JSR    FENDES    pour cadrage
       JSR    SAUVE     éventuel
       LDD    <ADF
       STD    ADFSOV,S

       LDX    #FIMPR
       LDD    #$0231
       JSR    FENOUV

       JSR    FENACT
EXECI1 JSR    FEN
       TSTB
       BEQ    EXECI1    ->
       LDU    #PILFEN
       PSHU   CC,D,X,Y
       CMPB   #$45      Ecran
       LBEQ   XIECR     ->
       CMPB   #$46      Feuille
       LBEQ   XIFEU     ->
       LDA    #$94
       LDX    #XIRET
       LDY    #XIRETZ
       JSR    ABORT
       CMPU   #0
       BEQ    EXECI1    ->
       JMP    ,U

*** Impression Ecran
XIECR  EQU    *
       LBSR   FENCH     Inverser pouss.
       LBSR   FENIVD

       LDA    RGDECR
       STA    CADRNG
       LDA    CLDECR
       STA    CADCOL
       LDA    #23
       STA    CADHAU
       LDA    #74
       STA    CADLAR
       LDB    #OFF      pas pleine page
       JSR    IMPPAG

       LDB    #$45      Inverser pouss.
       LBSR   FENCH
       LBSR   FENIVD
       LBSR   FENACT
       LBRA   EXECI1    ->

*** Impression feuille
XIFEU  EQU    *
       LBSR   FENCH     Inverser pouss.
       LBSR   FENIVD

       LDA    #1        sélection +
       JSR    SPCADR    cadrage
       LBEQ   XIFEUF    raz->
       EXG    A,B

       LDA    CADCOL    assure cadrage
       LSLA             horiz.
       ADDA   CADLAR
       STA    CADLAR
       CLR    CADCOL
       JSR    IMPPAG

       CLRB
       JSR    FENFER
       JSR    FENACT
XIFEUF LDB    #$46      Inverser pouss.
       LBSR   FENCH
       LBSR   FENIVD
       LBRA   EXECI1    ->

* Fin menu impression
*---------------------------------------

XIRETZ CLRB
XIRET  PSHS   B
       CLRB
       JSR    FENFER
       LDD    <ADF
       CMPD   ADFSOV+1,S
       BEQ    XIRET0    ->
       JSR    RESTAU    cadrage
XIRET0 JSR    FENACT
       PULS   B
       LEAS   2,S
       RTS


*=======================================
* S/P effacement écran courant
*=======================================

FSELR  FCB    FLOCF,0,0,4,16
       FCB    FFOND,FTOURE,FCADRE
       FCB    FCOMF,FF,OFF
       FCB    FLOCF,1,1,1,14
       FCB    FEDI,ESC,$4E
       FCC    \RAZT\
       FCB    ESC,$4C
       FCC    \out\
       FCB    0
       FCB    FPOUSS,$54,OFF
       FCB    FLOCR,1,0,1,14
       FCB    FEDI,ESC,$4E
       FCC    \RAZE\
       FCB    ESC,$4C
       FCC    \cran\
       FCB    0
       FCB    FPOUSS,$45,OFF
       FCB    FCALL
       FDB    MENUD
       FCB    FSTOP
*---------------------------------------
SPRAZ  JSR    FENCH
       LDD    RNG,X
       ADDB   #3
       LEAX   FSELR,PCR
       JSR    FENOUV
       JSR    FENACT
XRAZ0  JSR    FEN
       TSTB
       BEQ    XRAZ0     ->
       LDU    #PILFEN
       PSHU   CC,D,X,Y
       CMPB   #$54
       BEQ    XRAZT     ->
       CMPB   #$45
       BEQ    XRAZE     ->
       LDA    #$05
       LDX    #FSPRA
       LDY    #FSPRAZ
       JSR    ABORT
       CMPU   #0
       BEQ    XRAZ0     ->
       JMP    ,U

XRAZT  JSR    FENDES    raz feuille
       JSR    FENCH
       JSR    FENIVD
       JSR    RAZF

XRAZE  CLRB             raz écran
       JSR    FENFER
       JSR    RAZE
       JSR    FENACT
       RTS

FSPRAZ CLRB
FSPRA  PSHS   B
       CLRB
       JSR    FENFER
       JSR    FENACT
       PULS   B,PC


*=======================================
* S/P restaure écran à partir de la
*     zone de travail
*=======================================

RESTAU EQU    *
       CLRB
       JSR    FEUECR
       INCB
       JSR    FEUECR
       RTS


*=======================================
* S/P sauvegarde écran dans la zone
*     de travail
*=======================================

SAUVE  EQU    *
       CLRB
       JSR    ECRFEU
       INCB
       JSR    ECRFEU
       RTS


*=======================================
* S/P visualisation du motif courant en
*     fenêtre de travail
*
* Entrée : Y  pointe motif
*=======================================

VISMOO PSHS   D,X,Y
       BRA    VISMO0    ->
VISMOT PSHS   D,X,Y
PD     SET    0
PX     SET    2
PY     SET    4
*---------------------------------------

       LDB    #254
       JSR    FENCH
       LDD    RNG,X
       JSR    LPMOTI

VISMO0 LDD    #$020F
       LDY    #$0202
       JSR    FENLOF
       LDY    PY,S
       JSR    AF4MOT
       PULS   D,X,Y,PC


*=======================================
* S/P extraction du motif d'un caractère
*     -utilise le drapeau FLGSS2 qui
*     doit être mis à 0 au 1er appel
*     -utilise la table TABG2 des codes
*      G2:
*           rang = code pour générateur
*                  PTGENE (96,97,...)
*           si b7=> superposition
*           fin  = 0
*
* Entrée : B  caractère lu au clavier
*          Y  pointe motif à générer
* Sortie : CY 1 si motif modifié
*             0 sinon (SS2)
*=======================================

TABG2  FDB    $CB23,$2426,$2C2D,$2E2F
       FDB    $3031,$383C,$3D3E,$C1C2
       FDB    $C3C8,$6A7A,$7B00

XTRMOT PSHS   D,X,Y
*---------------------------------------

       TST    FLGSS2
       BEQ    XTRM50    ->
       LDA    FLGSS2
       CMPA   #SS2
       BNE    XTRM30    superposition ->
       LEAX   TABG2,PCR car. suivant SS2
       LDA    #95
XTRM21 INCA
       TST    ,X
       BEQ    XTRM50    inconnu ->
       CMPB   ,X
       BEQ    XTRM24    trouvé normal ->
       ORB    #$80
       CMPB   ,X
       BEQ    XTRM22    trouvé superpos>
       ANDB   #$7F
       LEAX   1,X
       BRA    XTRM21    ->

XTRM22 STA    FLGSS2    accent ...
       TFR    A,B
       ANDB   #$7F
       LDA    #8        renseigner motif
       MUL              sans visu.
       LDX    PTGENE
       LEAX   D,X
       LDB    #8
XTRM23 LDA    ,X+
       STA    ,Y+
       DECB
       BNE    XTRM23    ->
       ANDCC  #$FE
       LBRA   XTRMF     ->

XTRM24 CLR    FLGSS2    car. G2
       TFR    A,B
       BRA    XTRM90    ->

XTRM30 EQU    *         lettre accentuée
       CLR    FLGSS2    ->superposer
       SUBB   #$20
       BCS    XTRMRZ    ->
       CMPB   #$96
       BCC    XTRMRZ    ->
       LDA    #8
       MUL
       LDX    PTGENE
       LEAX   D,X
       LDB    #8
XTRM31 LDA    ,Y
       ORA    ,X+
       STA    ,Y+
       DECB
       BNE    XTRM31    ->
       ORCC   #1
       BRA    XTRMF     ->

XTRM50 CMPB   #SS2
       BNE    XTRM80    ->
       STB    FLGSS2
XTRMRZ ANDCC  #$FE
       BRA    XTRMF     ->

XTRM80 CLR    FLGSS2
       SUBB   #$20
       BCS    XTRMRZ    ->
       CMPB   #$96
       BCC    XTRMRZ    ->

XTRM90 LDA    #8        renseigner motif
       MUL
       LDX    PTGENE
       LEAX   D,X
       LDB    #8
XTRM91 LDA    ,X+
       STA    ,Y+
       DECB
       BNE    XTRM91    ->
       ORCC   #1

XTRMF  PULS   D,X,Y,PC
