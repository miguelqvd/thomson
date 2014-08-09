
****** **  ** *****  *****   ****
****** **  ** ****** ****** ******   *
  **   **  ** **  ** **  ** **  **  ***
  **   **  ** **  ** **  ** **  ** ** **
  **   **  ** *****  *****  **  ** ** **
  **   **  ** ****** *****  **  ** ** **
  **   **  ** **  ** **  ** **  ** ** **
  **   **  ** **  ** **  ** **  **  ***
  **   ****** **  ** ****** ******   *
  **    ****  **  ** *****   ****


       ORG    $8000

DEBUT  LDS    #$9FFF
       LDD    #$60F8
       TFR    A,DP
       LDA    <$19
       ORA    #2
       STA    <$19
       JSR    $E806
       LDA    #$65
       STA    $E7C3
       LDX    #$8000
       STX    <$4F
       LDY    #$6200
       CLRB
C0     LDA    ,Y+
       STA    ,X+
       DECB
       BNE    C0
       LDD    #$5494
       STA    $E7E7
       STA    <$81
       STB    <$CD
       LDD    #$0610
       STA    $618C
       INCA
       STA    <$47
       STB    $E7E5
       LDX    #C2
       LDU    #$601A
C1     LDA    ,X+
       STA    ,U+
       BNE    C1
       LDX    #C4
AFF    LDB    ,X+
       JSR    $E803
       BNE    AFF
       CLRA
       STA    <$49
       STA    <$4B
       INCA
       STA    <$4C
       INCA
       STA    <$48
       BSR    C3
       BSR    C3
       JMP    C5
C3     INC    <$4F
       INC    <$4C
       JMP    $E004
C2     FCB    $F0,9,$F0,1,$F0,$17,0

       ORG    $8080

C4     FCB    0

       ORG    $80F0

FACPIS FDB    $014F
NBBANK FCB    8
BANK1  FCB    7
FLGLE  FCB    255
FLGPB  FCB    0
FLGPAS FCB    0
COMPT  FCB    0
NESSAI FCB    0
SAVEX  FDB    0

*********** SECTEURS 2 ET 3 **********


       ORG    $8100

***  CHARGEMENT DES 1024 SECTEURS  ***

C5     LDX    #$9D00
       STX    <$4F
ZERO   CLR    ,-X
       CMPX   #$8CFF
       BHI    ZERO
NTRACK LDA    #$11
       STA    <$4C
       LDX    #$0201
       STX    <$48
       JSR    $E004
       LDX    #$9D00
       LEAY   -$100,X
       LDB    #6
DATE   LDA    ,X+
       CMPA   ,Y+
       BLO    SEC16
       BHI    COPY0
       DECB
       BNE    DATE
COPY0  LDX    #$9D00
       LEAY   -$100,X
       CLRB
COPY1  LDA    ,X+
       STA    ,Y+
       DECB
       BNE    COPY1
SEC16  DEC    <$4C
LIRSEC LDX    #$0201
       STX    <$48
       JSR    $E004
       TST    <$4E
       BEQ    ECRSEC
       LDX    #$FFF7
       STX    $9D00
       STX    $9D80
ECRSEC LDX    #$0804
       STX    <$48
       JSR    $E004
       DEC    <$4C
       BNE    LIRSEC
       INC    <$4B
       LDA    <$4B
       CMPA   #64
       BLO    NTRACK
       LDX    $9C00
       STX    <$7C
       LDA    $9C02
       STA    <$7E
       LDA    #$82
       STA    <$CD

*************  TURBO  ***********

       LDD    FACPIS
       DECA
       BNE    ADR01
       INCB
       BRA    ADR02
ADR01  LDA    #$01
ADR02  STA    $6049
       STB    $604B
       LDA    BANK1
       STA    $E7E5
       CLR    FLGPB
NBANK  LDA    #$03
       STA    COMPT
       INC    $E7E5
       LDX    #$A000
       STX    SAVEX
NPIST  DEC    $6049
       BEQ    ADR03
       DEC    $604B
       LDD    #$4001
       STD    $6048
ADR03  LDA    #$03
       STA    NESSAI
       CLR    FLGPAS
       LDX    SAVEX
       LEAX   $1556,X
       STX    COMPB+1
       ORCC   #$50
DEMAR  JSR    $E09D
       JSR    $E0A7
       JSR    $E452
       JSR    $E341
       LDB    #$18
       JSR    $E394
       LDA    #$E7
       TFR    A,DP
       LDY    #$0000
ADR04  LDA    <$D1
       BITA   #$40
       BEQ    ADR04
ADR05  LDA    <$D3
       LDA    <$D0
       BPL    ADR05
ADR06  LDA    <$D0
       BPL    ADR06
LIRE   LDA    <$D3
ADR16  LDA    <$D0
       BPL    ADR16
       BITA   #$01
       BNE    LIRE
       CLRB
       LDX    SAVEX
       LDA    <$D3
ADR17  LDA    <$D0
       BPL    ADR17
       LDA    <$D3
       CMPA   #$FB
       BEQ    ADR18
       DECB
       BNE    ADR17
       BRA    ERROR
ADR18  LDA    <$D0
       BPL    ADR18
       LDA    <$D3
       STA    ,X+
       LEAY   A,Y
COMPB  CMPX   #$E002
       BNE    ADR18
       TFR    Y,D
ADR19  TST    <$D0
       BPL    ADR19
       CMPA   <$D3
       BNE    ERROR
ADR20  TST    <$D0
       BPL    ADR20
       CMPB   <$D3
       BEQ    ADR21
ERROR  DEC    NESSAI
       LBNE   DEMAR
       LDA    #$FF
       STA    FLGPB
ADR21  CLR    <$D0
       LDA    #$40
       STA    <$D2
       LDX    COMPB+1
       STX    SAVEX
       DEC    COMPT
       LBNE   NPIST
       DEC    NBBANK
       LBNE   NBANK


********** LANCEUR **********


       LDD    #$6006
       TFR    A,DP
       STB    $E7E5
       STB    >$0001
       LDX    #$9C00
       STX    <$4F
       LDX    #$0804
       STX    <$48
       LDX    #$1401
       STX    <$4B
       JSR    $E004
       LDX    #$2000
       LDU    #$A000
L0     LDD    ,X++
       STD    ,U++
       CMPX   #$4000
       BNE    L0
       LDX    #$0000
L1     LDD    ,X++
       STD    ,U++
       CMPX   #$2000
       BNE    L1
       LDD    #$1212
       STA    $C021
       STD    $C022
       LDA    #$7A
       STA    $C026
       LDD    #$E7E6
       STD    $C027
       LDD    #$6301
       STD    $C19C
       DEC    $E7E5
       STA    >$0000
       LDX    #$2000
       LDU    #$A000
L2     LDD    ,X++
       STD    ,U++
       CMPX   #$4000
       BNE    L2
       LDX    #$0000
L3     LDD    ,X++
       STD    ,U++
       CMPX   #$2000
       BNE    L3
       LDA    #$7C
       STA    $C021
       LDD    #$E7E6
       STD    $C022
       LDD    #$1212
       STA    $C026
       STD    $C027
       LDD    #$847E
       STA    $AB7D
       LDA    #$25
       LEAX   GO,PCR
       STB    $ABBC
       STX    $ABBD
       CLR    $607F
       CLR    $E7E4
       STA    $E7E6
       JMP    $2B52
GO     CLR    $E7E6
       STA    >$0000
       JMP    $2452
FIN    NOP

**********************************

       END
