****************************************
*Conversion du BITMAP4 spécial en plans*
****************************************

       ORG    $9E00
DIR    EQU    $9E
Z      EQU    $DE

G      PSHS   U,Y,X,DP,B,A,CC
       ORCC   #80
       LDA    #DIR
       TFR    A,DP
       CLR    $E7E5

       LDU    #$A000
       LDX    #$C000

CONVER CLR    <Z
       CLR    <Z+1

       LDD    #$8080
       BITA   ,X
       BEQ    *+6
       ORB    <Z+1
       STB    <Z+1
       LDD    #$4080
       BITA   ,X
       BEQ    *+6
       ORB    <Z
       STB    <Z
       LDD    #$2040
       BITA   ,X
       BEQ    *+6
       ORB    <Z+1
       STB    <Z+1
       LDD    #$1040
       BITA   ,X
       BEQ    *+6
       ORB    <Z
       STB    <Z
       LDD    #$0820
       BITA   ,X
       BEQ    *+6
       ORB    <Z+1
       STB    <Z+1
       LDD    #$0420
       BITA   ,X
       BEQ    *+6
       ORB    <Z
       STB    <Z
       LDD    #$0210
       BITA   ,X
       BEQ    *+6
       ORB    <Z+1
       STB    <Z+1
       LDD    #$0110
       BITA   ,X
       BEQ    *+6
       ORB    <Z
       STB    <Z

       LDD    #$8008
       BITA   ,U
       BEQ    *+6
       ORB    <Z+1
       STB    <Z+1
       LDD    #$4008
       BITA   ,U
       BEQ    *+6
       ORB    <Z
       STB    <Z
       LDD    #$2004
       BITA   ,U
       BEQ    *+6
       ORB    <Z+1
       STB    <Z+1
       LDD    #$1004
       BITA   ,U
       BEQ    *+6
       ORB    <Z
       STB    <Z
       LDD    #$0802
       BITA   ,U
       BEQ    *+6
       ORB    <Z+1
       STB    <Z+1
       LDD    #$0402
       BITA   ,U
       BEQ    *+6
       ORB    <Z
       STB    <Z
       LDD    #$0201
       BITA   ,U
       BEQ    *+6
       ORB    <Z+1
       STB    <Z+1
       LDD    #$0101
       BITA   ,U
       BEQ    *+6
       ORB    <Z
       STB    <Z

       LDD    <Z
       STA    ,U+
       STB    ,X+
       CMPX   #$DF40
       LBNE   CONVER

       PULS   CC,A,B,DP,X,Y,U,PC
       FCC    "(c) HCL 92"
       FDB    0
ZZZEND
       END
