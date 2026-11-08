

<!-- Start of picture text -->
oglall a__uil5<br>uilSljo - dJStaul<br>MARRAKECH | FaCULTE DES SCIENCES<br>pececturytegatana | SEMLALIA~ MARRAKECH<br><!-- End of picture text -->

**PR. ELALAOUI Hasna Module** : Fondements avancés de l’IA **Filière** : Master IA – S1 **Année universitaire** : 2026-2027 

# **Mini-projet système expert avec ProLog** 

## **Système Expert de Diagnostic des Maladies des Plantes Cultivées** 

## **Introduction** 

L’agriculture occupe une place centrale dans l’économie marocaine, mais les cultures sont régulièrement menacées par des maladies (mildiou, oïdium, rouille, tavelure…), des ravageurs (pucerons, cochenilles, mineuses…) ou des troubles physiologiques (carences nutritives, stress hydrique). Un mauvais diagnostic conduit souvent à des traitements inadaptés, à une utilisation excessive de pesticides et à des pertes de rendement importantes, alors que l’accès rapide à un ingénieur agronome n’est pas toujours possible, en particulier pour les petites exploitations. 

Ce projet s’inscrit dans le cadre de la pratique du module « Fondements avancés de l’intelligence artificielle » et a pour but la réalisation d’un **<mark>système expert de diagnostic des maladies et ravageurs des plantes cultivées</mark>** . Ce système simulera le raisonnement d’un ingénieur agronome (phytopathologiste), guidant l’agriculteur pas à pas dans l’observation des symptômes (feuilles, tiges, fruits, racines) afin d’identifier la cause probable du problème (champignon, bactérie, virus, insecte, carence ou stress environnemental) et de lui proposer des mesures de traitement et de prévention adaptées. 

L’objectif n’est pas de remplacer un agronome ou une analyse en laboratoire pour les cas complexes, mais d’offrir un premier niveau de diagnostic intelligent, capable d’identifier les problèmes courants, d’éviter les traitements inutiles et d’expliquer le "pourquoi" de chaque conclusion. Le système doit intégrer une dimension pédagogique pour aider l’utilisateur à comprendre le cycle de la maladie et les conditions qui la favorisent. 

Ce système est capable, à partir de la culture concernée et d’une description initiale des symptômes observés, de prendre en compte le contexte (saison, stade de la culture, conditions climatiques récentes), de poser des questions ciblées pour affiner le diagnostic, de proposer une ou plusieurs causes probables avec un niveau de confiance, et de fournir des recommandations de traitement et de prévention raisonnées. 

**PR. ELALAOUI Hasna Module** : Fondements avancés de l’IA **Filière** : Master IA – S1 **Année universitaire** : 2026-2027 



<!-- Start of picture text -->
WY sglall é 5<br>JiSlpo - AU Stow<br>ACULTE DES SCIENCES<br><!-- End of picture text -->

## **Travail à faire** 

Afin de réaliser ce système expert avec ProLog, un ensemble d’étapes doivent être suivies et développées : 

- **Délimiter le domaine** : Choisir une famille de cultures précise, par exemple : arbres fruitiers (olivier, agrumes), cultures maraîchères (tomate, pomme de terre, poivron) ou céréales (blé, orge). Le système devra couvrir au moins 15 maladies, ravageurs ou troubles physiologiques. 

- **L’acquisition et la formalisation des connaissances** sous forme d’une base de connaissances (base des faits et base des règles) : Cette étape nécessite une recherche structurée pour modéliser les maladies. La base de faits contiendra les cultures (culture(tomate, maraichage)), les symptômes (symptome(taches_brunes_feuilles)), les conditions favorables (condition_favorable(mildiou, humidite_elevee)) et les traitements (traitement(mildiou, biologique, [bouillie_bordelaise, elimination_feuilles_atteintes])). Les règles lieront les symptômes et le contexte aux causes (diagnostiquer(mildiou) :- culture(tomate),symptome(taches_huileuses_feuilles), 

symptome(duvet_blanc_face_inferieure), meteo(humide).). 

_<u>Coup de main 1 :</u>_ Pour structurer les connaissances, utilisez une approche arborescente (arbre de décision) en partant de l’organe atteint puis du type de symptôme. Les fiches techniques de l’INRA Maroc et de l’ONSSA, les guides de la FAO ou encore les bases de données de l’EPPO et de PlantVillage sont d’excellentes sources pour décrire les symptômes, les conditions favorables et les moyens de lutte. 

- **Développement d’une Interface Utilisateur** qui permettra au système expert de guider l’agriculteur : Permettre à l’utilisateur de sélectionner la culture concernée, l’organe atteint (feuilles, tiges, fruits, racines) puis le symptôme principal observé. 

Poser des questions interactives pour affiner le diagnostic ("Les taches sont-elles entourées d’un halo jaune ?", "Observez-vous des insectes sur la face inférieure des feuilles ?", "A-t-il plu ou fait très humide ces derniers jours ?"). 

**PR. ELALAOUI Hasna Module** : Fondements avancés de l’IA **Filière** : Master IA – S1 **Année universitaire** : 2026-2027 



<!-- Start of picture text -->
Wp pglall @___15<br>) lSlpo - AJSLaudI<br>MARRAKECH —<br>susgailtav | FACULTESEMLALIA-DESMAMRARECH SCIENCES.<br><!-- End of picture text -->

- **Afficher le diagnostic probable avec un niveau de confiance** : 

   - Proposer un plan d’action adapté au mode de production sélectionné par l’utilisateur (conventionnel / biologique), avec des explications sur les mesures à appliquer (traitement, gestes culturaux, prévention), les précautions d’emploi des produits et le respect des délais avant récolte. 

   - Si le diagnostic est incertain, proposer plusieurs pistes avec des observations complémentaires à effectuer pour les départager (examen des racines, observation à la loupe…) ou recommander l’envoi d’un échantillon à un laboratoire. 

_<u>Coup de main 2</u>_ : Pour calculer le niveau de confiance, vous pouvez vous inspirer des facteurs de certitude du système MYCIN en associant un coefficient à chaque règle. Une application console interactive en Prolog est tout à fait adaptée ; pour une expérience plus poussée, un site web simple utilisant PSP permettra de créer un formulaire guidé illustré par des photos de symptômes. 

## **Livrables** 

Ce mini-projet est à réaliser **seul** ou en **binôme** et à livrer avant le **Dimanche 13 Décembre 2026 à Minuit** . 

Le projet est à soumettre sur le dossier Drive : <u>https://drive.google.com/drive/folders/1QviUrtE6dgP6VOO-</u> 

<u>eGviYbKJZsnoCanm?usp=drive_link sous format d’un fichier compressé contenant les éléments</u> suivants : 

- Le code ProLog en entier 

- Le code de l’interface IHM. 

- Un rapport .pdf détaillant l’ensemble des tâches réalisées 

_<u>Remarques :</u>_ 

- Un projet réalisé par plus de 2 personnes sera automatiquement rejeté 

- Un projet soumis après le délai sera automatiquement rejeté. 

- Tout fichier doit être nommé avec le nom du binôme pour qu’il soit facilement repérable. 

- Le fichier doit être soumis par un membre du binôme et non les 2. 


