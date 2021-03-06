


****************************************
*                                      *
*            M O I R A G E             *
*                                      *
****************************************
*                                      *
* Programme de moirage de la m�moire   *
* point.                               *
*--------------------------------------*
*                                      *
*     Manuel de l'assembleur 6809      *
*        du TO7/TO7-70 page 24         *
*                                      *
****************************************

INIT   EQU    $E800   Initialisation
PORTC  EQU    $E7C3
STADR  EQU    $4000   D�but de l'�cran
ENDADR EQU    $5F40   Fin de l'�cran + 1

*--------------------------------------*


       ORG    ENDMEM-$400 1K R�serve

DIRECT EQU    *<-8    Page 0
       SETDP  DIRECT
*      TITLE  Balayage Ecran
*      INCLUD EQUATES Fichier contenant
* les principales adresses d'entr�e du
* Moniteur TO7
       PAGE
START  PSHS   A,B,X,Y,U,DP Sauvegarde
       JSR    INIT    Initialisation
       LDA    #DIRECT Page 0
       TFR    A,DP
       LDA    PORTC   Mise en m�moire
* points:Par mise � 1 du bit 0 du port C
       ORA    #1
       STA    PORTC
       LDX    #STADR  Adresse de d�but
* de l'�cran
M2     LDY    #20     Compteur colonne:
* On affiche 20 fois 2 octets, soit
* 40 octets par ligne
       LDD    #$00FF  Moirage
* Alternance de 1 et de 0 sur la ligne
M0     STD    ,X++    Charger l'�cran
       LEAY   -1,Y
       BNE    M0      R�p�te 20 fois
       LDY    #20     Ligne suivante
       LDD    #$FF00  Le motif est inver
* se pour d�caler les 1 et les 0 d'une
* ligne � l'autre et obtenir un moirage
M1     STD    ,X++
       LEAY   -1,Y
       BNE    M1      Toujours 20 fois
       CMPX   #ENDADR Fin d'�cran
       BLS    M2      Sinon on recom
* mence 2 lignes � motifs altern�s
       SWI            Retour au moniteur
       END    START
