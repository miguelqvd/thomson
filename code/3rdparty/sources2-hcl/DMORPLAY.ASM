****************************************
*                                      *
*  Restitution d'une musique compactée *
*                                      *
* DEBMUS : pointe le début des modules *
* MM : contient le pointeur de musique *
*                                      *
* module = Bank ; Début ; Fin          *
* musique = module ; ... ; -1          *
*                                      *
****************************************


MUSIC  PSHS   X,A,B
       LDA    $E7E5
       STA    ENVOI+4 sauvegarde banque
BNKMUS LDA    #6      banque de musique
       STA    $E7E5
       LDX    #$A000  pointeur musique
       BRA    NOTE1
ENVOI  STA    *-1
       LDA    #0
       STA    $E7E5
       PULS   B,A,X,PC

NOTE1  LDA    ,X+      son compacté No 1
       LDA    -1,X
       LSRA              ( octet 0 )
       LSRA
       TST    ,-X
       STA    $E7CD
       STX    ENVOI-4
       LDA    #*+4-ENVOI
       BRA    ENVOI

       LDA    ,X+      son compacté No 2
       ANDA   #3
       STA    *+8      ( octets 0 et 1 )
       LDA    ,X
       LSRA
       LSRA
       ORA    #0
       STA    $E7CD
       STX    ENVOI-4
       LDA    #*+4-ENVOI
       BRA    ENVOI

       LDA    ,X+      son compacté No 3
       ASLA
       ASLA            ( octets 1 et 2 )
       STA    *+8
       LDA    ,X
       ANDA   #3
       ORA    #0
       STA    $E7CD
       STX    ENVOI-4
       LDA    #*+4-ENVOI
       BRA    ENVOI

       LDA    ,X       son compacté No 4
       TST    ,X+
       LSRA            ( octets 2 et 3 )
       LSRA
       STA    $E7CD
FINMOD CMPX   #$DFFE     fin du module ?
       BHS    NXTMOD
       STX    ENVOI-4
       LDA    #NOTE1-ENVOI
       BRA    ENVOI
NXTMOD LDX    MM         module suivant
       LDA    ,X+       banque du module
       BPL    *+7
       LDX    #DEBMUS recommence musique
       LDA    ,X+
       STA    BNKMUS+1
       LDD    ,X++      adresse début
       STD    ENVOI-4
       LDD    ,X++      adresse fin
       STD    FINMOD+1
       STX    MM
       LDA    #NOTE1-ENVOI
       BRA    ENVOI
