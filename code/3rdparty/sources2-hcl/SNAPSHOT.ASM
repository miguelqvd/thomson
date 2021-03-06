****************************************
*           S N A P S H O T            *
****************************************
*    Copie de l'�cran dans une BANK    *
*         au moment du RESET           *
****************************************
* La routine se met � l'abri en $5FC0. *
* D'apr�s la proc�dure de RESET (FEF2) *
* la m�moire COULEUR est commut�e lors *
* de la d�rivation. L'implantation ne  *
*  se fait donc qu'en RAMa. La palette *
*   est copi�e en $BF40 de la banque   *
* destination sous la forme : 0BVR x16 *
****************************************
***        (c) Doctor L� 1991        ***

       ORG    $6088
       JMP    $5FC0   d�tourne le RESET.
       ORG    $60FE   Car �a marche ssi
       FDB    $A55A   le reset est SOFT!
       ORG    $E7E5     s�lection BANK
       FCB    0        -> m�moire �cran

***** IMPLANTATION en fin de RAM-A *****

       ORG    $BFC0
       PSHS   X,B,A
GETKEY JSR    $E806    BANK destination
       SUBB   #48     (choix au clavier)
       ANDB   #$DF    minuscules->ABCDEF
       CMPB   #22      de 0 � F en hexa
       BHI    GETKEY
       CMPB   #10
       BLO    *+8
       CMPB   #17
       BLO    GETKEY
       SUBB   #7
       LDX    #$A000  copie de l'�cran
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
       LDD    #$A55A  � la prochaine !
       STD    $60FE
       PULS   A,B,X,PC

       END
