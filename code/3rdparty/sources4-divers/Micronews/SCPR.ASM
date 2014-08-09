***************************************

** ** *** ** ** *  * *** *** * *  * ***
*  *  * * *  *  ** * * * * *   ** *  *
** *  **  ** ** * ** *** **  * * **  *
 * *  * * *  *  *  * *   * * * *  *  *
** ** * * ** ** *  * *   * * * *  *  *

***************************************
*                                     *
* Par Michel SAINT-BRIANT / ASCI 1991 *
*                                     *
***************************************

* Cette petite routine installée en
* résident permet à tout programme BASIC
* 512 d'émuler une imprimante compatible
* IBM Proprinter (toutes les imprimantes
* pour ordinateur de type PC.

****************************************
*                                      *
* Ecrit spécialement pour les lecteurs *
*                                      *
* de MICRONEWS     (NANCY le 10/10/91) *
*                                      *
****************************************

       ORG    $7800

************** ^^^^ ****************
* En fonction de certains programmes
* qui utilisent la RAM en $7800 on
* peut modifier cette valeur (jusqu'à
* $9C00/$9D00 -> Attention à la pile!)
************************************

************************************
* Déroutage de l'analyse des instruc-
* tions BASIC. On cherche les codes
* $FF,$A4,$AB correspondant à SCREEN-
* PRINT et on les remplacera par un
* TROFF inoffensif de code $91 après
* avoir incrémenté de 2 le pointeur d'
* instructions BASIC en $61C7.
************************************


INTER  PSHS   CC,X
       CMPA   #$FF    Ordre BASIC 2ème
       BNE    QUIT              \série
       LDX    $61C7
       LDX    1,X
       CMPX   #$A4AB  si=SCREENPRINT
       BEQ    SCRPRT  alors>SCRPRT
QUIT   PULS   CC,X,PC sinon on sort.

SCRPRT LDX    $61C7   pointeur=
       LEAX   2,X     pointeur+2
       STX    $61C7
       LDA    #$91    En sortie on va
       PSHS   DP,B,A,Y,U   \simuler un
       LDX    #$4078        \TROFF
       LDB    #$14    on éteint le cur-
       JSR    $E803   seur (pollution!)
       LDD    #$1B40  <-Ajouter ici d'
       LBSR   PUTINT   éventuels codes
NEWLIN ORCC   #$50     de commandes pour
       LDA    #$28     impression spéci-
       STA    -15,S    ales (dble frappe
       LDD    #$3318   condensé,etc...)
       LBSR   PUTESC
       TST    $605F    est-ce en 40 col?
       BEQ    CONS0
CONS1  LDD    #$4C80   $4C est le code
       LBSR   PUTESC   pour le graphisme
       LDB    #$2      en double densité
       LBSR   PUTCPR   suivi de longueur
       BRA    NEWCAR   ($280=640 octets)
CONS0  LDD    #$4B40   $4B est le code
       LBSR   PUTESC   pour le graphisme
       LDB    #$01     en simple densité
       LBSR   PUTCPR   suivi de longueur
NEWCAR LDA    $E7C3    ($140=320 octets)
       ORA    #$01
       STA    $E7C3   <- RAMA
CAR80  LDA    -$78,X  lit le caractère
       LDB    -$50,X  (les 8 lignes et
       STD    -14,S    les stocke en
       LDA    -$28,X   dessous de la pi-
       LDB    ,X       le en sécurité)
       STD    -12,S
       LDA    $28,X
       LDB    $50,X
       STD    -10,S
       LDA    $78,X
       LDB    $A0,X
       STD    -8,S
       LDA    #$08    inversion de la
INVMAT ROL    -14,S   matrice 8x8 du
       ROLB           caractère-écran
       ROL    -13,S   pour en faire
       ROLB           la matrice 8x8
       ROL    -12,S   du caractère-
       ROLB               imprimante
       ROL    -11,S          >> C >>>
       ROLB                 /        \
       ROL    -10,S        /          \
       ROLB           ROL= <-xxxxxxxx-<
       ROL    -9,S           <<<<<<<<
       ROLB
       ROL    -8,S     rotation à gauche
       ROLB           le carry (C) va en
       ROL    -7,S    b0,b0 en b1,b1 >b2
       ROLB           etc...b6>b7 et b7
       BSR    PUTCPR  va dans le carry C
       DECA
       BNE    INVMAT
       LDA    $E7C3   est-on sur RAMA?
       BITA   #$01
       BEQ    TESTFL  test de fin de li-
       TST    $605F   test mode    \gne.
       BEQ    TESTFL  si 80 col alors
       ANDA   #$FE    on passe en RAMB
       STA    $E7C3   et on imprime le
       BRA    CAR80   caractère suivant.
TESTFL LEAX   1,X
       DEC    -15,S   jusqu'en fin de
       BNE    NEWCAR  ligne
       LEAX   $0118,X
       CMPX   #$5FB8  jusqu'en fin d'
       BHS    FIN     écran
       LDD    #$0A0D  code de saut de
       BSR    PUTINT        \ligne
       LBRA   NEWLIN
FIN    LDD    #$1B40  réinitialisation
       BSR    PUTINT  de l'imprimante.
       PULS   U,Y,A,B,DP
       PULS   X,CC,PC on sort...

PUTESC PSHS   B,A     impression d'un
       LDB    #$1B    code ESC ($1B) et
       BSR    PUTCPR  de 2 autres codes.
       PULS   A,B
PUTINT PSHS   B       impression de deux
       TFR    A,B     codes (A puis B)
       BSR    PUTCPR
       PULS   B
PUTCPR PSHS   A       impression d'un
BOUCLE LDA    $E7C3   Attente \caractere
       ANDA   #$40    passage du bit 6
       BNE    BOUCLE  de $E7C3 à 0
       TFR    B,A
       ANDA   #$FE    les bits 1 à 7 de
       ANDB   #$01    l'octet sont mis
       STD    -2,S    de 1 à 7 en $E7C8
       LDD    $E7C8   et le bit 0 dans
       ANDA   #$01    le bit 0 de $E7C9.
       ANDB   #$FC
       ADDD   -2,S
       STD    $E7C8
       ORB    #$02    signal d'envoi de
       STB    $E7C9   caractère (bit1=1)
       PULS   A,PC

********************************
*        Initialisation        *
********************************

INIT   PSHS   A,X     on installe la
       LDX    #INTER  routine sur le
       STX    $67C1   déroutage d'analy-
       LDA    #$7E    se d'instructions
       STA    $67C0   BASIC.
       PULS   A,X,PC


       END
