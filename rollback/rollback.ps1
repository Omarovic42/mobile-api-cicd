# Script PowerShell de rollback pour l'API Mobile
# Date de création : 2025-06-15
# Auteur: Omarovic42

param (
    [Parameter(Mandatory=$true)]
    [ValidateSet("staging", "production")]
    [string]$Environment,
    
    [Parameter(Mandatory=$true)]
    [string]$Version
)

# Détermine le serveur cible
if ($Environment -eq "staging") {
    $Server = "35.233.124.20"
} else {
    $Server = "34.38.164.180"
}

Write-Host "Rollback vers la version $Version sur $Environment..."

# Connexion SSH et exécution du rollback
$DeployScript = @"
docker stop mobile-api || true
docker rm mobile-api || true
docker pull ghcr.io/omarovic42/mobile-api:${Version}
docker run -d --name mobile-api -p 3000:3000 -e NODE_ENV=production -e PORT=3000 --restart always ghcr.io/omarovic42/mobile-api:${Version}
docker ps
"@

ssh -i C:\Users\omadjidi\mobile_api_rsa_key chelsea42_om@$Server $DeployScript

Write-Host "Rollback terminé avec succès!"
