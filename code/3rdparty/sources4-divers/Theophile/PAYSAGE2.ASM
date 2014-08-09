*
*            PAYSAGE2.ASM
*
*       Théophile No 9 page 48
*
*       Voir également PAYSAGE1
*    Passez facilement du BASIC au
*   langage machine des TO7(70),TO9
*   Programme No XXIX pages 203-215
*
* =====================================
*
* Recopie d'écran en double dimensions
* sur imprimante PR90-080.
*

GRCODE EQU    $6047   Imp mode graphique
RSOPC  EQU    $602B   Mot cde gest. com.
RSCO   EQU    $E812   Gère E/S communiq.
RSTA   EQU    $602C   Etat ct liais. com
GETP   EQU    $E821   Lect. statut point
PORT   EQU    $E7C3
KTST   EQU    $E809   Lecture clavier
PUTC   EQU    $E803   Affich d'1 caract.

       ORG    $7EDE

COPIE  PSHS   U,Y,X,DP,D,CC

OUVRIR LDB    #$40    Ouverture// Ecrit.
       STB    RSOPC
       JSR    RSCO
       LBCS   ARRET
       LDA    PORT    Mémoire-caractère
       ORA    #1
       STA    PORT
       LDA    #8      .Code copie graph.
       STA    RSOPC   .Imp.PR90-080+Mise
       LDB    #8      .en écriture
       JSR    RSCO
       LBCS   ARRET

CURSOR LDB    #$14    Effacement curseur
       JSR    PUTC

INIT   LDX    #320    Le premier point
*                     d'analyse sera:
PREM   LDY    #0      X=319,Y=0

****************************************
*La première colonne ne fait que 2 pts *
*en largeur.Son traitement est de type *
*DROIT (le bit de gauche ne sera double*
*qu'à l'impression de la ligne suivante*
*Pour cela on n'utilise qu'une partie  *
*de DMASQ appelée INIMSK.              *
****************************************

LIGN   CLRA           1ère colonne adr.
       LDU    #INIMSK 1er masque

POINT  LEAX   -1,X    Décrémente X lire
       JSR    GETP    coul du pt (X,Y)
       CMPB   #0      si coul=FOND si
       BMI    SUIV    coul=FORME on uili
       ORA    ,U      se le masque.

SUIV   LDB    ,U+     Masque suivant est
       CMPB   #$80    -ce le dernier ?
       BLO    POINT   non=>point suivant
       ORA    -1,U    oui=>masquer 1->b7

IMPR   EXG    A,B     L'octet à écrire
*                     passe dans B
       JSR    RSCO    1ère écriture
       LBCS   ARRET
       JSR    RSCO    2ème écriture
       LBCS   ARRET
       LEAY   1,Y     Y suivant...
       CMPY   #200    Bas de l'écran ?
       BEQ    CRLF
       LEAX   3,X     Imp ligne X=X+3
       BRA    LIGN    passer à la ligne
*                     Y+1

CRLF   LDB    #$0D    CR=Retour chariot
       JSR    RSCO
       LBCS   ARRET
       LDB    #$0A    LF=Saut de ligne
       JSR    RSCO
       LBCS   ARRET
       LEAX   2,X
       BRA    GAUCHE

DROIT  LDY    #0      TRAIT. TYPE DROIT

DLIGN  CLRA
       LDU    #DMASQ  Adresse 1er masque

DPOINT LEAX   -1,X    Décrémente X lire
       JSR    GETP    couleur du point
       CMPB   #0      (X,Y),si coul=fond
       BMI    DSUIV   si coul=forme on
       ORA    ,U      utilise le masque.

DSUIV  LDB    ,U+     Masque suivant est
       CMPB   #$80    -ce le dernier ?
       BLO    DPOINT  non=>point suivant
       ORA    -1,U    oui=>masquer 1->b7

DIMPR  EXG    A,B     L'octet à écrire
*                     passe dans B

       JSR    RSCO    1ère écriture
       BCS    ARRET
       JSR    RSCO    2ème écriture
       BCS    ARRET
       LEAY   1,Y     Y suivant...
       CMPY   #200    Bas de l'écran ?
       BEQ    DCRLF   Oui=>Imp la ligne
       LEAX   5,X     X=X+5
       BRA    DLIGN   Passer à la ligne
*                     Y+1

DCRLF  LDB    #$0D    Retour chariot
       JSR    RSCO
       BCS    ARRET
       LDB    #$0A    Saut de ligne
       JSR    RSCO
       BCS    ARRET
       LEAX   2,X

GAUCHE LDY    #0      TRAIT. TYPE GAUCHE

GLIGN  CLRA
       LDU    #GMASQ

GPOINT LEAX   -1,X
       JSR    GETP
       CMPB   #0
       BMI    GSUIV
       ORA    ,U

GSUIV  LDB    ,U+
       CMPB   #$80
       BLO    GPOINT
       ORA    -1,U

GIMPR  EXG    A,B
       JSR    RSCO
       BCS    ARRET
       JSR    RSCO
       BCS    ARRET
       LEAY   1,Y
       CMPY   #200
       BEQ    GCRLF
       LEAX   5,X
       BRA    GLIGN

GCRLF  LDB    #$0D    CR=Retour chariot
       JSR    RSCO
       BCS    ARRET
       LDB    #$0A    LF=Saut de ligne
       JSR    RSCO
       BCS    ARRET
       JSR    KTST    Arret imp si une
       BCS    ARRET   touche actionnée
       LEAX   1,X
       BEQ    ARRET
       LBRA   DROIT

ARRET  LDB    #$F     Retour en mode
       JSR    RSCO    caractère
       LDA    #16     Fermeture imp
       STA    RSOPC
       JSR    RSCO
       PULS   X,Y,U,D,DP,CC,PC

*Masques pour traitement DROIT:

DMASQ  FCB    3       00000011
       FCB    0CH     00001100
INIMSK FCB    30H     00110000
       FCB    40H     01000000
       FCB    80H     10000000 bit Graph

*Masques pour traitement GAUCHE:

GMASQ  FCB    1       00000001
       FCB    6       00000110
       FCB    18H     00011000
       FCB    60H     01100000
       FCB    80H     10000000 bit Graph
       END
