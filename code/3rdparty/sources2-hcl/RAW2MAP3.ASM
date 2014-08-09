****************************************
*  Conversion du mode RAW en bitmap16  *
****************************************
*        Doctor Lô le 29-4-91          *
****************************************

P0     EQU    0       bitplan0
P1     EQU    4000    décalage bitplan1
P2     EQU    2*P1    décalage bitplan2
P3     EQU    3*P1    décalage bitplan3

DIR    EQU    $9E     variables = les 2
Z      EQU    $FE      octets courants

       ORG    $9E00
G      ORCC   #80
       PSHS   DP
       LDA    #DIR
       TFR    A,DP

       LDY    #P1     octets par plan
       LDX    #$A000  source
       LDU    #$4000  destination

CONVER CLR    <Z
       CLR    <Z+1

       LDD    #$C010
       BITA   P0,X
       BEQ    *+6
       ORB    <Z
       STB    <Z
       LDB    #32
       BITA   P1,X
       BEQ    *+6
       ORB    <Z
       STB    <Z
       LDB    #64
       BITA   P2,X
       BEQ    *+6
       ORB    <Z
       STB    <Z
       LDB    #128
       BITA   P3,X
       BEQ    *+6
       ORB    <Z
       STB    <Z

       LDD    #$3001
       BITA   P0,X
       BEQ    *+6
       ORB    <Z
       STB    <Z
       LDB    #2
       BITA   P1,X
       BEQ    *+6
       ORB    <Z
       STB    <Z
       LDB    #4
       BITA   P2,X
       BEQ    *+6
       ORB    <Z
       STB    <Z
       LDB    #8
       BITA   P3,X
       BEQ    *+6
       ORB    <Z
       STB    <Z

       LDD    #$0C10
       BITA   P0,X
       BEQ    *+6
       ORB    <Z+1
       STB    <Z+1
       LDB    #32
       BITA   P1,X
       BEQ    *+6
       ORB    <Z+1
       STB    <Z+1
       LDB    #64
       BITA   P2,X
       BEQ    *+6
       ORB    <Z+1
       STB    <Z+1
       LDB    #128
       BITA   P3,X
       BEQ    *+6
       ORB    <Z+1
       STB    <Z+1

       LDD    #$0301
       BITA   P0,X
       BEQ    *+6
       ORB    <Z+1
       STB    <Z+1
       LDB    #2
       BITA   P1,X
       BEQ    *+6
       ORB    <Z+1
       STB    <Z+1
       LDB    #4
       BITA   P2,X
       BEQ    *+6
       ORB    <Z+1
       STB    <Z+1
       LDB    #8
       BITA   P3,X
       BEQ    *+6
       ORB    <Z+1
       STB    <Z+1

       LDA    $E7C3   premier octet en
       ORA    #1       RAM A
       STA    $E7C3
       LDB    <Z
       STB    ,U
       ANDA   #254    deuxième octet en
       STA    $E7C3    RAM B
       LDB    <Z+1
       STB    ,U+     destination
       LEAX   1,X     source (Bitplan 1)
       LEAY   -1,Y    compteur
       LBNE   CONVER

       CMPU   #$5F40    première moitié
       BLO    *+5
       LDU    #$4000    ou fin d'image ?
       STU    CONVER-2
       PULS   DP,PC

       END
