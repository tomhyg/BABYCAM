# BABYCAM - Système de Surveillance Intelligente 👶

**Système de surveillance avec traitement d'image embarqué et intelligence artificielle**

![BABYCAM System](docs/images/babycam-system.jpg)

> **Note**: Le code source est propriété de [Medivietech](https://www.medivietech.com) et reste confidentiel. Ce repository présente l'architecture technique, la méthodologie et les résultats du projet.

---

## 🎯 Contexte du Projet

- **Entreprise**: Medivietech (Startup MedTech incubée à AGORANOV Paris)
- **Période**: Avril 2025 - Octobre 2025 (6 mois)
- **Rôle**: Hardware/Software Engineer (Stage de fin d'études)
- **Équipe**: Neil Benhamou (CEO), Thomas Baret (CTO)
- **Objectif**: Développement d'un système de surveillance vidéo intelligente avec analyse embarquée

## 📝 Problématique

Les systèmes de surveillance actuels présentent plusieurs limitations :
- Dépendance au cloud pour le traitement vidéo (latence, confidentialité)
- Coût élevé des solutions professionnelles
- Consommation énergétique importante
- Alertes souvent basées sur des règles simples (peu d'IA)

**Mission** : Concevoir un système de surveillance intelligente avec traitement d'image embarqué, détection de mouvements et analyse en temps réel, tout en préparant la migration vers une plateforme industrielle.

## 🔧 Solution Technique

### Architecture Multi-Plateforme Explorée

Le projet a exploré plusieurs plateformes pour optimiser le rapport performance/coût/consommation :

```
┌─────────────────────────────────────────────────────────┐
│              Exploration Technologique                   │
│                                                          │
│  Phase 1: ESP32-CAM (Prototypage rapide)               │
│  Phase 2: Raspberry Pi 4 (Puissance de calcul)         │
│  Phase 3: CherryPi V3S (Optimisation coût/énergie)     │
│  Phase 4: Nordic nRF5340 (Industrialisation)           │
└─────────────────────────────────────────────────────────┘
```

### Architecture Générale

```
┌──────────────────────────────────────────────────────────┐
│                  BABYCAM System                           │
│  ┌──────────────┐     ┌──────────────┐   ┌────────────┐ │
│  │   Camera     │────▶│   MCU/SoC    │──▶│  BLE/WiFi  │ │
│  │   Module     │     │  (Processing) │   │  Module    │ │
│  └──────────────┘     └──────────────┘   └────────────┘ │
│         │                    │                   │        │
│         │                    ▼                   │        │
│         │          ┌──────────────────┐          │        │
│         └─────────▶│  Computer Vision │          │        │
│                    │  Motion Detection│          │        │
│                    └──────────────────┘          │        │
│                           │                      │        │
│                           ▼                      │        │
│                  ┌──────────────────┐            │        │
│                  │  Alert System    │            │        │
│                  └──────────────────┘            │        │
└──────────────────────────┬───────────────────────┘
                           │
                           ▼
                  ┌──────────────────┐
                  │   Mobile App     │
                  │  (Flutter/Dart)  │
                  └──────────────────┘
```

### Stack Technique

#### Phase 1 : ESP32-CAM (Prototypage)
- **Microcontrôleur**: ESP32 + OV2640 camera
- **Avantages**: Faible coût, WiFi intégré, écosystème Arduino
- **Limitations**: Processeur limité pour traitement vidéo complexe
- **Résultat**: Prototype fonctionnel, détection de mouvement basique

#### Phase 2 : Raspberry Pi 4 (Performance)
- **Processeur**: ARM Cortex-A72 quad-core
- **Avantages**: Puissance de calcul élevée, OpenCV complet, Python
- **Limitations**: Consommation énergétique, coût, encombrement
- **Résultat**: Algorithmes complexes validés, ML embarqué

#### Phase 3 : CherryPi V3S (Optimisation)
- **SoC**: Allwinner V3S (ARM Cortex-A7)
- **Avantages**: Très faible coût, faible consommation, Linux embarqué
- **Limitations**: Écosystème moins mature que Raspberry Pi
- **Résultat**: Bon compromis coût/performance pour production

#### Phase 4 : Nordic nRF5340 (Industrialisation)
- **Microcontrôleur**: Dual-core ARM Cortex-M33
- **Avantages**: Ultra-basse consommation, BLE 5.3, certifications
- **Migration**: Préparation de l'architecture pour production série
- **Objectif**: Réduction consommation, autonomie batterie, coût BOM

#### Software & Frameworks
- **Langage**: C++, Python
- **Computer Vision**: OpenCV pour traitement d'image
- **Protocoles**: BLE 5.0, WiFi, MQTT
- **Application**: Flutter/Dart pour interface mobile
- **ML (optionnel)**: TensorFlow Lite pour détection avancée

## 🚀 Réalisations Techniques

### 1. Développement Multi-Plateforme

**Approche itérative** :
1. **Prototypage rapide** sur ESP32-CAM pour validation concept
2. **Développement d'algorithmes** sur Raspberry Pi avec ressources complètes
3. **Optimisation** sur CherryPi V3S pour réduction coût/consommation
4. **Migration** vers Nordic nRF5340 pour production industrielle

**Challenges résolus** :
- Portabilité du code entre plateformes différentes
- Optimisation des algorithmes pour contraintes embarquées
- Gestion de la mémoire sur systèmes à ressources limitées
- Balance entre performance et consommation énergétique

### 2. Traitement d'Image Embarqué

**Fonctionnalités implémentées** :
- Détection de mouvement en temps réel
- Analyse de zones d'intérêt (ROI)
- Réduction du bruit vidéo
- Compression intelligente pour transmission

**Optimisations** :
- Traitement par ROI pour économie de ressources
- Frame skipping adaptatif selon activité détectée
- Compression vidéo avec qualité dynamique
- Buffer management pour éviter les fuites mémoire

### 3. Préparation Migration Nordic nRF5340

**Travaux préparatoires** :
- Étude comparative des SoCs pour production
- Architecture logicielle modulaire pour portabilité
- Évaluation consommation énergétique par composant
- Spécifications techniques pour industrialisation

**Objectifs de la migration** :
- Réduction de 70% de la consommation énergétique
- Autonomie sur batterie de 24h+
- Coût BOM réduit pour production série
- Certifications (CE, FCC) facilitées par l'écosystème Nordic

### 4. Intelligence Embarquée

**Détection intelligente** :
- Algorithmes de détection de mouvement adaptatifs
- Reconnaissance de patterns (pleurs, mouvements anormaux)
- Système d'alertes intelligent avec réduction de faux positifs
- Mode nuit avec traitement infrarouge

## 📊 Résultats & Performances

### Comparatif Plateformes

| Critère | ESP32-CAM | Raspberry Pi 4 | CherryPi V3S | nRF5340* |
|---------|-----------|----------------|--------------|----------|
| **Coût BOM** | ~5€ | ~60€ | ~10€ | ~8€ |
| **Consommation** | ~200mA | ~800mA | ~150mA | ~50mA |
| **Performance CV** | Basique | Excellente | Bonne | Optimisée |
| **FPS traité** | 5-10 | 30+ | 15-20 | 10-15 |
| **Autonomie batterie** | 8h | 2h | 12h | 24h+ |
| **Certification** | Difficile | Difficile | Moyenne | Facilitée |

*Valeurs estimées pour Nordic nRF5340 après migration

### Indicateurs de Performance (Raspberry Pi 4)

| Métrique | Valeur |
|----------|--------|
| **Résolution vidéo** | 720p @ 30 FPS |
| **Latence détection** | <100ms |
| **Taux faux positifs** | <5% |
| **Précision détection** | 95%+ |
| **Bande passante réseau** | ~1-2 Mbps |

## 🎓 Compétences Développées

### Techniques
- Traitement d'image embarqué (OpenCV, Computer Vision)
- Développement multi-plateforme (ESP32, ARM Linux, Nordic SDK)
- Optimisation d'algorithmes pour systèmes contraints
- Architecture IoT avec communication BLE/WiFi
- Prototypage électronique rapide
- Migration vers plateforme de production
- Analyse de consommation énergétique
- Développement d'applications mobiles (Flutter)

### Méthodologiques
- Évaluation comparative de solutions techniques
- Optimisation coût/performance/consommation
- Préparation à l'industrialisation
- Documentation technique pour certification
- Tests et validation fonctionnelle
- Gestion de contraintes hardware/software

## 🔄 Évolution du Projet

```
Prototypage       Développement      Optimisation      Industrialisation
ESP32-CAM    →    Raspberry Pi 4  →  CherryPi V3S  →   Nordic nRF5340
 (Concept)         (Algorithmes)      (Coût/Énergie)    (Production)
```

**Timeline** :
- **Mois 1-2** : Prototypage ESP32-CAM, validation concept
- **Mois 3-4** : Développement Raspberry Pi 4, algorithmes avancés
- **Mois 5** : Optimisation CherryPi V3S, réduction coûts
- **Mois 6** : Préparation migration Nordic nRF5340, industrialisation

## 📁 Documentation Disponible

- ✅ [Comparatif plateformes détaillé](docs/platform-comparison.md)
- ✅ [Architecture système](docs/architecture.md)
- ✅ [Rapport de stage complet (74 pages)](docs/rapport_stage.pdf)
- ✅ [Spécifications Nordic nRF5340](docs/nrf5340-migration.md)
- ✅ [Démonstrations et tests](docs/images/)

## 🏆 Impact & Résultats

- **4 plateformes explorées** avec analyse comparative complète
- **Prototype fonctionnel** sur 3 plateformes différentes
- **Algorithmes optimisés** pour contraintes embarquées
- **Architecture prête** pour migration industrielle
- **Base technique solide** pour certification et production série
- **Réduction de 80% du coût BOM** (ESP32-CAM vs Raspberry Pi)

## 🔒 Confidentialité

Le code source, les algorithmes propriétaires et les spécifications produit sont la propriété de **Medivietech SAS** et ne sont pas publiés dans ce repository.

Ce portfolio technique présente uniquement :
- L'approche méthodologique multi-plateforme
- Les défis techniques rencontrés et solutions explorées
- Les résultats comparatifs
- Les compétences développées

Pour toute question technique sur ce projet, je suis disponible pour échanger en entretien.

---

## 📫 Contact

**Tom Huyghe** - Ingénieur Systèmes Embarqués  
📧 tom.huyghe@orange.fr  
💼 [LinkedIn](https://www.linkedin.com/in/tom-huyghe)  
🌐 [GitHub Portfolio](https://github.com/tomhyg)

---

*Développé chez Medivietech - Startup MedTech incubée à AGORANOV Paris*  
*Stage ingénieur de fin d'études - ESME SUDRIA | Avril - Octobre 2025*
