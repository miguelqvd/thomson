****************************************
*                                      *
*             R E P L A Y              *
*           Crunched/6 bits            *
*      --------------------------      *
*   (c) 12.9.1991 by Doctor Lô / HCL   *
*                                      *
****************************************
*                                      *
*  REPLAY joue une série de "segments" *
* dont la structure permet de composer *
* de véritables musiques :             *
*                                      *
* BANK (1o): La Bank où est le segment *
* TEMPO (1o): "Vitesse" (0 ->23.8 KHz) *
* START (2o): (Adresse de début)-1 !!! *
* SIZE (2o): Longueur en "quadruplets" *
*                                      *
*   La fin de la liste de segments est *
* codée: ($80+BANK du premier segment) *
* et la musique boucle tant qu'aucune  *
* touche n'est frappée au clavier.     *
*                  -                   *
* REPLAY accepte en entrée 2 pointeurs *
* dans la liste des segments:          *
* -> on commence à jouer à partir de U *
* -> pour boucler, on reprend à X.     *
*               -------                *
*                                      *
*  L'intervalle entre deux "notes" est *
* TOUJOURS de 42+5*TEMPO microsecondes *
* réparties comme suit:                *
* 31: Avant validation de la hauteur.  *
*  4: Validation de la hauteur du son. *
* 7+5*TEMPO: boucle de temporisation.  *
*                                      *
****************************************



       ORG    $9F00   Last byte in $9F80
REPLAY PSHS   U,Y,X,DP,B,A,CC
       LDA    #$E7
       TFR    A,DP
       STX    PLAY4-4 sgmnt début boucle
       PULU   A,B,X,Y
       STA    <$E5    bank du 1er sgmnt
       PSHS   B       val. temporisation
       BRA    PLAY1

*******début*de**la*boucle*REPLAY*******

PLAY3  LDA    ,X+     6
       ASLA           2
       ASLA           2
       STA    *+8     5
       LDA    ,X      4
       ANDA   #3      2
       ORA    #0      2
       STA    <$CD    4------------note3
       LDB    ,S      4
       BEQ    *+5     3
        DECB
        BNE   *-1


* Répartition du son sur le quadruplet:
*
*   [54321010]  [54325432]  [54321010] *
*                          X:^^^^^^    *

       LDD    ,X      5
       LEAY   -1,Y    5 fin de segment ?
       BEQ    NEWBNK  3
        LDB   [D,Y]
        BRA   PLAY4
NEWBNK LDB    ,U      4 nouvelle Bank
       BMI    *+4     3 fin de musique ?
        BRA   *+5       non:continue
       LDU    #0      3 oui:recommence
       STB    <$E5    4
PLAY4  LSRA           2
       LSRA           2
       STA    <$CD    4------------note4
       LDB    ,S      4
       BEQ    *+5     3
        DECB
        BNE   *-1


* Répartition du son sur le quadruplet:
*
*   [54321010]  [54325432]  [54321010] *
*X+1:^^^^^^                            *

       LEAY   ,Y      4 fin de segment ?
       BEQ    NEWSEG  3 oui:re-paramètre
        MUL             non:continue
        JMP   PLAY1
NEWSEG PULU   A,B,X,Y 11 début;longueur;
       STB    ,S      4  nouveau tempo
PLAY1  LDA    1,X     5
       LSRA           2
       LSRA           2
       STA    <$CD    4------------note1
       LDB    ,S      4
       BEQ    *+5     3
        DECB
        BNE   *-1


* Répartition du son sur le quadruplet:
*
*  [54321010]  [54325432]  [54321010]  *
*X+1:     ^^    ^^^^                   *

       LEAX   1,X     5
       BRN    *       3
PLAY2  LDA    ,X+     6
       ANDA   #3      2
       STA    *+8     5
       LDA    ,X      4
       LSRA           2
       LSRA           2
       ORA    #0      2
       STA    <$CD    4------------note2
       LDB    ,S      4
       BEQ    *+5     3
        DECB
        BNE   *-1


* Répartition du son sur le quadruplet:
*
*   [54321010]  [54325432]  [54321010] *
*              X:    ^^^^          ^^  *

       LDA    $E7C8   5 touche frappée ?
       BEQ    PLAY3   3 non: on continue

********fin*de*la*boucle*REPLAY*********

       PULS   B        dépile le TEMPO
       PULS   CC,A,B,DP,X,Y,U,PC  retour
