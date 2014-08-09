       TITLE  TO-GRAPH: Gestion feuille
*      --------------------------------
       PAGE

****************************************
*                                      *
*           TO-GRAPH                   *
*                                      *
*    Gestion feuille                   *
*                                      *
****************************************


*=======================================
* S/P chargement du bank d'un album
*
* Entrée:  X  pt entrée de la table
*             des albums
* Sortie:  CY 0 ok
*             1 erreur
*=======================================

CHAALB PSHS   D,X,Y
       LEAS   -1,S
MEMBK  SET    0
PD     SET    1
PX     SET    3
*---------------------------------------

       LDA    BANKC
       STA    MEMBK,S

       LDA    #SQI      ouverture fich
       STA    FILMOD

       LDY    #FILNAM
       LDB    #8
BCA0   LDA    ,X+
       STA    ,Y+
       DECB
       BNE    BCA0      ->
       LDD    #$414C
       STD    ,Y++
       LDA    #$42
       STA    ,Y

       LDB    #OPEN
       JSR    EXTRA
       TSTB
       BNE    FINALR    erreur ->
       LDA    ,X
       STA    BANKC

*      récupérer la longueur du bloc

       JSR    LECFIC
       BCS    FINALR    ->
       TSTA
       BNE    FINARR    non 0 en tete ->
       JSR    LECFIC    lire longueur
       BCS    FINALR    ->
       TFR    A,B
       JSR    LECFIC
       BCS    FINALR    ->
       EXG    A,B
       CMPD   #0
       BEQ    FINARR    vide       ->
       CMPD   #$3FFE
       BGT    FINARR    trop grand ->
       STD    $A000
       TFR    D,Y

       JSR    LECFIC    passer adr bidon
       BCS    FINALR    ->
       JSR    LECFIC
       BCS    FINALR    ->

*      Chargement

       LDX    #$A002
       JSR    LECFIC    type écran
       BCS    FINALR    ->
       CMPA   #$80
       BNE    FINARR    # 80 col. ->

BCA1   STA    ,X+
       LEAY   -1,Y
       BEQ    FINALC    fini ->
       JSR    LECFIC
       BCS    FINALR    ->
       BRA    BCA1      ->

FINALC LDB    #CLOSE
       JSR    EXTRA
       LDA    MEMBK,S
       STA    BANKC
       ANDCC  #$FE
       LEAS   1,S
       PULS   D,X,Y,PC

FINARR LDB    #78       'bad picture'
       JSR    DOSERR
       LDB    #CLOSE
       JSR    EXTRA
FINALR LDA    MEMBK,S
       STA    BANKC
       LDX    PX,S      album libre
       NEG    8,X
       ORCC   #1
       LEAS   1,S
       PULS   D,X,Y,PC


*=======================================
* S/P codage d'un dessin
*
* Entrée:  B  0   simple calcul de long.
*             #0  écriture fichier
* Sortie:  CY 0   si ok
*             1   si erreur
*          D      longueur
*=======================================

CODDES PSHS   D
       LEAS   -267,S
LGFIC  SET    0
TYPDES SET    2
LARDES SET    3
HAUDES SET    4
MEMBK  SET    5
PBK    SET    6
TYPBLK SET    7       00: différents
*                     FF: répétition
LGBLK  SET    8       lg bloc
RPTBLK SET    9       bloc en répet
PAGEC  SET    10
BUFCOD SET    11
PD     SET    267
PA     SET    267
PB     SET    268
*---------------------------------------
       LDA    BANKC
       STA    MEMBK,S

* Calcul de l'adresse RAM début ligne
* initiale de la feuille (bank+déplac.)
       LDA    CADRNG    *60*8 !
       LSLA
       LDB    #60*4
       MUL
       ADDB   CADCOL
       ADCA   #0
       ADDD   <ADF
       BCC    CODE10    ->
       ADDD   #$FFFF-48959
CODE10 CMPD   #48960
       BCS    CODE11    ->
       SUBD   #48960
CODE11 STD    <ADPRRL
       ROLA
       ROLA
       ROLA
       ANDA   #3
       ADDA   #PBKTRA
       STA    PBK,S
       LDD    <ADPRRL
       ANDA   #$3F
       ADDD   #$A000
       STD    <ADPRRL

* Init. codage
       CLR    LGBLK,S   => lecture !
       CLR    PAGEC,S   page 0
       LDY    <ADPRRL
       LDA    PBK,S
       STA    BANKC
       LDA    CADHAU
       STA    HAUDES,S
       LDA    CADLAR
       STA    LARDES,S
       CLRA
       STA    LGFIC,S
       STA    LGFIC+1,S

* Boucle de lecture .. Y= ad. RAM
*                      X= ad. buffer blk
*                      U= cpt colonne
BCODS0 LDA    HAUDES,S  # boucle colonne
       LDB    #8
       MUL
       TFR    D,U
BCODS1 TST    LGBLK,S   # boucle lignes
       BNE    CODS10
       INC    LGBLK,S   1er octet bloc
       LEAX   BUFCOD,S
       LDA    ,Y
       STA    RPTBLK,S
       STA    ,X+
       LBRA   CODSUI    ->

CODS10 LDA    LGBLK,S
       CMPA   #1
       BNE    CODS20    ->
       INC    LGBLK,S   2ème octet bloc
       LDA    ,Y
       STA    ,X+
       CLR    TYPBLK,S
       CMPA   RPTBLK,S
       LBNE   CODSUI    ->
       COM    TYPBLK,S
       LBRA   CODSUI    ->

CODS20 TST    TYPBLK,S  bloc en cours
       LBNE   CODS40    répet. ->
       LDA    ,Y        bloc différent!
       STA    ,X+
       CMPA   -2,X
       BEQ    CODS30    2 car. ident ->
       INC    LGBLK,S
       LDA    LGBLK,S
       CMPA   #255
       LBNE   CODSUI    ->
       LDX    LGFIC,S   bloc diff plein
       LDB    LGBLK,S
       ADDB   #2
       ABX
       STX    LGFIC,S
       TST    PB,S
       BEQ    CODS25    ->
       CLRA             écrire bloc diff
       JSR    ECRFIC    ->
       LBCS   CODSF
       LDA    LGBLK,S
       JSR    ECRFIC
       LBCS   CODSF     ->
       LEAX   BUFCOD,S
       LDB    LGBLK,S
CODS21 LDA    ,X+
       JSR    ECRFIC
       LBCS   CODSF     ->
       DECB
       BNE    CODS21    ->
CODS25 CLR    LGBLK,S
       LBRA   CODSUI    ->
CODS30 DEC    LGBLK,S   bloc diff. fini
       LDX    LGFIC,S
       LDB    LGBLK,S
       ADDB   #2
       ABX
       STX    LGFIC,S
       TST    PB,S
       BEQ    CODS35    ->
       CLRA             écrire bloc diff
       JSR    ECRFIC
       LBCS   CODSF     ->
       LDA    LGBLK,S
       JSR    ECRFIC
       LBCS   CODSF     ->
       LEAX   BUFCOD,S
       LDB    LGBLK,S
CODS31 LDA    ,X+
       JSR    ECRFIC
       LBCS   CODSF     ->
       DECB
       BNE    CODS31    ->
CODS35 LDA    #2
       STA    LGBLK,S
       LDA    ,Y
       STA    RPTBLK,S
       LDA    #$FF
       STA    TYPBLK,S
       LBRA   CODSUI    ->

CODS40 LDA    ,Y        bloc répetition
       CMPA   RPTBLK,S
       BNE    CODS50    fin identiques>
       INC    LGBLK,S
       LDA    LGBLK,S
       CMPA   #255
       LBNE   CODSUI    ->
       LDD    LGFIC,S   bloc repet plein
       ADDD   #2
       STD    LGFIC,S
       TST    PB,S
       BEQ    CODS45    ->
       LDA    LGBLK,S   écrire bloc rpt
       JSR    ECRFIC
       LBCS   CODSF     ->
       LDA    RPTBLK,S
       JSR    ECRFIC
       LBCS   CODSF     ->
CODS45 CLR    LGBLK,S
       LBRA   CODSUI    ->
CODS50 LDD    LGFIC,S   fin bloc repet
       ADDD   #2
       STD    LGFIC,S
       TST    PB,S
       BEQ    CODS55    ->
       LDA    LGBLK,S   écrire bloc rpt
       JSR    ECRFIC
       LBCS   CODSF     ->
       LDA    RPTBLK,S
       JSR    ECRFIC
       LBCS   CODSF     ->
CODS55 LDA    #1
       STA    LGBLK,S
       LDA    ,Y
       LEAX   BUFCOD,S
       STA    ,X+
       STA    RPTBLK,S

CODSUI LEAY   60,Y
       JSR    NEXTF
       LEAU   -1,U
       CMPU   #0
       LBNE   BCODS1    ->
       COM    PAGEC,S
       BMI    CODS60
       LDA    PBK,S     -> page paire
       SUBA   #3
       STA    PBK,S
       STA    BANKC
       LDY    <ADPRRL
       LEAY   1,Y
       JSR    NEXTF
       STY    <ADPRRL
       LDA    BANKC
       STA    PBK,S
       BRA    CODS69    ->
CODS60 LDA    PBK,S
       ADDA   #3
       STA    PBK,S
       STA    BANKC
       LDY    <ADPRRL
CODS69 DEC    LARDES,S
       LBNE   BCODS0    ->

       TST    LGBLK,S   dernier bloc ?
       LBEQ   CODS80    ->
       TST    TYPBLK,S
       BEQ    CODS70    ->
       LDD    LGFIC,S
       ADDD   #2
       STD    LGFIC,S
       TST    PB,S
       LBEQ   CODS80    ->
       LDA    LGBLK,S   écrire bloc rpt
       JSR    ECRFIC
       LBCS   CODSF     ->
       LDA    RPTBLK,S
       JSR    ECRFIC
       LBCS   CODSF     ->
       BRA    CODS80    ->

CODS70 LDX    LGFIC,S
       LDB    LGBLK,S
       ADDB   #2
       ABX
       STX    LGFIC,S
       TST    PB,S
       BEQ    CODS80    ->
       CLRA             écrire bloc diff
       JSR    ECRFIC
       LBCS   CODSF     ->
       LDA    LGBLK,S
       JSR    ECRFIC
       LBCS   CODSF     ->
       LEAX   BUFCOD,S
       LDB    LGBLK,S
CODS71 LDA    ,X+
       JSR    ECRFIC
       LBCS   CODSF     ->
       DECB
       BNE    CODS71    ->

CODS80 LDD    LGFIC,S
       STD    PD,S
       ANDCC  #$FE
       BRA    CODSEX    fini ->

CODSF  ORCC   #1
CODSEX LDA    MEMBK,S
       STA    BANKC
       LEAS   267,S
       PULS   D,PC      ->>


*=======================================
* S/P saisie d'un album
*
* Entrée: A,B coordonnées fenêtre
*         X   Pt  recepteur nom
* Sortie: CY  1  Raz
*             0  ok
*        (X)  zone nom rendu
*=======================================

CZIALB PSHS   U
       LDU    #XCZIAL
       JSR    COMBK2
       PULS   U,PC


*=======================================
* S/P ecriture d'un fichier .ALB à
*     partir d'un album
*
* Entrée:  X pt sur album dans table
*=======================================

ECRALB PSHS   D,X,Y
       LEAS   -1,S
MEMBK  SET    0
*---------------------------------------
       LDY    #FILNAM   nom défaut
       LDA    #8
ECAL0  LDB    ,X+
       STB    ,Y+
       DECA
       BNE    ECAL0     ->
       LDD    #$414C
       STD    ,Y++
       LDA    #$42
       STA    ,Y+

       LDA    ,X
       STA    MEMBK,S

       LDX    #MCOMAL
       LDA    #8
ECAL00 LDB    ,X+
       STB    ,Y+
       DECA
       BNE    ECAL00    ->

       LDD    #$FD22    confirmer nom
       LBSR   FENLOF
       LDA    #BKMANO
       STA    BANKC
       LDX    #ZONTRA
       LDY    #LGZTRA
       LDU    #MVFICH
       LBSR   DOSCZI
       LBEQ   ECALFF    RAZ    ->
       LBCS   ECALFF    erreur ->

       LDD    #$0312    vérifier non
       LBSR   FENLOF    existence
       JSR    DOSTST
       BCS    ECALFF    existe ->

       LDB    MEMBK,S   album->bank ram
       LDA    BANKC
       STA    MEMBK,S
       STB    BANKC

       LDA    #SQO      #ouverture
       STA    FILMOD
       LDA    #2
       STA    FILTYP    type
       CLR    ASCFLG    binaire
       LDB    #OPEN
       JSR    EXTRA
       TSTB
       BNE    ECALO     erreur ->

       CLRA             #en tete bloc
       JSR    ECRFIC
       BCS    ECALF     ->
       LDA    $A000     longueur!
       JSR    ECRFIC
       BCS    ECALF     ->
       LDA    $A001
       JSR    ECRFIC
       BCS    ECALF     ->
       CLRA
       JSR    ECRFIC
       BCS    ECALF     ->
       JSR    ECRFIC
       BCS    ECALF     ->

       LDX    #$A002    #données
       LDY    $A000
ECAL1  LDA    ,X+
       JSR    ECRFIC
       BCS    ECALF     erreur ->
       LEAY   -1,Y
       BNE    ECAL1     ->

       LDA    #$FF      #bloc fin
       JSR    ECRFIC
       BCS    ECALF     ->
       CLRA
       LDB    #4
BECBFI JSR    ECRFIC
       BCS    ECALF     ->
       DECB
       BNE    BECBFI    ->

       LDB    #CLOSE    # fin normale
       JSR    EXTRA
       BRA    ECALF     ->
ECALO  JSR    DOSERR    # erreur OPEN
ECALF  LDA    MEMBK,S
       STA    BANKC
ECALFF LEAS   1,S
       PULS   D,X,Y,PC


*=======================================
* S/P ecriture d'un dessin limite par
*     SPCADR sur fichier
*=======================================

ECRDES PSHS   D,X,Y
       LEAS   -1,S
MEMBK  SET    0
*---------------------------------------
       LDA    BANKC
       STA    MEMBK,S

       LDY    #FILNAM   nom défaut
       LDX    #DESCOU
BECDE0 LDA    ,X+
       STA    ,Y+
       CMPY   #FILNAM+8
       BNE    BECDE0    ->
       LDD    #$4D41    '.MAP'
       STD    ,Y++
       LDA    #$50
       STA    ,Y+

       LDX    #MCOMAL
       LDA    #8
BECDE1 LDB    ,X+
       STB    ,Y+
       DECA
       BNE    BECDE1    ->

       LDD    #$0313    saisir nom fic.
       LBSR   FENLOF
       LDA    #BKMANO
       STA    BANKC
       LDX    #ZONTRA
       LDY    #LGZTRA
       LDU    #MVFICH
       LBSR   DOSCZI
       LBEQ   ECDEF     RAZ    ->
       LBCS   ECDEF     erreur ->

       LDD    #$0919    vérifier non
       LBSR   FENLOF    existence
       JSR    DOSTST
       LBCS   ECDEF     existe ->

       LDA    #SQO      #ouverture
       STA    FILMOD
       LDA    #2
       STA    FILTYP    type
       CLR    ASCFLG    binaire
       LDB    #OPEN
       JSR    EXTRA
       TSTB
       BNE    ECDEO     erreur ->

       CLRA             #en tete bloc
       JSR    ECRFIC
       BCS    ECDEF     ->

       CLRB
       JSR    CODDES    calcul lgth
       ADDD   #3        (type+larg+haut)
       ADDD   #4        (4 fois 0 en fin
       JSR    ECRFIC
       BCS    ECDEF     ->
       TFR    B,A
       JSR    ECRFIC
       BCS    ECDEF     ->
       CLRA
       JSR    ECRFIC
       BCS    ECDEF     ->
       JSR    ECRFIC
       BCS    ECDEF     ->

       LDA    #$80      80 colonnes
       JSR    ECRFIC
       BCS    ECDEF     ->

       LDA    CADLAR    largeur - 1
       DECA
       JSR    ECRFIC
       BCS    ECDEF     ->

       LDA    CADHAU    hauteur - 1
       DECA
       JSR    ECRFIC
       BCS    ECDEF     ->

       LDB    #1
       JSR    CODDES
       BCS    ECDEF     ->

       LDB    #4        fin image
       CLRA
BECFI0 JSR    ECRFIC
       BCS    ECDEF     ->
       DECB
       BNE    BECFI0    ->

       LDA    #$FF      #bloc fin
       JSR    ECRFIC
       BCS    ECDEF     ->
       CLRA
       LDB    #4
BECDFI JSR    ECRFIC
       BCS    ECDEF     ->
       DECB
       BNE    BECDFI    ->

       LDB    #CLOSE    # fin normale
       JSR    EXTRA
       BRA    ECDEF     ->
ECDEO  JSR    DOSERR    # erreur OPEN
ECDEF  LDA    MEMBK,S
       STA    BANKC
       LEAS   1,S
       PULS   D,X,Y,PC


*=======================================
* S/P copie d'une page écran vers la
*     zone correspondante de la feuille
*
* Entrée: B  0    page paire
*            1    page impaire
*         RGDECR  emplacement écran
*         CLDECR  dans la feuille
*=======================================

ECRFEU PSHS   U
       LDU    #XECRFE
       JSR    COMBK2
       PULS   U,PC


*=======================================
* S/P ecriture sur fichier
*
* Entrée: A  car. à ecrire
* Sortie: CY 0 si ok
*            1 si erreur (fichier sera
*                         fermé !)
*=======================================

ECRFIC PSHS   U
       LDU    #XECRFI
       JSR    COMBK2
       PULS   U,PC


*=======================================
* S/P copie vers une page écran de la
*     zone correspondante de la feuille
*
* Entrée: B  0    page paire
*            1    page impaire
*         RGDECR  emplacement écran
*         CLDECR  dans la feuille
*=======================================

FEUECR PSHS   U
       LDU    #XFEUEC
       JSR    COMBK2
       PULS   U,PC


*=======================================
* S/P chargement initial des albums
*     présents sur la disquette de char.
*     gement
*     (fichiers $xxxxxxx.ALB)
*=======================================

MCALB  FCC    \Chargementalbum:\
       FCB    0
*---------------------------------------
INIALB PSHS   D,X,Y,U
       LEAS   -2,S
FLGDIR SET    0
ALBC   SET    1
*---------------------------------------

*      calcul du maxima possible
       LDA    MAXBK
       DECA             ->nb bank disp.
       SUBA   #11
       LDB    #16       maxima!
       STB    MAXALB
       TSTA
       BGT    BRF000    ->
       CLR    MAXALB
       LBRA   FINIAL    ->
BRF000 CMPA   #16
       BGE    BRF00     ->
       STA    MAXALB

BRF00  LDA    MAXALB
       STA    ALBC,S

*      chargement table des albums
       CLR    NBALB
       CLR    FLGDIR,S
       LDX    #TABALB   raz tous postes
       LDA    #PBKALB
       NEGA
       LDB    #16       max !!!
BRF0   STA    8,X
       DECA
       CLR    ,X
       LEAX   9,X
       DECB
       BNE    BRF0      ->

       LDX    #FILNAM   filtre
       LDB    #$24       $xxxxxxx.ALB
       STB    ,X+
BRF1   CLR    ,X+
       CMPX   #FILNAM+8
       BNE    BRF1      ->
       LDD    #$414C
       STD    ,X++
       LDA    #$42
       STA    ,X

       LDX    #TABALB
BRF2   LDB    #DIR0
       ADDB   FLGDIR,S
       JSR    EXTRA
       TSTB
       BNE    FINIAL    erreur ->
       TST    NAMSEC
       BEQ    FINICN    fin ->
       LDY    NAMSLT
       LDA    #8
BRF3   LDB    ,Y+
       STB    ,X+
       DECA
       BNE    BRF3      ->
       LEAX   1,X
       LDA    #1
       STA    FLGDIR,S
       DEC    ALBC,S
       BNE    BRF2      suite charg ->

*      Chargement des albums sélectionné
FINICN LDA    ALBC,S
       CMPA   MAXALB
       BEQ    FINIAL    ->
       CLR    ALBC,S
       LDU    #TABALB

BRF4   LDD    #$0A18
       LDX    #ZONTRA
       LDY    #LGZTRA
       JSR    SBREAK
       LBCS   FINIAL    interrompu ->

       LDD    #$0401    visu chargement
       LDY    #$0120    courant
       JSR    FENLOF
       LEAX   MCALB,PCR
       JSR    FENEDI

       TST    ,U
       BEQ    INIVID    ->
       LDA    #8        poste à charger
       TFR    U,X
BRF5   LDB    ,X+
       JSR    FENPUT
       DECA
       BNE    BRF5      ->

       TFR    U,X
       NEG    8,U       si erreur sera
*                       inv. par CHAALB
       JSR    CHAALB    chargement->bank
       BCS    FINIAL    erreur ->
       STX    ALBCOU

       INC    NBALB
INIVID LEAU   9,U
       INC    ALBC,S
       LDA    ALBC,S
       CMPA   #16
       BNE    BRF4      suite ->

FINIAL LEAS   2,S
       PULS   D,X,Y,U,PC


*=======================================
* S/P recherche d'un album dans table
*         (création si inexistant)
* Entrée: X   pt nom album
* Sortie: CY  1  pas de place
*             0  ok
*         X   pt dans table si ok
*=======================================

CHALB  PSHS   U
       LDU    #XCHALB
       JSR    COMBK2
       PULS   U,PC


*=======================================
* S/P lecture d'un dessin sur fichier
*     en la position courante
*
* Sortie:  B 0   si ok
*          B #0  si erreur
*=======================================

MERDB  FCC    \CADRAGEINSUFFISANT\
       FCB    0

LECDES LEAS   -11,S
LGFIC  SET    0
TYPDES SET    2
LARDES SET    3
HAUDES SET    4
MEMBK  SET    5
PBK    SET    6
TYPBLK SET    7       00: différents
*                     FF: répétition
LGBLK  SET    8       lg bloc
RPTBLK SET    9       bloc en répet
PAGEC  SET    10
*---------------------------------------
       LDA    BANKC
       STA    MEMBK,S

       LDB    #SQI
       STB    FILMOD
       LDB    #OPEN
       JSR    EXTRA
       TSTB
       BEQ    LEDE0     ->
       JSR    DOSERR
       LBRA   LEDEF     ->

LEDE0  JSR    LECFIC    lecture en tete
       LBCS   LEDEF     ->
       TSTA
       LBNE   LEDER     ->
       JSR    LECFIC    lecture lg zone
       LBCS   LEDEF     ->
       STA    LGFIC,S
       JSR    LECFIC
       LBCS   LEDEF     ->
       STA    LGFIC+1,S
       JSR    LECFIC    passer 2
       LBCS   LEDEF     ->
       JSR    LECFIC
       LBCS   LEDEF     ->
       JSR    LECFIC    lire type image
       LBCS   LEDEF     ->
       TSTA
       BEQ    LEDE1     ->
       CMPA   #$80
       BEQ    LEDE1     ->
       LBRA   LEDER     ->

LEDE1  STA    TYPDES,S
       JSR    LECFIC    lire largeur
       LBCS   LEDEF     ->
       INCA
       STA    LARDES,S
       JSR    LECFIC    lire hauteur
       LBCS   LEDEF     ->
       INCA
       STA    HAUDES,S
       ADDA   RGDECR
       CMPA   #103
       LBCC   LEDED     debord ->
       LDA    CLDECR
       LSLA
       ADDA   LARDES,S
       CMPA   #121
       LBCC   LEDED     debord ->

* Calcul de l'adresse RAM début ligne
* initiale de la feuille (bank+déplac.)
       LDA    <RGDECR   *60*8 !
       LSLA
       LDB    #60*4
       MUL
       ADDB   <CLDECR
       ADCA   #0
       ADDD   <ADF
       BCC    LEDE10    ->
       ADDD   #$FFFF-48959
LEDE10 CMPD   #48960
       BCS    LEDE11    ->
       SUBD   #48960
LEDE11 STD    <ADPRRL
       ROLA
       ROLA
       ROLA
       ANDA   #3
       ADDA   #PBKTRA
       STA    PBK,S
       LDD    <ADPRRL
       ANDA   #$3F
       ADDD   #$A000
       STD    <ADPRRL

* Init. décodage
       CLR    LGBLK,S   => lecture !
       CLR    PAGEC,S   page 0
       LDY    <ADPRRL
       LDA    PBK,S
       STA    BANKC

* Boucle de lecture .. Y= ad. RAM
*                      U= cpt colonne
BLEDE0 LDA    HAUDES,S  # boucle colonne
       LDB    #8
       MUL
       TFR    D,U
BLEDE1 TST    LGBLK,S   # boucle lignes
       BNE    LEDE25    bloc en cours ->
       JSR    LECFIC    bloc a lire
       LBCS   LEDEF     ->
       STA    TYPBLK,S
       STA    LGBLK,S
       JSR    LECFIC
       LBCS   LEDEF     ->
       TST    TYPBLK,S
       BEQ    LEDE20    bloc diff. ->
       STA    RPTBLK,S  bloc repet
       BRA    LEDE25    ->
LEDE20 STA    LGBLK,S
LEDE25 TST    TYPBLK,S
       BEQ    LEDE26    bloc diff. ->
       LDA    RPTBLK,S  bloc repet
       BRA    LEDE27    ->
LEDE26 JSR    LECFIC
       LBCS   LEDEF     ->
LEDE27 DEC    LGBLK,S
       STA    ,Y
       LEAY   60,Y
       JSR    NEXTF
       LEAU   -1,U
       CMPU   #0
       LBNE   BLEDE1    ->

       COM    PAGEC,S
       BMI    LEDE50    ->
       LDA    PBK,S     -> page paire
       SUBA   #3
       STA    PBK,S
       STA    BANKC
       LDY    <ADPRRL
       LEAY   1,Y
       JSR    NEXTF
       STY    <ADPRRL
       LDA    BANKC
       STA    PBK,S
       BRA    LEDE59    ->
LEDE50 LDA    PBK,S     -> page impaire
       ADDA   #3
       STA    PBK,S
       STA    BANKC
       LDY    <ADPRRL
LEDE59 DEC    LARDES,S
       LBNE   BLEDE0    ->

       LDB    #CLOSE
       JSR    EXTRA
       CLRB
       BRA    LEDEF     fini ->

LEDED  LEAX   MERDB,PCR
       JSR    FENERR
       BRA    LEDEC     ->
LEDER  LDB    #78       'Bad picture'
       JSR    DOSERR
LEDEC  LDB    #CLOSE
       JSR    EXTRA
       LDB    #$FF
LEDEF  LDA    MEMBK,S
       STA    BANKC
       LEAS   11,S
       RTS


*=======================================
* S/P lecture sur le fichier courant
*
* Sortie: A  car. lu si ok
*         CY 0 si ok
*            1 si pb -> erreur traitée
*                       fichier fermé
*=======================================

LECFIC PSHS   U
       LDU    #XLECFI
       JSR    COMBK2
       PULS   U,PC


*=======================================
* S/P test bouclage sur une des pages de
*     la feuille
*
* Entrée: Y     ad. feuille
*         BANKC bank actif feuille
* Sortie: idem !
*=======================================

NEXTF  EQU    *
*---------------------------------------
       CMPY   #$DF40
       BCS    NEXTFF    ->
       LDA    BANKC
       CMPA   #PBKTRA+2
       BEQ    NEXTF0    ->
       CMPA   #PBKTRA+5
       BEQ    NEXTF0    ->
       CMPY   #$E000
       BCS    NEXTFF    ->
       LEAY   -$4000,Y
       INC    BANKC
       BRA    NEXTFF    ->
NEXTF0 LEAY   -$3F40,Y
       SUBA   #2
       STA    BANKC
NEXTFF RTS


*=======================================
* S/P pointage d'un album dans table
*
* Entrée: X   pt nom album
* Sortie: CY  1  pas trouvé
*             0  ok
*         X   pt dans table si ok
*             non modifié sinon
*=======================================

PTALB  PSHS   U
       LDU    #XPTALB
       JSR    COMBK2
       PULS   U,PC


*=======================================
* S/P raz de l'écran de travail
*=======================================

RAZE   PSHS   U
       LDU    #XRAZEC
       JSR    COMBK2
       PULS   U,PC


*=======================================
* S/P raz de la feuille de travail
*=======================================

RAZF   PSHS   U
       LDU    #XRAZFE
       JSR    COMBK2
       PULS   U,PC


*=======================================
* S/P sélection d'un album préexistant
*
* Entrée: A,B coordonnées fenêtre
*         X   =0  => visu seule
*             =-1 => sélection
*         Y   nb niv. à remonter si ok
*             (aucun si <0 )
* Sortie: CY  1  Raz ou pas d'album
*             0  ok
*         X   pt dans table si ok
*=======================================

SELALB PSHS   U
       LDU    #XSELAL
       JSR    COMBK2
       PULS   U,PC


*=======================================
* S/P visualisation de l'ascenceur bas
*=======================================

VISASB PSHS   U
       LDU    #XVISAB
       JSR    COMBK2
       PULS   U,PC


*=======================================
* S/P visualisation de l'ascenceur droit
*=======================================

VISASD PSHS   U
       LDU    #XVISAD
       JSR    COMBK2
       PULS   U,PC
