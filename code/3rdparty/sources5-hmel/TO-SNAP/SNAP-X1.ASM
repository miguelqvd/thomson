       TITLE  TO-PHOTO:Traitement
*      ---------------------------------
       PAGE

****************************************
*                                      *
*           Traitement                 *
*                                      *
****************************************


*=======================================
* S/P sauvegarde image vers un bank
*=======================================

SAUVG  EQU    *
*---------------------------------------

       LDX    #TABBK
       LDA    NUMPHO
       LDA    A,X
       STA    BANKC

SAUVGG EQU    *
*---------------------------------------
       LDA    $E7C3
       ORA    #1
       STA    $E7C3

       LDX    #$4000
       LDY    #$A000
BCOD0  LDD    ,X++
       STD    ,Y++
       CMPX   #$4000+8000
       BNE    BCOD0     ->

       LDA    $E7C3
       EORA   #1
       STA    $E7C3

       LDX    #$4000
BCOD1  LDD    ,X++
       STD    ,Y++
       CMPX   #$4000+8000
       BNE    BCOD1     ->
       RTS


*=======================================
* S/P codage d'une image vers un bank
*=======================================

CODPHO EQU    *
*---------------------------------------

       JSR    SAUVG

       LDX    #TABPHO   note photo
       LDA    NUMPHO
       LDB    #1
       STB    A,X
       LDX    #TABMOD   note mode photo
       LDB    SCRMOD    mode vidéo
       STB    A,X

       LDA    TOUR      sauve tour
       STA    TOUPHO

       LDX    #TMNGR    sauve mode basic
BNMBA0 LDA    ,X
       CMPA   #$FF
       BEQ    PBMOBA   ->
       CMPA   SCRMOD
       BEQ    OKMOBA   ->
       LEAX   17,X
       BRA    BNMBA0   ->
PBMOBA LDX    #TMNGR
OKMOBA LDA    1,X
       STA    MBSPHO

       LDA    #16       sauve palette
       LDX    #PALETE
       LDY    #PALPHO
BCDPA  LDU    ,X++
       STU    ,Y++
       DECA
       BNE    BCDPA     ->

       RTS


*=======================================
* S/P ecriture d'un fichier .PHO à
*     partir de la photo courante
*
* Entrée:  NUMPHO
*          FILNAM
* Sortie:  Cy =1 si erreur
*=======================================

ECRPHO PSHS   D,X,Y
       LEAS   -1,S
MEMBK  SET    0
*---------------------------------------

       CLR    $E7E4
       LDA    BANKC
       STA    MEMBK,S

* Une photo codée peut dépasser dans
* certains cas les 16k !!! pour garder
* la compatibilité de format on accèpte
* cette bizarerie et on procède :
*  -sauvegarde de la zone $9000-$9FFF
*   vers le bank DBKPIL qui ne doit pas
*   être actif.
*  -codage de $9000 à DFFF sur bank
*   BKMANO
*  - écriture fichier
*  -restauration zone $9000-9FFF

       LDA    #DBKPIL
       STA    BANKC
       LDX    #$9000
       LDY    #$A000
BSOVFE LDD    ,X++
       STD    ,Y++
       CMPX   #$A000
       BNE    BSOVFE    ->
       LDA    BKMANO
       STA    BANKC

       DECA
       STA    DEBZON+2
       LDD    #$9002
       STD    DEBZON
       CLR    PUTFLG
       LDB    #$FF
       STB    PASSCD
       CLR    WITH
       LDA    #1
       STA    X0COD
       CLR    Y0COD
       LDB    #40
       LDA    SCRMOD
       BITA   #$C0
       BEQ    ECCO      ->
       ADDB   #40
ECCO   STB    X1COD
       LDB    #24
       STB    Y1COD
       LDB    #CODE
       JSR    EXTRA
       COM    WITH

*      Ajout d'un descripteur
*          octet  0..1  : mode hard
*          octet  2..3  : couleur tour
*          octet  4..5  : mode basic
*          octets 6..37 : palette
*          octets 38-39 : $A55A

       LDA    NUMPHO
       LDX    #TABBK
       LDA    A,X
       STA    BANKC
       LDY    #BUF      ajout enveloppe
       CLRA             mode hard
       LDB    SCRMOD
       STD    ,Y++
       LDB    TOUPHO    tour
       STD    ,Y++
       LDB    MBSPHO    mode basic
       STD    ,Y++
       LDA    #32
       LDU    #PALPHO
BMMPA  LDD    ,U++
       ANDA   #$0F
       STD    ,Y++
       CMPU   #PALPHO+32
       BNE    BMMPA     ->
       LDD    #$A55A
       STD    ,Y++      ajout soco

       LDA    BKMANO
       STA    BANKC
       LDX    #BUF
       LDY    LSTBYT
       TFR    Y,D
       LSRB
       BCC    BMMPA0    ->
       CLR    ,Y+       descript. adr
BMMPA0 LDA    #40       paire
BMMPA1 LDB    ,X+
       STB    ,Y+
       DECA
       BNE    BMMPA1    ->

       LEAY   -$9002,Y  calcul longueur
       STY    $9000

       LDA    #SQO      #ouverture
       STA    FILMOD
       LDA    #2
       STA    FILTYP    type
       CLR    ASCFLG    binaire
       LDB    #OPEN
       JSR    EXTRA
       TSTB
       LBNE   ECALO     erreur ->

       CLRA             #en tete bloc
       JSR    ECRFIC
       LBCS   ECALF     ->
       LDA    $9000     longueur!
       JSR    ECRFIC
       LBCS   ECALF     ->
       LDA    $9001
       JSR    ECRFIC
       LBCS   ECALF     ->
       CLRA
       JSR    ECRFIC
       LBCS   ECALF     ->
       JSR    ECRFIC
       LBCS   ECALF     ->

       LDX    #$9002    #données
       LDY    $9000
ECAL1  LDA    ,X+
       JSR    ECRFIC
       LBCS   ECALF     erreur ->
       LEAY   -1,Y
       BNE    ECAL1     ->

       LDA    #$FF      #bloc fin
       JSR    ECRFIC
       LBCS   ECALF     ->
       CLRA
       LDB    #4
BECBFI JSR    ECRFIC
       LBCS   ECALF     ->
       DECB
       BNE    BECBFI    ->

       LDB    #CLOSE    # fin normale
       JSR    EXTRA

       LDA    #DBKPIL   restaure $9000..
       STA    BANKC
       LDX    #$9000
       LDY    #$A000
BRESFE LDD    ,Y++
       STD    ,X++
       CMPX   #$A000
       BNE    BRESFE    ->
       ANDCC  #$FE
       BRA    ECALF     ->

ECALO  STB    BUF       # erreur OPEN
       LDA    #DBKPIL   restaure $9000..
       STA    BANKC
       LDX    #$9000
       LDY    #$A000
BRESF5 LDD    ,Y++
       STD    ,X++
       CMPX   #$A000
       BNE    BRESF5    ->
       JSR    SELDEF    # éditer erreur
       LDB    BUF
       JSR    DOSERR
       ORCC   #$01

ECALF  TFR    CC,B
       LDA    MEMBK,S
       STA    BANKC
       TFR    B,CC
       LEAS   1,S
       PULS   D,X,Y,PC


*=======================================
* S/P décodage d'une image
*     L'entrée DCCPHO permet d'utiliser
*     deux pages physiques en commutatio
*     et donc d'accélerer l'affichage
*     Tout nouvel affichage devra
*     cependant etre précédé d'un appel
*     de FORCV0 pour forcer le retour
*     en page 0 qui seul permet les
*     écritures standards
*=======================================

DCCPHO LEAS   -1,S
PAG0   SET    0
       LDA    #1
       STA    PAG0,S
       BRA    DCCPH     ->
*---------------------------------------

DECPHO LEAS   -1,S
       CLR    PAG0,S
*---------------------------------------
DCCPH  LDX    #TABPHO
       LDA    NUMPHO
       TST    A,X
       BNE    DECS0     ->
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
       LEAS   1,S
       RTS              ->>

*      décodage image
DECS0  LDX    #TABBK
       LDA    A,X
       STA    BANKC
       BRA    DCVAZY    ->

RESTGG EQU    *
       LEAS   -1,S
       LDA    #-1
       STA    PAG0,S
*---------------------------------------

DCVAZY STS    BUF
       ORCC   #$50
       CLR    $E7E4    Accès registres
       LDA    BANKC     alimenter bkmano
       LDB    BKMANO    par la photo au

       LDY    #$A000    format "vidéo"
       LEAS   8000,Y
BDEC0  STA    <BANKC
       LDX    ,S++
       LDU    ,S++
       STB    <BANKC
       STX    ,Y++
       STU    ,Y++
       CMPY   #$A000+8000
       BNE    BDEC0     ->

       LDY    #$A000
       LEAS   8192,Y
BDEC1  STA    <BANKC
       LDX    ,Y++
       LDU    ,Y++
       STB    <BANKC
       STX    ,S++
       STU    ,S++
       CMPY   #$A000+8000
       BNE    BDEC1     ->

       LDS    BUF
       ANDCC  #$AF
       TST    PAG0,S
       BMI    SDEC01    ->
       STA    <BANKC
       LDA    TOUPHO    récup. tour
       STA    TOUR
       LDA    #16       récup. palette
       LDX    #PALPHO
       LDY    #PALETE
BRCPA  LDU    ,X++
       STU    ,Y++
       DECA
       BNE    BRCPA     ->
       JSR    SELMOD    fixer mode

SDEC01 LDB    $E7E4     Visualiser la
       ANDB   #$3F      page bkmano
       TST    BKMANO
       BEQ    SDEC00    ->
       ORB    #$80
SDEC00 ORB    TOUR
       STB    $E7DD

       LDA    BKVID
       LDB    BKMANO
       STA    BKMANO
       STB    BKVID

       TST    PAG0,S
       BGT    FDEC0     ->
       BSR    FORCV0

FDEC0  LEAS   1,S
       RTS


*=======================================
* S/P de forcage de la page physique 0
*     en page vidéo
*=======================================

FORCV0 EQU    *
*---------------------------------------
       TST    BKVID
       BNE    FFORCV   ->
       RTS             ->>

FFORCV LDA    BKVID    copier la meme
       LDB    BKMANO   visu en page 0
       LDY    #$A000   (la seule accédee
*                      par les routines
BDEC3  STA    <BANKC   d'accés en $4000)
       LDX    ,Y
       LDU    2,Y
       STB    <BANKC
       STX    ,Y++
       STU    ,Y++
       CMPY   #$A000+8000
       BNE    BDEC3     ->

       LDY    #$C000
BDEC4  STA    <BANKC
       LDX    ,Y
       LDU    2,Y
       STB    <BANKC
       STX    ,Y++
       STU    ,Y++
       CMPY   #$C000+8000
       BNE    BDEC4     ->

       LDB    $E7E4     visualiser la
       ANDB   #$3F      page 0
       ORB    TOUR
       STB    $E7DD

       LDA    BKMANO
       LDB    BKVID
       STA    BKVID
       STB    BKMANO
       RTS


*=======================================
* S/P ecriture sur fichier
*
* Entrée: A  car. à ecrire
* Sortie: CY 0 si ok
*            1 si erreur (fichier sera
*                         fermé et détr.
*=======================================

ECRFIC PSHS   B
       LEAS   -2,S
SCRMEM SET    0
ERRMEM SET    1
*---------------------------------------
       LDB    #PRINT
       JSR    EXTRA
       TSTB
       BNE    ECFIR     erreur ->
       ANDCC  #$FE
       LEAS   2,S
       PULS   B,PC      ->>

ECFIR  STB    ERRMEM,S

       LDA    #DBKPIL   restaure $9000
       STA    BANKC
       LDX    #$9000
       LDY    #$A000
BRESF4 LDD    ,Y++
       STD    ,X++
       CMPX   #$A000
       BNE    BRESF4    ->

       LDB    #CLOSE    # erreur PRINT
       JSR    EXTRA
       LDB    #KILL     détruire
       JSR    EXTRA

       JSR    SELDEF
       LDB    ERRMEM,S
       JSR    DOSERR
       ORCC   #$1
       LEAS   2,S
       PULS   B,PC      ->>


*=======================================
* S/P lecture sur le fichier courant
*
* Sortie: A  car. lu si ok
*         CY 0 si ok
*            1 si pb -> erreur traitée
*                       fichier fermé
*=======================================

LECFIC PSHS   B
*---------------------------------------
       LDB    #INPUT
       JSR    EXTRA
       TSTB
       BNE    LEFIFR    erreur ->
       LDB    #78       'bad picture'
       TST    EOFFLG    si eof !
       BNE    LEFIFR    ->
       LDA    CARCOU
       ANDCC  #$FE
       PULS   B,PC      ->>

LEFIFR JSR    SELDEF
       JSR    DOSERR
       LDB    #CLOSE
       JSR    EXTRA
       ORCC   #1
       PULS   B,PC      ->>


*=======================================
* S/P chargement d'une photo
*     Cette derniere est supposé au
*     format MAP avec optionnellement la
*     palette derrière la map si issu d
*     TO-SNAP !
*
* Entrée:  NUMPHO no photo sélectionnée
*          FILNAM nom fichier
*          A  0 non existance fichier
*               = erreur
*            #0 accepter
* Sortie:  CY 0 ok
*             1 erreur
* *ATTENTION* un FENFER de 2 niveaux
*             est exécuté si ok !
*             et si A = 0
*=======================================

LECPHO PSHS   D,X,Y
       LEAS   -4,S
MEMBK  SET    0
MEMLG  SET    1
MEMMOD SET    3
PA     SET    4
PB     SET    5
PX     SET    6
*---------------------------------------

* Une photo codée peut dépasser dans
* certains cas les 16k !!! pour garder
* la compatibilité de format on accèpte
* cette bizarerie et on procède :
*  -lecture du fichier sur les deux
*   bank 4k sur DBKPIL puis BKMANO
*  -sauvegarde de la zone $9000-$9FFF
*   vers le bank DBKPIL qui ne doit pas
*   être actif. (en $D000)
*  -copie des 4k de DBKPIL vers $9000
*  -décodage photo
*  -restauration zone $9000-9FFF
*  -codage photo vers bank

       LDA    #SQI      ouverture fich
       STA    FILMOD

       LDB    #OPEN
       JSR    EXTRA
       TSTB
       BEQ    LFVAY     ->
       TST    PA,S
       BEQ    LFPBB     ->
       CMPB   #62
       LBEQ   FINALR    ->
LFPBB  LDA    SCRMOD
       STA    BUF
       JSR    SELDEF
       JSR    DOSERR
       LDA    SCRMOD
       JSR    ACTMOD
       LBRA   FINALR    erreur ->

*      récupérer la longueur du bloc

LFVAY  JSR    LECFIC
       LBCS   FINALR    ->
       TSTA
       LBNE   FINARR    non 0 en tete ->
       JSR    LECFIC    lire longueur
       LBCS   FINALR    ->
       TFR    A,B
       JSR    LECFIC
       LBCS   FINALR    ->
       EXG    A,B
       CMPD   #0
       LBEQ   FINARR    vide       ->
       CMPD   #$4FFE
       LBGT   FINARR    trop grand ->
       STD    MEMLG,S

       JSR    LECFIC    passer adr bidon
       LBCS   FINALR    ->
       JSR    LECFIC
       LBCS   FINALR    ->

*      Chargement des 4k debut en $A000
*      du bank DBKPIL

       LDA    #DBKPIL
       STA    BANKC
       LDD    MEMLG,S
       TFR    D,Y
       SUBD   #$1000
       BPL    C4K1      ->
       LDU    #0        reste
       BRA    C4K2      ->
C4K1   TFR    D,U       reste !
       LDY    #$1000
C4K2   LDX    #$A000
       JSR    LECFIC    type écran
       LBCS   FINALR    ->
       STA    MEMMOD,S

BCA1   STA    ,X+
       LEAY   -1,Y
       BEQ    FINAL4    fini ->
       JSR    LECFIC
       LBCS   FINALR    ->
       BRA    BCA1      ->

FINAL4 TFR    U,Y
       CMPY   #0
       BEQ    FINALC    ->

       LDA    BKMANO    lecture du reste
       STA    BANKC
       LDX    #$A000
       BRA    BCA3      ->

BCA2   STA    ,X+
       LEAY   -1,Y
       LBEQ   FINALC    fini ->
BCA3   JSR    LECFIC
       LBCS   FINALR    ->
       BRA    BCA2      ->

*      fin de lecture ok

FINALC LDB    #CLOSE
       JSR    EXTRA

       LDA    #DBKPIL
       STA    BANKC
       LDB    #8        nom
       LDA    NUMPHO
       MUL
       LDX    #TABNOM
       LEAX   B,X
       LDY    #FILNAM
       LDB    #8
BNOMME LDA    ,Y+
       STA    ,X+
       DECB
       BNE    BNOMME    ->

* Visualisation

       TST    PA,S
       BNE    LFPA1     ->
       LDB    #2
       JSR    FENFER

LFPA1  JSR    SELDEF
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

       LDA    #DBKPIL   sauve $9000...
       STA    BANKC
       LDX    #$9000
       LDY    #$D000
BSOVF1 LDD    ,X++
       STD    ,Y++
       CMPX   #$A000
       BNE    BSOVF1    ->
       LDX    #$9000    ajoute debut pho
       LDY    #$A000
BNEWF1 LDD    ,Y++
       STD    ,X++
       CMPX   #$A000
       BNE    BNEWF1    ->
       LDA    BKMANO
       STA    BANKC

*      Prise en compte descripteur
*      Si abscence (cas d'un .MAP std)
*      on utilise la palette défaut,
*      le mode MAP et le tour courant
*      Nb: le mode MAP (1er octet format
*          compacté peut être identique
*          pour plusieurs formats...)
*
*      Format d'un descripteur
*          octet  0..1  : mode hard
*          octet  2..3  : couleur tour
*          octet  4..5  : mode basic
*          octets 6..37 : palette
*          octets 38-39 : $A55A

       LDB    #16
       LDX    #PALDEF   palette défaut
       LDY    #PALETE
PALDF1 LDU    ,X++
       STU    ,Y++
       DECB
       BNE    PALDF1    ->

       LDY    MEMLG,S   test si descript
       LEAY   $9000,Y
       LEAY   -2,Y

       LDD    ,Y
       CMPD   #$A55A
       BNE    FINALK    ->

       LEAY   -37,Y
       LDA    ,Y++      mode hard
       STA    MEMMOD,S
       LDA    ,Y++
       STA    TOUR
       LEAY   1,Y
       LDB    #16
       LDX    #PALETE
BLPAL  LDU    ,Y++
       STU    ,X++
       DECB
       BNE    BLPAL     ->

*  fixation mode vidéo après régen.

FINALK LDA    #DBKPIL
       STA    BANKC
       LDX    #$9000
       LDY    #$D000
BRESF2 LDD    ,Y++
       STD    ,X++
       CMPX   #$A000
       BNE    BRESF2    ->

       LDA    MEMMOD,S
       JSR    ACTMOD

       LDX    #$9000    ajoute debut pho
       LDY    #$A000
BNEWF2 LDD    ,Y++
       STD    ,X++
       CMPX   #$A000
       BNE    BNEWF2    ->
       LDA    BKMANO
       STA    BANKC

*      Décodage image

       DECA
       STA    DEBZON+2
       LDD    #$9000
       STD    DEBZON
       LDB    #$FF
       STB    PUTFLG
       CLR    WITH
       LDA    #1
       STA    X0COD
       CLR    Y0COD
       LDB    #CODE
       JSR    EXTRA
       COM    WITH

*  -restauration zone $9000-9FFF

       LDA    #DBKPIL
       STA    BANKC
       LDX    #$9000
       LDY    #$D000
BRESF1 LDD    ,Y++
       STD    ,X++
       CMPX   #$A000
       BNE    BRESF1    ->

* Enregistrement photo

       JSR    CODPHO

       ANDCC  #$FE
       LEAS   4,S
       PULS   D,X,Y,PC  ->>

FINARR JSR    SELDEF
       LDB    #78       'bad picture'
       JSR    DOSERR

FNARR0 LDB    #CLOSE
       JSR    EXTRA

FINALR ORCC   #1
       LEAS   4,S
       PULS   D,X,Y,PC


*=======================================
* S/P recherche 1ére photo libre
*
* Sortie:  Cy  0 ok
*          Cy  1 plus de place
*=======================================

PHOCH  PSHS   D,X
       LEAS   -2,S
NBPHO  SET    0
SCRMEM SET    1
*---------------------------------------
       LDA    MAXPHO
       INCA
       STA    NBPHO,S
       LDX    #TABBK
       LDA    NUMPHO
       LDA    A,X
       STA    BANKC
       BRA    BOUCS1    ->
BOUCS0 JSR    PHOSUI
BOUCS1 LDA    NUMPHO
       LDX    #TABPHO
       TST    A,X
       BEQ    BOUCS2    ->
       DEC    NBPHO,S
       BNE    BOUCS0    ->
       JSR    SELDEF
       LDX    #MPLEIN
       JSR    FENERR
       ORCC   #$01
       LEAS   2,S
       PULS   D,X,PC    ->>
BOUCS2 ANDCC  #$FE
       LEAS   2,S
       PULS   D,X,PC    ->>


*=======================================
* S/P sélection du mode défaut pour
*     dialogue (TO7 palette standard)
*=======================================

DEFSEL PSHS   D,X,Y,U
       LEAS   -1,S
ACTF   SET    0
*---------------------------------------
       CLR    ACTF,S
       BRA    SELFFF    ->

SELDEF PSHS   D,X,Y,U
       LEAS   -1,S
*---------------------------------------
       JSR    FENDES
       STA    ACTF,S

SELFFF LDA    #$00      mode
       STA    SCRMOD

       LDA    #$00      gate
       STA    >$E7DC

*      palette

       LDA    #$FF
       LDX    #PALDEF
       JSR    SETP

*      Tour

       CLR    $E7E4
       LDB    $E7E4
       ORB    #GRIS
       STB    $E7DD

*      Extra. mon.

       LDA    #NOIR
       STA    COULGR
       LDB    #CHOIX
       JSR    EXTRA

*      Fenêtre

       LDD    #319
       STD    XR

       TST    ACTF,S
       BPL    FSDEF      ->
       JSR    FENACT
FSDEF  LEAS   1,S
       PULS   D,X,Y,U,PC ->>


*=======================================
* S/P sélection du mode vidéo bit map 4
*=======================================

SELM4  EQU    *
*---------------------------------------
       LDA    #$01      mode
       STA    SCRMOD

       LDA    #$21      gate
       STA    >$E7DC

*      Fenêtre

       LDD    #319
       STD    XR

       RTS


*=======================================
* S/P sélection du mode vidéo TO7-70
*=======================================

SELTO7 EQU    *
*---------------------------------------
       LDA    #$00      mode
       STA    SCRMOD

       LDA    #$00      gate
       STA    >$E7DC

*      Fenêtre

       LDD    #319
       STD    XR

       RTS


*=======================================
* S/P sélection du mode vidéo overlay
*=======================================

SELOVL EQU    *
*---------------------------------------
       LDA    #$08      mode
       STA    SCRMOD

       LDA    #$26      gate
       STA    >$E7DC

*      Fenêtre

       LDD    #319
       STD    XR

       RTS


*=======================================
* S/P sélection du mode vidéo page 2
*=======================================

SELPG2 EQU    *
*---------------------------------------
       LDA    #$04      mode
       STA    SCRMOD

       LDA    #$25      gate
       STA    >$E7DC

*      Fenêtre

       LDD    #319
       STD    XR

       RTS


*=======================================
* S/P sélection du mode vidéo page 1
*=======================================

SELPG1 EQU    *
*---------------------------------------
       LDA    #$02      mode
       STA    SCRMOD

       LDA    #$24      gate
       STA    >$E7DC

*      Fenêtre

       LDD    #319
       STD    XR

       RTS


*=======================================
* S/P sélection du mode vidéo 80 colonne
*=======================================

SEL80C EQU    *
*---------------------------------------
       LDA    #$80      mode
       STA    SCRMOD

       LDA    #$2A      gate
       STA    >$E7DC

*      Fenêtre

       LDD    #639
       STD    XR

       RTS


*=======================================
* S/P sélection du mode vidéo bit map 16
*=======================================

SELM16 EQU    *
*---------------------------------------
       LDA    #$40      mode
       STA    SCRMOD

       LDA    #$7B      gate
       STA    >$E7DC

*      Fenêtre

       LDD    #159
       STD    XR

       RTS


*=======================================
* S/P sélection du mode vidéo triple ovl
*=======================================

SELTOV EQU    *
*---------------------------------------
       LDA    #$20      mode
       STA    SCRMOD

       LDA    #$3F      gate
       STA    >$E7DC

*      Fenêtre

       LDD    #159
       STD    XR

       RTS


*=======================================
* S/P sélection du bon mode vidéo
*=======================================

SELMOD PSHS   A,X
*---------------------------------------
       LDA    NUMPHO
       LDX    #TABPHO
       TST    A,X
       BNE    SBM0      ->
       LBSR   SELDEF
       PULS   A,X,PC    ->>
SBM0   LDX    #TABMOD
       LDA    A,X
       BSR    ACTMOD
       PULS   A,X,PC    ->>

ACTMOD PSHS   D,X,Y,U
       LEAS   -1,S
ACTF   SET    0
PA     SET    1
*---------------------------------------
       JSR    FENDES
       STA    ACTF,S

       LDA    PA,S
       LSLA
       BCC    SBM1      ->
       LBSR   SEL80C
       BRA    SBMF      ->
SBM1   LSLA
       BCC    SBM2      ->
       LBSR   SELM16
       BRA    SBMF      ->
SBM2   LSLA
       BCC    SBM3      ->
       LBSR   SELTOV
       BRA    SBMF      ->
SBM3   LSLA
       LSLA
       BCC    SBM4      ->
       LBSR   SELOVL
       BRA    SBMF      ->
SBM4   LSLA
       BCC    SBM5      ->
       LBSR   SELPG2
       BRA    SBMF      ->
SBM5   LSLA
       BCC    SBM6      ->
       LBSR   SELPG1
       BRA    SBMF      ->
SBM6   LSLA
       BCC    SBM7      ->
       LBSR   SELM4
       BRA    SBMF      ->

SBM7   LBSR   SELTO7

*      palette

SBMF   LDA    #$FF
       LDX    #PALETE
       JSR    SETP

*      Tour

       CLR    $E7E4
       LDB    $E7E4
       ORB    TOUR
       STB    $E7DD

*      Extra. mon.

       LDA    #NOIR
       STA    COULGR
       LDB    #CHOIX
       JSR    EXTRA

       TST    ACTF,S
       BPL    FSTMF      ->
       JSR    FENACT
FSTMF  LEAS   1,S
       PULS   D,X,Y,U,PC ->>


*=======================================
* S/P calcul du No de photo suivant
*     et positionnement bank
*=======================================

PHOSUI PSHS   A
*---------------------------------------
       LDA    NUMPHO
       INCA
       CMPA   MAXPHO
       BLE    BOUCS9    ->
       CLRA
BOUCS9 STA    NUMPHO
       LDX    #TABBK
       LDA    A,X
       STA    BANKC
       PULS   A,PC      ->>


*=======================================
* S/P calcul du No de photo précédent
*=======================================

PHOPRE PSHS   A
*---------------------------------------
       LDA    NUMPHO
       DECA
       BGE    BOUCS8    ->
       LDA    MAXPHO
BOUCS8 STA    NUMPHO
       LDX    #TABBK
       LDA    A,X
       STA    BANKC
       PULS   A,PC      ->>
