       TITLE  TO-GRAPH: Traitement
*      ------------------------------
       PAGE

****************************************
*                                      *
*           TO-GRAPH                   *
*                                      *
*    Traitement: GRAPH-X               *
*                                      *
****************************************


*=======================================
* S/P traitement du réaffichage de
*     l'outil caractère
*=======================================

AFFCAR LEAS   -1,S
MEMACT SET    0
*---------------------------------------

       LDA    OUTIL
       CMPA   #CARACT
       BNE    AFFCAF    ->
       LDB    TCAR
       SUBB   #TCN
       PSHS   B
       LSLB
       ADDB   ,S+
       LDX    #TABTOR
       ABX
       LDY    ,X
       LDB    2,X

       LDA    ETAOUT
       CMPA   #POINTE
       BEQ    AFFCA0    ->

       PSHS   B         copie en RAM
       LDX    #TFORME
COPTO0 LDA    ,Y+
       STA    ,X+
       DECB
       BNE    COPTO0    ->
       PULS   B

       STB    FACLO     compil sur place
       LDX    #TFORME
       LDY    #TFORME
       LDB    #CMPTOR
       JSR    EXTRA

       LDY    #TORTXT
       LDA    #$FF
       LDB    #SHOW
       JSR    EXTRA
       BRA    AFFCAF    ->

AFFCA0 TST    STDTOR
       BNE    AFFCAF    hors écran ! ->
       TFR    Y,X
       LDA    #1
       JSR    FENTOR

AFFCAF LEAS   1,S
       RTS


*=======================================
* S/P décalage droite/gauche du tiroir
*     pour mettre les 1ers points de
*     chaque ligne dans une colonne
*     donnée
* Entrée: B  rang à obtenir pour 1er pt
*            (0..7)
*=======================================

DECALT PSHS   U
       LDU    #XDECAL
       JSR    COMBK2
       PULS   U,PC


*=======================================
* S/P génération d'un dessin tortue
*     d'avance éventuellement décomposé
*     en plusieurs (max soft 255)
*
* Entrée: D  déplacement
*         X  chaine rangement
* Sortie: X  ...
*=======================================

DEPTOR PSHS   U
       LDU    #XDEPTO
       JSR    COMBK2
       PULS   U,PC


*=======================================
* S/P traitement d'effacement de l'outil
*     caractère
*=======================================

EFFCAR LEAS   -1,S
MEMACT SET    0
*---------------------------------------

       LDA    OUTIL
       CMPA   #CARACT
       BNE    EFFCAF    ->
       LDA    ETAOUT
       CMPA   #TIRE
       BNE    EFFCAF    ->
       LDY    #TORTXT
       CLRA
       LDB    #SHOW
       JSR    EXTRA
EFFCAF LEAS   1,S
       RTS


*=======================================
* S/P traitement visu/effac. des outils
*     ligne en mode TIRE
*=======================================

INVLIG EQU    *
*---------------------------------------

       LDA    ETAOUT
       CMPA   #TIRE
       BNE    XIF       ->
       LDB    OUTIL
       LSLB
       ADDB   OUTIL
       LEAX   XINOUT,PCR
       JSR    B,X
XIF    RTS              ->>
*---------------------------------------
XINOUT LBRA   XIF       points
       LBRA   XILIGN
       LBRA   XIRECT
       LBRA   XIRECT    carré
       LBRA   XIELLI
       LBRA   XIELLI    cercle
       LBRA   XIF       caractère
       LBRA   XIF       peinture
       LBRA   XIF       gomme
       LBRA   XIF       loupe
       LBRA   XIF       couper copier
       LBRA   XIF       coller
*---------------------------------------

XIRECT EQU    *
*-----
       JSR    FENDES
       JSR    TRINV     ancien tracé
       CLR    FILFLG
       JSR    TRRECT
       JSR    FENACT
       RTS

XILIGN
*-----
       JSR    FENDES
       JSR    TRINV     ancien tracé
       JSR    TRLIGN
       JSR    FENACT
       RTS

XIELLI EQU    *
*-----
       JSR    FENDES
       JSR    TRINV     ancien tracé
       CLR    FILFLG
       JSR    TRELLI
       JSR    FENACT
       RTS


*=======================================
* S/P expension d'un caractère dans
*     les 4 tailles standards en la
*     position souris courante
*
* Entrée: X      coordonnées souris
*         Y
*         TXTMOT motif du caractère
*=======================================

EXPCAR PSHS   D,X,Y,U
       LEAS   -4,S
CPTC   SET    0
FLGL   SET    1       flag double haut
FLGC   SET    2       flag double larg
LIGMOT SET    3
PD     SET    4
PX     SET    6
PY     SET    8
*---------------------------------------
       LDB    #$13      transparent ?
       JSR    FENCH
       LDB    VAL,X
       CMPB   #ON
       BEQ    EXPA0     ->
       JSR    TRRAZ     effacement zone
       LDA    #$FF
       STA    FILFLG
       LDD    #PLEIN
       STD    MACP
       LDX    PX,S
       STX    XXXXXX
       LDY    PY,S
       STY    YYYYYY
       LEAX   7,X
       LEAY   -7,Y
       LDA    TCAR
       CMPA   #TCN
       BEQ    EXPA01    ->
       CMPA   #TCDH
       BEQ    EXPA00    ->
       LEAX   8,X
       CMPA   #TCDL
       BEQ    EXPA01    ->
EXPA00 LEAY   -8,Y
EXPA01 LDB    #BOX
       JSR    EXTRA
       JSR    TRNORM

EXPA0  LDY    PY,S
       LDU    #TXTMOT

EXPA1  CLR    FLGL,S
EXPA2  LDA    #8
       STA    CPTC,S
       LDX    PX,S
       LDA    ,U
       STA    LIGMOT,S

EXPA3  CLR    FLGC,S
EXPA4  LDA    LIGMOT,S
       LSLA
       BCC    EXPA5     ->
       LDB    #PSETXY
       JSR    EXTRA

EXPA5  LEAX   1,X

       TST    FLGC,S
       BNE    EXPA6     ->
       COM    FLGC,S
       LDA    TCAR
       CMPA   #TCN
       BEQ    EXPA6     ->
       CMPA   #TCDH
       BEQ    EXPA6     ->
       BRA    EXPA4     double larg. ->

EXPA6  LSL    LIGMOT,S
       DEC    CPTC,S
       BNE    EXPA3     ->

       LEAY   -1,Y

       TST    FLGL,S
       BNE    EXPA7     ->
       COM    FLGL,S
       LDA    TCAR
       CMPA   #TCN
       BEQ    EXPA7     ->
       CMPA   #TCDL
       BEQ    EXPA7     ->
       BRA    EXPA2     double haut. ->

EXPA7  LEAU   1,U
       CMPU   #TXTMOT+8
       LBNE   EXPA1     ->

       JSR    TRNORM

       LEAS   4,S
       PULS   D,X,Y,U,PC


*=======================================
* S/P inversion du tiroir pour visu.
*     temporaire
*=======================================

INVTIR PSHS   U
       LDU    #XINVTI
       JSR    COMBK2
       PULS   U,PC


*=======================================
* S/P efface la loupe de pointage
*=======================================

RAZLOU LEAS   -1,S
MEMTL  SET    0
*---------------------------------------
       JSR    FENDES
       LDA    TLIGN
       STA    MEMTL,S
       LDA    #2
       STA    TLIGN
       TST    FLGLOU
       BEQ    RAZLOF    ->

       JSR    TRINV
       CLR    FILFLG
       JSR    TRRECT

       LDA    FLGLOU
       CMPA   #2
       BNE    RAZLOF    ->

       LDA    $E7C3     restau 1ére page
       ORA    #1
       STA    $E7C3
       LDX    #$4000
       LEAX   40*8*3,X
       LDB    COLLOU
       LSRB
       LEAX   B,X
       LDA    #BKMANO
       STA    BANKC
       LDY    #$A000
       LDU    #18*8
RAZLO0 LDA    #9
RAZLO1 LDB    ,Y+
       STB    ,X+
       DECA
       BNE    RAZLO1    ->
       LEAX   31,X
       LEAU   -1,U
       CMPU   #0
       BNE    RAZLO0    ->

       LDA    $E7C3     sauver 2éme page
       EORA   #1
       STA    $E7C3
       LDX    #$4000
       LEAX   40*8*3,X
       LDB    COLLOU
       LSRB
       LEAX   B,X
       LDU    #18*8
RAZLO2 LDA    #9
RAZLO3 LDB    ,Y+
       STB    ,X+
       DECA
       BNE    RAZLO3    ->
       LEAX   31,X
       LEAU   -1,U
       CMPU   #0
       BNE    RAZLO2    ->
       LDA    #BKTIR
       STA    BANKC

RAZLOF CLR    FLGLOU
       LDA    MEMTL,S
       STA    TLIGN
       LEAS   1,S
       RTS


*=======================================
* S/P visualise tortue selon tiroir
*     (tortue std si tiroir vide)
*=======================================

TORCOL LEAS   -80,S
DEBTOR SET    0
*---------------------------------------
       TST    FLGTIR
       BNE    TORCO0    ->
       LDD    #0       tortue std
       LBRA   TORCOF    ->
TORCO0 EQU    *
       LEAX   DEBTOR,S
       LDD    #$4C31    'L128'
       STD    ,X++
       LDD    #$3238
       STD    ,X++
       LDA    #$55      'Uxxx'
       STA    ,X+
       LDD    <LPTTIR
       LSRA
       RORB
       JSR    DEPTOR
       LDD    #$5236    'R64Uxxx'
       STD    ,X++
       LDD    #$3455
       STD    ,X++
       CLRA
       LDB    <HPTTIR
       LSRB
       JSR    BINDCG
       ABX
       LDD    #$4C31    'L128'
       STD    ,X++
       LDD    #$3238
       STD    ,X++
       LDA    #$44      'Dxxx'
       STA    ,X+
       CLRA
       LDB    <HPTTIR
       DECB
       JSR    BINDCG
       ABX
       LDD    #$4C36    'L64Dxxx'
       STD    ,X++
       LDD    #$3444
       STD    ,X++
       LDD    <LPTTIR
       SUBD   #1
       JSR    DEPTOR
       LDD    #$4C36    'L64Dxxx'
       STD    ,X++
       LDD    #$3444
       STD    ,X++
       CLRA
       LDB    <HPTTIR
       DECB
       JSR    BINDCG
       ABX
       LDD    #$4C36    'L64Dxxx'
       STD    ,X++
       LDD    #$3444
       STD    ,X++
       LDD    <LPTTIR
       SUBD   #1
       JSR    DEPTOR
       TFR    X,D
       LEAX   DEBTOR,S
       PSHS   X
       SUBD   ,S++
       LDA    #1

TORCOF JSR    FENTOR
       JSR    FENACT
       LEAS   80,S
       RTS


*=======================================
* S/P fixe fenêtre graphique sur zone
*     travail
*=======================================

TRAMIN PSHS   D
       LDD    #32
       STD    XL
       LDD    #623
       STD    XR
       LDD    #8
       STD    YB
       LDD    #191
       STD    YT
       PULS   D,PC


*=======================================
* S/P fixe fenêtre graphique sur écran
*     total
*=======================================

TRAMAX PSHS   D
       LDD    #0      restaure écr trav
       STD    XL
       STD    YB
       LDD    #639
       STD    XR
       LDD    #199
       STD    YT
       PULS   D,PC


*=======================================
* S/P tracé d'une ellipse dans les 3
*     tailles possibles
* Entrée: X0TIRE coordonnées centre
*         Y0TIRE
*         X1TIRE rayons
*         Y1TIRE
* Nb: Le mode de dessin doit être
*     déterminé à l'appel il est remis
*     en normal après traitement ...
*     Idem pour FILFLG
*=======================================

TRELLI PSHS   D,X,Y
*---------------------------------------
       JSR    TRAMIN

       LDX    X0TIRE
       STX    XXXXXX
       LDA    X1TIRE
       STA    AXEH
       LDY    Y0TIRE
       STY    YYYYYY
       LDA    Y1TIRE
       STA    AXEV
       CLR    CAMFLG
       LDB    #CIRCLE
       JSR    EXTRA
       LDB    TLIGN
       CMPB   #1
       BEQ    TRELLF    ->
       CLR    FILFLG
       LDA    X1TIRE
       INCA
       STA    AXEH
       LDA    Y1TIRE
       INCA
       STA    AXEV
       LDB    #CIRCLE
       JSR    EXTRA
       LDB    TLIGN
       CMPB   #2
       BEQ    TRELLF    ->
       LDA    X1TIRE
       INCA
       INCA
       STA    AXEH
       LDA    Y1TIRE
       INCA
       INCA
       STA    AXEV
       LDB    #CIRCLE
       JSR    EXTRA

TRELLF JSR    TRAMAX
       JSR    TRNORM
       PULS   D,X,Y,PC


*=======================================
* S/P tracé d'une droite dans les 3
*     tailles possibles
* Entrée: X0TIRE coordonnées
*         Y0TIRE
*         X1TIRE
*         Y1TIRE
* Nb: Le mode de dessin doit être
*     déterminé à l'appel il est remis
*     en normal après traitement ...
*=======================================

TPOINT FCB    0,0,0,1,1,1,1,0,1,-1,0,-1
       FCB    -1,-1,-1,0,-1,1
TPTV   FCB    0,0,0,1,0,-1
TPTH   FCB    0,0,1,0,-1,0
*---------------------------------------
TRLIGN PSHS   D,X,Y,U
       LEAS   -5,S
NBPTS  SET    0
DELTAX SET    1
DELTAY SET    3
*---------------------------------------
       JSR    TRAMIN

       LDA    TLIGN     calcul nb points
       TFR    A,B       pour un pavé
       MUL
       STB    NBPTS,S
       LEAU   TPOINT,PCR
       LDD    X0TIRE
       CMPD   X1TIRE
       BNE    LTRLI0    ->
       LDD    Y0TIRE
       CMPD   Y1TIRE
       BNE    LTRLI0    ->
       LBRA   BTRLI0    pavé ->

LTRLI0 LDA    TLIGN     cas des tracés
       STA    NBPTS,S
       LDD    X1TIRE
       SUBD   X0TIRE
       BGE    LTRLI1    ->
       LDD    X0TIRE
       SUBD   X1TIRE
LTRLI1 STD    DELTAX,S
       LDD    Y1TIRE
       SUBD   Y0TIRE
       BGE    LTRLI2    ->
       LDD    Y0TIRE
       SUBD   Y1TIRE
LTRLI2 STD    DELTAY,S
       CMPD   DELTAX,S
       BGE    LTRLIH    ->
       LEAU   TPTV,PCR  pts verticaux
       BRA    BTRLI0    ->
LTRLIH LEAU   TPTH,PCR  pts horizontaux

BTRLI0 LDX    X0TIRE
       LDA    ,U
       LEAX   A,X
       STX    XXXXXX
       LDX    X1TIRE
       LDA    ,U+
       LEAX   A,X
       LDY    Y0TIRE
       LDA    ,U
       LEAY   A,Y
       STY    YYYYYY
       LDY    Y1TIRE
       LDA    ,U+
       LEAY   A,Y
       LDB    #LINE
       JSR    EXTRA

       DEC    NBPTS,S
       BNE    BTRLI0    ->

       JSR    TRAMAX
       JSR    TRNORM
       LEAS   5,S
       PULS   D,X,Y,U,PC


*=======================================
* S/P tracé d'un rectangle dans les 3
*     tailles possibles
* Entrée: X0TIRE coordonnées début
*         Y0TIRE
*         X1TIRE coordonnées fin
*         Y1TIRE
* Nb: Le mode de dessin doit être
*     déterminé à l'appel il est remis
*     en normal après traitement ...
*     Idem pour FILFLG
*=======================================

TRRECT PSHS   D,X,Y,U
       LEAS   -8,S
X0LOC  SET    0
Y0LOC  SET    2
X1LOC  SET    4
Y1LOC  SET    6
*---------------------------------------
       JSR    TRAMIN

       LDD    X0TIRE    Mettre les coor.
       LDX    X1TIRE    au mieux !!!
       CMPD   X1TIRE
       BCS    RGPLG0    ->
       EXG    D,X
RGPLG0 STD    X0LOC,S
       STX    X1LOC,S

       LDD    Y0TIRE
       LDX    Y1TIRE
       CMPD   Y1TIRE
       BCS    RGPLG1    ->
       EXG    D,X
RGPLG1 STD    Y0LOC,S
       STX    Y1LOC,S

       LEAU   X0LOC,S
       BSR    TRBOX

       LDB    TLIGN
       CMPB   #1
       BEQ    TRRECF    ->
       CLR    FILFLG
       LDD    X0LOC,S
       SUBD   #1
       STD    X0LOC,S
       LDD    Y0LOC,S
       SUBD   #1
       STD    Y0LOC,S
       LDD    X1LOC,S
       ADDD   #1
       STD    X1LOC,S
       LDD    Y1LOC,S
       ADDD   #1
       STD    Y1LOC,S
       BSR    TRBOX

       LDB    TLIGN
       CMPB   #2
       BEQ    TRRECF    ->
       LDD    X0LOC,S
       SUBD   #1
       STD    X0LOC,S
       LDD    Y0LOC,S
       SUBD   #1
       STD    Y0LOC,S
       LDD    X1LOC,S
       ADDD   #1
       STD    X1LOC,S
       LDD    Y1LOC,S
       ADDD   #1
       STD    Y1LOC,S
       BSR    TRBOX

TRRECF JSR    TRAMAX
       JSR    TRNORM
       LEAS   8,S
       PULS   D,X,Y,U,PC ->>
*---------------------------------------

TRBOX  LDX    X0LOC,U
       STX    XXXXXX
       LDX    X1LOC,U
       LDY    Y0LOC,U
       STY    YYYYYY
       LDY    Y1LOC,U
       LDB    #BOX
       JSR    EXTRA
       RTS


*=======================================
* S/P sélection du mode de tracé
*=======================================

TRNORM PSHS   D       # normal
       CLRA
       BRA    TRCHOI    ->
TRTRAN PSHS   D       # transparent
       LDA    #1
       BRA    TRCHOI    ->
TRINV  PSHS   D       # inversion
       LDA    #2
       BRA    TRCHOI    ->
TRRAZ  PSHS   D       # tracé en 0
       CLRA
       STA    TRATYP
       LDA    #-1
       STA    COULGR
       BRA    XTR0      ->
TRCHOI STA    TRATYP
       CLR    COULGR
XTR0   LDB    #CHOIX
       JSR    EXTRA
       PULS   D,PC


*=======================================
* S/P détermination des variables de
*     tracé pour les remplissages
*=======================================

TRREMP JSR    TRNORM
       JSR    TRAMIN
       CLR    FILFLG
       LDB    #$12      rempli ?
       JSR    FENCH
       LDB    VAL,X
       CMPB   #OFF
       BEQ    TRREM0    ->
       COM    FILFLG
       LDD    #MOTIF
       STD    MACP
       LDB    #$13      transparent ?
       JSR    FENCH
       LDB    VAL,X
       CMPB   #OFF
       BEQ    TRREM0    ->
       JSR    TRTRAN
TRREM0 RTS


*=======================================
* S/P visualisation temporaire de la
*     loupe sous forme d'une boite en
*     taille 3 selon les coord.
*            (REGX/REGY)
*     Si FLGLOU = 0 on suppose 1er passe
*=======================================

VISLOU LEAS   -1,S
MEMTL  SET    0
*---------------------------------------
       JSR    FENDES
       JSR    TRINV
       LDA    TLIGN
       STA    MEMTL,S
       LDA    #2
       STA    TLIGN
       TST    FLGLOU
       BEQ    NOUVL0    ->
       JSR    TRINV
       CLR    FILFLG
       JSR    TRRECT

NOUVL0 LDA    #1
       STA    FLGLOU
       LDD    REGY
       CMPD   #24
       BGT    NOUVL1    ->
       LDD    #7
       BRA    NOUVL5    ->
NOUVL1 CMPD   #176
       BLT    NOUVL2    ->
       LDD    #159
       BRA    NOUVL5    ->
NOUVL2 SUBD   #17

NOUVL5 STD    Y0TIRE
       ADDD   #33
       STD    Y1TIRE

       LDD    REGX
       CMPD   #48
       BGT    NOUVL6    ->
       LDD    #31
       BRA    NOUVL9    ->
NOUVL6 CMPD   #608
       BLT    NOUVL7    ->
       LDD    #591
       BRA    NOUVL9    ->
NOUVL7 SUBD   #17

NOUVL9 STD    X0TIRE
       ADDD   #33
       STD    X1TIRE

       JSR    TRINV
       CLR    FILFLG
       JSR    TRRECT

       JSR    FENACT
       LDA    MEMTL,S
       STA    TLIGN
       LEAS   1,S
       RTS


*=======================================
* S/P visualisation temporaire du
*     tiroir en la position souris
*     courante (REGX/REGY)
*     Maintient jusqu'à:
*        - déplacement souris
*        - clic gauche
*        - fin clic droit
*=======================================

TMPTIR EQU    *
*---------------------------------------
       JSR    FENDES
       TST    FLGTIR
       BNE    VISTI0    ok ->
       LDX    #MTIRVI
       JSR    FENERR
       LBRA   VISTIF    ->

VISTI0 JSR    INVTIR    visu. tempor.
VISTI1 JSR    GETL
       BCS    VISTI1    ->
       CMPX   REGX
       BNE    VISTI9    déplac. ->
       CMPY   REGY
       BNE    VISTI9    déplac. ->
       JSR    LPIN
       BCS    VISTI9    clic gauche ->
       BNE    VISTI9    fin .. droit->
       BRA    VISTI1    ->
VISTI9 JSR    INVTIR    fin visu. temp.

VISTIF JSR    FENACT
       RTS
