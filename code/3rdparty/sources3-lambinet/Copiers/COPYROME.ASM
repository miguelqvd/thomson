*** COPYROME ***************************
*                                      *
* LECTURE DES 16 Ko ROM en $E000/$FFFF *
* ( moniteur en deux parties de 8 Ko ) *
*                                      *
*** par Michel SAINT-BRIANT/ASCI (c) ***

       ORG    $8000

* Sauvegarde des registres

       PSHS   U,X,Y,DP,A,B,CC

* Initialisation de la bank courante
* en bank 3 (no BASIC donc valeur=4)

       LDA    #4
       STA    $E7E5

* Copie du moniteur partie haute
* à lire en BANK 3 de $C000 à $DFFF

       LDA    $E7C3   la commutation des
       ORA    #$10    deux parties se
       STA    $E7C3   joue sur le bit 4
                      * du 6846 en $E7C3
                      * =1 -> part.haute
       LDX    #$C000
       LDY    #$E000
COP0   LDU    ,Y++
       STU    ,X++
       CMPX   #$E000
       BLO    COP0

* Copie du moniteur partie basse
* à lire en BANK 3 de $A000 à $BFFF

       LDA    $E7C3   la commutation des
       ANDA   #$EF    deux parties se
       STA    $E7C3   joue sur le bit 4
                      * du 6846 en $E7C3
                      * =0 -> part.basse
       LDX    #$A000
       LDY    #$E000
COP1   LDU    ,Y++
       STU    ,X++
       CMPX   #$C000
       BLO    COP1


* On restaure les registres et on sort.

       PULS   CC,B,A,DP,Y,X,U,PC

       END
