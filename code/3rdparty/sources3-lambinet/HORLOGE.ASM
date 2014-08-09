******  HORLOGE  ******

******  EQUATES  ******

DIXIEM EQU    $6580
SECOND EQU    $6581
MINUTE EQU    $6582
HEURE  EQU    $6583
JOUR   EQU    $6584
MOIS   EQU    $6585
ANNEE  EQU    $6586
AFTIME EQU    $6587



******  INITIALISATION  ******

DEBUT  PSHS   U,Y,X,DP,B,A,CC
       LDU    #DIXIEM
       LDA    #$4F
BDEB   CLR    A,U
       DECA
       BNE    BDEB
       LDX    #$65D0
       STX    $6027
       LDA    $6019
       ORA    #$20
       STA    $6019
       LDA    #$01
       STA    SECOND
       PULS   CC,A,B,DP,X,Y,U,PC

******  INTERRUPTION  ******

INTER  PSHS   U,Y,X,DP,B,A,CC
       INC    DIXIEM
       LDA    DIXIEM
       CMPA   #$0A
       LBLO   SOR
SEC    CLR    DIXIEM
       INC    SECOND
       LDA    SECOND
       CMPA   #$3C
       LBNE   TIMEOK
       CLR    SECOND
       INC    MINUTE
       LDA    MINUTE
       CMPA   #$3C
       LBNE   TIMEOK
       CLR    MINUTE
       INC    HEURE
       LDA    HEURE
       CMPA   #$18
       LBNE   TIMEOK
       CLR    HEURE
       INC    JOUR
       LDA    JOUR
       CMPA   #$20
       BEQ    CHGT31
       CMPA   #$1F
       BEQ    CHGT30
       CMPA   #$1E
       BEQ    CHGT29
       CMPA   #$1D
       LBNE   TIMEOK
       LDA    MOIS
       CMPA   #2
       LBNE   TIMEOK
CHGT28 LDA    ANNEE
       ANDA   #3
       LBEQ   TIMEOK
       BRA    CHGTM
CHGT29 LDA    MOIS
       CMPA   #2
       LBNE   TIMEOK
       LDA    ANNEE
       ANDA   #3
       LBNE   TIMEOK
       BRA    CHGTM
CHGT30 LDA    MOIS
       CMPA   #4
       BEQ    CHGTM
       CMPA   #6
       BEQ    CHGTM
       CMPA   #9
       BEQ    CHGTM
       CMPA   #11
       BEQ    CHGTM
       LBRA   TIMEOK
CHGT31 LDA    MOIS
       CMPA   #1
       BEQ    CHGTM
       CMPA   #3
       BEQ    CHGTM
       CMPA   #5
       BEQ    CHGTM
       CMPA   #7
       BEQ    CHGTM
       CMPA   #8
       BEQ    CHGTM
       CMPA   #10
       BEQ    CHGTM
       CMPA   #12
       LBNE   TIMEOK
CHGTM  LDA    #1
       STA    JOUR
       INC    MOIS
       LDA    MOIS
       CMPA   #13
       BNE    TIMEOK
CHGTA  LDA    #1
       STA    MOIS
       INC    ANNEE
       LDA    ANNEE
       CMPA   #100
       BNE    TIMEOK
       CLR    ANNEE
TIMEOK TST    AFTIME
       LBNE   SOR
       LDY    #$4020
       LDB    JOUR
       BSR    AFNBR
       LDB    #$2F
       BSR    AFASC
       LDB    MOIS
       BSR    AFNBR
       LDB    #$2F
       BSR    AFASC
       LDB    ANNEE
       BSR    AFNBR
       LDY    #$4160
       LDB    HEURE
       BSR    AFNBR
       LDB    #$3A
       BSR    AFASC
       LDB    MINUTE
       BSR    AFNBR
       LDB    #$2E
       BSR    AFASC
       LDB    SECOND
       BSR    AFNBR
       JMP    MMS
AFNBR  CLRA
       TSTB
       BEQ    AFF0
BDAA   INCA
       DAA
       DECB
       BNE    BDAA
AFF0   PSHS   A
       TFR    A,B
       RORB
       RORB
       RORB
       RORB
       ANDB   #$0F
       ADDB   #$30
       BSR    AFASC
       PULS   B
       ANDB   #$0F
       ADDB   #$30
       BSR    AFASC
       RTS
AFASC  PSHS   Y
       LDA    $E7C3
       ORA    #$01
       STA    $E7C3
       LDA    #8
       MUL
       ADDD   #$E74D
       TFR    D,X
       LDA    #8
BAFF   LDB    ,-X
       STB    ,Y
       LEAY   $28,Y
       DECA
       BNE    BAFF
       PULS   Y
       LEAY   1,Y
       RTS
MMS    LDA    $E7C3
       ORA    #1
       STA    $E7C3
       LDX    #$A340
       LDY    #$4000
       LDB    #$10
BMMS0  LDA    #5
BMMS1  LDU    ,X++
       STU    ,Y++
       DECA
       BNE    BMMS1
       DECB
       BEQ    SOR
       LEAY   $1E,Y
       BRA    BMMS0

SOR    PULS   CC,A,B,DP,X,Y,U
       JMP    $E830


******  FIN  ******


       END
