**************************************
**************************************
**                                  **
** ***  *  **  *** *** *** *  * *** **
** *   * * * *  *  * * * * ** * *   **
** *   *** **   *  * * * * * ** *** **
** *   * * * *  *  * * * * *  *   * **
** *** * * * *  *  *** *** *  * *** **
**                                  **
**************************************
**************************************
**                                  **
** Par Michel SAINT-BRIANT (c) ASCI **
**                                  **
**************************************
**************************************
* permet de transferer une zone de la
* page d'affichage no 0 sur les pages
* 2 ou 3 puis de commuter ladite page
* ce qui permet un affichage instan-
* utilisable pour des animations.
**************************************


       ORG    $8000
G      PSHS   X,Y,U,A,B,DP,CC
       LDA    #2      commutation de la
       STA    $E7E5   bank basic 1
       LDU    #$4262  zone lecture
       LDY    #$C4BA  zone écriture
       LDA    #170    170 lignes
       STA    COMPT   sur compteur
BOUCLE PULU   A,B,X   < équivaut LDD,U++
       STD    ,Y++     & LDX,Y++ mais en
       STX    ,Y++     plus rapide: 9 cy
       PULU   A,B,X    cles au lieu de16
       STD    ,Y++    < 8 cycles
       STX    ,Y++    < 8 cycles
       PULU   A,B,X
       STD    ,Y++      donc (8+8+9)*5=
       STX    ,Y++      125 cycles par
       PULU   A,B,X     ligne + 16 pour
       STD    ,Y++      boucle donc en
       STX    ,Y++      tout 151*170=
       PULU   A,B,X     25670 cycles
       STD    ,Y++      d'où 1/40 s
       STX    ,Y++
       LEAU   20,U      8 cycles )
       LEAY   20,Y      8 cycles ) =
       DEC    COMPT     7 cycles ) 26
       BNE    BOUCLE    3 cycles )
       LDA    #$80      on valide bank 1
       STA    $E7DD     pour l'écran
       PULS   CC,A,B,DP,X,Y,U,PC
COMPT  NOP
       END
