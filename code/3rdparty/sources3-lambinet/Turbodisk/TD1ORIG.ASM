*************
*
* TURBODISK 1 RESSOURCé
*
*************

       ORG    $8000

DEBUT  LDX    #$6200
       LDU    #DEBUT
       STU    $604F
COP0   LDD    ,X++
       STD    ,U++
       CMPU   #DEBUT+256
       BCS    COP0
       LDD    #$0208
       STA    $6048
       BSR    LITSEC
       LDB    #$06
       BSR    LITSEC
       LDB    #$04
       BSR    LITSEC
       LDB    #$02
       BSR    LITSEC
       LDB    #$07
       BSR    LITSEC
       LDX    #PARA
       LDU    #$601A
COP1   LDA    ,X+
       BEQ    SUITE
       STA    ,U+
       BRA    COP1
PARA   FCB    $F0,9,$F0,1,$F0,17,19,0

       ORG    $8100

SUITE  LDA    $6019   initialisation du
       ORA    #$02    clavier pour TO9+
       STA    $6019   + cartouche AUTO
       LDB    #$F8
       JSR    $E806
       LDA    #$54
       STA    $E7E7
       STA    $6081
       LDX    $6004
       LDD    CONFIG  F9/FA
       STA    $60CD
       BITA   #$08
       BNE    TD00
       LEAX   -6,X
TD00   STX    $6000
       LEAX    3,X
       STX    $6002
       STB    $618C
       INCB
       STB    $6047
       STB    $E7E5
       INCB
       ORB    #$20
       STB    APPBK+1
       LDD    FACPIS  FD/FE face-piste
       DECA
       BNE    TD10
       INCB
       BRA    TD20
TD10   LDA    #$01
TD20   STA    $6049
       STB    $604B
NBANK  LDA    #$03
       STA    COMPT
       INC    $E7E5
       LDX    #$A000
NPIST  STX    BUFFER+1
       LEAX   $1556,X
       STX    COMPAR+1
       DEC    $6049
       BEQ    TD30
       DEC    $604B
       LDD    #$4001
       STD    $6048
TD30   JSR    $E09D
       JSR    $E0A7
       JSR    $E45A
       JSR    $E4A8
       LDB    ,Y
       LDA    <$57
       SUBB   <$4B
       BEQ    TD60
       BPL    TD40
       ORA    #$20
       NEGB
TD40   STA     2,X
TD50   ORA    #$14
       STA     2,X
       ANDA   #$EB
       STA     2,X
       JSR    $E165
       DECB
       BNE    TD50
TD60   LDY    #$6052
       LDA    <$49
       ANDA   #$02
       LEAY   A,Y
       LDB    <$4B
       STB     6,X
       STB    ,Y
       JSR    $E341
       LDB    #$18
       JSR    $E394
       LDA    #$E7
       TFR    A,DP
TD80   LDA    <$D1
       BITA   #$40
       BEQ    TD80
TD90   LDA    <$D3
       LDA    <$D0
       BPL    TD90
TD100  LDA    <$D0
       BPL    TD100
TD110  LDA    <$D3
TD120  LDA    <$D0
       BPL    TD120
       BITA   #$01
       BNE    TD110
BUFFER LDX    #$CAAC
       LDA    <$D3
TD130  LDA    <$D0
       BPL    TD130
       LDA    <$D3
       CMPA   #$FB
       BNE    TD130
TD140  LDA    <$D0
       BPL    TD140
       LDA    <$D3
       STA    ,X+
COMPAR CMPX   #$E002
       BNE    TD140
       CLR    <$D0
       LDA    #$40
       STA    <$D2
       LDX    COMPAR+1
       DEC    COMPT
       LBNE   NPIST
       DEC    NBREBK  FB=nombre de banks
       LBNE   NBANK
       LDA    FGLANC  FC=flag de lanceur
       LBEQ   GORAMD  LANCE RAM-DISK
       CLR    $6052
APPBK  LDA    #$28
       PSHS   A
       LDA    #$FF
       STA    $6080
       STA    $0003
       LDA    #$60
       TFR    A,DP
       JSR    $3FED
       PULS   A
       STA    $E7E6
       LDU    #$0000
       TFR    U,X
LA20   LDA    ,U+
       LEAX   A,X
       CMPU   #$0020
       BNE    LA20
       LEAX   $55,X
       LDA    $E7C3
       ORA    #$01
       STA    $E7C3
       STX    $5FC1
       LDU    $001E
       LDS    #$60CC
       LDA    #$02
       STA    $E7E5
       CLR    $60D1
       JMP    ,U


GORAMD LDA    #$06
       STA    $E7E5
       STA    $0001
       LDX    #$2000
       LDU    #$A000
RD2    LDD    ,X++
       STD    ,U++
       CMPX   #$4000
       BNE    RD2
       LDX    #$0000
RD3    LDD    ,X++
       STD    ,U++
       CMPX   #$2000
       BNE    RD3
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
       STA    $0000
       LDX    #$2000
       LDU    #$A000
RD4    LDD    ,X++
       STD    ,U++
       CMPX   #$4000
       BNE    RD4
       LDX    #$0000
RD5    LDD    ,X++
       STD    ,U++
       CMPX   #$2000
       BNE    RD5
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
       LDX    #RD7
       STB    $ABBC
       STX    $ABBD
       CLR    $607F
       CLR    $E7E4
       STA    $E7E6
       JMP    $2B52
RD7    CLR    $E7E6
       STA    $0000
       JMP    $2452
