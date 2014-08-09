* LECTURE D'UNE IMAGE RAW
* SOURCE :
* 320X200 16 COULEURS
* DESTINATION :
* 160X200 16 COULEURS (BITMAP 16)
*
* COPYRIGHT (C) HOME SOFT 1992

       ORG    $9000

PUTC   EQU    $E803
EXTRA  EQU    $EC0C
DKDRV  EQU    $6049
OPEN   EQU    03
FILMOD EQU    $624B
FILNAM EQU    $624F
INPUT  EQU    05
CARCOU EQU    $6196
EOFFLG EQU    $6178
CLOSE  EQU    06
PRC    EQU    $E7C3

START  PSHS   A,B,X,Y,U,DP,CC
       LDB    #$1B
       JSR    PUTC
       LDB    #$5E
       JSR    PUTC
       LDB    #$14
       JSR    PUTC
       CLR    $E7DD

       CLR    DKDRV
       LDB    #$10
       STB    FILMOD
       LDX    #FILNAM
       LDU    #NAME
NA2    LDB    ,U+
       BEQ    NA1
       STB    ,X+
       BRA    NA2

NA1    LDB    #OPEN
       JSR    EXTRA

       LDX    #$4000
       LDA    PRC
       ANDA   #254
       STA    PRC

LI11   LDB    #INPUT
       JSR    EXTRA
       TST    EOFFLG
       LBNE   STP
       INC    PRC
       LDA    CARCOU
       LDB    ,X
       LSLA
       LSLA
       BCC    LI12
       ORB    #$10
       BRA    LI13
LI12   ANDB   #$EF
LI13   LSLA
       LSLA
       BCC    LI14
       ORB    #$01
       BRA    LI15
LI14   ANDB   #$FE
LI15   STB    ,X
       DEC    PRC
       LDB    ,X
       LSLA
       LSLA
       BCC    LI16
       ORB    #$10
       BRA    LI17
LI16   ANDB   #$EF
LI17   LSLA
       LSLA
       BCC    LI18
       ORB    #$01
       BRA    LI19
LI18   ANDB   #$FE
LI19   STB    ,X+
       CMPX   #$5F40
       BLO    LI11

       LDX    #$4000

LI21   LDB    #INPUT
       JSR    EXTRA
       TST    EOFFLG
       LBNE   STP
       INC    PRC
       LDA    CARCOU
       LDB    ,X
       LSLA
       LSLA
       BCC    LI22
       ORB    #$20
       BRA    LI23
LI22   ANDB   #$DF
LI23   LSLA
       LSLA
       BCC    LI24
       ORB    #$02
       BRA    LI25
LI24   ANDB   #$FD
LI25   STB    ,X
       DEC    PRC
       LDB    ,X
       LSLA
       LSLA
       BCC    LI26
       ORB    #$20
       BRA    LI27
LI26   ANDB   #$DF
LI27   LSLA
       LSLA
       BCC    LI28
       ORB    #$02
       BRA    LI29
LI28   ANDB   #$FD
LI29   STB    ,X+
       CMPX   #$5F40
       BLO    LI21

       LDX    #$4000

LI31   LDB    #INPUT
       JSR    EXTRA
       TST    EOFFLG
       LBNE   STP
       INC    PRC
       LDA    CARCOU
       LDB    ,X
       LSLA
       LSLA
       BCC    LI32
       ORB    #$40
       BRA    LI33
LI32   ANDB   #$BF
LI33   LSLA
       LSLA
       BCC    LI34
       ORB    #$04
       BRA    LI35
LI34   ANDB   #$FB
LI35   STB    ,X
       DEC    PRC
       LDB    ,X
       LSLA
       LSLA
       BCC    LI36
       ORB    #$40
       BRA    LI37
LI36   ANDB   #$BF
LI37   LSLA
       LSLA
       BCC    LI38
       ORB    #$04
       BRA    LI39
LI38   ANDB   #$FB
LI39   STB    ,X+
       CMPX   #$5F40
       BLO    LI31

       LDX    #$4000

LI41   LDB    #INPUT
       JSR    EXTRA
       TST    EOFFLG
       LBNE   STP
       INC    PRC
       LDA    CARCOU
       LDB    ,X
       LSLA
       LSLA
       BCC    LI42
       ORB    #$80
       BRA    LI43
LI42   ANDB   #$7F
LI43   LSLA
       LSLA
       BCC    LI44
       ORB    #$08
       BRA    LI45
LI44   ANDB   #$F7
LI45   STB    ,X
       DEC    PRC
       LDB    ,X
       LSLA
       LSLA
       BCC    LI46
       ORB    #$80
       BRA    LI47
LI46   ANDB   #$7F
LI47   LSLA
       LSLA
       BCC    LI48
       ORB    #$08
       BRA    LI49
LI48   ANDB   #$F7
LI49   STB    ,X+
       CMPX   #$5F40
       BLO    LI41

       CLR    COUL
A0     LDB    #INPUT
       JSR    EXTRA
       TST    EOFFLG
       BNE    STP
       LDA    CARCOU
       STA    ROUGE
       LDB    #INPUT
       JSR    EXTRA
       TST    EOFFLG
       BNE    STP
       LDA    CARCOU
       ANDA   #$F0
       STA    VERT
       LDA    CARCOU
       ANDA   #$0F
       STA    BLEU

       LDA    COUL
       ASLA
       STA    $E7DB
       LDA    BLEU
       LDB    VERT
       ORB    ROUGE
       STB    $E7DA
       STA    $E7DA

       INC    COUL
       LDB    COUL
       CMPB   #16
       BLO    A0

STP    LDB    #CLOSE
       JSR    EXTRA
       PULS   A,B,X,Y,U,DP,CC,PC

NAME   FCC    "        RAW"
       FCB    0
COUL   RMB    1
ROUGE  RMB    1
VERT   RMB    1
BLEU   RMB    1

       END
