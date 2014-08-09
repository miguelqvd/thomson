       TITLE  TO-DEMO:  Programme princ.
*      ---------------------------------
       PAGE

****************************************
*                                      *
*           TO-DEMO                    *
*                                      *
*    Programme principal               *
*                                      *
* - Affichage d'un titre               *
* - Attente action clavier ou souris   *
*   pour afficher un menu en POP-UP    *
* - selon ce menu,                     *
*     Arret                            *
*     Menu de gestion fichier          *
*     Ecran de démonstration de        *
*       poussoir 'balise'              *
*       poussoir 'zone'                *
*       poussoir 'rédéfinissable'      *
*       inverseur 'balise'             *
*       inverseur 'zone'               *
*       champ de saisie numérique      *
*       champ de saisie hexa décimal   *
*                                      *
****************************************

DEBUT  EQU    *

* Initialisations
*---------------------------------------

* Pile et DP
       LDS    #PILE
       LDD    #PAGE0
       TFR    A,DP

* Copie des S/P fenêtrage vers RAM
       LDU    #FENRAM
       JSR    COMBK2

* Vérification RAM disponible
* Ici on suppose un minimum de 6 bank
*  - 1 de manoeuvre
*  - 4 pour l'empilement des fenetres
*  - 1 pour l'application

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
OKRAM  EQU    *

* Init. extra moniteur pour turbo-disq
       LDB    #RESETC
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

       LDX    #DESCOU    fichier courant
       LDD    #$2020
BRZDC  STD    ,X++
       CMPX   #DESCOU+8
       BNE    BRZDC      ->

* Mémorisation de la palette si non
* déja fait ! Ceci est un exemple de
* mémorisation de données dans la pseudo
* cartouche elle meme !
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

* Bank RAM
       LDA    #BKMANO
       STA    BANKC

* Initialisation propre à l'application!

       LDA    #GRIS
       STA    TOUR
       CLR    MODVID

       LDB    #32
       LDX    #PALDEF
       LDY    #PALETE
BPALMA LDA    ,X+
       STA    ,Y+
       DECB
       BNE    BPALMA    ->

       CLRA             palette défaut !
       COMA
       LDX    #PALDEF
       JSR    SETP

* Fenêtrage
       LDB    #$1B      mode TO7
       JSR    PUTC
       LDB    #$5A
       JSR    PUTC

       LDX    #ZONFEN
       LDA    #PBKPIL
       LDB    #DBKPIL
       TFR    D,U
       LDA    #NOIR
       LDB    #GRIS
       JSR    FENINI

* Activation Fenêtre principale
* C'est le fond de tout les empilements
* ultérieurs. Comme c'est le premier
* il ne faut évidemment pas faire
* FENOUV  qui sauvegarde avant d'affiche
*---------------------------------------

       LDX    #FENPRI
       LDD    #0
       JSR    FENRPL

* Visualisation du titre
* pendant un petit moment ...
*---------------------------------------

       LDX    #FENTIT   Titre
       LDD    #$0606
       JSR    FENOUV

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

* La fenetre que nous activons mainte
* nant n'est autre que la fenetre
* principale puisque la fenetre titre a
* ete refermee !!!

EXEC01 JSR    FENACT

* Attente principale
* d'une saisie clavier ou souris
* avec déplacement souris et utilisation
* du S/P local FENPOP a la place de
* l'appel direct à FEN pour pouvoir
* visualiser le menu suivant sous la
* tortue de pointage !!!
*---------------------------------------

EXEC1  JSR    FENPOP
       TSTB
       BEQ    EXEC2     ->
       LBRA   MENDEM    ->

EXEC2  LDA    REGCC     #Etat pointage
       TFR    A,CC
       BCC    EXEC1     pas clic ->
       LBRA   MENDEM    ->


*---------------------------------------
*      Demande de menu
*---------------------------------------

MENDEM EQU    *         demande menu

* Affichage d'un menu déroulant
* POPUP est utilise pour positionner
* le menu en fonction de sa taille
* et de la position souris !

       LDX    #FENMEN   Menu
       LDD    3,X
       JSR    POPUP
       JSR    FENOUV

* Ici on affiche dynamiquement une info
* sur la fenetre

       CLRA
       LDB    BANKC
       LDX    #BUF
       JSR    BINDCG
       LDD    #$010E
       LDY    #$0102
       JSR    FENLOF
       JSR    FENEDI

* Ici on active la gestion du menu !

MENU0  JSR    FENACT

* Ici est la boucle d'attente du menu

MENU1  JSR    FENPOP
MENU2  TSTB
       BEQ    MENU1     ->
       CMPB   #'D
       LBEQ   XDEMO     ->
       CMPB   #'G
       LBEQ   XGRIL     ->
       CMPB   #'F
       LBEQ   XFICH     ->
       CMPB   #'Q
       LBEQ   QUIPHO    ->
       CMPB   #FF
       LBNE   MENU1     ->

* Ici on décide de remonter d'un niveau
* en fermant la fenetre
* ce qui signifie: en restaurant l'ecran
* memorise !
* Dans la foulée, on réactive cette
* fenetre sans meme avoir a en connaitre
* le fonctionnement !

       CLRB
       JSR    FENFER
       JSR    FENACT
       LBRA   EXEC1     visu principale>

*   Affichage d'une fenetre de demonstra
*   tion
* Nb: le traitement qui exploite cette
*     fenetre peut organiser un retour
*     de plusieurs niveau au niveau de
*     l'affichage...
*     Le test en sortie de procedure
*     permet de synchroniser le code
*     sur la fenetre restauree
*---------------------------------------
XDEMO  EQU    *
       JSR    XXDEMO
       LBNE   EXEC1     ->
       LBRA   MENU0     ->

*   Affichage d'une fenetre de demonstra
*   tion pour une grille de saisie
*---------------------------------------
XGRIL  EQU    *
       JSR    XXGRIL
       LBRA   MENU0     ->

*   Sélection FICHIER
*---------------------------------------
XFICH  EQU    *
       JSR    MENFIC
       LBNE   EXEC1     ->
       LBRA   MENU0     ->

*   Quitter
*---------------------------------------
QUIPHO EQU    *
       LBSR   FENCH
       LBSR   FENIVD
       LDA    #BKMANO   manoeuvre
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

       CLRA             restaure palette
       COMA
       LDX    #TMEMO    (éventuellement
*                        modifiée par
       JSR    SETP       appli.)

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
