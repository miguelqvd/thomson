*
* SOUS-PROGRAMME ASSEMBLEUR
* POUR INVERSION D'UNE CHAINE DE
* DE CARACTERES
*
* CLUB CONTACTHOMS No 15 page 14
*     Jérome THOEN (c) 1993
*

       ORG    $9000
MAXCAR EQU    255     long maxi chaîne

ENTREE PSHS   A,B,Y,U,CC
       CMPA   #3
       BNE    SORTIE  sortie si
       LDU    1,X     pas chaîne
       TSTB           sortie si
       BEQ    SORTIE  longueur nulle
       LDU    1,X     adr chaîne A
*                     inverser -> U
       TFR    B,A     longueur -> A
       PSHS   X       sauvegarde X
       LDX    #CHAINE adr fin chaîne
       ABX            inversée -> X
*                     inversée et copie
CSUIV  LDB    ,U+     chaîne dans
       STB    ,-X     buffer 'CHAINE'
       DECA           teste fin
       BNE    CSUIV   de chaîne
       PULS   X       recharge X
       LDD    #CHAINE nouvelle adr
       STD    1,X     -> descripteur
SORTIE PULS   A,B,Y,U,CC,PC

CHAINE RMB    MAXCAR  reserve place
*                     pour chaîne
*                     inversée
       END
