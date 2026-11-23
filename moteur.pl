/*
  moteur.pl : moteur d'inference (facteurs de certitude type MYCIN)

  Faits dynamiques (alimentes par l'interface ou par les tests) :
     reponse(Atome, oui|non|inconnu)   symptome ou condition
     contexte(Cle, Valeur)             culture, mode, stade, ...

  Calcul du niveau de confiance d'une maladie M :
     1. CF des symptomes observes, combines : CF = CF1 + CF2*(1-CF1)
     2. symptome attendu declare ABSENT : CF = CF * (1 - 0.4*CF_symptome)
     3. condition favorable confirmee : combinaison avec +0.2
        condition favorable declaree absente : CF = CF * 0.9
     4. stade de culture sensible : combinaison avec +0.1
  Aucun candidat sans au moins un symptome observe.
*/
:- encoding(utf8).
:- use_module(library(lists)).
:- use_module(library(apply)).

:- dynamic reponse/2, contexte/2.

observe(S) :- reponse(S, oui).
nie(S)     :- reponse(S, non).

% combinaison MYCIN de deux certitudes positives
combine(C, Acc, R) :- R is Acc + C*(1-Acc).

penalise(F, C, A, R) :- R is A*(1 - F*C).
attenue(F, _, A, R)  :- R is A*(1 - F).

cf_symptomes(M, CF) :-
    findall(C, (regle(M,S,C), observe(S)), Pos),
    Pos \== [],
    foldl(combine, Pos, 0, CFp),
    facteur_negatif(F),
    findall(C, (regle(M,S,C), nie(S)), Neg),
    foldl(penalise(F), Neg, CFp, CF).

cf_maladie(M, CF) :-
    cf_symptomes(M, CF0),
    poids_contexte_favorable(W),
    findall(W, (favorable(M,Ctx), observe(Ctx)), Bonus),
    foldl(combine, Bonus, CF0, CF1),
    poids_contexte_defavorable(Pd),
    findall(x, (favorable(M,Ctx), nie(Ctx)), Neg),
    foldl(attenue(Pd), Neg, CF1, CF2),
    bonus_stade(M, CF2, CF).

bonus_stade(M, CF0, CF) :-
    contexte(stade, St), stade_sensible(M, L), memberchk(St, L), !,
    poids_stade(W), combine(W, CF0, CF).
bonus_stade(_, CF, CF).

% classement(+Culture, -[CF-Maladie]) du plus probable au moins probable
classement(Culture, Liste) :-
    findall(CF-M, (disease(M,_,Culture,_), cf_maladie(M,CF)), L),
    sort(0, @>=, L, Liste).

% niveau de confiance en texte
niveau(CF, 'élevée')    :- CF >= 0.8, !.
niveau(CF, 'moyenne')    :- CF >= 0.5, !.
niveau(CF, 'faible')    :- CF >= 0.25, !.
niveau(_,  'très faible').

pourcent(CF, P) :- P is round(CF*100).

% Diagnostic incertain : ecart faible entre les deux premiers, ou score bas
incertain([CF1-_, CF2-_|_]) :- CF1 - CF2 < 0.15, !.
incertain([CF1-_|_]) :- CF1 < 0.5.

% Signes qui departagent M1 et M2 et qui n'ont pas encore ete demandes
depart(M1, M2, S) :-
    ( regle(M1, S, _), \+ regle(M2, S, _)
    ; regle(M2, S, _), \+ regle(M1, S, _) ),
    \+ reponse(S, _).

% explication : symptomes observes et conditions confirmees
explication(M, Symptomes, Contextes, Absents) :-
    findall(S-C, (regle(M,S,C), observe(S)), Symptomes),
    findall(Ctx, (favorable(M,Ctx), observe(Ctx)), Contextes),
    findall(S, (regle(M,S,_), nie(S)), Absents).

% symptomes / organes d'une culture
organe_de_culture(Culture, Organe) :-
    disease(M,_,Culture,_), symptom(M, Organe, _).

organes_culture(Culture, Organes) :-
    setof(O, organe_de_culture(Culture, O), Organes).

symptomes_organe(Culture, Organe, Symptomes) :-
    setof(S, M^N^G^(disease(M,N,Culture,G), symptom(M,Organe,S)), Symptomes).

% maladies candidates : celles qui possedent le symptome principal,
% ou toutes celles de l'organe si aucun symptome principal n'est choisi
candidats(Culture, Organe, aucun, Ms) :- !,
    setof(M, N^G^S^(disease(M,N,Culture,G), symptom(M,Organe,S)), Ms).
candidats(Culture, _, Principal, Ms) :-
    setof(M, N^G^(disease(M,N,Culture,G), regle(M,Principal,_)), Ms), !.
candidats(_, _, _, []).

% symptomes a demander pour un candidat dans un organe
symptome_a_demander(M, Organe, S) :-
    symptom(M, Organe, S), \+ reponse(S, _).

reinitialiser :- retractall(reponse(_,_)), retractall(contexte(_,_)).
