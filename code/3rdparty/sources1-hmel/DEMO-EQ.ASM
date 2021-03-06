       TITLE  TO-PHOTO: Equates
*      ------------------------------
       PAGE

****************************************
*                                      *
*           TO-PHOTO                   *
*                                      *
*    Equates                           *
*                                      *
****************************************


* Definition des points d'entree dans
* le moniteur TO9
*-------------------------------------

STATUS EQU    $6019   �tat machine
RANG   EQU    $601B   rangee courante
COLN   EQU    $6020   colonne courante
IRQPT  EQU    $6021   vecteur IRQ
FIRQPT EQU    $6023   vecteur FIRQ
TIMEPT EQU    $6027   vecteur IT timer
RSOPC  EQU    $602B
USERAF EQU    $602D   pt car. user
SWIPT  EQU    $602F   vecteur SWI1
FORME  EQU    $6038
ATRANG EQU    $6039   attrib. courants
ATRSCR EQU    $603A   ...     �cran
COLOUR EQU    $603B   couleur cour.
TELETL EQU    $603C   mode page
CHDRAW EQU    $6041   trac� point ou car
BAUDS  EQU    $6044
NOMBRE EQU    $6046
MAXBK  EQU    $6047   dernier bank libre
DKOPC  EQU    $6048   code op. DKCO
DKDRV  EQU    $6049   drive courant
DKNUM  EQU    $604D   entrelacement
SAVCOL EQU    $605C
REACLV EQU    $605E   pt buf clav
SCRMOD EQU    $605F   mode �cran
WRICLV EQU    $6067   pt buf clav
BUFCLV EQU    $6079   pt buffer clavier
SIZCLV EQU    $607B   lg buffer clavier
RUNFLG EQU    $607F   flag d�marr. auto
IDSAUT EQU    $6082   buffer clav. std.
RESETP EQU    $6088   init. periph.
PTGENE EQU    $60CF   g�n�. car.
TSTRST EQU    $60FE   flag d�marrage

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
TRATYP EQU    $61A0   type trac�
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
WITH   EQU    $6288   type trac�


DRA    EQU    $E7CC     registres 6821
DDRA   EQU    $E7CC
CRA    EQU    $E7CE     manettes et son

BANKC  EQU    $E7E5   gate commut bank

SIOTRN EQU    $E7E8   reg. TD/RD ACIA
SIOSTA EQU    $E7E9   reg. �tat   ...
SIOCMD EQU    $E7EA   reg. comm   ...

PUTC   EQU    $E803   edition ecran
INITC  EQU    $E800   init ecran
GETC   EQU    $E806   lecture clavier
KTST   EQU    $E809   test clavier
DRAW   EQU    $E80C   ecriture trait
PLOT   EQU    $E80F   ecriture point
RSCO   EQU    $E812   e/s
GETL   EQU    $E818   lect souris
LPIN   EQU    $E81B   lect touche souris
GETP   EQU    $E821   lect point graphi.
GETS   EQU    $E824   lect �cran
DKCO   EQU    $E82A   acc�s disquette
MENU   EQU    $E82D   retour TO9
KBIN   EQU    $E830   clig. curs. IT
SETP   EQU    $EC00   definition couleur
COMS   EQU    $EC03   appel sur ROM
EXTRA  EQU    $EC0C   extra. moniteur
RESETC EQU    0       .
RESETW EQU    1       .
FCBINI EQU    2       .
OPEN   EQU    3       .
PRINT  EQU    4       .
INPUT  EQU    5       .
CLOSE  EQU    6       .
DIR0   EQU    8       .
KILL   EQU    14      .
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

SQI    EQU    $10     acc�s fichier
SQO    EQU    $20


* Equates MIG
*---------------------------------------

STOP   EQU    0
ABS    EQU    5
REL    EQU    6
LFCUR  EQU    7
FCUR   EQU    8
BOITE  EQU    14
ROND   EQU    17

* Equates caract�res
*---------------------------------------

SOH    EQU    $01
EOT    EQU    $04
ACK    EQU    $06
BS     EQU    $08     codes ASCII ctrl
HT     EQU    $09
LF     EQU    $0A
VT     EQU    $0B
FF     EQU    $0C
RC     EQU    $0D
NACK   EQU    $15
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


* D�finition des bank RAM utilis�es
*---------------------------------------

BKMANO EQU    2       RAM manoeuvre
*                     (variable)
PBKPIL EQU    3       Pile fen�tre
DBKPIL EQU    6
PBKPEL EQU    7       pellicule

* D�placements sur RAM
*---------------------------------------

       ORG    $6800

PILE   EQU    *-1     pile soft

PAGE0  RMB    256     pour registres
*                     rapides !!!

ZONFEN RMB    1080    zone fen�trage

REGCC  RMB    1       pile (/U) des
REGA   RMB    1       param FEN
REGB   RMB    1
REGX   RMB    2
REGY   RMB    2
PILFEN EQU    *

PALETE RMB    16*2    palette courante
TOUR   RMB    1
MODVID RMB    1

DESCOU RMB    8       fichier courant

* Buffers
*---------------------------------------

BUF    RMB    128     buffer manoeuvre

* Zone manoeuvre
* utilise tout le bank RAM
*---------------------------------------

ZONTRA EQU    $A000
LGZTRA EQU    $E000-ZONTRA
FINTRA EQU    $DFFF
