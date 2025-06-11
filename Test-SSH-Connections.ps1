# Test-SSH-Connections.ps1 - Tester les connexions SSH

Write-Host "🧪 Test des connexions SSH vers les serveurs" -ForegroundColor Magenta
Write-Host ""

# Test staging
Write-Host "📡 Test de connexion staging (35.233.124.20)..." -ForegroundColor Yellow
try {
    $stagingTest = ssh -o ConnectTimeout=10 -i ~/.ssh/mobile-api-key omarovic42@35.233.124.20 'echo "Staging connection successful"' 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Staging: Connexion réussie" -ForegroundColor Green
    } else {
        Write-Host "❌ Staging: Échec de connexion" -ForegroundColor Red
        Write-Host "Erreur: $stagingTest" -ForegroundColor Gray
    }
} catch {
    Write-Host "❌ Staging: Exception - $_" -ForegroundColor Red
}

Write-Host ""

# Test production
Write-Host "📡 Test de connexion production (34.38.164.180)..." -ForegroundColor Yellow
try {
    $prodTest = ssh -o ConnectTimeout=10 -i ~/.ssh/mobile-api-key omarovic42@34.38.164.180 'echo "Production connection successful"' 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Production: Connexion réussie" -ForegroundColor Green
    } else {
        Write-Host "❌ Production: Échec de connexion" -ForegroundColor Red
        Write-Host "Erreur: $prodTest" -ForegroundColor Gray
    }
} catch {
    Write-Host "❌ Production: Exception - $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "💡 Si les tests échouent, vérifiez:" -ForegroundColor Yellow
Write-Host "- Les clés SSH sont bien générées" -ForegroundColor White
Write-Host "- Les clés publiques sont copiées sur les serveurs" -ForegroundColor White
Write-Host "- Les serveurs sont accessibles" -ForegroundColor White
Write-Host "- L'utilisateur omarovic42 existe sur les serveurs" -ForegroundColor White