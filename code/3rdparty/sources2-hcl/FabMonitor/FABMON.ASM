**** Fichier principal (Programme). ****

       INCLUD EQUATES

       ORG    CODE
       STA    KOMBAC+1
       LDX    #$5FEF  exécuté au RESET:
       STX    >$600A  ->indirection GETC
       LDB    #$20
       STB    >$5FFB  ->rétablit le saut
       BRA    KOMBAC
       FCC    " FAB-Mon  v3.1  "

G      STA    KOMBAC+1
       PULS   CC,A,B
       JSR    GETC
       PSHS   B,A,CC
       CMPB   #'Z-64    CNT-Z appuyé ?
       BEQ    *+10
KOMBAC LDD    #$00E7
       TFR    B,DP
       JMP    PCRTAD

*** sauvegarde des registres du 6809
       ORCC   #80
       STA    DIR*256+REGIST-15  ($E7E6)
       LEAS   4,S
       PULS   D           adresse retour
       STD    DIR*256+REGIST-2
       STS    DIR*256+REGIST-14   pile S
       LEAS   -6,S
       PULS   A              registre CC
       STA    DIR*256+REGIST-12
       PULS   A,B,DP    registres A,B,DP
       LDS    #DIR*256+REGIST-2
       PSHS   U,Y,X,DP,B,A
       LDS    #DIR*256+Z
       LDA    #DIR
       TFR    A,DP

*** sauvegarde de la palette de couleurs
       LDX    #COLORS+32
       JSR    SYNCRO
       LDA    #16
       CLR    $E7DB
PALSAV LDB    $E7DA
       STB    1,X
       LDB    $E7DA
       STB    ,X++
       DECA
       BNE    PALSAV
       LDX    #NULL   palettes en noir
       JSR    SETPAL

*** sauvegarde de l'environnement du TO8
       LDA    $E7C3
       LDB    $E7E7
       ANDB   #1        registre E7E4
       STD    <C3E4     registre E7C3
       ANDA   #254
       STA    $E7C3
       LDB    #$54
       STB    $E7E7   gestion pages E7E5

       LDA    $E7E5
       STA    >*+7
       JSR    ZZZBK1  sauve écran > bank
       LDA    #0
       STA    $E7E5

       LDA    $605F    devrait permettre
       LDX    #AFFMOD   de retrouver le
       LDB    ,X+      mode d'affichage
       CMPA   ,X++
       BEQ    AFFUND
       CMPX   #COLORS
       BNE    *-9
AFFUND LDA    -1,X
       STD    <CODCDD    registre E7DC
       CLR    $E7E4    et No de CONSOLE
       LDB    $E7E4
BORDER ADDB   #0        couleur du tour
       STB    <CODCDD+2  registre E7DD

       LDD    #0
       STD    $E7DC
       LDA    $6049    face du lecteur
       ANDA   #1
       STA    <DKDRV
       LDB    $6052   position tête Dsk0
       STB    <TRACK
       LDX    #BUFCLV
       LDD    $6079
       STD    ,X++
       STX    $6079
       JSR    FABMON

* on remet tout en place et on se casse.

       LDD    >BUFCLV
       STD    $6079
       LDB    <TRACK  position tête Dsk0
       STB    $6052
       LDD    <CODCDD+1 restaure rgistrs
       STD    $E7DC        du TO8
       LDA    $E7E5
       STA    >*+7
       JSR    GBK2VW       restaure
       LDA    #0        bank -> écran
       STA    $E7E5
       LDD    <C3E4
       STA    $E7C3
       STB    $E7E4

       LDX    #COLORS+32
       JSR    SETPAL
       LDA    $6081
       STA    $E7E7

       LDS    #DIR*256+REGIST-14
       PULS   Y        vraie pile retour
       PULS   A,X       registres CC,A,B
       STA    -6,Y
       STX    -5,Y
       PULS   A              registre DP
       STA    -3,Y
       LDX    <REGIST-2
       STX    -2,Y     adresse de retour
       PULS   X,Y,U
       LDS    <REGIST-14
       LEAS   -6,S
       LDA    <REGIST-15         ($E7E6)
       JMP    >KOMBAC

SETPAL PSHS   A,B
       BSR    SYNCRO
       LDB    #16
       CLR    $E7DB
       LDA    1,X
       STA    $E7DA
       LDA    ,X++
       STA    $E7DA
       DECB
       BNE    *-11
       PULS   A,B,PC
SYNCRO LDA    $E7E7      syncro basse
       BPL    *-3
       LDA    $E7E7
       BMI    *-3
       LDB    #4*45      descend encore
       TST    ,X      6   de 45 lignes
       LDA    1,X     5
       DECB           2
       BNE    *-5     3
       RTS

GVW2BK LDA    $E7C3
       ANDA   #254
       STA    $E7C3
ZZZBK1 LDA    #0
       STA    $E7E5
VW2BNK LDX    #$A000
       LDU    #$4000
       LDD    ,U++
       STD    ,X++
       CMPX   #$C000
       BNE    *-7
       INC    $E7C3
       LDU    #$4000
       LDD    ,U++
       STD    ,X++
       CMPX   #$E000
       BNE    *-7
       RTS

GBK2VW LDA    $E7C3
       ANDA   #254
       STA    $E7C3
ZZZBK2 LDA    >ZZZBK1+1
       STA    $E7E5
BNK2VW LDX    #$A000
       LDU    #$4000
       LDD    ,X++
       STD    ,U++
       CMPX   #$C000
       BNE    *-7
       INC    $E7C3
       LDU    #$4000
       LDD    ,X++
       STD    ,U++
       CMPX   #$E000
       BNE    *-7
       RTS

FABSCR LDA    $E7C3
       ANDA   #254
       STA    $E7C3
       LDX    #$5F40  dessine l'écran de
       LDD    #$C1C1   FAB-Monitor v3.1
       STD    ,--X
       CMPX   #$4000+192*40
       BHI    *-5
CMOTIF LDU    #$D0D0
       LDD    #$9090
       STU    ,--X
       STD    ,--X
       STU    ,--X
       STD    ,--X
       STU    ,--X
       LDB    #$D8
       LDA    #25
       STB    ,-X
       DECA
       BNE    *-3
       LDB    #$F0
       LDA    #5
       STB    ,-X
       DECA
       BNE    *-3
       CMPX   #$4000
       BHI    CMOTIF
       INC    $E7C3
       CLR    ,X+
       CMPX   #$5F40
       BLO    *-5
       LDU    #SCREEN
       STU    <CURSOR
       LDA    #-1
       STA    <IMABNK
       LDX    #COLORS
       JMP    SETPAL


* programme: FAB-Monitor v3.1
FABMON JSR    FABSCR
CMSTRT LDX    #$4000+192*40
       LDD    #0
       STD    ,X++    efface la barre de
       CMPX   #$5F40      commandes
       BLO    *-5
       LDX    <CURSOR sauve curseur haut
       STX    <WRKCSR
       LDD    #SCREEN+25*320
       STD    <BOTTOM
       LDX    #SCREEN+4+24*320
       STX    <CURSOR
       LDA    #-1
       STA    <CLIGNO
       LDD    #$43E    affiche l'invite
       STA    <XPOS          ">"
       JSR    PUTC
COMMND JSR    GETC    lecture lettre-clé
       CMPB   #$60     lettre minuscule
       BLO    *+4
       ANDB   #$DF
       LDX    #OPTION
QELOPT CMPB   ,X+
       BNE    OPTNXT
       LDU    ,X++    la lettre est une
       LDB    ,U+     clé : affichage du
       CMPB   #'@     texte et exécution
       BEQ    *+7       de la commande
       JSR    PUTC
       BRA    *-9
       JSR    [,X]
ERRET1 TSTA
       BEQ    CMSTRT
       LDX    #NULL   palettes en noir
       JMP    SETPAL   et on quitte
OPTNXT LEAX   4,X
       CMPX   #ENDOPT
       BLO    QELOPT
       BRA    COMMND
OPTION FCB    13
       FDB    LNFEED,OPFEED
       FCB    12
       FDB    RAZWIN,OPRAZW
       FCB    '?
       FDB    HLPTXT,OPHELP
       FCB    '@
       FDB    ASCTXT,OPASCI
       FCB    'A
       FDB    ABOTXT,OPABOU
       FCB    'B
       FDB    BNKTXT,OPBANK
       FCB    'C
       FDB    COPTXT,OPCOPY
       FCB    'D
       FDB    DMPTXT,OPDUMP
       FCB    'E
       FDB    JSRTXT,OPGJSR
       FCB    'F
       FDB    FILTXT,OPFILL
       FCB    'G
       FDB    GADTXT,OPGADG
       FCB    'H
       FDB    HNKTXT,OPHUNK
       FCB    'I
       FDB    IMATXT,OPIMAG
       FCB    'J
       FDB    JMPTXT,OPJUMP
       FCB    'K
       FDB    KILTXT,OPKILL
       FCB    'L
       FDB    LODTXT,OPLOAD
       FCB    'M
       FDB    MODTXT,OPMODE
       FCB    'N
       FDB    PALTXT,OPNPAL
       FCB    'O
       FDB    BORTXT,OPBORD
       FCB    'P
       FDB    POKTXT,OPPOKE
       FCB    'Q
       FDB    QITTXT,OPQUIT
       FCB    'R
       FDB    RIDTXT,OPREAD
       FCB    'S
       FDB    SERTXT,OPSEAR
       FCB    'T
       FDB    ROMTXT,OPROMC
       FCB    'U
       FDB    DESTXT,OPDESA
       FCB    'V
       FDB    VIWTXT,OPVIEW
       FCB    'W
       FDB    WRITXT,OPWRIT
       FCB    'X
       FDB    REGTXT,OPREGI
       FCB    '=
       FDB    RGETXT,OPRGEQ
       FCB    'Y
       FDB    SIDTXT,OPSIDE
       FCB    'Z
       FDB    MOVTXT,OPMOVE
       FCB    '*
       FDB    COLTXT,OPCOLO
ENDOPT

PALTXT  * initialise la palette couleurs
       FCC    "NEW PALETTE@"
OPNPAL JSR    GETC
       CMPB   #2
       BEQ    EOPPAL
       CMPB   #13
       BNE    OPNPAL
       LDX    #COLORS
       LDU    #COLORS+32
       LDD    ,X++
       STD    ,U++
       CMPX   #COLORS+32
       BNE    *-7
EOPPAL CLRA
       JMP    HWINDW


BORTXT  * change la couleur du cadre
       FCC    "BORDER $@"
       FCB    0
OPBORD LDA    #1
       JSR    INPUT
       JSR    HWINDW
       BEQ    EOPBOR
       TFR    U,D
       STB    >BORDER+1
       LDB    <CODCDD+2
       ANDB   #$F0
       ADDB   >BORDER+1
       STB    <CODCDD+2  registre E7DD
EOPBOR CLRA
       RTS

MOVTXT  * option: déplace l'indirection
       FCC    "ZAPPER AT $@"
       FDB    0,0
OPMOVE LDD    $6089
       JSR    ATOHEX
       TFR    B,A
       JSR    ATOHEX
       LEAU   -4,U
       LDX    #VALZAP
       STX    <INPVAL
       LDA    #4
       JSR    INPUT
       LDX    #VALHEX
       STX    <INPVAL
       JSR    HWINDW
       BEQ    EOPMOV
       CMPU   #$6000
       BHS    ZAPONE
       LDB    $E7E5
       STB    <CMPT
       LDB    >ZZZBK1+1
       STB    $E7E5
       LEAU   $6000,U
       BSR    ZAPONE
       LEAU   $2000-16,U
       BSR    ZAPONE
       LDB    <CMPT
       STB    $E7E5
       LEAU   -$8000-16,U
       BRA    VECTRS
ZAPONE LDA    #20     taille du zappeur
       LDX    >$6089
       CMPU   >$6089
       BLS    MVZAPI
       LEAX   A,X
       LEAU   A,U
MVZAPD LDB    ,-X     copie en mode
       STB    ,-U     descending
       DECA
       BNE    *-5
       BRA    VECTRS
MVZAPI LEAY   ,U
       LDB    ,X+     copie en mode
       STB    ,U+     ascending
       DECA
       BNE    *-5
       LEAU   ,Y
VECTRS STU    >$6089  détournement RESET
       LEAU   3,U
       STU    >$600A  indirection GETC
       STU    >$0004
       LEAU   12,U
       STU    >$000C
       LEAU   1,U
       STU    >$0034
       CLRA
EOPMOV RTS


ROMTXT  * option: copie une ROM en RAM
       FCC    "TRANSFER ROM $@"
       FCB    0
       FCC    " TO BANK $"
       FDB    0
OPROMC LDA    #1
       JSR    INPUT   choix de la page
       LBEQ   HWINDW  de ROM ($0 à $F)
       TFR    U,D
       LDX    #CPYROM
       STB    11,X       ROM à commuter
       LDU    #OPROMC-2
       LDA    $E7E5
       STA    <CMPT
       JSR    ATOHEX
       LDD    #VALBNK
       STD    <INPVAL
       LDU    #OPROMC-12
       LDA    #2
       JSR    DINPUT  choix de la banque
       LDX    #VALHEX de RAM ($00 à $1F)
       STX    <INPVAL
       JSR    HWINDW
       BEQ    EOPROM
       TFR    U,D
       STB    $E7E5

       LDX    #CPYROM
       LDB    $E7E6
       STB    ROMEND-CPYROM-7,X
       LDU    #$4000+192*40
       LDA    #$C9
       DEC    $E7C3
       STA    ,U
       INC    $E7C3
       LDB    ,X+
       STB    ,U+
       CMPX   #ROMEND
       BNE    *-15
       LDX    #0
       LDU    #$A000
       JMP    >$4000+192*40
RETROM LDX    #$4000+192*40
       DEC    $E7C3
       LDD    #$00C1+256*(ROMEND-CPYROM)
       STB    ,X+
       DECA
       BNE    *-3
       INC    $E7C3
       LDB    <CMPT
       STB    $E7E5
       CLRA
EOPROM RTS

CPYROM CLR    $E7E6
       LDA    >$0020
       FCB    $A7,$8C,ROMEND-9-*-3
       CLR    >$0000
       LDD    ,X++
       STD    ,U++
       LDD    ,X++
       STD    ,U++
       CMPX   #$4000
       BNE    *-11
       CLR    >$0000
       LDA    #0
       STA    $E7E6
       JMP    >RETROM
ROMEND

MODTXT  * change le mode d'affichage
       FCC    "MODE $@"
       FCB    0
OPMODE LDB    <CODCDD
       ADDB   #'0
       STB    ,U
       LDX    #CHKMOD
       STX    <INPCHK
       LDA    #1
       JSR    INPUT
       LDX    #CHKHEX
       STX    <INPCHK
       JSR    HWINDW
       BEQ    EOPMOD
       TFR    U,D
       TFR    B,A

       LDX    #AFFMOD
       LDB    ,X++
       CMPA   ,X+
       BEQ    MDFUND
       CMPX   #COLORS
       BNE    *-9
       BRA    EOPMOD
MDFUND STD    <CODCDD rgs E7DC / CONSOLE
       LDA    -2,X
       STA    $605F
EOPMOD CLRA
       RTS

GADTXT  * Exécuter un gadget utilisateur
       FCC    "GADGET@"
OPGADG CLRA
       JSR    GETC
       CMPB   #2
       LBEQ   HWINDW
       CMPB   #13
       BNE    OPGADG
       LDA    #13     No Gadget Installd
       JMP    ERROR

COLTXT  * Voir la palette de couleurs
       FCC    "SHOW COLORS@"
OPCOLO CLRA
       JSR    GETC
       CMPB   #2
       LBEQ   HWINDW
       CMPB   #13
       BNE    OPCOLO
       JSR    HWINDW
       JSR    SYNCRO
       PSHS   DP       On récupèrera DP
       LDB    #$E7      à la sortie !
       TFR    B,DP    Pour accès rapides
       LDD    #30     couleur 15 en noir
       STB    <$DB
       STA    <$DA
       STA    <$DA
       LDA    #15
       STA    <$DD    tour en couleur 15
       LDA    <$C8
       ANDA   #1      attend relâchement
       BNE    *-4         du clavier

* SYNCRONISATION - REGLAGE COLONNE *****
* b5 de $E7E7 : situation en ligne INILN
       LDX    #*+4
       LDA    #32
       BITA   <$E7       sort quand
       BEQ    *-2     spot dans fenêtre
       BITA   <$E7       sort quand
       BNE    *-2     spot entre border
       STA    ,X+     5
       MUL            11  boucle de 63
       MUL            11 cycles dont on
       MUL            11 sort quand le
       MUL            11 spot est sur la
       LDA    ,-X     5     dernière
       BITA   <$E7    4   C O L O N N E
       BEQ    *-10    3   de la fenêtre

* SYNCRONISATION - REGLAGE LIGNE *******
* b7 de $E7E7 : situation en trame INITN
       MUL            11  boucle de 64
       MUL            11 cycles dont on
       MUL            11 sort quand le
       MUL            11  spot est sur
       MUL            11    une ligne
       TST    <$E7    6  DANS le border
       BPL    *-7     3
       MUL            11  boucle de 64
       MUL            11 cycles dont on
       MUL            11 sort quand le
       MUL            11 spot est sur la
       MUL            11    dernière
       TST    <$E7    6     L I G N E
       BMI    *-7     3   de la fenêtre

       LDX    #115*8-3
       LEAX   -1,X     Pour centrer les
       BNE    *-2      lignes de copper.

BORCOL LDU    #COLORS+32
       LDD    ,U++       8
       STD    >NOSTAL+1  6
       LDA    #30        2
       STA    <$DB       4
NOSTAL LDD    #0         3
       STB    <$DA       4
       STA    <$DA       4
       LDX    #8*11      3
       LEAX   -1,X    5
       BNE    *-2     3
       MUL               11
       MUL               11
       CMPU   #COLORS+66 5
       BNE    BORCOL+3   3

       LDX    #107*8+8-2
       LEAX   -1,X
       BNE    *-2
       ABX
       LDA    <$C8      clavier frappé ?
       BEQ    BORCOL    non -> boucle

       JSR    SYNCRO
       LDD    #30
       STA    <$DD    tour en couleur 0
       STB    <$DB
       LDD    >COLORS+30
       STB    <$DA    couleur 15 en brun
       STA    <$DA
       JSR    GETC    Vide buffR clavier
       PULS   DP
       CLRA
       RTS

ASCTXT  * Afficher la table ASCII
       FCC    "ASCII TABLE@"
OPASCI CLRA
       JSR    GETC
       CMPB   #2
       LBEQ   HWINDW
       CMPB   #13
       BNE    OPASCI+1
       JSR    HWINDW

       LDD    #$2032
       STD    <DMPBYT
       LDU    #PUTC
ASCIIT LDB    #32
       JSR    ,U
       CMPA   #100
       BLS    *+4
       LDB    #'1
       JSR    ,U
       LDA    <DMPBYT+1
       JSR    DA2HEX
       LDA    <DMPBYT
       LDB    #8
       STB    <CMPT
       LDB    #32
ASCIHX JSR    ,U
       JSR    DA2HEX
       INCA
       DEC    <CMPT
       BNE    ASCIHX
       JSR    ,U
       JSR    ,U
       LDB    <DMPBYT
       LDA    #8
ASCICH JSR    ,U
       INCB
       DECA
       BNE    ASCICH
       STB    <DMPBYT
       LDB    #32
       JSR    ,U
       JSR    ,U
       LDA    <DMPBYT+1
       ADDA   #8
       DAA
       STA    <DMPBYT+1
       LDA    <DMPBYT
       CMPA   #128
       BNE    ASCIIT
       CLRA
       RTS



       INCLUD OPTIONS2
       INCLUD OPTIONS
       INCLUD FNCTBASE
       INCLUD FILES


       ORG    $2300-15-32
AFFMOD FCB    $2A,$80,1  * 80 colonnes
       FCB    $21,$01,2  * Bitmap 4
       FCB    $7B,$40,3  * Bitmap 16
       FCB    $41,$10,4  * Bitmap 4 SpéC
       FCB    $00,$00,0  * TO7 / défaut
COLORS FDB    0,15,240,255,3840,3855
       FDB    4080,4095,1911,826,931
       FDB    938,2611,2618,3815,123
       FDB    0,0,0,0,0,0,0,0
       FDB    0,0,0,0,0,0,0,0
NULL   FDB    0,0,0,0,0,0,0,0
       FDB    0,0,0,0,0,0,0,0
BUFCLV FDB    0       OLD buffer clavier
       FDB    0,0     mon buffer clavier


       END
