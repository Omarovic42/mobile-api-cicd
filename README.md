# Mobile API CI/CD Pipeline

## Présentation du projet

### Contexte

Ce projet met en place une infrastructure complète de CI/CD pour une API destinée à une application mobile. L'API est développée en Node.js et expose des endpoints RESTful qui seront consommés par l'application mobile.

### Technologies utilisées

- **Infrastructure**: Google Cloud Platform (GCP)

- **IaC**: Terraform

- **Configuration**: Ansible

- **Conteneurisation**: Docker

- **CI/CD**: GitHub Actions

- **Registry**: GitHub Container Registry (ghcr.io)

- **Monitoring**: Prometheus, Grafana, ELK Stack

- **Langages**: Node.js (API), Shell/PowerShell (scripts)

## Mise en place du GitFlow

Notre workflow Git suit le modèle GitFlow avec les branches suivantes:

- `main` : Code en production, toujours stable

- `develop` : Branche d'intégration pour le développement

- `feature/*` : Branches pour les nouvelles fonctionnalités

- `release/*` : Branches pour la préparation des versions

- `hotfix/*` : Branches pour les correctifs urgents

## Pipeline CI/CD

Notre pipeline CI/CD est implémenté avec GitHub Actions et comprend les étapes suivantes :

### 1. Test

- Exécution des tests unitaires et d'intégration

- Analyse statique du code

### 2. Build

- Construction de l'image Docker

- Tag de l'image avec SHA du commit et latest

### 3. Deploy to Staging

- Déploiement sur l'environnement de staging (35.233.124.20)

- Tests de l'API déployée

### 4. Deploy to Production

- Déploiement sur l'environnement de production (34.38.164.180) après approbation

### 5. Snapshots et Sauvegardes

- Création automatique de snapshots quotidiens des machines virtuelles

- Rétention des snapshots pendant 7 jours

### Configuration du workflow

Le workflow est défini dans [.github/workflows/ci-cd-complete.yml](.github/workflows/ci-cd-complete.yml)

## Packaging et Versionnement

### Versionnement sémantique (SemVer)

Nous utilisons le versionnement sémantique suivant le format `X.Y.Z` :

- **X** : Version majeure (changements incompatibles avec l'API)

- **Y** : Version mineure (fonctionnalités rétrocompatibles)

- **Z** : Version de correctif (corrections de bugs rétrocompatibles)

### Tags Git

Les versions sont créées avec des tags Git :

```bash

git tag -a v1.0.0 -m "Version 1.0.0"

git push origin v1.0.0

```

### Stockage des artefacts

Les images Docker sont stockées dans GitHub Container Registry (ghcr.io) avec des tags correspondant aux versions SemVer et aux SHA des commits.

Gestion des secrets et environnements
-------------------------------------

### Méthode utilisée

Nous utilisons GitHub Secrets pour stocker de manière sécurisée toutes les informations sensibles :

-   SSH_PRIVATE_KEY : Clé SSH pour le déploiement
-   GITHUB_TOKEN : Généré automatiquement pour l'authentification

### Séparation des environnements

Les environnements staging et production sont strictement séparés :

-   Différentes machines virtuelles
-   Workflow avec approbation requise pour la production
-   Variables d'environnement spécifiques à chaque environnement

Mécanismes de sauvegarde et rollback
------------------------------------

### Snapshots automatiques

Des snapshots automatiques sont configurés via Terraform :

-   Fréquence : Quotidienne à 04:00 UTC
-   Rétention : 7 jours
-   Couverture : Serveurs de staging et de production

### Procédure de rollback

En cas de problème avec une nouvelle version, notre solution permet un retour rapide à une version stable :

1.  Via les scripts de rollback dans le répertoire `rollback/`
2.  En utilisant les snapshots GCP pour restaurer un état antérieur complet

### Monitoring et supervision
-------------------------

Notre stack de monitoring comprend :

-   Prometheus : Collecte de métriques
-   Grafana : Visualisation et dashboards
-   ELK Stack : Centralisation et analyse des logs

Des alertes sont configurées pour surveiller :

-   Disponibilité du service
-   Utilisation des ressources
-   Performances de l'API
-   Erreurs applicatives

#### Procédures documentées
----------------------

### Déploiement

La documentation complète du processus de déploiement est disponible dans [docs/deployment.md](https://github.com/copilot/c/docs/deployment.md).

### Rollback

La procédure de rollback est détaillée dans [docs/rollback.md](https://github.com/copilot/c/docs/rollback.md).

### GitFlow

Notre stratégie de branchement est documentée dans [docs/gitflow.md](https://github.com/copilot/c/docs/gitflow.md).

### Structure du dépôt Git
----------------------
mobile-api-cicd/

├── api/                      # Code de l'API Node.js

│   ├── Dockerfile            # Conteneurisation de l'API

│   ├── server.js             # Point d'entrée de l'API

│   ├── package.json          # Dépendances Node.js

│   └── ...                   # Autres fichiers de l'API

├── terraform/                # Scripts Terraform pour l'infrastructure

│   ├── main.tf               # Ressources principales

│   ├── variables.tf          # Définition des variables

│   └── outputs.tf            # Sorties Terraform

├── ansible/                  # Configuration Ansible des serveurs

│   ├── playbook.yml          # Playbook principal

│   ├── inventory.yml         # Inventaire des serveurs

│   └── ...                   # Rôles et tâches Ansible

├── .github/workflows/        # Workflows GitHub Actions

│   └── ci-cd-complete.yml    # Pipeline CI/CD complet

├── monitoring/               # Configuration du monitoring

│   ├── docker-compose.yml    # Stack de monitoring

│   └── prometheus.yml        # Configuration Prometheus

├── rollback/                 # Scripts de rollback

│   ├── rollback.sh           # Script de rollback (Linux)

│   └── rollback.ps1          # Script de rollback (Windows)

├── docs/                     # Documentation supplémentaire

│   ├── deployment.md         # Guide de déploiement

│   ├── rollback.md           # Procédures de rollback

│   └── gitflow.md            # Documentation GitFlow

├── images/                   # Images pour la documentation

└── README.md                 # Documentation principale

### Captures d'écran
----------------

Pour des captures d'écran du projet en action, voir le répertoire [images/](https://github.com/copilot/c/images/) :

-   Exécution du pipeline CI/CD
-   Interface de staging et production
-   Historique Git et branches
-   Dashboard de monitoring
-   Procédures de rollback
