#!/bin/bash

# Add custom domain to Vercel project
# Requires: VERCEL_TOKEN environment variable

set -e

if [ -z "$VERCEL_TOKEN" ]; then
    echo "❌ VERCEL_TOKEN not set"
    exit 1
fi

PROJECT_NAME="gratisgast"
DOMAIN="gratisgast.nl"

echo "🌐 Adding custom domain to Vercel..."

# Get project ID
PROJECT_ID=$(curl -s -G "https://api.vercel.com/v9/projects" \
    -H "Authorization: Bearer $VERCEL_TOKEN" \
    -d "search=$PROJECT_NAME" | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)

if [ -z "$PROJECT_ID" ]; then
    echo "❌ Project not found. Deploy first with ./deploy.sh"
    exit 1
fi

echo "Project ID: $PROJECT_ID"

# Add domain
curl -s -X POST "https://api.vercel.com/v10/projects/$PROJECT_ID/domains" \
    -H "Authorization: Bearer $VERCEL_TOKEN" \
    -H "Content-Type: application/json" \
    -d "{\"name\":\"$DOMAIN\",\"gitBranch\":null}" > /dev/null

echo "✅ Domain added: $DOMAIN"
echo ""
echo "Next steps:"
echo "1. Go to Vercel dashboard → Project → Domains"
echo "2. Copy the DNS records (A record or CNAME)"
echo "3. Add them to your domain registrar (TransIP, Cloudflare, etc.)"
echo "4. Wait for DNS propagation (can take up to 24 hours)"
