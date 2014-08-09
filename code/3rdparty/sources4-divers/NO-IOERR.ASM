



*
*            NO-IOERR.ASM
*
*   Programmation en assembleur TO7
*   Editions Sybex Fagot et Barraly
*         Annexe 1  pages 162
*
* ======================================
*
* Gestion de l'erreur I/O sur lecteur de
* cassettes.Récupération de la partie du
* programme chargée avant l'interruption
* Autorise la fonction LIST pour listage
* et sauvegarde par: LIST"CASS:XXX.BAS"
*

       ORG    32701

       LDX    #26110
SUITE  LDA    ,X+
       CMPA   #0
       BNE    SUITE   (-6)
       STX    >26101
       CLR    >26103
       CLR    >26104
       LDX    #26101
SUITE2 LDX    ,X
       STX    >32750
       LDD    ,X
       SUBD   >32750
       CMPD   #256
       BLO    SUITE2  (-16)
       LDY    #0
       STY    ,X
       RTS
       END

*
* Programme Basic équivalent
*
* 10 CLEAR,32699:FOR I=32701 TO 32745:
*    READ I$:POKEI,VAL("&H"+I$):NEXT
* 20 DATA 8E,65,FE,A6,80,81,00,26,FA,BF,
*    65,F5,7F,65,F7,7F,65,F8,8E,65,F5,AE
*    ,84,BF,7E,EE,EC,84,B3,7F,EE,10,83,
*    01,00,25,F0,10,8E,00,00,10,AF,84,39
*
*
* MODE D'EMPLOI:
*
* Executer le programme Taper: RUN
*
* Charger avec  LOAD  le programme défec
* -tueux jusqu'au point d'erreur.
*
* Taper en mode direct: EXEC 32701
*
* Contôler avec:  LIST
*
* Sauvegander par: LIST"CASS:NOM.BAS"
*
*
* Version assembleur:
*
* 10 CLEAR,32699:LOADM"NO-IOERR.BIN"
*
