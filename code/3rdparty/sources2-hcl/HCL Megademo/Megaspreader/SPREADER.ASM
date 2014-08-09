****************************************
*                                      *
* MEGADEMO SPREADER: 640Ko EN 3 PASSES *
*                                      *
****************************************
* Bâclé par un Doctor Lô très pressé ! *


FONTE  EQU    $7770
MESG   EQU    $7A70
MAP2   EQU    MAP+$2A6
CHECKS EQU    $B980    B900= sector 53-1
COULR  EQU    $3E3E
COULW  EQU    $2C2C
CART   EQU    13
       ORG    $7C00

G      ORCC   #80
       LDA    #$E7
       EXG    A,DP
       STA    RDP+1
       STS    RDP-2
       LDD    #32
       STA    <$DB
       STA    <$DA
       DECB
       BNE    *-3
       LDA    #$21
       STA    <$DC
       CLR    <$DD
       LDA    <$C3
       ORA    #1
       STA    <$C3
       LDX    #$4000
       CLR    ,X+
       CMPX   #$5F40
       BNE    *-5
       DEC    <$C3
       CLR    ,-X
       CMPX   #$4000
       BNE    *-5
       LDX    #MAP
       STX    $616B
       LDD    #$FF0E
       STA    $6249
       STB    $616D
       LDD    #$60B
       STD    $61D6
       CLR    $6288
       LDB    #69
       JSR    $EC0C
       LDA    #255
       LDX    #COLORS-40
       JSR    $EC00
       LDA    <$CD
       BITA   #64
       BNE    *-4
       LDD    #32
       STA    <$DB
       STA    <$DA
       DECB
       BNE    *-3
       STB    <$DC
       LDX    #MAP2
       STX    $616B
       LDD    #$FF0E
       STA    $6249
       STB    $616D
       LDD    #$100
       STD    $61D6
       CLR    $6288
       LDB    #69
       JSR    $EC0C

       LDA    <$C3
       ORA    #1
       STA    <$C3
       LDX    #CHECKS
       LDY    #PRINT-3
       LDS    #$5D20
       TST    8,X
       BEQ    PACHEK
       LDB    #$26
       STB    TCHEK
       LDD    9,X
       STD    -3,Y
       LDA    11,X
       STA    -1,Y

PACHEK LDA    #8
       STA    ,Y
       LDB    ,X+
       LDA    #5
       MUL
       LDU    #FONTE+32
       LEAU   D,U
       LDD    ,U++
       STA    80,S
       STB    40,S
       LDD    ,U++
       STA    ,S+
       STB    -41,S
       LDA    ,U
       STA    -81,S
       DEC    ,Y
       BNE    PACHEK+4
       LDS    RDP-2
       LDA    #255
       LDX    #COLORS-32
       JSR    $EC00

       LDA    #$60
       TFR    A,DP
       CLR    <$49
       CLR    <$50
       LDD    #$301
       JSR    PRINT
CLAV   JSR    $E806
       CMPB   #48
       BLO    CLAV
       CMPB   #57
       BHI    CLAV
       SUBB   #48
       LBEQ   RDP-4
       STB    PRINT-2

       LDD    #$9002
       LDX    #0
       LDY    #$4504
       JSR    DISK
       LDX    #$9000
       JSR    CHECK

       LDA    PRINT-2
WRITE1 STA    PRINT-3
       ADDA   #16
       STA    MESG+276
       LDD    #$9008
       LDX    #0
       LDY    #$4504
       JSR    DISK
       LDA    PRINT-3
       DECA
       BNE    WRITE1

       LDD    #$8002
       LDX    #53
       LDY    #$4D4C
       JSR    DISK
       LDX    #$8100  checksector = 8000
       JSR    CHECK

       JSR    COMPT
       LDA    PRINT-2
WRITE2 STA    PRINT-3
       ADDA   #16
       STA    MESG+276
       LDD    #$8008
       LDX    #53
       LDY    #$4D4C
       CLR    <$49
       JSR    DISK
       LDA    PRINT-3
       DECA
       BNE    WRITE2

       LDD    #$9002
       LDX    #27
       LDY    #$55BC
       JSR    DISK
       LDX    #$9000
       JSR    CHECK

       LDA    PRINT-2
WRITE3 STA    PRINT-3
       ADDA   #16
       STA    MESG+276
       LDD    #$9008
       LDX    #27
       LDY    #$55BC
       JSR    DISK
       LDA    PRINT-3
       DECA
       BNE    WRITE3

       CLR    <$49
       JMP    QUIT

DISK   PSHS   A,B,X,Y
       CMPB   #2
       BEQ    READ
       LDD    #$600
       JSR    PRINT
       LDD    #$201
       JSR    PRINT
       JSR    ACTION
       LDD    #0
       JSR    PRINT
       LDD    #$701
       JSR    PRINT
       LDU    #COULW
       BRA    JOIN
READ   LDD    #$400
       JSR    PRINT
       LDD    #$201
       JSR    PRINT
       JSR    ACTION
       LDD    #0
       JSR    PRINT
       LDD    #$501
       JSR    PRINT
       LDU    #COULR
JOIN   PULS   Y,X,B,A
       STB    <$48
       STX    <$4A
       LDB    #2
       STB    $E7E5
       LDB    #1
       STB    <$4C
       STA    <$4F
CHARGE TST    $E7C8
       BEQ    *+5
       JMP    RDP-4
       JSR    $E004
       BCS    ERROR
       STU    ,Y++
       INCB
       CMPB   #17
       BNE    GOON+2
       LDB    #1
       LEAY   8,Y
       LEAX   1,X
       CMPX   #80
       BNE    GOON
       LDX    #0
       LDB    <$49
       EORB   #1
       LDX    #0
       STB    <$49
GOON   STX    <$4A
       STB    <$4C
       INCA
       STA    <$4F
       CMPA   #$E0
       BNE    CHARGE
       LDA    $E7E5
       INCA
       CMPA   #CART
       BNE    *+3
       INCA
       CMPA   #16
       BEQ    *+9
       STA    $E7E5
       LDA    #$A0
       BRA    CHARGE-2
       RTS

ERROR  LDB    <$4E
       CMPB   #2
       BEQ    CHARGE
       LDX    #COLORS+32
       LDU    #MESG+387
       LSRB
       LSRB
       LSRB
       LSRB
       LDA    B,X
       LDB    <$4E
       ANDB   #15
       LDB    B,X
       STD    ,U++
       LDB    <$48
       LDA    B,X
       LDB    <$49
       LDB    B,X
       STD    ,U++
       LDB    <$4B
       LSRB
       LSRB
       LSRB
       LSRB
       LDA    B,X
       LDB    <$4B
       ANDB   #15
       LDB    B,X
       STD    ,U++
       LDB    <$4C
       LSRB
       LSRB
       LSRB
       LSRB
       LDA    B,X
       LDB    <$4C
       ANDB   #15
       LDB    B,X
       STD    ,U
       LDD    #$900
       JSR    PRINT
QUIT   LDD    #$101
       JSR    PRINT
       TST    $E7C8
       BEQ    *-3
       LDS    #0
RDP    LDA    #0
       TFR    A,DP
       LDA    #255
       LDX    #COLORS
       JSR    $EC00
       RTS
       FDB    0,15,2,6
       FDB    0,$FD0,$FB0,$F90,$F70,$F50
       FDB    $F30,4095,$666,$222,5,10
       FDB    $500,$A00,$50,$A0
COLORS FDB    0,15,240,255,3840,3855
       FDB    4080,4095,1911,826,931
       FDB    938,2611,2618,3815,123
       FDB    $1011,$1213,$1415,$1617
       FDB    $1819,$2122,$2324,$2526
       FDB    0,0,0
PRINT  LDX    #MESG
       LDU    #$4078
       TSTB
       BEQ    *+5
       LDU    #$41B8
       LDB    #40
       MUL
       LEAY   D,X
       LDA    #40
       STA    PRINT-1
       LDA    $E7C3
       ORA    #1
       STA    $E7C3

CHAR   LDB    ,Y+
       LDA    #8
       MUL
       LDX    #FONTE
       LEAX   D,X
       LDD    ,X++
       STA    160,U
       STB    120,U
       LDD    ,X++
       STA    80,U
       STB    40,U
       LDD    ,X++
       STA    ,U+
       STB    -41,U
       LDD    ,X
       STA    -81,U
       STB    -121,U
       DEC    PRINT-1
       BNE    CHAR
       DEC    $E7C3
       RTS
ACTION LDA    $E7CD
       BITA   #64
       BNE    ACTION
       RTS
CHECK  LDD    #2
       STB    $E7E5
       ADDA   ,X+
       CMPX   #$E000
       BNE    *-5
       LDX    #$A000
       INCB
       CMPB   #CART
       BNE    *+3
       INCB
       CMPB   #16
       BNE    CHECK+3
       CMPA   PRINT-6
TCHEK  LDA    #4      -> BNE   *+6
       INC    *-3
       RTS
       LDD    #$800
       JSR    PRINT
       JMP    QUIT
COMPT  LDX    #$8088
       LDA    ,-X
       INCA
       CMPA   #10
       BNE    *+9
       CLR    ,X
       CMPX   #$8000
       BNE    COMPT+3
       STA    ,X
       RTS
MAP
       END
