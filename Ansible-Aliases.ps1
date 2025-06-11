# Ansible-Aliases.ps1 - Aliases pour Ansible sur Windows

# Fonction ansible
function ansible-win {
    python -m ansible.cli.adhoc $args
}

# Fonction ansible-playbook
function ansible-playbook-win {
    python -m ansible.cli.playbook $args
}

# Fonction ansible-inventory
function ansible-inventory-win {
    python -m ansible.cli.inventory $args
}

# Fonction ansible-galaxy
function ansible-galaxy-win {
    python -m ansible.cli.galaxy $args
}

Write-Host "🎯 Aliases Ansible chargés!" -ForegroundColor Green
Write-Host "Utilisez: ansible-win, ansible-playbook-win, ansible-inventory-win, ansible-galaxy-win" -ForegroundColor Cyan