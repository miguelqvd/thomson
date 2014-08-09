       TITLE  FEN:    parametres
*      --------------------------
       PAGE

****************************************
*                                      *
*    Parametres du FENETRAGE TO-FEN    *
*                                      *
****************************************



* Couleurs
*---------------------------------------

NOIR   EQU    0
ROUGE  EQU    1
VERT   EQU    2
JAUNE  EQU    3
BLEU   EQU    4
MAGENT EQU    5
CYAN   EQU    6
BLANC  EQU    7
GRIS   EQU    8
ROSE   EQU    9
VERTCL EQU    10
SABLE  EQU    11
BLEUCL EQU    12
PARME  EQU    13
BLEUCI EQU    14
ORANGE EQU    15

TRANSP EQU    $FF     non gere = transp.


* Blocs de descripteurs de fenetres
*---------------------------------------

FLOCA  EQU    0
FLOCF  EQU    1
FLOCR  EQU    2
FTOURI EQU    3
FTOURE EQU    4
FCADRE EQU    5
FCOULF EQU    6
FFOND  EQU    7
FTRAME EQU    8
FMASQ  EQU    9
FINVVD EQU    10
FTEXTE EQU    11
FEDI   EQU    12
FCALL  EQU    13
FDO    EQU    14
FLOOP  EQU    15
FSTOP  EQU    16
FPOUSS EQU    17
FINV   EQU    18
FCOMF  EQU    19
FCZI   EQU    20


* Deplacement des indirection vers les
* S/P de fenetrage dans le binaire
* relogeable.
* Nb: BASEF doit etre prealablement
*     equivalence a l'adresse d'implant.
*     du binaire
*---------------------------------------

FENINI EQU    BASEF+0
FENFIN EQU    BASEF+3
FENOUV EQU    BASEF+6
FENRPL EQU    BASEF+9
FENFER EQU    BASEF+12
FENACT EQU    BASEF+15
FENDES EQU    BASEF+18
FEN    EQU    BASEF+21
FENLCZ EQU    BASEF+24
FENCH  EQU    BASEF+27
FENVIS EQU    BASEF+30
FENLOC EQU    BASEF+33
FENLOF EQU    BASEF+36
FENLOR EQU    BASEF+39
FENTI  EQU    BASEF+42
FENTE  EQU    BASEF+45
FENCAD EQU    BASEF+48
FENCF  EQU    BASEF+51
FENFON EQU    BASEF+54
FENTRA EQU    BASEF+57
FENMAS EQU    BASEF+60
FENIVD EQU    BASEF+63
FENSEL EQU    BASEF+66
FENTXT EQU    BASEF+69
FENPUT EQU    BASEF+72
FENEDI EQU    BASEF+75
FENTOR EQU    BASEF+78
FENERR EQU    BASEF+81

SOUDAN EQU    BASEF+84
DECBIN EQU    BASEF+87
SIGBIN EQU    BASEF+90
HEXBIN EQU    BASEF+93
BINDCG EQU    BASEF+96
BINDCD EQU    BASEF+99
BINSGG EQU    BASEF+102
BINSGD EQU    BASEF+105
BINHX1 EQU    BASEF+108
BINHX2 EQU    BASEF+111

SBREAK EQU    BASEF+114
TBREAK EQU    BASEF+117

DOSSEL EQU    BASEF+120
DOSDIR EQU    BASEF+123
DOSFIL EQU    BASEF+126
DOSCZI EQU    BASEF+129
DOSINI EQU    BASEF+132
DOSREN EQU    BASEF+135
DOSSUP EQU    BASEF+138
DOSDUP EQU    BASEF+141
DOSCAT EQU    BASEF+144
DOSTST EQU    BASEF+147
DOSCNF EQU    BASEF+150
DOSERR EQU    BASEF+153
DOSCOU EQU    BASEF+156

FENCNT EQU    BASEF+159


* valeur de caractère pour l'édition
* d'une balise de pointage par FENTXT
*---------------------------------------

BALISE EQU    $1D


* Valeurs des entites d'une fenetre
*---------------------------------------

OFF    EQU    $00     touches
ON     EQU    $01

INTERD EQU    $FF     interdiction

TEXTE  EQU    $00     saisies
DECIM  EQU    $01
SIGNE  EQU    $02
HEXA   EQU    $03


* Type des entites d'une fenetre
*---------------------------------------

POUSS  EQU    $00     poussoir
INVERS EQU    $01     inverseur
CHACZI EQU    $02     champ de saisie


* Déplacements sur le descripteur d'une
* entite fenetre
*---------------------------------------

CODEQU EQU    0       code equivalent
TYP    EQU    1       POUSS:INVERS:CZI
*                     ------------------
VAL    EQU    2       OFF  :OFF   :TEXTE
*                     ON   :ON    :DECIM
*                          :      :SIGNE
*                          :      :HEXA
*                     INTER:INTERD:INTER

RNG    EQU    3       rangee  debut
COL    EQU    4       colonne debut
HAUT   EQU    5       hauteur
LARG   EQU    6       largeur
SUIV   EQU    7       pointeur bloc suiv
