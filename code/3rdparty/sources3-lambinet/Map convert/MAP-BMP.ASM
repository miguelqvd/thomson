****************************************
*                                      *
* TRANSCODEUR D'IMAGES TO.MAP > PC.BMP *
*                                      *
* par Michel SAINT-BRIANT * 15/03/1992 *
*                                      *
* (c)    A.S.C.I.    Copyright    1992 *
*                                      *
****************************************

* TRANSFERT D'UNE IMAGE THOMSON EN UNE
* IMAGE AU FORMAT PC-WINDOWS -> .BMP

       ORG    $9800

       PSHS   A,B,CC,DP,X,Y,U


       LDB    #$14    ARRET CLIGNOTEMENT
       JSR    $E803

       LDX    #FILE
       LDA    ,X++
       SUBA   #$30
       STA    $6049
       LDU    #$624B
       LDD    #$2003
       STD    ,U++
       LDA    #$FF
       STA    ,U++
       LDB    #8
COPS   LDA    ,X+
       STA    ,U+
       DECB
       BNE    COPS
       LDD    #$424D  'BM'
       STD    ,U++
       LDD    #$5009  'P'+8 octets
COPC   STA    ,U+
       LDA    ,X+
       DECB
       BNE    COPC

       LDB    #3      CODE DE OPEN
       JSR    $EC0C   OUVERTURE
       LDX    #ENTETE
       LDY    #30
COPEN0 LDA    ,X+
       LDB    #4
       JSR    $EC0C
       LEAY   -1,Y
       BNE    COPEN0
       LDY    #24
COPEN1 CLRA
       LDB    #4
       JSR    $EC0C
       LEAY   -1,Y
       BNE    COPEN1
       LDX    #PALETT
       LDY    #64
COPEN2 LDA    ,X+
       LDB    #4
       JSR    $EC0C
       LEAY   -1,Y
       BNE    COPEN2
       LDX    #$5F18
       STX    ADDRES
       LDA    MODE
       BEQ    MODTO7
       CMPA   #2
       LBEQ   MODBM4
       CMPA   #3
       LBEQ   MODB16
       LBRA   QUITTE

MODTO7 LDY    #$0028
OCTET  LDA    $E7C3
       ANDA   #$FE
       STA    $E7C3
       LDA    ,X
       BITA   #$40
       BEQ    OCTET0
       ANDA   #$38
       BRA    OCTET1
OCTET0 ORA    #$40
OCTET1 ANDA   #$78
       ASLA
       STA    FORM0+1
       LSRA
       LSRA
       LSRA
       LSRA
       STA    FORM1+1
       LDA    ,X
       ANDA   #$07
       TST    ,X
       BMI    OCTET2
       ORA    #$08
OCTET2 STA    FOND1+1
       ASLA
       ASLA
       ASLA
       ASLA
       STA    FOND0+1
       LDA    $E7C3
       ORA    #$01
       STA    $E7C3
       LDB    #4
       LDA    ,X+
       PSHS   A,B
FORM0  LDA    #$00
       ASL    ,S
       BCS    POINT0
FOND0  LDA    #$00
POINT0 ASL    ,S
       BCC    FOND1
FORM1  ORA    #$00
       BRA    POINT1
FOND1  ORA    #$00
POINT1 LDB    #4
       JSR    $EC0C
       DEC    1,S
       BNE    FORM0
       PULS   A,B
       LEAY   -1,Y
       BNE    OCTET
       LDX    ADDRES
       CMPX   #$4000
       LBLE   QUITTE
       LEAX   -$28,X
       STX    ADDRES
       BRA    MODTO7

MODBM4 LDY    #$0028
OCBM40 LDA    $E7C3
       ANDA   #$FE
       STA    $E7C3
       LDD    ,X
       PSHS   A,B
       LDA    $E7C3
       ORA    #$01
       STA    $E7C3
       LDD    ,X++
       PSHS   A,B
       LDA    #8
       PSHS   A
OCBM41 ASL    1,S
       ROLA
       ASL    3,S
       ROLA
       LSLA
       LSLA
       ASL    2,S
       ROLA
       ASL    4,S
       ROLA
       LSLA
       LSLA
       LDB    #4
       JSR    $EC0C
       DEC    ,S
       BNE    OCBM41
       PULS   CC,A,B,U
       LEAY   -2,Y
       BNE    OCBM40
       LDX    ADDRES
       CMPX   #$4000
       LBLE   QUITTE
       LEAX   -$28,X
       STX    ADDRES
       BRA    MODBM4

MODB16 LDY    #$0028
OCBM16 LDA    $E7C3
       ORA    #$01
       STA    $E7C3
       LDA    ,X
       TFR    A,DP
       ANDA   #$F0
       STA    ,X
       LSRA
       LSRA
       LSRA
       LSRA
       ORA    ,X
       LDB    #4
       JSR    $EC0C
       TFR    DP,A
       ANDA   #$0F
       STA    ,X
       ASLA
       ASLA
       ASLA
       ASLA
       ORA    ,X
       LDB    #4
       JSR    $EC0C
       LDA    $E7C3
       ANDA   #$FE
       STA    $E7C3
       LDA    ,X
       TFR    A,DP
       ANDA   #$F0
       STA    ,X
       LSRA
       LSRA
       LSRA
       LSRA
       ORA    ,X
       LDB    #4
       JSR    $EC0C
       TFR    DP,A
       ANDA   #$0F
       STA    ,X
       ASLA
       ASLA
       ASLA
       ASLA
       ORA    ,X+
       LDB    #4
       JSR    $EC0C
       LEAY   -1,Y
       BNE    OCBM16
       LDX    ADDRES
       CMPX   #$4000
       LBLE   QUITTE
       LEAX   -$28,X
       STX    ADDRES
       BRA    MODB16

QUITTE LDB    #6      CLOSE
       JSR    $EC0C
       PULS   A,B,DP,CC,X,Y,U,PC

ADDRES FDB    0
ENTETE FDB    $424D,$7680,0,0,0,$7600
       FDB    0,$2800,0,$4001,0,$C800
       FDB    0,$0100,$0400
PALETT RMB    64
MODE   FCB    1
FILE   FCC    #4:IMAGE   #
COMMEN FCC    #MAP>>BMP#

       END
