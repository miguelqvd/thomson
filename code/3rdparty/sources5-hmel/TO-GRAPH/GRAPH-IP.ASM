       TITLE  TO-GRAPH: Cadrage/Impressi
*      ---------------------------------
       PAGE

****************************************
*                                      *
*           TO-GRAPH                   *
*                                      *
*    Cadrage/Impression   GRAPH-IP     *
*                                      *
****************************************


*=======================================
* S/P Activation d'un chien de garde
*
* Entrée: U   ad. en cas d'arret
*=======================================

ACTDOG LDA    $E7E6
       STA    BKDOG
       STU    ADRDOG
       LEAU   2,S
       STU    STKDOG
       TFR    DP,A
       STA    DPDOG
       LDA    #1
       STA    FLGDOG
       RTS


*=======================================
* S/P raz d'une rectangulaire au point
*
* Entrée: XT0,YT0 coord. début
*         XT1,YT1 coord. fin
*=======================================

CLRTIR LDU    #XCLRTI
       JMP    COMBK2


*=======================================
* S/P impression d'un fragment de page
*     limité par CADRNG-CADCOL
*                CADHAU-CADLAR
* Entrée  B interrupteur pleine page
*=======================================

IMPPAG LDU    #XIMPPA
       JMP    COMBK2


*=======================================
* S/P initialisation du Chien de garde
*=======================================

INIDOG LDX    #DDOG
       LDY    #XDOG
INID0  LDA    ,X+
       STA    ,Y+
       CMPX   #FDOG
       BNE    INID0     ->
       CLR    FLGDOG
       LDD    #XDOG     activation
       STD    TIMEPT
       LDA    STATUS
       ORA    #$20
       STA    STATUS
       RTS              ->>

DDOG   TST    FLGDOG    ## TACHE IT ##
       BEQ    EXITIT    non actif ->
       JSR    GETC
       TSTB
       BNE    CNFDOG    cnf ->
       JSR    LPIN
       BCC    EXITIT    ->
CNFDOG TFR    S,X       confirmation
       LEAS   -12,S     hors IT par
       TFR    S,Y       ATTDOG
       LDB    #12
DDOG0  LDA    ,X+
       STA    ,Y+
       DECB
       BNE    DDOG0     ->
       LDD    #XDOG+ATTDOG-DDOG
       STD    10,S
       CLR    FLGDOG
*
* RTI va aller en ATTDOG au lieu point
* interrompu !!!

EXITIT JMP    KBIN      ->>>>

ATTDOG TFR    S,X       pile provisoire
       LDS    STKDOG
       LEAS   -20,S
       PSHS   X
       LDX    #$6100    sauve extra
       LEAY   -712,S
ATTDO9 LDD    ,X++
       STD    ,Y++
       CMPX   #$6300
       BNE    ATTDO9    ->
       LDB    REGY+1    test d'interupti
       LSRB
       LSRB
       LSRB
       CMPB   #14
       BLE    ATTDO0    ->
       LDB    #14
ATTDO0 CMPB   #5
       BGE    ATTDO5    ->
       LDB    #5
ATTDO5 PSHS   B
       LDD    REGX
       LSRA
       RORB
       LSRA
       RORB
       LSRB
       CMPB   #50
       BLE    ATTDO1    ->
       LDB    #50
ATTDO1 PULS   A
       LEAX   -200,S
       JSR    TBREAK
       BCC    ATTDON    ->
       LDA    BKDOG     confirmé
       STA    $E7E6
       LDA    DPDOG
       TFR    A,DP
       LDS    STKDOG
       LDX    ADRDOG
       JMP    ,X               ->>>>

ATTDON LDX    #$6100    restaure extra
       LEAY   -712,S
ATTDO8 LDD    ,Y++
       STD    ,X++
       CMPX   #$6300
       BNE    ATTDO8    ->
       PULS   X
       TFR    X,S
       COM    FLGDOG
       PULS   CC,D,DP,X,Y,U,PC ->>>>
FDOG   EQU    *


*=======================================
* S/P Lecture d'un bit sur le tiroir
*
* Entrée: X     coord. dans tiroir
*         CPTLT
* Sortie: Z   bit nul ou non
*=======================================

LECTXY LDU    #XLECTX
       JMP    COMBK2


*=======================================
* S/P lecture écran -> tiroir
*
* Entrée XT0,YT0   coord. début
*        XT1,YT1   coord. fin
*=======================================

LITTIR LDU    #XLITTI
       JMP    COMBK2


*=======================================
* S/P modification du tiroir
*     Nb: la souris est en REGX/REGY
*=======================================

FFMODT FCB    FLOCF,0,0,13,14
       FCB    FTRAME,FTOURI
       FCB    FCOMF,FF,OFF
       FCB    FLOCF,1,1,11,12
       FCB    FFOND,FTOURE,FCADRE

       FCB    FLOCF,2,4,1,6,FTOURE
       FCB    FEDI,ESC,$4E,SS2,$2C,96
       FCB    SS2,$2E,0
       FCB    FPOUSS,BS,OFF

       FCB    FLOCF,4,2,3,2,FTOURE
       FCB    FEDI,ESC,$4C,95,LF,BS
       FCB    ESC,$4E,SS2,$2F,0
       FCB    FPOUSS,29,OFF

       FCB    FLOCF,4,6,3,2,FTOURE
       FCB    FEDI,SS2,$2D,LF,BS,BS,124
       FCB    LF,BS,BS,SS2,$2F,0
       FCB    FPOUSS,LF,OFF

       FCB    FLOCF,4,10,3,2,FTOURE
       FCB    FEDI,LF,SS2,$2D,LF,BS,BS
       FCB    ESC,$4C,126,0
       FCB    FPOUSS,30,OFF

       FCB    FLOCF,8,4,3,6,FTOURE
       FCB    FEDI,ESC,$4E,SP,SS2,$2D
       FCB    LF,BS,BS,BS,BS,SS2,$2C
       FCB    SP,SS2,$2E,BS,BS,BS,BS,LF
       FCB    SS2,$2F,ESC,$4C,0
       FCB    FPOUSS,28,OFF
       FCB    FSTOP

FFCNFT FCB    FLOCF,0,0,5,22
       FCB    FTRAME,FTOURI
       FCB    FLOCF,1,1,3,20
       FCB    FFOND,FTOURE,FCADRE
       FCB    FLOCF,2,2,1,20
       FCB    FEDI
       FCC    \OKAnnuler\
       FCB    0
       FCB    FLOCF,2,6,1,1
       FCB    FEDI,BALISE,0
       FCB    FPOUSS,RC,OFF
       FCB    FLOCF,2,18,1,1
       FCB    FEDI,BALISE,0
       FCB    FPOUSS,FF,OFF
       FCB    FSTOP

MPBMDT FCC    \ROTATIONIMPOSSIBLE\
       FCB    0

FFEXPT FCB    FLOCA,1,4,23,74
       FCB    FCOMF,FF,OFF
       FCB    FSTOP

MODTIR LEAS   -920,S
COEFTL SET    0
COEFTH SET    4
MEMXT  SET    8
NEWXT0 SET    10
NEWYT0 SET    12
NEWXT1 SET    14
NEWYT1 SET    16
MULTL  SET    18
MULTH  SET    19
MMTOR  SET    20
MMNOIR SET    21      FF=> ligne en cour
BUFFER SET    22
*---------------------------------------

       LEAX   FFMODT,PCR
       LDB    REGY+1
       LSRB
       LSRB
       LSRB
       LDA    #10
       CMPB   #10
       BLE    MODT00    ->
       TFR    A,B
MODT00 PSHS   B
       LDD    REGX
       LSRA
       RORB
       LSRA
       RORB
       LSRB
       LDA    #63
       CMPB   #63
       BLE    MODT01    ->
       TFR    A,B
MODT01 PULS   A
       JSR    FENOUV

MODT0  JSR    FENACT
MODT1  JSR    FEN
       LDU    #PILFEN
       PSHU   CC,D,X,Y
       TSTB
       BEQ    MODT1     ->
       CMPB   #BS
       LBEQ   MTDG      ->
       CMPB   #HT
       LBEQ   MTDG      ->
       CMPB   #LF
       LBEQ   MTHB      ->
       CMPB   #VT
       LBEQ   MTHB      ->
       CMPB   #29
       LBEQ   MTROTP    ->
       CMPB   #30
       LBEQ   MTROTM    ->
       CMPB   #28
       LBEQ   MTEXP     ->
       CMPB   #FF
       LBNE   MODT1     ->
       CLRB
       JSR    FENFER
       LBRA   MTRET     ->

*** Retournement Droite Gauche
MTDG   EQU    *
       CLRB
       JSR    FENFER
       JSR    CLRTIR

       LDX    #0
BMTDG0 LDA    <HPTTIR
       STA    <CPTLT

BMTDG1 TFR    X,U
       LEAX   BUFFER,S  test d'interrupt
       LDD    #$0D35
       LBSR   SBREAK
       LBCS   MTRETA    ->
       TFR    U,X
       DEC    <CPTLT
       LDA    <CPTLT
       CMPA   #-1
       BEQ    BMTDG2    ->
       JSR    LECTXY
       BEQ    BMTDG1    ->
       PSHS   X
       LDD    <LPTTIR
       SUBD   ,S
       ADDD   #31
       TFR    D,X
       CLRA
       LDB    #8
       ADDB   <CPTLT
       TFR    D,Y
       LDB    #PSETXY
       JSR    EXTRA
       PULS   X
       LBRA   BMTDG1    ->

BMTDG2 LEAX   1,X
       CMPX   <LPTTIR
       LBNE   BMTDG0    ->

       LBRA   MTFIN     ->

*** Retournement Haut Bas
MTHB   EQU    *
       CLRB
       JSR    FENFER
       JSR    CLRTIR

       LDX    #0
BMTHB0 LDA    <HPTTIR
       STA    <CPTLT

BMTHB1 TFR    X,U
       LEAX   BUFFER,S  test d'interrupt
       LDD    #$0D35
       LBSR   SBREAK
       LBCS   MTRETA    ->
       TFR    U,X
       DEC    <CPTLT
       LDA    <CPTLT
       CMPA   #-1
       BEQ    BMTHB2    ->
       JSR    LECTXY
       BEQ    BMTHB1    ->
       LEAX   32,X
       CLRA
       LDB    #7
       ADDB   <HPTTIR
       SUBB   <CPTLT
       TFR    D,Y
       LDB    #PSETXY
       JSR    EXTRA
       LEAX   -32,X
       LBRA   BMTHB1    ->

BMTHB2 LEAX   1,X
       CMPX   <LPTTIR
       LBNE   BMTHB0    ->

       LBRA   MTFIN     ->

*** Rotation sens horaire
MTROTP EQU    *
       LDD    <LPTTIR
       CMPD   #184
       BLE    MTRTP0    ->
       LEAX   MPBMDT,PCR
       JSR    FENERR
       LBRA   MODT0     ->

MTRTP0 EQU    *
       CLRB
       JSR    FENFER
       LDD    #$0104    fond tramé
       LDY    #$174A
       JSR    FENLOC
       JSR    FENTRA
       LDD    <XT1
       PSHS   D
       CLRA
       LDB    <YT1
       SUBB   #8
       ADDB   #32
       STD    <XT1
       PULS   D
       SUBB   #32
       ADDB   #8
       STB    <YT1
       JSR    CLRTIR

       LDX    #0
BMTRP0 LDA    <HPTTIR
       STA    <CPTLT

BMTRP1 TFR    X,U
       LEAX   BUFFER,S  test d'interrupt
       LDD    #$0D35
       LBSR   SBREAK
       LBCS   MTRETA    ->
       TFR    U,X
       DEC    <CPTLT
       LDA    <CPTLT
       CMPA   #-1
       BEQ    BMTRP2    ->
       JSR    LECTXY
       BEQ    BMTRP1    ->
       PSHS   X
       LEAX   8,X
       TFR    X,Y
       CLRA
       LDB    <HPTTIR
       SUBB   <CPTLT
       ADDB   #31
       TFR    D,X
       LDB    #PSETXY
       JSR    EXTRA
       PULS   X
       LBRA   BMTRP1    ->

BMTRP2 LEAX   1,X
       CMPX   <LPTTIR
       LBNE   BMTRP0    ->

       LBRA   MTFIN     ->

*** Rotation sens anti-horaire
MTROTM EQU    *
       LDD    <LPTTIR
       CMPD   #184
       BLE    MTRTM0    ->
       LEAX   MPBMDT,PCR
       JSR    FENERR
       LBRA   MODT0     ->

MTRTM0 EQU    *
       CLRB
       JSR    FENFER
       LDD    #$0104    fond tramé
       LDY    #$174A
       JSR    FENLOC
       JSR    FENTRA
       LDD    <XT1
       PSHS   D
       CLRA
       LDB    <YT1
       SUBB   #8
       ADDB   #32
       STD    <XT1
       PULS   D
       SUBB   #32
       ADDB   #8
       STB    <YT1
       JSR    CLRTIR

       LDX    #0
BMTRM0 LDA    <HPTTIR
       STA    <CPTLT

BMTRM1 TFR    X,U
       LEAX   BUFFER,S  test d'interrupt
       LDD    #$0D35
       LBSR   SBREAK
       LBCS   MTRETA    ->
       TFR    U,X
       DEC    <CPTLT
       LDA    <CPTLT
       CMPA   #-1
       BEQ    BMTRM2    ->
       JSR    LECTXY
       BEQ    BMTRM1    ->
       PSHS   X
       CLRA
       LDB    <CPTLT
       ADDD   #32
       TFR    D,X
       LDD    <LPTTIR
       SUBD   ,S
       ADDD   #7
       TFR    D,Y
       LDB    #PSETXY
       JSR    EXTRA
       PULS   X
       LBRA   BMTRM1    ->

BMTRM2 LEAX   1,X
       CMPX   <LPTTIR
       LBNE   BMTRM0    ->

       LBRA   MTFIN     ->

*** Expension tiroir
MTEXP  EQU    *
       CLRB
       JSR    FENFER
       LEAX   FFEXPT,PCR
       LDD    #0
       JSR    FENOUV

       LDA    #2        tortue invisible
       STA    MMTOR,S
       CLRB
       JSR    FENTOR

       LDD    #32       zone délimitée
       STD    X0TIRE
       LDD    #8
       STD    Y0TIRE
       LDA    TLIGN
       PSHS   A
       LDA    #1
       STA    TLIGN
       CLR    FILFLG
       LDX    REGX
       STX    X1TIRE
       LDY    REGY
       STY    Y1TIRE
       JSR    TRINV
       JSR    TRRECT
       JSR    TRINV
       JSR    TRLIGN
       PULS   A
       STA    TLIGN

* Sélection nouvelle forme

       JSR    FENACT

EXSFT1 LDU    #PILFEN
       JSR    FEN
       PSHU   CC,D,X,Y
       CMPB   #FF
       BNE    EXSFT2    ->

EXSFTA CLRB             RAZ !
       JSR    FENFER
       LDD    #0        tortue std
       JSR    FENTOR
       LBRA   MTRETA    ->

*** Tester la gestion souris

EXSFT2 LDA    REGCC
       TFR    A,CC
       LBCC   EXSFT8    ->

EXSFT3 JSR    LPIN
       BCS    EXSFT3    ->

*** Clic de sélection

*      calcul dimensions point de la
*      zone... on ignore si trop petite
*      (erreur probable !)
       LDD    Y1TIRE
       SUBD   Y0TIRE
       ADDD   #1
       CMPD   #8
       LBCS   EXSFT1    ->
       LDD    X1TIRE
       SUBD   X0TIRE
       ADDD   #1
       CMPD   #8
       LBCS   EXSFT1    ->

       CLRB
       JSR    FENFER
       LDD    #0        tortue std
       JSR    FENTOR
       LDD    #$0104    fond tramé
       LDY    #$174A
       JSR    FENLOC
       JSR    FENTRA
       LDD    X1TIRE
       STD    <XT1
       LDD    Y1TIRE
       STB    <YT1
       JSR    CLRTIR

       LDD    X1TIRE    calcul rapport
       SUBD   X0TIRE    largeur
       ADDD   #1
       STD    FACMO
       LDA    #2
       STA    VALTYP
       LDA    #4
       LDB    #FRCTYP
       JSR    EXTRA
       LDB    #MOVAF
       JSR    EXTRA
       LDA    #2
       STA    VALTYP
       LDD    <LPTTIR
       STD    FACMO
       LDA    #4
       LDB    #FRCTYP
       JSR    EXTRA
       LDB    #DIVGO
       JSR    EXTRA
       LEAX   COEFTL,S
       LDB    #MOVMF
       JSR    EXTRA

       LDB    #MOVAF    voir si coef > 1
       JSR    EXTRA
       LDD    #1
       STD    FACMO
       LDA    #2
       STA    VALTYP
       LDA    #4
       LDB    #FRCTYP
       JSR    EXTRA
       LDB    #SUBGO
       JSR    EXTRA
       LDB    #SGN
       JSR    EXTRA
       LDD    FACMO
       STB    MULTL,S

       LDD    Y1TIRE    calcul rapport
       SUBD   Y0TIRE    largeur
       ADDD   #1
       STD    FACMO
       LDA    #2
       STA    VALTYP
       LDA    #4
       LDB    #FRCTYP
       JSR    EXTRA
       LDB    #MOVAF
       JSR    EXTRA
       LDA    #2
       STA    VALTYP
       CLRA
       LDB    <HPTTIR
       STD    FACMO
       LDA    #4
       LDB    #FRCTYP
       JSR    EXTRA
       LDB    #DIVGO
       JSR    EXTRA
       LEAX   COEFTH,S
       LDB    #MOVMF
       JSR    EXTRA
       CLR    MMNOIR,S

       LDB    #MOVAF    voir si coef > 1
       JSR    EXTRA
       LDD    #1
       STD    FACMO
       LDA    #2
       STA    VALTYP
       LDA    #4
       LDB    #FRCTYP
       JSR    EXTRA
       LDB    #SUBGO
       JSR    EXTRA
       LDB    #SGN
       JSR    EXTRA
       LDD    FACMO
       STB    MULTH,S

       LDX    #0        expension
       STX    MEMXT,S
BMTRE0 CLR    <CPTLT

       LEAX   BUFFER,S  test d'interrupt
       LDD    #$0D35
       LBSR   SBREAK
       LBCS   MTRETA    ->
BMTRE1 LDX    MEMXT,S
       JSR    LECTXY
       LBNE   LMTR90    pt noir ->

       TST    MMNOIR,S
       LBEQ   LMTRE9    lg blanche ->

       COM    MMNOIR,S
       LEAX   COEFTH,S  calcul coord. y
       LDA    #4        fin de ligne
       STA    VALTYP
       LDB    #MOVFM
       JSR    EXTRA
       LDB    #MOVAF
       JSR    EXTRA
       CLRA
       LDB    <CPTLT
       TST    MULTH,S
       BPL    LMTR40    ->
       DECB
LMTR40 STD    FACMO
       LDA    #2
       STA    VALTYP
       LDA    #4
       LDB    #FRCTYP
       JSR    EXTRA
       LDB    #MULTGO
       JSR    EXTRA
       LDA    #2
       LDB    #FRCTYP
       JSR    EXTRA
       LDD    FACMO
       TST    MULTH,S
       BMI    LMTR50    ->
       SUBD   #1
LMTR50 STD    NEWYT1,S

       LDX    NEWXT0,S  tracé ligne en
       LEAX   32,X
       STX    XXXXXX    cours
       LDX    NEWXT1,S
       LEAX   32,X
       CMPX   X1TIRE
       BLE    BMTR70    ->
       LDX    X1TIRE
BMTR70 LDY    NEWYT0,S
       LEAY   8,Y
       STY    YYYYYY
       LDY    NEWYT1,S
       LEAY   8,Y
       CMPY   Y1TIRE
       BLE    BMTR71    ->
       LDY    Y1TIRE
BMTR71 LDA    #$FF
       STA    FILFLG
       LDD    #PLEIN
       STD    MACP
       LDB    #BOX
       CMPX   XXXXXX
       BNE    BMTR91    ->
       LDB    #LINE
BMTR91 JSR    EXTRA
       LBRA   LMTRE9    ->

LMTR90 TST    MMNOIR,S
       LBNE   LMTRE9    suite ligne ->

       COM    MMNOIR,S
       LEAX   COEFTL,S  calcul coord.
       LDA    #4        debut ligne
       STA    VALTYP
       LDB    #MOVFM
       JSR    EXTRA
       LDB    #MOVAF
       JSR    EXTRA
       LDX    MEMXT,S
       STX    FACMO
       LDA    #2
       STA    VALTYP
       LDA    #4
       LDB    #FRCTYP
       JSR    EXTRA
       LDB    #MULTGO
       JSR    EXTRA
       LDA    #2
       LDB    #FRCTYP
       JSR    EXTRA
       LDD    FACMO
       STD    NEWXT0,S
       STD    NEWXT1,S
       TST    MULTL,S
       BLE    LMTRE0    ->

       LEAX   COEFTL,S calcul nb pt en x
       LDA    #4
       STA    VALTYP
       LDB    #MOVFM
       JSR    EXTRA
       LDB    #MOVAF
       JSR    EXTRA
       LDX    MEMXT,S
       LEAX   1,X
       STX    FACMO
       LDA    #2
       STA    VALTYP
       LDA    #4
       LDB    #FRCTYP
       JSR    EXTRA
       LDB    #MULTGO
       JSR    EXTRA
       LDA    #2
       LDB    #FRCTYP
       JSR    EXTRA
       LDD    FACMO
       SUBD   #1
       CMPD   NEWXT0,S
       BLE    LMTRE0    ->
       STD    NEWXT1,S

LMTRE0 LEAX   COEFTH,S  calcul coord. y
       LDA    #4        deb de ligne
       STA    VALTYP
       LDB    #MOVFM
       JSR    EXTRA
       LDB    #MOVAF
       JSR    EXTRA
       CLRA
       LDB    <CPTLT
       STD    FACMO
       LDA    #2
       STA    VALTYP
       LDA    #4
       LDB    #FRCTYP
       JSR    EXTRA
       LDB    #MULTGO
       JSR    EXTRA
       LDA    #2
       LDB    #FRCTYP
       JSR    EXTRA
       LDD    FACMO
       STD    NEWYT0,S
       STD    NEWYT1,S  si pas d'augment

LMTRE9 INC    <CPTLT    # fin d'un pt
       LDA    <CPTLT
       CMPA   <HPTTIR
       LBNE   BMTRE1    ->

       TST    MMNOIR,S  # fin d'une lign
       LBEQ   BMTR93    lig blanche ->

       COM    MMNOIR,S
       TST    MULTH,S   calcul coord. y
       BEQ    LMTR60    ->
       LEAX   COEFTH,S
       LDA    #4
       STA    VALTYP
       LDB    #MOVFM
       JSR    EXTRA
       LDB    #MOVAF
       JSR    EXTRA
       CLRA
       LDB    <CPTLT
       STD    FACMO
       LDA    #2
       STA    VALTYP
       LDA    #4
       LDB    #FRCTYP
       JSR    EXTRA
       LDB    #MULTGO
       JSR    EXTRA
       LDA    #2
       LDB    #FRCTYP
       JSR    EXTRA
       LDD    FACMO
       SUBD   #1
       STD    NEWYT1,S

LMTR60 LDX    NEWXT0,S  tracé ligne en
       LEAX   32,X      cours
       STX    XXXXXX
       LDX    NEWXT1,S
       LEAX   32,X
       CMPX   X1TIRE
       BLE    BMTR80    ->
       LDX    X1TIRE
BMTR80 LDY    NEWYT0,S
       LEAY   8,Y
       STY    YYYYYY
       LDY    NEWYT1,S
       LEAY   8,Y
       CMPY   Y1TIRE
       BLE    BMTR81    ->
       LDY    Y1TIRE
BMTR81 LDA    #$FF
       STA    FILFLG
       LDD    #PLEIN
       STD    MACP
       LDB    #BOX
       CMPX   XXXXXX
       BNE    BMTR92    ->
       LDB    #LINE
BMTR92 JSR    EXTRA

BMTR93 LDX    MEMXT,S
       LEAX   1,X
       STX    MEMXT,S
       CMPX   <LPTTIR
       LBNE   BMTRE0    ->

       LBRA   MTFIN     ->

*** Gestion annulation souris
EXSFT8 LDA    REGCC
       TFR    A,CC
       BNE    EXSFT9    ->
EXSFTZ JSR    LPIN      clic droit !
       BEQ    EXSFTZ    ->
       LBRA   EXSFTA    ->

*** Gestion déplacement
EXSFT9 LDA    REGA
       LBEQ   EXSFT1    ->
       LDX    #$0104
       LDY    #$174A
       JSR    SOUDAN
       BCS    EXST00    ->
       TST    MMTOR,S
       LBEQ   EXSFT1    ->
       LDD    #0        tortue std
       STA    MMTOR,S
       JSR    FENTOR
       LBRA   EXSFT1    ->
EXST00 LDA    MMTOR,S
       CMPA   #2
       BEQ    EXST01    ->
       LDA    #2        tortue invisible
       STA    MMTOR,S
       CLRB
       JSR    FENTOR
EXST01 JSR    FENDES
       LDA    TLIGN
       PSHS   A
       LDA    #1
       STA    TLIGN
       JSR    TRINV     ancien tracé
       CLR    FILFLG
       JSR    TRRECT
       JSR    TRINV
       JSR    TRLIGN

       LDX    REGX      nouveau tracé
       STX    X1TIRE
       LDY    REGY
       STY    Y1TIRE
       JSR    TRINV
       JSR    TRRECT
       JSR    TRINV
       JSR    TRLIGN
       PULS   A
       STA    TLIGN
       JSR    FENACT
       LBRA   EXSFT1    ->

*** Demande de confirmation de la modif.
MTFIN  EQU    *
       LEAX   FFCNFT,PCR
       LDB    REGY+1
       LSRB
       LSRB
       LSRB
       LDA    #19
       CMPB   #19
       BLE    MTFIN0    ->
       TFR    A,B
MTFIN0 PSHS   B
       LDD    REGX
       LSRA
       RORB
       LSRA
       RORB
       LSRB
       LDA    #57
       CMPB   #57
       BLE    MTFIN1    ->
       TFR    A,B
MTFIN1 PULS   A
       JSR    FENOUV
       JSR    FENACT
MTFIN2 LDU    #PILFEN
       JSR    FEN
       PSHU   CC,D,X,Y
       CMPB   #RC
       BEQ    MTFINO    ok ->
       CMPB   #FF
       BEQ    MTFINA    annul. ->
       BRA    MTFIN2    ->

*** Confirmation / lect. nouveau tiroir
MTFINO CLRB
       JSR    FENFER

       JSR    LITTIR    Nb: XT0 ... sont
*                           ok !

       LBRA   MTRET     ->

*** Annulation / revisu. tiroir
MTFINA CLRB
       JSR    FENFER
MTRETA LDD    #$0104    fond tramé
       LDY    #$174A
       JSR    FENLOC
       JSR    FENTRA
       LDX    #32
       LDY    #8
       LDA    #1
       JSR    VISTIR

* Fin du traitement du tiroir
*---------------------------------------

MTRET  JSR    FENACT
       LEAS   920,S
       RTS


*=======================================
* S/P traitement de la fenêtre de
*     cadrage de la feuille
*
* Entrée: A  =0   cadrage seul
*            #0   +sélection zone
*
* Sortie: <ADF    pour le cadrage
*    et si sélection zone:
*         CADRNG  rangée début  (0..101)
*         CADCOL  colonne début (0..69 )
*         CADHAU  hauteur       (1..102)
*         CADLAR                (1..120)
*         B       sélection externe even
*         A       interrupteur pleine
*                 page
*         Z    1  zone ok
*              0  feuille vide ou aband.
*=======================================

SPCADR PSHS   U
       LDU    #XSPCAD
       JSR    COMBK2
       PULS   U,PC


*=======================================
* S/P visualisation du tiroir
*
* Entrée: X   coord. graphique haut
*         Y   gauche
*         A   #0 si effacement préalable
*=======================================

VISTIR LDU    #XVISTI
       JSR    COMBK2
       RTS
