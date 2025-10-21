#!/bin/bash
# ============================================================
# INSTALL.SH - Linux (Version 2.0 - Optimisée)
# ============================================================
# Prompt Generator – Script d'installation Linux
# Auteur : Antoine Blanc
# Version : 2.0 – Octobre 2025
# Licence : Creative Commons Attribution 4.0 International (CC BY 4.0)
# https://creativecommons.org/licenses/by/4.0/
# ============================================================

set -e  # Arrêter en cas d'erreur

echo "🐧 Installation de Prompt Generator (Linux)"
echo ""

# --- Déterminer le dossier d'installation actuel ---
INSTALL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# --- VÉRIFICATION 1 : Fichier Python existe (NOM CORRECT) ---
PYTHON_FILE="prompt_generator.py"

if [ ! -f "$INSTALL_DIR/$PYTHON_FILE" ]; then
    echo "❌ Erreur : $PYTHON_FILE introuvable dans $INSTALL_DIR"
    echo "Assurez-vous de lancer install.sh depuis le dossier Prompt_Generator."
    exit 1
fi

echo "✅ Fichier source trouvé : $PYTHON_FILE"

# --- VÉRIFICATION 2 : Python 3 disponible ---
if ! command -v python3 &> /dev/null; then
    echo "❌ Python3 non trouvé."
    echo "Installez-le avec : sudo apt install python3 python3-pip"
    exit 1
fi

echo "✅ Python détecté :"
python3 --version

# --- VÉRIFICATION 3 : pip disponible ---
if ! command -v pip3 &> /dev/null; then
    echo "❌ pip3 non trouvé."
    echo "Installez-le avec : sudo apt install python3-pip"
    exit 1
fi

# --- VÉRIFICATION 4 : Dépendances système pour presse-papier ---
echo ""
echo "🔍 Vérification des dépendances système..."

CLIPBOARD_TOOL_FOUND=0

if command -v xclip &> /dev/null; then
    echo "✅ xclip trouvé (copie/pâte fonctionnera)"
    CLIPBOARD_TOOL_FOUND=1
elif command -v xsel &> /dev/null; then
    echo "✅ xsel trouvé (copie/pâte fonctionnera)"
    CLIPBOARD_TOOL_FOUND=1
else
    echo "⚠️  Ni xclip ni xsel trouvés. La copie dans le presse-papier sera limitée."
    echo "   Pour l'activer : sudo apt install xclip"
fi

# --- INSTALLATION DES PACKAGES PYTHON ---
echo ""
echo "⚡ Installation de Gradio et Pyperclip..."

python3 -m pip install --upgrade pip --user --quiet 2>/dev/null || {
    echo "⚠️  Impossible de mettre à jour pip (continuer)"
}

python3 -m pip install --user gradio pyperclip --quiet

if [ $? -ne 0 ]; then
    echo "❌ Erreur lors de l'installation des packages Python."
    echo "Essayez : python3 -m pip install --user gradio pyperclip"
    exit 1
fi

echo "✅ Packages installés avec succès"

# --- CRÉATION DES DOSSIERS ---
echo ""
echo "📂 Création du dossier d'installation..."

BASE_DIR="$HOME/Documents/Prompts/Prompt_Generator"

if [ -d "$BASE_DIR" ]; then
    echo "⚠️  Le dossier $BASE_DIR existe déjà."
    read -p "Voulez-vous écraser les fichiers ? (o/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Oo]$ ]]; then
        echo "❌ Installation annulée."
        exit 1
    fi
fi

mkdir -p "$BASE_DIR/Icon"
mkdir -p "$BASE_DIR/Template_Prompts"

# --- COPIE DES FICHIERS PYTHON ---
echo ""
echo "📋 Copie des fichiers..."

cp "$INSTALL_DIR/$PYTHON_FILE" "$BASE_DIR/"
if [ $? -ne 0 ]; then
    echo "❌ Erreur lors de la copie de $PYTHON_FILE"
    exit 1
fi
echo "✅ $PYTHON_FILE copié"

# --- COPIE DE L'ICÔNE ---
ICON_PATH=""

if [ -f "$INSTALL_DIR/Icon/icon.png" ]; then
    cp "$INSTALL_DIR/Icon/icon.png" "$BASE_DIR/Icon/"
    ICON_PATH="$BASE_DIR/Icon/icon.png"
    echo "✅ icon.png copié"
elif [ -f "$INSTALL_DIR/Icon/icon.ico" ]; then
    cp "$INSTALL_DIR/Icon/icon.ico" "$BASE_DIR/Icon/"
    ICON_PATH="$BASE_DIR/Icon/icon.ico"
    echo "✅ icon.ico copié"
else
    echo "⚠️  Aucune icône trouvée (icon.png ou icon.ico) → sera ignorée"
fi

# --- COPIE DES TEMPLATES ---
if [ -d "$INSTALL_DIR/Template_Prompts" ] && [ -n "$(ls -A "$INSTALL_DIR/Template_Prompts" 2>/dev/null)" ]; then
    cp -r "$INSTALL_DIR/Template_Prompts/"* "$BASE_DIR/Template_Prompts/" 2>/dev/null || true
    echo "✅ Templates copiés"
fi

# --- CRÉATION DU RACCOURCI .DESKTOP ---
echo ""
echo "🔗 Création du raccourci d'application..."

DESKTOP_DIR="$HOME/.local/share/applications"
DESKTOP_FILE="$DESKTOP_DIR/Prompt_Generator.desktop"

mkdir -p "$DESKTOP_DIR"

# Créer le fichier .desktop (NE PAS rendre exécutable)
cat > "$DESKTOP_FILE" << EOL
[Desktop Entry]
Version=1.0
Type=Application
Name=Prompt Generator
Comment=Générateur de prompts optimisés pour IA
Exec=python3 "$BASE_DIR/$PYTHON_FILE"
$([ -n "$ICON_PATH" ] && echo "Icon=$ICON_PATH")
Terminal=false
Categories=Development;Utility;
Keywords=prompt;ai;generator;
EOL

chmod 644 "$DESKTOP_FILE"

if [ $? -eq 0 ]; then
    echo "✅ Raccourci .desktop créé"
else
    echo "⚠️  Impossible de créer le raccourci"
fi

# --- MISE À JOUR DU CACHE DES APPLICATIONS ---
if command -v update-desktop-database &> /dev/null; then
    update-desktop-database "$DESKTOP_DIR" 2>/dev/null || true
    echo "✅ Cache d'applications mise à jour"
fi

# --- RÉSUMÉ FINAL ---
echo ""
echo "════════════════════════════════════════════════════════════"
echo "✅ Installation terminée avec succès !"
echo "════════════════════════════════════════════════════════════"
echo ""
echo "📍 Emplacement : $BASE_DIR"
echo ""
echo "🚀 LANCEMENT :"
echo "   Option 1 : Cherchez 'Prompt Generator' dans votre menu"
echo "   Option 2 : Lancez manuellement :"
echo "             python3 $BASE_DIR/$PYTHON_FILE"
echo ""
echo "📝 Prompts sauvegardés dans : $BASE_DIR/Template_Prompts/"
echo ""

if [ $CLIPBOARD_TOOL_FOUND -eq 0 ]; then
    echo "💡 Conseil : Installez xclip pour la copie au presse-papier :"
    echo "   sudo apt install xclip"
fi

echo ""