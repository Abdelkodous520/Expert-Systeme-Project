/*
  interface.pl : dialogue console (IHM)

  Parcours : culture -> mode de production -> contexte (lieu, saison, meteo,
  stade) -> organe -> symptome principal -> questions ciblees -> conditions
  favorables -> (departage si incertain) -> diagnostic, explication, plan.
*/
:- encoding(utf8).
:- use_module(library(readutil)).
:- use_module(library(lists)).

:- dynamic candidat/1.

% ---------------------------------------------------------------- saisie
lire(L) :-
    read_line_to_string(user_input, L0),
    (   L0 == end_of_file
    ->  nl, writeln('Fin de la saisie. Au revoir.'), halt
    ;   normalize_space(string(L), L0)
    ).

menu(Titre, Options, Cle) :-
    nl, writeln(Titre),
    forall(nth1(I, Options, _-Lib), format("  ~w) ~w~n", [I, Lib])),
    length(Options, N),
    repeat,
        format("Votre choix (1-~w) : ", [N]), flush_output,
        lire(L),
        number_string(I, L), integer(I), between(1, N, I), !,
    nth1(I, Options, Cle-_).

oui_non(Question) :-
    repeat,
        format("~n~w (o/n) : ", [Question]), flush_output,
        lire(L), string_lower(L, L1),
        ( member(L1, ["o","oui"]) -> R = oui
        ; member(L1, ["n","non"]) -> R = non
        ; fail ), !,
    R == oui.

texte_question(S, Q) :- question(S, Q), !.
texte_question(S, Q) :- description(S, D), !, format(atom(Q), 'Observez-vous : ~w ?', [D]).
texte_question(S, Q) :- texte_code(S, T), format(atom(Q), '~w ?', [T]).

% Pose une question (symptome ou condition) si la reponse n'est pas connue
poser(S) :- reponse(S, _), !.
poser(S) :-
    texte_question(S, Q),
    repeat,
        format("~n~w~n  [o]ui / [n]on / [?] ne sais pas / [p]ourquoi cette question : ", [Q]),
        flush_output,
        lire(L), string_lower(L, L1),
        traiter(L1, S), !.

traiter(R, S) :- member(R, ["o","oui"]), !, assertz(reponse(S, oui)).
traiter(R, S) :- member(R, ["n","non"]), !, assertz(reponse(S, non)).
traiter("?", S) :- !, assertz(reponse(S, inconnu)).
traiter(R, S) :- member(R, ["p","pourquoi"]), !, pourquoi_question(S), fail.

% Explique pourquoi la question est posee ("pourquoi cette question ?")
pourquoi_question(S) :-
    contexte(culture, C),
    findall(Nom-CF, (regle(M,S,CF), disease(M,Nom,C,_)), L),
    L \== [], !,
    writeln('  -> Ce signe est associé à :'),
    forall(member(Nom-CF, L),
           format("     - ~w (certitude ~w)~n", [Nom, CF])).
pourquoi_question(S) :-
    contexte(culture, C),
    findall(Nom, (favorable(M,S), disease(M,Nom,C,_)), L),
    L \== [], !,
    writeln('  -> Cette condition favorise :'),
    forall(member(Nom, L), format("     - ~w~n", [Nom])).
pourquoi_question(_) :- writeln('  -> Cette information précise le contexte.').

% ----------------------------------------------------------- programme
demarrer :-
    reinitialiser, retractall(candidat(_)),
    banniere,
    choisir_culture(C),
    choisir_mode,
    questions_contexte(C),
    boucle_organes(C),
    questions_conditions,
    affiner(C),
    classement(C, L),
    afficher(C, L),
    nl,
    ( oui_non('Faire un nouveau diagnostic ?') -> demarrer ; writeln('Au revoir.') ).

banniere :-
    nl,
    writeln('=============================================================='),
    writeln('  SYSTÈME EXPERT : diagnostic des maladies, ravageurs et'),
    writeln('  troubles physiologiques de la tomate et de la pomme de terre'),
    writeln('=============================================================='),
    writeln('Premier niveau de diagnostic uniquement : il ne remplace ni un'),
    writeln('agronome ni une analyse en laboratoire.').

choisir_culture(C) :-
    findall(X-X, crop(X,_), Opts),
    menu('Quelle culture est concernée ?', Opts, C),
    assertz(contexte(culture, C)).

choisir_mode :-
    menu('Quel est votre mode de production ?',
         [biologique-'Biologique', conventionnel-'Conventionnel'], M),
    assertz(contexte(mode, M)).

questions_contexte(C) :-
    menu('Où se trouve la culture ?',
         [plein_champ-'Plein champ', serre-'Sous serre / abri'], Lieu),
    ( Lieu == serre -> assertz(contexte(lieu, serre)) ; assertz(contexte(lieu, plein_champ)) ),
    deduire(Lieu),
    menu('Quelle est la saison ?',
         [printemps-'Printemps', ete-'Été', automne_hiver-'Automne / hiver'], Saison),
    assertz(contexte(saison, Saison)), deduire(Saison),
    menu('Quel temps a-t-il fait ces derniers jours ?',
         [humide_pluvieux-'Pluvieux / très humide', chaud_sec-'Chaud et sec',
          frais-'Frais', normal-'Normal / je ne sais pas'], Meteo),
    assertz(contexte(meteo, Meteo)), deduire(Meteo),
    stades(C, Ss),
    menu('Quel est le stade de la culture ?', Ss, Stade),
    assertz(contexte(stade, Stade)).

stades(tomate, [plantule-'Plantule / repiquage', croissance-'Croissance végétative',
                floraison-'Floraison', fructification-'Fructification / récolte']).
stades(pomme_de_terre, [plantule-'Levée / début de croissance', croissance-'Croissance végétative',
                tuberisation-'Tubérisation', maturation-'Maturation / sénescence']).

% une reponse generale confirme des conditions favorables
deduire(Rep) :-
    forall(( deduit(Rep, Cond), \+ reponse(Cond, _) ),
           assertz(reponse(Cond, oui))).

% ------------------------------------------------- organe -> symptomes
boucle_organes(C) :-
    organes_culture(C, Os),
    findall(O-Lib, (member(O, Os), organe_libelle(O, Lib)), Opts),
    menu('Quel organe est atteint ?', Opts, Organe),
    symptomes_organe(C, Organe, Ss),
    findall(S-D, (member(S, Ss), description(S, D)), SOpts0),
    append(SOpts0, [aucun-'Aucun de ceux-là / je ne sais pas'], SOpts),
    menu('Quel est le symptôme principal observé ?', SOpts, Principal),
    ( Principal == aucun -> true ; retractall(reponse(Principal,_)), assertz(reponse(Principal, oui)) ),
    candidats(C, Organe, Principal, Ms),
    forall(member(M, Ms), ( candidat(M) -> true ; assertz(candidat(M)) )),
    forall(( member(M, Ms), symptome_a_demander(M, Organe, S) ), poser(S)),
    (   oui_non('Voyez-vous aussi des symptômes sur un autre organe ?')
    ->  boucle_organes(C)
    ;   true
    ).

questions_conditions :-
    findall(Ctx, (candidat(M), favorable(M, Ctx), \+ reponse(Ctx,_)), L0),
    sort(L0, L),
    (   L == [] -> true
    ;   nl, writeln('--- Contexte de la culture ---'), forall(member(Ctx, L), poser(Ctx))
    ).

% ------------------------------------------- departage (cas incertains)
affiner(C) :-
    classement(C, L),
    L = [_-M1, _-M2|_],
    incertain(L), !,
    findall(S, depart(M1, M2, S), Ss0), sort(Ss0, Ss),
    (   Ss == [] -> true
    ;   nl, writeln('--- Diagnostic encore incertain : quelques questions pour départager ---'),
        forall(member(S, Ss), poser(S))
    ).
affiner(_).

% ----------------------------------------------------------- affichage
afficher(_, []) :- !,
    nl, writeln('Aucun diagnostic possible avec ces observations.'),
    writeln('Faites relire le problème par un agronome ou envoyez un échantillon à un laboratoire.').
afficher(_, L) :-
    nl, writeln('==================== RÉSULTAT ===================='),
    L = [Top-M1|_],
    findall(CF-M, (member(CF-M, L), CF > 0), Pos),
    prefixe(3, Pos, Haut),
    writeln('Causes probables (niveau de confiance) :'),
    forall(member(CF-M, Haut),
           ( disease(M, Nom, _, _), pourcent(CF, P), niveau(CF, N),
             format("  - ~w : ~w %  (confiance ~w)~n", [Nom, P, N]) )),
    nl,
    expliquer_diagnostic(M1),
    ( incertain(L) -> afficher_incertitude(L, Top) ; true ),
    plan_action(M1),
    avertissements(Haut).

prefixe(N, L, P) :- length(L, Len), ( Len =< N -> P = L ; length(P, N), append(P, _, L) ).

expliquer_diagnostic(M) :-
    disease(M, Nom, _, _),
    format("POURQUOI « ~w » ?~n", [Nom]),
    explication(M, Sym, Ctx, Abs),
    forall(member(S-C, Sym),
           ( ( description(S, D) -> true ; D = S ),
             format("  + signe observé : ~w (certitude du signe : ~w)~n", [D, C]) )),
    forall(member(X, Ctx),
           ( texte_code(X, Q),
             format("  + condition favorable confirmée : ~w~n", [Q]) )),
    forall(member(S, Abs),
           ( ( description(S, D) -> true ; D = S ),
             format("  - signe attendu mais absent : ~w (diminue la confiance)~n", [D]) )),
    ( cycle(M, Cy) -> format("~nCycle de la maladie :~n  ~w~n", [Cy]) ; true ).

afficher_incertitude(L, Top) :-
    nl, writeln('DIAGNOSTIC INCERTAIN : plusieurs pistes sont proches ou la confiance est faible.'),
    ( Top < 0.5 -> writeln('Confiance faible : validez avec un conseiller agricole.') ; true ),
    writeln('Observations complémentaires pour départager :'),
    prefixe(2, L, Deux),
    forall(( member(_-M, Deux), observation(M, Ob), disease(M, Nom, _, _) ),
           format("  * ~w : ~w~n", [Nom, Ob])),
    writeln('  * En cas de doute persistant, envoyez un échantillon à un laboratoire de phytopathologie.').

plan_action(M) :-
    contexte(mode, Mode),
    disease(M, Nom, _, _),
    nl, format("PLAN D'ACTION (~w) pour « ~w » :~n", [Mode, Nom]),
    ( traitement(M, Mode, Codes) -> true ; Codes = [] ),
    ( Codes \== []
    ->  forall(member(Code, Codes),
               ( texte_code(Code, T), format("  * ~w~n", [T]) ))
    ;   writeln('  (aucun traitement enregistré)')
    ),
    ( recommend(M, Actions)
    ->  nl, writeln('Mesures de gestion intégrée et de prévention :'),
        forall(( member(A, Actions), \+ memberchk(A, Codes) ),
               ( texte_code(A, T), format("  - ~w~n", [T]) ))
    ;   true ),
    nl, writeln('PRÉCAUTIONS D''EMPLOI ET DÉLAI AVANT RÉCOLTE :'),
    forall(precaution(commun, P), format("  ! ~w~n", [P])),
    forall(precaution(Mode, P), format("  ! ~w~n", [P])),
    writeln('  Ce système ne donne ni dose ni nom de produit : demandez conseil et lisez l''étiquette.').

avertissements(Haut) :-
    forall(( member(CF-M, Haut), CF >= 0.2, reglemente(M), message_reglemente(M, Msg) ),
           ( nl, format("ALERTE RÉGLEMENTAIRE : ~w~n", [Msg]) )).
