****************************************
*                                      *
* Calcul du checksum pour une zone DSK *
*                                      *
************(MEGASPREADER)**************

       ORG    $9F00

G      ORCC   #80
       LDD    #$11B   face et piste
       STA    $6049
       STB    $604B
       LDX    #$A000
       STX    $604F
       CLR    $E7E5

       LDD    #$102   lecture secteur 1
       STB    $6048
       CLRB

LOAD   STA    $604C
       JSR    $E004
       LDX    #$A000
       ADDB   ,X+
       CMPX   #$A100
       BNE    *-5
       INCA
       CMPA   #17
       BNE    LOAD
       LDA    $604B
       INCA
       STA    $604B
       CMPA   #80     derniere piste ?
       BEQ    *+6
       LDA    #1
       BRA    LOAD
       STB    *+4     la somme finale
       RTS

       END
