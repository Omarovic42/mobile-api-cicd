# Guide de rollback

Ce document décrit la procédure à suivre pour effectuer un rollback de l'API mobile vers une version antérieure en cas de problème avec une nouvelle version.

## Prérequis

- Accès SSH aux serveurs
- Connaissance de la version stable à laquelle revenir

## Procédure de rollback via scripts

### Sous Windows (PowerShell)

```powershell
# Pour revenir à une version précédente sur staging
.\rollback\rollback.ps1 -Environment staging -Version v1.0.0

# Pour revenir à une version précédente sur production
.\rollback\rollback.ps1 -Environment production -Version v1.0.0
```
### Sous Linux/Mac

```bash
# Pour revenir à une version précédente sur staging
./rollback/rollback.sh staging v1.0.0

# Pour revenir à une version précédente sur production
./rollback/rollback.sh production v1.0.0
```
# Vérification post-rollback

Après le rollback, vérifiez que l'API fonctionne correctement:

# Vérifier que l'API répond
Invoke-RestMethod -Uri http://[SERVER_IP]:3000/health