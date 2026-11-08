/*
  Expert system starter knowledge base: tomato and potato health problems.
  Run with SWI-Prolog. Example:
    ?- diagnose(tomate, [taches_huileuses_feuille, duvet_blanc_face_inferieure], R).
  Symptom names are atoms; see symptom/3 and examples/0.
  Management entries are general IPM measures, not pesticide prescriptions.
*/

:- use_module(library(lists)).
:- use_module(library(pairs)).

crop(tomate, maraichage).
crop(pomme_de_terre, maraichage).

% disease(Id, CommonName, Crop, CauseGroup)
disease(mildiou_tomate, 'Mildiou de la tomate', tomate, oomycete).
disease(alternariose_tomate, 'Alternariose de la tomate', tomate, champignon).
disease(oïdium_tomate, 'Oïdium', tomate, champignon).
disease(moisissure_grise, 'Pourriture grise (Botrytis)', tomate, champignon).
disease(chancres_tige, 'Chancre de tige (Didymella)', tomate, champignon).
disease(fusariose_tomate, 'Fusariose vasculaire', tomate, champignon).
disease(mildiou_pomme_de_terre, 'Mildiou de la pomme de terre', pomme_de_terre, oomycete).
disease(alternariose_pomme_de_terre, 'Alternariose de la pomme de terre', pomme_de_terre, champignon).
disease(gale_commune, 'Gale commune', pomme_de_terre, bacterie).
disease(gale_poudreuse, 'Gale poudreuse', pomme_de_terre, champignon).
disease(nematodes_kystes, 'Nématodes à kystes de la pomme de terre', pomme_de_terre, nematode).
disease(tuta_absoluta, 'Mineuse de la tomate (Tuta absoluta)', tomate, insecte).
disease(mineuse_feuille, 'Mineuse des feuilles (Liriomyza spp.)', tomate, insecte).
disease(pucerons, 'Pucerons', tomate, insecte).
disease(aleurodes, 'Aleurodes', tomate, insecte).
disease(acariens, 'Acariens tétranyques', tomate, acarien).
disease(virus_enroulement_tomate, 'Virus des feuilles jaunes en cuillère (TYLCV)', tomate, virus).
disease(tobrfv, 'Virus ToBRFV', tomate, virus).
disease(carence_calcique, 'Carence fonctionnelle en calcium / nécrose apicale', tomate, physiologique).
disease(eclatement_fruits, 'Éclatement physiologique des fruits', tomate, physiologique).

% symptom(Disease, Organ, ObservableSymptom)
symptom(mildiou_tomate, feuille, taches_huileuses_feuille).
symptom(mildiou_tomate, feuille, duvet_blanc_face_inferieure).
symptom(mildiou_tomate, tige, lesion_brune_allongee).
symptom(mildiou_tomate, fruit, tache_brune_dure_irreguliere).
symptom(alternariose_tomate, feuille, tache_brune_concentrique).
symptom(alternariose_tomate, feuille, jaunissement_autour_tache).
symptom(alternariose_tomate, tige, lesion_sombre_collet).
symptom(oïdium_tomate, feuille, poudre_blanche_feuille).
symptom(oïdium_tomate, feuille, jaunissement_feuille).
symptom(moisissure_grise, feuille, moisissure_grise_duveteuse).
symptom(moisissure_grise, tige, chancre_beige_tige).
symptom(moisissure_grise, fruit, pourriture_molle_grise).
symptom(chancres_tige, tige, chancre_sombre_tige).
symptom(chancres_tige, tige, points_noirs_sur_lesion).
symptom(chancres_tige, feuille, fletrissement_brutal).
symptom(fusariose_tomate, feuille, jaunissement_unilateral).
symptom(fusariose_tomate, feuille, fletrissement_progressif).
symptom(fusariose_tomate, tige, brunissement_vaisseaux).
symptom(mildiou_pomme_de_terre, feuille, tache_humide_irreguliere).
symptom(mildiou_pomme_de_terre, feuille, duvet_blanc_face_inferieure).
symptom(mildiou_pomme_de_terre, tubercule, pourriture_brune_tubercule).
symptom(alternariose_pomme_de_terre, feuille, tache_brune_concentrique).
symptom(alternariose_pomme_de_terre, feuille, jaunissement_feuille).
symptom(gale_commune, tubercule, lesion_corky_enfoncee_ou_surelevee).
symptom(gale_commune, tubercule, peau_rugueuse).
symptom(gale_poudreuse, tubercule, pustules_poudreuses_tubercule).
symptom(gale_poudreuse, racine, galles_racines).
symptom(nematodes_kystes, racine, petites_boules_blanches_ou_brunes_racines).
symptom(nematodes_kystes, feuille, croissance_en_taches_deprimees).
symptom(nematodes_kystes, feuille, jaunissement_fletrissement).
symptom(tuta_absoluta, feuille, galerie_mineuse_large_irreguliere).
symptom(tuta_absoluta, fruit, trou_entree_et_dejections).
symptom(tuta_absoluta, feuille, larve_dans_mine).
symptom(mineuse_feuille, feuille, galerie_sinueuse_fine).
symptom(mineuse_feuille, feuille, pupe_mineuse_visible).
symptom(pucerons, feuille, colonies_petits_insectes_sous_feuille).
symptom(pucerons, feuille, feuilles_enroulees_miellat).
symptom(pucerons, feuille, fumagine_sur_miellat).
symptom(aleurodes, feuille, petits_insectes_blancs_s_envolent).
symptom(aleurodes, feuille, miellat_fumagine).
symptom(aleurodes, feuille, jaunissement_feuille).
symptom(acariens, feuille, ponctuations_jaunes_feuille).
symptom(acariens, feuille, fines_toiles_sous_feuille).
symptom(virus_enroulement_tomate, feuille, feuille_jaune_enroulee_vers_haut).
symptom(virus_enroulement_tomate, plante, nanisme_et_raccourcissement_internoeuds).
symptom(virus_enroulement_tomate, fruit, petite_floraison_peu_de_fruits).
symptom(tobrfv, feuille, mosaique_et_deformation_feuille).
symptom(tobrfv, fruit, taches_jaunes_ou_brunissement_fruit).
symptom(tobrfv, fruit, fruits_bosseles_irreguliers).
symptom(carence_calcique, fruit, tache_noire_enfoncee_bout_floral).
symptom(carence_calcique, fruit, necrose_apicale).
symptom(eclatement_fruits, fruit, fissures_radiales_ou_concentriques).

% favorable(Disease, Context)
favorable(mildiou_tomate, humidite_foliaire_prolongee).
favorable(mildiou_tomate, temps_frais_humide).
favorable(alternariose_tomate, alternance_humidite_et_chaleur).
favorable(oïdium_tomate, forte_humidite_ambiante).
favorable(moisissure_grise, humidite_elevee_et_aeration_faible).
favorable(chancres_tige, saison_fraiche_humide).
favorable(fusariose_tomate, sol_contamine_et_temperature_chaude).
favorable(mildiou_pomme_de_terre, humidite_foliaire_et_nuits_fraiches).
favorable(alternariose_pomme_de_terre, chaleur_et_stress_plante).
favorable(gale_commune, sol_sec_pendant_tuberisation).
favorable(gale_poudreuse, sol_humide_frais).
favorable(nematodes_kystes, sol_contamine_et_rotation_courte).
favorable(tuta_absoluta, presence_plantes_hotes_et_temperature_douce).
favorable(mineuse_feuille, presence_adultes_et_temperature_douce).
favorable(pucerons, pousse_tendre_et_temps_doux).
favorable(aleurodes, temps_chaud_et_culture_abritee).
favorable(acariens, temps_chaud_sec).
favorable(virus_enroulement_tomate, presence_aleurodes_vecteurs).
favorable(tobrfv, semences_plants_outils_contamines).
favorable(carence_calcique, irrigation_irreguliere_et_croissance_rapide).
favorable(eclatement_fruits, alternance_secheresse_et_apport_eau_abondant).

% action(Disease, IntegratedManagement)
action(mildiou_tomate, [retirer_et_detruire_organes_atteints, reduire_mouillage_foliaire, aerer_la_culture, utiliser_variete_adaptee, demander_conseil_local_si_progression]).
action(alternariose_tomate, [enlever_residus_infectes, rotation_hors_solanacees, eviter_arrosage_sur_feuillage, surveiller_bas_de_culture]).
action(oïdium_tomate, [retirer_feuilles_tres_atteintes, aerer_la_culture, limiter_exces_d_azote, verifier_diagnostic]).
action(moisissure_grise, [enlever_tissus_morts_et_fruits_pourris, aerer_serre, eviter_blessures_et_mouillage_prolonge]).
action(chancres_tige, [eliminer_debris_et_tuteurs_contamines, pratiquer_rotation, desinfecter_outils, eviter_blessures]).
action(fusariose_tomate, [utiliser_varietes_resistantes, rotation_longue, solarisation_si_adaptee, confirmer_par_analyse_si_fletrissement]).
action(mildiou_pomme_de_terre, [utiliser_plants_sains, detruire_fanes_ou_debris_infectes, assurer_bonne_aeration, solliciter_avis_technique_rapidement]).
action(alternariose_pomme_de_terre, [rotation, eliminer_residus, maintenir_vigueur_par_irrigation_reguliere, surveiller_les_premieres_taches]).
action(gale_commune, [plants_certifies, rotation, maintenir_humidite_du_sol_reguliere_a_tuberisation, ne_pas_replanter_tubercules_malades]).
action(gale_poudreuse, [plants_sains, rotation, eviter_deplacer_sol_contamine, confirmer_avant_mesure_lourde]).
action(nematodes_kystes, [isoler_et_signaler_suspicion_aux_services_phytosanitaires, nettoyer_materiel_et_outils, rotation_longue, faire_analyser_sol, utiliser_variete_resistante_validee]).
action(tuta_absoluta, [surveiller_piege_pheromone, poser_filet_insect_proof, retirer_et_detruire_feuilles_et_fruits_mines, favoriser_auxiliaires, alterner_modes_de_lutte_homologues_selon_conseil_local]).
action(mineuse_feuille, [retirer_feuilles_fortement_minees, surveiller_pieges, proteger_auxiliaires, eviter_traitements_non_cibles]).
action(pucerons, [surveiller_face_inferieure, favoriser_coccinelles_et_auxiliaires, eliminer_foyers_limites, eviter_exces_azote]).
action(aleurodes, [utiliser_plants_sains_et_filets, surveiller_pieges, enlever_plantes_hotes_et_debris, favoriser_auxiliaires, gerer_vecteurs_des_virus]).
action(acariens, [limiter_stress_hydrique, surveiller_a_la_loupe, retirer_folioles_tres_atteintes, proteger_acariens_predateurs]).
action(virus_enroulement_tomate, [arracher_plants_symptomatiques, utiliser_plants_sains, controler_aleurodes_par_IPM, retirer_adventices_hotes]).
action(tobrfv, [isoler_et_retirer_plants_suspects, utiliser_semences_et_plants_certifies, nettoyer_et_desinfecter_outils, eviter_manipulation_de_plants_mouilles, demander_confirmation_laboratoire]).
action(carence_calcique, [regulariser_irrigation, maintenir_calcium_disponible_et_ph_adapte, eviter_exces_salinite_ou_azote, retirer_fruits_atteints]).
action(eclatement_fruits, [regulariser_apports_d_eau, pailler_si_adapte, recolter_a_maturite, choisir_varietes_moins_sensibles]).

% Generic scoring: confidence is a transparent symptom-match fraction, not a
% laboratory probability. A candidate needs at least one observed symptom.
diagnose(Crop, Observed, Result) :-
    diagnoses(Crop, Observed, [Result|_]).

diagnoses(Crop, Observed, Results) :-
    findall(Score-candidate(Disease,Name,Group,Score,Hits),
      ( disease(Disease,Name,Crop,Group),
        findall(S,symptom(Disease,_,S),All0), sort(All0,All),
        intersection(All,Observed,Hits), length(All,Total), length(Hits,N),
        N > 0, Score is round(100*N/Total)
      ), Pairs),
    keysort(Pairs, Asc), reverse(Asc, Desc), pairs_values(Desc, Results).

recommend(Disease, Actions) :- action(Disease, Actions).
problem_summary(Disease, Name, Crop, Group) :- disease(Disease,Name,Crop,Group).

examples :-
    diagnose(tomate, [taches_huileuses_feuille,duvet_blanc_face_inferieure], R), writeln(R),
    recommend(mildiou_tomate, A), writeln(A).

