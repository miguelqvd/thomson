****************************************
*                                      *
*   Conversion d'un son AMIGA en TO8   *
*                                      *
****************************************

       ORG    $7580
DEBSOU EQU    $7700   }zique AMIGA
FINSOU EQU    $DF97   }
DEBOBJ EQU    $7600   résultat THOMSON

G      ORCC   #80
       LDX    #DEBSOU

EMULE  LDA    ,X
       ADDA   #128
       LSRA
       LSRA              1ère étape:
       BCC    FINEMU  8 bits  ->  6 bits
       CMPA   #63
       BEQ    *+3
       INCA
FINEMU STA    ,X+
       CMPX   #FINSOU
       BNE    EMULE

       LDX    #DEBSOU
       LDU    #DEBOBJ
COMPIL LDA    ,X+
       ASLA
       ASLA
       STA    ,U

       LDA    ,X
       ANDA   #3
       ORA    ,U
       STA    ,U+
       LDA    ,X+
       ASLA              2ème étape:
       ASLA            mise bout à bout
       ANDA   #240    pour gain de place
       STA    ,U

       LDA    ,X
       LSRA
       LSRA
       ORA    ,U
       STA    ,U+
       LDA    ,X+
       ANDA   #3
       STA    ,U

       LDA    ,X+
       ASLA
       ASLA
       ORA    ,U
       STA    ,U+
       CMPX   #FINSOU
       BLO    COMPIL  dernier octet =
       STU    *+4     fin du son après
       SWI            la compilation

       END
