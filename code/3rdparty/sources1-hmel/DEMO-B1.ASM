       TITLE  TO-DEMO:S/PBANK1
*      ---------------------------------
       PAGE

****************************************
*                                      *
*          S/P bank 1                  *
*                                      *
****************************************


*=======================================
* Auto-copie $1800..$3FFF vers $7800
* (S/P fenêtrage)
*=======================================
FENRAM EQU    *
*---------------------------------------
       LDX    #$1800
       LDY    #$7800
BCPIF1 LDD    ,X++
       STD    ,Y++
       CMPX   #$4000
       BNE    BCPIF1    ->
       RTS


*=======================================
* S/P ecriture sur fichier
*
* Entrée: A  car. à ecrire
* Sortie: CY 0 si ok
*            1 si erreur (fichier sera
*                         fermé et détr.
*=======================================

ECRFIC PSHS   B
       LEAS   -1,S
ERRMEM SET    0
*---------------------------------------
       LDB    #PRINT
       JSR    EXTRA
       TSTB
       BNE    ECFIR     erreur ->
       ANDCC  #$FE
       LEAS   2,S
       PULS   B,PC      ->>

ECFIR  STB    ERRMEM,S

       LDB    #CLOSE    # erreur PRINT
       JSR    EXTRA
       LDB    #KILL     détruire
       JSR    EXTRA

       LDB    ERRMEM,S
       JSR    DOSERR
       ORCC   #$1
       LEAS   1,S
       PULS   B,PC      ->>


*=======================================
* S/P lecture sur le fichier courant
*
* Sortie: A  car. lu si ok
*         CY 0 si ok
*            1 si pb -> erreur traitée
*                       fichier fermé
*=======================================

LECFIC PSHS   B
*---------------------------------------
       LDB    #INPUT
       JSR    EXTRA
       TSTB
       BNE    LEFIFR    erreur ->
       LDB    #54       'input past end'
       TST    EOFFLG    si eof !
       BNE    LEFIFR    ->
       LDA    CARCOU
       ANDCC  #$FE
       PULS   B,PC      ->>

LEFIFR JSR    DOSERR
       LDB    #CLOSE
       JSR    EXTRA
       ORCC   #1
       PULS   B,PC      ->>
