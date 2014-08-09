****************************************
*   Complément de SNAPSHOT : Affiche   *
* à l'écran la BANK choisie au clavier *
*    et cherche la palette en $BF40    *
****************************************

       ORG    $9F00

G      ORCC   #80
       LDA    $E7E5
       PSHS   A,DP
       LDB    #$E7
       TFR    B,DP
GETKEY JSR    $E806   choix au clavier
       CMPB   #'S     "S" pour quitter
       BNE    *+8
       PULS   A,DP
       STA    $E7E5
       RTS
       SUBB   #48     de 0 à f en hexa
       CMPB   #22
       BHI    GETKEY
       CMPB   #10     le numéro de BANK
       BLO    *+8
       CMPB   #17
       BLO    GETKEY
       SUBB   #7
       LDA    <$E7    syncro bas d'écran
       BPL    *-2
       LDA    <$E7
       BMI    *-2
       LDA    #15     palettes en noir
       LDX    #0
       LEAY   ,X
       JSR    $EC00
       DECA
       BGE    *-9
       LDX    #$A000      transfert
       LDU    #$C000    BANK -> écran
       STB    <$E5
       LDA    ,X
       CLR    <$E5
       STA    ,X+
       STB    <$E5
       LDA    ,U
       CLR    <$E5
       STA    ,U+
       CMPX   #$BF40
       BNE    *-23
       STB    <$E5    nouvelle palette
       LDA    #255
       JSR    $EC00
       BRA    GETKEY  boucle clavier
       END
