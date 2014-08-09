*
* FLIPTITRE (C) TEO 1986
*    No 1 page 19
*
DEBUT  EQU    $C000
GETC   EQU    $E806
PRC    EQU    $E7C3
STAD   EQU    $4000
       ORG    DEBUT
* PASSAGE EN MEMOIRE FORME
       LDB    PRC     FORCE MEMOIRE
       ORB    #1      FORME
       STB    PRC
* COORDONNEES DEPART
ENC1   LDB    #16     2 LIGNES
       PSHS   B
ENC    LDX    #STAD+16*40 FIN DES 2 LI
       LDA    #40     SAUVE LES 40
P1     LDB    ,-X     DERNIERS GPL
       PSHS   B
       DECA
       BNE    P1
       LDY    #16*40  NB TOTAL DE GPL
P2     LDB    ,-X     1 GPL
       STB    40,X    AFFICHE UNE LIGNE
       BSR    TEMPO
       LEAY   -1,Y    + BAS
       BNE    P2
       LDX    #STAD   AFFICHE 1ERE
       LDA    #40     LIGNE
P3     PULS   B
       STB    ,X+
       DECA
       BNE    P3
       DEC    ,S      2 LIGNES ?
       BNE    ENC
       PULS   B
       JSR    GETC    UNE TOUCHE
       TSTB           A ETE FRAPPEE ?
       BEQ    ENC1    NON
       RTS            OUI RETOUR BASIC
TEMPO  PSHS   A
       LDA    #12
T1     DECA
       BNE    T1
       PULS   A,PC
       END    DEBUT
