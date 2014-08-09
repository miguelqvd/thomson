       ORG    $9800
G      ORCC   #80
       LDX    #$FDC8
       LDU    #RESET
       LDA    ,X+
       STA    ,U+
       CMPX   #$FEF8
       BNE    *-7
RESET

       ORG    $995E
       LDA    #15
       STA    $E7E5
       LDX    #0
       LDU    #$A000
       LDA    ,X+
       STA    ,U+
       CMPX   #$4000
       BNE    *-7
       BRA    *
       END
