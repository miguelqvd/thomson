 **************************************
**         -  C O P P E R  -          **
*  permet de changer la palette de la  *
* couleur 0 à chaque ligne. On obtient *
* ainsi des images (fixes) en plus de  *
*        2 0 0   T E I N T E S         *
* Laurent HIRIART ,  Les ENVERSGOUTTES *
**       67420 COLROY-LA-ROCHE        **
 **************************************

NL     EQU    200     nombre de lignes
VIT    EQU    0       vitesse défilement

* Palettes à partir de $DF5E et + bas...
* 16 bits chacune: (0 bleu vert rouge)


       ORG    $DF60

G      ORCC   #80     Stop interruptions
       PSHS   DP       On récupèrera DP
       LDB    #$E7      à la sortie !
       TFR    B,DP    Pour accès rapides

* SYNCRONISATION - REGLAGE COLONNE *****
* b5 de $E7E7 : situation en ligne INILN

       LDX    #*+4
       LDA    #32

       BITA   <$E7       sort quand
       BEQ    *-2     spot dans fenêtre

       BITA   <$E7       sort quand
       BNE    *-2     spot entre border

       STA    ,X+     5
       MUL            11  boucle de 63
       MUL            11 cycles dont on
       MUL            11 sort quand le
       MUL            11 spot est sur la
       LDA    ,-X     5     dernière
       BITA   <$E7    4   C O L O N N E
       BEQ    *-10    3   de la fenêtre

* SYNCRONISATION - REGLAGE LIGNE *******
* b7 de $E7E7 : situation en trame INITN

       MUL            11  boucle de 64
       MUL            11 cycles dont on
       MUL            11 sort quand le
       MUL            11  spot est sur
       MUL            11    une ligne
       TST    <$E7    6  DANS le border
       BPL    *-7     3

       MUL            11  boucle de 64
       MUL            11 cycles dont on
       MUL            11 sort quand le
       MUL            11 spot est sur la
       MUL            11    dernière
       TST    <$E7    6     L I G N E
       BMI    *-7     3   de la fenêtre

       LDX    #(211-NL/2)*8-3
       LEAX   -1,X     Pour centrer les
       BNE    *-2      lignes de copper.

* Pour pousser les bandes noires dans le
* border afin qu'on ne puisse les voir
* ni à gauche ni à droite.
* Varie selon les moniteurs : régler le
* nombre de cycles machine ...

       TST    A,X     7    Temporisation

* Changement de la palette d'une couleur
* tous les 64 cycles (i.e. chaque ligne)

       LDX    #G      Déb liste palettes
GOON   LDY    #NL     Nombre de lignes

COPPER LDD    ,--X     8  Chargement et
       CLR    <$DB     6  affectation de
       STB    <$DA     4  la nouvelle
       STA    <$DA     4  palette->coul0
       MUL             11  Temporisation
       MUL             11  Temporisation
       NOP             2   Temporisation
       CMPX   #G-2*NL  4  Fin dans liste
       BEQ    *+4      3  des couleurs ?
       BRA    *+5       3 non:rien, oui:
       LDX    #G       3  repart début.
       LEAY   -1,Y     5  200ème ligne ?
       BNE    COPPER   3  non: on boucle

       LDY    #(311-NL)*8-1  4 Cf + bas.
       CLRA           2 A la fin des NL
       NOP            2 lignes de copper
       CLR    <$DB    6  on remet vite
       STA    <$DA    4 la couleur 0 en
       STA    <$DA    4 noir (palette=0)
       LEAY   -1,Y    5   On patiente
       BNE    *-2     3 dans le border.

*      LEAX   2*VIT,X 5 Donne la vitesse
       FDB    $3088   Sinon l'assembleur
       FCB    2*VIT   risque d'optimiser
       CMPX   #G      4 Pointeur couleur
       BHI    DECALB  3 dépasse en haut?
       LDA    A,X      5  non:
       BRA    *+6      3  temporisation
DECALB LEAX   -2*NL,X 8 oui:décale bas.
       CMPX   #G-2*NL 4 Pointeur couleur
       BLS    DECALH  3 dépasse en bas ?
       LDA    A,X      5  non:
       BRA    *+6      3  temporisation
DECALH LEAX   2*NL,X  8 oui:décale haut.
       NOP            2   Temporisation
       TST    <$C8    6 clavier frappé ?
       BEQ    GOON    3  non -> boucle

       JSR    $E806   Recconnaît le code
       STB    TOUCHE  ASCII de la touche
       PULS   DP      Et on sort,heureux
       RTS
       FCC    /(c)HCL91/
TOUCHE  *             La touche frappée

       END
