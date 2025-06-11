@echo off
python -c "
import subprocess
import sys
import os

# Rediriger stderr vers nul pour ?viter les erreurs de descripteur
cmd = ['python', '-m', 'ansible.cli.inventory'] + sys.argv[1:]
try:
    with open(os.devnull, 'w') as devnull:
        result = subprocess.run(cmd, stderr=devnull, text=True, capture_output=True)
        print(result.stdout)
        if result.stderr and 'OSError' not in result.stderr:
            print(result.stderr, file=sys.stderr)
        sys.exit(result.returncode)
except Exception as e:
    print(f'Erreur: {e}', file=sys.stderr)
    sys.exit(1)
"
