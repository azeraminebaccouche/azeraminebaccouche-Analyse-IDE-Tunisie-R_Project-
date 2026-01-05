# Instructions pour synchroniser avec GitHub

Ce guide vous explique comment supprimer tous les fichiers du dépôt GitHub et les remplacer par vos fichiers locaux.

## Méthode 1 : Utiliser le script batch (Recommandé)

1. Double-cliquez sur `sync_with_github.bat` dans votre dossier de projet
2. Suivez les instructions à l'écran
3. Entrez vos identifiants GitHub quand demandé (utilisez un Personal Access Token si vous avez 2FA activé)

## Méthode 2 : Utiliser le script PowerShell

1. Ouvrez PowerShell dans votre dossier de projet
2. Exécutez : `.\sync_with_github.ps1`
3. Suivez les instructions

## Méthode 3 : Commandes manuelles

Ouvrez Git Bash ou PowerShell dans votre dossier de projet et exécutez :

```bash
# Ajouter le remote si pas déjà fait
git remote add origin https://github.com/azeraminebaccouche/Analyse-IDE-Tunisie-R_Project-.git

# Récupérer le dépôt distant
git fetch origin

# Passer à la branche main
git checkout -b main origin/main
# OU si la branche existe déjà :
git checkout main
git pull origin main

# Supprimer tous les fichiers trackés (mais garder les fichiers locaux)
git rm -rf --cached .

# Ajouter tous les fichiers locaux
git add .

# Créer un commit
git commit -m "Mise à jour: remplacement de tous les fichiers par les fichiers locaux"

# Pousser vers GitHub (force push pour remplacer tout)
git push -u origin main --force
```

## Notes importantes

- Le `--force` est nécessaire pour remplacer complètement le contenu du dépôt
- Vous devrez entrer vos identifiants GitHub
- Si vous utilisez 2FA, créez un Personal Access Token : https://github.com/settings/tokens
- Les fichiers `.RData` et `.Rhistory` seront automatiquement exclus grâce au `.gitignore`

## Vérification

Après la synchronisation, vérifiez votre dépôt à :
https://github.com/azeraminebaccouche/Analyse-IDE-Tunisie-R_Project-

