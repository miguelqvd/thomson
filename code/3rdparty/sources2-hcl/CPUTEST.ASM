****************************************
*Mesure du temps CPU utilisé par ROUTST*
****************************************

ROUTST EQU    BIDON   routine à tester

       ORG    $A000
G      ORCC   #80
       PSHS   DP
       LDD    #$3E7
       TFR    B,DP
       STA    <$DD    border en jaune

SYNCRO LDA    #32
       BITA   <$E7
       BEQ    *-2
       BITA   <$E7
       BNE    *-2
       PSHS   A
       MUL
       MUL
       MUL
       MUL
       PULS   A
       BITA   <$E7
       BEQ    *-10
       MUL
       MUL
       MUL
       MUL
       MUL
       TST    <$E7
       BPL    *-7
       MUL
       MUL
       MUL
       MUL
       MUL
       TST    <$E7
       BMI    *-7
       LDX    #$3B5
       LEAX   -1,X
       BNE    *-2
       LDX    #0      initialisations
       LDY    #0      éventuelles pour
       LDU    #0      la routine appelée
       LDD    #15

       STA    <$DB
       STB    <$DA    trace ON
       STA    <$DB
       JSR    ROUTST
       CLRA
       STA    <$DA    trace OFF
       LDB    <$C8
       BEQ    SYNCRO
       STA    <$DD    border en noir
       PULS   DP
       SWI
BIDON  RTS

       END
