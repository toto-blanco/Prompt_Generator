#!/bin/bash
# ============================================================
# INSTALL.COMMAND - macOS
# ============================================================
# Prompt Generator – Script d'installation macOS
# Auteur : Antoine Blanc
# Version : 2.0 – Octobre 2025
# Licence : Creative Commons Attribution 4.0 International (CC BY 4.0)
# https://creativecommons.org/licenses/by/4.0/
# ============================================================

set -e  # Arrêter en cas d'erreur

echo "🍏 Installation de Prompt Generator (macOS)"
echo ""

# --- Obtenir le dossier d'installation actuel ---
INSTALL_DIR="$(cd "$(dirname "$0")" && pwd)"

# --- Vérifier que les fichiers sources existent (NOM CORRECT) ---
PYTHON_FILE="prompt_generator.py"

if [ ! -f "$INSTALL_DIR/$PYTHON_FILE" ]; then
    echo "❌ Erreur : $PYTHON_FILE introuvable dans le dossier d'installation."
    echo "Assurez-vous de lancer install.command depuis le dossier Prompt_Generator."
    exit 1
fi

echo "✅ Fichier source trouvé : $PYTHON_FILE"

# --- Vérification Python ---
if ! command -v python3 &> /dev/null; then
    echo "❌ Python3 non trouvé."
    echo "Installez-le avec : brew install python3"
    echo "Ou téléchargez depuis : https://www.python.org/downloads/"
    exit 1
fi

echo "✅ Python détecté"
python3 --version

# --- Installation Gradio et Pyperclip ---
echo ""
echo "⚡ Installation de Gradio et Pyperclip..."
python3 -m pip install --upgrade pip --quiet 2>/dev/null || true
python3 -m pip install gradio pyperclip --quiet

if [ $? -ne 0 ]; then
    echo "❌ Erreur lors de l'installation des packages Python."
    echo "Vérifiez votre connexion internet et les permissions."
    exit 1
fi

echo "✅ Packages installés avec succès"

# --- Création du dossier de destination ---
echo ""
echo "📂 Création du dossier d'installation..."
BASE_DIR="$HOME/Documents/Prompts/Prompt_Generator"

if [ -d "$BASE_DIR" ]; then
    echo "⚠️  Le dossier existe déjà. Les fichiers seront écrasés."
fi

mkdir -p "$BASE_DIR/Icon"
mkdir -p "$BASE_DIR/Template_Prompts"

# --- Copie des fichiers ---
echo ""
echo "📋 Copie des fichiers..."

cp "$INSTALL_DIR/$PYTHON_FILE" "$BASE_DIR/"
if [ $? -ne 0 ]; then
    echo "❌ Erreur lors de la copie de $PYTHON_FILE"
    exit 1
fi
echo "✅ $PYTHON_FILE copié"

# --- Copie de l'icône ---
ICON_COPIED=0
if [ -f "$INSTALL_DIR/Icon/icon.png" ]; then
    cp "$INSTALL_DIR/Icon/icon.png" "$BASE_DIR/Icon/"
    ICON_PATH="$BASE_DIR/Icon/icon.png"
    ICON_COPIED=1
    echo "✅ icon.png copié"
elif [ -f "$INSTALL_DIR/Icon/icon.icns" ]; then
    cp "$INSTALL_DIR/Icon/icon.icns" "$BASE_DIR/Icon/"
    ICON_PATH="$BASE_DIR/Icon/icon.icns"
    ICON_COPIED=1
    echo "✅ icon.icns copié"
else
    echo "⚠️  Aucune icône trouvée (icon.png ou icon.icns)"
    ICON_PATH=""
fi

# --- Copie des templates existants ---
if [ -d "$INSTALL_DIR/Template_Prompts" ] && [ "$(ls -A "$INSTALL_DIR/Template_Prompts" 2>/dev/null)" ]; then
    cp -r "$INSTALL_DIR/Template_Prompts/"* "$BASE_DIR/Template_Prompts/" 2>/dev/null || true
    echo "✅ Templates copiés"
fi

# --- Création d'un lanceur sur le bureau ---
echo ""
echo "🔗 Création du lanceur sur le bureau..."
APP_SCRIPT="$HOME/Desktop/Prompt_Generator.command"

cat > "$APP_SCRIPT" << EOL
#!/bin/bash
cd "$BASE_DIR"
python3 "$BASE_DIR/$PYTHON_FILE"
EOL

chmod +x "$APP_SCRIPT"

if [ $? -eq 0 ]; then
    echo "✅ Lanceur créé sur le bureau"
else
    echo "⚠️  Impossible de créer le lanceur automatiquement"
fi

# --- Résumé final ---
echo ""
echo "════════════════════════════════════════════════════════════"
echo "✅ Installation terminée avec succès !"
echo "════════════════════════════════════════════════════════════"
echo ""
echo "📍 Emplacement : $BASE_DIR"
echo ""
echo "🚀 LANCEMENT :"
echo "   Option 1 : Double-cliquez sur 'Prompt_Generator.command' sur votre bureau"
echo "   Option 2 : Lancez manuellement :"
echo "             python3 $BASE_DIR/$PYTHON_FILE"
echo ""
echo "📝 Prompts sauvegardés dans : $BASE_DIR/Template_Prompts/"
echo ""
echo "💡 Astuce : Au premier lancement, macOS peut demander l'autorisation"
echo "   d'ouvrir le fichier. Faites clic-droit → Ouvrir pour valider."
echo ""