"""
============================================================
Prompt Generator v2.0 - Assistant IA Multiplateforme
Auteur : Antoine Blanc
Version : 2.0 - Octobre 2025
Licence : Creative Commons Attribution 4.0 International (CC BY 4.0)
https://creativecommons.org/licenses/by/4.0/
============================================================

Vous etes libre de partager et d'adapter ce script pour tout usage,
a condition de mentionner l'auteur original.
"""

import os
import platform
import gradio as gr
from datetime import datetime
import json
import subprocess
from typing import Tuple
import logging

# --- Configuration du logging ---
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

# --- Gestion multi-OS du presse-papier ---
OS_NAME = platform.system().lower()

try:
    import pyperclip
    PYPERCLIP_AVAILABLE = True
except ImportError:
    PYPERCLIP_AVAILABLE = False
    logger.warning("⚠️ pyperclip non disponible. La copie sera limitée.")

def copy_to_clipboard(text: str) -> Tuple[bool, str]:
    """Copie dans le presse-papier de manière robuste selon l'OS"""
    try:
        if OS_NAME == "linux":
            try:
                subprocess.run(['xclip', '-selection', 'clipboard'], 
                             input=text.encode('utf-8'), 
                             check=True, 
                             timeout=2)
                return True, "✅ Prompt copié dans le presse-papier (xclip)"
            except (subprocess.CalledProcessError, FileNotFoundError, subprocess.TimeoutExpired):
                try:
                    subprocess.run(['xsel', '--clipboard', '--input'], 
                                 input=text.encode('utf-8'), 
                                 check=True, 
                                 timeout=2)
                    return True, "✅ Prompt copié dans le presse-papier (xsel)"
                except (subprocess.CalledProcessError, FileNotFoundError, subprocess.TimeoutExpired):
                    return False, "❌ Erreur : Installez xclip ou xsel\n💡 sudo apt install xclip xsel"
        else:
            if not PYPERCLIP_AVAILABLE:
                return False, "❌ pyperclip non installé. Exécutez : pip install pyperclip"
            pyperclip.copy(text)
            return True, "✅ Prompt copié dans le presse-papier"
    except Exception as e:
        logger.error(f"Erreur copie presse-papier : {e}")
        return False, f"❌ Erreur lors de la copie : {str(e)}"

# --- Détection du répertoire home ---
if OS_NAME == "windows":
    home_dir = os.path.join(os.environ.get("USERPROFILE", os.path.expanduser("~")), "Documents")
elif OS_NAME == "darwin":  # macOS
    home_dir = os.path.join(os.environ.get("HOME", os.path.expanduser("~")), "Documents")
else:  # Linux / Ubuntu
    home_dir = os.path.join(os.environ.get("HOME", os.path.expanduser("~")), "Documents")

# --- Définition des dossiers ---
base_dir = os.path.join(home_dir, "Prompts", "Prompt_Generator")
save_dir = os.path.join(base_dir, "Template_Prompts")

# --- Création automatique des dossiers ---
try:
    os.makedirs(save_dir, exist_ok=True)
    logger.info(f"Dossier de sauvegarde : {save_dir}")
except OSError as e:
    logger.error(f"Erreur création dossiers : {e}")

# --- Options prédéfinies pour les dropdowns ---
PROFILE_OPTIONS = [
    "Débutant complet",
    "Débutant en ce domaine",
    "Confirmé/Intermédiaire",
    "Expert",
    "Expert multi-domaines"
]

AUDIENCE_OPTIONS = [
    "Développeur junior",
    "Développeur senior",
    "Product Manager",
    "Designer UX/UI",
    "Data Analyst",
    "Non-technique/Client",
    "Équipe complète",
    "Étudiant/Apprenant"
]

FORMAT_OPTIONS = [
    "Texte structuré",
    "Markdown avec sections",
    "JSON",
    "Liste numérotée",
    "Tableau",
    "Code commenté",
    "Guide étape-par-étape",
    "Points clés + détails"
]

LENGTH_OPTIONS = [
    "Ultra-synthétique (50-100 mots)",
    "Synthétique (150-250 mots)",
    "Normal (300-500 mots)",
    "Détaillé (600-1000 mots)",
    "Très détaillé (1000+ mots)"
]

LANGUAGE_OPTIONS = [
    "Python (dernière version)",
    "Python 3.9+",
    "JavaScript (ES6+)",
    "TypeScript",
    "SQL",
    "Java",
    "C#",
    "Go",
    "Rust",
    "Pseudo-code",
    "Agnostique (langage-neutral)"
]

TONE_OPTIONS = [
    "Pédagogique (explique les concepts)",
    "Formel et professionnel",
    "Conversationnel et amical",
    "Technique et précis",
    "Créatif et innovant",
    "Sceptique et critique",
    "Encourageant et motivant"
]

# --- Génération du prompt optimisé ---
def generate_prompt(
    role: str,
    profile: str,
    audience: str,
    objective: str,
    context: str,
    restrictions: str,
    format_output: str,
    length: str,
    language: str,
    tone: str,
    example: str,
    clarification_needed: bool
) -> str:
    """Génère un prompt optimisé selon les principes du Prompt Engineering"""
    
    # VALIDATION : Au minimum un champ significatif
    if not any([role, objective, format_output, language]):
        raise ValueError(
            "⚠️ Au minimum requis : Rôle, Objectif, Format, Langage"
        )
    
    prompt_lines = []

    # --- SECTION 1 : RÔLE & AUDIENCE (Fondation) ---
    if role:
        prompt_lines.append(f"## RÔLE")
        prompt_lines.append(f"Tu es {role}.\n")

    if audience:
        prompt_lines.append(f"## PUBLIC CIBLE")
        prompt_lines.append(f"Je m'adresse à : {audience}.")
        if profile:
            prompt_lines.append(f"Mon profil : {profile}.\n")

    # --- SECTION 2 : OBJECTIF PRÉCIS ---
    if objective or context:
        prompt_lines.append(f"## OBJECTIF")
        if objective:
            prompt_lines.append(f"Je veux : {objective}")
        if context:
            prompt_lines.append(f"Contexte technique : {context}\n")

    # --- SECTION 3 : FORMAT & STRUCTURE DE SORTIE ---
    output_specs = []
    if format_output:
        output_specs.append(f"Format : {format_output}")
    if length:
        output_specs.append(f"Longueur : {length}")
    if language:
        output_specs.append(f"Langage : {language}")

    if output_specs:
        prompt_lines.append(f"## FORMAT & STRUCTURE")
        for spec in output_specs:
            prompt_lines.append(spec)
        prompt_lines.append("")

    # --- SECTION 4 : RESTRICTIONS & CE QU'ON NE VEUT PAS ---
    if restrictions:
        prompt_lines.append(f"## RESTRICTIONS & EXCLUSIONS")
        prompt_lines.append(f"NE fais PAS / Évite :")
        prompt_lines.append(f"{restrictions}\n")

    # --- SECTION 5 : EXEMPLE D'EXCELLENCE (TRÈS IMPORTANT) ---
    if example:
        prompt_lines.append(f"## EXEMPLE DE CE QUE J'ATTENDS")
        prompt_lines.append(f"Voici un exemple de réponse idéale :")
        prompt_lines.append(f"\n```\n{example}\n```\n")

    # --- SECTION 6 : TON & STYLE ---
    if tone:
        prompt_lines.append(f"## TON & STYLE")
        prompt_lines.append(f"Ton : {tone}\n")

    # --- SECTION 7 : INSTRUCTION FINALE ---
    if clarification_needed:
        prompt_lines.append(f"## CLARIFICATION")
        prompt_lines.append(
            f"Si tu détectes une ambiguïté ou un manque d'information, "
            f"pose une ou deux questions précises avant de répondre.\n"
        )

    prompt_lines.append(f"## RÉPONSE")
    prompt_lines.append(f"Maintenant, réponds en respectant EXACTEMENT les spécifications ci-dessus.")

    # Joindre et nettoyer
    prompt = "\n".join(filter(str.strip, prompt_lines))
    return prompt

# --- Sauvegarde du prompt ---
def save_prompt(prompt: str, file_format: str = "txt") -> str:
    """Sauvegarde le prompt généré en TXT ou JSON"""
    
    if not prompt or not prompt.strip():
        return "⚠️ Aucun prompt à sauvegarder."
    
    # VALIDATION du format
    if file_format not in ["txt", "json"]:
        return f"❌ Format invalide : {file_format}. Utilisez 'txt' ou 'json'."
    
    try:
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        
        if file_format == "txt":
            file_path = os.path.join(save_dir, f"prompt_{timestamp}.txt")
            with open(file_path, "w", encoding="utf-8") as f:
                f.write(prompt)
            logger.info(f"Prompt sauvegardé : {file_path}")
            
        elif file_format == "json":
            file_path = os.path.join(save_dir, f"prompt_{timestamp}.json")
            data = {
                "timestamp": timestamp,
                "prompt": prompt,
                "metadata": {
                    "os": OS_NAME,
                    "version": "2.0"
                }
            }
            with open(file_path, "w", encoding="utf-8") as f:
                json.dump(data, f, ensure_ascii=False, indent=2)
            logger.info(f"Prompt JSON sauvegardé : {file_path}")
        
        return f"✅ Prompt sauvegardé avec succès !\n📂 {file_path}"
    
    except OSError as e:
        logger.error(f"Erreur sauvegarde fichier : {e}")
        return f"❌ Erreur lors de la sauvegarde : {str(e)}"
    except Exception as e:
        logger.error(f"Erreur inattendue sauvegarde : {e}")
        return f"❌ Erreur inattendue : {str(e)}"

# --- Copie dans le presse-papier (wrapper) ---
def copy_prompt(prompt: str) -> str:
    """Copie le prompt dans le presse-papier"""
    if not prompt or not prompt.strip():
        return "⚠️ Aucun prompt à copier."
    
    success, message = copy_to_clipboard(prompt)
    return message

# --- Interface graphique Gradio ---
with gr.Blocks(title="Prompt Generator v2.0", theme=gr.themes.Soft()) as app:
    gr.Markdown("# 🚀 Prompt Generator v2.0")
    gr.Markdown("**Créez des prompts optimisés selon les principes du Prompt Engineering**")
    gr.Markdown("*Chaque champ est optimisé pour générer des réponses d'IA de haute qualité*")

    # --- GROUPE 1 : RÔLE & AUDIENCE ---
    with gr.Group():
        gr.Markdown("## 👤 RÔLE & AUDIENCE")
        with gr.Row():
            role = gr.Textbox(
                label="Rôle/Expertise de l'IA",
                placeholder="Ex : Expert en Data Science, Architecte Cloud, Mentor en programmation…",
                lines=2
            )
        with gr.Row():
            profile = gr.Dropdown(
                label="Votre profil",
                choices=PROFILE_OPTIONS,
                value="Confirmé/Intermédiaire"
            )
            audience = gr.Dropdown(
                label="Public cible",
                choices=AUDIENCE_OPTIONS,
                value="Développeur junior"
            )

    # --- GROUPE 2 : OBJECTIF & CONTEXTE ---
    with gr.Group():
        gr.Markdown("## 🎯 OBJECTIF & CONTEXTE")
        objective = gr.Textbox(
            label="Objectif précis",
            placeholder="Ex : Créer une API REST en Python / Expliquer la régression linéaire / Optimiser une requête SQL…",
            lines=2
        )
        context = gr.Textbox(
            label="Contexte technique",
            placeholder="Ex : Environnement production, API doit gérer 10k req/s, base de données PostgreSQL…",
            lines=2
        )

    # --- GROUPE 3 : FORMAT & STRUCTURE ---
    with gr.Group():
        gr.Markdown("## 📋 FORMAT & STRUCTURE DE SORTIE")
        with gr.Row():
            format_output = gr.Dropdown(
                label="Format de sortie",
                choices=FORMAT_OPTIONS,
                value="Code commenté"
            )
            length = gr.Dropdown(
                label="Longueur attendue",
                choices=LENGTH_OPTIONS,
                value="Détaillé (600-1000 mots)"
            )
        language = gr.Dropdown(
            label="Langage/Technologie (si applicable)",
            choices=LANGUAGE_OPTIONS,
            value="Python (dernière version)"
        )

    # --- GROUPE 4 : RESTRICTIONS ---
    with gr.Group():
        gr.Markdown("## 🚫 RESTRICTIONS & EXCLUSIONS")
        gr.Markdown("*Ce que l'IA NE doit PAS faire (très puissant pour guider le comportement)*")
        restrictions = gr.Textbox(
            label="Restrictions",
            placeholder="Ex : N'utilise pas de boucles / Pas de frameworks externes / Pas de regex / Pas de hardcoding…",
            lines=2
        )

    # --- GROUPE 5 : EXEMPLE ---
    with gr.Group():
        gr.Markdown("## 📘 EXEMPLE D'EXCELLENCE (Few-Shot Prompting)")
        gr.Markdown("*L'exemple est le critère le PLUS important. Montrez exactement ce que vous voulez.*")
        example = gr.Textbox(
            label="Exemple de résultat attendu",
            placeholder="Collez un exemple détaillé de ce que vous voulez obtenir...",
            lines=4
        )

    # --- GROUPE 6 : TON & STYLE ---
    with gr.Group():
        gr.Markdown("## 🎨 TON & STYLE")
        tone = gr.Dropdown(
            label="Ton souhaité",
            choices=TONE_OPTIONS,
            value="Technique et précis"
        )

    # --- GROUPE 7 : OPTIONS AVANCÉES ---
    with gr.Group():
        gr.Markdown("## ⚙️ OPTIONS AVANCÉES")
        clarification_needed = gr.Checkbox(
            label="L'IA peut poser des questions de clarification si ambiguïté",
            value=True
        )

    # --- BOUTONS D'ACTION ---
    with gr.Group():
        gr.Markdown("## 🔧 ACTIONS")
        with gr.Row():
            generate_btn = gr.Button("⚡ GÉNÉRER LE PROMPT", variant="primary", scale=2)
            copy_btn = gr.Button("📋 Copier", scale=1)
        with gr.Row():
            save_txt_btn = gr.Button("💾 Sauvegarder (TXT)", scale=1)
            save_json_btn = gr.Button("📄 Sauvegarder (JSON)", scale=1)

    # --- OUTPUTS ---
    prompt_output = gr.Textbox(
        label="🧩 PROMPT GÉNÉRÉ (Prêt à copier-coller)",
        lines=20,
        max_lines=50,
        show_copy_button=True
    )
    status_output = gr.Textbox(
        label="📊 Statut",
        lines=2,
        interactive=False
    )

    # --- EVENT LISTENERS ---
    generate_btn.click(
        fn=generate_prompt,
        inputs=[
            role, profile, audience, objective, context,
            restrictions, format_output, length, language,
            tone, example, clarification_needed
        ],
        outputs=prompt_output
    )

    copy_btn.click(
        fn=copy_prompt,
        inputs=[prompt_output],
        outputs=status_output
    )

    save_txt_btn.click(
        fn=lambda p: save_prompt(p, "txt"),
        inputs=[prompt_output],
        outputs=status_output
    )

    save_json_btn.click(
        fn=lambda p: save_prompt(p, "json"),
        inputs=[prompt_output],
        outputs=status_output
    )

    # --- FOOTER ---
    with gr.Group():
        gr.Markdown(
            f"""
            ---
            **💡 Conseils d'utilisation :**
            1. L'**exemple** est le critère le PLUS important → soyez précis et détaillé
            2. Les **restrictions** guident fortement le comportement de l'IA
            3. Utilisez un **format explicite** pour des résultats reproductibles
            4. Le **contexte technique** prévient les erreurs d'adaptation
            5. Testez votre prompt → affinez si besoin
            
            ---
            📂 **Dossier de sauvegarde** : `{save_dir}`  
            💻 **Système détecté** : {OS_NAME.capitalize()}  
            📌 **Version** : 2.0 | **Auteur** : Antoine Blanc | **Licence** : CC BY 4.0
            """
        )

# --- LANCEMENT ---
if __name__ == "__main__":
    try:
        logger.info("Démarrage de Prompt Generator v2.0...")
        logger.info(f"Dossier de sauvegarde : {save_dir}")
        logger.info(f"Système : {OS_NAME.capitalize()}")
        
        app.launch(
            server_name="127.0.0.1",
            server_port=7860,
            share=False,
            inbrowser=True,
            quiet=False
        )
    except Exception as e:
        logger.error(f"Erreur au lancement : {e}")
        print("❌ Erreur au lancement : {e}")
        print("💡 Vérifiez que le port 7860 est libre ou relancez l'application")