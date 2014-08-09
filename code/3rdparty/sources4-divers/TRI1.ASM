*
*            TRI1.ASM
*
*    Passez facilement du BASIC au
*   langage machine des TO7(70),TO9
*   Programme No XXX pages 220-221
*
* =====================================
*
*    Tri par la méthode de RIPPLE avec
*   flag de terminaison,et contrôle du
*    résultat.
*
       ORG    $7900
       PSHS   U,Y,X,DP,D,CC
       SETDP  $79
       LDA    #$79
       TFR    A,DP
       LDY    #DON
       LDX    #TABLE
DEBUT  LDD    ,X++
       CMPD   #4
       BEQ    SUITE
       STD    ,Y++
       BRA    DEBUT
SUITE  LDX    #DON+16
       STX    <COMP
D1     LDX    #DON
D2     LDD    ,X++
       CMPD   ,X++
       BHI    SUITE2
       BSR    SWAP
SUITE2 CMPX   <COMP
       BEQ    D3
       LEAX   -2,X
       BRA    D2
D3     TST    <FLAG
       BEQ    FIN
       CLR    <FLAG
       LDU    <COMP
       LEAU   -2,U
       CMPU   #DON+2
       BEQ    FIN
       STU    <COMP
       BRA    D1
SWAP   INC    <FLAG
       LDY    ,--X
       STY    ,--X
       LEAX   2,X
       STD    ,X++
       RTS
FIN    PULS   CC,D,DP,X,Y,U
       SWI
TABLE  FDB    12,265,34543,1467,3567
       FDB    64321,45678,46,$4
COMP   FDB    0000
FLAG   FCB    00
DON    EQU    *
       END
