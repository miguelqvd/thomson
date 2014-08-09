       TITLE  TO-GRAPH:
*      ------------------------------
       PAGE

****************************************
*                                      *
*        GESTION TO9 GRAPHIQUE         *
*                                      *
****************************************
*                                      *
* Sources:                             *
*                                      *
*   FEN-EQU .ASM Equates du fenêtrage  *
*   GRAPH-EQ.ASM Equates               *
*   GRAPH-CN.ASM Constantes            *
*   GRAPH-MN.ASM Gestion menus déroul  *
*   GRAPH-F .ASM Gestion feuille       *
*   GRAPH-X1.ASM Traitements graphiques*
*   GRAPH-X2.ASM ... outillage de base *
*   GRAPH-IP.ASM ... cadrage+impression*
*   GRAPH-PR.ASM Programme principal   *
*   GRAPH   .ASM Structure             *
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
* bank 2 : Tiroir                      *
* bank 3                               *
*   .. 6 : Pile des fenêtres           *
*          Nb: le bank 6 sert également*
*              de zone de manoeuvre    *
*               (codage décodage d'    *
*               image, remplissage,    *
*               gestion fichier ...    *
* bank 7                               *
*   .. 12: Feuille de travail          *
* bank 13                              *
*   ...  : Albums (max. 16)            *
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
* $A000..$DFFF: Tiroir                 *
*                                      *
****************************************
*                                      *
* Production:                          *
*   Sous 6809-ASM:                     *
*     - L GRAPH                        *
*     - A GRAPH/NL/NS assemblage sans  *
*                     liste            *
*   Sous CR-APPLI:                     *
*                                      *
*     - Charger GRAPH.BIN (base $0000) *
*     - Charger FEN.BIN   (base $5800) *
*     - Créer TO-GRAPH.CHG sur 2 banks *
*                                      *
****************************************


BASEF  EQU    $7800    implant. soft
*                      fenêtrage !!!

       INCLUD FEN-EQU  équates FEN

       INCLUD GRAPH-EQ

       SETDP  MANTIR/256

*************** bank 1 *****************

       ORG    $22

* Auto-copie $1800..$3FFF vers $7800
* (S/P fenêtrage)
*---------------------------------------

L0022  INC    $E7E6     en fait sur BK2!
       LDX    #$1800
       LDY    #$7800
BCPIF1 LDD    ,X++
       STD    ,Y++
       CMPX   #$4000
       BNE    BCPIF1    ->
       DEC    $E7E6

       LBRA   DEBUT     ------>


* Séquence de commutation vers les S/P
* en cartouche no 2
*---------------------------------------

COMBK2 INC    $E7E6
       LEAU   -$4000,U
       JSR    ,U
       PSHS   CC
       DEC    $E7E6
       PULS   CC
       RTS

* Séquence de commutation vers les S/P
* en cartouche no 1
*---------------------------------------

       DEC    $E7E6
       JSR    ,U
       PSHS   CC
       INC    $E7E6
       PULS   CC
       RTS

****************************************

       INCLUD GRAPH-CN

       INCLUD GRAPH-MN

       INCLUD GRAPH-F

       INCLUD GRAPH-X1

       INCLUD GRAPH-X2

       INCLUD GRAPH-IP

       INCLUD GRAPH-PR


*************** bank 2 *****************

       ORG    $4022

* Auto-copie $1800..$3FFF vers $7800
* (S/P fenêtrage)
*---------------------------------------

       INC    $E7E6
       LDX    #$1800
       LDY    #$7800
BCPIF2 LDD    ,X++
       STD    ,Y++
       CMPX   #$4000
       BNE    BCPIF2    ->
       DEC    $E7E6

       LBRA   DEBUT     ------>


* Séquence de commutation vers les S/P
* en cartouche no 2
*---------------------------------------

       INC    $E7E6
       LEAU   -$4000,U
       JSR    ,U
       PSHS   CC
       DEC    $E7E6
       PULS   CC
       RTS

* Séquence de commutation vers les S/P
* en cartouche no 1
*---------------------------------------

COMBK1 DEC    $E7E6
       JSR    ,U
       PSHS   CC
       INC    $E7E6
       PULS   CC
       RTS

* S/P de la cartouche no 2
*---------------------------------------

       INCLUD GRAPH-C1 version ok

*      INCLUD GRAPH-D1 version démo

       INCLUD GRAPH-C2

       END
