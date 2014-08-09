

L6300  SET    $7300
L6280  SET    $7280
L4C    SET    $604C
L4F    SET    $604F
L49    SET    $6049
L48    SET    $6048
L4B    SET    $604B
L4A    SET    $604A
L4D    SET    $604D
L4E    SET    $604E
LE004  SET    $E004

       ORG    $9000
BOOT
       ORCC   #$50
       LDD    #9
       STD    L4B
       STB    L4C
       BSR    AUDIS
LOUP
       BSR    LECT
       PSHS   B
       BSR    LECT
       TFR    B,A
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
       CMPU   #L6300
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
       LDU    #L6280
       STU    L4F
       CLR    L4A
       CLR    L4D
       CLR    L4E
       CLR    L49
       LDA    #2
       STA    L48
       JMP    LE004
FBOOT
