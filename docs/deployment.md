# Guide de déploiement

## Prérequis
- Accès à GCP
- Terraform installé
- Ansible installé
- Git installé

## Étapes de déploiement initial

### 1. Infrastructure avec Terraform

# Se placer dans le répertoire Terraform et initialiser
cd terraform
terraform init

# Appliquer la configuration
terraform apply -var-file=terraform.tfvars

### 2. Configuration avec Ansible

# Se placer dans le répertoire Ansible et exécuter le playbook
cd ansible
ansible-playbook -i inventory.yml playbook.yml

### 3. Déploiement manuel initial

# Construire l'image Docker
docker build -t ghcr.io/omarovic42/mobile-api:v1.0.0 ./api

# Se connecter au GitHub Container Registry
docker login ghcr.io -u Omarovic42

# Pousser l'image
docker push ghcr.io/omarovic42/mobile-api:v1.0.0

