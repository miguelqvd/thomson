       TITLE  TO-DEMO:S/P
*      ---------------------------------
       PAGE

****************************************
*                                      *
*            S/P                       *
*                                      *
****************************************


*=======================================
* S/P test de localisation de la souris
*     dans un carreau
* Entrée: XH  rangée  début   ]
*         XL  colonne début   du carreau
*         YH  hauteur         ]
*         YL  largeur         ]
* Sortie: CY 1 souris dans le carreau
*            0 ... en dehors
*=======================================

SOUROK PSHS   D,X,Y,U
       LEAS   -5,S
HORDOT SET    0
VERDOT SET    2
MULTH  SET    4
PA     SET    5
PB     SET    6
PXH    SET    7
PXL    SET    8
PYH    SET    9
PYL    SET    10
*---------------------------------------

       LDB    #8        coef de * horiz
       LDA    SCRMOD
       CMPA   #$40
       BNE    RGMU      ->
       LDB    #4        bit map 16
RGMU   STB    MULTH,S

       LDA    #8
       LDB    PXH,S
       MUL
       STD    HORDOT,S
       CMPD   REGY
       BGT    SELDN     hors haut ->
       LDA    MULTH,S
       LDB    PXL,S
       MUL
       STD    VERDOT,S
       CMPD   REGX
       BGT    SELDN     hors gauche ->
       LDA    #8
       LDB    PYH,S
       MUL
       ADDD   HORDOT,S
       CMPD   REGY
       BLE    SELDN     hors bas ->
       LDA    MULTH,S
       LDB    PYL,S
       MUL
       ADDD   VERDOT,S
       CMPD   REGX
       BLE    SELDN     hors droit ->
       ORCC   #$01      dedans
       BRA    SELDF     ->
SELDN  ANDCC  #$FE      hors

SELDF  LEAS   5,S
       PULS   D,X,Y,U,PC
