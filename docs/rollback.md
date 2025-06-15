# Guide de rollback

Ce document d�crit la proc�dure � suivre pour effectuer un rollback de l'API mobile vers une version ant�rieure en cas de probl�me avec une nouvelle version.

## Pr�requis

- Acc�s SSH aux serveurs
- Connaissance de la version stable � laquelle revenir

## Proc�dure de rollback via scripts

### Sous Windows (PowerShell)

```powershell
# Pour revenir � une version pr�c�dente sur staging
.\rollback\rollback.ps1 -Environment staging -Version v1.0.0

# Pour revenir � une version pr�c�dente sur production
.\rollback\rollback.ps1 -Environment production -Version v1.0.0
```
### Sous Linux/Mac

```bash
# Pour revenir � une version pr�c�dente sur staging
./rollback/rollback.sh staging v1.0.0

# Pour revenir � une version pr�c�dente sur production
./rollback/rollback.sh production v1.0.0
```
# V�rification post-rollback

Apr�s le rollback, v�rifiez que l'API fonctionne correctement:

# V�rifier que l'API r�pond
Invoke-RestMethod -Uri http://[SERVER_IP]:3000/health