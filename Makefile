# ============================================================
# Prompt Generator - Makefile d'automatisation (v2.0)
# Auteur : Antoine Blanc
# Version : 2.0 - Octobre 2025
# Licence : Creative Commons Attribution 4.0 International (CC BY 4.0)
# https://creativecommons.org/licenses/by/4.0/
# ============================================================

.PHONY: help install run clean update uninstall check-python check-app-exists

# --- Variables ---
PYTHON := python3
PIP := $(PYTHON) -m pip
INSTALL_DIR := $(shell pwd)
BASE_DIR := $(HOME)/Documents/Prompts/Prompt_Generator
APP_FILE := prompt_generator.py
ICON_DIR := $(BASE_DIR)/Icon
TEMPLATE_DIR := $(BASE_DIR)/Template_Prompts
DESKTOP_FILE := $(HOME)/.local/share/applications/Prompt_Generator.desktop

# ============================================================
# 📖 AIDE (target par défaut)
# ============================================================
help:
	@echo "════════════════════════════════════════════════════════════"
	@echo "🚀 Prompt Generator - Makefile"
	@echo "════════════════════════════════════════════════════════════"
	@echo ""
	@echo "📋 Commandes disponibles :"
	@echo ""
	@echo "  make install      - Installe les dépendances et copie l'app"
	@echo "  make run          - Lance l'application"
	@echo "  make clean        - Nettoie les fichiers temporaires Python"
	@echo "  make update       - Met à jour les dépendances"
	@echo "  make uninstall    - Supprime l'application"
	@echo "  make help         - Affiche cette aide"
	@echo ""
	@echo "📍 Source : $(INSTALL_DIR)"
	@echo "📍 Installation : $(BASE_DIR)"
	@echo "════════════════════════════════════════════════════════════"
	@echo ""

# ============================================================
# 1️⃣ INSTALLATION
# Installe les dépendances, copie les fichiers et crée le raccourci
# ============================================================
install: check-python
	@echo "🔧 Installation de Prompt Generator..."
	@echo ""
	@if [ ! -f "$(INSTALL_DIR)/$(APP_FILE)" ]; then \
		echo "❌ Erreur : $(APP_FILE) introuvable dans $(INSTALL_DIR)"; \
		echo "Assurez-vous d'être dans le bon dossier"; \
		exit 1; \
	fi
	@echo "⚡ Installation des dépendances Python..."
	@$(PIP) install --upgrade pip --user --quiet 2>/dev/null || true
	@$(PIP) install --user gradio pyperclip --quiet
	@if [ $$? -eq 0 ]; then \
		echo "✅ Packages installés avec succès"; \
	else \
		echo "❌ Erreur lors de l'installation des packages"; \
		exit 1; \
	fi
	@echo ""
	@echo "📂 Création de la structure des dossiers..."
	@mkdir -p $(BASE_DIR)
	@mkdir -p $(ICON_DIR)
	@mkdir -p $(TEMPLATE_DIR)
	@echo "✅ Dossiers créés"
	@echo ""
	@echo "📋 Copie des fichiers..."
	@cp "$(INSTALL_DIR)/$(APP_FILE)" "$(BASE_DIR)/"
	@echo "✅ $(APP_FILE) copié"
	@if [ -d "$(INSTALL_DIR)/Icon" ]; then \
		cp -r "$(INSTALL_DIR)/Icon/"* "$(ICON_DIR)/" 2>/dev/null || true; \
		echo "✅ Icône(s) copiée(s)"; \
	fi
	@if [ -d "$(INSTALL_DIR)/Template_Prompts" ] && [ "$$(ls -A $(INSTALL_DIR)/Template_Prompts 2>/dev/null)" ]; then \
		cp "$(INSTALL_DIR)/Template_Prompts/"* "$(TEMPLATE_DIR)/" 2>/dev/null || true; \
		echo "✅ Templates copiés"; \
	fi
	@echo ""
	@echo "🔗 Création du raccourci d'application..."
	@mkdir -p $(HOME)/.local/share/applications
	@echo "[Desktop Entry]" > $(DESKTOP_FILE)
	@echo "Name=Prompt Generator" >> $(DESKTOP_FILE)
	@echo "Comment=Générateur de prompts pour Data Analyst" >> $(DESKTOP_FILE)
	@echo "Exec=$(PYTHON) \"$(BASE_DIR)/$(APP_FILE)\"" >> $(DESKTOP_FILE)
	@if [ -f "$(ICON_DIR)/icon.png" ]; then \
		echo "Icon=$(ICON_DIR)/icon.png" >> $(DESKTOP_FILE); \
	fi
	@echo "Terminal=false" >> $(DESKTOP_FILE)
	@echo "Type=Application" >> $(DESKTOP_FILE)
	@echo "Categories=Development;Utility;" >> $(DESKTOP_FILE)
	@chmod +x $(DESKTOP_FILE)
	@echo "✅ Raccourci créé"
	@echo ""
	@echo "════════════════════════════════════════════════════════════"
	@echo "✅ Installation terminée avec succès !"
	@echo "════════════════════════════════════════════════════════════"
	@echo ""
	@echo "📍 Emplacement : $(BASE_DIR)"
	@echo "🚀 Lancement : make run"
	@echo "📝 Prompts sauvegardés dans : $(TEMPLATE_DIR)"
	@echo ""

# ============================================================
# 2️⃣ LANCER L'APPLICATION
# Vérifie que l'app existe puis la lance
# ============================================================
run: check-app-exists
	@echo "🚀 Lancement de Prompt Generator..."
	@echo ""
	@echo "💡 L'application devrait s'ouvrir automatiquement dans votre navigateur"
	@echo "   Si ce n'est pas le cas, ouvrez : http://127.0.0.1:7860"
	@echo ""
	@$(PYTHON) "$(BASE_DIR)/$(APP_FILE)"

# ============================================================
# 3️⃣ NETTOYAGE
# Supprime les fichiers compilés et les caches Python
# ============================================================
clean:
	@echo "🧹 Nettoyage des fichiers temporaires..."
	@find $(BASE_DIR) -type f -name "*.pyc" -delete 2>/dev/null || true
	@find $(BASE_DIR) -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	@find $(BASE_DIR) -type d -name "*.egg-info" -exec rm -rf {} + 2>/dev/null || true
	@find $(INSTALL_DIR) -type f -name "*.pyc" -delete 2>/dev/null || true
	@find $(INSTALL_DIR) -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	@echo "✅ Nettoyage terminé"

# ============================================================
# 4️⃣ MISE À JOUR
# Met à jour les dépendances Python
# ============================================================
update: check-python
	@echo "🔄 Mise à jour des dépendances..."
	@$(PIP) install --upgrade gradio pyperclip --user --quiet
	@if [ $$? -eq 0 ]; then \
		echo "✅ Dépendances mises à jour avec succès"; \
	else \
		echo "❌ Erreur lors de la mise à jour"; \
		exit 1; \
	fi
	@echo ""
	@echo "💡 Si vous avez modifié $(APP_FILE), recopiez-le avec :"
	@echo "   cp $(INSTALL_DIR)/$(APP_FILE) $(BASE_DIR)/"

# ============================================================
# 5️⃣ DÉSINSTALLATION
# Supprime l'application et les dossiers
# ============================================================
uninstall:
	@echo "⚠️  Attention : Cela supprimera l'application et TOUS vos prompts sauvegardés !"
	@echo ""
	@read -p "Êtes-vous sûr ? (o/n) " -r; \
	if [ "$$REPLY" = "o" ] || [ "$$REPLY" = "O" ]; then \
		echo ""; \
		echo "🗑️  Suppression de $(BASE_DIR)..."; \
		rm -rf $(BASE_DIR); \
		echo "🗑️  Suppression du raccourci..."; \
		rm -f $(DESKTOP_FILE); \
		echo "✅ Application supprimée"; \
	else \
		echo ""; \
		echo "❌ Suppression annulée"; \
	fi

# ============================================================
# 🔍 VÉRIFICATIONS (Hidden targets)
# ============================================================

check-python:
	@command -v $(PYTHON) >/dev/null 2>&1 || { \
		echo "❌ $(PYTHON) non trouvé."; \
		echo "Installez-le avec : sudo apt install python3 python3-pip"; \
		exit 1; \
	}
	@echo "✅ $(PYTHON) détecté ($(shell $(PYTHON) --version))"

check-app-exists:
	@if [ ! -f "$(BASE_DIR)/$(APP_FILE)" ]; then \
		echo "❌ Erreur : $(APP_FILE) non trouvé dans $(BASE_DIR)"; \
		echo "Lancez 'make install' d'abord"; \
		exit 1; \
	fi

# ============================================================
# 💡 Notes pour les développeurs
# ============================================================
# IMPORTANT : Ce Makefile utilise des TABS, pas des espaces !
# 
# Variables disponibles :
#   - PYTHON : Commande Python (défaut: python3)
#   - PIP : Commande pip avec module
#   - INSTALL_DIR : Répertoire source du projet
#   - BASE_DIR : Répertoire d'installation (~Documents/Prompts/Prompt_Generator)
#   - APP_FILE : Fichier principal (prompt_generator.py)
#   - TEMPLATE_DIR : Répertoire des prompts sauvegardés
#
# Utilisation :
#   make help       - Voir toutes les commandes
#   make install    - Installation complète
#   make run        - Lancer l'application
#   make clean      - Nettoyer les temporaires
#   make update     - Mettre à jour les dépendances
#   make uninstall  - Supprimer l'application
# ============================================================