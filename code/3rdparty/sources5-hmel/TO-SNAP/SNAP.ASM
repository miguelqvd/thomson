       TITLE  TO-SNAP:
*      ------------------------------
       PAGE

****************************************
*                                      *
*       Capture d'écran sur TO         *
*                                      *
****************************************
*                                      *
* Sources:                             *
*                                      *
*   FEN-EQU.ASM Equates du fenêtrage   *
*   SNAP-EQ.ASM Equates                *
*   SNAP-CN.ASM Constantes             *
*   SNAP-X1.ASM Traitement             *
*   SNAP-MN.ASM Gestion menus          *
*   SNAP-SP.ASM Gestion S/P            *
*   SNAP-PR.ASM Programme principal    *
*   SNAP   .ASM Structure              *
*                                      *
****************************************
*                                      *
* Exécutable destiné à être chargé en  *
* aplication avec le module de         *
* fenêtrage FEN.BIN                    *
*                                      *
****************************************
*                                      *
*  Carte mémoire:                      *
*                                      *
** Banks RAM cartouche                 *
*                                      *
* No 1   : Soft, constantes et données *
*          pseudo statique (motifs...) *
* No 2   : En $1800, S/P de fenêtrage  *
*          En $20, S/P de recopie des  *
*          S/P FEN vers $7800          *
*                                      *
** Banks données :                     *
*                                      *
* bank 2 : Manoeuvre                   *
* bank 3                               *
*   .. 6 : Pile des fenêtres           *
* bank 7                               *
*   ...  : Photos courante (pellicule) *
*                                      *
** RAM "en ligne"                      *
*                                      *
* $0000..$3FFF: Soft, constantes et    *
*               données pseudo stati-  *
*               ques (cartouche)       *
* $6000..$62FF: RAM moniteur/extramon  *
* $6300..$67FF: Pile (#1ko)            *
* $6800..$6FFF: RAM soft (2ko)         *
* $7000..$77FF: Zones DOS 5 dsk 2fic.  *
* $7800..$9FFF: Copie active des S/P   *
*               de fenêtrage (10ko)    *
* $A000..$DFFF: Manoeuvre              *
*                                      *
****************************************
*                                      *
* Production:                          *
*   Sous TO-PROG:                      *
*                                      *
*     - Charger SNAP.BIN (base $0000)  *
*     - Charger FEN.BIN   (base $5800) *
*     - Créer TO-SNAP.CHG à partir de  *
*       $0000..$7FFF non image mémoire *
*     - Activer ce fichier en applica- *
*       tion grace à ACT-APPL.BAS      *
*                                      *
*   Sous CR-APPLI:                     *
*                                      *
*     - Charger SNAP.BIN (base $0000)  *
*     - Charger FEN.BIN   (base $5800) *
*     - Créer TO-SNAP.CHG              *
*                                      *
****************************************


BASEF  EQU    $7800    implant. soft
*                      fenêtrage !!!

       INCLUD FEN-EQU  équates FEN

       INCLUD SNAP-EQ

****************************************

       SETDP  $E7

*
* En tête cartouche No 1
* enlever les commentaires pour TO-PROG
*---------------------------------------

*      ORG    0

*      FCC    'TO-SNAP'
*      FCB    4,0
*      FCB    0,0,0,0,0,0,0,0
*      FCB    0,0,0,0,0,0,0,0
*      FCB    $7B       soco
*      FCB    0
*      FDB    L0022
*      FDB    L0022
*L0020 FDB    $A55A

       ORG    $22

       LBRA   DEBUT     ------>


* Séquence de commutation vers les S/P
* en cartouche no 2
*---------------------------------------

COMBK2 INC    >$E7E6
       LEAU   -$4000,U
       JSR    ,U
       PSHS   CC
       DEC    >$E7E6
       PULS   CC
       RTS

* Séquence de commutation vers les S/P
* en cartouche no 1
*---------------------------------------

       DEC    >$E7E6
       JSR    ,U
       PSHS   CC
       INC    >$E7E6
       PULS   CC
       RTS

****************************************

       INCLUD SNAP-CN

       INCLUD SNAP-MN

       INCLUD SNAP-X1

       INCLUD SNAP-SP

****************************************

       INCLUD SNAP-PR

****************************************


*
* En tête cartouche No 2
* enlever les commentaires pour TO-PROG
*---------------------------------------

*      ORG    $4000
*
*      FCC    'TO-SNAP'
*      FCB    4,0
*      FCB    0,0,0,0,0,0,0,0
*      FCB    0,0,0,0,0,0,0,0
*      FCB    $7B       soco
*      FCB    0
*      FDB    L0022
*      FDB    L0022
*LL0020FDB    $A55A

       ORG    $4022

       LBRA   DEBUT     ------>


* Séquence de commutation vers les S/P
* en cartouche no 2
*---------------------------------------

       INC    >$E7E6
       LEAU   -$4000,U
       JSR    ,U
       PSHS   CC
       DEC    >$E7E6
       PULS   CC
       RTS

* Séquence de commutation vers les S/P
* en cartouche no 1
*---------------------------------------

COMBK1 DEC    >$E7E6
       JSR    ,U
       PSHS   CC
       INC    >$E7E6
       PULS   CC
       RTS

* S/P de la cartouche no 2
*---------------------------------------


*=======================================
* Auto-copie $1800..$3FFF vers $7800
* (S/P fenêtrage)
*=======================================
FENRAM EQU    *
*---------------------------------------
       LDX    #$1800
       LDY    #$7800
BCPIF1 LDD    ,X++
       STD    ,Y++
       CMPX   #$4000
       BNE    BCPIF1    ->
       RTS


*=======================================
* S/P appel du boot sur disquette ...
*     en cas d'échec, la routine monit.
*     fait un JMP [001E] ... c'est
*     pourquoi, ce vecteur est utilisé
*     pour brancher sur le traitement
*     échec !!!
* Sortie:  CY 1 si pb
*=======================================
BOOT   EQU    *
*---------------------------------------

       LDA    >$E7E6    autorise écrit
       ORA    #$40      cartouche
       STA    >$E7E6
       LDU    #PBBOOT-$4000
       STU    >$001E
       LDA    >$E7E6    interdit écrit
       ANDA   #$BF
       STA    >$E7E6

       LDA    #$01      init. ctrl dsk
       STA    DKOPC
       JSR    DKCO

       LDA    #$20      posit piste 0
       STA    DKOPC
       JSR    DKCO

       LDA    >$E7C3    moniteur bk 0
       ANDA   #$EF
       STA    >$E7C3

       LDS    #$60CC

*      une séquence d'effacement appelée
*      par le programme chargé réalise
*      une initialisation d'un zone
*      pointée par $601c à $601e... zone
*      dans laquelle peut justement se
*      trouver le programme (MGT !)
*      les valeurs mises sont celles en
*      vigueur hors extra mon !!!

       LDD    #$F001
       STD    $601C
       LDD    #$F017
       STD    $601E

       LDU    #ACTIT
       LBSR   COMBK1

       LDA    #$FF      présence disk
       STA    $6080
       LDB    #$44      commut.bank
       STB    $6081     ram pia
       STB    >$E7E7    (compatibilité)

       JMP    $E007     ->

PBBOOT LDB    #$54      commut.bank
       STB    $6081     ram E7E5
       STB    >$E7E7    (compatibilité)

       LDX    #DEBBOO-$4000
       LDY    #$A000    flag pour redem.
COPBOO LDA    ,X+
       STA    ,Y+
       CMPX   #FINBOO-$4000
       BNE    COPBOO    ->
       JSR    $A000

       LDU    #DEBUT
       LBSR   COMBK1    ->>>>>

DEBBOO DEC    >$E7E6
       LDA    >$E7E6    autorise écrit
       ORA    #$40      cartouche
       STA    >$E7E6
       LDA    #$FF
       STA    FLGBOO
       LDA    >$E7E6    interdit écrit
       ANDA   #$BF
       STA    >$E7E6
       INC    >$E7E6
       RTS
FINBOO EQU    *

       END
