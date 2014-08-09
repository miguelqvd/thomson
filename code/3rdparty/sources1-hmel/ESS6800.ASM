****************************************
*                                      *
*  Essai de l'assembleur croisé 6800   *
*                                      *
****************************************

       TITLE  ESSAIASM6800

LED    EQU    3       bit commande led
SWITCH EQU    7       bit interrupteur
PORTB  EQU    $0001
PORTF  EQU    $ABCD
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

T0     ABA
       CLRA
       CLRB
       CBA
       COMA
       COMB
       NEGA
       NEGB
       DAA
       DECA
       DECB
       INCA
       INCB
       PSHA
       PSHB
       PULA
       PULB
       ROLA
       ROLB
       RORA
       RORB
       ASLA
       ASLB
       ASRA
       ASRB
       LSRA
       LSRB
       LSLA           *
       LSLB           *
       SBA
       TAB
       TBA
       TSTA
       TSTB
       DEX
       DECX           *
       DES
       DECS           *
       INX
       INCX           *
       INS
       INCS           *
       TXS
       TSX
       NOP
       RTI
       RTS
       SWI
       WAI
       WAIT           *
       CLC
       CLI
       CLV
       SEC
       SEI
       SEV
       TAP
       TPA


* Assemblage type 1
*
*   adressage PC relatif -128..+127
*
*   BRA   LABEL
*   BRA   LABEL+1
*   BRA   *+25
*---------------------------------------

T1     BRA    *
       BCC    T10
       BCS    T1
       BEQ    *
       BGE    *
       BGT    *
       BHI    *
       BLE    *
       BLS    *
       BLT    *
       BMI    *
       BNE    *
       BVC    *
       BVS    *
       BPL    *
T10    BSR    *


* Assemblage type 2
*
*   CLR [<]<exp. 8 bits>,X indexe offset
*                          sur 8 bits
*   CLR [>]<exp.16 bits>
*---------------------------------------

T2     CLR    VAR,X
       CLR    <VAR,X
       CLR    VAR
       CLR    >VAR
       COM    VAR
       NEG    VAR
       DEC    VAR
       INC    VAR
       ROL    VAR
       ROR    VAR
       ASL    VAR
       ASR    VAR
       LSR    VAR
       LSL    VAR     *
       TST    VAR
       JMP    PORTF
       JSR    T1


* Assemblage type 3
*
*  STAA [<]<exp. 8 bits>      direct
*  STAA [<]<exp. 8 bits>,X indexe offset
*                          8 bits
*  STAA [>]<exp.16 bits>
*
*     si '>'  impose mode étendu
*     si '>'  impose mode étendu
*     si rien fait au mieux selon expres
*---------------------------------------

T3     STAA   VAR
       STAA   PORTF
       STAA   <VAR
       STAA   >VAR
       STAA   VAR,X
       STAA   <VAR,X
       STA    VAR     *
       STAB   VAR
       STB    VAR     *
       STX    VAR
       STS    VAR


* Assemblage type 4 et 5
*
*  ADDA #<exp. 8/16 bits>
*  ADDA [<]<exp. 8 bits>
*  ADDA [<]<exp. 8 bits>,X
*  ADDA [>]<exp. 16 bits>
*
*     si '>'  impose mode étendu
*     si '>'  impose mode étendu
*     si rien fait au mieux selon expres
*---------------------------------------

T45    ADDA   #CNST1
       ADDA   #25
       ADDA   #$23
       ADDA   VAR
       ADDA   PORTF
       ADDA   <VAR
       ADDA   >VAR
       ADDA   VAR,X
       ADDA   <$12,X
       ADDB   #25
       ADCA   #25
       ADCB   #25
       ANDA   #25
       ANDB   #25
       BITA   #25
       BITB   #25
       CMPA   #25
       CMPB   #25
       EORA   #25
       EORB   #25
       LDAA   #25
       LDA    #25     *
       LDAB   #25
       LDB    #25     *
       ORAA   #25
       ORA    #25     *
       ORAB   #25
       ORB    #25     *
       SUBA   #25
       SUBB   #25
       SBCA   #25
       SBCB   #25
       CPX    #25
       CMPX   #25     *
       LDX    #25
       LDS    #25

FINPRG EQU    *
       END
