HNKTXT  * option: Hunks d'un fichier
       FCC    "HUNKS @"
       FCB    0
       FCC    "ILENAME."
       FCB    0
       FCC    "IN"
OPHUNK JSR    FILRQT    nom du fichier
       JSR    IPIHEX
EOPHNK JSR    HWINDW  efface curseur etc
       BEQ    *+6
       JSR    HUNKS
       CLRA
       RTS

LODTXT  * option: lecture d'un prog BIN
       FCC    "LOADM @"
       FCB    0
       FCC    "ILENAME."
       FCB    0
       FCC    "IN +SHIFT $"
       FDB    0,0
OPLOAD JSR    FILRQT    nom du fichier
       JSR    IPIHEX
       BEQ    EOPLOD
       LEAU   12,Y
       LDA    #4
       JSR    DINPUT  valeur du décalage
       BEQ    EOPLOD    au chargement
       STU    <LSHIFT
       CLR    <FILETY
EOPLOD JSR    HWINDW  efface curseur etc
       BEQ    *+6
       JSR    LOADM
       CLRA
       RTS

RIDTXT  * option: lecture d'un fichier
       FCC    "READ @"
       FCB    0
       FCC    "ILENAME."
       FCB    0
       FCC    "IN>BUFFER $"
       FDB    0,0
       FCC    " - $"
       FDB    0,0
OPREAD JSR    FILRQT    nom du fichier
       JSR    IPIHEX
       BEQ    EOPRID
       LEAU   12,Y
       JSR    CLRBAR
       LDA    #4
       STA    <FILETY
       JSR    DINPUT  adresse début du
       BEQ    EOPRID  buffer
       STU    <LSHIFT
       LDA    #4
       JSR    DIPUT2  adresse fin du
       BEQ    EOPRID  buffer
       LDD    #2
       SUBD   <LSHIFT
       LEAU   D,U
       STU    <FILSIZ taille+1 du buffer
       LDA    #-1
EOPRID JSR    HWINDW  efface curseur etc
       BEQ    *+6
       JSR    LOADM
       CLRA
       RTS

WRITXT  * option: écriture d'un fichier
       FCC    "WRITE @"
       FCB    0
       FCC    "ILENAME."
       FCB    0
       FCC    "IN ; "
       FCB    0
       FCC    "omments>FILE TYPE: "
       FCB    0
       FCC    " ; DATA TYPE: "
       FCB    0
       FCC    ">FROM $"
       FDB    0,0
       FCC    " TO $"
       FDB    0,0
       FCC    " EXEC $"
       FDB    0,0
OPWRIT JSR    FILRQT  saisie du nom
       BEQ    *+5
       JSR    COMRQT  saisie commentaire
       JSR    IPIHEX
       BEQ    EOPWRT
       BSR    CLRBAR
       LEAU   23,Y
       LDD    #CHKFTY
       STD    <INPCHK
       LDD    #VALFTY
       STD    <INPVAL
       LDA    #1
       JSR    DIPUT3  type du fichier
       BEQ    WRABOR
       STB    <FILETY
       LDD    #CHKDTY
       STD    <INPCHK
       LDD    #VALDTY
       STD    <INPVAL
       LDA    #1
       JSR    DIPUT4  type des données
WRABOR JSR    IPIHEX
       BEQ    EOPWRT
       STB    <DATATY
       BSR    CLRBAR
       LDA    #4
       JSR    DIPUT2  adresse de début
       BEQ    EOPWRT
       STU    <BEGADR
       LDA    #4
       JSR    DIPUT2  adresse de fin
       BEQ    EOPWRT
       LDD    <BEGADR
       TFR    U,D
       SUBD   <BEGADR
       ADDD   #1
       STD    <FILSIZ
       LDA    #4
       LDB    <FILETY    ssi c'est un
       CMPB   #2        programme en LM,
       BNE    EOPWRT      on lit son
       JSR    DIPUT2  adresse exécution
       BEQ    EOPWRT
       STU    <EXEADR

EOPWRT JSR    HWINDW  efface curseur etc
       BEQ    *+6
       JSR    SAVEM
       CLRA
       RTS

CLRBAR LDX    #$4000+192*40
       LDD    #0
       STD    ,X++    efface la barre de
       CMPX   #$5F40      commandes
       BLO    *-5
       LDX    #SCREEN+4+24*320
       STX    <CURSOR
       LDB    #4
       STB    <XPOS
       RTS

KILTXT  * option: efface un fichier
       FCC    "KILL @"
       FCB    0
       FCC    "ILENAME."
       FCB    0
       FCC    "IN"
OPKILL JSR    FILRQT
       JSR    IPIHEX
       JSR    HWINDW  efface curseur etc
       BEQ    *+6
       JSR    KILLM
       CLRA
       RTS

FILRQT LEAY   ,U      lit un descripteur
       LDX    #CHKFIL
       STX    <INPCHK
       LDX    #VALASC
       STX    <INPVAL
       LDA    #8
       JSR    INPUT   nom du fichier
       BEQ    COMRQT-1
       LDX    #FILNAM
       LDB    ,U+
       STB    ,X+
       DECA
       BNE    *-5
       CMPX   #FILNAM+8
       BHS    *+8
       LDB    #32     complète le nom
       STB    ,X+     avec des espaces
       BRA    *-9
       LEAU   8,Y
       LDB    ,U+     affiche "."
       JSR    PUTC
       LDA    #3
       JSR    INPUT   suffixe du fichier
       BEQ    COMRQT-1
       LDB    ,U+
       STB    ,X+
       DECA
       BNE    *-5
       CMPX   #FILNAME+11
       BHS    *+8
       LDB    #32     complète suffixe
       STB    ,X+     avec des espaces
       BRA    *-9
       LDA    #-1     code retour = OK
       RTS
COMRQT LEAU   12,Y
       LDA    #3
       LDB    ,U+     affiche " ; "
       JSR    PUTC
       DECA
       BNE    *-6
       LDD    #CHKASC
       STD    <INPCHK
       LDA    #8
       JSR    INPUT   commentaire
       BEQ    COMRQT-1
       LDB    ,U+
       STB    ,X+
       DECA
       BNE    *-5
       CMPX   #FILNAME+19
       BHS    COMRQT-3
       LDB    #32
       STB    ,X+
       BRA    *-9

RGETXT  * option: charge un registre
       FCC    "LET REGISTER @"
       FDB    0
       FCC    " = $"
       FDB    0,0
OPRGEQ LDX    #CHKASC
       STX    <INPCHK
       LDX    #VALREG
       STX    <INPVAL
       LDA    #2
       JSR    INPUT
       JSR    IPIHEX
       BEQ    EOPRGQ
       LDA    -3,U    longueur
       NEGA           est-ce D ?
       BNE    *+6
       LDA    #2
       LEAY   3,Y
       PSHS   Y,A     sauve longueur
       LDU    #RGETXT+16
       ASLA           digits=2*longueur
       JSR    DINPUT
       PULS   B,Y
       BEQ    EOPRGQ
       BITB   #1      registre 16 bits ?
       BNE    *+6
       STU    ,Y      nouveaux 16 bits
       BRA    EOPRGQ
       TFR    U,D
       STB    ,Y      nouveaux 8 bits
EOPRGQ CLRA
       JMP    HWINDW

       FCB    -2
LRGEQU FCB    'P,'C,-2,32,'U,-2,32,'Y,-2
       FCB    32,'X,-1,'D,'P,-1,32,'B,-1
       FCB    32,'A,-1,'C,'C,-2,32,'S,00
       FCB    32,'D

REGTXT  * option: affiche les registres
       FCC    "REGISTERS@"
       FCC    " PC  A  B   X    Y    U "
       FCC    "   S    DP  CC  "
OPREGI CLRA
       JSR    GETC
       CMPB   #2
       LBEQ   HWINDW
       CMPB   #13
       BNE    OPREGI+1
       JSR    HWINDW
       LDX    #OPREGI-40
       LDB    ,X+
       JSR    PUTC
       CMPX   #OPREGI
       BLO    *-8
       LDX    #DA2HEX
       LDY    #PUTC
       LDU    #DIR*256+REGIST
       LDB    #32
       LDA    ,--U    affiche PC fort
       JSR    ,X
       LDA    1,U     affiche PC faible
       JSR    ,X
       JSR    ,Y
       LDA    -9,U    affiche A
       JSR    ,X
       JSR    ,Y
       LDA    -8,U    affiche B
       JSR    ,X
       JSR    ,Y
       LDA    -6,U    affiche X fort
       JSR    ,X
       LDA    -5,U    affiche X faible
       JSR    ,X
       JSR    ,Y
       LDA    -4,U    affiche Y fort
       JSR    ,X
       LDA    -3,U    affiche Y faible
       JSR    ,X
       JSR    ,Y
       LDA    ,--U    affiche U fort
       JSR    ,X
       LDA    1,U     affiche U faible
       JSR    ,X
       JSR    ,Y
       LDA    -10,U   affiche S fort
       JSR    ,X
       LDA    -9,U    affiche S faible
       JSR    ,X
       JSR    ,Y
       JSR    ,Y
       LDA    -5,U    affiche DP
       JSR    ,X
       JSR    ,Y
       JSR    ,Y
       LDA    -8,U    affiche CC
       JSR    ,X
       CLRA
       JSR    ,Y
       JMP    ,Y

JSRTXT  * option: exécution en mémoire
       FCC    "EXECUTE $@"
       FDB    0,0
OPGJSR LDA    #4
       JSR    INPUT
       BEQ    EOPJSR
       PSHS   DP,CC
       STU    <SUBADR
       STS    <STKBAK
       LDX    #GETC   FAB-Monitor n'est
       STX    $600A   pas ré-entrant !!!
       LDX    BUFCLV
       STX    $6079
       LDS    #DIR*256+REGIST-11
       PULS   A,B,DP,X,Y,U
       LDS    DIR*256+REGIST-14
       LEAS   -6,S
       PSHS   A                 }
       LDA    DIR*256+REGIST-12 } charge
       TFR    A,CC              }   CC
       PULS   A                 }
       JSR    [DIR*256+SUBADR]
       PSHS   A                 }
       TFR    CC,A              } sauve
       STA    DIR*256+REGIST-12 }  CC
       PULS   A                 }
       LEAS   6,S
       STS    DIR*256+REGIST-14
       LDS    #DIR*256+REGIST-2
       PSHS   U,Y,X,DP,B,A
       LDS    DIR*256+STKBAK
       LDX    #BUFCLV+2
       STX    $6079
       LDX    #MYGETC     restaure
       STX    $600A   l'indirection GETC
       PULS   CC,DP
       CLRA
EOPJSR JMP    HWINDW

JMPTXT  * option: saut en mémoire-adieu!
       FCC    "JUMP $@"
       FDB    0,0
OPJUMP LDA    #4
       JSR    INPUT
       BEQ    EOPJMP   peur de sauter ?
       STU    REGIST-2   PC=adresse saut
       LDA    #-1     code retour=EXIT!
EOPJMP JMP    HWINDW

POKTXT  * option: équivalent du POKE
       FCC    "POKE $@"
       FDB    0,0
       FCC    ",$"
       FDB    0,0,0,0,0,0,0,0
OPPOKE LDA    #4
       LEAY   4,U
       JSR    INPUT   l'adresse où POKEr
       BEQ    EOPPOK
       LDB    ,Y+
       JSR    PUTC
       CMPB   #'$
       BNE    *-7
       LEAY   ,U      Y pointe la zone
       LDX    #CHKSOP
       STX    <INPCHK
       LDX    #VALSOP
       STX    <INPVAL  (longueur paire)
PKIMPR LDD    #$10FF
       LDU    #OPPOKE-16
       JSR    INPUT   valeur à y déposer
       JSR    IPIHEX
       BEQ    EOPPOK
       TSTB           chaîne " ?
       BEQ    *+3
       LSRA
POKE   LDB    ,U+
       STB    ,Y+
       DECA
       BNE    POKE
       LDU    #OPPOKE-22 adresse début
       TFR    Y,D
       JSR    ATOHEX
       TFR    B,A
       JSR    ATOHEX
       CLRA
EOPPOK JMP    HWINDW

BNKTXT  * option: change de bank
       FCC    "BANK $@"
       FDB    0
OPBANK LDA    $E7E5
       JSR    ATOHEX
       LDX    #VALBNK
       STX    <INPVAL
       LDA    #2
       LEAU   -2,U
       JSR    INPUT
       BEQ    EOPBNK   juste consulté ?
       TFR    U,D
       STB    $E7E5   valide bank
EOPBNK LDX    #VALHEX
       STX    <INPVAL
       JMP    HWINDW

LNFEED  * option: saute une ligne
       FCC    "RETURN@"
OPFEED JSR    HWINDW
       LDD    #$2820
       JSR    PUTC
       DECA
       BNE    *-4
       RTS

RAZWIN  * option: efface la fenêtre
       FCC    "CLS@"
OPRAZW JSR    HWINDW
       LDX    #SCREEN
       STX    <CURSOR
       LDA    #24
       STA    <CMPT
RAZLIN LDD    #$2820
       JSR    PUTC
       DECA
       BNE    *-4
       DEC    <CMPT
       BNE    RAZLIN
       STX    <CURSOR
       RTS

QITTXT  * option: quitter le moniteur
       FCC    "QUIT@"
OPQUIT CLRA
QUIT   JSR    GETC
       CMPB   #2      touche Stop
       BEQ    QTABRT
       CMPB   #13     touche Entrée
       BNE    QUIT
       DECA           validation Quitter
QTABRT JMP    HWINDW    code retour=-1

SERTXT  * option: recherche d'une chaîne
       FCC    "SEARCH $@"

OPSEAR LDX    #CHKSOP
       STX    <INPCHK
       LDX    #VALSOP   longueur paire
       STX    <INPVAL
       LDD    #$10FF  8 octets=16 digits
       LDU    #SRWORD+17
       JSR    INPUT
       TSTB           chaîne " ?
       BEQ    *+3
       LSRA
       JSR    IPIHEX
       JSR    HWINDW
       BEQ    EOPSER
       LDX    #SRWORD
       STA    ,X+       longueur chaîne
       LDB    ,U+
       STB    ,X+     copie de la chaîne
       DECA
       BNE    *-5
       LDA    $E7E5
SRSUIV ANDA   #$1F
       JSR    SEARCH
       JSR    GETC
       CMPB   #8      flèche gauche
       BNE    SR1
       DECA
       BRA    SRSUIV
SR1    CMPB   #9      flèche droite
       BNE    SR2
       INCA
       BRA    SRSUIV
SR2    CMPB   #13      touche Entrée
       BNE    ENDSR
       CLRA
       JSR    SEARCH
       BNE    SRSUIV+5
       INCA
       CMPA   #$1F
       BLO    *-8
       BRA    SRSUIV
ENDSR  CMPB   #2       touche Stop
       BNE    SRSUIV+5
       CLRA           code retour=OK
EOPSER RTS

DMPTXT  * option: dump de la mémoire
       FCC    "DUMP $@"
       FDB    0,0
OPDUMP LDA    #4
       JSR    INPUT   lecture correcte ?
       JSR    HWINDW  fenêtre supérieure
       BNE    *+3
       RTS            sort ss rien faire
       LEAY   ,U
DPSUIV JSR    DUMP
       JSR    GETC
       CMPB   #10     flèche bas
       BEQ    DPSUIV
       CMPB   #11     flèche haut
       BNE    DMP1
       LEAY   -16,Y
       BRA    DPSUIV
DMP1   CMPB   #8      flèche gauche
       BNE    DMP2
       LEAY   -9,Y
       BRA    DPSUIV
DMP2   CMPB   #9      flèche droite
       BNE    DMP3
       LEAY   -7,Y
       BRA    DPSUIV
DMP3   CMPB   #13     touche Entrée
       BNE    DMP4
DMPAGE LDX    #SCREEN
       STX    <CURSOR
       LDA    #23     hauteur d'1 écran
       STA    <CMPT
       JSR    DUMP
       DEC    <CMPT
       BNE    *-5
       BRA    DPSUIV
DMP4   CMPB   #30     touche RetScreen
       BNE    DMP5
       LEAY   -48*8,Y
       BRA    DMPAGE
DMP5   JSR    FNCKIZ
       BEQ    DPSUIV
ENDDMP CMPB   #2      touche Stop = QUIT
       BNE    DPSUIV+3
       LDU    #OPDUMP-4 adresse courante
       TFR    Y,D     du dump devient la
       JSR    ATOHEX   valeur par défaut
       TFR    B,A
       JSR    ATOHEX
       CLRA           code retour=OK
       RTS

DESTXT  * option: désassemblage mémoire
       FCC    "UNASSEMBLE $@"
       FDB    0,0
OPDESA LDA    #4
       JSR    INPUT
       JSR    HWINDW  fenêtre supérieure
       BNE    *+3     lecture correcte ?
       RTS            sort ss rien faire
       LEAY   ,U
ASSUIV JSR    DESASS
       JSR    GETC
       CMPB   #10     flèche bas
       BEQ    ASSUIV
       CMPB   #8      flèche gauche
       BNE    ASS1
       LDY    <FIRBYT
       LEAY   -1,Y
       BRA    ASSUIV
ASS1   CMPB   #9      flèche droite
       BNE    ASS2
       LDY    <FIRBYT
       LEAY   1,Y
       BRA    ASSUIV
ASS2   CMPB   #13     touche Entrée
       BNE    ASS3
       LDX    #SCREEN
       STX    <CURSOR
       LDA    #23     hauteur d'1 écran
       STA    <CMPT
       JSR    DESASS
       DEC    <CMPT
       BNE    *-5
       BRA    ASSUIV
ASS3   CMPB   #30     touche "y sauter"
       BNE    ASS4
       LDA    <ADRMOD flag "peut sauter"
       BNE    ASSUIV+3
       LDY    <OPCODE  ->adresse pointée
       BRA    ASSUIV
ASS4   JSR    FNCKIZ
       BEQ    ASSUIV
ENDASS CMPB   #2      touche Stop = QUIT
       BNE    ASSUIV+3
       LDU    #OPDESA-4 adresse courante
       TFR    Y,D     du désa devient la
       JSR    ATOHEX   valeur par défaut
       TFR    B,A
       JSR    ATOHEX
       CLRA           code retour=OK
       RTS

* A: numéro de la bank à parcourir
SEARCH STA    $E7E5
       LDU    #LINE
       LDD    #$423A  début ligne "B: "
       STD    ,U++
       LDB    #32
       STB    ,U+
       LDA    $E7E5
       JSR    ATOHEX  affiche la bank
       LDA    #27
       STB    ,U+     ligne vide...
       DECA
       BNE    *-3     ...jusqu'à la
       LDD    #$6000  début de zone
       PSHS   D
       JSR    ATOHEX  "6000    "
       TFR    B,A     ..dernière colonne
       JSR    ATOHEX
       LDD    #$2020
       STD    ,U++
       STD    ,U
       JSR    DISLIN   affiche première
       LDU    <CURSOR  ligne et revient
       LEAU   -315,U     au milieu de
       STU    <CURSOR      celle-ci
       LDA    #5
       STA    <XPOS
       LDU    #SRWORD  chaîne à trouver
       LDB    ,U+     longueur de chaîne
       PULS   X       retrouve $6000=déb
SRMEMO LDA    $E7C8   clavier relâché ?
       BEQ    SRCONT
       PSHS   B
       JSR    GETC
       CMPB   #2      touche STOP
       BNE    *+6
       LEAS   1,S
       BRA    SREND
       CMPB   #3      touche SHIFT+STOP
       PULS   B         longueur > 0
       BEQ    SREND+1
SRCONT LDA    ,X+
       CMPA   ,U
       BEQ    CMPNXT
SEARET CMPX   #$E000
       BNE    SRMEMO
SREND  CLRB           code "pas CNT-C"
       PSHS   X
       LDX    <CURSOR fin de recherche
       LDA    <XPOS
       LEAX   1,X      on va en bout de
       INCA                ligne
       CMPA   #36
       BNE    *-5
       STA    <XPOS         et
       STX    <CURSOR
       PULS   A         affiche "E000"
       JSR    DA2HEX
       PULS   A
       JSR    DA2HEX
       LDA    $E7E5
       TSTB           code CNT-C ou pas
       RTS
CMPNXT LEAY   ,X
       LEAU   1,U
       DECB           longueur chaîne
       BEQ    SRFUND
       LDA    ,X+
       CMPA   ,U+
       BEQ    *-8
       LEAX   ,Y
       LDU    #SRWORD
       LDB    ,U+
       BRA    SEARET
SRFUND LDA    <XPOS   on a trouvé le mot
       CMPA   #30       fin de ligne ?
       BLO    SRDADR
       PSHS   X
       LDA    #39
       STA    <XPOS
       LDX    <CURSOR   nouvelle ligne
       LEAX   9,X
       STX    <CURSOR
       LDD    #$2920  remplie d'espaces
       JSR    PUTC
       DECA
       BNE    *-4
       LDX    <CURSOR
       LEAX   -315,X   on se place au
       STX    <CURSOR milieu de la ligne
       LDA    #5
       STA    <XPOS
       PULS   X
SRDADR LDB    #32
       JSR    PUTC
       LDU    #SRWORD
       LDB    ,U      recule le pointeur
       NEGB             mémoire de la
       SEX             longueur du mot
       LEAX   D,X
       TFR    X,D      et affiche cette
       JSR    DA2HEX        adresse
       TFR    B,A
       JSR    DA2HEX
       LEAX   ,Y
       LDB    ,U+
       JMP    SEARET
SRWORD FCB    1
       FCC    "SEARCHED PATTERN"
       FDB    0,0,0,0,0,0,0,0

* Y: pointe l'octet à DUMPer (DMPBYT)  *
DUMP   LDU    #LINE
       LDX    #LINE+30  place de l'ASCII
       TFR    Y,D
       JSR    ATOHEX  affiche l'adresse
       TFR    B,A     du début d'HEXDUMP
       JSR    ATOHEX
       LDA    #32
       STA    ,U+
       LDB    #8      octets traités
HXDUMP LDA    ,Y
       JSR    ATOHEX  valeur en hexa
       LDA    #32
       STA    ,U+
       LDA    ,Y+
       STA    ,X+     équivalent ASCII
       DECB
       BNE    HXDUMP
       STY    <DMPBYT
       LDD    #$2020
       STA    ,U
       STD    ,X
       BRA    DISLIN   affiche la ligne

* Y: pointe l'octet à décoder (CURBYT) *
DESASS STY    <FIRBYT sauve l'adresse du
       LDU    #LINE   1r oct désassemblé
       TFR    Y,D
       JSR    ATOHEX    cette adresse
       TFR    B,A     figurera en début
       JSR    ATOHEX      de ligne
       LDA    #32
       STA    ,U+
       JSR    INSTR   décode la commande
       TSTA
       BMI    HEXDMP
       BNE    OPERAN
       INC    <ADRMOD flag "pas sauter!"
       BRA    HEXDMP

OPERAN LDB    #32      remplit d'espaces
       STB    ,U+     jusqu'à l'opérande
       CMPU   #LINE+11
       BNE    *-6
       ANDA   #15
       LDX    #OPECAS-2
       JSR    [A,X]

HEXDMP LDB    #32      remplit d'espaces
       STB    ,U+       jusqu'au hexdump
       CMPU   #LINE+30
       BNE    *-6
       LDX    <FIRBYT   équivalent hexa
       STY    <CURBYT de tous les octets
HEXEQU LDA    ,X+      de l'instruction
       JSR    ATOHEX     désassemblée
       CMPX   <CURBYT
       BLO    HEXEQU
EOLASS CMPU   #LINE+40 remplit d'espaces
       BHS    DISLIN   de la fin du Dump
       STB    ,U+      au bout de ligne.
       BRA    EOLASS   (= 40 caractères)
DISLIN LDX    #LINE   affiche la ligne
       LDA    #40
       LDB    ,X+
       JSR    PUTC
       DECA
       BNE    *-6
       RTS
OPECAS FDB    IMMEDI,DIRECT,INDEXE
       FDB    ETENDU,RELATI,TRANSF,PILES

IMMEDI LDB    #'#
       STB    ,U+
       LDA    ,Y+
       JSR    ATOHEX
       LDA    <ADRMOD
       BITA   #16     opérande 8 bits ?
       BNE    *+3
       RTS
       LDA    ,Y+
       JMP    ATOHEX

DIRECT LDB    #'<
       STB    ,U+
       LDA    ,Y+
       JMP    ATOHEX

ETENDU LDB    #'>
       STB    ,U+
       LDA    ,Y+
       STA    <OPCODE    au cas où l'on
       JSR    ATOHEX
       LDA    ,Y+
       STA    <OPCODE+1 voudrait y aller
       CLR    <ADRMOD flag "peut sauter"
       JMP    ATOHEX

IDX8   LDA    #'-           8 bits , R
       STA    ,U
       LDD    ,Y++    on saute l'offset
       EXG    A,B
       TSTA           déplacement > 0 ?
       BPL    *+5
       LEAU   1,U     garde le signe "-"
       NEGA           et inverse déplac.
       JSR    ATOHEX
       TFR    B,A
       BRA    VIMADP  virgule & registre
IDX9   LDA    ,Y+          16 bits , R
       PSHS   A
       LDD    ,Y++     le déplacement
       BPL    IDXPOS  est-il positif ?
       STD    <OPCODE
       LDA    #'-     non: affiche "-"
       STA    ,U+
       LDD    #0      et inverse déplac.
       SUBD   <OPCODE
IDXPOS JSR    ATOHEX
       TFR    B,A
       JSR    ATOHEX
       PULS   A
VIMADP LDB    #',     virgule & registre
       STB    ,U+
       BRA    IDXREG
IDX11  LDA    #'D          D,R
       STA    ,U+
       BRA    VIRREG
INDEXE LDA    ,Y
       BMI    INDEX2  pas R+4 bits dépl.
       BITA   #16
       BEQ    *+7
       LDB    #'-
       STB    ,U+
       NEGA
       ANDA   #31
       CMPA   #9
       BHI    *+8
       ADDA   #48
       STA    ,U+
       BRA    *+5
       JSR    ATOHEX  écrit déplacament
VIRREG LDA    #',
       STA    ,U+
PCKREG LDA    ,Y+
IDXREG ANDA   #$60        décode et
       LSRA            écrit le registre
       LSRA             servant d'index
       LSRA
       LSRA
       LSRA
       LDX    #IDXLRG liste de registres
       LDA    A,X
       STA    ,U+
       RTS
INDEX2 LDB    ,Y
       BITB   #16
       BEQ    *+6
       LDA    #'[
       STA    ,U+
       ANDB   #15
       ASLB
       LDX    #IDXCAS
       JSR    [B,X]
       LDA    LINE+11
       CMPA   #'[
       BNE    IDXCAS-1
       LDD    [DIR*256+OPCODE]
       STD    <OPCODE
       LDA    #']
       STA    ,U+
       RTS
IDXCAS FDB    IDX0,IDX1,IDX2,IDX3,VIRREG
       FDB    IDX5,IDX6,IDXERR,IDX8,IDX9
       FDB    IDXERR,IDX11,IDX12,IDX13
       FDB    IDXERR,IDX15

IDX0   BSR    VIRREG       ,R+
       LDA    #'+
       STA    ,U+
       RTS
IDX1   BSR    VIRREG       ,R++
       LDD    #$2B2B
       STD    ,U++
       RTS
IDX2   LDD    #$2C2D       ,-R
       STD    ,U++
       BRA    PCKREG
IDX3   LDD    #$2C2D       ,--R
       STD    ,U++
       STB    ,U+
       BRA    PCKREG
IDX5   LDA    #'B          B,R
       STA    ,U+
       BRA    VIRREG
IDX6   LDA    #'A          A,R
       STA    ,U+
       JMP    VIRREG
IDX12  LDD    ,Y++         8 bits , PCR
       SEX
IDXPCR LEAX   D,Y
       TFR    X,D
       STD    <OPCODE si on veut y aller
       CLR    <ADRMOD flag "peut sauter"
       JSR    ATOHEX
       TFR    B,A
       JSR    ATOHEX
       LDD    #$2C50
       STD    ,U++
       LDD    #$4352
       STD    ,U++
       RTS
IDX13  LDA    ,Y+          16 bits , PCR
       LDD    ,Y++
       BRA    IDXPCR
IDX15  LDA    ,Y
       BITA   #16
       BEQ    IDXERR
       LEAY   1,Y
       LDA    ,Y+
       STA    <OPCODE    au cas où l'on
       JSR    ATOHEX
       LDA    ,Y+
       STA    <OPCODE+1 voudrait y aller
       CLR    <ADRMOD flag "peut sauter"
       JMP    ATOHEX
IDXERR LDD    #$3F3F
       STD    ,U++
       RTS
IDXLRG FCC    "XYUS"

RELATI LDA    <ADRMOD
       BITA   #16     déplacement 8bits?
       BNE    RLWORD
       LDB    ,Y+
       SEX
       BRA    *+4
RLWORD LDD    ,Y++
       LEAX   D,Y     l'adresse pointée
       STX    <OPCODE  au cas où l'on
       LDA    <OPCODE voudrait y aller
       JSR    ATOHEX
       LDA    <OPCODE+1
       CLR    <ADRMOD flag "peut sauter"
       JMP    ATOHEX

TRANSF LDB    ,Y
       ANDB   #$F0
       LDX    #TFXREG
       LSRB           4bits poids fort
       LSRB             =reg "source"
       LSRB
       LDD    B,X     texte registre 1
       CMPA   #32
       BEQ    *+4
       STA    ,U+
       STB    ,U+
       LDB    #',     la virgule sépare
       STB    ,U+
       LDB    ,Y+     4bits poids faible
       ANDB   #15     =reg "destination"
       ASLB
       LDD    B,X     texte registre 2
       CMPA   #32
       BEQ    *+4
       STA    ,U+
       STB    ,U+
       RTS

TFXREG FCC    " D X Y U SPC ? ? A BCCDP"
       FCC    " ? ? ? ?"

PILES  LDB    #'S      pile non utilisée
       LDA    <OPCODE+1
       CMPA   #$35
       BHI    *+4
       LDB    #'U
       STB    PILREG+3
       LDB    ,Y+
       BITA   #1      empile-t-on ?
       BNE    DEPILE-5
       LDX    #PILREG liste de registres
       LDA    #8      registres à tester
EMPILE ASLB
       BCC    *+4
       BSR    REGSEL  valide registre
       LEAX   2,X
       DECA
       BNE    EMPILE
ENDPIL LDA    #32     efface la dernière
       STA    ,-U          virgule
       RTS
       LDX    #PILREG+14
       LDA    #8
DEPILE ASRB
       BCC    *+4
       BSR    REGSEL
       LEAX   -2,X
       DECA
       BNE    DEPILE
       BRA    ENDPIL
REGSEL PSHS   D         ce registre est
       LDD    ,X          sélectionné
       CMPA   #32
       BEQ    *+4
       STA    ,U+     on copie son nom
       STB    ,U+
       LDA    #',
       STA    ,U+
       PULS   D,PC
PILREG FCC    "PC U Y XDP B ACC"


INSTR  LDB    ,Y+     décode instruction
       CMPB   #$10    et renvoie le code
       BNE    INSTR2   opérande dans A.
       STB    <OPCODE opcode complexe 10
       LDX    #MNEMO2
       BRA    CMPLEX
INSTR2 CMPB   #$11
       BNE    INSTR3
       STB    <OPCODE opcode complexe 11
       LDX    #MNEMO3
CMPLEX LDB    ,Y+
       BSR    FNDCOD
       BPL    *+4
       LEAY   -1,Y    A=-1: code inconnu
       RTS
INSTR3 LDX    #MNEMO1 opcode simple (1o)
       CLR    <OPCODE
FNDCOD STB    <OPCODE+1 trouve txt+infos
FNDTXT LDD    ,X++     correspondant à
       CMPD   #$3F3F  l'opcode cherché.
       BNE    PAFIN1
       STD    ,U++    code inconnu (??)
       LDA    #-1
       RTS
PAFIN1 CMPA   <OPCODE+1 trouvé l'opcode?
       BNE    FNDTXT
       CMPB   #$1F    c'est un vrai ?
       BHI    FNDTXT  non:c'est du texte
       STB    <ADRMOD
       LDD    ,X++      on saute les
       CMPB   #$1F    autres adressages
       BLO    *-4     de la Mnémonique.
       LEAX   -2,X
       LDD    ,X++      copie du texte
       STD    ,U++
       LDD    ,X++
       STD    ,U++
       LDA    <OPCODE+1
       CMPA   #$1C    l'exception: ANDCC
       BNE    *+4
       STB    ,U+
       LDA    <ADRMOD
       RTS
