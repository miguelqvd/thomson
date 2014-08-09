****************************************
*                                      *
* Modification Budget famillial        *
*                                      *
*   - arret page accueil par clic      *
*   - arret par STOP au menu           *
*   - archivage disquettes au lieu     *
*     cassette                         *
*                                      *
****************************************

PUTC   EQU    $E803
GETC   EQU    $E806
LPIN   EQU    $E81B
MENU   EQU    $E82D
COMSLO EQU    $EC03
EXTRA  EQU    $EC0C

FILNAM EQU    $624F

DOSBUF EQU    $6300
DOSFAT EQU    $6300+256
DOSFCB EQU    $6300+256+(5*166)
ZONE   EQU    $6300+256+(5*166)+283

MESS   EQU    $B96

MENUB  EQU    $6B

       ORG    $10
       FCB    $04
       LDX    #$0059
       JMP    >$0023

       ORG    $1A
       FCB    $1B

       ORG    $1D
       FCB    $11

       ORG    $65
       JSR    XINTRO
       JMP    >$6B

       ORG    $74
       JSR    XMENU

       ORG    $77
       JSR    XCHOIX
       JMP    >$82

       ORG    $1E7
       JMP    CZIDR

       ORG    $2EF
       JMP    OUINO1

       ORG    $31D
       JMP    OUINO2

       ORG    $771
       JMP    XARCHI

       ORG    $77E
       JMP    XCHARG

       ORG    $855
       JMP    OUINO3

       ORG    $D89
       JMP    OUINO4

       ORG    $13A5
       FCB    $20

       ORG    $13B3
       FCC    \HMEL93\

       ORG    $1538
       FCB    $04

       ORG    $1D56
       FCB    $1B,$46,$1B,$50,$1B,$4F
       FCB    $0C,$1F,$43,$47
       FCC    \*ARCHIVAGE*\
       FCB    $1B,$4C,$04

       ORG    $1D80
       FCB    $1B,$46,$1B,$50,$1B,$4F
       FCB    $0C,$1F,$43,$47
       FCC    \*CHARGEMENT*\
       FCB    $1B,$4C,$04

       ORG    $2000
MCHOIX FCB    $1B,$4C,$1F,$57,$4F
       FCC    \VOTRECHOIX(ouSTOP)?\
       FCB    $11,$04

MSTOP  FCB    $1B,$4C,$1F,$57,$4F
       FCC    \ConfirmerSTOP(O/N)?\
       FCB    $11,$04

MPSELD FCB    $1F,$46,$4F,$04

MPCZI  FCB    $1F,$4A,$45,$04

MPDIRR FCB    $1F,$47,$45,$04

MFEX1  FCC    \Effacement\
       FCB    $04

MFEX2  FCC    \(O/N)?\
       FCB    $04

FILMEM FCC    \\

*=======================================

XINTRO JSR    GETC
       TSTB
       BNE    FINTRO  ->
       JSR    LPIN
       BCC    XINTRO  ->

*=======================================

FINTRO CLR    $E7E4
       LDA    $E7E6     autorise écritur
       ORA    #$40      cartouche
       STA    $E7E6

       LDX    #FILMEM
       LDD    #$2020
       STD    ,X++
       STD    ,X++
       STD    ,X++
       STD    ,X++
       RTS

*=======================================

XMENU  JSR    MESS
       LDX    #MCHOIX
       JMP    MESS    ->>

*=======================================

XCHOIX JSR    GETC
       CMPB   #2
       BEQ    XSTOP   ->
       CMPB   #'1
       BLO    XCHOIX  ->
       CMPB   #'9
       BHI    XCHOIX  ->
       RTS            ->>

*=======================================

XSTOP  LDX    #MSTOP
       JSR    MESS
XSTOPC JSR    GETC
       CMPB   #'N
       BEQ    NSTOP   ->
       CMPB   #'n
       BEQ    NSTOP   ->
       CMPB   #'O
       BEQ    OSTOP   ->
       CMPB   #'o
       BEQ    OSTOP   ->
       BRA    XSTOPC  ->
NSTOP  LDX    #MCHOIX
       JSR    MESS
       BRA    XCHOIX  ->
OSTOP  JMP    MENU    --->>>>

*=======================================

OUINO1 ANDB   #$DF
       CMPB   #'N
       LBEQ   $2F7    ->
       CMPB   #'O
       LBEQ   $2FC    ->
       LBRA   $2EC    ->

*=======================================

OUINO2 ANDB   #$DF
       CMPB   #'N
       LBEQ   $325    ->
       CMPB   #'O
       LBEQ   $325    ->
       LBRA   $315    ->

*=======================================

OUINO3 ANDB   #$DF
       CMPB   #'N
       LBEQ   $7FD    ->
       CMPB   #'O
       LBEQ   $85D    ->
       LBRA   $850    ->

*=======================================

OUINO4 ANDB   #$DF
       CMPB   #'N
       LBEQ   $D94    ->
       CMPB   #'O
       LBEQ   $D91    ->
       LBRA   $D86    ->

*=======================================

CZIDR  ANDB   #$DF
       CMPB   #'D
       LBEQ   $1FD    ->
       CMPB   #'R
       LBEQ   $1FD    ->
       LBRA   $209    ->

*=======================================

XARCHI EQU    *
       LDX    <$02
       LDY    #$A000
COPZO1 LDA    ,X+
       STA    ,Y+
       CMPX   #$6C35
       BNE    COPZO1  ->

       JSR    XEXTRA

       LDX    #$1D56
       JSR    MESS

       LDX    #MPSELD
       JSR    MESS

XARCHB LDX    #ZONE
       LDY    #100
       LDA    #3
       LDU    #$3FC7
       JSR    COMSLO

       LDX    #MPCZI
       JSR    MESS

       LDX    #FILMEM
       LDY    #FILNAM
       LDB    #8
BCPN1  LDA    ,X+
       STA    ,Y+
       DECB
       BNE    BCPN1     ->

       LDX    #FILNAM+8
       LDA    #'B
       STA    ,X+
       LDA    #'U
       STA    ,X+
       LDA    #'D
       STA    ,X+
       CLR    ,X

       LDX    #ZONE
       LDY    #100
       LDA    #3
       LDU    #$3FC4
       JSR    COMSLO
       TSTB
       BNE    ARCHF   abandon ->

       JSR    CNFNEX
       CMPB   #'N
       BEQ    XARCHB  fichier existe ->

       LDA    #$20    open output
       STA    $624B
       LDA    #3
       STA    $624C
       CLR    $624D
       LDB    #3
       JSR    EXTRA
       TSTB
       LBNE   ERRF0   ->

       LDX    #$A000  put
BARCHI LDA    ,X
       LDB    #4
       JSR    EXTRA
       TSTB
       LBNE   ERRF00  ->

       LEAX   1,X
       CMPX   #$A835
       BNE    BARCHI  ->

       LDB    #6      close
       JSR    EXTRA

ARCHF  JSR    FEXTRA
       JMP    >MENUB

*=======================================

XCHARG JSR    XEXTRA

       LDX    #$1D80
       JSR    MESS

       LDX    #MPSELD
       JSR    MESS

       LDX    #ZONE
       LDY    #100
       LDA    #3
       LDU    #$3FC7
       JSR    COMSLO

       LDX    #MPDIRR
       JSR    MESS

       LDX    #FILNAM
       LDD    #$0000
       STD    ,X++
       STD    ,X++
       STD    ,X++
       STD    ,X++
       LDA    #'B
       STA    ,X+
       LDA    #'U
       STA    ,X+
       LDA    #'D
       STA    ,X+

       LDX    #ZONE
       LDY    #1700
       LDA    #3
       LDU    #$3FC1
       JSR    COMSLO    DIRR
       CMPB   #62
       LBEQ   FCHARG    ->
       TSTB
       BNE    ERRF0     ->

       LDX    #FILNAM
       LDY    #FILMEM
       LDB    #8
BCPN2  LDA    ,X+
       STA    ,Y+
       DECB
       BNE    BCPN2     ->

       LDA    #$10    open input
       STA    $624B
       LDB    #3
       JSR    EXTRA
       TSTB
       BNE    ERRF0   ->

       LDX    #$A000
BCHARG LDB    #5      input
       JSR    EXTRA
       TSTB
       BNE    ERRF00  ->
       TST    $6178
       BNE    FCHAR0  ->
       LDA    $6196
       STA    ,X+
       CMPX   #$A835
       BNE    BCHARG  ->

FCHAR0 LDB    #6      close
       JSR    EXTRA

       JSR    FEXTRA

       LDX    <$02
       LDY    #$A000
COPZO2 LDA    ,Y+
       STA    ,X+
       CMPX   #$6C35
       BNE    COPZO2  ->

       JMP    >MENUB    ->

ERRF00 PSHS   B
       LDB    #6      close
       JSR    EXTRA
       PULS   B
ERRF0  EQU    *
       JSR    DOSERR
FCHARG JSR    FEXTRA
       JMP    >MENUB

*=======================================

CNFNEX EQU    *
       LDA    #$10    essai open input
       STA    $624B
       LDB    #3
       JSR    EXTRA
       TSTB
       BEQ    CNFSUP  ->
       LDB    #'O     non existe
       BRA    OCNFSU  ->

CNFSUP LDB    #6      close
       JSR    EXTRA

       JSR    BOITE

       LDX    #MFEX1
       JSR    MESS

       LDX    #FILNAM
       LDA    FILNAM+8
       PSHS   A
       LDA    #4
       STA    FILNAM+8
       JSR    MESS
       PULS   A
       STA    FILNAM+8

       LDB    #'.
       JSR    PUTC

       LDX    #FILNAM+8
       LDA    FILNAM+11
       PSHS   A
       LDA    #4
       STA    FILNAM+11
       JSR    MESS
       PULS   A
       STA    FILNAM+11

       LDX    #MFEX2
       JSR    MESS

XCNFSU JSR    GETC
       ANDB   #$DF
       CMPB   #'N
       BEQ    OCNFSU  ->
       CMPB   #'O
       BNE    XCNFSU  ->
       JSR    PUTC

       LDB    #14     kill
       JSR    EXTRA
OCNFSU RTS

*=======================================

DOSERR EQU    *
       JSR    BOITE

       TFR    B,A
       LDX    #ZONE
       LDB    #20
       JSR    EXTRA   ERRMSG

DOER0  LDB    ,X+
       BEQ    DOER1   ->
       JSR    PUTC
       BRA    DOER0   ->

DOER1  JSR    GETC
       TSTB
       BNE    DOER2   ->
       JSR    LPIN
       BCC    DOER1   ->
DOER2  RTS

*=======================================

BOITE  EQU    *
       PSHS   D,X,Y,U
       LDX    #0
       STX    $61A1
       LDX    #319
       LDY    #8*11
       STY    $61A3
       LDY    #8*14
       LDA    #$FF
       STA    $61EF
       LDU    #ZONE
       LDD    #0
       STD    ,U++
       STD    ,U++
       STD    ,U++
       STD    ,U++
       STU    $627D
       LDB    #27
       JSR    EXTRA   BOX

       LDB    #$1F
       JSR    PUTC
       LDB    #$40+12
       JSR    PUTC
       LDB    #$41+1
       JSR    PUTC
       PULS   D,X,Y,U,PC

*=======================================

XEXTRA LDX    #$6100
       LDY    #SAUVP0
BSAUV  LDD    ,X++
       STD    ,Y++
       CMPX   #$7000
       BNE    BSAUV   ->

       CLRB             reset extra
       JSR    EXTRA

       LDD    #0
       STD    $61A5
       STD    $61A7
       LDD    #319
       STD    $61A9
       LDD    #199
       STD    $61AB

       CLR    $61A0
       CLR    $6041
       LDA    #7
       STA    $619F
       CLR    $6288
       LDB    #28
       JSR    EXTRA     CHOIX

       LDD    #DOSBUF
       STD    $6197
       LDD    #DOSFAT
       STD    $6199
       LDX    #DOSFCB
       LDA    #1
       LDY    #5
       LDB    #2
       JSR    EXTRA     FCBINI
       RTS

*=======================================

FEXTRA LDX    #$6100
       LDY    #SAUVP0
BREST  LDD    ,Y++
       STD    ,X++
       CMPX   #$7000
       BNE    BREST   ->
       RTS

SAUVP0 EQU    *
       END
