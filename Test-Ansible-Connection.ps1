# Test-Ansible-Connection.ps1 - Tester la connexion Ansible

Write-Host "🧪 Test de connexion Ansible" -ForegroundColor Magenta
Write-Host ""

# Test de l'inventaire
Write-Host "📋 Test de l'inventaire..." -ForegroundColor Yellow
try {
    ansible-inventory -i ansible/inventory/hosts.yml --list --yaml
    Write-Host "✅ Inventaire OK" -ForegroundColor Green
} catch {
    Write-Error "Problème avec l'inventaire: $_"
    exit 1
}

Write-Host ""
Write-Host "🔍 Test de connexion aux serveurs..." -ForegroundColor Yellow

# Test de ping sur staging
Write-Host "📡 Test de connexion au serveur staging..." -ForegroundColor Cyan
try {
    ansible -i ansible/inventory/hosts.yml staging -m ping
    Write-Host "✅ Connexion staging OK" -ForegroundColor Green
} catch {
    Write-Warning "Problème de connexion staging: $_"
}

Write-Host ""
Write-Host "📡 Test de connexion au serveur production..." -ForegroundColor Cyan
try {
    ansible -i ansible/inventory/hosts.yml production -m ping
    Write-Host "✅ Connexion production OK" -ForegroundColor Green
} catch {
    Write-Warning "Problème de connexion production: $_"
}

Write-Host ""
Write-Host "🎯 Pour déployer sur staging (dry-run):" -ForegroundColor Cyan
Write-Host "ansible-playbook -i ansible/inventory/hosts.yml ansible/playbooks/deploy.yml --limit staging --check" -ForegroundColor Gray