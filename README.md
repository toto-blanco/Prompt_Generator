# 🚀 Prompt Generator v2.0

**Générateur de prompts optimisés pour Intelligence Artificielle**

Créez des prompts de haute qualité selon les principes du **Prompt Engineering** pour obtenir les meilleures réponses de ChatGPT, Claude, Gemini et autres assistants IA.

---

## 📋 Table des matières

- [Présentation](#-présentation)
- [Fonctionnalités](#-fonctionnalités)
- [Prérequis](#-prérequis)
- [Installation](#-installation)
  - [Linux](#-linux)
  - [macOS](#-macos)
  - [Windows](#-windows)
- [Utilisation](#-utilisation)
- [Structure du projet](#-structure-du-projet)
- [Conseils d'utilisation](#-conseils-dutilisation)
- [Dépannage](#-dépannage)
- [Licence](#-licence)
- [Auteur](#-auteur)

---

## 🎯 Présentation

**Prompt Generator** est une application web locale qui vous aide à construire des prompts structurés et optimisés pour les assistants IA. 

Basée sur les meilleures pratiques du **Prompt Engineering**, elle vous guide pour créer des instructions claires, précises et efficaces.

### ✨ Pourquoi utiliser Prompt Generator ?

- 📝 **Structuration automatique** : Organisez vos instructions selon les principes du Prompt Engineering
- 🎯 **Résultats reproductibles** : Obtenez des réponses cohérentes et de qualité
- 💾 **Sauvegarde et réutilisation** : Conservez vos meilleurs prompts en TXT ou JSON
- 🔄 **Gain de temps** : Ne réinventez pas la roue à chaque fois
- 🎓 **Apprentissage** : Comprenez ce qui fait un bon prompt

---

## ⚡ Fonctionnalités

### 🎨 Interface intuitive
- **Interface web Gradio** moderne et responsive
- **Formulaire guidé** avec sections organisées
- **Aperçu en temps réel** du prompt généré

### 🛠️ Options avancées
- **Rôle & Audience** : Définissez le contexte et le public cible
- **Format de sortie** : Code, Markdown, JSON, tableaux, etc.
- **Restrictions** : Spécifiez ce que l'IA ne doit PAS faire
- **Exemples** : Few-shot prompting pour des résultats précis
- **Ton & Style** : Pédagogique, technique, conversationnel, etc.

### 💾 Gestion des prompts
- **Copie automatique** dans le presse-papier
- **Sauvegarde** en TXT ou JSON avec horodatage
- **Organisation** dans `~/Documents/Prompts/Prompt_Generator/Template_Prompts/`

---

## 📦 Prérequis

### Commun à tous les systèmes
- **Python 3.9+** (3.10 ou 3.11 recommandé)
- **pip** (gestionnaire de paquets Python)
- **Connexion internet** (pour l'installation des dépendances)

### Linux uniquement
- **xclip** ou **xsel** (pour la copie dans le presse-papier)
  ```bash
  sudo apt install xclip xsel
  ```

---

## 🔧 Installation

### 🐧 Linux

#### Méthode 1 : Installation automatique (recommandée)

1. **Téléchargez** ou clonez le projet
2. **Ouvrez un terminal** dans le dossier du projet
3. **Lancez l'installation** :
   ```bash
   cd Prompt_Generator
   bash install.sh
   ```

#### Méthode 2 : Avec Make

Si vous avez `make` installé :

```bash
cd Prompt_Generator
make install
```

#### Méthode 3 : Installation manuelle

```bash
# Installer les dépendances
python3 -m pip install --user gradio pyperclip

# Installer xclip (recommandé)
sudo apt install xclip xsel

# Lancer l'application
python3 prompt_generator.py
```

### 🍎 macOS

1. **Téléchargez** le projet
2. **Double-cliquez** sur `install.command`
3. Si macOS bloque l'exécution :
   - **Clic droit** sur `install.command`
   - Choisissez **"Ouvrir"**
   - Confirmez l'ouverture

Ou via le terminal :
```bash
cd Prompt_Generator
bash install.command
```

### 🪟 Windows

1. **Téléchargez** le projet
2. **Double-cliquez** sur `install.bat`
3. Suivez les instructions à l'écran

Ou via l'invite de commandes :
```cmd
cd Prompt_Generator
install.bat
```

---

## 🚀 Utilisation

### Lancer l'application

#### Linux
- **Option 1** : Cherchez "Prompt Generator" dans votre menu d'applications
- **Option 2** : Cliquez sur l'icône dans votre barre latérale (favoris)
- **Option 3** : Via le terminal :
  ```bash
  python3 ~/Documents/Prompts/Prompt_Generator/prompt_generator.py
  ```
- **Option 4** : Avec Make :
  ```bash
  cd ~/Documents/Prompts/Prompt_Generator
  make run
  ```

#### macOS
- **Double-cliquez** sur `Prompt_Generator.command` sur votre bureau

#### Windows
- **Double-cliquez** sur le raccourci `Prompt_Generator` sur votre bureau

### Interface web

Une fois lancée, l'application s'ouvre automatiquement dans votre navigateur à l'adresse :

```
http://127.0.0.1:7860
```

### Guide d'utilisation

1. **Définissez le rôle** de l'IA (ex: "Expert en Python", "Coach en productivité")
2. **Précisez votre profil** et le public cible
3. **Décrivez votre objectif** et le contexte technique
4. **Choisissez le format** de sortie souhaité
5. **Ajoutez des restrictions** (ce que l'IA ne doit PAS faire)
6. **Fournissez un exemple** de résultat attendu (très important !)
7. **Sélectionnez le ton** approprié
8. **Cliquez sur "GÉNÉRER LE PROMPT"**
9. **Copiez** ou **sauvegardez** le prompt généré

---

## 📁 Structure du projet

### Avant installation

```
Prompt_Generator/
├── prompt_generator.py      # Application principale
├── launch.sh               # Script de lancement (créé par install.sh)
├── install.sh               # Script d'installation Linux
├── install.command          # Script d'installation macOS
├── install.bat              # Script d'installation Windows
├── Makefile                 # Automatisation des tâches (Linux)
├── README.md                # Ce fichier
├── Icon/
│   ├── icon.png            # Icône de l'application (Linux/macOS)
│   ├── icon.ico            # Icône de l'application (Windows)
│   └── icon.icns           # Icône de l'application (macOS native)
└── Template_Prompts/        # Dossier pour templates (peut être vide)
```

### Après installation

```
~/Documents/Prompts/Prompt_Generator/
├── prompt_generator.py      # Application copiée
├── launch.sh               # Script de lancement
├── Icon/
│   └── icon.png            # Icône copiée
└── Template_Prompts/        # Vos prompts sauvegardés
    ├── prompt_20251017_143022.txt
    └── prompt_20251017_143045.json
```

---

## 💡 Conseils d'utilisation

### Les 5 règles d'or d'un bon prompt

1. **L'exemple est roi** 👑
   - Fournissez TOUJOURS un exemple concret de ce que vous voulez
   - Plus l'exemple est détaillé, meilleur sera le résultat

2. **Les restrictions guident le comportement** 🚫
   - Spécifiez ce que l'IA ne doit PAS faire
   - Ex: "N'utilise pas de boucles", "Pas de frameworks externes"

3. **Le format doit être explicite** 📋
   - "Code commenté en Python" > "Du code"
   - "Tableau avec colonnes A, B, C" > "Un tableau"

4. **Le contexte prévient les erreurs** 🎯
   - Précisez l'environnement, les contraintes, les versions
   - Ex: "API REST pour production, 10k req/s, PostgreSQL 14"

5. **Testez et affinez** 🔄
   - Un bon prompt s'améliore avec l'usage
   - Sauvegardez vos meilleurs prompts pour les réutiliser

### Exemples de bons prompts

**❌ Mauvais prompt :**
```
Explique-moi les API
```

**✅ Bon prompt :**
```
## RÔLE
Tu es un mentor en développement web.

## PUBLIC CIBLE
Je m'adresse à : Développeur junior
Mon profil : Débutant en ce domaine.

## OBJECTIF
Je veux : Comprendre comment créer et utiliser une API REST
Contexte technique : Application Node.js avec Express, base MongoDB

## FORMAT & STRUCTURE
Format : Guide étape-par-étape
Longueur : Détaillé (600-1000 mots)
Langage : JavaScript (ES6+)

## EXEMPLE DE CE QUE J'ATTENDS
```
1. Configuration du serveur Express
   - Installation des dépendances
   - Structure du projet
   
2. Création des routes
   - GET /api/users
   - POST /api/users
   [...]
```

## TON & STYLE
Ton : Pédagogique (explique les concepts)

## RÉPONSE
Maintenant, réponds en respectant EXACTEMENT les spécifications ci-dessus.
```

---

## 🐛 Dépannage

### L'application ne se lance pas

**Linux :**
```bash
# Vérifier que Python est installé
python3 --version

# Réinstaller les dépendances
python3 -m pip install --user --upgrade gradio pyperclip

# Lancer manuellement
python3 ~/Documents/Prompts/Prompt_Generator/prompt_generator.py
```

**macOS/Windows :**
Vérifiez que Python 3.9+ est installé et ajouté au PATH.

### La copie dans le presse-papier ne fonctionne pas

**Linux :**
Installez xclip et xsel :
```bash
sudo apt install xclip xsel
```

**Tous systèmes :**
Vous pouvez toujours sélectionner et copier manuellement le texte généré (bouton natif Gradio disponible).

### Le raccourci ne fonctionne pas (Linux)

Si le raccourci dans le menu ou la barre latérale ne fonctionne pas :

```bash
# Vérifier que launch.sh existe et est exécutable
ls -la ~/Documents/Prompts/Prompt_Generator/launch.sh

# Le rendre exécutable si nécessaire
chmod +x ~/Documents/Prompts/Prompt_Generator/launch.sh

# Rafraîchir le cache des applications
update-desktop-database ~/.local/share/applications/
```

Ou lancez manuellement :
```bash
python3 ~/Documents/Prompts/Prompt_Generator/prompt_generator.py
```

### Port 7860 déjà utilisé

Si une autre application utilise le port 7860 :

```bash
# Tuer le processus existant
kill -9 $(lsof -ti:7860)

# Ou utiliser un port différent
GRADIO_SERVER_PORT=7861 python3 ~/Documents/Prompts/Prompt_Generator/prompt_generator.py
```

L'application essaiera automatiquement les ports 7860 à 7869.

### Erreur "Module not found: gradio"

Réinstallez les dépendances :
```bash
python3 -m pip install --user --upgrade gradio pyperclip
```

### Message GTK "Not loading module atk-bridge"

Ce message est inoffensif et peut être ignoré. C'est juste un avertissement de l'environnement graphique Linux.

---

## 🧹 Désinstallation

### Linux (avec Make)
```bash
cd ~/Documents/Prompts/Prompt_Generator
make uninstall
```

### Tous systèmes (manuel)
Supprimez simplement le dossier :
```bash
rm -rf ~/Documents/Prompts/Prompt_Generator
```

Et le raccourci (Linux uniquement) :
```bash
rm ~/.local/share/applications/Prompt_Generator.desktop
```

---

## 📄 Licence

**Creative Commons Attribution 4.0 International (CC BY 4.0)**

Vous êtes libre de :
- ✅ **Partager** : copier et redistribuer le matériel
- ✅ **Adapter** : remixer, transformer et créer à partir du matériel
- ✅ **Usage commercial** : utiliser à des fins commerciales

À condition de :
- 📝 **Mentionner l'auteur** : Antoine Blanc
- 🔗 **Indiquer la licence** : CC BY 4.0

Plus d'infos : [https://creativecommons.org/licenses/by/4.0/](https://creativecommons.org/licenses/by/4.0/)

---

## 👤 Auteur

**Antoine Blanc**

📅 Version 2.0 - Octobre 2025

---

## 🙏 Remerciements

Merci à la communauté du Prompt Engineering et aux utilisateurs qui ont contribué à améliorer cet outil.

---

## 🔄 Mises à jour

### Version 2.0 (Octobre 2025)
- ✨ Refonte complète basée sur le Prompt Engineering
- 🎯 Structure optimisée en 7 sections
- 📋 Nouveaux formats de sortie (JSON, tableaux, etc.)
- 🚫 Ajout des restrictions (ce que l'IA ne doit PAS faire)
- 💡 Interface améliorée avec conseils intégrés
- 🔧 Scripts d'installation pour Linux, macOS et Windows
- 📖 Makefile pour automatisation (Linux)
- 🚀 Script launch.sh pour lancement depuis favoris (Linux)
- 🎨 Support multi-OS du presse-papier

---

**🚀 Créez de meilleurs prompts, obtenez de meilleures réponses !**
