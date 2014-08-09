       TITLE  TO-GRAPH: constantes
*      ------------------------------
       PAGE

****************************************
*                                      *
*           constantes                 *
*                                      *
****************************************

****************************************
*           F E N E T R E S            *
****************************************

* Fenêtre vide (pour activer une boucle
* d'attente par FEN (avec déplacement
* tortue de pointage sans zone optique
* active !)
*---------------------------------------

FENVID FCB    FSTOP

* Fenêtre principale
*---------------------------------------

FENPRI FCB    FLOCA,20,2,0,0
       FCB    FEDI
       FCC    \Ceciestl'\
       FCB    SS2,AIGU
       FCC    \ecrandefonddelad\
       FCB    SS2,AIGU
       FCC    \emo\
       FCB    RC,LF
       FCC    \Danscelui-ciiln'ya\
       FCC    \pasdezoneopti--que\
       FCC    \active !!!\
       FCB    0
       FCB    FSTOP

* Fenêtre de démonstration
*---------------------------------------

FENINF FCB    FLOCF,0,0,16,23
       FCB    FCOULF,VERTCL
       FCB    FTRAME,FTOURI
       FCB    FLOCF,1,1,1,21
       FCB    FCOULF,BLANC
       FCB    FFOND,FTOURE,FCADRE
       FCB    FCOULF,TRANSP
       FCB    FEDI,$1B,$4E
       FCC    \INFO\
       FCB    $1B,$4C,0

       FCB    FLOCF,3,1,10,21
       FCB    FFOND,FTOURE,FCADRE

       FCB    FLOCF,4,1,1,21
       FCB    FEDI
       FCC    \TourPaletteBVR\
       FCB    0

* la définition du carreau ci-dessous
* sert à disposer d'une méthode simple
* (FENCH+FENFOND) pour changer le
* contenu de ce carreaux sans en connai-
* -tre la position ! De ce fait, le
* poussoir associé restera toujours
* INTERD !

       FCB    FLOCF,6,2,4,2
       FCB    FCOULF,PARME
       FCB    FFOND,FTOURE,FCADRE
       FCB    FCOULF,TRANSP
       FCB    FPOUSS,'X,INTERD

       FCB    FLOCF,6,5,2,1
       FCB    FTOURE
       FCB    FTEXTE,'+,'-,0
       FCB    FLOCR,0,0,1,1
       FCB    FTOURI
       FCB    FPOUSS,'T,OFF
       FCB    FLOCR,1,0,1,1
       FCB    FTOURI
       FCB    FPOUSS,'U,OFF

       FCB    FLOCF,9,5,1,2
       FCB    FTOURE,FCADRE
       FCB    FPOUSS,'Y,INTERD

       FCB    FLOCF,6,9,4,2
       FCB    FCOULF,ORANGE
       FCB    FFOND,FTOURE,FCADRE
       FCB    FCOULF,TRANSP

       FCB    FLOCF,6,12,2,1
       FCB    FTOURE
       FCB    FTEXTE,'+,'-,0
       FCB    FLOCR,0,0,1,1
       FCB    FTOURI
       FCB    FPOUSS,'P,OFF
       FCB    FLOCR,1,0,1,1
       FCB    FTOURI
       FCB    FPOUSS,'Q,OFF

       FCB    FLOCF,9,12,1,2
       FCB    FTOURE,FCADRE
       FCB    FPOUSS,'Z,INTERD

       FCB    FLOCF,6,16,2,1
       FCB    FTOURE
       FCB    FTEXTE,'+,'-,0
       FCB    FLOCR,0,0,1,1
       FCB    FTOURI
       FCB    FPOUSS,'B,OFF
       FCB    FLOCR,1,0,1,1
       FCB    FTOURI
       FCB    FPOUSS,'C,OFF

       FCB    FLOCF,6,18,2,1
       FCB    FTOURE
       FCB    FTEXTE,'+,'-,0
       FCB    FLOCR,0,0,1,1
       FCB    FTOURI
       FCB    FPOUSS,'V,OFF
       FCB    FLOCR,1,0,1,1
       FCB    FTOURI
       FCB    FPOUSS,'W,OFF

       FCB    FLOCF,6,20,2,1
       FCB    FTOURE
       FCB    FTEXTE,'+,'-,0
       FCB    FLOCR,0,0,1,1
       FCB    FTOURI
       FCB    FPOUSS,'R,OFF
       FCB    FLOCR,1,0,1,1
       FCB    FTOURI
       FCB    FPOUSS,'S,OFF

       FCB    FLOCF,9,16,1,5
       FCB    FTOURE,FCADRE
       FCB    FEDI
       FCC    \--\
       FCB    0
       FCB    FPOUSS,'H,INTERD

       FCB    FLOCF,11,2,1,4
       FCB    FEDI
       FCC    \Mode\
       FCB    0
       FCB    FLOCR,0,5,1,14
       FCB    FTOURE,FCADRE
       FCB    FPOUSS,'M,OFF

       FCB    FLOCF,14,1,1,21
       FCB    FFOND,FTOURE,FCADRE

       FCB    FTEXTE
       FCC    \Ok\
       FCB    BALISE
       FCC    \Annuler\
       FCB    BALISE,0
       FCB    FLOCR,0,5,1,1
       FCB    FPOUSS,RC,OFF
       FCB    FLOCR,0,13,1,1
       FCB    FPOUSS,FF,OFF
       FCB    FSTOP

* Fenêtre de démonstration 1
*---------------------------------------

FENDEM FCB    FLOCF,0,0,21,25
       FCB    FCOULF,VERTCL
       FCB    FTRAME,FTOURI
       FCB    FCOULF,TRANSP
       FCB    FCOMF,FF,OFF

       FCB    FLOCF,1,1,9,23
       FCB    FFOND,FTOURE,FCADRE

       FCB    FLOCF,2,2,1,23
       FCB    FEDI
       FCC    \SaisieTexte\
       FCB    0
       FCB    FLOCR,0,13,1,8
       FCB    FTOURE,FCADRE
*      champ de saisie en texte
*      le code 130 servira à lire le
*      texte saisie
       FCB    FCZI,130,TEXTE

       FCB    FLOCF,4,2,1,23
       FCB    FEDI
       FCC    \SaisieHexa\
       FCB    0
       FCB    FLOCR,0,17,1,4
       FCB    FTOURE,FCADRE
*      champ de saisie en hexa
*      le code 131 servira à lire le
*      texte saisie
       FCB    FCZI,131,HEXA

       FCB    FLOCF,6,2,1,23
       FCB    FEDI
       FCC    \SaisieD\
       FCB    SS2,AIGU
       FCC    \ecimale\
       FCB    0
       FCB    FLOCR,0,17,1,4
       FCB    FTOURE,FCADRE
*      champ de saisie en décimal
*      le code 132 servira à lire le
*      texte saisie
       FCB    FCZI,132,DECIM

       FCB    FLOCF,8,2,1,23
       FCB    FEDI
       FCC    \Inverseur\
       FCB    0
       FCB    FLOCR,0,17,1,1
       FCB    FTEXTE,BALISE,0
*      Inverseur
*      le code 133 servira à mani-
*      puler l'inverseur au clavier et
*      à en lire la valeur !!!
       FCB    FINV,133,OFF

       FCB    FLOCF,11,1,9,23
       FCB    FFOND,FTOURE,FCADRE

       FCB    FLOCF,12,2,1,23
       FCB    FEDI
       FCC    \LireTexte\
       FCB    0
       FCB    FLOCR,0,11,1,1
       FCB    FTEXTE,BALISE,0
       FCB    FPOUSS,134,OFF

       FCB    FLOCF,14,2,1,23
       FCB    FEDI
       FCC    \LireHexa\
       FCB    0
       FCB    FLOCR,0,11,1,1
       FCB    FTEXTE,BALISE,0
       FCB    FPOUSS,135,OFF

       FCB    FLOCF,16,2,1,23
       FCB    FEDI
       FCC    \LireD\
       FCB    SS2,AIGU
       FCC    \ecim\
       FCB    0
       FCB    FLOCR,0,11,1,1
       FCB    FTEXTE,BALISE,0
       FCB    FPOUSS,136,OFF

       FCB    FLOCF,18,2,1,23
       FCB    FEDI
       FCC    \LireInv.\
       FCB    0
       FCB    FLOCR,0,11,1,1
       FCB    FTEXTE,BALISE,0
       FCB    FPOUSS,137,OFF

*      champ pour visu des lectures
*      le code 140 servira à positionner
*      les éditions sans en connaitre
*      la position
       FCB    FLOCF,15,15,1,8
       FCB    FTOURE,FCADRE
       FCB    FPOUSS,140,INTERD

       FCB    FSTOP

* Menu déroulant
*---------------------------------------

FENMEN FCB    FLOCF,0,0,11,18
       FCB    FCOULF,BLEUCI
       FCB    FFOND,FTOURE,FCADRE
       FCB    FCOMF,FF,OFF
       FCB    FLOCF,1,9,1,10
       FCB    FEDI
       FCC    \bank\
       FCB    0
       FCB    FLOCF,1,14,1,2
       FCB    FCOULF,BLANC
       FCB    FFOND,FTOURE,FCADRE
       FCB    FCOULF,TRANSP
       FCB    FLOCF,3,1,1,16
       FCB    FPOUSS,'D,OFF
       FCB    FEDI
       FCC    \DEMONSTRATION\
       FCB    0
       FCB    FLOCR,2,0,1,16
       FCB    FPOUSS,'G,OFF
       FCB    FEDI
       FCC    \GRILLE\
       FCB    0
       FCB    FLOCR,2,0,1,16
       FCB    FPOUSS,'F,OFF
       FCB    FEDI
       FCC    \FICHIERS\
       FCB    0
       FCB    FLOCR,2,0,1,16
       FCB    FPOUSS,'Q,OFF
       FCB    FEDI
       FCC    \QUITTER\
       FCB    0
       FCB    FSTOP

* Fenêtre titre
*---------------------------------------

FENTIT FCB    FLOCF,0,0,6,19    titre
       FCB    FCOULF,ORANGE
       FCB    FFOND,FTOURE,FCADRE
       FCB    FLOCR,1,2,20,20
       FCB    FEDI
       FCC    \TO-DEMO\
       FCB    0
       FCB    FLOCR,2,4,20,20
       FCB    FEDI
       FCC    \HMEL-92V1.0\
       FCB    0
       FCB    FSTOP

* Fenêtre gestion fichier
*---------------------------------------

FENFIC FCB    FLOCF,0,0,19,20
       FCB    FCOULF,BLEUCI
       FCB    FTOURE,FCADRE,FFOND
       FCB    FCOMF,FF,ON
       FCB    FLOCF,1,1,1,14
       FCB    FPOUSS,'P,OFF
       FCB    FEDI
       FCC    \Pr\
       FCB    SS2,$42
       FCC    \eciserunit\
       FCB    SS2,$42,$65
       FCB    0
       FCB    FLOCR,2,0,1,14
       FCB    FPOUSS,'I,OFF
       FCB    FEDI
       FCC    \Initialiser\
       FCB    0
       FCB    FLOCR,2,0,1,18
       FCB    FPOUSS,'C,OFF
       FCB    FEDI
       FCC    \Catalogue\
       FCB    0
       FCB    FLOCR,2,0,1,18
       FCB    FPOUSS,'R,OFF
       FCB    FEDI
       FCC    \Renommerfichier\
       FCB    0
       FCB    FLOCR,2,0,1,18
       FCB    FPOUSS,'S,OFF
       FCB    FEDI
       FCC    \Supprimerfichier\
       FCB    0
       FCB    FLOCR,2,0,1,18
       FCB    FPOUSS,'D,OFF
       FCB    FEDI
       FCC    \Dupliquerfichier\
       FCB    0
       FCB    FLOCR,3,0,1,18
       FCB    FPOUSS,'L,OFF
       FCB    FEDI
       FCC    \Lire\
       FCB    SS2,$42
       FCC    \ecran\
       FCB    0
       FCB    FLOCR,2,0,1,18
       FCB    FPOUSS,'E,OFF
       FCB    FEDI
       FCC    \Ecrire\
       FCB    SS2,$42
       FCC    \ecran\
       FCB    0
       FCB    FCOULF,BLANC
       FCB    FLOCF,1,16,2,3
       FCB    FFOND,FTOURE,FCADRE
       FCB    FSTOP

*      Mémorisation palette à l'appel
*---------------------------------------

TFMEMO FCB    $FF
TMEMO  FDB    $FFFF,$FFFF,$FFFF,$FFFF
       FDB    $FFFF,$FFFF,$FFFF,$FFFF
       FDB    $FFFF,$FFFF,$FFFF,$FFFF
       FDB    $FFFF,$FFFF,$FFFF,$FFFF

*      Palette standard
*---------------------------------------

PALDEF FDB    0000,0015,0240,0255
       FDB    3840,3855,4080,4095
       FDB    1911,0826,0931,0938
       FDB    2611,2618,3815,0123

*      Mnémo des modes graphiques
*  octet 1 : mode hard ($FF = fin !)
*  octet 2 : mode basic
*  15 oct  : mnémo sur 14 car.
*---------------------------------------

TMNGR  FCB    $00,0
       FCC    \TO7-70\
       FCB    0
       FCB    $80,1
       FCC    \80colonnes   \
       FCB    0
       FCB    $40,3
       FCC    \Bitmap 16     \
       FCB    0
       FCB    $20,11
       FCC    \Tripleoverlay\
       FCB    0
       FCB    $08,7
       FCC    \Doubleoverlay\
       FCB    0
       FCB    $04,5
       FCC    \Page2\
       FCB    0
       FCB    $02,4
       FCC    \Page1\
       FCB    0
       FCB    $01,2
       FCC    \Bitmap 4      \
       FCB    0
       FCB    $FF

****************************************
*  M E S S A G E S                     *
****************************************

MLIRE  FCB    ESC,$4E
       FCC    \LIRE\
       FCB    ESC,$4C,0
MOUT   FCC    \MEMOIREinsuffisante\
       FCB    0
MVFICH FCB    ESC,$4E,HT,SS2,$2E
       FCC    \FICHIER\
       FCB    ESC,$4C,0
MCOMAL FCC    \To-demo\
       FCB    0
MON    FCC    \ON\
       FCB    0
MOFF   FCC    \OFF\
       FCB    0
