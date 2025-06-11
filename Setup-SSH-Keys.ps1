# Setup-SSH-Keys.ps1 - Configuration complète des clés SSH

Write-Host "🔑 Configuration des clés SSH pour Mobile API CI/CD" -ForegroundColor Magenta
Write-Host "Production: 34.38.164.180 | Staging: 35.233.124.20" -ForegroundColor Blue
Write-Host ""

# 1. Instructions pour générer les clés SSH
Write-Host "📋 Étape 1: Génération des clés SSH" -ForegroundColor Yellow
Write-Host ""
Write-Host "Exécutez ces commandes dans Git Bash ou WSL:" -ForegroundColor Cyan
Write-Host ""
Write-Host "# Générer une nouvelle paire de clés" -ForegroundColor Gray
Write-Host "ssh-keygen -t ed25519 -C 'Omarovic42@mobile-api-cicd' -f ~/.ssh/mobile-api-key -N ''" -ForegroundColor White
Write-Host ""
Write-Host "# Ou si ed25519 n'est pas supporté:" -ForegroundColor Gray
Write-Host "ssh-keygen -t rsa -b 4096 -C 'Omarovic42@mobile-api-cicd' -f ~/.ssh/mobile-api-key -N ''" -ForegroundColor White
Write-Host ""

Write-Host "📋 Étape 2: Copier les clés sur les serveurs" -ForegroundColor Yellow
Write-Host ""
Write-Host "# Copier sur le serveur de staging" -ForegroundColor Gray
Write-Host "ssh-copy-id -i ~/.ssh/mobile-api-key.pub omarovic42@35.233.124.20" -ForegroundColor White
Write-Host ""
Write-Host "# Copier sur le serveur de production" -ForegroundColor Gray
Write-Host "ssh-copy-id -i ~/.ssh/mobile-api-key.pub omarovic42@34.38.164.180" -ForegroundColor White
Write-Host ""

Write-Host "📋 Étape 3: Tester les connexions" -ForegroundColor Yellow
Write-Host ""
Write-Host "# Test staging" -ForegroundColor Gray
Write-Host "ssh -i ~/.ssh/mobile-api-key omarovic42@35.233.124.20 'echo Staging OK'" -ForegroundColor White
Write-Host ""
Write-Host "# Test production" -ForegroundColor Gray
Write-Host "ssh -i ~/.ssh/mobile-api-key omarovic42@34.38.164.180 'echo Production OK'" -ForegroundColor White
Write-Host ""

Write-Host "📋 Étape 4: Afficher la clé privée pour GitHub" -ForegroundColor Yellow
Write-Host ""
Write-Host "cat ~/.ssh/mobile-api-key" -ForegroundColor White
Write-Host ""

Write-Host "🌐 Étape 5: Configurer les secrets GitHub" -ForegroundColor Yellow
Write-Host ""
Write-Host "Allez sur: https://github.com/Omarovic42/mobile-api-cicd/settings/secrets/actions" -ForegroundColor Cyan
Write-Host ""
Write-Host "Ajoutez ces secrets:" -ForegroundColor White
Write-Host "- Name: SSH_PRIVATE_KEY" -ForegroundColor Gray
Write-Host "  Value: [contenu complet de ~/.ssh/mobile-api-key]" -ForegroundColor Gray
Write-Host ""
Write-Host "⚠️ Important: Copiez TOUT le contenu de la clé privée," -ForegroundColor Yellow
Write-Host "   y compris les lignes -----BEGIN ... KEY----- et -----END ... KEY-----" -ForegroundColor Yellow
Write-Host ""

Write-Host "✅ Une fois configuré, votre pipeline pourra se connecter aux serveurs!" -ForegroundColor Green