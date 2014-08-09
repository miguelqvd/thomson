* CC++ PAR MICHEL SAINT-BRIANT
* Pour copie de disquettes TO

RETOUR EQU    $6AF9   (=X% EN BASIC 512)
ORIGIN EQU    $6ABA   (=O% EN BASIC 512)
DESTIN EQU    $6A6D   (=D% EN BASIC 512)
PISTE  EQU    $6AC1   (=P% EN BASIC 512)

       ORG    $8000

*VERIFIER DISK-ORIGIN. PROTEGE
*un EXEC analyse la disquette dans le
*lecteur ORIGIN (O% sous BASIC512) et
*retourne dans la variable X% l'état du
*lecteur:
*         X%=0 -> OK=disquette protégée
*         X%=255 -> disquette non prot.
*         X%=254 -> lecteur vide.

VERPRO PSHS   A,B,DP,CC,X,Y,U
       CLR    RETOUR
       LDA    ORIGIN
       STA    >$6049
       JSR    $E09D
       JSR    $E0A7
       JSR    $E452
       BCS    NOPRET
       LDA    1,X
       BITA   #$04
       BNE    FINVER
       BRA    INCORR

*VERIFIER DISK-DESTIN. NON PROTEGE
*un EXEC analyse la disquette dans le
*lecteur DESTIN (D% sous BASIC512) et
*retourne dans la variable X% l'état du
*lecteur:
*         X%=0 -> OK=disq. non protégée
*         X%=255 -> disquette protégée.
*         X%=254 -> lecteur vide.

VERNON PSHS   A,B,DP,CC,X,Y,U
       CLR    RETOUR
       LDA    DESTIN
       STA    >$6049
       JSR    $E09D
       JSR    $E0A7
       JSR    $E452
       BCS    NOPRET
       LDA    1,X
       BITA   #$04
       BEQ    FINVER
INCORR DEC    RETOUR
FINVER LDA    #$40
       STA    2,X
       CLR    ,X
       PULS   A,B,DP,CC,X,Y,U,PC

NOPRET LDA    #254
       STA    RETOUR
       BRA    FINVER

* COPIE D'UNE PISTE EN ABSOLUE FIDELITE
* Lit la piste P% du lecteur O% et
* stocke le résultat dans la banque
* courante depuis $A200 et restructure
* les signaux.

AF     PSHS   A,B,DP,CC,X,Y,U
       JSR    $E09D
       LDA    #2
       LDB    ORIGIN
       STD    <$48
       LDA    PISTE   PISTE=P (P%)
       STA    <$4B
       JSR    $E0A7
       JSR    $E452
       JSR    $E341
       LDB    #$1B
       JSR    $E394
       LDD    #$E718
       TFR    A,DP
       STB    <$D0
       LDA    >$6057
       ORA    #4
       STA    <$D2
       LDX    #$A000
       LDU    #$FFFF
       LDA    #0
PREPA  STU    ,X++
       DECA
       BNE    PREPA
       LDA    #$40
ATTL0  BITA   <$D1
       BEQ    ATTL0
ATTL1  BITA   <$D1
       BNE    ATTL1
       LDA    <$D3
ATTL3  LDB    <$D0
       BPL    ATTL3
       LDA    <$D3
       ANDB   #1
       STD    ,X++
       LDA    <$D1
       BITA   #$40
       BEQ    ATTL3
       CLR    <$D0
       LDA    #$40
       STA    <$D2
       LDA    #$FE
       STA    1,X

* ON MET A 4E LES PREMIERS OCTETS

       LDY    #$A200
       LDA    #$4E
PREM1  LDB    1,Y
       BNE    POSE
       STA    ,Y++
       BRA    PREM1

* ON POSE DES CODES FE POUR STOPPER

POSE   LDB    #$FE
       STB    1,X
       LEAX   1,X
STOP   LDA    ,--X
       BMI    FINLIR
       BEQ    STOP
       LEAX   1,X
       STB    7,X
       STB    9,X
       STB    11,X
       STB    13,X
       STB    15,X

* ON RESTITUE LES CODES A1 (+ LES 00) EN
* RECTIFIANT LE NOMBRE DE CODES A1 POUR
* LES SYNCHROS (3 POUR TO8/8D/9+ ET 2
* SEULEMENT POUR LES ATARI ST ET PC720K)


REST0  LEAX   1,X
REST1  LDA    ,--X
       BMI    FINLIR
       BEQ    REST1
       LEAX   1,X
       LDA    #3      <---- nombre de A1
       LDU    #$A10A
REST2  STU    ,--X
       DECA
       BNE    REST2
       LDU    #$0000
       LDA    #$0C
REST3  STU    ,--X
       DECA
       BNE    REST3
       BRA    REST0

FINLIR PULS   A,B,CC,DP,X,Y,U,PC

* ON ECRIT LA PISTE RESTRUCTUREE
* sur piste P% du lecteur D% depuis la
* banque courante ($A200 ...)

       PSHS   A,B,CC,DP,X,Y,U
       JSR    $E09D
       LDA    #$40
       LDB    DESTIN
       STD    <$48
       LDA    PISTE
       STA    <$4B
       JSR    $E004
       CLR    <$48
       JSR    $E0A7
       JSR    $E45A
       LDB    #$18
       JSR    $E394
       JSR    $E341
       LDA    #$E7
       TFR    A,DP
ATTI0  LDA    <$D3
       LDA    <$D0
       BPL    ATTI0
ATTI1  LDA    <$D0
       BPL    ATTI1
       LDD    #0
       STD    <$D3
       LDD    #$4004
       STB    <$D0
INDEX0 BITA   <$D1
       BEQ    INDEX0
INDEX1 BITA   <$D1
       BNE    INDEX1
       LDX    #$A200
ATTE0  LDA    <$D3
       LDA    <$D0
       BPL    ATTE0
ATTE1  LDA    <$D0
       BPL    ATTE1
       LDD    #$4EFF
       STD    <$D3
       LDB    #$04
       STB    <$D0
ATTE2  LDB    <$D0
       BPL    ATTE2
       LDD    ,X++
       TSTB
       BMI    FINI
       BNE    DEBSIG  DEBUT DE SIGNAL
       STA    <$D3
       BRA    ATTE2
DEBSIG STD    <$D3
ATTE3  LDB    <$D0
       BPL    ATTE3
       LDD    ,X++
       TSTB
       BMI    FINI
       BEQ    FINSIG
       STA    <$D3
       BRA    ATTE3
FINSIG LDB    #$FF
       STD    <$D3
       BRA    ATTE2
FINI   STA    <$D3
ATTE4  LDD    <$D0
       BPL    ATTE4
       LDA    ,X++
       STA    <$D3
       BITB   #$40
       BEQ    ATTE4
       CLR    <$D0
       LDA    #$40
       STA    <$D2
       PULS   A,B,DP,CC,X,Y,U,PC

* COPIE D'UNE PISTE EN FIDELITE NORMALE
* copie du type BACKUP sans formatage.
* depuis lecteur O% vers lecteur D% pour
* la piste P% ;en retour on peut lire X%
*       X%=0    Tout est OK
*       X%=255  Lecture impossible
*       X%=254  Ecriture impossible

FN     PSHS   A,B,DP,CC,X,Y,U
       CLR    RETOUR
       LDA    #$60
       TFR    A,DP
       LDA    ORIGIN
       STA    <$49
       LDA    PISTE
       STA    <$4B
       LDX    #$A000
       STX    <$4F
C1010  LDA    #1
       STA    <$4C
C1020  LDA    #2      <-nbre de tentati-
       STA    FOIS     \ves de lecture.
C1030  LDA    #2
       STA    <$48
       JSR    $E004
       BCC    C1040
       DEC    FOIS
       BNE    C1030
       COM    RETOUR
       BRA    FINFN
C1040  INC    <$4F
       LDA    <$4C
       ADDA   #5      <-un facteur de 5
       CMPA   #16      \pour un entre-
       BLS    C1050     lacement de 7.
       SUBA   #16
C1050  STA    <$4C
       CMPA   #1
       BNE    C1020
       LDA    DESTIN
       STA    <$49
       LDX    #$A000
       STX    <$4F
C2010  LDA    #1
       STA    <$4C
C2020  LDA    #2      <-nbre de tentati-
       STA    FOIS     \ves d'écriture
C2030  LDA    #8
       STA    <$48
       JSR    $E004
       BCC    C2040
       DEC    FOIS
       BNE    C2030
       LDA    #254
       STA    RETOUR
       BRA    FINFN
C2040  INC    <$4F
       LDA    <$4C
       ADDA   #5      <-facteur de 5
       CMPA   #16
       BLS    C2050
       SUBA   #16
C2050  STA    <$4C
       CMPA   #1
       BNE    C2020
FINFN  PULS   A,B,DP,CC,X,Y,U,PC

FOIS   FCB    0

       END
