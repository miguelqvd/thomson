       ORG    $6280
       FCB    0,5,6,'Z-64,$5F,$EC
       FDB    H-$6280  adresse exécution
GOTO   FDB    MYEND-2
COLORS FDB    0,15,240,255,3840,3855
       FDB    4080,4095,1911,826,931,938
       FDB    2611,2618,3815,123
       FCB    27,$40,27,$50,27,$60,12
       FCB    31,32,$28,27,$47,12,27,$68
       FCB    0
       FDB    980,4567,23571,9804,13879
       FCC    "ASM"
       FDB    28486,6480,4889,19687,1225

MODCOD NEG    <0
       PSHS   U
       DAA
       PSHS   PC,Y,DP
       LDD    2,S
       FCB    $71,$35,$F1      NEG >35F1
       ASLA
       COMA
       INCA
       FCC    " Rules"         BRA DEVIE

       FDB    7813,4089,10389,23586,8912

RETURN LEAS   4,S
       FCB    $6D,$F0          TST [,S+]
       LDB    -4,S
       ORA    #1      A=$B1
       BMI    LAB1
       FCB    $1B,$19,0

LAB2   ROLA
       PULS   U
       ORCC   #$10
       RORB
       FCB    $72,$10,$23     COM >$1023
       ROLA
       ADDD   >$0001
       PSHS   D
       LDA    ,X++
       BVC    LAB3
       FCB    $0B,$0F

LAB1   TFR    D,Y
       LEAX   D,Y     !!! seul Z changé
       BPL    H-15
       FCB    $1F,$70          TFR ?,D
       ADDD   $627E,PCR
       FCB    $01,$27          NEG <27
       SUBD   #$39BD                !
       ADCA   #$10         +--------+
       ROLB                !
       SEX                \/
SB6327 FCB    $BE,$45,$51 COMA LSRA NEGB
       LBRN   $1972
       LBRA   LAB2
       FCB    9
       BRA    *+72
DEVIE  LDU    [GOTO,PCR]
       FDB    $0153           NEG  <53
       FCB    $6E,$C7         JMP  A,U
       FCB    17

LAB3   ADDA   1,S
       LDB    ,X
       FCB    $CF,$12,$6E     STUl 2,PCR
       ADDB   ,S++
       STB    ,--X
       FCB    $E6,$90         LDB [,X+]
       STA    1,X
       RTS

       FDB    30899,3278,7810,12488
       FDB    26252,15478
       FCB    32

H      BSR    CHKIND
       CLR    >$60D1
       LDA    #-1
       LDX    #COLORS
       JSR    $EC00   initialise palette
       LDU    #$E004
       LDY    #$CB28  change 6396 & 6398
CPT    LDD    #$E766
       LEAX   $FD79,PCR
       INCA
       DAA
       DECB
       BPL    *-3
       TFR    A,B
       SUBA   #($58-$65)
       JSR    D,X
       BSR    MAPPRO
       LDU    #COLORS+32
       LDB    ,U+
       JSR    $E803
       BNE    *-5     écran noir
       LDU    #0
       LDY    #$4000  effacement & copie
       LDD    ,X        en $4000 de la
CODCHG EORA   #$7B
       EORB   #$DE
       EXG    A,B
       STU    ,X++    suite du programme
       STD    ,Y++
       CMPX   #MYEND+$500
       BLO    CODCHG-2
       RTS
CHKIND LDD    #$63FF
       TFR    A,DP
       TFR    B,CC
       LDX    >$600A  FAB-Mon déjà actif
       CMPX   #$E000  => RESET à froid
       BHS    CHKIND-1
       STX    >$60FE
       JMP    $FDC8
MAPPRO LDU    #MYEND
       LDX    #$6300
       LDB    ,X+
       SUBB   ,U
       STB    ,U+
       CMPX   #MYEND
       BNE    *-9
       CMPU   #MYEND+$500
       BLO    MAPPRO+3
       RTS
       FDB    RETURN+$50
MYEND
       END
