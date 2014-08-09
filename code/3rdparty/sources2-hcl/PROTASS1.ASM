****************************************
*                                      *
*                                      *
*                                      *
*                                      *
*         PROTECTION ASSDESAS          *
*                                      *
*                                      *
*                                      *
*                                      *
****************************************

L4D    EQU    $604D
L4B    EQU    $604B
L4E    EQU    $604E


DEBUT  LDX    #NOM
       LDB    #8+2+3
       LDU    #FPDE1
       JSR    NET1
       CLRA
       JSR    OPELEC
       LBCS   SERR
       CLR    BLO
       LDX    #BUF1
       STX    BUF
       LDD    #$0009
       STD    PISEC

LOOP   CLRA
       JSR    LEC
       LBCS   SERR
       JSR    ECRO
       TST    LF0
       BNE    LOOP
       JSR    CLOSO
       JMP    PBOOT

NOM    FCC    /DFBIN/
       FDB    $200
BUF    RMB    2
BLO    RMB    1
PISEC  RMB    2
BUF1   RMB    256

ECRO   PSHS   A,B,X
       LDX    BUF
       STB    ,X+
       STX    BUF
       INC    BLO
       BNE    ECR1
       FCB    $F5
CLOSO  PSHS   A,B,X
       CLR    BLO
       LDX    #BUF1
       STX    BUF
       STX    L4F
       CLR    L49
       LDD    PISEC
       STD    $604B
       LDB    #8
       STB    L48
       JSR    LE004
       BCS    SERR
       LDD    PISEC
       CMPB   #16
       BLO    REC5
       CLRB
       INCA
REC5   INCB
       STD    PISEC

ECR1   PULS   A,B,X,PC

SERR
       LDB    #'E
       JSR    $E803
       SWI


       INCLUD SED

PBOOT  LDX    #BOOT
       LDU    #BUF1
       LDB    #FBOOT-BOOT
       JSR    NET1
       LDX    #BUF1
       LDA    #$55
INU    ADDA   ,X
       COM    ,X
       INC    ,X+
       CMPX   #BUF1+127
       BNE    INU
       STA    ,X
       LDX    #BUF1
       STX    L4F
       LDA    #8
       STA    L48
       LDD    #001
       STD    $604B
       JSR    LE004
       LBCS   SERR
       SWI
BOOT
       LDD    #9
       STD    L4B
       STB    L4C
       BSR    AUDIS
LOUP
       BSR    LECT
       TFR    A,B
       BSR    LECT
       TFR    D,Y
       BSR    LECT
       TFR    B,A
       BSR    LECT
       TFR    D,X
       LDA    ,S+
       BNE    BNI
LO
       BSR    LECT
       STB    ,X+
       LEAY   -1,Y
       BNE    LO
       BRA    LOUP
UI0
       LDB    #12
       JSR    $E803
       LDB    #'E
       JSR    $E803
       BRA    *

BNI    JMP    ,X

LECT
       LDB    ,U+
       CMPU   #$6300
       BNE    LOP10
       PSHS   A,B
       LDA    L4B
       LDB    L4C
       CMPB   #16
       BNE    LYP6
       INCA
       CLRB
LYP6
       INCB
       STA    L4B
       STB    L4C
       BSR    AUDIS
       PULS   A,B
LOP10  RTS
AUDIS
       LDU    #$6280
       STU    L4F
       CLR    L4A
       CLR    L4D
       CLR    L4E
       CLR    L49
       LDA    #2
       STA    L48
       JMP    LE004
FBOOT





       END
