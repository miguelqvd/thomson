****************************************
*             - F A D E -              *
* Cette routine passe de la palette de *
* couleurs courante à celle stockée en *
* $DFE0 en réalisant un fondu enchaîné *
****************************************
*Laurent Hiriart, 67420 COLROY-la-ROCHE*
****************************************

DIR    EQU    ENDPRG/256
V      EQU    ENDPRG-DIR*256
NPASS  EQU    V      nombre d'étapes
NCOLOR EQU    V+1    No couleur traitée
ACTUEL EQU    V+2    sa palette courante
BLEU   EQU    V+4    hauteur de Bleu
VERT   EQU    V+5    hauteur de Vert
ROUGE  EQU    V+6    hauteur de Rouge

WAIT   EQU    1   Attente entre 2 étapes

       ORG    $DF58
G      PSHS   X,B,A,DP,CC
       LDD    #$1000+DIR    accès direct
       TFR    B,DP       aux "variables"
       STA    <NPASS
       LDU    #$E7DA   +rapide & +concis

APPEAR LDD    #$1E00+WAIT
       TST    13,U
       BPL    *-2     attend le retour
       TST    13,U     du spot sur la
       BMI    *-2        ligne 200.
       DECB
       BNE    APPEAR+3
       LDX    #8*45   descend bien bas
       LEAX   -1,X     dans le border
       BNE    *-2
       LDX    #COLORS+32
       STA    <NCOLOR

PALETT LDA    ,-X     palette finale
       ANDA   #15
       STA    <ROUGE  hauteurs de rouge,
       LDD    ,-X
       ANDA   #15
       ANDB   #240
       STD    <BLEU   de bleu et de vert

       LDA    <NCOLOR 2*No de la couleur
       STA    1,U
       LDB    ,U       palette courante
       LDA    ,U        de la couleur
       ANDA   #15         courante
       STD    <ACTUEL

COMPO1 LDA    <ACTUEL+1
       ANDB   #15
       CMPB   <ROUGE  (ajuste le rouge)
       BHI    SUBROU
       BEQ    COMPO2
       ADDA   #2      Quelques octets de
SUBROU DECA            moins à recopier

COMPO2 LDB    <ACTUEL+1
       ANDB   #240
       CMPB   <VERT   (ajuste le vert)
       BHI    SUBVER
       BEQ    COMPO3
       ADDA   #32     c'est déjà ça d'é-
SUBVER SUBA   #16     pargné au lecteur

COMPO3 STA    <ACTUEL+1
       LDA    <ACTUEL
       CMPA   <BLEU   (ajuste le bleu)
       BHI    SUBBLE
       BEQ    FINCOU
       ADDA   #2      de Micro-News qui
SUBBLE DECA           recopie mes DATAS.

FINCOU LDB    <NCOLOR
       STB    1,U
       LDB    <ACTUEL+1
       STB    ,U        validation de la
       STA    ,U        nouvelle palette
       DEC    <NCOLOR
       DEC    <NCOLOR  couleur suivante
       BPL    PALETT         ...

       DEC    <NPASS  étape suivante ...
       BNE    APPEAR
       PULS   CC,DP,A,B,X,U,PC   on sort

ENDPRG FCB    0,0,0,0,0,0,0  "variables"
       FCC    "HCL" *-> Lg multiple de 8
COLORS * nouvelles palettes stockées ici

       END
