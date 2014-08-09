*** COPYCART ***************************
*                                      *
*  LECTURE d'une cartouche de 4K à 64K *
*                                      *
*** par Michel SAINT-BRIANT/ASCI (c) ***

       ORG    $8000

* Sauvegarde des registres

       PSHS   U,X,Y,DP,A,B,CC

* On sauvegarde la valeur de $E7C3 pour
* restauration en fin de programme.

       LDA    $E7C3
       PSHS   A

* On commute l'espace logique $0/$3FFF
* sur la cartouche en mettant le bit 2
* de $E7C3 à 0 (sinon à 1 ce sont les
* 64 Ko de BASIC512+BASIC1.0+DOS icon.)

       ANDA   #$FB
       STA    $E7C3

* Initialisation de la bank courante
* en bank 3 (no BASIC donc valeur=4)

       LDA    #4
       STA    $E7E5

* Copie de la première banque-cartouche
* à lire en BANK 3 de $A000 à $DFFF

       STA    >0      la commutation des
                * slots se fait en écri-
                * vant à l'adresse dont
                * le no est no du slot.

       BSR    COPIE

* Copie de la 2è banque de la cartouche
* si elle existe sinon la 1 est recopiée
* à lire en BANK 4 de $A000 à $DFFF

       STA    >1
       BSR    COPIE

* Copie de la 3è banque de la cartouche
* si elle existe sinon la 1 est recopiée
* à lire en BANK 5 de $A000 à $DFFF

       STA    >2
       BSR    COPIE

* Copie de la 4è banque de la cartouche
* si elle existe sinon la 1 est recopiée
* à lire en BANK 6 de $A000 à $DFFF

       STA    >3
       BSR    COPIE

* On restaure le registre $E7C3

       PULS   A
       STA    $E7C3

* On se remet sur le slot 0 pour
* 'retomber' en BASIC512 si c'esl le cas

       STA    >0

* On restaure les registres et on sort.

       PULS   CC,B,A,DP,Y,X,U,PC

**********************
* copier les banques *
**********************

COPIE  LDX    #$0000
       LDY    #$A000
COP    LDU    ,X++
       STU    ,Y++
       CMPX   #$4000
       BLO    COP
       INC    $E7E5   bank suivante
       RTS

       END
