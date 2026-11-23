/*
  questions.pl : textes affiches a l'utilisateur (francais)

  description(Symptome, Texte) : description courte d'un signe observable.
      La question posee est construite : "Observez-vous : <description> ?"
  question(Condition, Texte)   : question sur une condition favorable.
  organe_libelle/2             : noms d'organes pour les menus.
*/
:- encoding(utf8).

organe_libelle(feuille,   'Feuilles').
organe_libelle(tige,      'Tiges').
organe_libelle(fruit,     'Fruits').
organe_libelle(racine,    'Racines').
organe_libelle(tubercule, 'Tubercules').
organe_libelle(plante,    'Plante entière (port général)').

% --- Symptomes ---
description(taches_huileuses_feuille,   'des taches d''aspect huileux ou détrempé sur les feuilles').
description(duvet_blanc_face_inferieure,'un duvet blanc sous les feuilles, en face des taches').
description(lesion_brune_allongee,      'une lésion brune allongée sur la tige').
description(tache_brune_dure_irreguliere,'une tache brune, dure et irrégulière sur le fruit').
description(tache_brune_concentrique,   'des taches brunes avec des anneaux concentriques (aspect de cible)').
description(jaunissement_autour_tache,  'un halo jaune autour des taches').
description(lesion_sombre_collet,       'une lésion sombre au collet (base de la tige)').
description(poudre_blanche_feuille,     'une poudre blanche, comme de la farine, sur les feuilles').
description(jaunissement_feuille,       'un jaunissement des feuilles').
description(moisissure_grise_duveteuse, 'une moisissure grise et duveteuse sur les feuilles').
description(chancre_beige_tige,         'un chancre beige sur la tige (souvent à une plaie de taille)').
description(pourriture_molle_grise,     'une pourriture molle recouverte de moisissure grise sur les fruits').
description(chancre_sombre_tige,        'un chancre sombre sur la tige').
description(points_noirs_sur_lesion,    'de petits points noirs (visibles à la loupe) sur la lésion').
description(fletrissement_brutal,       'un flétrissement brutal d''une partie de la plante').
description(jaunissement_unilateral,    'un jaunissement qui touche un seul côté de la plante ou de la feuille').
description(fletrissement_progressif,   'un flétrissement progressif, d''abord aux heures chaudes').
description(brunissement_vaisseaux,     'un brunissement des vaisseaux quand on coupe la tige en long').
description(tache_humide_irreguliere,   'des taches humides, irrégulières, qui brunissent').
description(pourriture_brune_tubercule, 'une pourriture brune et sèche dans le tubercule').
description(lesion_corky_enfoncee_ou_surelevee,'des lésions liégeuses (comme du liège), en creux ou en relief, sur la peau du tubercule').
description(peau_rugueuse,              'une peau rugueuse du tubercule').
description(pustules_poudreuses_tubercule,'des pustules qui libèrent une poudre brune sur le tubercule').
description(galles_racines,             'des galles (boules) sur les racines').
description(petites_boules_blanches_ou_brunes_racines,'de petites boules blanches, jaunes puis brunes (taille d''une tête d''épingle) sur les racines').
description(croissance_en_taches_deprimees,'des zones du champ où la culture pousse mal, en taches').
description(jaunissement_fletrissement, 'un jaunissement suivi d''un flétrissement des plantes').
description(galerie_mineuse_large_irreguliere,'une galerie large et irrégulière (mine) dans la feuille').
description(trou_entree_et_dejections,  'un petit trou d''entrée avec des déjections noires sur le fruit').
description(larve_dans_mine,            'une petite larve visible en ouvrant la mine').
description(galerie_sinueuse_fine,      'une galerie fine et sinueuse dans la feuille').
description(pupe_mineuse_visible,       'de petites pupes (cocons) visibles sur ou sous la feuille').
description(colonies_petits_insectes_sous_feuille,'des colonies de petits insectes (verts, noirs...) sous les feuilles ou sur les jeunes pousses').
description(feuilles_enroulees_miellat, 'des feuilles enroulées et collantes (miellat)').
description(fumagine_sur_miellat,       'une suie noire (fumagine) sur les feuilles collantes').
description(petits_insectes_blancs_s_envolent,'de petits insectes blancs qui s''envolent quand on secoue la plante').
description(miellat_fumagine,           'du miellat collant avec de la suie noire sur les feuilles').
description(ponctuations_jaunes_feuille,'de fines ponctuations jaunes sur les feuilles').
description(fines_toiles_sous_feuille,  'de fines toiles sous les feuilles').
description(feuille_jaune_enroulee_vers_haut,'des feuilles jaunes, petites et enroulées en cuillère vers le haut').
description(nanisme_et_raccourcissement_internoeuds,'un nanisme de la plante avec des entre-nœuds raccourcis').
description(petite_floraison_peu_de_fruits,'très peu de fleurs ou de fruits noués').
description(mosaique_et_deformation_feuille,'une mosaïque (zones vert clair / vert foncé) ou des feuilles déformées').
description(taches_jaunes_ou_brunissement_fruit,'des taches jaunes ou un brunissement irrégulier des fruits').
description(fruits_bosseles_irreguliers,'des fruits bosselés ou de maturation irrégulière').
description(tache_noire_enfoncee_bout_floral,'une tache noire enfoncée à l''extrémité du fruit (côté fleur)').
description(necrose_apicale,             'une nécrose (zone morte) à l''extrémité du fruit').
description(fissures_radiales_ou_concentriques,'des fissures en étoile ou en cercles autour du pédoncule du fruit').

% --- Conditions favorables (contexte) ---
question(humidite_foliaire_prolongee, 'Le feuillage est-il resté mouillé longtemps (rosée, pluie, arrosage par aspersion) ces derniers jours ?').
question(temps_frais,        'Les températures récentes ont-elles été fraîches (environ 10 à 20 °C) ?').
question(temps_humide,       'A-t-il plu ou fait très humide ces derniers jours ?').
question(alternance_humide_sec,'Avez-vous eu une alternance de périodes humides (rosée, pluie) et de périodes sèches ?').
question(temps_chaud,        'Fait-il chaud en ce moment (journées au-dessus de 28-30 °C) ?').
question(forte_humidite_ambiante,'L''humidité de l''air est-elle élevée (serre fermée, brouillard, temps couvert) ?').
question(aeration_faible,    'La culture est-elle dense ou peu aérée (serre peu ventilée, plants serrés) ?').
question(saison_fraiche_humide,'Sommes-nous en saison fraîche et humide (automne-hiver) ?').
question(sol_contamine,      'Cette parcelle a-t-elle déjà eu le même problème, ou la culture précédente était-elle une solanacée ?').
question(nuits_fraiches,     'Les nuits sont-elles fraîches avec de la rosée ?').
question(stress_plante,      'La plante est-elle stressée (manque d''eau, carence, fructification chargée, vieillissement) ?').
question(sol_sec,            'Le sol a-t-il été plutôt sec pendant la formation des tubercules ?').
question(sol_humide,         'Le sol est-il resté humide, mal drainé ?').
question(rotation_courte,    'La pomme de terre (ou une solanacée) est-elle revenue sur la parcelle en moins de 4 ans ?').
question(presence_plantes_hotes,'Y a-t-il des plantes hôtes proches (solanacées, adventices, cultures voisines atteintes) ?').
question(temps_doux,         'Le temps est-il doux (environ 15 à 25 °C) ?').
question(presence_adultes,   'Avez-vous vu des petits adultes volants (mouches) autour des plants ?').
question(pousse_tendre,      'La plante est-elle en pleine croissance, avec des pousses tendres ?').
question(culture_abritee,    'La culture est-elle sous serre ou sous abri ?').
question(temps_sec,          'Le temps est-il sec ?').
question(presence_aleurodes, 'Avez-vous observé des aleurodes (petites mouches blanches) sur la culture ou à proximité ?').
question(materiel_contamine, 'Les semences, plants, outils ou mains ont-ils été en contact avec des plants suspects ou d''origine incertaine ?').
question(irrigation_irreguliere,'L''irrigation est-elle irrégulière (périodes de manque d''eau puis excès) ?').
question(croissance_rapide,  'La croissance a-t-elle été très rapide (forte chaleur, apport d''azote élevé) ?').
question(secheresse_puis_arrosage_abondant,'Les fissures sont-elles apparues après une période sèche suivie d''un arrosage ou d''une pluie abondants ?').
