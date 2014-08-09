*NOMBRES PREMIERS
*ASCINEWS 4 juin 1993 / ASCI (c)
*par Michel SAINT-BRIANT

LIMITE EQU    28      jusqu'a 1 000 000
*LIMITE EQU    60      TO8sans ext.256Ko
*LIMITE EQU    124     TO8+256ko ou TO9+

MAXI   EQU    1024    jusqu'a 1 000 000
*MAXI  EQU    1846    TO8sans ext.256ko
*MAXI   EQU    2757    TO8+256ko ou TO9+

       ORG    $8000

*remise à zero sur toutes les banks

       PSHS   A,B,DP,CC,X,Y,U
G      ORCC   #$50
       LDU    #0
       LDD    #$0307
       STA    $E7E5
       STB    $60CE
       LDA    #LIMITE
       LSRA
       LSRA           division par 4
       SUBA   #3      =13 banks pour TO8
NEWBNK LDX    #$A000
NULL   STU    ,X++
       CMPX   #$E000
       BLO    NULL
       INC    $E7E5
       DECA
       BNE    NEWBNK

*algorithme du crible d'Eratosthene

       LDD    #$0301
       STA    $E7E5
       STB    >$A000  (1 pas premier)
       LDU    #RETENU+1
       LDD    #$0001
       STD    POINTR+1

*nombre suivant

NEWNBR LDD    #$0C03
       STA    RETENU
       STB    $E7E5
       LDD    POINTR+1
       ADDD   #2      impair de 2 en 2
       STD    POINTR+1
       CMPD   #MAXI   est-ce le dernier?
       BHI    FIN
       ADDD   POINTR+1
       STD    AJOUTE+2 multiples impairs

*le nombre est-il premier?

       LSRA
       RORB
       LSRA
       RORB
       PSHS   B
       LSRA
       RORB
       LSRA
       RORB
       LSRA
       RORB
       ADDA   #$A0
       TFR    D,Y
       PULS   B
       LDA    #1
       ANDB   #7
       BEQ    ZERO0
DECAL0 LSLA
       DECB
       BNE    DECAL0
ZERO0  ANDA   ,Y
       BNE    NEWNBR  sinon autre nombre

*si oui on marque tous ses multiples

POINTR LDX    #0
AJOUTE LEAX   >$FFFF,X
       CMPX   AJOUTE+2
       BHS    PASRET  si pas debordement
       INC    RETENU
       LDA    RETENU
       CMPA   #LIMITE
       BHS    NEWNBR
       LSRA
       LSRA
       STA    $E7E5
PASRET LDA    RETENU
       STA    ,U
       TFR    X,D
       LSR    ,U
       RORA
       RORB
       PSHS   B
       LSR    ,U
       RORA
       RORB
       LSRA
       RORB
       LSRA
       RORB
       ADDA   #$A0
       TFR    D,Y
       PULS   B
       LDA    #1
       ANDB   #7
       BEQ    ZERO1
DECAL1 LSLA
       DECB
       BNE    DECAL1
ZERO1  ORA    ,Y
       STA    ,Y
       BRA    AJOUTE
FIN    PULS   A,B,CC,DP,X,Y,U,PC


RETENU FCB    0

       END
