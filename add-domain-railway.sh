#!/bin/bash

# Add custom domain to Railway project
# Requires: RAILWAY_TOKEN environment variable

set -e

if [ -z "$RAILWAY_TOKEN" ]; then
    echo "❌ RAILWAY_TOKEN not set"
    exit 1
fi

DOMAIN="api.gratisgast.nl"

echo "🌐 Adding custom domain to Railway..."

# Login to Railway
railway login --token "$RAILWAY_TOKEN"

# Get project ID
PROJECT_ID=$(railway list 2>/dev/null | grep -i "gratisgast" | awk '{print $1}')

if [ -z "$PROJECT_ID" ]; then
    echo "❌ Project not found. Deploy first with ./deploy.sh"
    exit 1
fi

# Link to project
railway link --project "$PROJECT_ID"

# Add domain
railway domain add "$DOMAIN"

echo "✅ Domain added: $DOMAIN"
echo ""
echo "Next steps:"
echo "1. Go to Railway dashboard → Project → Settings → Domains"
echo "2. Copy the CNAME record"
echo "3. Add it to your domain registrar"
echo "4. Wait for DNS propagation"
