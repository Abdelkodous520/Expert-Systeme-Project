# Knowledge base: sources and scope

This project knowledge base covers **tomato and potato** and contains 20 candidate problems: fungal/oomycete diseases, bacterial and viral diseases, insect and mite pests, potato nematodes, and physiological disorders. Entries are represented in [`knowledge_base.pl`](knowledge_base.pl).

## Sources consulted

1. **FAO, “Cultural practices and infectious crop diseases,” chapter 17** — Morocco-specific tomato context: autumn tomato stem canker (Didymella), its occurrence in the wet/cold October–January period, tomato pathogens in Morocco, and soil/support solarization examples. [FAO chapter](https://www.fao.org/4/t0455e/t0455e0h.htm)
2. **FAO, “Good practices” for potato production** — healthy seed potatoes, resistant varieties, rotation, volunteer potato and weed control, monitoring, and integrated management. [FAO guide, PDF](https://www.fao.org/4/i1127e/i1127e02.pdf)
3. **FAO, “Guidance on integrated pest management for the world’s major crop pests and diseases” (2025)** — IPM bundles for potato and fruit/vegetable pests and diseases. [FAO publication](https://www.fao.org/science-technology-and-innovation/resources/publications/guidance-on-integrated-pest-management-for-the-world-s-major-crop-pests-and-diseases/fr)
4. **EPPO Global Database: *Globodera pallida*** — potato host, nonspecific patches of poor growth, stunting/yellowing/wilting, root branching, sampling/confirmation, rotation, hygiene and resistant varieties. [EPPO datasheet](https://gd.eppo.int/taxon/HETDPA/datasheet)
5. **EPPO Global Database: *Globodera rostochiensis*** — additional potato cyst nematode reference. [EPPO datasheet](https://gd.eppo.int/taxon/HETDRO/datasheet)
6. **EPPO Global Database: *Phthorimaea absoluta* (syn. *Tuta absoluta*)** — tomato/potato host and pest reference. [EPPO datasheet](https://gd.eppo.int/taxon/GNORAB/datasheet)
7. **EPPO Global Database: *Liriomyza bryoniae*** — tomato and potato leaf miner host reference. [EPPO datasheet](https://gd.eppo.int/taxon/LIRIBO/datasheet)
8. **EPPO Global Database: *Bactericera cockerelli*** — diagnostic differential for psyllid yellows and vector-associated symptoms; this is not treated as a confirmed Moroccan occurrence. [EPPO datasheet](https://gd.eppo.int/taxon/PARZCO/datasheet)
9. **EPPO Global Database: *Candidatus Phytoplasma solani*** — potato and tomato symptom differential. [EPPO datasheet](https://gd.eppo.int/taxon/PHYPSO/datasheet)
10. **EPPO potato cyst nematode standard** — emphasizes symptoms are nonspecific and reliable detection requires soil sampling/testing. [EPPO PM 9/26](https://gd.eppo.int/download/standard/746/pm9-26-1-en.pdf)

PlantVillage pages were not accessible to the research browser, and no specific INRA Maroc or ONSSA technical sheet could be verified in this pass. The KB therefore cites accessible FAO/EPPO material and uses familiar symptom patterns as a prototype, with source/provenance limitations stated here rather than implying that every individual symptom was confirmed against a Moroccan fact sheet. Before operational or treatment use, validate every entry with current Moroccan INRA/ONSSA guidance and a qualified plant-health adviser.

## Model behavior and limits

- `symptom/3` links a condition to an affected organ and observable sign; `favorable/2` records a broad context clue; `action/2` provides non-chemical IPM actions.
- `diagnoses(Crop, ObservedSymptoms, Results)` returns candidates ranked by the fraction of that condition’s listed symptoms present in the observation. This score is a **transparent symptom-match score**, not a calibrated probability or MYCIN certainty factor.
- A single matching symptom can produce a candidate. Treat results as triage prompts: overlapping symptoms, crop variety, growth stage, weather, and laboratory tests are not yet modeled.
- No pesticide active ingredients, doses, pre-harvest intervals, or legal-use claims are provided. Any chemical intervention must be checked against current ONSSA registration, the product label, crop, target, and local advice.
- Quarantine or regulated-pest suspicions (including potato cyst nematodes or ToBRFV) should be confirmed and referred to the appropriate Moroccan plant-health service; visual diagnosis alone is insufficient.

## Run examples (SWI-Prolog)

```prolog
?- diagnoses(tomate, [taches_huileuses_feuille, duvet_blanc_face_inferieure], R).
?- diagnose(pomme_de_terre, [croissance_en_taches_deprimees, jaunissement_fletrissement], R).
?- recommend(tuta_absoluta, Actions).
```

