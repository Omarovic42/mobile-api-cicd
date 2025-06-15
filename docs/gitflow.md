# Stratégie GitFlow pour Mobile API

## Branches principales
- `main` : Code en production, toujours stable
- `develop` : Branche d'intégration pour le développement

## Branches de travail
- `feature/*` : Nouvelles fonctionnalités (ex: `feature/auth-api`)
- `release/*` : Préparation des versions (ex: `release/1.0.0`)
- `hotfix/*` : Correctifs d'urgence (ex: `hotfix/1.0.1`)

## Workflow

1. **Développement de fonctionnalités**
   ```powershell
   # Créer une branche feature depuis develop
   git checkout develop
   git pull
   git checkout -b feature/nom-feature
   
   # Développer la fonctionnalité
   # [Modifications du code]
   
   # Commiter les changements
   git add .
   git commit -m "Ajout de fonctionnalité: description"
   ```