@echo off
:: ============================================================
:: INSTALL.BAT - Windows
:: ============================================================
:: Prompt Generator – Script d'installation Windows
:: Auteur : Antoine Blanc
:: Version : 2.0 – Octobre 2025
:: Licence : Creative Commons Attribution 4.0 International (CC BY 4.0)
:: https://creativecommons.org/licenses/by/4.0/
:: ============================================================

chcp 65001 >nul
setlocal enabledelayedexpansion

echo.
echo 🔧 Installation de Prompt Generator (Windows)
echo.

REM --- Obtenir le dossier d'installation actuel ---
set "INSTALL_DIR=%~dp0"
set "INSTALL_DIR=%INSTALL_DIR:~0,-1%"

REM --- Vérifier que les fichiers sources existent (NOM CORRECT) ---
set "PYTHON_FILE=prompt_generator.py"

if not exist "%INSTALL_DIR%\%PYTHON_FILE%" (
    echo ❌ Erreur : %PYTHON_FILE% introuvable dans le dossier d'installation.
    echo Assurez-vous de lancer install.bat depuis le dossier Prompt_Generator.
    pause
    exit /b 1
)

echo ✅ Fichier source trouvé : %PYTHON_FILE%

REM --- Vérifier si Python est installé ---
python --version >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo ❌ Python n'est pas trouvé dans le PATH.
    echo Veuillez installer Python 3.9+ depuis https://www.python.org/downloads/
    echo et cocher "Add Python to PATH" lors de l'installation.
    pause
    exit /b 1
)

echo ✅ Python détecté
python --version

REM --- Installer Gradio et Pyperclip ---
echo.
echo ⚡ Installation de Gradio et Pyperclip...
python -m pip install --upgrade pip >nul 2>&1
python -m pip install gradio pyperclip >nul 2>&1

IF %ERRORLEVEL% NEQ 0 (
    echo ❌ Erreur lors de l'installation des packages Python.
    echo Vérifiez votre connexion internet et les permissions.
    echo Essayez : python -m pip install gradio pyperclip
    pause
    exit /b 1
)

echo ✅ Packages installés avec succès

REM --- Création du dossier de destination ---
echo.
echo 📂 Création du dossier d'installation...
set "BASE_DIR=%USERPROFILE%\Documents\Prompts\Prompt_Generator"

if exist "%BASE_DIR%" (
    echo ⚠️  Le dossier existe déjà. Les fichiers seront écrasés.
)

mkdir "%BASE_DIR%" 2>nul
mkdir "%BASE_DIR%\Icon" 2>nul
mkdir "%BASE_DIR%\Template_Prompts" 2>nul

REM --- Copie des fichiers ---
echo.
echo 📋 Copie des fichiers...

copy /Y "%INSTALL_DIR%\%PYTHON_FILE%" "%BASE_DIR%\" >nul
IF %ERRORLEVEL% NEQ 0 (
    echo ❌ Erreur lors de la copie de %PYTHON_FILE%
    pause
    exit /b 1
)
echo ✅ %PYTHON_FILE% copié

REM --- Copie de l'icône (chercher .ico puis .png) ---
set "ICON_COPIED=0"
set "ICON_PATH="

if exist "%INSTALL_DIR%\Icon\icon.ico" (
    copy /Y "%INSTALL_DIR%\Icon\icon.ico" "%BASE_DIR%\Icon\" >nul
    set "ICON_PATH=%BASE_DIR%\Icon\icon.ico"
    set "ICON_COPIED=1"
    echo ✅ icon.ico copié
) else if exist "%INSTALL_DIR%\Icon\icon.png" (
    copy /Y "%INSTALL_DIR%\Icon\icon.png" "%BASE_DIR%\Icon\" >nul
    set "ICON_PATH=%BASE_DIR%\Icon\icon.png"
    set "ICON_COPIED=1"
    echo ✅ icon.png copié
) else (
    echo ⚠️  Aucune icône trouvée (icon.ico ou icon.png)
)

REM --- Copie des templates existants (optionnel) ---
if exist "%INSTALL_DIR%\Template_Prompts\*.*" (
    xcopy /Y /I "%INSTALL_DIR%\Template_Prompts\*.*" "%BASE_DIR%\Template_Prompts\" >nul 2>&1
    echo ✅ Templates copiés
)

REM --- Création du raccourci bureau ---
echo.
echo 🔗 Création du raccourci sur le bureau...
set "DESKTOP_PATH=%USERPROFILE%\Desktop"
set "SHORTCUT_PATH=%DESKTOP_PATH%\Prompt_Generator.lnk"

REM Créer le raccourci avec PowerShell
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$WshShell = New-Object -ComObject WScript.Shell; ^
    $Shortcut = $WshShell.CreateShortcut('%SHORTCUT_PATH%'); ^
    $Shortcut.TargetPath = 'python'; ^
    $Shortcut.Arguments = '\"%BASE_DIR%\%PYTHON_FILE%\"'; ^
    $Shortcut.WorkingDirectory = '%BASE_DIR%'; ^
    if ('%ICON_COPIED%' -eq '1' -and (Test-Path '%ICON_PATH%')) { $Shortcut.IconLocation = '%ICON_PATH%' }; ^
    $Shortcut.Save()"

IF %ERRORLEVEL% NEQ 0 (
    echo ⚠️  Impossible de créer le raccourci automatiquement.
    echo Vous pouvez créer un raccourci manuellement vers : %BASE_DIR%\%PYTHON_FILE%
) else (
    echo ✅ Raccourci créé sur le bureau
)

REM --- Résumé final ---
echo.
echo ════════════════════════════════════════════════════════════
echo ✅ Installation terminée avec succès !
echo ════════════════════════════════════════════════════════════
echo.
echo 📍 Emplacement : %BASE_DIR%
echo 🚀 Lancement : Double-cliquez sur 'Prompt_Generator.lnk' sur votre bureau
echo 📝 Prompts sauvegardés dans : %BASE_DIR%\Template_Prompts\
echo.
echo 💡 Alternative : Ouvrez l'invite de commandes et lancez :
echo    python "%BASE_DIR%\%PYTHON_FILE%"
echo.
pause
endlocal