# Test-Ansible-PowerShell.ps1 - Test d'Ansible via PowerShell

Write-Host "🧪 Test d'Ansible via PowerShell" -ForegroundColor Magenta
Write-Host ""

# Fonction pour exécuter Ansible via Python
function Invoke-AnsibleCommand {
    param(
        [string]$Module,
        [string[]]$Arguments
    )
    
    $cmd = "python -m ansible.cli.$Module " + ($Arguments -join " ")
    Write-Host "Exécution: $cmd" -ForegroundColor Gray
    
    try {
        $result = Invoke-Expression $cmd 2>$null
        return $result
    } catch {
        Write-Warning "Erreur: $_"
        return $null
    }
}

# Test 1: Inventaire
Write-Host "📋 Test de l'inventaire..." -ForegroundColor Yellow
$inventoryResult = Invoke-AnsibleCommand "inventory" @("-i", "ansible/inventory/hosts.yml", "--list")

if ($inventoryResult -and $inventoryResult -like "*staging*") {
    Write-Host "✅ Inventaire fonctionne!" -ForegroundColor Green
    Write-Host "Aperçu:" -ForegroundColor Gray
    $inventoryResult | Select-Object -First 10 | ForEach-Object { Write-Host "  $_" -ForegroundColor White }
} else {
    Write-Warning "Problème avec l'inventaire"
}

# Test 2: Ping simple (ne nécessite pas de connexion réelle)
Write-Host ""
Write-Host "📡 Test de ping local..." -ForegroundColor Yellow
$pingResult = Invoke-AnsibleCommand "adhoc" @("-i", "ansible/inventory/hosts.yml", "localhost", "-m", "ping", "--connection=local")

if ($pingResult -and $pingResult -like "*SUCCESS*") {
    Write-Host "✅ Ping local fonctionne!" -ForegroundColor Green
} else {
    Write-Warning "Problème avec le ping local"
}

Write-Host ""
Write-Host "🎯 Pour tester la connexion aux serveurs réels:" -ForegroundColor Cyan
Write-Host "python -m ansible.cli.adhoc -i ansible/inventory/hosts.yml staging -m ping" -ForegroundColor Gray
Write-Host ""
Write-Host "🎯 Pour faire un dry-run du déploiement:" -ForegroundColor Cyan
Write-Host "python -m ansible.cli.playbook -i ansible/inventory/hosts.yml ansible/playbooks/deploy.yml --limit staging --check" -ForegroundColor Gray