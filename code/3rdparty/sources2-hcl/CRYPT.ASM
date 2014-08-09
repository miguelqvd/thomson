LEN    EQU    $D4


       ORG    $9000+LEN
G      ORCC   #80
       LDU    #TXTLST
PASS0  LDD    #$A300+LEN
       LDX    ,U++
       BEQ    ENDTXT
       LEAX   D,X
       STX    CMPT+1
       LDX    ,U++
       LEAX   D,X
       LDA    ,X
       ADDA   #$A5
       STA    ,X+
CMPT   CMPX   #0
       BNE    *-9
       BRA    PASS0
ENDTXT

       LDX    #$A300+LEN
PASS1  LDD    ,X
       EXG    A,B
       EORA   #$22
       EORB   #$53
       STD    ,X++
       CMPX   #$AA00
       BLO    PASS1

       LDU    #$A300+LEN
       LDX    #$9000
PASS2  LDB    ,X+
       SUBB   ,U
       STB    ,U+
       CMPX   #$9000+LEN
       BNE    PASS2
       CMPU   #$AA00
       BLO    PASS2-3

       RTS

TXTLST FDB    $065,$006,$158,$0EE
       FDB    $2A7,$210,$4F7,$46F
       FDB    0

       END
