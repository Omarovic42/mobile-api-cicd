# Install-AnsibleCollections.ps1 - Installer les collections Ansible

Write-Host "📦 Installation des collections Ansible..." -ForegroundColor Yellow

# Vérifier si ansible-galaxy est disponible
try {
    $null = Get-Command ansible-galaxy -ErrorAction Stop
    Write-Host "✅ ansible-galaxy trouvé" -ForegroundColor Green
    
    # Installer les collections
    Write-Host "🔽 Installation en cours..." -ForegroundColor Cyan
    & ansible-galaxy collection install -r ansible/requirements.yml --force
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Collections installées avec succès!" -ForegroundColor Green
    } else {
        Write-Warning "Erreur lors de l'installation des collections"
    }
} catch {
    Write-Warning "ansible-galaxy n'est pas installé!"
    Write-Host "💡 Installez Ansible avec: pip install ansible" -ForegroundColor Cyan
    exit 1
}

Write-Host ""
Write-Host "🧪 Commandes de test:" -ForegroundColor Cyan
Write-Host "  ansible-inventory -i ansible/inventory/hosts.yml --list" -ForegroundColor Gray
Write-Host "  ansible -i ansible/inventory/hosts.yml all -m ping" -ForegroundColor Gray
Write-Host "  ansible-playbook -i ansible/inventory/hosts.yml ansible/playbooks/deploy.yml --limit staging" -ForegroundColor Gray