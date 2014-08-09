*** COPYROM0 ***************************
*                                      *
* LECTURE DES 64 Ko ROM en $0000/$3FFF *
*                                      *
*** par Michel SAINT-BRIANT/ASCI (c) ***

       ORG    $8000

* Sauvegarde des registres

       PSHS   U,X,Y,DP,A,B,CC

* Initialisation de la bank courante
* en bank 3 (no BASIC donc valeur=4)

       LDA    #4
       STA    $E7E5

* Copie de BASIC512 banque 0
* à lire en BANK 3 de $A000 à $DFFF

       STA    >0      la commutation des
                * slots se fait en écri-
                * vant à l'adresse dont
                * le no est no du slot.

       BSR    COPIE

* Copie de BASIC512 banque 1
* à lire en BANK 4 de $A000 à $DFFF

       STA    >1
       BSR    COPIE

* Copie de BASIC 1.0 banque 2
* à lire en BANK 5 de $A000 à $DFFF

       STA    >2
       BSR    COPIE

* Copie du DOS ICONIQUE banque 3
* à lire en BANK 6 de $A000 à $DFFF

       STA    >3
       BSR    COPIE

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
