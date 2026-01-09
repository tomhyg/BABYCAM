# 👶 BABYCAM - Smart Baby Monitor with AI

> **Exploration R&D complète** d'une caméra intelligente pour surveillance de bébés avec IA embarquée  
> *Projet mené durant mon stage chez Medivietech (avril-octobre 2025)*

[![ESP32-P4](https://img.shields.io/badge/ESP32--P4-RISC--V-blue)](https://www.espressif.com/en/products/socs/esp32-p4)
[![Flutter](https://img.shields.io/badge/Flutter-Mobile-02569B?logo=flutter)](https://flutter.dev/)
[![MIPI CSI-2](https://img.shields.io/badge/MIPI_CSI--2-Camera-green)](https://www.mipi.org/)
[![Status](https://img.shields.io/badge/Status-Prototype_Validated-orange)](https://github.com/tomhyg/BABYCAM)

![BABYCAM App](https://raw.githubusercontent.com/tomhyg/BABYCAM/main/mobile_app/assets/images/babycam_logo.png)

---

## 🎯 Le Concept

Un système de surveillance intelligent pour parents, combinant :
- 📹 **Caméra HD** avec vision nocturne automatique
- 🧠 **IA embarquée** pour détection des pleurs et mouvements
- 🌡️ **Monitoring environnemental** (température, humidité, qualité de l'air)
- 📱 **Application mobile** temps réel (iOS & Android)
- 🔋 **Optimisé pour l'autonomie** et la performance

**Objectif** : Créer une solution complète à prix accessible (60-80€) avec des fonctionnalités premium.

---

**Pivot stratégique** : Passage de DVP (interface parallèle limitée) vers **MIPI CSI-2** (haute performance) après analyse comparative.

---

## 🛠️ Stack Technique

### Hardware
- **Microcontrôleur** : ESP32-P4 (Dual RISC-V @ 400MHz, 64MB PSRAM)
- **Caméra** : OV5647 5MP avec filtre IR-Cut automatique
- **Capteurs** :  (T°/H/Air),  (luminosité), (mouvement)
- **Audio** : Microphone MEMS I2S + Amplificateur classe D

### Software
- **Firmware** : ESP-IDF (C natif optimisé, 1000+ lignes)
- **Pipeline vidéo** : ISP Hardware → YUV422 → H.264 (compression matérielle)
- **Application mobile** : Flutter (iOS + Android)
- **Backend** : Python sur Raspberry Pi (phase prototype)

### Architecture Pipeline Vidéo
![Pipeline Architecture](https://raw.githubusercontent.com/tomhyg/BABYCAM/main/images/architecture.png)

---

## ✨ Fonctionnalités Développées

### 📱 Application Mobile

✅ **Streaming temps réel** 1080p @ 30 FPS (latence <200ms)  
✅ **Détection IA des pleurs** avec classification  
✅ **Surveillance environnementale** (4 capteurs)  
✅ **Contrôles à distance** (veilleuse, berceuses)  
✅ **Historique & statistiques**  
✅ **Mode sombre** pour usage nocturne  

### 🎥 Système Caméra

✅ **Vision nocturne** automatique (IR-Cut Filter)  
✅ **Résolution** : VGA → 1080p selon plateforme  
✅ **Compression H.264** matérielle (ratio 8:1)  
✅ **Multi-buffering** pour streaming fluide  
✅ **Angle de vue** : 130° (couverture chambre complète)  

![Prototype Physique](https://raw.githubusercontent.com/tomhyg/BABYCAM/main/assets/prototype_hardware.jpg)

---

## 🏆 Résultats & Performances

### ESP32-P4 (Solution Retenue)

| Métrique | Performance |
|----------|-------------|
| **Résolution** | 720p @ 60 FPS / 1080p @ 30 FPS |
| **Streaming** | 1.5 Mbps stable |
| **Mémoire** | 64 MB PSRAM (vs 520KB ESP32 classique) |
| **Compression** | H.264 hardware (500KB/frame) |
| **Connectivité** | WiFi 6 + Bluetooth 5.3 |

### Validation Technique

✅ **Tous les capteurs intégrés et fonctionnels**  
✅ **Application mobile complète testée**  
✅ **Pipeline vidéo optimisé et stable**  
✅ **Architecture industrialisable** (SoC commercialement disponible)  

---

## 🎓 Compétences Démontrées

### Techniques
- **Systèmes embarqués** : ESP-IDF, RTOS, gestion mémoire critique
- **Traitement d'image** : Pipeline ISP, compression vidéo, multi-buffering
- **IoT** : Communication temps réel, capteurs I2C/I2S, protocoles WiFi/BLE
- **Mobile** : Flutter, architecture client-serveur, UI/UX responsive

### Méthodologiques
- **Approche itérative** : Validation progressive par phases
- **Analyse comparative** : Benchmark de 4 plateformes (ESP32-CAM, Pi4, V3S, ESP32-P4)
- **Gestion de l'échec** : Pivot stratégique après blocage technique (V3S)
- **Vision produit** : Architecture écosystème complet (caméra + bracelet + hub)
---

## 📸 Galerie

### Application Mobile
![App Demo](https://raw.githubusercontent.com/tomhyg/BABYCAM/main/APP.png)

### Prototype Hardware
![Hardware Prototype](https://raw.githubusercontent.com/tomhyg/BABYCAM/main/camera.png)

### Architecture Technique
![Technical Architecture](https://raw.githubusercontent.com/tomhyg/BABYCAM/main/images/Camera IRCUTFILTER.png)

---

## 🔗 Projet Connexe

🏥 **[PULSAR](https://github.com/tomhyg/PULSAR)** - Montre physiologique médicale (projet principal)  
→ 50% du temps de stage, 15 prototypes produits, validation clinique sur 50 patients

---

## 📄 Contexte

**Stage de fin d'études** - Medivietech (6 mois)  
**Période** : Avril - Octobre 2025  
**Rôle** : Ingénieur Hardware/Software Embarqué  
**Statut** : Prototype R&D validé techniquement, arrêt stratégique pour priorisation ressources

---

## 📬 Contact

**Tom HUYGHE**  
Ingénieur Mécatronique - ESME SUDRIA 2025  
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue?logo=linkedin)](https://www.linkedin.com/in/tom-huyghe)  
[![Portfolio](https://img.shields.io/badge/Portfolio-Visit-green)](https://github.com/tomhyg)

---

<div align="center">

**🌟 Si ce projet vous intéresse, n'hésitez pas à explorer le code et la documentation technique !**

*Développé avec passion pour l'innovation MedTech et les systèmes embarqués intelligents*

</div>
