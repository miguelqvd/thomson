*
* SOUS-PROGRAMME ASSEMBLEUR
* POUR INVERSION D'UNE CHAINE DE
* DE CARACTERES
*
* CLUB CONTACTHOMS No 15 page 14
*     J�rome THOEN (c) 1993
*

       ORG    $9000
MAXCAR EQU    255     long maxi cha�ne

ENTREE PSHS   A,B,Y,U,CC
       CMPA   #3
       BNE    SORTIE  sortie si
       LDU    1,X     pas cha�ne
       TSTB           sortie si
       BEQ    SORTIE  longueur nulle
       LDU    1,X     adr cha�ne A
*                     inverser -> U
       TFR    B,A     longueur -> A
       PSHS   X       sauvegarde X
       LDX    #CHAINE adr fin cha�ne
       ABX            invers�e -> X
*                     invers�e et copie
CSUIV  LDB    ,U+     cha�ne dans
       STB    ,-X     buffer 'CHAINE'
       DECA           teste fin
       BNE    CSUIV   de cha�ne
       PULS   X       recharge X
       LDD    #CHAINE nouvelle adr
       STD    1,X     -> descripteur
SORTIE PULS   A,B,Y,U,CC,PC

CHAINE RMB    MAXCAR  reserve place
*                     pour cha�ne
*                     invers�e
       END
