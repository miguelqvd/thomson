       TITLE  TO-SNAP:Menusderoulants
*      ---------------------------------
       PAGE

****************************************
*                                      *
*           Menu déroulants            *
*                                      *
****************************************


*=======================================
* S/P menu déroulant de gestion info
*=======================================

MENINF EQU    *
       LEAS   -39,S
PBLEU  SET    0
PVERT  SET    1
PROUGE SET    2
NOPAL  SET    3
MTOUR  SET    4
MMODE  SET    5
MPAL   SET    7       32 octets palette
*---------------------------------------

       LDX    #FENINF
       LDD    3,X
       JSR    POPUP
       JSR    FENOUV

       LDA    NUMPHO
       LDX    #TABBK
       LDA    A,X
       STA    BANKC

       LDA    TOUR
       STA    MTOUR,S

       LDA    #16
       LDX    #PALPHO
       LEAY   MPAL,S
LIPAI  LDU    ,X++
       STU    ,Y++
       DECA
       BNE    LIPAI     ->

       LDA    NUMPHO
       LDX    #TABMOD
       LDB    A,X
       STB    MMODE,S
       LDX    #TMNGR
BAFMV  LDA    ,X
       CMPA   #$FF
       BEQ    PERMO    pas trouve ->
       CMPA   MMODE,S
       BEQ    POKMO    ->
       LEAX   17,X
       BRA    BAFMV    ->
PERMO  LDX    #TMNGR
POKMO  STX    MMODE,S

       CLR    NOPAL,S
EXCI00 LEAX   MPAL,S
       LDA    NOPAL,S
       LSLA
       LEAX   A,X
       LDA    ,X
       ANDA   #$0F
       STA    PBLEU,S
       LDA    1,X
       LSRA
       LSRA
       LSRA
       LSRA
       STA    PVERT,S
       LDA    1,X
       ANDA   #$0F
       STA    PROUGE,S

EXECI0 JSR    FENDES
       LDB    #$5A     coul palette
       JSR    FENCH
       CLRA
       LDB    NOPAL,S
       LDX    #BUF
       LDY    #2
       JSR    BINDCD
       JSR    FENEDI

       LDA    PBLEU,S
       LDB    PVERT,S
       LSLB
       LSLB
       LSLB
       LSLB
       ORB    PROUGE,S
       TFR    D,Y
       LEAX   MPAL,S
       LDA    NOPAL,S
       LSLA
       STY    A,X
       PSHS   Y
       LDA    #ORANGE
       LDX    #0
       JSR    SETP

       LDB    #$48     hexa palette
       JSR    FENCH
       LDX    #BUF
       PULS   D
       JSR    BINHX2
       LDX    #BUF
       LDB    1,X
       JSR    FENPUT
       LDB    #HT
       JSR    FENPUT
       LDB    2,X
       JSR    FENPUT
       LDB    #HT
       JSR    FENPUT
       LDB    3,X
       JSR    FENPUT

       LEAX   MPAL,S  coul tour
       LDA    MTOUR,S
       LSLA
       LDY    A,X
       LDA    #PARME
       LDX    #0
       JSR    SETP
       LDB    #$59
       JSR    FENCH
       CLRA
       LDB    MTOUR,S
       LDX    #BUF
       LDY    #2
       JSR    BINDCD
       JSR    FENEDI

       LDB    #$4D     mode vidéo
       JSR    FENCH
       LDX    MMODE,S
       LEAX   2,X
       JSR    FENEDI

EXECI1 JSR    FENACT

EXECI2 JSR    FENPOP
       TSTB
       BEQ    EXECI2    ->
       CMPB   #$54      +Tour
       LBEQ   XIPLT     ->
       CMPB   #$55      -Tour
       LBEQ   XIMNT     ->
       CMPB   #$50      +Palette
       LBEQ   XIPLP     ->
       CMPB   #$51      -Palette
       LBEQ   XIMNP     ->
       CMPB   #$42      +Bleu
       LBEQ   XIPLB     ->
       CMPB   #$43      -Bleu
       LBEQ   XIMNB     ->
       CMPB   #$56      +Vert
       LBEQ   XIPLV     ->
       CMPB   #$57      -Vert
       LBEQ   XIMNV     ->
       CMPB   #$52      +Rouge
       LBEQ   XIPLR     ->
       CMPB   #$53      -Rouge
       LBEQ   XIMNR     ->
       CMPB   #$4D      Mode
       LBEQ   XIMOD     ->

       CMPB   #RC
       LBEQ   XIRC      ->
       CMPB   #FF       RAZ
       LBEQ   XIRET     ->
       LBRA   EXECI2    ->

*** mode
XIMOD  EQU    *
       LDX    MMODE,S
       LEAX   17,X
       STX    MMODE,S
       LDA    ,X
       CMPA   #$FF
       LBNE   EXECI0    ->
       LDX    #TMNGR
       STX    MMODE,S
       LBRA   EXECI0    ->

*** + tour
XIPLT  EQU    *
       INC    MTOUR,S
       LDA    MTOUR,S
       CMPA   #16
       LBLT   EXECI0    ->
       CLR    MTOUR,S
       LBRA   EXECI0    ->

*** - tour
XIMNT  EQU    *
       DEC    MTOUR,S
       LBGE   EXECI0    ->
       LDA    #15
       STA    MTOUR,S
       LBRA   EXECI0    ->

*** + palette
XIPLP  EQU    *
       INC    NOPAL,S
       LDA    NOPAL,S
       CMPA   #16
       LBLT   EXCI00    ->
       CLR    NOPAL,S
       LBRA   EXCI00    ->

*** - palette
XIMNP  EQU    *
       DEC    NOPAL,S
       LBGE   EXCI00    ->
       LDA    #15
       STA    NOPAL,S
       LBRA   EXCI00    ->

*** + bleu
XIPLB  EQU    *
       INC    PBLEU,S
       LDA    PBLEU,S
       CMPA   #16
       LBLT   EXECI0    ->
       CLR    PBLEU,S
       LBRA   EXECI0    ->

*** -bleu
XIMNB  EQU    *
       DEC    PBLEU,S
       LBGE   EXECI0    ->
       LDA    #15
       STA    PBLEU,S
       LBRA   EXECI0    ->

*** + vert
XIPLV  EQU    *
       INC    PVERT,S
       LDA    PVERT,S
       CMPA   #16
       LBLT   EXECI0    ->
       CLR    PVERT,S
       LBRA   EXECI0    ->

*** - vert
XIMNV  EQU    *
       DEC    PVERT,S
       LBGE   EXECI0    ->
       LDA    #15
       STA    PVERT,S
       LBRA   EXECI0    ->

*** + rouge
XIPLR  EQU    *
       INC    PROUGE,S
       LDA    PROUGE,S
       CMPA   #16
       LBLT   EXECI0    ->
       CLR    PROUGE,S
       LBRA   EXECI0    ->

*** - rouge
XIMNR  EQU    *
       DEC    PROUGE,S
       LBGE   EXECI0    ->
       LDA    #15
       STA    PROUGE,S
       LBRA   EXECI0    ->

*** validation
XIRC   EQU    *
       LDA    MTOUR,S   tour
       STA    TOUR
       STA    TOUPHO

       LDA    #16
       LEAX   MPAL,S
       LDY    #PALPHO
ECPAI  LDU    ,X++
       STU    ,Y++
       DECA
       BNE    ECPAI     ->

       LDA    #16
       LEAX   MPAL,S
       LDY    #PALETE
ECPAI1 LDU    ,X++
       STU    ,Y++
       DECA
       BNE    ECPAI1    ->

       LDA    NUMPHO
       LDX    #TABMOD
       LDY    MMODE,S
       LDB    ,Y
       STB    A,X       mode "hard"
       LDB    1,Y
       STB    MBSPHO    mode "basic"
       LDA    #15
       LDX    #0
       LDY    PALDEF+30
       JSR    SETP

       LDB    #1
       JSR    FENFER
       JSR    SELMOD
       JSR    FENACT
       LDB    #$FF
       LEAS   39,S
       RTS              ->>

* Fin menu info video
*---------------------------------------

XIRET  CLRB
       JSR    FENFER
       LDA    #ORANGE
       LDX    #0
       LDY    PALDEF+30
       JSR    SETP
       LDA    #PARME
       LDX    #0
       LDY    PALDEF+26
       JSR    SETP
       JSR    FENACT
       CLRB
       LEAS   39,S
       RTS


*=======================================
* S/P menu déroulant gestion diaporama
*=======================================

MENCAT EQU    *
       LEAS   -3,S
PHO    SET    0
PHONEW SET    1
CPTR   SET    2
*---------------------------------------

       LDX    #FFPEL
       LDD    #$0101
       JSR    FENOUV

* Compteur anim.

       LDD    MEMTPO
       LDY    #2
       LDX    #BUF
       JSR    BINDCD
       LDB    #255
       JSR    FENCH
       LDX    #BUF
       JSR    FENEDI

* Interdire et tramer les photos non
* accessibles

EXECC0 LDA    MAXPHO
       STA    PHO,S
BINVPH INC    PHO,S
       LDB    PHO,S
       CMPB   #22
       BEQ    EXECC1   ->
       ADDB   #200
       JSR    FENCH
       JSR    FENTRA
       LDB    #INTERD
       STB    VAL,X
       BRA    BINVPH    ->

* visualiser les noms

EXECC1 LDB    #-1
       STB    PHO,S
BVINM  INC    PHO,S
       LDB    PHO,S
       CMPB   #22
       BEQ    EXECC2   ->
       LDX    #TABPHO
       TST    B,X
       BEQ    BVINM    ->
       ADDB   #200
       JSR    FENCH
       LDX    #TABNOM
       LDB    PHO,S
       LDA    #8
       MUL
       LEAX   B,X
       LDA    #8
BVINM1 LDB    ,X+
       JSR    FENPUT
       DECA
       BNE    BVINM1    ->
       BRA    BVINM     ->

EXECC2 LDA    #$FF
       STA    PHO,S     photo sélectioné
       JSR    FENACT

EXECC3 JSR    FEN
       TSTB
       BEQ    EXECC3    ->
       CMPB   #$56      V
       LBEQ   XCVOIR    ->
       CMPB   #$53      S
       LBEQ   XCSUP     ->
       CMPB   #$41      A
       LBEQ   XCANIM    ->
       CMPB   #$45      E
       LBEQ   XCECHA    ->
       CMPB   #FF       RAZ
       LBEQ   XCRET     ->
       CMPB   #200
       BCS    EXECC3    ->
       CMPB   #222
       BCC    EXECC3    ->

*** Sélection de l'une des photos
*** 200..221 -> 0..21
       SUBB   #200
       CMPB   MAXPHO
       LBGT   EXECC3    ->
       STB    PHONEW,S
       CMPB   PHO,S
       LBEQ   SERD1     sup select ->

       TST    PHO,S
       LBMI   SERD0     ->

       LDB    #$45      2ème select.
       JSR    FENCH
       LDB    VAL,X
       CMPB   #OFF
       LBEQ   SERD00    ->
       LDB    #OFF      mode echange
       STB    VAL,X
       JSR    FENIVD

       LDX    #TABPHO   Echange des type
       LDA    PHO,S
       LDB    A,X
       STB    CPTR,S

       LDB    PHONEW,S
       LDB    B,X
       STB    A,X

       LDA    PHONEW,S
       LDB    CPTR,S
       STB    A,X

       LDX    #TABMOD   Echange des mode
       LDA    PHO,S
       LDB    A,X
       STB    CPTR,S

       LDB    PHONEW,S
       LDB    B,X
       STB    A,X

       LDA    PHONEW,S
       LDB    CPTR,S
       STB    A,X

       LDX    #TABBK    Echange des bank
       LDA    PHO,S
       LDB    A,X
       STB    CPTR,S

       LDB    PHONEW,S
       LDB    B,X
       STB    A,X

       LDA    PHONEW,S
       LDB    CPTR,S
       STB    A,X

       LDX    #TABNOM   Echange des noms
       LDA    PHO,S
       LDB    #8
       MUL
       LEAX   B,X
       LDY    #TABNOM
       LDA    PHONEW,S
       LDB    #8
       MUL
       LEAY   B,Y

       LDU    #8
XGNM   LDA    ,X
       LDB    ,Y
       STA    ,Y+
       STB    ,X+
       LEAU   -1,U
       CMPU   #0
       BNE    XGNM      ->

       LDA    PHO,S     cas d'une des
       LDB    PHONEW,S
*      CMPA   PHOTIR
       BEQ    EXGVI0    ->
       EXG    A,B
*      CMPA   PHOTIR
       BEQ    EXGVI0    ->
       BRA    EXGVID    ->
EXGVI0 EQU    *
*XGVI0 STB    PHOTIR

EXGVID JSR    FENDES
       LDB    PHO,S     restaure vidéo
       ADDB   #200      des 2 photos
       JSR    FENCH
       JSR    FENIVD
       LDB    PHO,S
       LDA    #8
       MUL
       LDX    #TABNOM
       LEAX   B,X
       LDA    #8
EXGV0  LDB    ,X+
       JSR    FENPUT
       DECA
       BNE    EXGV0     ->

       LDB    PHONEW,S
       ADDB   #200
       JSR    FENCH
       JSR    FENIVD
       LDB    PHONEW,S
       LDA    #8
       MUL
       LDX    #TABNOM
       LEAX   B,X
       LDA    #8
EXGV1  LDB    ,X+
       JSR    FENPUT
       DECA
       BNE    EXGV1     ->

       JSR    FENCNT

       LDA    #$FF
       STA    PHO,S
       LBRA   EXECC3    ->

SERD00 JSR    FENDES    raz autre sélect
       LDB    PHO,S
       ADDB   #200
       JSR    FENCH
       JSR    FENIVD
       JSR    FENCNT
SERD0  LDB    PHONEW,S
       STB    PHO,S
       LBRA   EXECC3    ->

SERD1  JSR    FENDES
       LDA    #$FF
       STA    PHO,S
       LDB    #$45
       JSR    FENCH
       LDA    VAL,X
       CMPA   #ON
       BEQ    SERD10    ->
       JSR    FENCNT
       LBRA   EXECC3    ->
SERD10 LDB    #OFF      invalide mode
       STB    VAL,X     échange
       JSR    FENIVD
       LBRA   EXECC1    ->

*** Voir la photo sélectionnée
XCVOIR EQU    *
       LDB    PHO,S
       LBMI   EXECC3    ->
       STB    NUMPHO

       LDB    #2        retour niveau 1
       JSR    FENFER

       JSR    SELMOD

       JSR    DECPHO

       JSR    FENACT
       LEAS   3,S
       LDB    #$FF
       RTS              ->>

*** positionnement flag "echange"
XCECHA EQU    *
       LDB    PHO,S
       LBPL   EXECC3    ->

       LDB    #$45
       JSR    FENCH
       LDA    VAL,X
       CMPA   #OFF
       LBEQ   EXECC3    ->
       JSR    FENDES    interdit si pas
       LDB    #$45      de sélection
       JSR    FENCH
       LDB    #OFF
       STB    VAL,X
       JSR    FENIVD
       JSR    FENCNT
       LBRA   EXECC3    ->

*** Supprimer la photo sélectionnée
XCSUP  EQU    *
       LDA    PHO,S
       LBMI   EXECC3    ->

       JSR    DELPHO
       EXG    A,B
       ADDB   #200
       JSR    FENCH
       JSR    FENFON
       LBRA   EXECC1    ->

*** Animer la pellicule
XCANIM EQU    *
       LDX    #TABPHO   verif pas tout
       CLRA             vierge
       CLR    CPTR,S
BVERIR TST    A,X
       BEQ    SVERIR    ->
       INC    CPTR,S
SVERIR INCA
       CMPA   MAXPHO
       BLE    BVERIR    ->
       LDA    CPTR,S
       CMPA   #1
       LBLE   EXECC3    ->

       LDB    #255
       LDX    #BUF
       JSR    FENLCZ
       LDD    #0
       LDY    #100
       JSR    DECBIN
       STD    MEMTPO
       STB    CPTR,S    memo

       LDB    #2        retour niveau 1
       JSR    FENFER

       LDA    NUMPHO
       STA    PHO,S
       LBRA   XXBAN1    ->
BANIM  JSR    GETC      test interrup.
       TSTB
       BNE    BANSTO    ->
       JSR    LPIN
       BCC    XBANIM    ->
BANSTO JSR    FORCV0    page vid 0
       JSR    SELDEF    mode vidéo def.
       LDA    #DBKPIL
       STA    BANKC
       LDX    #$A000    conf. interrup.
       LDD    #$0D11
       JSR    TBREAK
       LBCS   FBANIM    ->
       LDX    #500

XBANIM TST    MEMTPO+1
       BEQ    XXBAN1    ->
       LEAX   -1,X
       BNE    BANIM     ->
       LDX    #500
       DEC    CPTR,S
       BNE    BANIM     ->
       LDA    MEMTPO+1
       STA    CPTR,S    compteur en sec

XXBAN1 LDX    #TABPHO
       LDA    NUMPHO
XXBANI TST    A,X
       BNE    XXXBAN    ->
       INCA
       CMPA   MAXPHO
       BLE    XXBANI    ->
       CLRA
       BRA    XXBANI    ->

XXXBAN STA    NUMPHO
       STA    PHO,S     pour abandon
       JSR    DCCPHO

       LDX    #666

       INC    NUMPHO
       LDA    NUMPHO
       CMPA   MAXPHO
       LBLE   BANIM     ->
       CLR    NUMPHO
       LBRA   BANIM     ->

FBANIM LDA    PHO,S
       STA    NUMPHO
       JSR    SELMOD
       JSR    FENACT
       LEAS   3,S
       LDB    #$FF
       RTS              ->>

* Fin menu catalogue
*---------------------------------------

XCRET  LDB    #2        retour niveau 1
       JSR    FENFER    car photo peut
       JSR    SELMOD    etre supprimée
       JSR    DECPHO    ou echangée
       JSR    FENACT
       LDB    #$FF
       LEAS   3,S
       RTS


*=======================================
* S/P menu déroulant de gestion fichier
*=======================================

MENFIC EQU    *
       LEAS   -2,S
MANO   SET    0
*---------------------------------------

       LDX    #FENFIC
       LDD    3,X
       JSR    POPUP
       JSR    FENOUV

EXECF0 LDB    #ESC
       JSR    PUTC
       LDB    #$4D
       JSR    PUTC
       LDB    #BLANC
       JSR    FENCF
       LDD    #$0211   Disque courant
       LDY    #$0201
       JSR    FENLOF
       LDB    DKDRV
       ADDB   #$30
       JSR    PUTC
       LDB    #TRANSP
       JSR    FENCF
       LDB    #ESC
       JSR    PUTC
       LDB    #$4C
       JSR    PUTC

EXECF1 JSR    FENACT


EXECF2 JSR    FENPOP
       TSTB
       BEQ    EXECF2    ->
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
       CMPB   #FF       RAZ
       LBEQ   XFRET     ->
       LBRA   EXECF2    ->

*** Préciser unité
XFUNIT EQU    *
       LBSR   FENCH     Inverser pouss.
       LBSR   FENIVD
       LDX    #FENVID   sélection
       LDA    #11
       LDB    #24
       LBSR   POPUP
       JSR    FENOUV
       LDA    BKMANO    manoeuvre
       STA    BANKC
       LDX    #ZONTRA
       LDY    #LGZTRA
       LDU    #$FFFF
       LBSR   DOSSEL
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
       LDA    #15
       LDB    #24
       LBSR   POPUP
       JSR    FENOUV
       LDA    BKMANO    manoeuvre
       STA    BANKC
       LDX    #ZONTRA
       LDY    #LGZTRA
       LBSR   DOSINI
       CLRB
       LBSR   FENFER
       LDB    #$49      Inverser pouss.
       LBSR   FENCH
       LBSR   FENIVD
       LBRA   EXECF1    ->

*** Catalogue
XFCATA EQU    *
       LBSR   FENCH     Inverser pouss.
       LBSR   FENIVD
       LDX    #FENVID   sélection
       LDD    #$0200
       LBSR   FENOUV
       LDA    BKMANO    manoeuvre
       STA    BANKC
       LDX    #ZONTRA
       LDY    #LGZTRA
       LBSR   DOSCAT
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
       LDD    #$0500
       LBSR   FENOUV
       LDA    BKMANO    manoeuvre
       STA    BANKC
       LDX    #ZONTRA
       LDY    #LGZTRA
       LBSR   DOSREN
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
       LDD    #$0500
       LBSR   FENOUV
       LDA    BKMANO    manoeuvre
       STA    BANKC
       LDX    #ZONTRA
       LDY    #LGZTRA
       LBSR   DOSSUP
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
       LDD    #$0500
       LBSR   FENOUV
       LDA    BKMANO    manoeuvre
       STA    BANKC
       LDX    #ZONTRA
       LDY    #LGZTRA
       LBSR   DOSDUP
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

       LDB    #$10
       JSR    FENCH
       LDB    VAL,X
       CMPB   #ON
       LBEQ   XFLALB    ->

*      lecture unitaire

       LDX    #FILNAM   filtre .MAP
XLIRZ  CLR    ,X+
       CMPX   #FILNAM+8
       BNE    XLIRZ     ->
       LDD    #$4D41
       STD    ,X++
       LDA    #$50
       STA    ,X+
       LDX    #FENVID   sélection
       LDD    #$0500
       LBSR   FENOUV
       LDA    BKMANO    manoeuvre
       STA    BANKC
       LDX    #ZONTRA
       LDY    #LGZTRA
       LDU    #MLIRE
       LBSR   DOSFIL
       LBEQ   XLIRZ9    RAZ    ->
       LBCS   XLIRZ9    erreur ->

       LDX    #FILNAM   fich cour.
       LDY    #DESCOU
BMEMFC LDA    ,X+
       STA    ,Y+
       CMPX   #FILNAM+8
       BNE    BMEMFC    ->

       LDA    NUMPHO
       STA    OLDPHO
       JSR    PHOCH     recherche disp.
       LBCS   XLIRZ9    pas ->
       CLRA
       JSR    LECPHO    lecture photo
       LBCS   XLIRZF    ->

* Nb: un FENFER de 2 niveau est executé
*     dans LECPHO !!!

CPNOF  JSR    SELMOD
       JSR    FENACT
       LEAS   2,S
       LDB    #$FF
       RTS              ->>

*      lecture générique

XFLALB LDX    #FILNAM   filtre 00.MAP
XLIRZG CLR    ,X+
       CMPX   #FILNAM+6
       BNE    XLIRZG    ->
       LDD    #$3030
       STD    ,X++
       LDD    #$4D41
       STD    ,X++
       LDA    #$50
       STA    ,X+
       LDX    #FENVID   sélection
       LDD    #$0500
       LBSR   FENOUV
       LDA    BKMANO    manoeuvre
       STA    BANKC
       LDX    #ZONTRA
       LDY    #LGZTRA
       LDU    #MLIRE
       LBSR   DOSFIL
       LBEQ   XLIRZ9    RAZ    ->
       LBCS   XLIRZ9    erreur ->

       LDX    #FILNAM   fich cour.
       LDY    #DESALB
BMEMFG LDA    ,X+
       STA    ,Y+
       CMPX   #FILNAM+8
       BNE    BMEMFG    ->

       CLR    NUMALB

       LDA    NUMPHO    1ere
       STA    OLDPHO
       JSR    PHOCH     recherche disp.
       LBCS   XLIRZ9    Pas    ->
       CLRA             1ére existe !
       JSR    LECPHO    lecture photo
       LBCS   XLIRZF    ->
       BRA    CPNO3     ->

CPNO2  LDA    NUMPHO
       STA    OLDPHO
       JSR    PHOCH     pas 1ere
       BCC    CPNO2B    ->
       LDA    OLDPHO
       STA    NUMPHO
       LBRA   CPNOF     ->
CPNO2B LDA    #$FF      suivante facult
       JSR    LECPHO
       BCC    CPNO3     ->
       LDA    OLDPHO
       STA    NUMPHO
       LBRA   CPNOF     ->

CPNO3  JSR    GETC      test interrup.
       TSTB
       BNE    CPNOTB    ->
       JSR    LPIN
       BCC    CPNOCN    ->
CPNOTB JSR    SELDEF    mode vidéo def.
       LDA    #DBKPIL
       STA    BANKC
       LDX    #$A000    conf. interrup.
       LDD    #$0D11
       JSR    TBREAK
       PSHS   CC
*      LDA    OLDPHO
*      STA    NUMPHO
       JSR    SELMOD
       PULS   CC
       LBCS   CPNOF     ->

CPNOCN INC    NUMALB
       CLRA             composition nom
       LDB    NUMALB    fichier suivant
       LDX    #FILNAM+6
       LDY    #2
       JSR    BINDCD
       LDA    FILNAM+6
       CMPA   #$20
       LBNE   CPNO2     ->
       LDA    #$30
       STA    FILNAM+6
       LBRA   CPNO2     ->

XLIRZF LDA    OLDPHO
       STA    NUMPHO
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

       LDB    #$10
       JSR    FENCH
       LDB    VAL,X
       CMPB   #ON
       LBNE   XFECR1    ->

*      écriture générique

       CLR    NUMALB
       LDX    #TABPHO   verif pas tout
       CLRA             vierge
BVERIE LDB    A,X
       BNE    ECAL11    ->
       INCA
       CMPA   MAXPHO
       BLE    BVERIE    ->
       LDX    #MPELVI
       JSR    FENERR
       LBRA   XFECRF    ->

ECAL11 STA    PRMPHO
       LDX    #FENVID   Sélection
       LDD    #$0505
       LBSR   FENOUV

ECAL13 LDY    #FILNAM   nom défaut
       LDX    #DESALB
       LDA    #6
ECAL19 LDB    ,X+
       STB    ,Y+
       DECA
       BNE    ECAL19    ->
       LDD    #$2323
       STD    ,Y++
       LDD    #$4D41
       STD    ,Y++
       LDA    #$50
       STA    ,Y+

       LDX    #MCOMAL
       LDA    #8
ECAL10 LDB    ,X+
       STB    ,Y+
       DECA
       BNE    ECAL10    ->

       LDA    BKMANO    saisir nom
       STA    BANKC
       LDX    #ZONTRA
       LDY    #LGZTRA
       LDU    #MVPEL
       LBSR   DOSCZI
       LBEQ   XFCRFF    RAZ    ->
       LBCS   XFCRFF    erreur ->

       LDD    FILNAM+6  vérifier numéro
       CMPD   #$2323             libre
       BEQ    ECAL12    ->
       LDX    #MNUMP
       JSR    FENERR
       LDD    #0
       JSR    FENLOF
       BRA    ECAL13    ->

ECAL12 LDD    #$3030
       STD    FILNAM+6  1er fichier
       LDD    #$0309    vérifier non
       LBSR   FENLOF    existence (1er!)
       JSR    DOSTST
       LBCS   XFCRFF    existe ->

       LDB    #2
       JSR    FENFER

       LDA    NUMPHO
       STA    OLDPHO
       LDA    PRMPHO
       STA    NUMPHO

ECAL14 JSR    GETC      test interrup.
       TSTB
       BNE    ECALTB    ->
       JSR    LPIN
       BCC    ECALCN    ->
ECALTB JSR    SELDEF    mode vidéo def.
       LDA    #DBKPIL
       STA    BANKC
       LDX    #$A000    conf. interrup.
       LDD    #$0D11
       JSR    TBREAK
       LBCS   ECAL2S    ->

ECALCN JSR    DECPHO

       JSR    ECRPHO
       LBCS   ECAL3S    erreur ->

       LDX    #TABPHO
       LDA    NUMPHO
       STA    OLDPHO
ECAL15 INCA
       STA    NUMPHO
       CMPA   MAXPHO
       BGT    ECAL2S    ->
       TST    A,X
       BEQ    ECAL15    ->
       LDX    #FILNAM+6 nouveau nom
       INC    NUMALB
       CLRA
       LDB    NUMALB
       LDY    #2
       JSR    BINDCD
       LDA    #$4D
       STA    FILNAM+8  (0 de fin!)
       LDA    FILNAM+6
       CMPA   #$20
       BNE    ECAL14    ->
       LDA    #$30
       STA    FILNAM+6
       BRA    ECAL14    ->

ECAL2S LDA    OLDPHO    arret
       STA    NUMPHO
       LDX    #FILNAM+6 nouveau nom
       INC    NUMALB    pour purge suiv.
       CLRA
       LDB    NUMALB
       LDY    #2
       JSR    BINDCD
       LDA    #$4D
       STA    FILNAM+8
       LDA    FILNAM+6
       CMPA   #$20
       BNE    ECA22S    ->
       LDA    #$30
       STA    FILNAM+6
ECA22S LDB    #KILL
       JSR    EXTRA
       TSTB
       BEQ    ECAL2S    ->
ECAL3S JSR    SELMOD
       JSR    FENACT
       LEAS   2,S
       LDB    #$FF
       RTS              ->>

*      écriture unitaire

XFECR1 LDA    NUMPHO
       LDX    #TABPHO
       TST    A,X
       BNE    ECPH0     ->
       LDX    #MPASPH   pas de photo
       JSR    FENERR      courante !
       LBRA   XFECRF    ->

ECPH0  LDX    #FENVID   Sélection
       LDD    #$0505
       LBSR   FENOUV

       LDY    #FILNAM   nom défaut
       LDX    #DESCOU
       LDA    #8
ECAL0  LDB    ,X+
       STB    ,Y+
       DECA
       BNE    ECAL0     ->
       LDD    #$4D41
       STD    ,Y++
       LDA    #$50
       STA    ,Y+

       LDX    #MCOMAL
       LDA    #8
ECAL00 LDB    ,X+
       STB    ,Y+
       DECA
       BNE    ECAL00    ->

       LDA    BKMANO
       STA    BANKC
       LDX    #ZONTRA
       LDY    #LGZTRA
       LDU    #MVFICH
       LBSR   DOSCZI
       LBEQ   XFCRFF    RAZ    ->
       LBCS   XFCRFF    erreur ->

       LDD    #$0309    vérifier non
       LBSR   FENLOF    existence
       JSR    DOSTST
       LBCS   XFCRFF    existe ->

       LDB    #2
       JSR    FENFER

       JSR    SELMOD

       JSR    ECRPHO

       JSR    FENACT
       LEAS   2,S
       LDB    #$FF
       RTS              ->>

XFCRFF CLRB
       JSR    FENFER

XFECRF LDB    #$45
       JSR    FENCH
       JSR    FENIVD
       LBRA   EXECF1    ->

* Fin menu fichier
*---------------------------------------

XFRET  CLRB
       JSR    FENFER
       JSR    FENACT
       CLRB
       LEAS   2,S
       RTS

*=======================================
* S/P mode d'emploi
*=======================================

       FDB    0
TABHLP FDB    HLP1
       FDB    HLP2
       FDB    HLP3
       FDB    HLP4
       FDB    HLP5
       FDB    HLP6
       FDB    HLP7
       FDB    0

EMPPHO EQU    *
       LEAS   -2,S
PTHLP  SET    0
*---------------------------------------

       LDX    #FENHLP
       LDD    #$0000
       JSR    FENOUV

       LDD    #TABHLP
       STD    PTHLP,S

EXECM0 LDD    #$0301
       LDY    #$1326
       JSR    FENLOF
       JSR    FENFON

       LDD    #$0100
       LDY    #$1226
       JSR    FENLOR
       LDX    [PTHLP,S]
       JSR    FENTXT

       LDX    [PTHLP,S]
       CMPX   #HLP5
       BNE    EXECM1    ->
       LDX    #MIGDIN
       LDY    #BUF
BCOPMG LDA    ,X+
       STA    ,Y+
       CMPX   #FMIGDI
       BNE    BCOPMG    ->

       LDX    #BUF
       LDB    #MIG
       JSR    EXTRA

EXECM1 JSR    FENACT

EXECM2 JSR    FEN
       CMPB   #FF
       LBEQ   XMRET     ->
       CMPB   #RC
       LBEQ   XMRET     ->
       CMPB   #LF
       LBEQ   HLPSUI    ->
       CMPB   #VT
       LBEQ   HLPPRE    ->
       BRA    EXECM2    ->

*** passage à la page help suivante
HLPSUI EQU    *
       LDX    PTHLP,S
       LEAX   2,X
       LDD    ,X
       CMPD   #0
       BEQ    PBSHLP    ->
       STX    PTHLP,S
       JSR    FENDES
       LBRA   EXECM0    ->
PBSHLP LDB    #7
       JSR    FENPUT
       LBRA   EXECM2

*** passage à la page help précédente
HLPPRE EQU    *
       LDX    PTHLP,S
       LEAX   -2,X
       LDD    ,X
       CMPD   #0
       BEQ    PBPHLP    ->
       STX    PTHLP,S
       JSR    FENDES
       LBRA   EXECM0    ->
PBPHLP LDB    #7
       JSR    FENPUT
       LBRA   EXECM2    ->

* Fin menu mode d'emploi
*---------------------------------------

XMRET  CLRB
       JSR    FENFER
       JSR    FENACT
       CLRB
       LEAS   2,S
       RTS
