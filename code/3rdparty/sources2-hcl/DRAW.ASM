****************************************
*     Traçage de segments optimisé     *
*   abcisses et ordonnées sur 8 bits   *
****************************************
*  - FONCTIONNE EN MODE 40 COLONNES -  *
* GESTION DES COULEURS NON ASSUREE ICI *
* - ATTENTION AUX DEPASSEMENTS EN Y !- *
****************************************
********** By Doctor Lô of HCL *********

       ORG    $9C00
ECRAN  EQU    $C004
DIR    EQU    $9F     } pour les accès
Z      EQU    $00     } en page directe

G      ORCC   #80
       LDA    #DIR
       TFR    A,DP
       CLR    $E7E5

SYNCRO TST    $E7E7
       BMI    *-3
       TST    $E7E7
       BPL    *-3
       LDD    #15
       STA    $E7DB
       STB    $E7DA
       STA    $E7DA

       LDD    #$FF00  coordonnees point1
       STD    <Z+6
       LDD    #$00C7    deuxieme point
       JSR    DRAW

       LDD    #0
       STA    $E7DB
       STB    $E7DA
       STA    $E7DA
       TST    $E7C8
       BEQ    SYNCRO
       SWI


DRAW   LDU    #PUISS  permanent (pixels)
       STD    <Z+4
       CMPA   <Z+6    si x1 > x2 alors
       BLS    *+10      permutation
       LDX    <Z+6
       STX    <Z+4
       STD    <Z+6
       LDB    <Z+5

       CMPB   <Z+7
       LBHI   MONTEE  quand y1 < y2

       LDD    <Z+6
       SUBA   <Z+4    A = (dx)
       STA    <Z+1
       SUBB   <Z+5    B = (dy)
       CMPB   <Z+1
       LBHI   VERTI1  quand (dy) > (dx)

       TFR    B,A
       CLRB           (dy) / (dx) = 0.?
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #128
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #64
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #32
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #16
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #8
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #4
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #2
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #1
       STB    MMSEG1+1

       LDX    #ECRAN
       LDA    #40
       LDB    <Z+5
       MUL
       LEAX   D,X
       LDB    <Z+4
       LSRB
       LSRB
       LSRB
       ABX
       LDB    <Z+4
       ANDB   #7
       LDA    B,U
       STA    <Z
       CLRB

       LDA    ,X
LINE1  ORA    <Z
       DEC    <Z+1
       BNE    *+5
       STA    ,X
       RTS
       LSR    <Z
       BNE    MMSEG1
       ROR    <Z
       STA    ,X+
       LDA    ,X
MMSEG1 ADDB   #0
       BCC    LINE1
       STA    ,X
       LEAX   40,X
       BRA    LINE1-2

VERTI1 STB    <Z+1
       CLRB           (dx) / (dy) = 0.?
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #128
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #64
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #32
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #16
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #8
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #4
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #2
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #1
       STB    VIRG1+1

       LDX    #ECRAN
       LDA    #40
       LDB    <Z+5
       MUL
       LEAX   D,X
       LDB    <Z+4
       LSRB
       LSRB
       LSRB
       ABX
       LDB    <Z+4
       ANDB   #7
       LDA    B,U
       STA    LINE2+3
       CLRB

LINE2  LDA    ,X
       ORA    #0
       STA    ,X
       LEAX   40,X
       DEC    <Z+1
       BNE    *+3
       RTS
VIRG1  ADDB   #0
       BCC    LINE2
       LSR    LINE2+3
       BNE    LINE2
       ROR    LINE2+3
       LEAX   1,X
       BRA    LINE2

MONTEE LDD    <Z+6
       SUBA   <Z+4    A = (dx)
       STA    <Z+1
       LDB    <Z+5
       SUBB   <Z+7    B = (dy)
       CMPB   <Z+1
       LBHI   VERTI2  quand (dy) > (dx)

       TFR    B,A
       CLRB           (dy) / (dx) = 0.?
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #128
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #64
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #32
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #16
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #8
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #4
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #2
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #1
       STB    MMSEG2+1

       LDX    #ECRAN
       LDA    #40
       LDB    <Z+5
       MUL
       LEAX   D,X
       LDB    <Z+4
       LSRB
       LSRB
       LSRB
       ABX
       LDB    <Z+4
       ANDB   #7
       LDA    B,U
       STA    <Z
       CLRB

       LDA    ,X
LINE3  ORA    <Z
       DEC    <Z+1
       BNE    *+5
       STA    ,X
       RTS
       LSR    <Z
       BNE    MMSEG2
       ROR    <Z
       STA    ,X+
       LDA    ,X
MMSEG2 ADDB   #0
       BCC    LINE3
       STA    ,X
       LEAX   -40,X
       BRA    LINE3-2

VERTI2 STB    <Z+1
       CLRB           (dx) / (dy) = 0.?
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #128
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #64
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #32
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #16
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #8
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #4
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #2
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #1
       STB    VIRG2+1

       LDX    #ECRAN
       LDA    #40
       LDB    <Z+5
       MUL
       LEAX   D,X
       LDB    <Z+4
       LSRB
       LSRB
       LSRB
       ABX
       LDB    <Z+4
       ANDB   #7
       LDA    B,U
       STA    LINE4+3
       CLRB

LINE4  LDA    ,X
       ORA    #0
       STA    ,X
       LEAX   -40,X
       DEC    <Z+1
       BNE    *+3
       RTS
VIRG2  ADDB   #0
       BCC    LINE4
       LSR    LINE4+3
       BNE    LINE4
       ROR    LINE4+3
       LEAX   1,X
       BRA    LINE4

PUISS  FDB    $8040,$2010,$0804,$0201
       END
