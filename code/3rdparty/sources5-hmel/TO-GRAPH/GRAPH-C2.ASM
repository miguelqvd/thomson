       TITLE  TO-GRAPH: S/P cartouche 2
*      ---------------------------------
       PAGE

****************************************
*                                      *
*           TO-GRAPH                   *
*                                      *
*    S/P de la cartouche no 2          *
*                                      *
****************************************


*=======================================
* S/P décalage droite/gauche du tiroir
*     pour mettre les 1ers points de
*     chaque ligne dans une colonne
*     donnée
* Entrée: B  rang à obtenir pour 1er pt
*            (0..7)
*=======================================

XDECAL PSHS   D,X
       LEAS   -1,S
CPTDEC SET    0
PA     SET    1
PB     SET    2
*---------------------------------------
       SUBB   <DECTIR
       LBEQ   DECTF     déja ok  ->
       BMI    DECTG     à gauche ->
       STB    CPTDEC,S  # à droite
       LDB    PB,S
       STB    <DECTIR
BDCDD  LDX    #ZONTRA
       LDA    <HPTTIR
BDCDL  LDB    <LARTIR
       ANDCC  #$FE
BDCDC  ROR    ,X+
       DECB
       BNE    BDCDC     ->
       DECA
       BNE    BDCDL     ->
       DEC    CPTDEC,S
       BNE    BDCDD     ->
       BRA    DECTF         ->

DECTG  NEGB             # à gauche
       STB    CPTDEC,S
       LDB    PB,S
       STB    <DECTIR
BDCGD  LDX    #ZONTRA
       LDA    <HPTTIR
       LDB    <LARTIR
       MUL
       LEAX   D,X
       LDA    <HPTTIR
BDCGL  LDB    <LARTIR
       ANDCC  #$FE
BDCGC  ROL    ,-X
       DECB
       BNE    BDCGC     ->
       DECA
       BNE    BDCGL     ->
       DEC    CPTDEC,S
       BNE    BDCGD     ->

DECTF  LEAS   1,S
       PULS   D,X,PC


*=======================================
* S/P génération d'un dessin tortue
*     d'avance éventuellement décomposé
*     en plusieurs (max soft 255)
*
* Entrée: D  déplacement
*         X  chaine rangement
* Sortie: X  ...
*=======================================

XDEPTO PSHS   D
       LEAS   -5,S
DEPCPT SET    0
DEPCOU SET    2
DEPCAR SET    4
PD     SET    5
*---------------------------------------
       LDA    -1,X
       STA    DEPCAR,S
       LDD    PD,S
       STD    DEPCPT,S
DEPTO0 LDD    DEPCPT,S
       CMPD   #255
       BLE    DEPTO1    ->
       LDD    #255
DEPTO1 STD    DEPCOU,S
       LDD    DEPCOU,S
       JSR    BINDCG
       ABX
       LDD    DEPCPT,S
       SUBD   DEPCOU,S
       STD    DEPCPT,S
       BLE    DEPTOF    ->
       LDD    #$4C30    'L0'
       STD    ,X++
       LDA    DEPCAR,S
       STA    ,X+
       BRA    DEPTO0    ->

DEPTOF LEAS   5,S
       PULS   D,PC


*=======================================
* S/P copie d'une page écran vers la
*     zone correspondante de la feuille
*
* Entrée: B  0    page paire
*            1    page impaire
*         RGDECR  emplacement écran
*         CLDECR  dans la feuille
*=======================================

XECRFE PSHS   D,X,Y
       LEAS   -2,S
MEMBK  SET    0
DBK    SET    1
PA     SET    2
PB     SET    3
*---------------------------------------
       LDA    BANKC
       STA    MEMBK,S

* Commut. page écran à sauvegarder
       LDA    $E7C3
       ANDA   #$FE
       ADDA   PB,S
       EORA   #1
       STA    $E7C3
       LDA    #PBKTRA+2
       TST    PB,S
       BEQ    ECFE00    ->
       ADDA   #3
ECFE00 STA    DBK,S

* Calcul de l'adresse RAM début ligne
* initiale de la feuille (bank+déplac.)
       LDA    <RGDECR   *60*8 !
       LSLA
       LDB    #60*4
       MUL
       ADDB   <CLDECR
       ADCA   #0
       ADDD   <ADF
       BCC    ECFE0     ->
       ADDD   #$FFFF-48959
ECFE0  CMPD   #48960
       BCS    ECFE1     ->
       SUBD   #48960
ECFE1  STD    <ADPRRL
       ROLA
       ROLA
       ROLA
       ANDA   #3
       ADDA   PB,S      3 bank par page
       ADDA   PB,S      écran
       ADDA   PB,S
       ADDA   #PBKTRA
       STA    BANKC
       LDD    <ADPRRL
       ANDA   #$3F
       ADDD   #$A000
       STD    <ADPRRL

* Initialisation du 1er segment à lire
* sur l'écran
       LDD    #$4000+8*40+2
       STD    <ADPRSL

* Nb de lignes écran à déplacer (+1)
       LDA    #185
       STA    <CPTLT

* Boucle de copie .. X= ad. écran
*                    Y= ad. RAM
       LDX    <ADPRSL
       LDY    <ADPRRL

BECFE  DEC    <CPTLT
       LBEQ   FECFE     fini ->
       LDA    BANKC
       LDB    #37
       CMPA   DBK,S
       BEQ    ECFE30    dernier bank ->

       CMPY   #$E000-36
       BCS    BECFE1    move 37 ok ->
       PSHS   Y         move en 2 fois
       LDD    #$E000
       SUBD   ,S++
       STB    <CPTCT
BECFE0 LDA    ,X+
       STA    ,Y+
       DECB
       BNE    BECFE0    ->
       INC    BANKC
       LDY    #$A000
       LDB    #37
       SUBB   <CPTCT
BECFE1 LDA    ,X+
       STA    ,Y+
       DECB
       BNE    BECFE1    ->

       LEAX   40-37,X   ligne écran suiv
       LEAY   60-37,Y   ligne feuille
       CMPY   #$E000
       BCS    BECFE     ->
       INC    BANKC
       LEAY   -$4000,Y
       BRA    BECFE     ->

ECFE30 CMPY   #$DF40-36
       BCS    BECFE3    move 37 ok ->
       PSHS   Y         move en 2 fois
       LDD    #$DF40
       SUBD   ,S++
       STB    <CPTCT
BECFE2 LDA    ,X+
       STA    ,Y+
       DECB
       BNE    BECFE2    ->
       DEC    BANKC
       DEC    BANKC
       LDY    #$A000
       LDB    #37
       SUBB   <CPTCT
BECFE3 LDA    ,X+
       STA    ,Y+
       DECB
       BNE    BECFE3    ->

       LEAX   40-37,X   ligne écran suiv
       LEAY   60-37,Y   ligne feuille
       CMPY   #$DF40
       LBCS   BECFE     ->
       DEC    BANKC
       DEC    BANKC
       LEAY   -$DF40,Y
       LEAY   $A000,Y
       LBRA   BECFE     ->

FECFE  LDA    MEMBK,S
       STA    BANKC
       LEAS   2,S
       PULS   D,X,Y,PC


*=======================================
* S/P copie vers une page écran de la
*     zone correspondante de la feuille
*
* Entrée: B  0    page paire
*            1    page impaire
*         RGDECR  emplacement écran
*         CLDECR  dans la feuille
*=======================================

XFEUEC PSHS   D,X,Y
       LEAS   -2,S
MEMBK  SET    0
DBK    SET    1
PA     SET    2
PB     SET    3
*---------------------------------------
       LDA    BANKC
       STA    MEMBK,S

* Commut. page écran à régénérer
       LDA    $E7C3
       ANDA   #$FE
       ADDA   PB,S
       EORA   #1
       STA    $E7C3
       LDA    #PBKTRA+2
       TST    PB,S
       BEQ    FEEC00   ->
       ADDA   #3
FEEC00 STA    DBK,S

* Calcul de l'adresse RAM début ligne
* initiale de la feuille (bank+déplac.)
       LDA    <RGDECR   *60*8 !
       LSLA
       LDB    #60*4
       MUL
       ADDB   <CLDECR
       ADCA   #0
       ADDD   <ADF
       BCC    FEEC0     ->
       ADDD   #$FFFF-48959
FEEC0  CMPD   #48960
       BCS    FEEC1     ->
       SUBD   #48960
FEEC1  STD    <ADPRRL
       ROLA
       ROLA
       ROLA
       ANDA   #3
       ADDA   PB,S      3 bank par page
       ADDA   PB,S      écran
       ADDA   PB,S
       ADDA   #PBKTRA
       STA    BANKC
       LDD    <ADPRRL
       ANDA   #$3F
       ADDD   #$A000
       STD    <ADPRRL

* Initialisation du 1er segment à écrire
* sur l'écran
       LDD    #$4000+8*40+2
       STD    <ADPRSL

* Nb de lignes écran à déplacer (+1)
       LDA    #185
       STA    <CPTLT

* Boucle de copie .. X= ad. écran
*                    Y= ad. RAM
       LDX    <ADPRSL
       LDY    <ADPRRL

BFEEC  DEC    <CPTLT
       LBEQ   FFEEC     fini ->
       LDA    BANKC
       LDB    #37
       CMPA   DBK,S
       BEQ    FEEC30    dernier bank ->

       CMPY   #$E000-36
       BCS    BFEEC1    move 37 ok ->
       PSHS   Y         move en 2 fois
       LDD    #$E000
       SUBD   ,S++
       STB    <CPTCT
BFEEC0 LDA    ,Y+
       STA    ,X+
       DECB
       BNE    BFEEC0    ->
       INC    BANKC
       LDY    #$A000
       LDB    #37
       SUBB   <CPTCT
BFEEC1 LDA    ,Y+
       STA    ,X+
       DECB
       BNE    BFEEC1    ->

       LEAX   40-37,X   ligne écran suiv
       LEAY   60-37,Y   ligne feuille
       CMPY   #$E000
       BCS    BFEEC     ->
       INC    BANKC
       LEAY   -$4000,Y
       BRA    BFEEC     ->

FEEC30 CMPY   #$DF40-36
       BCS    BFEEC3    move 37 ok ->
       PSHS   Y         move en 2 fois
       LDD    #$DF40
       SUBD   ,S++
       STB    <CPTCT
BFEEC2 LDA    ,Y+
       STA    ,X+
       DECB
       BNE    BFEEC2    ->
       DEC    BANKC
       DEC    BANKC
       LDY    #$A000
       LDB    #37
       SUBB   <CPTCT
BFEEC3 LDA    ,Y+
       STA    ,X+
       DECB
       BNE    BFEEC3    ->

       LEAX   40-37,X   ligne écran suiv
       LEAY   60-37,Y   ligne feuille
       CMPY   #$DF40
       LBCS   BFEEC     ->
       DEC    BANKC
       DEC    BANKC
       LEAY   -$DF40,Y
       LEAY   $A000,Y
       LBRA   BFEEC     ->

FFEEC  LDA    MEMBK,S
       STA    BANKC
       LEAS   2,S
       PULS   D,X,Y,PC


*=======================================
* S/P inversion du tiroir pour visu.
*     temporaire
*=======================================

XINVTI EQU    *
*---------------------------------------
*      calculer coord. de visualisation
       LDD    <LPTTIR
       LSRA
       RORB
       PSHS   D
       LDD    REGX
       SUBD   ,S++
       STD    <XT0
       ADDD   <LPTTIR
       SUBD   #1
       STD    <XT1

       CLRA             calcul +/- 32k
       LDB    <HPTTIR
       LSRA
       RORB
       PSHS   D
       LDD    REGY
       SUBD   ,S++
       STD    <YT0
       CLRA
       LDB    <HPTTIR
       ADDD   <YT0
       SUBD   #1
       STD    <YT1

*      décaler le tiroir pour corresp.
*      colonnes
       LDD    <XT0
       ANDB   #7
       LBSR   XDECAL

*      calcul de la zone visualisée
       LDD    <XT0
       ASRA
       RORB
       ASRA
       RORB
       ASRA
       RORB
       STB    <COLT0
       CLR    <DECSEG
       CMPB   #4
       BGE    INVT10    ->
       LDA    #4
       SUBA   <COLT0
       STA    <DECSEG
       LDA    #4
       STA    <COLT0
       LDD    #32
       STD    <XT0

INVT10 CLR    <DECLIG
       LDD    <YT0
       CMPD   #8
       BGE    INVT11    ->
       LDD    #8
       SUBD   <YT0
       STB    <DECLIG
       LDD    #8
       STD    <YT0
INVT11 LDA    <YT0+1
       STA    <YT0      valeur 8..191

       LDD    <XT1
       ASRA
       RORB
       ASRA
       RORB
       ASRA
       RORB
       STB    <COLT1
       CMPB   #77
       BLE    INVT12    ->
       LDB    #77
       STB    <COLT1
       LDD    #623
       STD    <XT1

INVT12 LDD    <YT1
       CMPD   #191
       BLE    INVT13    ->
       LDD    #191
       STD    <YT1
INVT13 LDA    <YT1+1    valeur 8..191
       STA    <YT1

       LDA    <COLT1
       SUBA   <COLT0
       INCA
       STA    <LARTV
       LDA    <YT1
       SUBA   <YT0
       INCA
       STA    <HAUTV

*      calcul des référence 1er segment
*      (page écran et adresse
       LDA    $E7C3
       ANDA   #$FE
       LDB    <COLT0
       LSRB
       BCS    INVT14    ->
       ORA    #$01
INVT14 STA    <PRE7C3
       LDA    <YT0
       LDB    #40
       MUL
       ADDD   #$4000
       STD    <ADPRSG
       CLRA
       LDB    <COLT0
       LSRB
       ADDD   <ADPRSG
       STD    <ADPRSG

*      calcul des nb de seg. sur page
*      du 1er et sur l'autre
       LDA    <LARTV
       LSRA
       STA    <NBSEG1
       STA    <NBSEG2
       BCC    INVT15    ->
       INC    <NBSEG1

*      xor sur seg. 1ère page
INVT15 LDA    <PRE7C3
       STA    $E7C3
       LDA    <HAUTV
       STA    <CPTLT
       LDU    <ADPRSG
       STU    <ADPRSL
       LDY    #ZONTRA   Y=ad 1ére ligne
       LDA    <LARTIR
       LDB    <DECLIG
       MUL
       LEAY   D,Y
INVT16 LDA    <DECSEG
       LEAX   A,Y
       LDA    <NBSEG1
INVT17 LDB    ,U
       EORB   ,X++
       STB    ,U+
       DECA
       BNE    INVT17    ->
       LDB    <LARTIR
       LEAY   B,Y
       LDU    <ADPRSL
       LEAU   40,U
       STU    <ADPRSL
       DEC    <CPTLT
       BNE    INVT16    ->

*      xor seg. 2ème page
       LDA    $E7C3
       EORA   #$01
       STA    $E7C3
       LDA    <HAUTV
       STA    <CPTLT
       CLRA
       LDB    <PRE7C3
       ANDB   #1
       EORB   #1
       ADDD   <ADPRSG
       STD    <ADPRSL
       TFR    D,U
       LDY    #ZONTRA+1 Y=ad 1ére ligne
       LDA    <LARTIR
       LDB    <DECLIG
       MUL
       LEAY   D,Y
INVT18 LDA    <DECSEG
       LEAX   A,Y
       LDA    <NBSEG2
INVT19 LDB    ,U
       EORB   ,X++
       STB    ,U+
       DECA
       BNE    INVT19    ->
       LDB    <LARTIR
       LEAY   B,Y
       LDU    <ADPRSL
       LEAU   40,U
       STU    <ADPRSL
       DEC    <CPTLT
       BNE    INVT18    ->
       RTS


*=======================================
* S/P raz de l'écran de travail
*=======================================

XRAZEC PSHS   D,Y
       LDD    #$0104
       LDY    #$174A
       JSR    FENLOC
       JSR    FENFON
       PULS   D,Y,PC


*=======================================
* S/P raz de la feuille de travail
*=======================================

XRAZFE PSHS   D,X
       LEAS   -2,S
MEMBK  SET    0
BKTRA  SET    1
*---------------------------------------
       LDA    BANKC
       STA    MEMBK,S
       LDA    #PBKTRA
       STA    BKTRA,S
BRAZF0 LDA    BKTRA,S
       CMPA   #DBKTRA
       BGT    FRAZF     fin ->
       STA    BANKC
       LDD    #0
       LDX    #$A000
BRAZF1 STD    ,X++
       CMPX   #$E000
       BNE    BRAZF1    ->
       INC    BKTRA,S
       BRA    BRAZF0    ->
FRAZF  LDA    MEMBK,S
       STA    BANKC
       LEAS   2,S
       PULS   D,X,PC


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
*         CADCOL  colonne début (0..59 )
*         CADHAU  hauteur       (1..102)
*         CADLAR                (1..120)
*         B       éventuelle sélec ext
*         A       interrupteur pleine
*                 page
*         Z    1  zone ok
*              0  feuille vide ou aband.
*=======================================

FFCADS FCB    FCALL
       FDB    FFCADF-$4000

       FCB    FLOCF,8,18,1,1
       FCB    FEDI
       FCC    \Pleine\
       FCB    0
       FCB    FLOCR,1,1,1,1
       FCB    FEDI
       FCC    \page\
       FCB    0
       FCB    FLOCR,2,1,1,1
       FCB    FEDI,BALISE,0
       FCB    FLOCF,11,20,1,1
       FCB    FINV,$50,OFF
       FCB    FSTOP

FFCADC FCB    FCALL
       FDB    FFCADF-$4000

       FCB    FLOCF,0,0,23,26
       FCB    FCOMF,FF,OFF

       FCB    FLOCA,0,5,1,16
       FCB    FPOUSS,$90,OFF
       FCB    FLOCA,0,23,1,12
       FCB    FPOUSS,$91,OFF
       FCB    FLOCA,0,37,1,14
       FCB    FPOUSS,$92,OFF
       FCB    FLOCA,0,53,1,12
       FCB    FPOUSS,$93,OFF
       FCB    FLOCA,0,67,1,12
       FCB    FPOUSS,$94,OFF
       FCB    FLOCA,1,1,2,2
       FCB    FPOUSS,$0F,OFF  (ctrl) O
       FCB    FLOCA,4,1,2,2
       FCB    FPOUSS,$10,OFF  (ctrl) P
       FCB    FLOCA,7,1,1,2
       FCB    FINV,$12,OFF    (ctrl) R
       FCB    FLOCA,10,1,1,2
       FCB    FINV,$13,OFF    (ctrl) S
       FCB    FLOCA,13,1,2,2
       FCB    FPOUSS,$14,OFF  (ctrl) T
       FCB    FLOCA,16,1,2,2
       FCB    FPOUSS,$15,OFF  (ctrl) U
       FCB    FLOCA,20,1,1,2
       FCB    FPOUSS,$05,OFF  (ctrl) E
       FCB    FLOCA,22,1,1,2
       FCB    FPOUSS,$11,OFF  (ctrl) Q
       FCB    FLOCA,24,6,1,4
       FCB    FPOUSS,BS+$80,OFF
       FCB    FLOCA,24,10,1,2
       FCB    FPOUSS,BS,OFF
       FCB    FLOCA,24,12,1,60
       FCB    FPOUSS,$80,OFF
       FCB    FLOCA,24,72,1,2
       FCB    FPOUSS,HT,OFF
       FCB    FLOCA,24,74,1,4
       FCB    FPOUSS,HT+$80,OFF
       FCB    FLOCA,1,78,2,2
       FCB    FPOUSS,VT+$80,OFF
       FCB    FLOCA,3,78,1,2
       FCB    FPOUSS,VT,OFF
       FCB    FLOCA,4,78,17,2
       FCB    FPOUSS,$81,OFF
       FCB    FLOCA,21,78,1,2
       FCB    FPOUSS,LF,OFF
       FCB    FLOCA,22,78,2,2
       FCB    FPOUSS,LF+$80,OFF
       FCB    FEDI,ESC,$4C,0
       FCB    FSTOP

FFCADF FCB    FLOCF,0,0,23,26
       FCB    FTRAME,FTOURI
       FCB    FLOCF,1,1,1,24
       FCB    FFOND,FTOURE,FCADRE
       FCB    FEDI,HT,ESC,$4E
       FCC    \CADRAGE\
       FCB    ESC,$4C,0
       FCB    FLOCF,3,1,15,24
       FCB    FFOND,FTOURE,FCADRE
       FCB    FLOCF,19,1,3,24
       FCB    FFOND,FTOURE,FCADRE

       FCB    FLOCF,14,20,1,2
       FCB    FEDI,ESC,$4E,SS2,$2D,0
       FCB    FTOURI
       FCB    FPOUSS,VT,OFF
       FCB    FLOCR,1,-2,1,2
       FCB    FEDI,SS2,$2C,0
       FCB    FTOURI
       FCB    FPOUSS,BS,OFF
       FCB    FLOCR,0,4,1,2
       FCB    FEDI,SS2,$2E,0
       FCB    FTOURI
       FCB    FPOUSS,HT,OFF
       FCB    FLOCR,1,-2,1,2
       FCB    FEDI,SS2,$2F,ESC,$4C,0
       FCB    FTOURI
       FCB    FPOUSS,LF,OFF

       FCB    FLOCF,20,3,1,1
       FCB    FEDI
       FCC    \OK\
       FCB    BALISE
       FCC    \Annuler\
       FCB    BALISE,0
       FCB    FLOCF,20,6,1,1
       FCB    FPOUSS,RC,OFF
       FCB    FLOCF,20,22,1,1
       FCB    FPOUSS,FF,OFF
       FCB    FSTOP

*---------------------------------------
XSPCAD PSHS   D,X,Y,U   #(SPCADR)#
       LEAS   -128,S
BUFRED SET    0
MEMBK  SET    120
DBK    SET    121
YRED   SET    122
DECRNG SET    124     decalage +/-
DECCOL SET    125         ...
DRLG   SET    126     dern ...
CLDRO  SET    127     col. bord droit
PA     SET    128
PB     SET    129
*---------------------------------------

       CLR    DECRNG,S   résultat cadr.
       CLR    DECCOL,S

       LEAX   FFCADC,PCR
       TST    PA,S
       BEQ    SPCAD0    ->
       LEAX   FFCADS,PCR
SPCAD0 LDD    #$011C
       JSR    FENOUV

       LDX    #239
       STX    XXXXXX
       LDX    #360
       LDY    #39
       STY    YYYYYY
       LDY    #142
       CLR    FILFLG
       LDB    #BOX
       JSR    EXTRA

* Positionnement initial sur la feuille

       LDA    BANKC
       STA    MEMBK,S

       LDD    <ADF
       ROLA
       ROLA
       ROLA
       ANDA   #3
       ADDA   #PBKTRA
       STA    DBK,S
       LDD    <ADF
       ANDA   #$3F
       ADDD   #$A000
       STD    <ADPRRL
       LDY    #40
       STY    YRED,S

* Raz buffer image rangée

BRED0  LEAX   BUFRED,S
       LDB    #120
BRED1  CLR    ,X+
       DECB
       BNE    BRED1     ->

* Boucle de lecture de 8 lignes (1 car.)
* en page 0

       LDA    DBK,S
       STA    BANKC
       LDA    #9
       STA    <CPTLT
       LDY    <ADPRRL
BRED2  LEAX   BUFRED,S
       DEC    <CPTLT
       LBEQ   RED0F     -->
       LDA    BANKC
       LDB    #60
       CMPA   #PBKTRA+2
       BEQ    RED0D     dernier bank ->
       CMPY   #$E000-59
       BCS    BRED01    trait. 60 ok ->
       PSHS   Y         trait. en 2 fois
       LDD    #$E000
       SUBD   ,S++
       STB    <CPTCT
BRED00 LDA    ,Y+
       BEQ    LRED00    ->
       STA    ,X
LRED00 LEAX   2,X
       DECB
       BNE    BRED00    ->
       INC    BANKC
       LDY    #$A000
       LDB    #60
       SUBB   <CPTCT
BRED01 LDA    ,Y+
       BEQ    LRED01    ->
       STA    ,X
LRED01 LEAX   2,X
       DECB
       BNE    BRED01    ->
       CMPY   #$E000
       BCS    BRED2     ->
       INC    BANKC
       LDY    #$A000
       BRA    BRED2     ->

RED0D  CMPY   #$DF40-59 dernier bank
       BCS    BRED03    trait. 60 ok ->
       PSHS   Y         trait. en 2 fois
       LDD    #$DF40
       SUBD   ,S++
       STB    <CPTCT
BRED02 LDA    ,Y+
       BEQ    LRED02    ->
       STA    ,X
LRED02 LEAX   2,X
       DECB
       BNE    BRED02    ->
       DEC    BANKC
       DEC    BANKC
       LDY    #$A000
       LDB    #60
       SUBB   <CPTCT
BRED03 LDA    ,Y+
       BEQ    LRED03    ->
       STA    ,X
LRED03 LEAX   2,X
       DECB
       BNE    BRED03    ->
       CMPY   #$DF40
       LBCS   BRED2     ->
       DEC    BANKC
       DEC    BANKC
       LDY    #$A000
       LBRA   BRED2     ->
RED0F  EQU    *

* Boucle de lecture de 8 lignes (1 car.)
* en page 1

       LDA    DBK,S
       ADDA   #3
       STA    BANKC
       LDA    #9
       STA    <CPTLT
       LDY    <ADPRRL
BRED3  LEAX   BUFRED,S
       LEAX   1,X
       DEC    <CPTLT
       LBEQ   RED1F     -->
       LDA    BANKC
       LDB    #60
       CMPA   #PBKTRA+5
       BEQ    RED1D     dernier bank ->
       CMPY   #$E000-59
       BCS    BRED11    trait. 60 ok ->
       PSHS   Y         trait. en 2 fois
       LDD    #$E000
       SUBD   ,S++
       STB    <CPTCT
BRED10 LDA    ,Y+
       BEQ    LRED10    ->
       STA    ,X
LRED10 LEAX   2,X
       DECB
       BNE    BRED10    ->
       INC    BANKC
       LDY    #$A000
       LDB    #60
       SUBB   <CPTCT
BRED11 LDA    ,Y+
       BEQ    LRED11    ->
       STA    ,X
LRED11 LEAX   2,X
       DECB
       BNE    BRED11    ->
       CMPY   #$E000
       BCS    BRED3     ->
       INC    BANKC
       LDY    #$A000
       BRA    BRED3     ->

RED1D  CMPY   #$DF40-59 dernier bank
       BCS    BRED13    trait. 60 ok ->
       PSHS   Y         trait. en 2 fois
       LDD    #$DF40
       SUBD   ,S++
       STB    <CPTCT
BRED12 LDA    ,Y+
       BEQ    LRED12    ->
       STA    ,X
LRED12 LEAX   2,X
       DECB
       BNE    BRED12    ->
       DEC    BANKC
       DEC    BANKC
       LDY    #$A000
       LDB    #60
       SUBB   <CPTCT
BRED13 LDA    ,Y+
       BEQ    LRED13    ->
       STA    ,X
LRED13 LEAX   2,X
       DECB
       BNE    BRED13    ->
       CMPY   #$DF40
       LBCS   BRED3     ->
       DEC    BANKC
       DEC    BANKC
       LDY    #$A000
       LBRA   BRED3     ->

RED1F  STY    <ADPRRL
       LDA    BANKC
       SUBA   #3
       STA    DBK,S

* Boucle de visualisation de la ligne
* réduite.

       CLRA
       LEAU   BUFRED,S
       LDY    YRED,S
RED4   TST    ,U+
       BEQ    RED5      ->
       LDX    #240
       LEAX   A,X
       LDB    #PSETXY
       JSR    EXTRA
RED5   INCA
       CMPA   #120
       BNE    RED4      ->

* Passer à la ligne car. suivante

       LEAY   1,Y
       STY    YRED,S
       CMPY   #40+102
       LBNE   BRED0     ->

* Sélection opérateur

CADR0  JSR    FENACT    sélection
CADR1  JSR    FEN
       TSTB
       BEQ    CADR1     ->
       CMPB   #FF
       LBEQ   CADRRZ    raz ->
       CMPB   #RC
       LBEQ   CADROK    RC  ->
       CMPB   #VT
       LBEQ   CADRVT    VT ->
       CMPB   #BS
       LBEQ   CADRBS    BS ->
       CMPB   #HT
       LBEQ   CADRHT    HT ->
       CMPB   #LF
       LBEQ   CADRLF    LF ->
       TST    PA,S
       BNE    CADR1     ->
       LDA    #$92
       LDX    #CADRRT-$4000
       LDY    #CADRRZ-$4000
       LDU    #ABORT
       LBSR   COMBK1
       CMPU   #0
       BEQ    CADR1     ->
       JMP    ,U

CADRVT EQU    *
******

* Vérification ligne non vide
       JSR    FENDES

       LDA    $E7C3
       ORA    #1
       STA    $E7C3
       LDX    #$4000+5*8*40+15
       LDB    #8
CDRVV0 TST    ,X+
       LBNE   CADR0     ->
       DECB
       BNE    CDRVV0    ->
       LDA    $E7C3
       EORA   #1
       STA    $E7C3
       LDX    #$4000+5*8*40+15
       LDB    #7
CDRVV1 TST    ,X+
       LBNE   CADR0     ->
       DECB
       BNE    CDRVV1    ->

* Scroll point
       LDX    #$4000+5*8*40+15
       LEAY   40,X
       LDB    #101
       STB    <CPTLT
BVH0   LDB    #7
BVH1   LDA    ,Y+
       STA    ,X+
       DECB
       BNE    BVH1      ->
       LEAX   40-7,X
       LEAY   40-7,Y
       DEC    <CPTLT
       BNE    BVH0      ->

       LDB    #7        raz nouv ligne
BVH10  CLR    ,X+
       DECB
       BNE    BVH10     ->

       LDA    $E7C3
       EORA   #1
       STA    $E7C3
       LDX    #$4000+5*8*40+15
       LEAY   40,X
       LDB    #101
       STB    <CPTLT
BVH2   LDB    #8
BVH3   LDA    ,Y+
       STA    ,X+
       DECB
       BNE    BVH3      ->
       LEAX   40-8,X
       LEAY   40-8,Y
       DEC    <CPTLT
       BNE    BVH2      ->

       LDB    #8        raz nouv ligne
BVH30  CLR    ,X+
       DECB
       BNE    BVH30     ->

       INC    DECRNG,S
       LBRA   CADR0     ->

CADRBS EQU    *
******

* Vérification 2 colonnes gauches vides
       JSR    FENDES

       LDA    $E7C3
       ORA    #1
       STA    $E7C3
       LDX    #$4000+5*8*40+15
       LDB    #102
CDRBV0 LDA    ,X
       ANDA   #$C0
       LBNE   CADR0     ->
       LEAX   40,X
       DECB
       BNE    CDRBV0    ->

* Scroll 2 points
       LDX    #$4000+5*8*40+22
       LDB    #102
       STB    <CPTLT
BVG0   LDB    #7
       LSL    ,X
       LEAX   -1,X
BVG1   DEC    $E7C3
       ROL    ,X
       INC    $E7C3
       ROL    ,X
       LEAX   -1,X
       DECB
       BNE    BVG1      ->
       LEAX   48,X
       DEC    <CPTLT
       BNE    BVG0      ->

       LDX    #$4000+5*8*40+22
       LDB    #102
       STB    <CPTLT
BVG2   LDB    #7
       LSL    ,X
       LEAX   -1,X
BVG3   DEC    $E7C3
       ROL    ,X
       INC    $E7C3
       ROL    ,X
       LEAX   -1,X
       DECB
       BNE    BVG3      ->
       LEAX   48,X
       DEC    <CPTLT
       BNE    BVG2      ->

       INC    DECCOL,S
       LBRA   CADR0     ->

CADRHT EQU    *
******

* Vérification 2 colonnes droites vides
       JSR    FENDES

       LDA    $E7C3
       ORA    #1
       STA    $E7C3
       LDX    #$4000+5*8*40+22
       LDB    #102
CDRHV0 LDA    ,X
       ANDA   #$03
       LBNE   CADR0     ->
       LEAX   40,X
       DECB
       BNE    CDRHV0    ->

* Scroll 2 points
       LDX    #$4000+5*8*40+15
       LDB    #102
       STB    <CPTLT
BVD0   LDB    #7
       LSR    ,X
BVD1   DEC    $E7C3
       ROR    ,X+
       INC    $E7C3
       ROR    ,X
       DECB
       BNE    BVD1      ->
       LEAX   40-7,X
       DEC    <CPTLT
       BNE    BVD0      ->

       LDX    #$4000+5*8*40+15
       LDB    #102
       STB    <CPTLT
BVD2   LDB    #7
       LSR    ,X
BVD3   DEC    $E7C3
       ROR    ,X+
       INC    $E7C3
       ROR    ,X
       DECB
       BNE    BVD3      ->
       LEAX   40-7,X
       DEC    <CPTLT
       BNE    BVD2      ->

       DEC    DECCOL,S
       LBRA   CADR0     ->

CADRLF EQU    *
******

* Vérification ligne non vide
       JSR    FENDES

       LDA    $E7C3
       ORA    #1
       STA    $E7C3
       LDX    #$4000+5*8*40+15+101*40
       LDB    #8
CDRVB0 TST    ,X+
       LBNE   CADR0     ->
       DECB
       BNE    CDRVB0    ->
       LDA    $E7C3
       EORA   #1
       STA    $E7C3
       LDX    #$4000+5*8*40+15+101*40
       LDB    #7
CDRVB1 TST    ,X+
       LBNE   CADR0     ->
       DECB
       BNE    CDRVB1    ->

* Scroll point
       LDX    #$4000+5*8*40+15+101*40
       LEAY   -40,X
       LDB    #101
       STB    <CPTLT
BVB0   LDB    #7
BVB1   LDA    ,Y+
       STA    ,X+
       DECB
       BNE    BVB1      ->
       LEAX   -47,X
       LEAY   -47,Y
       DEC    <CPTLT
       BNE    BVB0      ->

       LDB    #7        raz nouv ligne
BVB10  CLR    ,X+
       DECB
       BNE    BVB10     ->

       LDA    $E7C3
       EORA   #1
       STA    $E7C3
       LDX    #$4000+5*8*40+15+101*40
       LEAY   -40,X
       LDB    #101
       STB    <CPTLT
BVB2   LDB    #8
BVB3   LDA    ,Y+
       STA    ,X+
       DECB
       BNE    BVB3      ->
       LEAX   -48,X
       LEAY   -48,Y
       DEC    <CPTLT
       BNE    BVB2      ->

       LDB    #8        raz nouv ligne
BVB30  CLR    ,X+
       DECB
       BNE    BVB30     ->

       DEC    DECRNG,S
       LBRA   CADR0     ->

CADROK EQU    *         Sortie normale
******
       JSR    FENDES
       LDA    MEMBK,S
       STA    BANKC

* Déterminer nouvelle adresse feuille
       LDA    DECRNG,S
       BEQ    CADRO2    ->
       BMI    CADRO0    ->
       LSLA             *8*60
       LDB    #240
       MUL
       ADDD   <ADF
       CMPD   #48960
       BCS    CADRO1    ->
       SUBD   #48960
       BRA    CADRO1    ->
CADRO0 NEGA
       LSLA             *8*60
       LDB    #240
       MUL
       PSHS   D
       LDD    <ADF
       SUBD   ,S++
       BCC    CADRO1    ->
       ADDD   #48960
CADRO1 STD    <ADF
CADRO2 LDB    DECCOL,S
       BEQ    CADRO5    ->
       BMI    CADRO3    ->
       CLRA
       ADDD   <ADF
       CMPD   #48960
       BCS    CADRO4    ->
       SUBD   #48960
       BRA    CADRO4    ->
CADRO3 NEGB
       CLRA
       PSHS   D
       LDD    <ADF
       SUBD   ,S++
       BCC    CADRO4    ->
       ADDD   #48960
CADRO4 STD    <ADF

* Déterminer sélection si demandé
CADRO5 TST    PA,S
       LBEQ   CADRO6    ->
       LDB    #$50
       JSR    FENCH
       LDA    VAL,X
       STA    PA,S

* Déterminer la 1ère ligne non vide
       LDA    $E7C3     # page 0
       ORA    #1
       STA    $E7C3
       LDX    #$4000+5*8*40+15
       LDB    #102
       STB    <CPTLT
BD1L0  LDB    #8
BD1L1  TST    ,X+
       BNE    LD1L0     trouvé ->
       DECB
       BNE    BD1L1     ->
       LEAX   40-8,X
       DEC    <CPTLT
       BNE    BD1L0     ->

LD1L0  LDB    #102
       SUBB   <CPTLT
       STB    CADRNG    result page 0

       LDA    $E7C3     # page 1
       EORA   #1
       STA    $E7C3
       LDX    #$4000+5*8*40+15
       LDB    #102
       STB    <CPTLT
BD2L0  LDB    #7
BD2L1  TST    ,X+
       BNE    LD2L0     trouvé ->
       DECB
       BNE    BD2L1     ->
       LEAX   40-7,X
       DEC    <CPTLT
       BNE    BD2L0     ->

LD2L0  LDB    #102      result page 1
       SUBB   <CPTLT
       CMPB   CADRNG
       BGE    LD2L1     ->
       STB    CADRNG
LD2L1  LDB    CADRNG
       CMPB   #102
       LBEQ   CADRRZ    feuille vide ->

* Détermination dernière ligne
       LDA    $E7C3     # page 0
       ORA    #1
       STA    $E7C3
       LDX    #$4000+5*8*40+15+101*40
       LDB    #101
       STB    <CPTLT
BDDL0  LDB    #8
BDDL1  TST    ,X+
       BNE    LDDL0     trouvé ->
       DECB
       BNE    BDDL1     ->
       LEAX   -48,X
       DEC    <CPTLT
       BRA    BDDL0     ->

LDDL0  LDB    <CPTLT    result page 0
       STB    DRLG,S

       LDA    $E7C3     # page 1
       EORA   #1
       STA    $E7C3
       LDX    #$4000+5*8*40+15+101*40
       LDB    #101
       STB    <CPTLT
BDDL2  LDB    #7
BDDL3  TST    ,X+
       BNE    LDDL1     trouvé ->
       DECB
       BNE    BDDL3     ->
       LEAX   -47,X
       DEC    <CPTLT
       BRA    BDDL2     ->

LDDL1  LDB    <CPTLT
       CMPB   DRLG,S
       BGT    LDDL2     ->
       LDB    DRLG,S
LDDL2  SUBB   CADRNG
       INCB
       STB    CADHAU

* Cumul des lignes sur le buffer
* BUFRED
       LEAX   BUFRED,S
       LDB    #15
BRAZBR CLR    ,X+
       DECB
       BNE    BRAZBR    ->

       LDA    $E7C3     page 0
       ORA    #1
       STA    $E7C3
       LDX    #$4000+5*8*40+15
       LDA    CADRNG
       LDB    #40
       MUL
       LEAX   D,X
       LDA    CADHAU
       STA    <CPTLT
BCUM0  LDB    #8
       LEAY   BUFRED,S
BCUM1  LDA    ,X+
       ORA    ,Y
       STA    ,Y++
       DECB
       BNE    BCUM1     ->
       LEAX   40-8,X
       DEC    <CPTLT
       BNE    BCUM0     ->

       LDA    $E7C3     page 1
       EORA   #1
       STA    $E7C3
       LDX    #$4000+5*8*40+15
       LDA    CADRNG
       LDB    #40
       MUL
       LEAX   D,X
       LDA    CADHAU
       STA    <CPTLT
BCUM2  LDB    #7
       LEAY   BUFRED,S
       LEAY   1,Y
BCUM3  LDA    ,X+
       ORA    ,Y
       STA    ,Y++
       DECB
       BNE    BCUM3     ->
       LEAX   40-7,X
       DEC    <CPTLT
       BNE    BCUM2     ->

* Recherche borne gauche
       LEAX   BUFRED,S
       CLRB
BRBG0  LDA    ,X+
       BNE    LRBG0     ->
       INCB
       BRA    BRBG0     ->
LRBG0  PSHS   A
       LDA    #8
       MUL
       STB    CADCOL
       PULS   A
       LDB    #-1
BRBG1  LSLA
       INCB
       BCC    BRBG1     ->
       ADDB   CADCOL
       LSRB             colonne / page
       STB    CADCOL              paire

* Recherche borne droite
       LEAX   BUFRED,S
       LDB    #14
BRBD0  LDA    B,X
       BNE    LRBD0     ->
       DECB
       BRA    BRBD0     ->
LRBD0  PSHS   A
       LDA    #8
       MUL
       PULS   A
       STB    CLDRO,S
       LDB    #8
BRBD1  LSRA
       DECB
       BCC    BRBD1     ->
       ADDB   CLDRO,S
       SUBB   CADCOL    0..59 et non
       SUBB   CADCOL    0..119 !!!
       INCB
       STB    CADLAR

       LDX    #240
       LDA    CADCOL
       LSLA
       LEAX   A,X
       STX    XXXXXX
       LDA    CADLAR
       LEAX   A,X
       LEAX   -1,X
       LDY    #40
       LDA    CADRNG
       LEAY   A,Y
       STY    YYYYYY
       LDA    CADHAU
       LEAY   A,Y
       LEAY   -1,Y
       LDB    #BOX
       JSR    EXTRA

CADRO6 CLR    PB,S
       ANDCC  #$FB
       LEAS   128,S
       PULS   D,X,Y,U,PC ->>

CADRRZ EQU    *
******
       CLRB
CADRRT STB    PB,S
       CLRB
       JSR    FENFER
       JSR    FENACT
       LDA    MEMBK,S
       STA    BANKC
       ORCC   #$04
       LEAS   128,S
       PULS   D,X,Y,U,PC ->>


*=======================================
* S/P visualisation de l'ascenceur bas
*=======================================

XVISAB LDA    #1
       LDB    #60
       TFR    D,Y
       LDA    #24
       LDB    #12
       JSR    FENLOC
       JSR    FENFON
       JSR    FENTI
       LDA    #1
       LDB    #37
       TFR    D,Y
       LDA    #24
       LDB    #12
       ADDB   CLDECR
       JSR    FENLOC
       JSR    FENTRA
       JSR    FENTI
       RTS


*=======================================
* S/P visualisation de l'ascenceur droit
*=======================================

XVISAD LDA    #17
       LDB    #2
       TFR    D,Y
       LDA    #4
       LDB    #78
       JSR    FENLOC
       JSR    FENFON
       JSR    FENTI
       LDA    #4
       LDB    #2
       TFR    D,Y
       LDB    RGDECR
       CLRA
DDIV6  SUBB   #6
       BCS    FDIV6     ->
       INCA
       BRA    DDIV6     ->
FDIV6  TSTA
       BNE    VISAS0    ->
       TST    RGDECR
       BEQ    VISAS1    ->
       INCA             montrer pas haut
       BRA    VISAS1
VISAS0 CMPA   #13
       BNE    VISAS1
       LDB    RGDECR
       CMPB   #78
       BGE    VISAS1
       DECA             montrer pas bas
VISAS1 ADDA   #4
       LDB    #78
       JSR    FENLOC
       JSR    FENTRA
       JSR    FENTI
       RTS
