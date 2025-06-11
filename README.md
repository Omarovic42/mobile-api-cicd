# Mobile API CI/CD - Omarovic42

## Présentation du projet

Infrastructure complète CI/CD pour une API mobile avec déploiement automatisé.

**Auteur:** Omarovic42  
**Date:** 2025-06-11 07:31:56 UTC  
**Repository:** https://github.com/Omarovic42/mobile-api-cicd  

## Technologies utilisées

- **Infrastructure:** Terraform + GCP
- **Configuration:** Ansible  
- **CI/CD:** GitHub Actions
- **API:** Node.js + Express
- **Base de données:** PostgreSQL
- **Monitoring:** Logs + Health checks

## GitFlow
main (production) ← develop ← feature/initial-setup


## Pipeline CI/CD

1. **Lint** - Vérification du code
2. **Test** - Tests automatisés  
3. **Build** - Construction de l'application
4. **Deploy Staging** - Déploiement de test
5. **Deploy Production** - Déploiement en production
6. **Rollback** - Retour arrière en cas d'échec

## Environnements

- **Staging:** http://35.233.124.20:3000/
- **Production:** http://34.38.164.180:3000/

## Endpoints API

- `GET /health` - Health check
- `GET /api/mobile` - API principale  
- `GET /api/users` - Gestion utilisateurs

## Déploiement

```bash
git clone https://github.com/Omarovic42/mobile-api-cicd.git
cd mobile-api-cicd
cd terraform && terraform init && terraform apply
cd ../ansible && ansible-playbook deploy.yml
cd ../api && npm install && npm start