# Système expert : diagnostic tomate / pomme de terre (SWI-Prolog)

## Structure (tous les fichiers dans le MÊME dossier : Expert-Systeme-Project/)

| Fichier | Rôle |
|---|---|
| `knowledge_base.pl` | Base de faits : cultures, 20 problèmes, symptômes, conditions favorables, mesures IPM (votre fichier, modifié) |
| `regles_cf.pl` | **Nouveau** : coefficient de certitude de chaque symptôme, paramètres, stades sensibles |
| `questions.pl` | **Nouveau** : textes des questions et descriptions des symptômes |
| `traitements.pl` | **Nouveau** : traitements conventionnel / biologique, précautions et DAR, cycle de la maladie, observations de départage, alertes réglementaires |
| `moteur.pl` | **Nouveau** : inférence MYCIN (combinaison, contexte, stade, signes absents, incertitude) |
| `interface.pl` | **Nouveau** : dialogue console (culture → mode → contexte → organe → symptôme → questions → résultat) |
| `main.pl` | **Nouveau** : point d'entrée |
| `tests.pl` | **Nouveau** : 33 tests automatiques (plunit) |

## Lancer

    cd Expert-Systeme-Project
    swipl main.pl          # le dialogue démarre ; pour recommencer : ?- demarrer.

Tests : `swipl -g run_tests -t halt tests.pl`

Sous Windows, utilisez `swipl-win` (ou `chcp 65001` dans cmd) pour afficher correctement les accents.

## Méthode de calcul (à décrire dans le rapport)

1. Symptômes observés : `CF = CF1 + CF2 * (1 - CF1)` (ex. 0.8 puis 0.6 donne 0.92).
2. Signe attendu mais absent : `CF = CF * (1 - 0.4 * CF_signe)`.
3. Condition favorable confirmée : combinée avec +0.2 ; déclarée absente : `CF * 0.9`.
4. Stade de culture sensible : combiné avec +0.1.
5. Aucun candidat sans au moins un symptôme observé.
6. Incertain si l'écart entre les 2 premiers < 0.15 ou si le meilleur score < 0.5.

## Limites

Les coefficients sont des estimations d'expert à valider par un agronome. Aucune dose ni matière active n'est fournie. Voir `SOURCES_KB.md`.
