/*
  main.pl : point d'entree.
  Lancer :   swipl main.pl      (le dialogue demarre tout seul)
  Relancer : ?- demarrer.
*/
:- encoding(utf8).

:- [knowledge_base].
:- [regles_cf].
:- [questions].
:- [traitements].
:- [moteur].
:- [interface].

:- initialization(demarrer).
