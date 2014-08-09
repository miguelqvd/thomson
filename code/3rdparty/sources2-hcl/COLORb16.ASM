****************************************
*      REMPLACEMENT DE COULEURS        *
*       sur une image BitMap16         *
****************************************
* Voir la matrice des correspondances en
* fin de programme. By Doctor Lô 19-5-91


       ORG    $9F00

G      ORCC   #80
       LDU    #CORRES   Table conversion
       LDA    $E7C3
       ORA    #1
       STA    $E7C3
       BSR    TRAITE-3
       DEC    $E7C3

       LDX    #$4000
TRAITE LDA    ,X      première couleur
       LSRA            forts->faibles
       LSRA
       LSRA
       LSRA             origine...
       LDA    A,U          ...nouvelle
       LSLA
       LSLA
       LSLA
       LSLA            faibles->forts
       LDB    ,X           origine
       ANDB   #15      4 bits forts à 0
       STB    ,X
       ORA    ,X       et remplacés par
       STA    ,X      la nouvelle valeur
       ANDA   #15
       LDB    ,X           origine
       ANDB   #240    4 bits faibles à 0
       ORB    A,U      et remplacés par
       STB    ,X+     la nouvelle valeur
       CMPX   #$5F40
       BNE    TRAITE
       RTS

* Table de correspondance des couleurs:
*   indice de la case = couleur origine
*  contenu de la case = nouvelle couleur

       FCC    / HCL /
CORRES FCB    0,1,2,3,4,5,6,7,8,9,10,11
       FCB    12,13,14,15
       END
