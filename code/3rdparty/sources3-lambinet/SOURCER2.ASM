
****************************************
*SOURCER II (RECALCUL DES ETIQUETTES ***
****************************************




       ORG    $8000

       PSHS   A,B,CC,DP,X,Y,U
G      LDX    #FILE
       LDU    #$624F
       LDB    #11
COP    LDA    ,X+
       STA    ,Y+
       DECB
       BNE    COP
       LDD    #$0440
       STA    $6049   RAMDISK
       STB    $624B   ACCES DIRECT
       LDX    #35     LONGUEUR DES (41)
       STX    $6247   ENREGISTREMENTS
       LDB    #3      CODE DE OPEN
       JSR    $EC0C   OUVERTURE
       LDX    #0
       STX    PTRP    POINTEUR PRINCIPAL
       LDX    #BUFFER DECLARATION D'UN
       STX    $62AA   BUFFER

*ANALYSE D'UNE NOUVELLE LIGNE

NEWLIN LDX    PTRP
       LEAX   1,X
       STX    PTRP
       CMPX   FINPTR  DERNIER ENREGISTR.
       LBHI   FIN
       CLR    EXIST   FLAG D'EXISTENCE
       CLR    $6249   GET
       LDB    #7
       JSR    $EC0C
       LDX    #BUFFER
       LDY    #NUMERO
       LDU    #NBHEX0
       LDA    ,X+
       STA    ,U+
       CMPA   #$24    SI CE N'EST PAS UN
       BNE    NEWLIN  $ ->NOUVELLE LIGNE
       LDA    ,X+
       SUBA   #$30    SI MOINS DE ZERO
       BMI    NEWLIN  -->  PAS BON
       CMPA   #$A     SI MOINS DE 10
       BLO    CHIF1   --> ON PREND
       CMPA   #$11    SI >9 ET <A
       BLO    NEWLIN  --> PAS BON
       SUBA   #7
       CMPA   #15     SI PLUS DE 15
       BHI    NEWLIN  --> PAS BON
CHIF1  ASLA
       ASLA
       ASLA
       ASLA
       STA    ,Y
       LDA    ,X+
       STA    ,U+
       SUBA   #$30
       BMI    NEWLIN
       CMPA   #$A
       BLO    CHIF2
       CMPA   #$11
       BLO    NEWLIN
       SUBA   #7
       CMPA   #15
       BHI    NEWLIN
CHIF2  ORA    ,Y
       STA    ,Y
       LDA    ,X+
       STA    ,U+
       CMPA   #$24
       BNE    NEWLIN
       LDA    ,X+
       SUBA   #$30
       BMI    NEWLIN
       CMPA   #$A
       BLO    CHIF3
       CMPA   #$11
       BLO    NEWLIN
       SUBA   #7
       CMPA   #15
       BHI    NEWLIN
CHIF3  ASLA
       ASLA
       ASLA
       ASLA
       STA    1,Y
       LDA    ,X+
       STA    ,U+
       SUBA   #$30
       LBMI   NEWLIN
       CMPA   #$A
       BLO    CHIF4
       CMPA   #$11
       LBLO   NEWLIN
       SUBA   #7
       CMPA   #15
       LBHI   NEWLIN
CHIF4  LDX    #NUMERO
       ORA    1,Y
       STA    1,Y
NWNBRE LDX    ,Y
       LEAX   1,X
       STX    ,Y
       CLRB
NWDIGI LDA    B,Y
       LSRA
       LSRA
       LSRA
       LSRA
       ADDA   #$30
       CMPA   #$3A
       BLO    HEX
       ADDA   #7
HEX    STA    ,U+
       INCB
       CMPB   #4
       BLO    NWDIGI
       CMPU   #ETIQ
       BLO    NWNBRE
       LDX    #0
       STX    PTRS

*RECHERCHE DU NBRE 'NBHEXA' DANS LES
*AUTRES LIGNES

AUTLIN LDX    PTRS
       LEAX   1,X
       STX    PTRS
       CMPX   FINPTR  DERNIER ENREGISTR.
       BHI    FINLIN
*      CLR    $6249   GET
       LDB    #7
       JSR    $EC0C
       LDX    #BUFFER+19
       LDU    #NBHEX3+3
       LDB    #3
       LDA    ,X
TYPE   CMPA   ,U
       BEQ    TEST
       LEAU   4,U
       DECB
       BPL    TYPE
       BRA    NONEGA
TEST   LDA    ,-X
       CMPA   ,-U
       BNE    NONEGA
       CMPX   #BUFFER+16
       BHI    TEST
       STA    EXIST
       LDU    #ETIQ
       TSTB           SI B=0 NBRE
       BNE    DECALE  SINON NBRE+B
       LDB    #5
COP0   LDA    ,U+
       STA    ,X+
       DECB
       BNE    COP0
       BRA    RECRIT
DECALE PSHS   B
       LDD    #$3D05  '='
       LDX    #BUFFER+22   (PUIS29)
       STA    ,X+
COP1   LDA    ,U+
       STA    ,X+
       DECB
       BNE    COP1
       LDA    #$2B    '+'
       PULS   B
       ADDB   #$30
       STD    ,X
RECRIT LDD    #$FF07
       STA    $6249
       LDX    PTRS
       JSR    $EC0C
NONEGA LBRA   AUTLIN

* EN FIN DE LIGNE ON TESTE LE FLAG

FINLIN TST    EXIST
       BEQ    REPART
       LDX    PTRP
       LDD    #$0007
       STA    $6249
       JSR    $EC0C
       LDX    #BUFFER
       LDU    #ETIQ
       LDB    #5
COP2   LDA    ,U+
       STA    ,X+
       DECB
       BNE    COP2
       LDX    PTRP
       LDD    #$FF07
       STA    $6249
       JSR    $EC0C
       LDD    ETIQ+3
       ADDB   PAS+1
       STB    ETIQ+4
       CMPB   #$3A
       BLO    RETIQ1
       SUBB   #10
       STB    ETIQ+4
       INCA
RETIQ1 ADDA   PAS
       STA    ETIQ+3
       CMPA   #$3A
       BLO    REPART
       SUBA   #10
       STA    ETIQ+3
       LDD    ETIQ+1
       INCB
       CMPB   #$3A
       BLO    RETIQ2
       SUBB   #10
       INCA
       CMPA   #$3A
       BEQ    TOOBIG
RETIQ2 STD    ETIQ+1
REPART LBRA   NEWLIN

TOOBIG


FIN    LDB    #6
       JSR    $EC0C
K      PULS   A,B,DP,CC,X,Y,U,PC

PTRP   FDB    0
PTRS   FDB    0
FINPTR FDB    0
NUMERO FDB    0
EXIST  FCB    0
NBHEX0 FCC    #ABCD#
NBHEX1 FCC    #ABCD#
NBHEX2 FCC    #ABCD#
NBHEX3 FCC    #ABCD#
ETIQ   FCC    #E0000#
PAS    FCB    1,0
FILE   FCC    #ESSAI   ASM#
BUFFER RMB    50



       END
