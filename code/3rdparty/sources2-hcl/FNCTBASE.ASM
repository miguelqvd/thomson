FNCKIZ CMPB   #$90
       BLO    EOFKIZ+1
       CMPB   #$99
       BHI    EOFKIZ+1
       LDU    #F1F5BF
       ASLB
       ASLB
       ASLB
       ASLB
       CMPB   #$50
       BLO    FKMTOY
       SUBB   #$50
       LEAU   B,U
       TFR    Y,D
       BSR    ATOHEX
       TFR    B,A
       BSR    ATOHEX
       CLR    ,U
EOFKIZ CLRB
       LDA    #1
       RTS
FKMTOY LEAU   B,U
       LDA    ,U
       BEQ    EOFKIZ
       CLRA
CHKFKI LDB    ,U+
       BEQ    FMK2Y2
       JSR    CHKHEX
       BEQ    EOFKIZ
       INCA
       CMPA   #5      5ème digit <> 0 ?
       BEQ    EOFKIZ
       BRA    CHKFKI
FMK2Y2 LDX    #FMKRET "empile" PC,X et B
       PSHS   X,DP,B,A
       LEAU   -1,U
       JMP    VALHEX
FMKRET LEAY   ,U
       CLRB
       RTS

BB2DEC CLRA
       ASLB
       BCC    *+3
       INCA
DTODEC PSHS   X,D
       LDD    #0
       LDX    ,S
       CMPX   #100
       BLO    *+8
       LEAX   -100,X
       INCB
       BRA    *-9
       TSTB
       BNE    *+6
       LDB    #32
       BRA    *+5
       ADDB   #'0
       DECA
       STB    ,U+
       CLRB
       CMPX   #10
       BLO    *+7
       LEAX   -10,X
       INCB
       BRA    *-8
       TSTB
       BNE    *+9
       TSTA
       BNE    *+6
       LDB    #32
       BRA    *+4
       ADDB   #'0
       STB    ,U+
       TFR    X,D
       ADDB   #'0
       STB    ,U+
       PULS   D,X,PC

ATOHEX PSHS   X,A       convertit A
       LDX    #HEXA   en hexa et met le
       LSRA             résultat dans
       LSRA           la ligne courante.
       LSRA            (pointée par U)
       LSRA
       LDA    A,X
       STA    ,U+
       PULS   A
       ANDA   #15
       LDA    A,X
       STA    ,U+
       PULS   X,PC
HEXA   FCC    "0123456789ABCDEF"

DA2HEX PSHS   X,B,A     convertit A
       LDX    #HEXA   en hexa et affiche
       LSRA             le résultat à
       LSRA               l'écran
       LSRA
       LSRA
       LDB    A,X
       BSR    PUTC
       LDA    ,S
       ANDA   #15
       LDB    A,X
       BSR    PUTC
       PULS   A,B,X,PC

PUTC   PSHS   U,X,D
       CMPB   #32      CHR$ affichable ?
       BGE    *+4
       LDB    #'.
       LDX    <CURSOR position courante
       CMPX   <BOTTOM est trop en bas ?
       BLO    FSCROL
       PSHS   X,Y,B   monte écran d'1 lg
       STS    POPS+2
       LDS    #$4000+320     source
       LDU    #$4006       destination
SCROLL PULS   X,Y,D   segment 1
       PSHU   D,Y,X
       LEAU   12,U
       PULS   X,Y,D   segment 2
       PSHU   D,Y,X
       LEAU   12,U
       PULS   X,Y,D   segment 3
       PSHU   D,Y,X
       LEAU   12,U
       PULS   X,Y,D   segment 4
       PSHU   D,Y,X
       LEAU   12,U
       PULS   X,Y,D   segment 5
       PSHU   D,Y,X
       LEAU   12,U
       PULS   X,Y,D   segment 6
       PSHU   D,Y,X
       LEAU   10,U
       PULS   X,Y     segment +
       PSHU   Y,X
       LEAU   10,U
       CMPU   #$4006+184*40 bas fenêtre?
       BLO    SCROLL
POPS   LDS    #0      récupère la pile
       PULS   B,Y,X
       LEAX   -320,X
FSCROL LDU    #FONTS  cherche le dessin
       LDA    #8       du caractère B
       SUBB   #32
       MUL
       LEAU   D,U
       PULU   D       lignes 6 et 7
       STA    160,X
       STB    120,X
       PULU   D       lignes 4 et 5
       STA    80,X
       STB    40,X
       PULU   D       lignes 2 et 3
       STA    ,X+
       STB    -41,X
       PULU   D       lignes 0 et 1
       STA    -81,X
       STB    -121,X
       LDA    <XPOS   nouvelle abscisse
       INCA
       CMPA   #40
       BLO    *+7
       CLRA           et position écran
       LEAX   280,X     le curseur
       STA    <XPOS
       STX    <CURSOR nouvelle position
       LDA    <CLIGNO
       BEQ    EOPUTC
       STA    160,X
       STA    120,X
       STA    80,X
       STA    40,X
       STA    ,X
       STA    -40,X
       STA    -80,X
       STA    -120,X
EOPUTC PULS   D,X,U,PC    à l'écran


IPIHEX LDX    #CHKHEX
       STX    <INPCHK
       LDX    #VALHEX
       STX    <INPVAL
       TSTA
       RTS

DIPUT4 LEAU   ,Y
DIPUT3 LDB    ,U+
       JSR    PUTC
       CMPB   #':
       BNE    DIPUT3
       LDB    ,U+
       JSR    PUTC
       LEAY   A,U
       BRA    INPUT
DIPUT2 LEAU   ,Y
DINPUT LDB    ,U+
       JSR    PUTC
       CMPB   #'$
       BNE    DINPUT
       LEAY   A,U
INPUT  PSHS   X,B
       STA    <NBDGIT sauve nbre digits
       LDX    <CURSOR
       CLRA
IPKEYB JSR    GETC
       CMPB   #30     flèche Recommence
       BEQ    *+6
       CMPB   #8       flèche Backspace
       BNE    IP1
IPDEL  TSTA           déjà au début !
       BEQ    IPKEYB
       PSHS   A,B
       LDX    <CURSOR
       LEAX   -1,X     recule d'un car
       DEC    <XPOS
       LDD    #$FF00  et affiche curseur
       STD    160,X
       STD    120,X
       STD    80,X
       STD    40,X
       STD    ,X
       STD    -40,X
       STD    -80,X
       STD    -120,X
       PULS   B,A
       DECA
       CLR    ,-U
       STX    <CURSOR
       CMPB   #30
       BNE    IPKEYB
       BRA    IPDEL
IP1    CMPB   #2      touche Stop
       BNE    IP2
       CMPA   <NBDGIT
       BHS    *+4
       CLR    ,U      saisie interrompue
       CLRA
       PULS   X,B,PC
IP2    CMPB   #13     touche Entrée
       BNE    IP3
       TSTA           rien du tout entré
       BEQ    IPKEYB    non valide !
       CMPA   <NBDGIT
       BEQ    *+4
       CLR    ,U
       STA    <NBDGRL
       JMP    [DIR*256+INPVAL]
IP3    CMPB   #11      touche historique
       BNE    IP4
       TSTA
       BNE    IPKEYB
IPROPO LDB    ,U      affiche la valeur
       BEQ    IPKEYB     par défaut
       JSR    PUTC    (i.e: l'ancienne)
       LEAU   1,U
       INCA
       CMPA   <NBDGIT
       BNE    IPROPO
       BRA    IPKEYB
IP4    CMPB   #$90    touches fonctions
       BLO    IP5
       CMPB   #$99
       BHI    IP5
       LDX    #F1F5BF
       ASLB
       ASLB
       ASLB
       ASLB
       CMPB   #$40
       BHI    MEMOFK
       TSTA
       LBNE   IPKEYB
       ABX
AFFFKM LDB    ,X+     restitue mémoire
       JSR    [DIR*256+INPCHK]
       LBEQ   IPKEYB
       STB    ,U
       JSR    PUTC
       LEAU   1,U
       INCA
       CMPA   <NBDGIT
       BNE    AFFFKM
       JMP    IPKEYB
MEMOFK SUBB   #$50
       ABX
       LEAX   A,X
       CMPA   #16
       BEQ    *+4
       CLR    ,X
       TSTA
       BEQ    IP5-3
       PSHS   U,A
MEMFKM LDB    ,-U
       STB    ,-X
       DECA
       BNE    MEMFKM
       PULS   A,U
       JMP    IPKEYB
IP5    JSR    [DIR*256+INPCHK]
       LBEQ   IPKEYB  non affichable
       CMPA   <NBDGIT au bout à droite ?
       BLO    IPECHO    pas encore...
       LEAU   -1,U
       LDX    <CURSOR
       LEAX   -1,X
       STX    <CURSOR
       DEC    <XPOS    précompensation
       DECA
IPECHO STB    ,U+
       JSR    PUTC
       INCA
       JMP    IPKEYB

CHKSOP TSTA
       BNE    *+8
       CMPB   #'"
       BNE    CHKHEX
       TSTB
       RTS
       PSHS   D
       TFR    A,B
       NEGB
       SEX
       LDA    D,U
       CMPA   #'"
       PULS   D
       BEQ    CHKASC

CHKHEX CMPB   #$60    lettre minuscule ?
       BLO    *+4
       ANDB   #$DF
       CMPB   #'0     valeur hexa ?
       BLO    NCHKHX
       CMPB   #'F
       BHI    NCHKHX
       CMPB   #':
       BLO    *+7
       CMPB   #'@
       BHI    *+3
NCHKHX CLRB           NO: non hexa
       TSTB           YES: affichable
       RTS

CHKASC CMPB   #32     caractère ASCII ?
       BLO    *+6
       CMPB   #128
       BLO    *+3
       CLRB
       TSTB
       RTS

CHKMOD CMPB   #'0     mode d'affichage ?
       BLO    *+6
       CMPB   #'5
       BLO    *+3
       CLRB
       TSTB
       RTS

CHKBOL CMPB   #'0     chiffre booléen ?
       BLO    *+6
       CMPB   #'2
       BLO    *+3
       CLRB
       TSTB
       RTS

CHKFIL CMPB   #32      lettre pouvant
       BLO    NCHKFI  figurer dans le
       CMPB   #127    nom d'un fichier
       BHI    NCHKFI
       CMPB   #':
       BEQ    NCHKFI
       CMPB   #'.
       BEQ    NCHKFI
       CMPB   #'(
       BEQ    NCHKFI
       CMPB   #')
       BEQ    NCHKFI
       CMPB   #'"
       BNE    *+3
NCHKFI CLRB
       RTS

CHKFTY ANDB   #$DF    minus -> majuscule
       CMPB   #'B     BASIC
       BEQ    FTYPOK
       CMPB   #'D     DATAS
       BEQ    FTYPOK
       CMPB   #'M     MACHINE
       BEQ    FTYPOK
       CMPB   #'A     ASSEMBLY
       BEQ    FTYPOK
       CLRB
FTYPOK TSTB
       RTS

CHKDTY ANDB   #$DF    minus -> majuscule
       CMPB   #'A     ASCII
       BEQ    DTYPOK
       CMPB   #'B     BINARY
       BEQ    DTYPOK
       CLRB
DTYPOK TSTB
       RTS

VALFTY LDX    #FTYPSL
       LDA    #$FF
       LDB    ,-U
       INCA
       CMPB   ,X+
       BNE    *-3
       STA    ,S
       LDA    #-1
       PULS   B,X,PC
FTYPSL FCC    "BDMA"


VALDTY LDB    ,-U     la valeur est à
       SUBB   #'B     lire dans B !!!
       STB    ,S      $FF=ASCII;0=Binary
       LDA    #-1     code retour = OK
       PULS   B,X,PC


VALREG PSHS   A,X,U,Y
       CMPA   #1      une seule lettre ?
       BHI    *+6
       LDB    #32     1ère lettre=espace
       BRA    *+4
       LDB    ,-U     registre sur 2 CHR
       LDA    ,-U
       CMPB   #32     1 lettre+1 espace?
       BNE    *+4
       EXG    A,B
       TFR    D,X
       LDU    #LRGEQU
       LDY    #DIR*256+REGIST-2 où modif
RGEFND CMPX   ,U++    cherche registre
       BNE    *+8        sollicité
       LEAS   7,S     "dépile" A,X,U,Y
       LDA    #-1     code retour=OK
       PULS   B,X,PC
       LDB    ,U+     code de longueur
       SEX
       LEAY   D,Y
       CMPU   #REGTXT
       BLO    RGEFND
       PULS   A,X,U,Y
       JMP    IPKEYB

VALZAP PSHS   U,A
       LDX    #ZAPRET "empile" PC,X et B
       PSHS   X,DP,B,A
       JMP    VALHEX
ZAPRET CMPU   #$5FEC
       BLO    BADZAP
       CMPU   #$DFFF
       BHI    BADZAP
       LEAS   3,S     "dépile" A,U
       PULS   B,X,PC
BADZAP PULS   A,U
       JMP    IPKEYB

VALBNK CMPA   #1
       BEQ    VALHEX
       LDB    -2,U    si No Bank >= $20
       CMPB   #'2     c'est inacceptable
       BLO    VALHEX
       JMP    IPKEYB

VALSOP PSHS   D
       TFR    A,B
       NEGB
       SEX
       LDA    D,U
       CMPA   #'"
       PULS   D
       BNE    VALHXP
       DECA
       LBEQ   IPKEYB
       DEC    <NBDGRL
       CLR    ,S      B=0 -> VALchaîne "

VALASC LDB    ,-U     U doit pointer le
       DECA           début de chaîne
       BNE    *-3
       LDA    <NBDGRL code retour=OK
       PULS   B,X,PC

VALHXP BITA   #1      nb digits pair ?
       LBNE   IPKEYB  non: inacceptable!

VALHEX LDX    #HWINDW
       CLR    -2,X    conver ASCII->hexa
       LDB    ,-U     de droite à gauche
       SUBB   #'0
       CMPB   #10
       BLO    *+4
       SUBB   #7
       STB    ,-X     poids faible
       DECA
       BEQ    EOINPT
       LDB    ,-U     de droite à gauche
       SUBB   #'0
       CMPB   #10
       BLO    *+4
       SUBB   #7
       ASLB
       ASLB
       ASLB
       ASLB
       ADDB   ,X
       STB    ,X      poids fort
       DECA
       BNE    VALHEX+5
EOINPT LDA    <NBDGIT
       CMPA   #4      saisie longue ?
       BHI    *+7
       LDU    HWINDW-2   non:U=valeur
       BRA    *+4
       LEAU   ,X        oui:U=&(valeur)
       LDA    <NBDGRL   (CC): Z = 0
       PULS   X,B,PC  code retour: A>0
        *             buffer calcul val.
       FDB    0,0,0,0,0,0,0,0
HWINDW CLR    <CLIGNO ne pas séparer !!!
       LDB    #32
       JSR    PUTC
       LDX    <WRKCSR  active la fenêtre
       STX    <CURSOR     supérieure
       LDX    #SCREEN+24*320
       STX    <BOTTOM
       CLR    <XPOS
       TSTA
       RTS
