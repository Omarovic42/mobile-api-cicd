#!/bin/bash

# Script de rollback pour l'API Mobile
# Date de création : 2025-06-15
# Auteur: Omarovic42

set -e

# Variables
ENV=$1
VERSION=$2

if [ "$ENV" != "staging" ] && [ "$ENV" != "production" ]; then
    echo "Usage: $0 <staging|production> <version>"
    exit 1
fi

if [ -z "$VERSION" ]; then
    echo "Usage: $0 <staging|production> <version>"
    exit 1
fi

# Détermine le serveur cible
if [ "$ENV" == "staging" ]; then
    SERVER="chelsea42_om@35.233.124.20"
else
    SERVER="chelsea42_om@34.38.164.180"
fi

echo "Rollback vers la version $VERSION sur $ENV..."
ssh -i ~/.ssh/mobile_api_rsa_key $SERVER "docker stop mobile-api || true && docker rm mobile-api || true && docker pull ghcr.io/omarovic42/mobile-api:${VERSION} && docker run -d --name mobile-api -p 3000:3000 -e NODE_ENV=production -e PORT=3000 --restart always ghcr.io/omarovic42/mobile-api:${VERSION} && docker ps"
echo "Rollback terminé avec succès!"
