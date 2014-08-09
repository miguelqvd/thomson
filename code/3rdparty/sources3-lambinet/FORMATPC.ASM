*** exemple de dérivation d'un programme
*** ressourcé avec CODEVIEW3

*** FORMATAGE PHYSIQUE D'UNE DISQUETTE
*** AU STANDARD PC (80 PISTES DE 2 FACES
*** DE 9 SECTEURS DE 512 OCTETS

*** MICHEL SAINT-BRIANT  (ASCI 1992)

* les BSR et LBSR ont été remplacés par
* des JSR (absolu) et quelques modifica-
* tions mineures ont été apportées.

       ORG    $8000

       PSHS   U,Y,X,DP,B,A,CC
       JSR    $E09D
       CLR    <$49
       JSR    $E0A7
       JSR    $E45A
       LBCS   P0060
       JSR    $E134
       LBCS   P0060
       CLR    <$4B    piste 0
       JSR    $E521
       LBCS   P0060
P0000  CLR    <$49    face 0
       BRA    P0020
P0010  LDA    #$01    face 1
       STA    <$49
P0020  JSR    $E0A7
       JSR    $E45A
       PSHS   CC
       ORCC   #$50
       LBSR   P0080
       LDA    #$02
       PSHS   A
P0030  LBSR   P0140
       LDX    #$E7D0
       JSR    $E45A
       LBSR   P0200
       BCC    P0040
       DEC    ,S
       BNE    P0030
       PULS   A
       PULS   CC
       COMA
       BRA    P0060
P0040  PULS   A
       PULS   CC
       TST    <$49
       BEQ    P0010
       LDA    <$4B    est-ce la dernière
       CMPA   #$4F    \piste?
       BEQ    P0050
       BSR    P0070
       BRA    P0000
P0050  LDA    #$50
       STA    <$4B
P0060  JMP    $E08A   sortie du DOS
P0070  INC    <$4B    piste=piste+1
       JMP    $E47A
P0080  LDX    #$60D3  on bufférise les
       LDB    #$09    9 secteurs en
P0090  CLR    B,X     prenant un entre-
       DECB           lacement de 1 (pc)
       BNE    P0090
       LEAX   9,X
       PSHS   X
       LDX    #$60D3
       LDA    #$01
       LDB    #$01
P0100  STA    ,X
       LEAX   B,X
       INCA
       CMPA   #$09
       BHI    P0130
P0110  CMPX   ,S
       BCS    P0120
       LEAX   -9,X
P0120  TST    ,X
       BEQ    P0100
       LEAX   1,X
       BRA    P0110
P0130  LEAS   2,S
       RTS
P0140  LDX    #$60D3
       LDU    <$4F
P0150  LDB    ,X+
       BEQ    P0160
       LDA    <$4B
       STA    ,U
       LDA    <$49
       STA    1,U
       STB    2,U
       LDY    #$0004
       LDA    #$02
       STA    3,U
       LDD    #$B230
       JSR    $E364
       STD    ,U++
       BRA    P0150
P0160  RTS
P0170  LDB    1,X
       BITB   #$40
       BEQ    P0170
P0180  LDB    3,X
       LDB    ,X
       BPL    P0180
P0190  LDB    ,X
       BPL    P0190
       RTS
P0200  LDA    #$09    on formate piste
       PSHS   A
       LDU    <$4F
       JSR    $E341
       BSR    P0170
       LDD    #$4EFF
       STD    3,X
       LDB    #$04
       STB    ,X
       LDA    #$1E
P0210  LDB    ,X
       BPL    P0210
       LDB    #$4E
       STB    3,X
       DECA   
       BNE    P0210
P0220  LDA    #$0C
P0230  LDB    ,X
       BPL    P0230
       CLR    3,X
       DECA   
       BNE    P0230
P0240  LDB    ,X
       BPL    P0240
       LDD    #$A10A
       STD    3,X
P0250  LDB    ,X
       BPL    P0250
       STA    3,X
P0260  LDB    ,X
       BPL    P0260
       STA    3,X
P0270  LDB    ,X
       BPL    P0270
       LDD    #$FEFF
       STD    3,X
       LDA    #$06
P0280  LDB    ,X
       BPL    P0280
       LDB    ,U+
       STB    3,X
       DECA   
       BNE    P0280
       LDA    #$16
P0290  LDB    ,X
       BPL    P0290
       LDB    #$4E
       STB    3,X
       DECA   
       BNE    P0290
       LDA    #$0C
P0300  LDB    ,X
       BPL    P0300
       CLR    3,X
       DECA   
       BNE    P0300
P0310  LDB    ,X
       BPL    P0310
       LDD    #$A10A
       STD    3,X
P0320  LDB    ,X
       BPL    P0320
       STA    3,X
P0330  LDB    ,X
       BPL    P0330
       STA    3,X
P0340  LDB    ,X
       BPL    P0340
       LDD    #$FBFF
       STD    3,X
       LDY    #$0200  512 octets
P0350  LDB    ,X
       BPL    P0350
       LDB    #$F6    code $F6 pour
       STB    3,X     \remplissage
       LEAY   -1,Y
       BNE    P0350
P0360  LDB    ,X
       BPL    P0360
       LDB    #$2B    $2BF6 est le chek-
       STB    3,X     \sum correspondant
P0370  LDB    ,X
       BPL    P0370
       LDB    #$F6
       STB    3,X
       LDA    #$54
P0380  LDB    ,X
       BPL    P0380
       LDB    #$4E
       STB    3,X
       DECA
       BNE    P0380
       DEC    ,S
       LBNE   P0220
P0390  LDA    1,X
       BITA   #$40
       BNE    P0410
P0400  LDA    ,X
       BPL    P0400
       STB    3,X
       BRA    P0390
P0410  PULS   A
       CLR    ,X
       RTS

       END
