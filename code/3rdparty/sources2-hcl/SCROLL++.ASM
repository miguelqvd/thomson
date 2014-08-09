****************************************
*    Scrolling segment par segment.    *
*      D'une taille conséquente.       *
*                                      *
*   Je pourrais gagner un peu de temps *
*  CPU en faisant du code généré, mais *
*  quoi ! On n'est pas des bêtes...    *
****************************************

SIZE   EQU    HAUT*LONG/4
FONTE  EQU    $0000-SIZE*2
RAMA   EQU    $DF18-HAUT*40
HAUT   EQU    112     multiple de 8 !
LONG   EQU    5       segments par CHR$
DIR    EQU    $9F     } début buffer
Z      EQU    0       } à accès direct
CARTOU EQU    15      page $0000-$3FFF
ZZ     EQU    DIR*256+Z

       ORG    DIR*256+Z
       FDB    1,TEXTE,FONTE

       ORG    $9800
G      ORCC   #80
       LDD    $E7E5
       PSHS   D,DP
       LDA    #DIR
       TFR    A,DP
       STS    RDP+2
       CLR    $E7E5
       CLR    $E7C5

SYNCRO TST    $E7E7
       BPL    *-3
       TST    $E7E7
       BMI    *-3

       LDD    #8
       STA    $E7DB   pour voir le temps
       STB    $E7DA    CPU qu'il reste.
       STA    $E7DA

       LDX    #RAMA+160
       LDU    <Z+4
       LDA    #HAUT/8
       STA    <Z
COPYA  PULU   D
       STA    -120,X
       STB    -80,X
       PULU   D
       STA    -40,X
       STB    ,X
       PULU   D
       STA    40,X
       STB    80,X
       PULU   D
       STA    120,X
       STB    160,X
       LEAX   280,X
       DEC    <Z
       BNE    COPYA
       PULU   D
       STU    <Z+4

       TFR    DP,A
       STA    <Z+6
       LDA    #HAUT/2
       STA    ZZ
       LDU    #RAMA+1
       LDS    #RAMA+8
SCROLA PULU   CC,A,B,DP,X,Y
       PSHS   Y,X,DP,B,A,CC
       LEAS   16,S
       FDB    $373F,$343F,$32E8,$1037
       FDB    $3F34,$3F32,$E810
       FDB    $373F,$343F,$32E8,$1037
       FDB    $3F34,$3F32,$E810
       FDB    $373F,$343F,$32E8,$1037
       FDB    $3F34,$3F32,$E810
       FDB    $373F,$343F,$32E8,$1037
       FDB    $3F34,$3F32,$E810
       FDB    $373F,$343F,$32E8
       FCB    16
       DEC    ZZ
       BNE    SCROLA
       CLR    RAMA+HAUT*40

       LDA    ZZ+6
       TFR    A,DP

       LDD    #0
       STA    $E7DB   pour voir le temps
       STB    $E7DA    CPU qu'il reste.
       STA    $E7DA

       TST    $E7C8
       BNE    RDP
       DEC    <Z+1
       LBNE   SYNCRO

       LDA    #LONG
       STA    <Z+1
       LDX    <Z+2    lettre suivante
       LDA    ,X+
       BNE    *+7
       LDX    #TEXTE
       LDA    ,X+
       LDU    #FONTE
       LDB    #SIZE
       ASLA
       MUL
       LEAU   D,U
       STU    <Z+4
       STX    <Z+2
       JMP    SYNCRO

RDP    LDS    #0
       PULS   D,DP
       STD    $E7E5
       SWI
TEXTE  FCB    1,2,3,4,5,6,7,8,9,0

       END
