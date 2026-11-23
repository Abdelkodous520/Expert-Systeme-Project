/*
  traitements.pl : plan d'action, cycle de la maladie, observations de depart

  POLITIQUE DE PRUDENCE : aucune dose, aucune matiere active precise, aucun
  delai avant recolte chiffre. Les traitements sont des FAMILLES de solutions ;
  le choix du produit se fait avec un conseiller agricole et l'etiquette
  (homologation ONSSA).

  traitement(Maladie, Mode, [Codes])   Mode = biologique | conventionnel
  libelle(Code, Texte)                 texte lisible d'un code
  cycle(Maladie, Texte)                dimension pedagogique
  observation(Maladie, Texte)          observation pour confirmer / departager
  reglemente(Maladie)                  suspicion a signaler aux services officiels
*/
:- encoding(utf8).

% ---------------------------------------------------------------- libelles
libelle(produit_cuivre_bio,
  'Produit à base de cuivre autorisé en agriculture biologique (préventif, à renouveler selon l''étiquette)').
libelle(soufre_bio,
  'Soufre mouillable autorisé en bio (à éviter par forte chaleur : risque de brûlures)').
libelle(biocontrole_bacillus,
  'Produit de biocontrôle à base de Bacillus, selon homologation ONSSA').
libelle(bt_bio,
  'Bacillus thuringiensis (Bt) homologué, efficace surtout sur jeunes larves').
libelle(savon_huile_bio,
  'Savon insecticide ou huile autorisés en bio, sur foyers localisés').
libelle(auxiliaires,
  'Conservation ou lâchers d''auxiliaires (coccinelles, chrysopes, punaises prédatrices, parasitoïdes selon le ravageur)').
libelle(piegeage,
  'Piégeage (phéromone, pièges chromatiques collants) pour surveiller et réduire les populations').
libelle(acariens_predateurs,
  'Acariens prédateurs (lâchers) et gestion de l''humidité de la serre').
libelle(fongicide_homologue,
  'Fongicide homologué ONSSA pour cette culture et cette cible, choisi avec un conseiller (alterner les modes d''action)').
libelle(insecticide_homologue,
  'Insecticide ou acaricide homologué ONSSA pour cette culture et cette cible, choisi avec un conseiller (alterner les modes d''action, protéger les auxiliaires et les pollinisateurs)').
libelle(aucun_curatif,
  'Aucun traitement curatif réellement efficace : la prévention et l''élimination des plants atteints sont les leviers principaux').
libelle(attendre_confirmation_officielle,
  'Ne rien appliquer avant la confirmation officielle : suivre les consignes des services phytosanitaires').
libelle(calcium_conseille,
  'Apport de calcium en complément seulement si un conseiller le confirme (le vrai levier est la régularité de l''eau)').

% Libelle par defaut : "retirer_et_detruire_x" -> "Retirer et détruire x"
texte_code(Code, Texte) :- libelle(Code, Texte), !.
texte_code(Code, Texte) :-
    atomic_list_concat(Parts0, '_', Code),
    maplist(mot, Parts0, Parts1),
    elide(Parts1, Parts2),
    atomic_list_concat(Parts2, ' ', T0),
    sub_atom(T0, 0, 1, _, F), sub_atom(T0, 1, _, 0, R),
    upcase_atom(F, FU), atom_concat(FU, R, Texte).

mot(W, A) :- accent(W, A), !.
mot(W, W).

% "d eau" -> "d'eau" ; "s envolent" -> "s'envolent"
elide([], []).
elide([E, W|T], [A|T2]) :- memberchk(E, [d, s, l]), !,
    atomic_list_concat([E, '\'', W], A), elide(T, T2).
elide([W|T], [W|T2]) :- elide(T, T2).

accent(a, 'à').                 accent(detruire, 'détruire').
accent(reduire, 'réduire').     accent(variete, 'variété').
accent(varietes, 'variétés').   accent(aerer, 'aérer').
accent(aeration, 'aération').   accent(eviter, 'éviter').
accent(residus, 'résidus').     accent(debris, 'débris').
accent(regulariser, 'régulariser'). accent(recolter, 'récolter').
accent(maturite, 'maturité').   accent(humidite, 'humidité').
accent(eliminer, 'éliminer').   accent(desinfecter, 'désinfecter').
accent(deplacer, 'déplacer').   accent(resistante, 'résistante').
accent(resistantes, 'résistantes'). accent(verifier, 'vérifier').
accent(reguliere, 'régulière'). accent(materiel, 'matériel').
accent(hotes, 'hôtes').         accent(controler, 'contrôler').
accent(piege, 'piège').         accent(pheromone, 'phéromone').
accent(proteger, 'protéger').   accent(exces, 'excès').
accent(salinite, 'salinité').   accent(adapte, 'adapté').
accent(adaptee, 'adaptée').     accent(contamines, 'contaminés').
accent(minees, 'minées').       accent(mines, 'minés').
accent(tuberisation, 'tubérisation'). accent(homologues, 'homologués').
accent(tres, 'très').           accent(variete_adaptee, 'variété adaptée').
accent(tissus, tissus).         accent(confirmer, confirmer).
accent(analyse, analyse).       accent(solliciter, solliciter).
accent(eclatement, 'éclatement'). accent(etiquette, 'étiquette').
accent(apports, apports).       accent(rotation, rotation).
accent(foliaire, foliaire).     accent(arrosage, arrosage).
accent(fletrissement, 'flétrissement'). accent(feuilles, feuilles).
accent(isoler, isoler).         accent(signaler, signaler).
accent(utiliser, utiliser).     accent(pratiquer, pratiquer).
accent(favoriser, favoriser).   accent(alterner, alterner).
accent(modes, modes).           accent(lutte, lutte).
accent(local, local).           accent(demander, demander).
accent(conseil, conseil).       accent(progression, progression).
accent(si, si).                 accent(surveiller, surveiller).
accent(presence, 'présence').   accent(temperature, 'température').
accent(forte, forte).           accent(prolongee, 'prolongée').
accent(abritee, 'abritée').     accent(rapide, rapide).
accent(irreguliere, 'irrégulière'). accent(secheresse, 'sécheresse').
accent(precedente, 'précédente'). accent(deja, 'déjà').
accent(nuits, nuits).           accent(frais, frais).
accent(contamine, 'contaminé'). accent(pieges, 'pièges').       accent(gerer, 'gérer').
accent(surveillance, surveillance).

% ------------------------------------------------------------ traitements
traitement(mildiou_tomate, biologique,
  [produit_cuivre_bio, retirer_et_detruire_organes_atteints, reduire_mouillage_foliaire]).
traitement(mildiou_tomate, conventionnel,
  [fongicide_homologue, retirer_et_detruire_organes_atteints, reduire_mouillage_foliaire]).

traitement(alternariose_tomate, biologique,
  [produit_cuivre_bio, enlever_residus_infectes, eviter_arrosage_sur_feuillage]).
traitement(alternariose_tomate, conventionnel,
  [fongicide_homologue, enlever_residus_infectes, eviter_arrosage_sur_feuillage]).

traitement(oidium_tomate, biologique,
  [soufre_bio, biocontrole_bacillus, retirer_feuilles_tres_atteintes]).
traitement(oidium_tomate, conventionnel,
  [fongicide_homologue, retirer_feuilles_tres_atteintes]).

traitement(moisissure_grise, biologique,
  [biocontrole_bacillus, enlever_tissus_morts_et_fruits_pourris, aerer_serre]).
traitement(moisissure_grise, conventionnel,
  [fongicide_homologue, enlever_tissus_morts_et_fruits_pourris, aerer_serre]).

traitement(chancres_tige, biologique,
  [produit_cuivre_bio, eliminer_debris_et_tuteurs_contamines, desinfecter_outils]).
traitement(chancres_tige, conventionnel,
  [fongicide_homologue, eliminer_debris_et_tuteurs_contamines, desinfecter_outils]).

traitement(fusariose_tomate, biologique,
  [aucun_curatif, utiliser_varietes_resistantes, solarisation_si_adaptee]).
traitement(fusariose_tomate, conventionnel,
  [aucun_curatif, utiliser_varietes_resistantes, rotation_longue]).

traitement(mildiou_pomme_de_terre, biologique,
  [produit_cuivre_bio, detruire_fanes_ou_debris_infectes, utiliser_plants_sains]).
traitement(mildiou_pomme_de_terre, conventionnel,
  [fongicide_homologue, detruire_fanes_ou_debris_infectes, utiliser_plants_sains]).

traitement(alternariose_pomme_de_terre, biologique,
  [produit_cuivre_bio, eliminer_residus, maintenir_vigueur_par_irrigation_reguliere]).
traitement(alternariose_pomme_de_terre, conventionnel,
  [fongicide_homologue, eliminer_residus, maintenir_vigueur_par_irrigation_reguliere]).

traitement(gale_commune, biologique,
  [aucun_curatif, plants_certifies, maintenir_humidite_du_sol_reguliere_a_tuberisation]).
traitement(gale_commune, conventionnel,
  [aucun_curatif, plants_certifies, maintenir_humidite_du_sol_reguliere_a_tuberisation]).

traitement(gale_poudreuse, biologique,
  [aucun_curatif, plants_sains, rotation]).
traitement(gale_poudreuse, conventionnel,
  [aucun_curatif, plants_sains, rotation]).

traitement(nematodes_kystes, biologique,
  [attendre_confirmation_officielle, nettoyer_materiel_et_outils, rotation_longue]).
traitement(nematodes_kystes, conventionnel,
  [attendre_confirmation_officielle, nettoyer_materiel_et_outils, rotation_longue]).

traitement(tuta_absoluta, biologique,
  [piegeage, bt_bio, auxiliaires, poser_filet_insect_proof]).
traitement(tuta_absoluta, conventionnel,
  [piegeage, insecticide_homologue, poser_filet_insect_proof, retirer_et_detruire_feuilles_et_fruits_mines]).

traitement(mineuse_feuille, biologique,
  [auxiliaires, piegeage, retirer_feuilles_fortement_minees]).
traitement(mineuse_feuille, conventionnel,
  [insecticide_homologue, piegeage, retirer_feuilles_fortement_minees]).

traitement(pucerons, biologique,
  [auxiliaires, savon_huile_bio, eviter_exces_azote]).
traitement(pucerons, conventionnel,
  [insecticide_homologue, auxiliaires, eviter_exces_azote]).

traitement(aleurodes, biologique,
  [piegeage, auxiliaires, savon_huile_bio, utiliser_plants_sains_et_filets]).
traitement(aleurodes, conventionnel,
  [piegeage, insecticide_homologue, utiliser_plants_sains_et_filets]).

traitement(acariens, biologique,
  [acariens_predateurs, savon_huile_bio, limiter_stress_hydrique]).
traitement(acariens, conventionnel,
  [insecticide_homologue, limiter_stress_hydrique, retirer_folioles_tres_atteintes]).

traitement(virus_enroulement_tomate, biologique,
  [aucun_curatif, arracher_plants_symptomatiques, auxiliaires, utiliser_plants_sains]).
traitement(virus_enroulement_tomate, conventionnel,
  [aucun_curatif, arracher_plants_symptomatiques, insecticide_homologue, utiliser_plants_sains]).

traitement(tobrfv, biologique,
  [attendre_confirmation_officielle, isoler_et_retirer_plants_suspects, nettoyer_et_desinfecter_outils]).
traitement(tobrfv, conventionnel,
  [attendre_confirmation_officielle, isoler_et_retirer_plants_suspects, nettoyer_et_desinfecter_outils]).

traitement(carence_calcique, biologique,
  [regulariser_irrigation, calcium_conseille, retirer_fruits_atteints]).
traitement(carence_calcique, conventionnel,
  [regulariser_irrigation, calcium_conseille, retirer_fruits_atteints]).

traitement(eclatement_fruits, biologique,
  [regulariser_apports_d_eau, pailler_si_adapte, recolter_a_maturite]).
traitement(eclatement_fruits, conventionnel,
  [regulariser_apports_d_eau, pailler_si_adapte, recolter_a_maturite]).

% --------------------------------------------------------------- precautions
precaution(commun,
  'Lisez toujours l''étiquette : culture, cible, dose, nombre d''applications et équipement de protection (gants, masque, combinaison).').
precaution(commun,
  'Vérifiez que le produit est homologué par l''ONSSA pour cette culture ; ne mélangez pas de produits sans avis.').
precaution(commun,
  'Respectez le DÉLAI AVANT RÉCOLTE (DAR) indiqué sur l''étiquette : ne récoltez pas avant son expiration, surtout sur tomates cueillies en continu.').
precaution(commun,
  'Ne traitez pas en plein soleil, par vent fort ni quand les abeilles butinent ; évitez la contamination des cours d''eau.').
precaution(biologique,
  'En agriculture biologique, vérifiez que le produit figure dans votre cahier des charges / organisme de certification. « Naturel » ne veut pas dire sans risque ni sans délai avant récolte.').
precaution(conventionnel,
  'Alternez les modes d''action pour éviter les résistances et privilégiez d''abord les mesures culturales.').

% ------------------------------------------------------ regles reglementaires
reglemente(tobrfv).
reglemente(nematodes_kystes).

message_reglemente(tobrfv,
  'Suspicion de virus réglementé (ToBRFV) : isolez les plants, ne manipulez pas d''autres plants ensuite sans désinfecter, ne déplacez ni plants ni fruits, et SIGNALEZ-LE aux services phytosanitaires (ONSSA). Seule une analyse en laboratoire confirme.').
message_reglemente(nematodes_kystes,
  'Suspicion de nématodes à kystes (organisme de quarantaine) : l''observation visuelle ne suffit pas. Prélevez le sol pour analyse, nettoyez le matériel, ne déplacez pas de terre et informez les services phytosanitaires (ONSSA).').

% --------------------------------------------------------------------- cycle
cycle(mildiou_tomate,
  'Causé par Phytophthora infestans, un oomycète. Il se conserve sur les débris, les plants infectés et les pommes de terre voisines. Les spores voyagent avec le vent et la pluie et germent sur feuillage mouillé : temps frais et humide = explosion rapide de la maladie.').
cycle(alternariose_tomate,
  'Causée par Alternaria solani, qui survit sur les débris de culture. Les spores se disséminent par le vent et les éclaboussures. La maladie débute sur les vieilles feuilles du bas, surtout sur plantes fatiguées ou très chargées en fruits, avec alternance de rosée et de chaleur.').
cycle(oidium_tomate,
  'Champignon dont les spores germent sans eau libre sur la feuille : l''humidité de l''air élevée et des températures modérées suffisent. Il est fréquent sous abri et se propage par le vent.').
cycle(moisissure_grise,
  'Botrytis cinerea pénètre surtout par les blessures (tailles, effeuillage, pétales fanés) et les tissus vieillissants. Il prospère quand l''air est humide et peu renouvelé ; ses spores sont emportées par l''air.').
cycle(chancres_tige,
  'Didymella lycopersici infecte par les plaies de la tige, les tuteurs et les débris contaminés. Elle est surtout observée en période fraîche et humide d''automne-hiver.').
cycle(fusariose_tomate,
  'Champignon du sol (Fusarium oxysporum f. sp. lycopersici). Il entre par les racines et colonise les vaisseaux qui conduisent l''eau, d''où le flétrissement. Il persiste de nombreuses années dans le sol et est favorisé par la chaleur.').
cycle(mildiou_pomme_de_terre,
  'Même agent que pour la tomate (Phytophthora infestans). Les tubercules infectés servent de source ; les spores lavées par la pluie descendent dans le sol et infectent les tubercules. Rosée et nuits fraîches l''encouragent.').
cycle(alternariose_pomme_de_terre,
  'Alternaria solani survit sur les résidus. Elle attaque surtout les plantes en fin de cycle, stressées ou vieillissantes, quand alternent humidité et chaleur.').
cycle(gale_commune,
  'Causée par des bactéries du sol (Streptomyces). Elles infectent les jeunes tubercules au début de la tubérisation ; un sol sec à ce moment favorise la maladie. Elle est surtout esthétique mais déclasse les tubercules.').
cycle(gale_poudreuse,
  'Causée par Spongospora subterranea, un organisme du sol à spores très durables. Elle est favorisée par les sols frais, humides et mal drainés, et se transmet par plants et terre contaminés.').
cycle(nematodes_kystes,
  'Les femelles meurent et forment des kystes qui protègent les œufs dans le sol pendant de nombreuses années. L''éclosion est déclenchée par les exsudats racinaires de la pomme de terre. La seule vraie parade est la rotation longue et les plants sains.').
cycle(tuta_absoluta,
  'Papillon dont les larves creusent des galeries dans les feuilles, tiges et fruits. Il a plusieurs générations par an, plus rapides par temps doux à chaud, et survit sur d''autres solanacées.').
cycle(mineuse_feuille,
  'Les femelles piquent les feuilles ; les larves creusent des galeries sinueuses, puis se nymphosent sur la feuille ou dans le sol. Cycle rapide par temps doux.').
cycle(pucerons,
  'Se reproduisent très vite (sans mâle) et forment des colonies sur les pousses tendres. Leur miellat attire la fumagine et ils peuvent transmettre des virus.').
cycle(aleurodes,
  'Petits insectes blancs vivant sous les feuilles, au développement rapide par temps chaud et sous abri. Ils piquent la sève, produisent du miellat et transmettent des virus comme le TYLCV.').
cycle(acariens,
  'Acariens minuscules qui piquent les cellules des feuilles (ponctuations jaunes) et tissent des toiles. Leur multiplication est très rapide par temps chaud et sec.').
cycle(virus_enroulement_tomate,
  'Virus transmis par les aleurodes (Bemisia tabaci), pas par simple contact. Une plante infectée jeune produit très peu de fruits. Il n''existe pas de traitement curatif : on agit sur le vecteur et sur les plants.').
cycle(tobrfv,
  'Virus très stable, transmis par contact (mains, outils, vêtements), plants et semences contaminés. Il persiste longtemps sur les surfaces. C''est un organisme réglementé.').
cycle(carence_calcique,
  'Trouble physiologique non contagieux. Le calcium circule avec le flux d''eau de la transpiration et atteint mal les fruits en croissance rapide, surtout si l''irrigation est irrégulière ou le sol salin. Le sol peut contenir assez de calcium : c''est son transport vers le fruit qui est en cause.').
cycle(eclatement_fruits,
  'Trouble physiologique non contagieux : après une période sèche, un afflux d''eau fait gonfler le fruit plus vite que sa peau ne peut s''étirer, d''où les fissures.').

% ---------------------------------------------------------------- observations
observation(mildiou_tomate,
  'Placez une feuille tachée dans un sac humide une nuit : un duvet blanc apparaissant sous la tache confirme le mildiou.').
observation(alternariose_tomate,
  'Observez à la loupe des anneaux concentriques (cible) sur les vieilles feuilles du bas, souvent avec un halo jaune.').
observation(oidium_tomate,
  'Frottez la poudre blanche : elle s''essuie. Vérifiez aussi le dessous des feuilles (taches jaunes dessus, feutrage blanc dessous).').
observation(moisissure_grise,
  'Tapotez le tissu atteint : un nuage de spores grises s''en échappe. Cherchez le point d''entrée (plaie de taille).').
observation(chancres_tige,
  'Cherchez à la loupe de petits points noirs sur le chancre et vérifiez s''il part d''une plaie ou d''un tuteur.').
observation(fusariose_tomate,
  'Coupez la tige à la base en long : un brunissement des vaisseaux sans pourriture molle suggère une fusariose. À distinguer d''un flétrissement bactérien (non couvert ici) : analyse en laboratoire si doute.').
observation(mildiou_pomme_de_terre,
  'Recherchez le duvet blanc sous la tache (surtout au petit matin) et coupez un tubercule : pourriture brune rousse sous la peau.').
observation(alternariose_pomme_de_terre,
  'Observez les anneaux concentriques sur les feuilles du bas et le jaunissement autour des taches.').
observation(gale_commune,
  'Coupez le tubercule : la lésion liégeuse reste superficielle (quelques millimètres).').
observation(gale_poudreuse,
  'Lavez le tubercule et observez à la loupe : pustules qui libèrent une poudre brune ; examinez aussi les racines (galles).').
observation(nematodes_kystes,
  'Arrachez une plante en floraison, lavez les racines et regardez à la loupe : petites boules blanches/jaunes puis brunes. Confirmez par analyse de sol en laboratoire.').
observation(tuta_absoluta,
  'Ouvrez une mine : larve crème à tête sombre et déjections noires. Installez un piège à phéromone pour confirmer la présence.').
observation(mineuse_feuille,
  'Regardez la feuille à contre-jour : galerie fine et sinueuse avec une larve ou une pupe ; cherchez les petites piqûres.').
observation(pucerons,
  'Retournez les feuilles et regardez à la loupe : colonies, peaux blanches (exuvies), fourmis qui les protègent.').
observation(aleurodes,
  'Secouez la plante : de petits insectes blancs s''envolent. Posez des pièges jaunes collants pour confirmer.').
observation(acariens,
  'Loupe x10 sous la feuille : toiles et petits points mobiles. Tapotez une feuille sur une feuille de papier blanc.').
observation(virus_enroulement_tomate,
  'Cherchez des aleurodes sur la culture. Les symptômes sont surtout sur les jeunes feuilles du haut. Un test de laboratoire (PCR) confirme.').
observation(tobrfv,
  'Ne concluez pas à l''œil : une analyse de laboratoire est nécessaire (ToBRFV ressemble à d''autres virus de mosaïque).').
observation(carence_calcique,
  'Vérifiez que seul le fruit est touché (pas de moisissure ni d''insecte), que la tache est côté fleur, et examinez l''historique de l''irrigation.').
observation(eclatement_fruits,
  'Notez si les fissures sont apparues après une pluie ou un arrosage abondant suivant une période sèche.').
