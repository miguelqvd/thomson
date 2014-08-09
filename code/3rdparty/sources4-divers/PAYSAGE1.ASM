*
*            PAYSAGE1.ASM
*
*    Passez facilement du BASIC au
*   langage machine des TO7(70),TO9
*   Programme No XXIX pages 203-215
*
*      Voir également PAYSAGE2
*     Théophile No9 page 48 à 51
*
* =====================================
*
* Recopie d'écran en double dimensions
* sur imprimante PR90-080.
*

RSOPC  EQU    $602B
RSCOH  EQU    $E812

       ORG    $7D00   Soit 32000
P1     PSHS   U,Y,X,DP,D,CC
R1     LDB    #$40    Ouverture// Ecrit.
       STB    RSOPC
       JSR    RSCOH
R2     LBCS   D11
R3     LDA    $E7C3   Mémoire-caractère
       ORA    #1
       STA    $E7C3
R4     LDB    #8      .Code copie graph.
       STB    RSOPC   .Imp.PR90-080+Mise
       JSR    RSCOH   .en écriture
       LBCS   D11
       LDU    #&32000 Posit. pile U
R7     LDX    #$4000-1 Début programme
D1     LDA    #&40
P2     PSHU   A
D2     LEAX   1,X
       LDA    #8
P3     PSHU   A
D3     LDA    #7
P4     PSHU   A
P5     PSHU   B
D4     LDB    0,X
P6     LDA    2,U
D5     LSRB
       DECA
       BNE    D5
P7     PULU   B
       RORB
P8     DEC    0,U
       BEQ    D6
P9     PSHU   B
       LEAX   &40,X
       BRA    D4
D6     LSRB
       ORB    #$80
       TST    FLAG
       BNE    D9
D7     JSR    RSCOH   Impression
       BCS    D11
       LEAX   -(6*&40),X
P10    PULU   A
P11    DEC    0,U
       BEQ    P12
       BRA    D3
P12    PULU   A
P13    DEC    0,U
       BEQ    P14
       BRA    D2
P14    PULU   A
       LDB    #$0A    Avance lign/papier
       JSR    RSCOH
       BCS    D11
       CMPX   #$5F3F-(&40*3)
       BEQ    FIN
       LEAX   (6*&40),X
       CMPX   #$5F3F-(&40*4)
       BEQ    D8
       BRA    D1
D8     INC    FLAG
       BRA    D1
D9     ANDB   #$8F
       BRA    D7
FIN    LDD    #$80A   3 copies/feuille
D10    JSR    RSCOH
       BCS    D11
       DECA
       BNE    D10
D11    CLR    FLAG    R.a.z FLAG
       LDB    #$0F    Mis.mod.caract.imp
       JSR    RSCOH
       LDB    #$10    Fermeture
       STB    RSOPC
       JSR    RSCOH
P15    PULS   CC,D,DP,X,Y,U
       SWI
FLAG   FCB    00
       END
