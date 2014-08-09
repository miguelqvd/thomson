*
*  ANNONCE4 (c) THEOPHILE J. ELTABET
*       No 5 page 45 juin 1984
*
       ORG    $B000
AFF    EQU    $E803
CLAV   EQU    $E806
US     EQU    1FH
ESC    EQU    1BH
*
*      DEBUT
*
       LDX    1,X     RECUP AD TEXTE
       STX    ADTXT
       STB    LTXT
       LDX    #ATT11  EN GROSSES LETTRES
       BSR    EDM
DEB    CLR    I
A0     LDX    #POSI
       BSR    EDM
       LDA    I       CTRL AFF TXT
       INCA
       STA    I
       CMPA   LTXT    FIN D'UN TOUR ?
       BHI    A9
*
*      DELAI ATTENTE
*
       LDY    #3000
ATT    LEAY   -1,Y
       BNE    ATT
       LDA    I
       CMPA   #19     SI L<19 ALORS A1
       BMI    A1
*
*      CAS DU MESSAGE > 19
*
       LDA    I       CALCUL ADR DEBUT
       SUBA   #18     DU TEXTE
       LDX    ADTXT
A7     LEAX   1,X
       DECA
       BNE    A7
       LDA    #19     ET AFFICHAGE
A2     LDB    0,X     19 CAR
       JSR    AFF
       LEAX   1,X
       DECA
       BNE    A2
       BRA    A0
*
*      CAS DU MESSAGE < 19 CAR
*
A1     LDA    #19     AFF DES . AVANT
       SUBA   I
       LDB    #'.
A4     JSR    AFF
       DECA
       BNE    A4
       LDX    ADTXT
       LDA    #1      AFFICHAGE DES I
A6     CMPA   I       PREMIERS CAR
       BHI    A0
       LDB    0,X
       JSR    AFF
       LEAX   1,X
       INCA
       BRA    A6
*
*      AUTRE TOUR ?
*
A9     JSR    CLAV
       TSTB
       BEQ    DEB
*
*      FINAL
*
FIN    LDX    #ATT00  ON REVIENT
       BSR    EDM     EN LETTRES NORM
       RTS
*
*      AFFICHAGE MESSAGE
*
EDM    LDB    0,X
       BEQ    FEDM
       JSR    AFF
       LEAX   1,X
       BRA    EDM
FEDM   RTS
*
*      DEFINITION DE ZONES
*
POSI   FCB    US,40H+23,40H+1,0
ATT11  FCB    ESC,4FH,0
ATT00  FCB    ESC,4CH,0
LTXT   FCB    0
I      FCB    0
ADTXT  FCB    00
       END
