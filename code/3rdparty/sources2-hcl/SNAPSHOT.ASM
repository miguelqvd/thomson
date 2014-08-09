****************************************
*           S N A P S H O T            *
****************************************
*    Copie de l'écran dans une BANK    *
*         au moment du RESET           *
****************************************
* La routine se met à l'abri en $5FC0. *
* D'après la procédure de RESET (FEF2) *
* la mémoire COULEUR est commutée lors *
* de la dérivation. L'implantation ne  *
*  se fait donc qu'en RAMa. La palette *
*   est copiée en $BF40 de la banque   *
* destination sous la forme : 0BVR x16 *
****************************************
***        (c) Doctor Lô 1991        ***

       ORG    $6088
       JMP    $5FC0   détourne le RESET.
       ORG    $60FE   Car ça marche ssi
       FDB    $A55A   le reset est SOFT!
       ORG    $E7E5     sélection BANK
       FCB    0        -> mémoire écran

***** IMPLANTATION en fin de RAM-A *****

       ORG    $BFC0
       PSHS   X,B,A
GETKEY JSR    $E806    BANK destination
       SUBB   #48     (choix au clavier)
       ANDB   #$DF    minuscules->ABCDEF
       CMPB   #22      de 0 à F en hexa
       BHI    GETKEY
       CMPB   #10
       BLO    *+8
       CMPB   #17
       BLO    GETKEY
       SUBB   #7
       LDX    #$A000  copie de l'écran
       LDA    ,X
       STB    $E7E5
       STA    ,X+
       CLR    $E7E5
       CMPX   #$E000
       BNE    *-13
       LDX    #$BF40  formatage palette
       LDB    #16      et transfert en
       LDA    ,X        $BF40 - $BF5F
       ANDA   #15
       STA    ,X++
       DECB
       BNE    *-7
       LDD    #$A55A  à la prochaine !
       STD    $60FE
       PULS   A,B,X,PC

       END
