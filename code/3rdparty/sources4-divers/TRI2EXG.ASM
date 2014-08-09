


****************************************
*                                      *
*              T R I 2 EXG             *
*                                      *
****************************************
*                                      *
* Programme de tri en mémoire centrale *
* appel par le BASIC par USR(0)        *
*--------------------------------------*
*                                      *
*     Manuel de l'assembleur 6809      *
*        du TO7/TO7-70 page 165        *
*                                      *
****************************************


       ORG    $7FBD

       LDA    #100    Nb d'éléments à
       LDB    #100    trier = 100 seront
* contenus dans les accumulateurs A et B

       LDY    2,X     Le paramètre trans
* mis au langage machine est placé dans
* les 2 octets après l'adresse contenue
* dans X.Y va contenir VARPTR(A(0)).Le
* programme démarre avec Y pointant sur
* le 1er élément A(0) du tableau A(I).

SUITE2 PSHS   D       Sauvegarde de D

       LEAX   2,Y     On commande à X de
* pointer sur le 2ème élément du tableau
* soit A(1), noter que les entiers sont
* rangés en mémoire sur 2 octets.

SUITE1 DEC    ,S      Décrémente l'octet
* au sommet de la pile.Celui-ci équivaut
* au nombre de passages dans la boucle
* SUITE1.

       BEQ    PASSE   (+21)On compare le
       LDD    ,X++    2nd élem. de A(I)
*                     pointé par X et le
       CMPD   ,Y      1er (pointé par Y)
       BHS    SUITE1  (-11)Oui si le 2nd
* > ou = au 1er alors retour à SUITE1
* pour comparer le 3ème et le 1er.

       PSHS   D       Si non (2nd<1er)
       LDD    ,Y      on procède à leur
       STD    ,--X    échange.Nous avons
       PULS   D       la certitude à la
       STD    ,Y      fin de la boucle
       LEAX   2,X     SUITE1 que A(0)
       BRA    SUITE1  (-25)est l'élément
*                     minimum de A(I).

PASSE  LEAY   2,Y     Y va contenir l'
       PULS   D       adresse de A(1) et
       DECB           un retour à SUITE2
       EXG    B,A     est programmé.Pour
       CMPB   #1      comparer A(1) avec
       BNE    SUITE2  (-40)les éléments
* suivants; un échange sera effectué à
* chaque fois que l'on aura trouvé un
* élément plus petit que A(1).

       RTS
       END

* Ainsi après deux passages de la boucle
* SUITE2, A(0) et A(1) contiendront les
* deux plus petites valeurs de A(I), et
* ceci dans l'ordre croissant.
* Quand le programme arrivera à la fin,
* les 100 éléments seront rangés et la
* ligne BASIC 60 nous en donnera la
* confirmation.
* NB: La variable Z est une var. fictive
* dont la valeur est sans importance
* puisque l'assembleur n'a aucun para-
* mètre à retourner au BASIC.
