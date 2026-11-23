/*
  regles_cf.pl : facteurs de certitude (style MYCIN)

  regle(Maladie, Symptome, CF)
     CF in ]0,1[ : force avec laquelle l'observation du symptome confirme la
     maladie. Un symptome caracteristique a un CF fort (0.8-0.9), un symptome
     banal ou partage avec d'autres problemes a un CF faible (0.2-0.4).

  ATTENTION : ces coefficients sont des estimations d'expert (prototype
  academique). Ils sont a justifier dans le rapport et a faire valider par un
  agronome. Voir aussi SOURCES_KB.md.
*/
:- encoding(utf8).
:- discontiguous regle/3.

% --- Tomate : maladies fongiques / oomycetes ---
regle(mildiou_tomate, taches_huileuses_feuille,       0.6).
regle(mildiou_tomate, duvet_blanc_face_inferieure,    0.8).
regle(mildiou_tomate, lesion_brune_allongee,          0.4).
regle(mildiou_tomate, tache_brune_dure_irreguliere,   0.5).

regle(alternariose_tomate, tache_brune_concentrique,  0.8).
regle(alternariose_tomate, jaunissement_autour_tache, 0.4).
regle(alternariose_tomate, lesion_sombre_collet,      0.4).

regle(oidium_tomate, poudre_blanche_feuille,          0.9).
regle(oidium_tomate, jaunissement_feuille,            0.2).

regle(moisissure_grise, moisissure_grise_duveteuse,   0.8).
regle(moisissure_grise, chancre_beige_tige,           0.5).
regle(moisissure_grise, pourriture_molle_grise,       0.7).

regle(chancres_tige, chancre_sombre_tige,             0.6).
regle(chancres_tige, points_noirs_sur_lesion,         0.8).
regle(chancres_tige, fletrissement_brutal,            0.4).

regle(fusariose_tomate, jaunissement_unilateral,      0.6).
regle(fusariose_tomate, fletrissement_progressif,     0.4).
regle(fusariose_tomate, brunissement_vaisseaux,       0.8).

% --- Pomme de terre ---
regle(mildiou_pomme_de_terre, tache_humide_irreguliere,    0.5).
regle(mildiou_pomme_de_terre, duvet_blanc_face_inferieure, 0.8).
regle(mildiou_pomme_de_terre, pourriture_brune_tubercule,  0.6).

regle(alternariose_pomme_de_terre, tache_brune_concentrique, 0.8).
regle(alternariose_pomme_de_terre, jaunissement_feuille,     0.2).

regle(gale_commune, lesion_corky_enfoncee_ou_surelevee, 0.8).
regle(gale_commune, peau_rugueuse,                      0.5).

regle(gale_poudreuse, pustules_poudreuses_tubercule,    0.8).
regle(gale_poudreuse, galles_racines,                   0.6).

regle(nematodes_kystes, petites_boules_blanches_ou_brunes_racines, 0.8).
regle(nematodes_kystes, croissance_en_taches_deprimees,            0.5).
regle(nematodes_kystes, jaunissement_fletrissement,                0.3).

% --- Ravageurs ---
regle(tuta_absoluta, galerie_mineuse_large_irreguliere, 0.7).
regle(tuta_absoluta, trou_entree_et_dejections,         0.6).
regle(tuta_absoluta, larve_dans_mine,                   0.8).

regle(mineuse_feuille, galerie_sinueuse_fine,           0.7).
regle(mineuse_feuille, pupe_mineuse_visible,            0.5).

regle(pucerons, colonies_petits_insectes_sous_feuille,  0.8).
regle(pucerons, feuilles_enroulees_miellat,             0.5).
regle(pucerons, fumagine_sur_miellat,                   0.4).

regle(aleurodes, petits_insectes_blancs_s_envolent,     0.9).
regle(aleurodes, miellat_fumagine,                      0.4).
regle(aleurodes, jaunissement_feuille,                  0.2).

regle(acariens, ponctuations_jaunes_feuille,            0.5).
regle(acariens, fines_toiles_sous_feuille,              0.9).

% --- Virus ---
regle(virus_enroulement_tomate, feuille_jaune_enroulee_vers_haut,       0.8).
regle(virus_enroulement_tomate, nanisme_et_raccourcissement_internoeuds, 0.5).
regle(virus_enroulement_tomate, petite_floraison_peu_de_fruits,          0.4).

regle(tobrfv, mosaique_et_deformation_feuille,          0.5).
regle(tobrfv, taches_jaunes_ou_brunissement_fruit,      0.6).
regle(tobrfv, fruits_bosseles_irreguliers,              0.6).

% --- Troubles physiologiques ---
regle(carence_calcique, tache_noire_enfoncee_bout_floral, 0.8).
regle(carence_calcique, necrose_apicale,                  0.8).

regle(eclatement_fruits, fissures_radiales_ou_concentriques, 0.9).

/* Parametres de l'inference (a decrire dans le rapport) */
poids_contexte_favorable(0.2).    % une condition favorable confirmee : CF +0.2
poids_contexte_defavorable(0.1).  % condition favorable declaree absente : CF x (1-0.1)
poids_stade(0.1).                 % le stade de culture est un stade sensible
facteur_negatif(0.4).             % symptome attendu declare absent : -0.4 * CF

/* Stades de culture sensibles (estimations a valider).
   Stades tomate : plantule, croissance, floraison, fructification
   Stades pomme de terre : plantule, croissance, tuberisation, maturation */
stade_sensible(mildiou_tomate,              [croissance, floraison, fructification]).
stade_sensible(alternariose_tomate,         [floraison, fructification]).
stade_sensible(oidium_tomate,               [croissance, floraison, fructification]).
stade_sensible(moisissure_grise,            [floraison, fructification]).
stade_sensible(chancres_tige,               [croissance, floraison]).
stade_sensible(fusariose_tomate,            [floraison, fructification]).
stade_sensible(mildiou_pomme_de_terre,      [croissance, tuberisation]).
stade_sensible(alternariose_pomme_de_terre, [tuberisation, maturation]).
stade_sensible(gale_commune,                [tuberisation]).
stade_sensible(gale_poudreuse,              [tuberisation, maturation]).
stade_sensible(nematodes_kystes,            [croissance, tuberisation]).
stade_sensible(carence_calcique,            [fructification]).
stade_sensible(eclatement_fruits,           [fructification]).

/* Contexte general declare au debut du dialogue -> conditions deduites.
   deduit(ReponseGenerale, ConditionFavorable) */
deduit(serre,          culture_abritee).
deduit(automne_hiver,  saison_fraiche_humide).
deduit(automne_hiver,  temps_frais).
deduit(printemps,      temps_doux).
deduit(ete,            temps_chaud).
deduit(humide_pluvieux, temps_humide).
deduit(humide_pluvieux, forte_humidite_ambiante).
deduit(chaud_sec,      temps_chaud).
deduit(chaud_sec,      temps_sec).
deduit(frais,          temps_frais).
