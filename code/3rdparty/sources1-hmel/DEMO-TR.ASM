       TITLE  TO-DEMO:Traitements
*      ---------------------------------
       PAGE

****************************************
*                                      *
*           Traitements                *
*                                      *
****************************************


*=======================================
* S/P fenetre de demo
*     permet de modifier la palette et
*     la couleur de tour via des
*     poussoirs 'zone'
*     De choisir un mode vidéo via un
*     poussoir 'zone' redéfini
*     (bidon !)
*     d'utiliser des poussoirs 'balise'
*     de manipuler des inverseurs
*     'zone' et 'balise'
*=======================================

XXDEMO EQU    *
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

       LDA    TOUR
       STA    MTOUR,S

       LDA    #16
       LDX    #PALETE
       LEAY   MPAL,S
LIPAI  LDU    ,X++
       STU    ,Y++
       DECA
       BNE    LIPAI     ->

       LDB    MODVID
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

* Initialisation des parametres dynami
* ques de la fenetre

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
       LDA    #ORANGE utilisé pour visu
       LDX    #0      temporaire couleur
       JSR    SETP    sélectionnée

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
       LDA    #PARME  utilisé pour visu
       LDX    #0      temporaire couleur
       JSR    SETP    tour
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
       CMPB   #'T       +Tour
       LBEQ   XIPLT     ->
       CMPB   #'U       -Tour
       LBEQ   XIMNT     ->
       CMPB   #'P       +Palette
       LBEQ   XIPLP     ->
       CMPB   #'Q       -Palette
       LBEQ   XIMNP     ->
       CMPB   #'B       +Bleu
       LBEQ   XIPLB     ->
       CMPB   #'C       -Bleu
       LBEQ   XIMNB     ->
       CMPB   #'V       +Vert
       LBEQ   XIPLV     ->
       CMPB   #'W       -Vert
       LBEQ   XIMNV     ->
       CMPB   #'R       +Rouge
       LBEQ   XIPLR     ->
       CMPB   #'S       -Rouge
       LBEQ   XIMNR     ->
       CMPB   #'M       Mode
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

       LDA    #16
       LEAX   MPAL,S
       LDY    #PALETE
ECPAI1 LDU    ,X++
       STU    ,Y++
       DECA
       BNE    ECPAI1    ->

       LDA    #PARME
       LDX    #0
       LDY    PALDEF+26
       JSR    SETP

       LDA    #ORANGE
       LDX    #0
       LDY    PALDEF+30
       JSR    SETP

       LDB    #1
       JSR    FENFER
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
* S/P fenetre de demo des possibilités
*     de saisie.
*     Défini trois champ de saisie de
*     types différents et un inverseur
*     Sur appuis d'un pouusoir, rend la
*     valeur lue dans ce champ
*     NB: les procédures de conversion
*     sont fournies pour récupérer des
*     valeurs binaires à partir des
*     chaines de texte lues.
*=======================================

XXGRIL EQU    *
*---------------------------------------

       LDX    #FENDEM
       LDD    3,X
       JSR    POPUP
       JSR    FENOUV

EXECD1 JSR    FENACT

EXECD2 JSR    FENPOP
       TSTB
       BEQ    EXECD2    ->
       CMPB   #134      visu texte
       LBEQ   XDTXT     ->
       CMPB   #135      visu hexa
       LBEQ   XDHEX     ->
       CMPB   #136      visu décim.
       LBEQ   XDDEC     ->
       CMPB   #137      visu invers
       LBEQ   XDINV     ->

       CMPB   #FF       RAZ
       LBEQ   XDRET     ->
       LBRA   EXECD2    ->

*** visu inverseur
XDINV  EQU    *
       LDB    #133      invers. à lire
       JSR    FENCH
       LDA    VAL,X
       LDX    #MON
       CMPA   #ON
       BEQ    XDAFF
       LDX    #MOFF
       BRA    XDAFF     ->

*** visu champ texte
XDTXT  EQU    *
       LDB    #130      champ à lire
       BRA    XDVIS     ->

*** visu champ hexa
XDHEX  EQU    *
       LDB    #131      champ à lire
       BRA    XDVIS     ->

*** visu champ décimal
XDDEC  EQU    *
       LDB    #132      champ à lire

*** lecture et visu des champs
XDVIS  LDX    #BUF      lecture champ
       CLR    BUF
       JSR    FENLCZ

XDAFF  PSHS   X
       JSR    FENDES    car sinon les
*      réactivation faites dans FENCH ..
*      entrainent un repositionnement
*      sur la première zone de saisie !
       LDB    #140      visu résultat
       JSR    FENCH
       JSR    FENFON    efface
       PULS   X
       JSR    FENEDI
       LBRA   EXECD1    ->

* Fin menu démo grille saisie
*---------------------------------------

XDRET  CLRB
       JSR    FENFER
       JSR    FENACT
       CLRB
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
       CMPB   #'P
       LBEQ   XFUNIT    ->
       CMPB   #'I
       LBEQ   XFINIT    ->
       CMPB   #'C
       LBEQ   XFCATA    ->
       CMPB   #'R
       LBEQ   XFRENO    ->
       CMPB   #'S
       LBEQ   XFSUPR    ->
       CMPB   #'D
       LBEQ   XFDUPL    ->
       CMPB   #'L
       LBEQ   XFLIRE    ->
       CMPB   #'E
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
       LDA    #BKMANO   manoeuvre
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
       LDA    #BKMANO   manoeuvre
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
       LDA    #BKMANO   manoeuvre
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
       LDA    #BKMANO   manoeuvre
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
       LDA    #BKMANO   manoeuvre
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
       LDA    #BKMANO   manoeuvre
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
* Ce qui suit pour que le poussoir
* soit inversé pendant une phase de
* traitement qui peut être longue

       LBSR   FENCH     Inverser pouss.
       LBSR   FENIVD

* La saisie du fichier s'opère grace
* au DOS iconique 'enveloppé' dans TO-FE
* pour pouvoir revenir au menu déroulant
* il faut ouvrir une fenêtre vide à
* laquelle sera ajoutée la fenêtre de
* saisie !!!

       LDX    #FILNAM   filtre .ASM
XLIRZ  CLR    ,X+
       CMPX   #FILNAM+8
       BNE    XLIRZ     ->
       LDA    #'A
       LDB    #'S
       STD    ,X++
       LDA    #'M
       STA    ,X+
       LDX    #FENVID   sélection
       LDD    #$0500
       LBSR   FENOUV
       LDA    #BKMANO   manoeuvre
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

* On simule ici la lecture d'un fichier
* à afficher à l'écran... pour cela, il
* faut fermer toutes les fenêtres (2 niv
* -eaux puis remonter également de deux
* niveaux pour les procédures de dialo-
* -gue.

CPNOF  LDB    #2
       JSR    FENFER

       JSR    FENACT
       LEAS   2,S
       LDB    #$FF
       RTS              ->>

XLIRZ9 CLRB
       LBSR   FENFER

* Le poussoir redevient normal

       LDB    #'L       Inverser pouss.
       LBSR   FENCH
       LBSR   FENIVD
       LBRA   EXECF1    ->

*** Ecrire fichier
XFECRI EQU    *
       JSR    FENCH
       JSR    FENIVD

       LDX    #FENVID   Sélection
       LDD    #$0505
       LBSR   FENOUV

       LDY    #FILNAM   nom défaut
       LDX    #DESCOU
       LDA    #8
ECAL0  LDB    ,X+
       STB    ,Y+
       DECA
       BNE    ECAL0     ->
       LDA    #'A
       LDB    #'S
       STD    ,Y++
       LDA    #'M
       STA    ,Y+

       LDX    #MCOMAL  commentaire
       LDA    #8
ECAL00 LDB    ,X+
       STB    ,Y+
       DECA
       BNE    ECAL00    ->

       LDA    #BKMANO
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

* Ici on simule le retour au fond pour
* pouvoir par exemple coder l'image
* avant de l'écrire !

       LDB    #2
       JSR    FENFER

       JSR    FENACT
       LEAS   2,S
       LDB    #$FF
       RTS              ->>

XFCRFF CLRB
       JSR    FENFER

XFECRF LDB    #'E
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
