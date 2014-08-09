       TITLE  TO-PHOTO:S/P
*      ---------------------------------
       PAGE

****************************************
*                                      *
*            S/P                       *
*                                      *
****************************************


*=======================================
* S/P prise en compte d'une adresse
*     de déroutement
*=======================================
FIXIT  EQU    *
*---------------------------------------
       LDB    #255
       LDX    #BUF
       JSR    FENLCZ
       BCS    FIXIT0    ->
       RTS

FIXIT0 LDD    #$0000
       LDY    #$FFFF
       JSR    HEXBIN
       TFR    D,U

       CLR    $E7E4
       LDA    $E7E6     autorise écritur
       ORA    #$40      cartouche
       STA    $E7E6

       STU    ADRIT

       LDA    $E7E6     interdit écritur
       ANDA   #$BF      cartouche
       STA    $E7E6
       RTS


*=======================================
* S/P activation dela tache sous
*     déroutement
*=======================================

ACTIT  EQU    *
*---------------------------------------
       ORCC   #$50

       CLR    $E7E4
       LDA    $E7E6     autorise écritur
       ORA    #$40      cartouche
       STA    $E7E6

       ANDA   #$3F
       STA    BKSNAP
       STA    BKDSNA

       LDD    ADRIT     défaut pour
       STD    ADITFQ    dérout. buffer

       LDX    #VECTMM
       LDA    #5
       LSLA
       LDD    A,X
       STD    VFDER

       LDA    TYPDER
       BEQ    ACTIT0    FIRQ   ->
       CMPA   #1
       BEQ    ACTIT0    RESETP ->
       CMPA   #14
       BEQ    ACTIT0    BUFCLV ->
       CMPA   #2
       BNE    ACTIT1    ->
*      LDX    TIMEMM
       LDX    #KBIN
       STX    VFDER
       BRA    ACTIT0    ->

ACTIT1 LDX    #VECTMM
       LDA    TYPDER
       SUBA   #3
       LSLA
       LDD    A,X
       STD    VFDER

ACTIT0 LDA    $E7E6     interdit écritur
       ANDA   #$BF      cartouche
       STA    $E7E6

       LDA    TYPDER
       CMPA   #2
       BGE    BACITX    ->

* FIRQ et RESETP !!!

       LDX    #ITSNAP
       LDY    ADRIT
BACIT0 LDA    ,X+
       STA    ,Y+
       CMPX   #FINIT
       BNE    BACIT0    ->

       LDA    $E7C3
       EORA   #1
       STA    $E7C3

       LDX    #ITSNAP
       LDY    ADRIT
CACIT0 LDA    ,X+
       STA    ,Y+
       CMPX   #FINIT
       BNE    CACIT0    ->

       LDD    ADRIT
       TST    TYPDER
       BEQ    BACITG    ->
       STD    RESETP+1
       LDA    #$7E      JMP
       STA    RESETP
       LBRA   BACITF    ->
BACITG STD    >FIRQPT
       LBRA   BACITY    ->

* timer + vecteurs + buffer clav !!!

BACITX LDX    #DRSNAP
       LDY    ADRIT
BACIT1 LDA    ,X+
       STA    ,Y+
       CMPX   #FINDER
       BNE    BACIT1    ->

       LDA    $E7C3
       EORA   #1
       STA    $E7C3

       LDX    #DRSNAP
       LDY    ADRIT
CACIT1 LDA    ,X+
       STA    ,Y+
       CMPX   #FINDER
       BNE    CACIT1    ->

       LDU    ADRIT
       LDA    TYPDER
       CMPA   #14
       BEQ    BACIT3    ->
       SUBA   #3
       BMI    BACIT2    ->
       LSLA             vecteurs
       LDX    #$6000
       STU    A,X
       BRA    BACITY    ->
BACIT2 STU    TIMEPT    timer
       LDA    STATUS
       ORA    #$20
       STA    STATUS
       BRA    BACITY    ->
BACIT3 LDD    #$600A    buffer clav.
       STD    BUFCLV
       CLR    REACLV
       CLR    WRICLV

       LDX    #DRBUF
       LDY    #$5F8E
BACIT4 LDA    ,X+
       STA    ,Y+
       CMPX   #FDRBUF
       BNE    BACIT4    ->

       LDA    $E7C3
       EORA   #1
       STA    $E7C3

       LDX    #DRBUF
       LDY    #$5F8E
BACIT5 LDA    ,X+
       STA    ,Y+
       CMPX   #FDRBUF
       BNE    BACIT5    ->

* programmation PIA système pour
* détection à partir prise crayon
* (hors RESETP !)

BACITY LDA    >$E7CB    RAZ IT
       ORA    #$40
       STA    >$E7CB
       LDA    <$E7C9
       LDA    >$E7CB    6821 pour \/
       ANDA   #$FC      par prise crayon
       TST    TYPDER
       BNE    BACIT9    ->
       ORA    #$01      (IT sur \/ CB1)
BACIT9 STA    >$E7CB

BACITF ANDCC  #$AF
       RTS


*=======================================
* S/P tache a implanter pour acquisition
*     sous FIRQ et RESETP
*=======================================

ITSNAP EQU    *
*---------------------------------------
       LDA    #0      posit bank TO-SNAP
BKSNAP EQU    *-1
       STA    >$E7E6
       JMP    XSNAP   activation ->
FINIT  EQU    *


*=======================================
* S/P tache a implanter pour acquisition
*     sous déroutement système
*=======================================

DRSNAP EQU    *
*---------------------------------------
       TST    >$E7CB
       BPL    FDER    ->
       LDA    #0      posit bank TO-SNAP
BKDSNA EQU    *-1
       STA    >$E7E6
       JMP    XSNAP   activation ->
FDER   JMP    $FFFF
VFDER  EQU    *-2
FINDER EQU    *


*=======================================
* S/P tache a implanter pour acquisition
*     sous déroutement buffer clavier
*     (l'entrée de $5F dans le buffer
*     clavier dérouté sur l'indirection
*     GETCH génère une adresse $5F8E
*     à la place de l'adresse défaut
*     $FF8E...
*     A l'appel de GETCH suivant, ceci
*     va générer un appel vers l'implant
*     DRBUF  qui va armer un déroutement
*     de GETCH traditionnel ...
*     NB: $5F = code de _ au clavier
*         (obligatoire avant toute autre
*         saisie, :
*     NB: L'implant est donc obligatoir.
*         ement en $5F8E !!!
*         et sur les deux pages
*=======================================

DRBUF  EQU    *       (en $5F8E !!!)
*---------------------------------------
       PSHS   A,CC
       ORCC   #$50
       LDD    #$0000    déroute GETC
ADITFQ EQU    *-2
       STD    $600A

       LDB    #$82      buffer clav std
       STB    BUFCLV+1

       CLRB
       CLR    [BUFCLV]
       CLR    REACLV
       CLR    WRICLV

       ANDCC  #$AF
       PULS   A,CC,PC ->>
FDRBUF EQU    *


*=======================================
* S/P lecture des applications disponib.
*=======================================

LECAPL EQU    *
*---------------------------------------

* Pas d'appli. par défaut

       LDX    #APLTAB
       LDA    #6
       LDB    #$FF
BRAZAP STB    ,X
       LEAX   33,X
       DECA
       BNE    BRAZAP    ->

* Chargement en RAM du programme de
* lecture des appli. disponibles

       LDA    BKMANO
       STA    BANKC
       LDX    #DEBLEC
       LDY    #$A000
BECRPG LDA    ,X+
       STA    ,Y+
       CMPX   #FINLEC
       BNE    BECRPG    ->

* Lecture des appli. disponibles

       JSR    $A000

       RTS              ->>


*=======================================
* S/P lecture des appli disp
*     (à charger en RAM hors cartouche!)
*=======================================
DEBLEC EQU    *
       LEAS   -1,S
MEME6  SET    0       memo $E7E6
*---------------------------------------
       CLR    $E7E4
       LDA    $E7E6
       STA    MEME6,S
       CLR    $E7E6   cartouche=ROM

* voir slot 1 (cartouche externe)

       LDB    $E7C3
       ANDB   #$FB
       STB    $E7C3
       LDU    #APLTAB+1
       LDY    #0
       LBSR   VERSOC
       BCS    SUIAP0  pas cartouche ->
       LDA    #$30
       STA    ,-U

* voir slot 0 bank 0 (basic 512)

SUIAP0 LDB    $E7C3
       ORB    #4
       STB    $E7C3
       STA    $0000
       LDU    #APLTAB+33+1
       LDY    #0
       LBSR   VERSOC
       BCS    SUIAP1  pas basic ! ->
       LDA    #$00
       STA    ,-U

* voir slot 0 bank 2 (basic 1)

SUIAP1 STA    $0002
       LDU    #APLTAB+33*2+1
       LDY    #0
       LBSR   VERSOC
       BCS    SUIAP2  pas basic ! ->
       LDA    #$02
       STA    ,-U

* voir slot 0 bank 3 (fichiers...)

SUIAP2 STA    $0003
       LDU    #APLTAB+33*3+1
       LDY    #0
       LBSR   VERSOC
       BCS    SUIAP3  pas fichiers! ->
       LDA    #$03
       STA    ,-U

* Rechercher 'Réglages et préférences'
* petits pb de visu et pas utile !

       BRA    SUIAP4    ->
SUIAP3 LDU    #APLTAB+33*4+1
       LDY    #$2000
BRREG  LDD    ,Y
       CMPD   #$2052
       BNE    SRREG     ->
       LDD    2,Y
       CMPD   #$8567
       BNE    SRREG     ->
       LBSR   VERSOC
       BCS    SRREG     ->
       LDA    #$03
       STA    ,-U
       BRA    SUIAP4    ->
SRREG  LEAY   1,Y
       CMPY   #$4000
       BNE    BRREG     ->

* Rechercher 'Appel de programmes'

SUIAP4 LDU    #APLTAB+33*4+1
       LDY    #$2000
BRPGM  LDD    ,Y
       CMPD   #$2041
       BNE    SRPGM     ->
       LDD    2,Y
       CMPD   #$7070
       BNE    SRPGM     ->
       LBSR   VERSOC
       BCS    SRPGM     ->
       LDA    #$03
       STA    ,-U
       BRA    SUIAP5    ->
SRPGM  LEAY   1,Y
       CMPY   #$4000
       BNE    BRPGM     ->

* revenir sur RAM/cartouche

SUIAP5 LDA    MEME6,S
       STA    $E7E6
       LEAS   1,S
       RTS


*=======================================
* S/P vérification de la présence d'une
*     application
* Entrée:  Y  @ ROM candidate
*          U  @ rangement
* Sortie  CY  0 si ok
*=======================================
VERSOC PSHS   D,X,Y,U
*---------------------------------------
       LDA    #26       lecture mnémo
       LDX    #$55
BVSO0  LDB    ,Y+
       STB    ,U+
       ABX
       CMPB   #$04
       BNE    SVSO00    ->
       CLR    -1,U
SVSO00 CMPB   #$85
       BNE    SVSO01    ->
       LDB    #$65      minuscules codée
       STB    -1,U
SVSO01 DECA
       BNE    BVSO0     ->

       TFR    X,D       verif soco
       ANDB   #$DF      erreur soc appel
       PSHS   B         pgm
       LDB    ,Y+
       STB    ,U+
       ANDB   #$DF
       CMPB   ,S+
       BNE    SVSO0     pas cartouche ->
       LDA    #5
BVSO1  LDB    ,Y+
       STB    ,U+
       DECA
       BNE    BVSO1     ->
       ANDCC  #$FE
       PULS   D,X,Y,U,PC
SVSO0  ORCC   #1
       PULS   D,X,Y,U,PC
FINLEC EQU    *


*=======================================
* S/P fenetre de lancement applic.
*=======================================
RZECRN FCB    $1B,$69,$1B,$44,$1B,$56
       FCB    $1B,$66,FF,0
MENLAN EQU    *
*---------------------------------------

       LDX    #FENLAN
       LDD    3,X
       JSR    POPUP
       JSR    FENOUV

* Visu des appli. disponibles

       LDY    #APLTAB
       LDB    #$90
BVIAP  JSR    FENCH
       TST    ,Y
       BMI    APINT     ->
       LEAX   1,Y
       JSR    FENEDI
       BRA    SUIAP     ->
APINT  LDA    #INTERD
       STA    VAL,X
SUIAP  LEAY   33,Y
       INCB
       CMPB   #$95
       BNE    BVIAP    ->


* Adresse implantation SNAP
       LDB    #255
       JSR    FENCH

*      calcul @ pgm
       LDD    ADRIT

       LDX    #BUF
       JSR    BINHX2
       CLR    4,X
       JSR    FENEDI

*      visu déroutement courant
EXEA00 LDB    #$53
       JSR    FENCH
       LDX    #TABDER
       LDA    #19
       LDB    TYPDER
       MUL
       LEAX   D,X
       JSR    FENEDI

*      calcul lg pgm
       LDB    #254
       JSR    FENCH
       LDA    TYPDER
       CMPA   #1
       BGT    VISDER    ->
       LDD    #FINIT
       SUBD   #ITSNAP
       BRA    VISADD    ->
VISDER LDD    #FINDER
       SUBD   #DRSNAP
VISADD LDX    #BUF
       LDY    #2
       JSR    BINDCD
       JSR    FENEDI

EXECA0 JSR    FENACT

EXECA1 JSR    FEN
       TSTB
       BEQ    EXECA1    ->
       CMPB   #FF       RAZ
       LBEQ   XARET     ->
       CMPB   #$53      'S'
       LBEQ   MODSNA    ->
       CMPB   #$95      F6
       LBEQ   XBOOT     ->
       CMPB   #$90      <F1
       BLT    EXECA1    ->
       CMPB   #$94      >F5
       BGT    EXECA1    ->

*** Lancement soft
       PSHS   B
       CLR    RUNFLG    auto ou non
       LDB    #$01
       JSR    FENCH
       LDA    VAL,X
       CMPA   #OFF
       BEQ    XLANC1    ->
       COM    RUNFLG
XLANC1 LDB    ,S
       SUBB   #$90
       LDA    #33
       MUL
       LDX    #APLTAB
       LEAX   D,X
       LDA    ,X
       LBMI   EXECA1    ->
       LDU    31,X      @ dem. froid
       PSHS   A,U
       JSR    FIXIT
       JSR    FENFIN

       LDA    #$FF
       LDX    #TMEMO
       JSR    SETP

       LDA    $E7C3     sinon, noir de
       ANDA   #$FE      applications
       STA    $E7C3     = 256 !!!
       CLR    $5F40

       CLR    $E7E4
       LDA    $E7E6     autorise écritur
       ORA    #$40      cartouche
       STA    $E7E6
*      CLR    TFMEMO
       LDA    $E7E6     interdit écritur
       ANDA   #$BF      cartouche
       STA    $E7E6

       JSR    RSTECR

       JSR    ACTIT

       LDB    3,S
       CMPB   #$91
       BEQ    GORAM0    ->
       CMPB   #$93
       BGE    GORAM0    ->
       LDA    #$44      commut.bank
       STA    $6081     ram pia
       STA    $E7E7     (compatibilité)

       CMPB   #$90
       BEQ    GORAM0    ->
*      basic 1
       LDA    #$01      init. ctrl dsk
       STA    DKOPC
       JSR    DKCO

       LDA    #$20      posit piste 0
       STA    DKOPC
       JSR    DKCO

*      une séquence d'effacement appelée
*      par le programme chargé réalise
*      une initialisation d'un zone
*      pointée par $601c à $601e... zone
*      dans laquelle peut justement se
*      trouver le programme (MGT !)
*      les valeurs mises sont celles en
*      vigueur hors extra mon !!!

       LDD    #$F001
       STD    $601C
       LDD    #$F017
       STD    $601E

GORAM0 LDA    #$FF      présence disk
       STA    $6080
       LDA    >$E7C3    moniteur bk 0
       ANDA   #$EF
       STA    >$E7C3
       PULS   A,U
       LDS    #$60CC
       LDB    #$60
       TFR    B,DP

       JSR    COMS

*** Boot disquette
XBOOT  JSR    FENCH
       JSR    FENIVD
       JSR    FIXIT
       JSR    FENFIN

       LDA    #$FF
       LDX    #TMEMO
       JSR    SETP

       CLR    $E7E4
       LDA    $E7E6     autorise écritur
       ORA    #$40      cartouche
       STA    $E7E6
*      CLR    TFMEMO
       LDA    $E7E6     interdit écritur
       ANDA   #$BF      cartouche
       STA    $E7E6

       JSR    RSTECR

       LDU    #BOOT
       JSR    COMBK2

*** modification du déroutement
MODSNA JSR    FENDES
       LDB    TYPDER
       INCB
       CMPB   #15
       BLT    ECRDER    ->
       CLRB

ECRDER CLR    $E7E4
       LDA    $E7E6     autorise écritur
       ORA    #$40      cartouche
       STA    $E7E6
       STB    TYPDER
       LDA    $E7E6     interdit écritur
       ANDA   #$BF      cartouche
       STA    $E7E6

       LBRA   EXEA00    ->

* Fin menu lancement
*---------------------------------------

XARET  JSR    FIXIT
       CLRB
       JSR    FENFER    car photo peut
       JSR    FENACT
       RTS


*=======================================
* S/P restore attributs écran
*=======================================
RSTECR LDB    #$1B
       JSR    PUTC
       LDB    #$69
       JSR    PUTC
       LDB    #$1B
       JSR    PUTC
       LDB    #$44      bleu
       JSR    PUTC
       LDB    #$1B
       JSR    PUTC
       LDB    #$56      sur cyan
       JSR    PUTC
       LDB    #$1B
       JSR    PUTC
       LDB    #$66      tour cyan
       JSR    PUTC
       LDB    #FF
       JSR    PUTC
       RTS


*=======================================
* S/P destruction logique d'une photo
*
* Entrée: A num photo
*=======================================
DELPHO PSHS   A,X
*---------------------------------------
       LDX    #TABPHO
       CLR    A,X
       PULS   A,X,PC    ->>


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
