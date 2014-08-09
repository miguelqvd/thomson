*
*     ETOILE.ASM  routine DRAWH
*
*   Passez facilement du BASIC au
*   langage machine des TO7(70),TO9
*   Programme No XVIII pages 123-129
*
* =====================================
*
* Dessin de deux triangles inversés qui
* se croisent.
*
* -------------------------------------
*
* ATTENTION SUR TO7, FAIRE PRECEDER
* L'APPEL A DRAWH DE PDHS U, ET LE
* FAIRE SUIVRE DE PULS U.
*

PUTCH  EQU    $E803   Affiche caractère
CHDRAW EQU    $6041   Cod ASCI car. des.
FORME  EQU    $6038   Code de la couleur
PLOTX  EQU    $603D   Abscis. der. point
PLOTY  EQU    $603F   Ordonné der. point
DRAWH  EQU    $E80C   Tracé de segment


       ORG    $7D00   Soit 32000

       PSHS   U,Y,X,DP,D,CC
       LDU    #TABLE  Ecran
D0     LDB    ,U+
       CMPB   #4
       BEQ    SUITE
       JSR    PUTCH
       BRA    D0
SUITE  CLRA
       STA    CHDRAW
       LDA    #4      Bleu
       STA    FORME
       JSR    A1      1er triangle
       LDA    #1      Rouge
       STA    FORME
       JSR    A2      2nd triangle
       JSR    COMPT   Temporisation
       LDA    #$FC    Fond jaune
       STA    FORME
       JSR    A1      Eff. 1er triangle
       JSR    A2      Eff. 2nd triangle
       BRA    FIN
A1     LDX    #&160
       STX    PLOTX
       LDY    #&96
       STY    PLOTY
       LDU    #TABLE1 .Coordonnées
D1     LDX    ,U++    .du 1er
       LDY    ,U++    .triangle
       JSR    DRAWH   .le dessiner
       CMPX   #&160   Fin table 1
       BEQ    RET
       BRA    D1
A2     LDX    #&160
       STX    PLOTX
       LDY    #&136
       STY    PLOTY
       LDU    #TABLE2 .Coordonnées
D2     LDX    ,U++    .du 2nd
       LDY    ,U++    .triangle
       JSR    DRAWH   .le dessiner
       CMPX   #&160   Fin table 2
       BEQ    RET
       BRA    D2
COMPT  CLRB           B=0
       LEAU   1,U     Plac.pile U
D3     PSHU   B       Sauv. B
       CLRA           A=0
       CLRB           B=0
D4     ADDD   #1      D=D+1
       CMPD   #$FFFF  .D=$FFFF?
       BNE    D4      .Non->D4
       PULU   B       .Oui, sortir B
       INCB           B=B+1
       CMPB   #10     .B=10?
       BEQ    RET     .Oui=retour
       BRA    D3      .Sinon D3
RET    RTS            Fin s/s prog.
FIN    PULS   CC,D,DP,X,Y,U
       SWI
TABLE  FCB    $1B,$23,$20,$53,$4
TABLE1 FDB    208,96,184
       FDB    144,160,96
TABLE2 FDB    184,88,208
       FDB    136,160,136
       END
