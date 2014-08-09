


****************************************
*                                      *
*            M O I R A G E             *
*                                      *
****************************************
*                                      *
* Programme de moirage de la mémoire   *
* point.                               *
*--------------------------------------*
*                                      *
*     Manuel de l'assembleur 6809      *
*        du TO7/TO7-70 page 24         *
*                                      *
****************************************

INIT   EQU    $E800   Initialisation
PORTC  EQU    $E7C3
STADR  EQU    $4000   Début de l'écran
ENDADR EQU    $5F40   Fin de l'écran + 1

*--------------------------------------*


       ORG    ENDMEM-$400 1K Réserve

DIRECT EQU    *<-8    Page 0
       SETDP  DIRECT
*      TITLE  Balayage Ecran
*      INCLUD EQUATES Fichier contenant
* les principales adresses d'entrée du
* Moniteur TO7
       PAGE
START  PSHS   A,B,X,Y,U,DP Sauvegarde
       JSR    INIT    Initialisation
       LDA    #DIRECT Page 0
       TFR    A,DP
       LDA    PORTC   Mise en mémoire
* points:Par mise à 1 du bit 0 du port C
       ORA    #1
       STA    PORTC
       LDX    #STADR  Adresse de début
* de l'écran
M2     LDY    #20     Compteur colonne:
* On affiche 20 fois 2 octets, soit
* 40 octets par ligne
       LDD    #$FFFF  Moirage
* Alternance de 1 et de 0 sur la ligne
M0     STD    ,X++    Charger l'écran
       LEAY   -1,Y
       BNE    M0      Répète 20 fois
       LDY    #20     Ligne suivante
       LDD    #$0000  Le motif est inver
* se pour décaler les 1 et les 0 d'une
* ligne à l'autre et obtenir un moirage
M1     STD    ,X++
       LEAY   -1,Y
       BNE    M1      Toujours 20 fois
       CMPX   #ENDADR Fin d'écran
       BLS    M2      Sinon on recom
* mence 2 lignes à motifs alternés
       SWI            Retour au moniteur
       END    START
