/*
  tests.pl : tests automatiques (plunit)
  Lancer :  swipl -g run_tests -t halt tests.pl
*/
:- encoding(utf8).
:- [knowledge_base].
:- [regles_cf].
:- [questions].
:- [traitements].
:- [moteur].
:- use_module(library(plunit)).

% scenario(+Culture, +Stade, +Symptomes, +Conditions)
scenario(C, Stade, Syms, Conds) :-
    reinitialiser,
    assertz(contexte(culture, C)),
    assertz(contexte(stade, Stade)),
    forall(member(S, Syms),  assertz(reponse(S, oui))),
    forall(member(X, Conds), assertz(reponse(X, oui))).

% helpers definis dans user (les tests plunit tournent dans un autre module)
rep(S, V) :- assertz(reponse(S, V)).
stade(S) :- retractall(contexte(stade,_)), assertz(contexte(stade, S)).

premier(C, M) :- classement(C, [_-M|_]).

diag(C, Stade, Syms, Conds, Attendu) :-
    scenario(C, Stade, Syms, Conds), premier(C, Attendu).

:- begin_tests(diagnostic, [cleanup(reinitialiser)]).

test(mildiou_tomate) :-
    diag(tomate, floraison, [taches_huileuses_feuille, duvet_blanc_face_inferieure],
         [humidite_foliaire_prolongee], mildiou_tomate).
test(alternariose_tomate) :-
    diag(tomate, fructification, [tache_brune_concentrique, jaunissement_autour_tache], [], alternariose_tomate).
test(oidium) :-
    diag(tomate, croissance, [poudre_blanche_feuille], [forte_humidite_ambiante], oidium_tomate).
test(botrytis) :-
    diag(tomate, fructification, [moisissure_grise_duveteuse, pourriture_molle_grise], [], moisissure_grise).
test(chancre) :-
    diag(tomate, croissance, [chancre_sombre_tige, points_noirs_sur_lesion], [], chancres_tige).
test(fusariose) :-
    diag(tomate, floraison, [brunissement_vaisseaux, jaunissement_unilateral], [], fusariose_tomate).
test(tuta) :-
    diag(tomate, fructification, [galerie_mineuse_large_irreguliere, larve_dans_mine], [], tuta_absoluta).
test(mineuse) :-
    diag(tomate, croissance, [galerie_sinueuse_fine], [], mineuse_feuille).
test(pucerons) :-
    diag(tomate, croissance, [colonies_petits_insectes_sous_feuille, feuilles_enroulees_miellat], [], pucerons).
test(aleurodes) :-
    diag(tomate, croissance, [petits_insectes_blancs_s_envolent], [], aleurodes).
test(acariens) :-
    diag(tomate, croissance, [fines_toiles_sous_feuille], [temps_chaud, temps_sec], acariens).
test(tylcv) :-
    diag(tomate, croissance, [feuille_jaune_enroulee_vers_haut, nanisme_et_raccourcissement_internoeuds], [], virus_enroulement_tomate).
test(carence_calcique) :-
    diag(tomate, fructification, [tache_noire_enfoncee_bout_floral], [], carence_calcique).
test(eclatement) :-
    diag(tomate, fructification, [fissures_radiales_ou_concentriques], [], eclatement_fruits).
test(mildiou_pdt) :-
    diag(pomme_de_terre, croissance, [tache_humide_irreguliere, duvet_blanc_face_inferieure], [], mildiou_pomme_de_terre).
test(gale_commune) :-
    diag(pomme_de_terre, tuberisation, [lesion_corky_enfoncee_ou_surelevee, peau_rugueuse], [], gale_commune).
test(nematodes) :-
    diag(pomme_de_terre, croissance, [petites_boules_blanches_ou_brunes_racines], [], nematodes_kystes).

% la culture filtre les maladies
test(filtre_culture) :-
    scenario(tomate, croissance, [duvet_blanc_face_inferieure], []),
    classement(tomate, L), \+ member(_-mildiou_pomme_de_terre, L).

% formule MYCIN : 0.8 + 0.6*(1-0.8) = 0.92
test(formule_mycin) :-
    scenario(tomate, croissance, [duvet_blanc_face_inferieure, taches_huileuses_feuille], []),
    cf_symptomes(mildiou_tomate, CF), abs(CF - 0.92) < 1.0e-9.

% le contexte favorable augmente la confiance
test(contexte_augmente) :-
    scenario(tomate, plantule, [taches_huileuses_feuille], []),
    cf_maladie(mildiou_tomate, A),
    rep(humidite_foliaire_prolongee, oui),
    cf_maladie(mildiou_tomate, B), B > A.

% un signe attendu declare absent diminue la confiance
test(signe_absent_diminue) :-
    scenario(tomate, plantule, [taches_huileuses_feuille], []),
    cf_maladie(mildiou_tomate, A),
    rep(duvet_blanc_face_inferieure, non),
    cf_maladie(mildiou_tomate, B), B < A.

% le stade sensible augmente la confiance
test(stade_sensible) :-
    scenario(tomate, plantule, [taches_huileuses_feuille], []),
    cf_maladie(mildiou_tomate, A),
    stade(floraison),
    cf_maladie(mildiou_tomate, B), B > A.

% sans symptome observe : aucun diagnostic (le contexte seul ne suffit pas)
test(sans_symptome) :-
    scenario(tomate, floraison, [], [humidite_foliaire_prolongee, temps_frais]),
    classement(tomate, []).

% un signe banal et partage -> diagnostic incertain
test(incertain) :-
    scenario(tomate, croissance, [jaunissement_feuille], []),
    classement(tomate, L), incertain(L).

% un diagnostic net n'est pas incertain
test(net_pas_incertain, [fail]) :-
    scenario(tomate, floraison, [poudre_blanche_feuille, jaunissement_feuille], [forte_humidite_ambiante]),
    classement(tomate, L), incertain(L).

% les maladies reglementees ont un message
test(reglemente) :-
    reglemente(tobrfv), message_reglemente(tobrfv, _),
    reglemente(nematodes_kystes), message_reglemente(nematodes_kystes, _).

:- end_tests(diagnostic).

% coherence de la base : chaque maladie a regles, traitements (2 modes), cycle, observation
:- begin_tests(coherence).
test(complet) :-
    forall(disease(M,_,_,_),
      (  regle(M,_,_), traitement(M, biologique, _), traitement(M, conventionnel, _),
         cycle(M,_), observation(M,_), action(M,_) )).
test(regle_correspond_symptome) :-
    forall(regle(M,S,_), symptom(M,_,S)).
test(symptome_a_une_regle) :-
    forall(symptom(M,_,S), regle(M,S,_)).
test(cf_valides) :-
    forall(regle(_,_,C), (C > 0, C < 1)).
test(description_pour_chaque_symptome) :-
    forall(symptom(_,_,S), description(S,_)).
test(question_pour_chaque_condition) :-
    forall(favorable(_,X), question(X,_)).
test(au_moins_15_problemes) :-
    aggregate_all(count, disease(_,_,_,_), N), N >= 15.
:- end_tests(coherence).
