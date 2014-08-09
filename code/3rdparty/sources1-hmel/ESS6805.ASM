****************************************
*                                      *
*  Essai de l'assembleur croisé 6805   *
*                                      *
*--------------------------------------*
*                                      *
* les instuctions commentées par *     *
* sont des mnémos ajoutés par esprit   *
* cartésien et soucis de cohérence     *
* avec le code 6809 !!!                *
*                                      *
****************************************

       TITLE  ESSAIASM6805

LED    EQU    3       bit commande led
SWITCH EQU    7       bit interrupteur
PORTB  EQU    $0001
FLG    SET    50

       ORG    $0010   ram

MEMPT  RMB    2
VAR    RMB    1

       PAGE
       ORG    $0080   rom

CNST1  FCB    10
CNST2  FDB    $1234
MESS   FCC    'SALUTOHBRICOLEUR'
*      INCLUD FILE    include mis en
*                     commentaire !!


* Assemblage type 0
*
*   adressage inherent
*---------------------------------------

T0     TAX
       TXA
       SEC
       CLC
       SEI
       CLI
       SWI
       RTS
       RTI
       RSP
       NOP
       STOP
       WAIT
       INCA
       INCX
       DECA
       DECX
       CLRA
       CLRX
       COMA
       COMX
       NEGA
       NEGX
       ROLA
       ROLX
       RORA
       RORX
       LSLA
       LSLX
       LSRA
       LSRX
       ASLA           *
       ASLX           *
       ASRA
       ASRX
       TSTA
       TSTX


* Assemblage type 1
*
*   adressage PC relatif -128..+127
*
*   BRA   LABEL
*   BRA   LABEL+1
*   BRA   *+25
*---------------------------------------

T1     BRA    *
       BRN    T1
       BHI    *
       BLS    *
       BCC    *
       BHS    *
       BCS    *
       BLO    *
       BNE    *
       BEQ    *
       BHCC   *
       BHCS   *
       BPL    *
       BMI    *
       BMC    *
       BMS    *
       BIL    *
       BIH    *
       BSR    *


* Assemblage type 2
*
*   INC [<]<exp. 8 bits>   direct
*
*   INC ,X                 indexe pas
*                          d'offset
*   INC [<]<exp. 8 bits>,X indexe offset
*                          sur 8 bits
*---------------------------------------

T2     INC    VAR
       INC    ,X
       INC    CNST2,X
       DEC    VAR
       CLR    VAR
       COM    VAR
       NEG    VAR
       ROL    VAR
       ROR    VAR
       LSL    VAR
       LSR    VAR
       ASL    VAR     *
       ASR    VAR
       TST    VAR


* Assemblage type 3
*
*   BRSET #<exp. 3 bits>,
*         [<]<exp. 8 bits>,
*         <déplacement relat. -128..127>
*---------------------------------------

T3     BRSET  #SWITCH,PORTB,T1
       BRCLR  #SWITCH,<PORTB,T2


* Assemblage type 4
*
*   BSET #<exp. 3 bits>,
*        [<]<exp. 8 bits>
*---------------------------------------

T4     BSET   #LED,PORTB
       BCLR   #LED,<PORTB


* Assemblage type 5
*
*   STA [<]<exp. 8 bits>
*   STA [>]<exp. 16 bits>
*   STA ,X
*   STA [<]<exp. 8 bits>,X
*   STA [>]<exp. 16 bits>,X
*
* Nb: si '<'  impose mode direct
*     si '>'  impose mode étendu
*     si rien fait au mieux selon expres
*---------------------------------------

T5     STA    VAR
       STA    >VAR
       STA    ,X
       STA    <VAR,X
       STA    >VAR,X
       STX    VAR
       JMP    T1
       JMP    FINPRG
       JMP    ,X
       JMP    T1,X
       JMP    FINPRG,X
       JSR    T1


* Assemblage type 6
*
*   LDA #<exp. 8 bits>
*   LDA [<]<exp. 8 bits>
*   LDA [>]<exp. 16 bits>
*   LDA ,X
*   LDA [<]<exp. 8 bits>,X
*   LDA [>]<exp. 16 bits>,X
*
* Nb: si '<'  impose mode direct
*     si '>'  impose mode étendu
*     si rien fait au mieux selon expres
*---------------------------------------

T6     LDA    #CNST1
       LDA    #25
       LDA    #$23
       LDA    VAR
       LDA    >VAR
       LDA    $1000
       LDA    ,X
       LDA    <VAR,X
       LDA    >$1235,X
       LDX    #CNST1
       ADD    #CNST1
       ADC    #CNST1
       SUB    #CNST1
       SBC    #CNST1
       AND    #CNST1
       ORA    #CNST1
       EOR    #CNST1
       CMP    #CNST1
       CPX    #CNST1
       BIT    #CNST1

       ADDA   #CNST1    *
       ADCA   #CNST1    *
       SUBA   #CNST1    *
       SBCA   #CNST1    *
       ANDA   #CNST1    *
       EORA   #CNST1    *
       CMPA   #CNST1    *
       CMPX   #CNST1    *
       BITA   #CNST1    *

FINPRG EQU    *
       END
