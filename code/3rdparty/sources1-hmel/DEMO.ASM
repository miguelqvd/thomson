       TITLE  TO-DEMO:
*      ------------------------------
       PAGE

****************************************
*                                      *
*  Démonstration de l'utilisation des  *
*          routines TO-FEN             *
*                                      *
*  Création du squelette d'une applica *
*  tion .CHG de 32ko                   *
*                                      *
****************************************
*                                      *
* Sources:                             *
*                                      *
*   FEN-EQU.ASM Equates du fenêtrage   *
*   DEMO-EQ.ASM Equates                *
*   DEMO-CN.ASM Constantes             *
*   DEMO-B1.ASM Traitement BANK 1      *
*   DEMO-TR.ASM Traitements            *
*   DEMO-SP.ASM Gestion S/P            *
*   DEMO-PR.ASM Programme principal    *
*   DEMO   .ASM Structure              *
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
*                                      *
** Banks données :                     *
*                                      *
* bank 2 : Manoeuvre                   *
* bank 3                               *
*   .. 6 : Pile des fenêtres           *
*          (moins ou plus selon les    *
*           niveaux d'empilement max.  *
* bank 7                               *
*   ...  : Pour application !!!        *
*                                      *
** RAM "en ligne"                      *
*                                      *
* $0000..$3FFF: Soft, constantes et    *
*               données pseudo stati-  *
*               ques (cartouche)       *
* $6000..$62FF: RAM moniteur/extramon  *
* $6300..$67FF: Pile (#1ko)            *
* $6800..$6FFF: RAM appli. non commut. *
*               (#2ko)                 *
* $7000..$77FF: Zones DOS 5 dsk 2fic.  *
* $7800..$9FFF: Copie active des S/P   *
*               de fenêtrage (10ko)    *
*               pour que les S/P de    *
*               fenetrage puissent etre*
*               appelés à partir de    *
*               les banks de l'appli ! *
* $A000..$DFFF: Manoeuvre sur les bank *
*               de donnée              *
*                                      *
****************************************
* PRODUCTION:                          *
****************************************
*                                      *
*   Sous 6809 ASM                      *
*                                      *
*     - L DEMO (deja fait si vous lisez*
*     - A DEMO (/NL/NS si sup listing) *
*                                      *
*   Sous CR-APPLI:                     *
*                                      *
*     - Charger DEMO.BIN (base $0000)  *
*     - Charger FEN.BIN   (base $5800) *
*     - Créer TO-DEMO.CHG              *
*                                      *
****************************************

* Definition de l'implantation finale
* des sous-programmes de TO-FEN

BASEF  EQU    $7800    implant. soft
*                      fenêtrage !!!

       INCLUD FEN-EQU  équates FEN

       INCLUD DEMO-EQ

* Page 0 dee l'application
       SETDP  PAGE0/256

****************************************


*
* Cartouche No 1
* L'en-tete (34oc)sera cree par CR-APPLI
* L'assemblage se fait selon l'adressage
* réel $0000-$3FFF
* L'appel d'un S/P du bank 1 se fait par
*    JSR   adr    ou par
*    LBSR  adr
* L'appel d'un S/P du bank 2 se fait par
*    LDU   #adr.S/P (fourni par ASM)
*    JSR   COMBK2   (ou LBSR ...)
* L'appel d'un S/P moniteur se fait par
*    JSR   adr    ou par
*    LBSR  adr
*---------------------------------------

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

**** Code du premier bank **************

       INCLUD DEMO-CN

       INCLUD DEMO-TR

       INCLUD DEMO-SP

****************************************

       INCLUD DEMO-PR

****************************************


*
* En tête cartouche No 2
* L'en-tete (34oc)sera cree par CR-APPLI
* L'assemblage se fait selon l'adressage
* simulé $4000-$7FFF au lieu de
*        $0000-$3FFF
* L'appel d'un S/P du bank 2 se fait par
*    LBSR  adr
* L'appel d'un S/P du bank 1 se fait par
*    LDU   #adr.S/P (fourni par ASM)
*    LBSR  COMBK2
* L'appel d'un S/P moniteur se fait par
*    JSR   adr
*---------------------------------------

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


**** Code du deuxieme bank *************


       INCLUD DEMO-B1

       END
