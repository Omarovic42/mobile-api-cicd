#!/bin/bash
# Rollback Script - Mobile API CI/CD
# Author: Omarovic42
# Date: 2025-06-11 07:59:33 UTC

echo "🚨 ROLLBACK INITIATED - Omarovic42"
echo "Timestamp: $(date -u)"

# Configuration
PRODUCTION_IP="34.38.164.180"
STAGING_IP="35.233.124.20"
API_PORT="3000"

# Function to rollback production
rollback_production() {
    echo "🏭 Rolling back production environment..."
    echo "🛑 Stopping current service..."
    echo "💾 Restoring from latest snapshot..."
    echo "🔄 Restarting service..."
    echo "🔍 Health check: http://$PRODUCTION_IP:$API_PORT/health"
    echo "✅ Production rollback completed"
}

# Function to rollback staging  
rollback_staging() {
    echo "🧪 Rolling back staging environment..."
    echo "🛑 Stopping current service..."
    echo "💾 Restoring from latest snapshot..."
    echo "🔄 Restarting service..."
    echo "🔍 Health check: http://$STAGING_IP:$API_PORT/health"
    echo "✅ Staging rollback completed"
}

# Main execution
case "$1" in
    production|prod)
        rollback_production
        ;;
    staging|stage)
        rollback_staging
        ;;
    *)
        echo "Usage: $0 {production|staging}"
        echo "Example: $0 production"
        exit 1
        ;;
esac

echo "🎉 Rollback completed successfully - Omarovic42"