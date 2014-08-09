***********************
*                     *  PUTC3.ASM
*   PUTC ETENDU AU    *
*   MODE BIP.MAP 16   *  DISQUE
*                     *
***********************  RESEAU 1

       ORG    $A000
       PSHS   A,B,X,Y,U,CC
       LDA    COL,PCR *COLONNE
       CMPA   #19     *19 MAX
       BHI    ARRET
       LDA    LIG,PCR *LIGNE
       CMPA   #24     *24 MAX
       BHI    ARRET
       LDA    COUL,PCR *COULEUR
       CMPA   #$0F     *15 MAX
       BHI    ARRET
       LDA    LETTRE,PCR *DATA
       CMPA   #32        *DU TEXTE
       BHS    SUIT
ARRET  LDB    #$07
       JSR    >$E803
       PULS   A,B,X,Y,U,CC,PC
SUIT   LDA    LIG,PCR *CALCUL DE ADR
       LDB    #$08    *OU SERA AFFICHE
       MUL            *LA LETTRE.
       LDA    #$28
       MUL
       TFR    D,X
       LDA    #$02
       LDB    COL,PCR
       MUL
       ADDD   #$4000
       LEAX   D,X
       TFR    X,D     *FIN DU CALCUL
       ADDD   #280
       TFR    D,U
       LDX    LETTRE,PCR
DEBUT  LDY    >$60CF
       LDA    ,X      *CALCUL DE ADR
       SUBA   #32     *OU EST STOCKEE
       LDB    #$08    *LA LETTRE.
       MUL
       LEAY   D,Y     *FIN CALCUL
       LDB    #$08
ENCOR1 BSR    SUB1
       LEAY   1,Y
       LEAU   -$29,U
       DECB
       BNE    ENCOR1
       LEAX   1,X
       LDA    ,X
       BNE    ENCOR2
       LDA    COL,PCR *MODIFIE
       INCA           *COOR AVANT
       STA    COL,PCR *RETOUR
       CMPA   #20
       BLO    FIN
       INC    LIG,PCR
       CLR    COL,PCR
FIN    PULS   A,B,X,Y,U,CC,PC
ENCOR2 INC    COL,PCR
       LDA    COL,PCR
       CMPA   #20
       BLO    ENCOR3
       CLR    COL,PCR
       LEAU   280,U
       INC    LIG,PCR
       LDA    LIG,PCR
       CMPA   #25
       BHS    ARRET
ENCOR3 LEAU   322,U
       BRA    DEBUT
************
****SUB1****
************
SUB1   LDA    >$E7C3  *ROUTINE D'AFFI
       ORA    #$01    *DE LA LETTRE.
       STA    >$E7C3
       LDA    ,Y
       ANDA   #$80
       BEQ    SUIT1
       BSR    SUB2
SUIT1  LDA    ,Y
       ANDA   #$40
       BEQ    SUIT2
       BSR    SUB3
SUIT2  LDA    >$E7C3
       ANDA   #$FE
       STA    >$E7C3
       LDA    ,Y
       ANDA   #$20
       BEQ    SUIT3
       BSR    SUB2
SUIT3  LDA    ,Y
       ANDA   #$10
       BEQ    SUIT4
       BSR    SUB3
SUIT4  LEAU   1,U
       LDA    >$E7C3
       ORA    #$01
       STA    >$E7C3
       LDA    ,Y
       ANDA   #$08
       BEQ    SUIT5
       BSR    SUB2
SUIT5  LDA    ,Y
       ANDA   #$04
       BEQ    SUIT6
       BSR    SUB3
SUIT6  LDA    >$E7C3
       ANDA   #$FE
       STA    >$E7C3
       LDA    ,Y
       ANDA   #$02
       BEQ    SUIT7
       BSR    SUB2
SUIT7  LDA    ,Y
       ANDA   #$01
       BEQ    SUIT8
       BSR    SUB3
SUIT8  RTS
************
****SUB2****
************
SUB2   LDA    ,U
       ANDA   #$0F
       STA    ,U
       LDA    COUL,PCR
       ASLA
       ASLA
       ASLA
       ASLA
       ORA    ,U
       STA    ,U
       RTS
************
****SUB3****
************
SUB3   LDA    ,U
       ANDA   #$F0
       STA    ,U
       LDA    COUL,PCR
       ORA    ,U
       STA    ,U
       RTS
*************
****STOCK****
*************
COL    FCB    $00
LIG    FCB    $00
COUL   FCB    $00
LETTRE FDB    $0000
       END
