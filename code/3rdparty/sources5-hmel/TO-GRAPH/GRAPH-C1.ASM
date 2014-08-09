       TITLE  TO-GRAPH: S/P CARTOUCHE
*      ------------------------------
       PAGE

****************************************
*                                      *
*           TO-GRAPH                   *
*                                      *
*    S/P cartouche                     *
*                                      *
****************************************


*=======================================
* S/P recherche d'un album dans table
*         (création si inexistant)
* Entrée: X   pt nom album
* Sortie: CY  1  pas de place
*             0  ok
*         X   pt dans table si ok
*=======================================

XCHALB PSHS   D,Y,U
       LEAS   -1,S
ALBC   SET    0
PD     SET    1
*---------------------------------------

       LBSR   XPTALB
       BCC    CHALBF    trouvé ->

       TST    MAXALB
       BEQ    CHALBR    pas de place ->
       LDU    #TABALB
       CLR    ALBC,S
CHAL1  TST    8,U
       BMI    CHAVID    poste vide ->
       INC    ALBC,S
       LDA    ALBC,S
       CMPA   MAXALB
       BGE    CHALBR    pas de place ->
       LEAU   9,U
       BRA    CHAL1     ->

CHAVID LDA    #8
CHAVI0 LDB    ,X+
       STB    ,U+
       DECA
       BNE    CHAVI0    ->
       NEG    ,U        marque occupé
       LEAX   -8,U
       INC    NBALB
CHALBF ANDCC  #$FE
       LEAS   1,S
       PULS   D,Y,U,PC   ->>
CHALBR LDB    #7        'out of memory'
       JSR    DOSERR
       ORCC   #$01
       LEAS   1,S
       PULS   D,Y,U,PC   ->>


*=======================================
* S/P saisie d'un album
*
* Entrée: A,B coordonnées fenêtre
*         X   Pt  recepteur nom
* Sortie: CY  1  Raz
*             0  ok
*        (X)  zone nom rendu
*=======================================

FCZIAL FCB    FLOCF,0,0,11,26
       FCB    FTRAME,FTOURI
       FCB    FLOCF,1,1,5,24
       FCB    FFOND,FTOURE,FCADRE
       FCB    FLOCF,7,1,3,24
       FCB    FFOND,FTOURE,FCADRE
       FCB    FLOCF,2,3,1,24
       FCB    FEDI
       FCC    \Nomdel'album:\
       FCB    0
       FCB    FLOCF,4,16,1,8
       FCB    FTOURE
       FCB    FCZI,255,TEXTE

       FCB    FLOCF,8,3,1,24
       FCB    FEDI
       FCC    \OK\
       FCB    BALISE
       FCC    \Annuler\
       FCB    BALISE,0
       FCB    FLOCF,8,6,1,1
       FCB    FPOUSS,RC,OFF
       FCB    FLOCF,8,22,1,1
       FCB    FPOUSS,FF,OFF
       FCB    FSTOP

*---------------------------------------
XCZIAL PSHS   D,X,Y,U
       LEAS   -9,S
BUF1   SET    0
PD     SET    9
PX     SET    11
*---------------------------------------

       LEAX   FCZIAL,PCR
       JSR    FENOUV

       JSR    FENACT    sélection
CZIAL1 JSR    FEN
       TSTB
       BEQ    CZIAL1    ->
       CMPB   #FF
       BEQ    CZIALR    raz ->
       CMPB   #RC
       BEQ    CZIALO    RC  ->
       BRA    CZIAL1    ->

CZIALO LDX    PX,S      résultat
       LDB    #8
       LDA    #SP
CZIAO0 STA    ,X+
       DECB
       BNE    CZIAO0    ->
       LEAX   BUF1,S
       LDB    #255
       JSR    FENLCZ
       LEAX   BUF1,S
       LDY    PX,S
CZIAO1 LDA    ,X+
       BEQ    CZIAO2    ->
       STA    ,Y+
       BRA    CZIAO1    ->

CZIAO2 CLRB
       JSR    FENFER
       JSR    FENACT
       ANDCC  #$FE
       LEAS   9,S
       PULS   D,X,Y,U,PC ->>
CZIALR CLRB
       JSR    FENFER
       JSR    FENACT
       ORCC   #$01
       LEAS   9,S
       PULS   D,X,Y,U,PC ->>


*=======================================
* S/P raz d'une rectangulaire au point
*
* Entrée: XT0,YT0 coord. début
*         XT1,YT1 coord. fin
*=======================================

XCLRTI LDA    #$FF
       STA    FILFLG
       LDD    #PLEIN
       STD    MACP
       LDU    #TRRAZ
       LBSR   COMBK1
       LDX    <XT0
       STX    XXXXXX
       CLRA
       LDB    <YT0
       STD    YYYYYY
       LDX    <XT1
       CLRA
       LDB    <YT1
       TFR    D,Y
       LDB    #BOX
       JSR    EXTRA
       LDU    #TRNORM
       LBSR   COMBK1
       RTS


*=======================================
* S/P ecriture sur fichier
*
* Entrée: A  car. à ecrire
* Sortie: CY 0 si ok
*            1 si erreur (fichier sera
*                         fermé !)
*=======================================

XECRFI PSHS   B
*---------------------------------------
       LDB    #PRINT
       JSR    EXTRA
       TSTB
       BNE    ECFIR     erreur ->
       ANDCC  #$FE
       PULS   B,PC      ->>

ECFIR  PSHS   B
       LDB    #CLOSE    # erreur PRINT
       JSR    EXTRA
       PULS   B
       JSR    DOSERR
       ORCC   #$1
       PULS   B,PC      ->>


*=======================================
* S/P impression d'un fragment de page
*     limité par CADRNG-CADCOL
*                CADHAU-CADLAR
* Entrée  B interrupteur pleine page
*=======================================

FFCIMP FCB    FLOCF,0,0,11,24
       FCB    FTRAME,FTOURI

       FCB    FLOCF,1,1,5,22
       FCB    FFOND,FTOURE,FCADRE
       FCB    FLOCF,2,3,1,22
       FCB    FEDI
       FCC    \Impr.OK?\
       FCB    0
       FCB    FLOCR,0,6,1,7
       FCB    FTOURE,FCADRE
       FCB    FPOUSS,'I,OFF
       FCB    FLOCF,4,6,1,22
       FCB    FEDI
       FCC    \Brouillon\
       FCB    BALISE,0
       FCB    FLOCR,0,10,1,1
       FCB    FINV,'B,OFF

       FCB    FLOCF,7,1,3,22
       FCB    FFOND,FTOURE,FCADRE
       FCB    FLOCF,8,3,1,22
       FCB    FEDI
       FCC    \OK\
       FCB    BALISE
       FCC    \Annuler\
       FCB    BALISE,0
       FCB    FLOCF,8,6,1,1
       FCB    FPOUSS,RC,OFF
       FCB    FLOCF,8,20,1,1
       FCB    FPOUSS,FF,OFF
       FCB    FSTOP

MTYPIP FCC    \THOMSON\
       FCB    0
       FCC    \EPSON\
       FCB    0
       FCC    \IBM\
       FDB    0

TYPIMP FCB    THOMSO  type imprimante
THOMSO EQU    0
EPSON  EQU    1
IBM    EQU    2
MAXIMP EQU    3

*---------------------------------------
XIMPPA PSHS   B
       LEAS   -963,S
FLGPAS SET    0
MEMBK  SET    1
DBK    SET    2
BUFFER SET    3
PB     SET    963
*---------------------------------------
       LDA    BANKC
       STA    MEMBK,S

       LDD    #$0633
       LEAX   FFCIMP,PCR
       JSR    FENOUV

IMPC00 LDB    #'I
       JSR    FENCH
       LEAX   TYPIMP,PCR
       LDA    ,X
       LDB    #8
       MUL
       LEAX   MTYPIP,PCR
       LEAX   D,X

       JSR    FENFON
       JSR    FENEDI

* Sélection opérateur

IMPC0  JSR    FENACT    sélection
IMPC1  JSR    FEN
       TSTB
       BEQ    IMPC1     ->
       CMPB   #FF
       LBEQ   IMPCRZ    raz ->
       CMPB   #RC
       BEQ    IMPCOK    RC  ->
       CMPB   #'I
       BEQ    CHGIMP    Imprim. ->
       BRA    IMPC1     ->

CHGIMP JSR    FENDES
       LEAX   TYPIMP,PCR
       LDA    ,X
       INCA
       CMPA   #MAXIMP
       BNE    CHGIM0    ->
       CLRA
CHGIM0 LDB    $E7E6     autorise écritur
       ORB    #$40      cartouche
       STB    $E7E6
       STA    ,X
       LDB    $E7E6     interdit écritur
       ANDB   #$BF      cartouche
       STB    $E7E6
       LBRA   IMPC00    ->

IMPCOK JSR    FENDES
       JSR    FENCH
       JSR    FENIVD
       LDB    #'B
       JSR    FENCH
       CLR    FLGPAS,S
       LDA    VAL,X
       CMPA   #OFF
       BNE    LIMPC    ->
       COM    FLGPAS,S

LIMPC  LDA    #$40     open //
       STA    RSOPC
       JSR    RSCO
       LBCS   IMPCRZ    ->

       LDA    #$08     écriture //
       STA    RSOPC

       LEAX   TYPIMP,PCR
       LDA    ,X
       CMPA   #IBM
       BEQ    SETIP0   ->
       LDB    #ESC     reset imprimante
       JSR    RSCO
       LDB    #'@
       JSR    RSCO

SETIP0 CMPA   #THOMSO
       BNE    SETIP1   ->
*                      THOMSON
       LDB    #ESC     suppress inter
       JSR    RSCO     ligne
       LDB    #$39
       JSR    RSCO
       BRA    SETIP3   ->
*                      IBM EPSON
SETIP1 LDB    #ESC     suppress inter
       JSR    RSCO     ligne
       LDB    #'3
       JSR    RSCO
       LDB    #24
       TST    FLGPAS,S
       BEQ    SETI11   ->
       DECB            double passe
SETI11 JSR    RSCO
       TST    FLGPAS,S
       BEQ    SETIP2   ->
       LDB    #ESC     unidirectionnel
       JSR    RSCO
       LDB    #'U
       JSR    RSCO
       LDB    #1
       JSR    RSCO
SETIP2 CMPA   #IBM
       BNE    SETIP3   ->
       LDB    #ESC     supprime auto LF
       JSR    RSCO
       LDB    #'5
       JSR    RSCO
       LDB    #0
       JSR    RSCO
SETIP3 EQU    *

       LDB    PB,S     passez lignes
       CMPB   #ON      en pleine page
       BNE    LIMPC0   ->

       LDA    CADRNG
       STA    <CPTLT
BIMPC0 BEQ    LIMPC0
       LDB    #LF
       JSR    RSCO

       LEAX   BUFFER,S  test d'interrupt
       LDD    #$0D39
       JSR    SBREAK
       LBCS   IMPCAB    ->

       DEC    <CPTLT
       BRA    BIMPC0   ->

* Calcul de l'adresse RAM début ligne
* initiale de la feuille (bank+déplac.)
LIMPC0 LDA    CADRNG    *60*8 !
       LSLA
       LDB    #60*4
       MUL
       ADDB   CADCOL
       ADCA   #0
       ADDD   <ADF
       BCC    LIMPC1    ->
       ADDD   #$FFFF-48959
LIMPC1 CMPD   #48960
       BCS    LIMPC2    ->
       SUBD   #48960
LIMPC2 STD    <ADPRRL
       ROLA
       ROLA
       ROLA
       ANDA   #3
       ADDA   #PBKTRA
       STA    DBK,S
       LDD    <ADPRRL
       ANDA   #$3F
       ADDD   #$A000
       STD    <ADPRRL

* Boucle de lecture de 8 lignes (1 car.)
* en page 0

BRIP0  LDA    DBK,S
       STA    BANKC
       LDA    #9
       STA    <CPTLT
       LDY    <ADPRRL
BRIP2  LEAX   BUFFER,S
       LDA    #9
       SUBA   <CPTLT
       LEAX   A,X
       DEC    <CPTLT
       LBEQ   RIP0F     -->
       LDA    BANKC
       LDB    #60
       CMPA   #PBKTRA+2
       BEQ    RIP0D     dernier bank ->
       CMPY   #$E000-59
       BCS    BRIP01    trait. 60 ok ->
       PSHS   Y         trait. en 2 fois
       LDD    #$E000
       SUBD   ,S++
       STB    <CPTCT
BRIP00 LDA    ,Y+
       STA    ,X
       LEAX   16,X
       DECB
       BNE    BRIP00    ->
       INC    BANKC
       LDY    #$A000
       LDB    #60
       SUBB   <CPTCT
BRIP01 LDA    ,Y+
       STA    ,X
       LEAX   16,X
       DECB
       BNE    BRIP01    ->
       CMPY   #$E000
       BCS    BRIP2     ->
       INC    BANKC
       LDY    #$A000
       BRA    BRIP2     ->

RIP0D  CMPY   #$DF40-59 dernier bank
       BCS    BRIP03    trait. 60 ok ->
       PSHS   Y         trait. en 2 fois
       LDD    #$DF40
       SUBD   ,S++
       STB    <CPTCT
BRIP02 LDA    ,Y+
       STA    ,X
       LEAX   16,X
       DECB
       BNE    BRIP02    ->
       DEC    BANKC
       DEC    BANKC
       LDY    #$A000
       LDB    #60
       SUBB   <CPTCT
BRIP03 LDA    ,Y+
       STA    ,X
       LEAX   16,X
       DECB
       BNE    BRIP03    ->
       CMPY   #$DF40
       LBCS   BRIP2     ->
       DEC    BANKC
       DEC    BANKC
       LDY    #$A000
       LBRA   BRIP2     ->
RIP0F  EQU    *

* Boucle de lecture de 8 lignes (1 car.)
* en page 1

       LDA    DBK,S
       ADDA   #3
       STA    BANKC
       LDA    #9
       STA    <CPTLT
       LDY    <ADPRRL
BRIP3  LEAX   BUFFER,S
       LEAX   8,X
       LDA    #9
       SUBA   <CPTLT
       LEAX   A,X
       DEC    <CPTLT
       LBEQ   RIP1F     -->
       LDA    BANKC
       LDB    #60
       CMPA   #PBKTRA+5
       BEQ    RIP1D     dernier bank ->
       CMPY   #$E000-59
       BCS    BRIP11    trait. 60 ok ->
       PSHS   Y         trait. en 2 fois
       LDD    #$E000
       SUBD   ,S++
       STB    <CPTCT
BRIP10 LDA    ,Y+
       STA    ,X
       LEAX   16,X
       DECB
       BNE    BRIP10    ->
       INC    BANKC
       LDY    #$A000
       LDB    #60
       SUBB   <CPTCT
BRIP11 LDA    ,Y+
       STA    ,X
       LEAX   16,X
       DECB
       BNE    BRIP11    ->
       CMPY   #$E000
       BCS    BRIP3     ->
       INC    BANKC
       LDY    #$A000
       BRA    BRIP3     ->

RIP1D  CMPY   #$DF40-59 dernier bank
       BCS    BRIP13    trait. 60 ok ->
       PSHS   Y         trait. en 2 fois
       LDD    #$DF40
       SUBD   ,S++
       STB    <CPTCT
BRIP12 LDA    ,Y+
       STA    ,X
       LEAX   16,X
       DECB
       BNE    BRIP12    ->
       DEC    BANKC
       DEC    BANKC
       LDY    #$A000
       LDB    #60
       SUBB   <CPTCT
BRIP13 LDA    ,Y+
       STA    ,X
       LEAX   16,X
       DECB
       BNE    BRIP13    ->
       CMPY   #$DF40
       LBCS   BRIP3     ->
       DEC    BANKC
       DEC    BANKC
       LDY    #$A000
       LBRA   BRIP3     ->

RIP1F  STY    <ADPRRL
       LDA    BANKC
       SUBA   #3
       STA    DBK,S

*      Edition ligne graphique

       LEAX   BUFFER,S
       LDB    CADLAR
       LDA    FLGPAS,S
       LBSR   XIMPLI

       LEAX   BUFFER,S  test d'interrupt
       LDD    #$0D39
       JSR    SBREAK
       BCS    IMPCAB    ->

       DEC    CADHAU
       LBNE   BRIP0     ->

IMPCAB LDB    #ESC     reset imprimante
       JSR    RSCO
       LDB    #'@
       LEAX   TYPIMP,PCR
       LDA    ,X
       CMPA   #IBM
       BNE    RSTIP    ->
       LDB    #'2
RSTIP  JSR    RSCO
       CMPA   #THOMSO
       BEQ    RSTIP1   ->
       LDB    #ESC     bidirectionnel
       JSR    RSCO
       LDB    #'U
       JSR    RSCO
       LDB    #0
       JSR    RSCO

RSTIP1 LDA    #$10     close
       STA    RSOPC
       JSR    RSCO

IMPCRZ LDA    MEMBK,S
       STA    BANKC
       LEAS   963,S
       CLRB
       JSR    FENFER
       PULS   B,PC


*=======================================
* S/P impression d'une ligne graphique
*
* Entrée X  pt buffer
*           8 seg. 1er  car
*           8 seg. 2eme car
*           ...
*        A  0 en simple passage
*          #0 en double passage
*        B  nb car.
*=======================================

XIMPLI PSHS   D,X,Y,U
       LEAS   -10,S
BUFV   SET    0
NBSEG  SET    8
PA     SET    10
PB     SET    11
PX     SET    12
*---------------------------------------
       STB    CPTLT

*      Codage buffer en colonnes
BIMPL0 LEAY   BUFV,S    raz mano
       LDA    #8
BIMPL1 CLR    ,Y+
       DECA
       BNE    BIMPL1    ->

       LDA    #8        colonnes car.
       STA    CPTCT     cour. -> mano
BIMPL2 LDA    #8
       LEAY   BUFV,S
       LDB    ,X+
BIMPL3 LSLB
       ROR    ,Y+
       DECA
       BNE    BIMPL3    ->
       DEC    CPTCT
       BNE    BIMPL2    ->

       LEAX   -8,X      buffer recodé
       LEAY   BUFV,S
       LDA    #8
BIMPL4 LDB    ,Y+
       STB    ,X+
       DECA
       BNE    BIMPL4    ->

       DEC    CPTLT
       BNE    BIMPL0    car. suiv ->

*      Calcul et codage ASCII nb segment
*      en soustrayant les nuls de droite
       LDB    PB,S
       LDA    #8
       MUL
       LDX    PX,S
       LEAX   D,X
LIMPK0 TST    ,-X
       BNE    LIMPK1    ->
       SUBD   #1
       BNE    LIMPK0    ->
LIMPK1 ADDD   #1        force pair
       ANDB   #$FE
       STD    NBSEG,S
       LBEQ   LIMPL3    rien ->

       LEAX   BUFV,S
       LDY    #3
       JSR    BINDCD
       LDA    #3
       LEAX   BUFV,S
BIMPL5 LDB    ,X+
       CMPB   #$20
       BNE    LIMPL0    ->
       ADDB   #$10
       STB    -1,X
       DECA
       BNE    BIMPL5    ->


LIMPL0 LDB    #ESC      édition graphiq.
       JSR    RSCO

       LEAY   TYPIMP,PCR
       LDA    ,Y
       CMPA   #THOMSO
       BNE    SETGR0    ->
       LDB    #$47
       LDA    PA,S
       BEQ    LIMPL1    ->
       ADDB   #2
LIMPL1 JSR    RSCO

       LEAX   BUFV,S
       LDA    #3
BIMPL6 LDB    ,X+
       JSR    RSCO
       DECA
       BNE    BIMPL6    ->
       BRA    SETGR1    ->

SETGR0 LDB    #'L
       JSR    RSCO
       LDD    NBSEG,S
       JSR    RSCO
       TFR    A,B
       JSR    RSCO

SETGR1 EQU    *

       LDX    PX,S
       LDY    NBSEG,S

       LEAU   TYPIMP,PCR
       LDA    ,U
       CMPA   #THOMSO
       BNE    SELIP0    ->
       LDA    PA,S
       LBNE   BIMPLA    normal THOMSON->
       BRA    BIMPL9    brouillon ... ->
SELIP0 LDA    PA,S
       BNE    XIMPL8    normal IBM EPS->

BIMPL7 LDA    ,X+       brouillon IBM EP
       LDB    #1
SIMPL7 LSRA
       ROLB
       BCC    SIMPL7    ->
       JSR    RSCO
       LEAY   -1,Y
       BNE    BIMPL7    ->
       LBRA   LIMPL3    ->

XIMPL8 PSHS   X,Y
BIMPL8 LDA    ,X+       normal IBM EPSON
       LDB    #1        passe 1
SIMPL8 LSRA
       ROLB
       BCC    SIMPL8    ->
       JSR    RSCO
       LEAY   -1,Y
       BNE    BIMPL8    ->
       PULS   X,Y
       LDB    #ESC      passe 1/216 "
       JSR    RSCO      (pour 1/2 point)
       LDB    #'J       (1 pt = 1/72 ")
       JSR    RSCO
       LDB    #1
       JSR    RSCO
       LDB    #RC
       JSR    RSCO
       LDB    #ESC
       JSR    RSCO
       LDB    #'L
       JSR    RSCO
       LDD    NBSEG,S
       JSR    RSCO
       TFR    A,B
       JSR    RSCO
BIMPH8 LDA    ,X+       normal IBM EPSON
       LDB    #1        passe 2
SIMPH8 LSRA
       ROLB
       BCC    SIMPH8    ->
       JSR    RSCO
       LEAY   -1,Y
       BNE    BIMPH8    ->
       LBRA   LIMPL3    ->

BIMPL9 LDB    ,X+       brouillon THOMSO
       JSR    RSCO
       LEAY   -1,Y
       BNE    BIMPL9    ->
       LBRA   LIMPL3    ->

BIMPLA LDA    ,X+       double/1er  oct.
       CLRB
       LSRA
       RORB
       LSRB
       LSRA
       RORB
       LSRB
       LSRA
       RORB
       LSRB
       LSRA
       RORB
       STB    BUFV,S
       LSRB
       ORB    BUFV,S
       JSR    RSCO
*                       double/1er  oct.
       CLRB
       LSRA
       RORB
       LSRB
       LSRA
       RORB
       LSRB
       LSRA
       RORB
       LSRB
       LSRA
       RORB
       STB    BUFV,S
       LSRB
       ORB    BUFV,S
       JSR    RSCO
       LEAY   -1,Y
       BNE    BIMPLA    ->

LIMPL3 LDB    #LF       lig. suiv
       JSR    RSCO

       LEAS   10,S
       PULS   D,X,Y,U,PC


*=======================================
* S/P lecture sur le fichier courant
*
* Sortie: A  car. lu si ok
*         CY 0 si ok
*            1 si pb -> erreur traitée
*                       fichier fermé
*=======================================

XLECFI PSHS   B
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

LEFIFR JSR    DOSERR
       LDB    #CLOSE
       JSR    EXTRA
       ORCC   #1
       PULS   B,PC


*=======================================
* S/P lecture écran -> tiroir
*
* Entrée XT0,YT0   coord. début
*        XT1,YT1   coord. fin
*=======================================

TMAQG2 FDB    $FF7F,$3F1F,$0F07,$0301
TMAQD2 FDB    $80C0,$E0F0,$F8FC,$FEFF

XLITTI EQU    *
*---------------------------------------
       LDA    #1        note tiroir ok
       STA    <FLGTIR

*      calcul des dimensions points
       LDD    <XT1
       SUBD   <XT0
       ADDD   #1
       STD    <LPTTIR
       LDA    <YT1
       SUBA   <YT0
       INCA
       STA    <HPTTIR

*      calcul des dimensions segment
*      Nb: le tiroir est augmenté de 1
*          en largeur à cause décalages
*          ultérieurs
       LDD    <XT0
       LSRA
       RORB
       LSRA
       RORB
       LSRB
       STB    <COLT0
       LDD    <XT1
       LSRA
       RORB
       LSRA
       RORB
       LSRB
       INCB             +1 sur largeur
       STB    <COLT1
       SUBB   <COLT0
       INCB
       STB    <LARTIR
       LDD    <XT0
       ANDB   #$07
       STB    <DECTIR   décal. bit/seg.

*      calcul des référence 1er segment
*      (page écran et adresse
       LDA    $E7C3
       ANDA   #$FE
       LDB    <COLT0
       LSRB
       BCS    XDCC2     ->
       ORA    #$01
XDCC2  STA    <PRE7C3
       LDA    <YT0
       LDB    #40
       MUL
       ADDD   #$4000
       STD    <ADPRSG
       CLRA
       LDB    <COLT0
       LSRB
       ADDD   <ADPRSG
       STD    <ADPRSG

*      calcul des nb de seg. sur page
*      du 1er et sur l'autre
       LDA    <LARTIR
       LSRA
       STA    <NBSEG1
       STA    <NBSEG2
       BCC    XDCC3     ->
       INC    <NBSEG1

*      acquisition des seg. 1ère page
XDCC3  LDA    <PRE7C3
       STA    $E7C3
       LDA    <HPTTIR
       STA    <CPTLT
       LDU    <ADPRSG
       STU    <ADPRSL
       LDX    #ZONTRA
       TFR    X,Y       Y=ad 1ère lign
XDCC10 LDA    <NBSEG1
XDCC11 LDB    ,U+
       STB    ,X++
       DECA
       BNE    XDCC11    ->
       TFR    Y,X
       LDB    <LARTIR
       ABX
       TFR    X,Y
       LDU    <ADPRSL
       LEAU   40,U
       STU    <ADPRSL
       DEC    <CPTLT
       BNE    XDCC10    ->

*      acquisition des seg. 2ème page
       LDA    $E7C3
       EORA   #$01
       STA    $E7C3
       LDA    <HPTTIR
       STA    <CPTLT
       CLRA
       LDB    <PRE7C3
       ANDB   #1
       EORB   #1
       ADDD   <ADPRSG
       STD    <ADPRSL
       TFR    D,U
       LDX    #ZONTRA+1
       TFR    X,Y       Y=ad 1ère lign
XDCC20 LDA    <NBSEG2
XDCC21 LDB    ,U+
       STB    ,X++
       DECA
       BNE    XDCC21    ->
       TFR    Y,X
       LDB    <LARTIR
       ABX
       TFR    X,Y
       LDU    <ADPRSL
       LEAU   40,U
       STU    <ADPRSL
       DEC    <CPTLT
       BNE    XDCC20    ->

*      mise à zéro des bits hors tiroir
*      à gauche
       LEAX   TMAQG2,PCR
       LDA    <DECTIR
       BEQ    RZDT      ->
       LDA    A,X
       STA    <CPTCT
       LDA    <HPTTIR
       LDX    #ZONTRA
BRGT   LDB    ,X
       ANDB   <CPTCT
       STB    ,X
       LDB    <LARTIR
       ABX
       DECA
       BNE    BRGT      ->

*      mise à zéro des bits hors tiroir
*      à droite
RZDT   LDD    <XT1
       ANDB   #7
       CMPB   #7
       BEQ    RZDD      ->
       LEAX   TMAQD2,PCR
       LDA    B,X
       STA    <CPTCT
       LDA    <HPTTIR
       LDX    #ZONTRA
       LDB    <LARTIR
       ABX
       LEAX   -2,X
BRDT   LDB    ,X
       ANDB   <CPTCT
       STB    ,X
       LDB    <LARTIR
       ABX
       DECA
       BNE    BRDT      ->

*      mise à zéro du segment supplé-
*      mentaire pour décalage
RZDD   LDA    <HPTTIR
       LDX    #ZONTRA
       LDB    <LARTIR
       ABX
       LEAX   -1,X
BRDD   CLR    ,X
       LDB    <LARTIR
       ABX
       DECA
       BNE    BRDD      ->
       RTS


*=======================================
* S/P Lecture d'un bit sur le tiroir
*
* Entrée: X     coord. dans tiroir
*         CPTLT
* Sortie: Z   bit nul ou non
*=======================================

TEXTBL FDB    $8040,$2010,$0804,$0201

XLECTX PSHS   X
PX     SET    0
*---------------------------------------
       LDU    #$A000
       LDA    <CPTLT
       LDB    <LARTIR
       MUL
       LEAU   D,U
       TFR    X,D
       LSRA
       RORB
       LSRA
       RORB
       LSRB
       LDB    D,U
       LDA    PX+1,S
       ANDA   #7
       LEAX   TEXTBL,PCR
       ANDB   A,X
       PULS   X,PC


*=======================================
* S/P pointage d'un album dans table
*
* Entrée: X   pt nom album
* Sortie: CY  1  pas trouvé
*             0  ok
*         X   pt dans table si ok
*             non modifié sinon
*=======================================

XPTALB PSHS   D,X,Y,U
       LEAS   -1,S
ALBC   SET    0
PD     SET    1
PX     SET    3
*---------------------------------------

       TST    MAXALB
       BEQ    PTALER    ->

       LDU    #TABALB
       CLR    ALBC,S
PTAL1  TST    8,U
       BMI    PTAVID    poste vide ->
       LDX    PX,S
       TFR    U,Y
       LDA    #8
PTAL2  LDB    ,X+
       CMPB   ,Y+
       BNE    PTAL3     différent ->
       DECA
       BNE    PTAL2     ->
       BRA    PTALOK    trouvé ->
PTAL3  INC    ALBC,S
       LDA    ALBC,S
       CMPA   MAXALB
       BGE    PTALER    fini ->
PTAVID LEAU   9,U
       BRA    PTAL1     ->

PTALOK STU    PX,S
       ANDCC  #$FE
       LEAS   1,S
       PULS   D,X,Y,U,PC ->>
PTALER ORCC   #$01
       LEAS   1,S
       PULS   D,X,Y,U,PC ->>


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

FFELAL FCB    FLOCF,0,0,13,44
       FCB    FTRAME,FTOURI
       FCB    FCOMF,FF,OFF
       FCB    FLOCF,1,1,1,42
       FCB    FFOND,FTOURE,FCADRE
       FCB    FLOCF,1,15,1,42
       FCB    FEDI,ESC,$4E
       FCC    \ALBUMS\
       FCB    ESC,$4C,0
       FCB    FLOCF,3,1,9,42
       FCB    FFOND,FTOURE,FCADRE

       FCB    FLOCF,4,3,1,8
       FCB    FPOUSS,200,INTERD
       FCB    FLOCF,4,13,1,8
       FCB    FPOUSS,201,INTERD
       FCB    FLOCF,4,23,1,8
       FCB    FPOUSS,202,INTERD
       FCB    FLOCF,4,33,1,8
       FCB    FPOUSS,203,INTERD

       FCB    FLOCF,6,3,1,8
       FCB    FPOUSS,204,INTERD
       FCB    FLOCF,6,13,1,8
       FCB    FPOUSS,205,INTERD
       FCB    FLOCF,6,23,1,8
       FCB    FPOUSS,206,INTERD
       FCB    FLOCF,6,33,1,8
       FCB    FPOUSS,207,INTERD

       FCB    FLOCF,8,3,1,8
       FCB    FPOUSS,208,INTERD
       FCB    FLOCF,8,13,1,8
       FCB    FPOUSS,209,INTERD
       FCB    FLOCF,8,23,1,8
       FCB    FPOUSS,210,INTERD
       FCB    FLOCF,8,33,1,8
       FCB    FPOUSS,211,INTERD

       FCB    FLOCF,10,3,1,8
       FCB    FPOUSS,212,INTERD
       FCB    FLOCF,10,13,1,8
       FCB    FPOUSS,213,INTERD
       FCB    FLOCF,10,23,1,8
       FCB    FPOUSS,214,INTERD
       FCB    FLOCF,10,33,1,8
       FCB    FPOUSS,215,INTERD
       FCB    FSTOP

MPASAL FCC    \PASD'ALBUM\
       FCB    0

*---------------------------------------
XSELAL PSHS   D,X,Y,U
       LEAS   -2,S
ALBC   SET    0
ALBOK  SET    1
PD     SET    2
PX     SET    4
PYL    SET    7
*---------------------------------------

       TST    NBALB
       BNE    SELAL0    ->
       LEAX   MPASAL,PCR
       JSR    FENERR
       LBRA   SELALF    ->
SELAL0 LEAX   FFELAL,PCR
       LDD    PD,S
       JSR    FENOUV

       CLR    ALBC,S    visu albums
       CLR    ALBOK,S
       LDU    #TABALB
SELAL1 TST    8,U
       BMI    ALVID     ->
       LDB    ALBOK,S   poste occupé
       ADDB   #200
       JSR    FENCH
       TST    PX,S
       BEQ    SELALV    visu seule ->
       LDA    #OFF
       STA    VAL,X
SELALV LDA    #8
SELAL2 LDB    ,U+
       JSR    FENPUT
       DECA
       BNE    SELAL2    ->
       LEAU   1,U
       INC    ALBOK,S
SELAL3 INC    ALBC,S
       LDA    ALBC,S
       CMPA   #16
       BGE    SELAL4    fini ->
       BRA    SELAL1    ->
ALVID  LEAU   9,U
       BRA    SELAL3    ->

SELAL4 JSR    FENACT    sélection
SELAL5 JSR    FEN
       TSTB
       BEQ    SELAL5    ->
       CMPB   #FF
       BEQ    SELALR    raz ->
       TST    PX,S
       BEQ    SELAL5    visu seule ->
       SUBB   #200
       BMI    SELAL5    ->
       CMPB   ALBOK,S
       BGE    SELAL5    ->

*      Album sélectionné
       INCB
       LDX    #TABALB
SELAL6 TST    8,X
       BMI    SELAL7    ->
       DECB
       BEQ    FSELAL    pointé ->
SELAL7 LEAX   9,X
       BRA    SELAL6    ->

FSELAL STX    PX,S
       LDB    PYL,S
       BMI    SELALZ    dépile par appel
       JSR    FENFER               .lant
       JSR    FENACT
SELALZ ANDCC  #$FE
       LEAS   2,S
       PULS   D,X,Y,U,PC ->>
SELALR CLRB
       JSR    FENFER
       JSR    FENACT
SELALF ORCC   #$01
       LEAS   2,S
       PULS   D,X,Y,U,PC ->>


*=======================================
* S/P visualisation du tiroir
*
* Entrée: X   coord. graphique haut
*         Y   gauche
*         A   #0 si effacement préalable
*=======================================

XVISTI PSHS   D,X,Y,U
PA     SET    0
PB     SET    1
PX     SET    2
PY     SET    4
*---------------------------------------

*      calculer coord. de visualisation
       LDD    PX,S
       STD    <XT0
       ADDD   <LPTTIR
       SUBD   #1
       STD    <XT1

       LDD    PY,S
       STD    <YT0
       CLRA
       LDB    <HPTTIR
       ADDD   <YT0
       SUBD   #1
       STD    <YT1

*      décaler le tiroir pour corresp.
*      colonnes
       LDD    <XT0
       ANDB   #7
       LBSR   XDECAL

*      calcul de la zone visualisée
       LDD    <XT0
       ASRA
       RORB
       ASRA
       RORB
       ASRA
       RORB
       STB    <COLT0
       CLR    <DECSEG
       CMPB   #4
       BGE    XPCL10    ->
       LDA    #4
       SUBA   <COLT0
       STA    <DECSEG
       LDA    #4
       STA    <COLT0
       LDD    #32
       STD    <XT0

XPCL10 CLR    <DECLIG
       LDD    <YT0
       CMPD   #8
       BGE    XPCL11    ->
       LDD    #8
       SUBD   <YT0
       STB    <DECLIG
       LDD    #8
       STD    <YT0
XPCL11 LDA    <YT0+1
       STA    <YT0      valeur 8..191

       LDD    <XT1
       ASRA
       RORB
       ASRA
       RORB
       ASRA
       RORB
       STB    <COLT1
       CMPB   #77
       BLE    XPCL12    ->
       LDB    #77
       STB    <COLT1
       LDD    #623
       STD    <XT1

XPCL12 LDD    <YT1
       CMPD   #191
       BLE    XPCL13    ->
       LDD    #191
       STD    <YT1
XPCL13 LDA    <YT1+1    valeur 8..191
       STA    <YT1

       LDA    <COLT1
       SUBA   <COLT0
       INCA
       STA    <LARTV
       LDA    <YT1
       SUBA   <YT0
       INCA
       STA    <HAUTV

*      calcul des référence 1er segment
*      (page écran et adresse
       LDA    $E7C3
       ANDA   #$FE
       LDB    <COLT0
       LSRB
       BCS    XPCC2     ->
       ORA    #$01
XPCC2  STA    <PRE7C3
       LDA    <YT0
       LDB    #40
       MUL
       ADDD   #$4000
       STD    <ADPRSG
       CLRA
       LDB    <COLT0
       LSRB
       ADDD   <ADPRSG
       STD    <ADPRSG

*      calcul des nb de seg. sur page
*      du 1er et sur l'autre
       LDA    <LARTV
       LSRA
       STA    <NBSEG1
       STA    <NBSEG2
       BCC    XPCC3     ->
       INC    <NBSEG1

*      si demandé... effacer
XPCC3  TST    PA,S
       BEQ    XPCC4     ->
       LBSR   XCLRTI

*      superposition des seg. 1ère page
XPCC4  LDA    <PRE7C3
       STA    $E7C3
       LDA    <HAUTV
       STA    <CPTLT
       LDU    <ADPRSG
       STU    <ADPRSL
       LDY    #ZONTRA   Y=ad 1ére ligne
       LDA    <LARTIR
       LDB    <DECLIG
       MUL
       LEAY   D,Y
XPCC10 LDA    <DECSEG
       LEAX   A,Y
       LDA    <NBSEG1
XPCC11 LDB    ,U
       ORB    ,X++
       STB    ,U+
       DECA
       BNE    XPCC11    ->
       LDB    <LARTIR
       LEAY   B,Y
       LDU    <ADPRSL
       LEAU   40,U
       STU    <ADPRSL
       DEC    <CPTLT
       BNE    XPCC10    ->

*      superposition des seg. 2ème page
       LDA    $E7C3
       EORA   #$01
       STA    $E7C3
       LDA    <HAUTV
       STA    <CPTLT
       CLRA
       LDB    <PRE7C3
       ANDB   #1
       EORB   #1
       ADDD   <ADPRSG
       STD    <ADPRSL
       TFR    D,U
       LDY    #ZONTRA+1 Y=ad 1ére ligne
       LDA    <LARTIR
       LDB    <DECLIG
       MUL
       LEAY   D,Y
XPCC20 LDA    <DECSEG
       LEAX   A,Y
       LDA    <NBSEG2
XPCC21 LDB    ,U
       ORB    ,X++
       STB    ,U+
       DECA
       BNE    XPCC21    ->
       LDB    <LARTIR
       LEAY   B,Y
       LDU    <ADPRSL
       LEAU   40,U
       STU    <ADPRSL
       DEC    <CPTLT
       BNE    XPCC20    ->

       PULS   D,X,Y,U,PC ->>
