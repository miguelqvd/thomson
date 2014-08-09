****************************************
*                                      *
* Sauvegarde écran+palette en secteurs *
*                                      *
*************(MEGASHOW1)****************

       ORG    $9F00

G      ORCC   #80
       LDD    #$138   face et piste
       STA    $6049
       STB    $604B
       LDX    #$A000
       STX    $604F

       LDU    #$DF40  debut palette
       CLR    $E7E5
       CLRA
       LDX    #$FFFF
       LDY    #0
       JSR    $EC00
       STX    ,U++
       INCA
       CMPA   #16
       BNE    *-15

       LDD    #$108   ecriture secteur 1
       STB    $6048
       LDB    #64     car $4000=256*64
SAVEP  STA    $604C
       JSR    $E004
       INCA
       CMPA   #17
       BNE    *+7
       LDA    #1
       INC    $604B
       INC    $604F
       DECB
       BNE    SAVEP
       LDB    $604B   1ere piste libre
       STB    G+4      une fois fini
       RTS

       END
