       TITLE  TO-GRAPH: Equates
*      ------------------------------
       PAGE

****************************************
*                                      *
*           TO-GRAPH                   *
*                                      *
*    Equates                           *
*                                      *
****************************************


* Definition des points d'entree dans
* le moniteur TO9
*-------------------------------------

STATUS EQU    $6019   état machine
RANG   EQU    $601B   rangee courante
COLN   EQU    $6020   colonne courante
TIMEPT EQU    $6027   vecteur IT timer
RSOPC  EQU    $602B
USERAF EQU    $602D   pt car. user
ATRANG EQU    $6039   attrib. courants
ATRSCR EQU    $603A   ...     écran
COLOUR EQU    $603B   couleur cour.
TELETL EQU    $603C   mode page
CHDRAW EQU    $6041   tracé point ou car
MAXBK  EQU    $6047   dernier bank libre
DKDRV  EQU    $6049   drive courant
DKNUM  EQU    $604D   entrelacement
SCRMOD EQU    $605F   mode écran
BUFCLV EQU    $6079   pt buffer clavier
SIZCLV EQU    $607B   lg buffer clavier
IDSAUT EQU    $6082   buffer clav. std.
PTGENE EQU    $60CF   géné. car.

VALTYP EQU    $6105   calculs
FACMO  EQU    $6150
FACLO  EQU    $6151
ARGMO  EQU    $615B
ARGLO  EQU    $615C
DEBZON EQU    $616B
FINZON EQU    $616E
EOFFLG EQU    $6178
NAMSEC EQU    $618E
NAMSLT EQU    $618F
CARCOU EQU    $6196
SECBUF EQU    $6197
FATPTR EQU    $6199
COULGR EQU    $619F   couleur graphique
TRATYP EQU    $61A0   type tracé
XXXXXX EQU    $61A1   curseur graphique
YYYYYY EQU    $61A3   .
XL     EQU    $61A5   marges graphiques
YB     EQU    $61A7
XR     EQU    $61A9
YT     EQU    $61AB
X0COD  EQU    $61D6
Y0COD  EQU    $61D7
X1COD  EQU    $61D8
Y1COD  EQU    $61D9
PASSCD EQU    $61DB
LSTBYT EQU    $61DC
FILFLG EQU    $61EF   flag remplissage
AXEH   EQU    $61F1   rayons ellipses
AXEV   EQU    $61F0
CAMFLG EQU    $61F2

PUTFLG EQU    $6249   mode cod/decod ima
FILMOD EQU    $624B
FILTYP EQU    $624C
ASCFLG EQU    $624D
FILNAM EQU    $624F   nom fichier
OPTBUF EQU    $625A
MACP   EQU    $627D   pt motif rempliss.
WITH   EQU    $6288   type tracé

BANKC  EQU    $E7E5   gate commut bank

PUTC   EQU    $E803   edition ecran
INITC  EQU    $E800   init ecran
GETC   EQU    $E806   lecture clavier
KTST   EQU    $E809   test clavier
RSCO   EQU    $E812   e/s
GETL   EQU    $E818   lect souris
LPIN   EQU    $E81B   lect touche souris
GETP   EQU    $E821   lect point graphi.
GETS   EQU    $E824   lect écran
MENU   EQU    $E82D   retour TO9
KBIN   EQU    $E830   clig. curs. IT
SETP   EQU    $EC00   definition couleur
EXTRA  EQU    $EC0C   extra. moniteur
RESETC EQU    0       .
RESETW EQU    1       .
FCBINI EQU    2       .
OPEN   EQU    3       .
PRINT  EQU    4       .
INPUT  EQU    5       .
CLOSE  EQU    6       .
DIR0   EQU    8       .
ERRMSG EQU    20      .
CIRCLE EQU    24      .
PSETXY EQU    25      .
LINE   EQU    26      .
BOX    EQU    27      .
CHOIX  EQU    28      .
PAINT  EQU    29      .
MIG    EQU    30      .
SHOW   EQU    33      .
MOVE   EQU    38      .
INITOR EQU    39      .
CMPTOR EQU    40      .
SGN    EQU    41      .
SQR    EQU    44      .
FRCTYP EQU    50      .
SUBGO  EQU    55      .
MULTGO EQU    56      .
DIVGO  EQU    57      .
MOVFM  EQU    62      .
MOVMF  EQU    63      .
MOVAF  EQU    64      .
EXTFIN EQU    65      .
CODE   EQU    69      .

SQI    EQU    $10     accès fichier
SQO    EQU    $20


* Equates caractères
*---------------------------------------

BS     EQU    $08     codes ASCII ctrl
HT     EQU    $09
LF     EQU    $0A
VT     EQU    $0B
FF     EQU    $0C
RC     EQU    $0D
SS2    EQU    $16
CAN    EQU    $18
ESC    EQU    $1B
INS    EQU    $1C
EFF    EQU    $1D
RS     EQU    $1E
US     EQU    $1F
SP     EQU    $20
GRAVE  EQU    $41
AIGU   EQU    $42
CIRCON EQU    $43
DEL    EQU    $7F

* Equates des outils
*---------------------------------------

POINTS EQU    0
LIGNES EQU    1
RECTAN EQU    2
CARRE  EQU    3
ELLIPS EQU    4
CERCLE EQU    5
CARACT EQU    6
PEINTU EQU    7
GOMME  EQU    8
LOUPE  EQU    9
COUCOP EQU    10
COLLER EQU    11

* Etats des outils
*---------------------------------------

POINTE EQU    0
TIRE   EQU    1

* Tailles caractère
*---------------------------------------

TCN    EQU    $4C
TCDH   EQU    $4D
TCDL   EQU    $4E
TCDT   EQU    $4F

* Définition des bank RAM utilisées
*---------------------------------------

BKTIR  EQU    2       RAM
PBKPIL EQU    3       Pile fenêtre
DBKPIL EQU    6
BKMANO EQU    6       Zone manoeuvre
PBKTRA EQU    7       Feuille travail
DBKTRA EQU    12
PBKALB EQU    13      Albums

* Définition des caractères utilisateurs
*---------------------------------------

* Nb de $80 à $AF ... icones outils !!!
* Nb de $B0 à $BB ... icones taille trai
MOTRAZ EQU    $BC     icone raz
MOTRET EQU    $BD     icone retour
MOTSUI EQU    $BE           suite
CSCRG0 EQU    $BF     icones scroll
CSCRG1 EQU    $C0
CSCRG2 EQU    $C1
CSCRD0 EQU    $C2
CSCRD1 EQU    $C3
CSCRD2 EQU    $C4
CSCRH0 EQU    $C5
CSCRH1 EQU    $C6
CSCRH2 EQU    $C7
CSCRB0 EQU    $C8
CSCRB1 EQU    $C9
CSCRB2 EQU    $CA

* Déplacements sur RAM
*---------------------------------------

       ORG    $6800

PILE   EQU    *-1     pile soft

ZONFEN RMB    1080    zone fenêtrage

OUTIL  RMB    1       outil courant

MAXALB RMB    1       max. albums
NBALB  RMB    1       nb album courant
TABALB RMB    16*(8+1)
*                     16 postes max
*                     8 car: nom
*                     1 car: bank

ETAOUT RMB    1       état outil

X0TIRE RMB    2       coordo. dessins
Y0TIRE RMB    2       provisoires
X1TIRE RMB    2
Y1TIRE RMB    2

REGCC  RMB    1       pile (/U) des
REGA   RMB    1       param FEN
REGB   RMB    1
REGX   RMB    2
REGY   RMB    2
PILFEN EQU    *

CARMOT RMB    8       motif courant
MOTIF  EQU    *

TXTMOT RMB    8       motif ASCII

       RMB    8       motif plein
PLEIN  EQU    *

TCAR   RMB    1       taille caractère

TLIGN  RMB    1       taille ligne

FLGSS2 RMB    1       drapeau SS2

FLGLOU RMB    1       drapeau loupe
RNGLOU RMB    1       fenêtre loupe
COLLOU RMB    1       ...

STDTOR RMB    1       drapeau tortue std

CADRNG RMB    1       zone cadréee dans
CADCOL RMB    1       la fenêtre par
CADHAU RMB    1       SPCADR
CADLAR RMB    1       CADCOL=0..59!

COEFMU RMB    4       réel coef écr/impr
MEMREL RMB    4       réel manoeuvre

DESCOU RMB    8       fichier courant

* Chien de garde (peinture)
*---------------------------------------

BKDOG  RMB    1
ADRDOG RMB    2
STKDOG RMB    2
DPDOG  RMB    1
FLGDOG RMB    1
XDOG   RMB    FDOG-DDOG

* Page 0 en accès rapide:
*    - Tiroir
*    - Echanges écran <-> feuille
*---------------------------------------

       ORG    $6F00
MANTIR EQU    *
FLGTIR RMB    1       signale un tiroir
*                     dans $A000...
XT0    RMB    2       cordonnées points
YT0    RMB    2       début
XT1    RMB    2       cordonnées points
YT1    RMB    2       fin
CPTLT  RMB    1       compteurs
CPTCT  RMB    1
HPTTIR RMB    1       hauteur en points
LPTTIR RMB    2       largeur ...
LARTIR RMB    1       largeur en segment
DECTIR RMB    1       décalage bit
COLT0  RMB    1       col. car. gauche
COLT1  RMB    1       col. car. droite
ADPRSG RMB    2       adresse 1er seg.
*                     dans chaque page
ADPRSL RMB    2       adresse 1er seg.
*                     ligne courante
PRE7C3 RMB    1       page 1er segment
NBSEG1 RMB    1       nb seg. 1ère page
NBSEG2 RMB    1       nb seg. 2ème page
DECSEG RMB    1       décalage visu
DECLIG RMB    1
LARTV  RMB    1       taille visu
HAUTV  RMB    1
ADF    RMB    2       adr. début feuille
*                     pour les 2 pages
*                     0..48959 (3 banks)
ADPRRL RMB    2       adr. deb. ligne
RGDECR RMB    1       rangée début écran
*                     0..101 (8 pts)
CLDECR RMB    1       colonne ...
*                     0..59  (16 pts)

* Variables de gestion "copier" sur
* album
*---------------------------------------

COPALB RMB    1       flag FF=>en cours
COPAOU RMB    1       mémo outil
ALBCOU RMB    2       pt album courant


* Tortue de pointage en mode caractère
*---------------------------------------

FLGTXT RMB    1       flag mode texte
CLITXT RMB    1       flag clign tortue
TORTXT RMB    100     descrip. tortue
*                     pour mode texte
TXTX   EQU    TORTXT+6  abscisse tortue
TXTY   EQU    TORTXT+9  ordonne tortue
TFORME EQU    TORTXT+16 forme

* Tiroir ou zone manoeuvre (codage/
* décodage,remplissage,copie fichier)
* utilise tout le bank RAM
*---------------------------------------

ZONTRA EQU    $A000
LGZTRA EQU    $E000-ZONTRA
FINTRA EQU    $DFFF
