# ConcePTIONAlgorithmPregnancies

The **statistical analysis plan** for the ConcePTION algorithm pregnancies is available at this [link](https://docs.google.com/document/d/1mM2laGcuVEvQazdKkbqaJcOIXXENqiPS/edit#).

## Background
ConcePTION aims to build an ecosystem that can use observational data sources to generate Real World Evidence (RWE) that may be used for clinical and regulatory decision making. Real world evidence is required to address the big information gap of medication safety in pregnancy. 
Data sources participating in multi-database studies, such as the studies conducted in the WP1 of ConcePTION, do not necessarily come with a complete enumeration of the pregnancies experienced in their underlying populations. Data sources are different in terms of compositions of data banks, and many data banks collect information that is pertinent to the purpose of identifying pregnancies: birth registries, primary care medical records, hospital administrative records, termination registries, and others. All combinations of such data banks are documented among the data sources of ConcePTION, see the Deliverable 7.5 of ConcePTION (Dodd C et al, 2020), and Table 1 below. Therefore, in order to identify the list of pregnancies, algorithms that only retrieve pregnancies using diagnostic codes, or that process records independently of their origin, are suboptimal (Matcho A et al, 2018; Sarayani A , et al, 2020). On the other hand, algorithms that only retrieve pregnancies from birth registries may fail to detect pregnancies that end prematurely, and fail to exploit the full range of information that may be available from primary care medical records (Ortiz SS et al, 2020) or records of specialist visits (Schink T et al, 2020). In previous experience from multi-database European studies, algorithms exploiting diverse data banks were implemented separately by each research partner (Charlton  RA et al, 2014). To incorporate all such scenarios in a transparent and common framework, a novel algorithm must be designed. Such an algorithm may also enable estimation of the moment when a completed pregnancy had left its first identifiable sign in the data source.


## Strategy
The algorithm will comprise standard components: for instance, pregnancy retrieved from a birth registry, or pregnancies retrieved from a hospital administrative data bank using a diagnostic code associated to delivery. Composition of such components will be tailored to each data source in a hierarchical manner: e.g. in order to associate date of start of pregnancy to a pregnancy, estimate from ultrasound recorded in a birth registry may be deemed more reliable than diagnostic codes of pregnancy-related events retrieved from a hospital administrative data bank.  Pregnancies derived from all available data banks will be included, and consequently, the population of identified pregnancies will be comprised of several subpopulations. For instance, pregnancies whose start and end date are obtained by sources other than registries, despite often having a lower degree of certainty, will be identified and be available for inclusion in the main analysis or in sensitivity analyses. In some data sources, according to their composition in data banks and to the information recorded in the specific data bank, a smaller range of options may be available.


## Overall design 
Subjects are first selected as experiencing the end of a pregnancy or an ongoing pregnancy. The selection is done in parallel from four streams.

| ![img](https://github.com/ARS-toscana/ConcePTIONAlgorithmPregnancies/blob/documentation/readme/streams.PNG) | 
|:--:| 
| *Figure 1. Flow of the overall design. In the graphical representation, a diamond represents the date of the record, a circle represents a record of a date of start of pregnancy, and the bar represents the interval between start and end.*|



- stream **PROMPTS**: prompts of birth registries, terminations registries, and spontaneous abortion registries in SURVEY_ID: the existence of one of such record implies readily that a pregnancy has ended 
- stream **EUROCAT**: records of the EUROCAT table
- stream **CONCEPTSETS**: diagnostic codes from the EVENTS or procedure codes from the PROCEDURES or codes from the MEDICAL_RECORDS file referring to an end or an ongoing pregnancy 
- stream **ITEMSETS**: variables from ordinary healthcare that are only populated when a woman is pregnant
The resulting sets of pregnancies of a same person are then compared with each other, to identify which pregnancies are in fact the same, recorded oin multiple occasions. 
