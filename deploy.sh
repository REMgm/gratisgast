#!/bin/bash

# Gratis Gast Deployment Script
# Uses environment variables: GITHUB_TOKEN, VERCEL_TOKEN, RAILWAY_TOKEN

set -e

echo "🚀 Gratis Gast Deployment"
echo "=========================="

# Check if tokens are set
if [ -z "$GITHUB_TOKEN" ]; then
    echo "❌ GITHUB_TOKEN not set"
    exit 1
fi

if [ -z "$VERCEL_TOKEN" ]; then
    echo "❌ VERCEL_TOKEN not set"
    exit 1
fi

if [ -z "$RAILWAY_TOKEN" ]; then
    echo "❌ RAILWAY_TOKEN not set"
    exit 1
fi

echo "✅ All tokens found"
echo ""

# Configuration
GITHUB_USER="REMgm"
REPO_NAME="gratisgast"
FRONTEND_DIR="frontend"
BACKEND_DIR="backend"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Step 1: Create GitHub Repo
echo -e "${YELLOW}Step 1: Creating GitHub repository...${NC}"

# Check if repo exists
REPO_EXISTS=$(curl -s -o /dev/null -w "%{http_code}" \
    -H "Authorization: token $GITHUB_TOKEN" \
    "https://api.github.com/repos/$GITHUB_USER/$REPO_NAME")

if [ "$REPO_EXISTS" = "200" ]; then
    echo "✅ Repository already exists"
else
    # Create repo
    curl -s -X POST \
        -H "Authorization: token $GITHUB_TOKEN" \
        -H "Accept: application/vnd.github.v3+json" \
        -d "{\"name\":\"$REPO_NAME\",\"private\":false,\"description\":\"Gratis Gast - AMEX Platinum referral site\"}" \
        "https://api.github.com/user/repos" > /dev/null
    echo -e "${GREEN}✅ Repository created${NC}"
fi

# Step 2: Push to GitHub
echo -e "${YELLOW}Step 2: Pushing code to GitHub...${NC}"

cd /root/.openclaw/workspace/projects/gratisgast

# Initialize git if needed
if [ ! -d ".git" ]; then
    git init
fi

# Configure git
git config user.email "gast@gratisgast.nl"
git config user.name "Gratis Gast"

# Add remote
REMOTE_URL="https://$GITHUB_TOKEN@github.com/$GITHUB_USER/$REPO_NAME.git"
git remote remove origin 2>/dev/null || true
git remote add origin "$REMOTE_URL"

# Commit and push
git add .
git commit -m "Deploy: Gratis Gast v1.0" || echo "No changes to commit"
git push -u origin main --force

echo -e "${GREEN}✅ Code pushed to GitHub${NC}"
echo ""

# Step 3: Deploy Frontend to Vercel
echo -e "${YELLOW}Step 3: Deploying frontend to Vercel...${NC}"

# Check if Vercel CLI is installed
if ! command -v vercel &> /dev/null; then
    echo "Installing Vercel CLI..."
    npm install -g vercel
fi

# Deploy frontend
cd "$FRONTEND_DIR"

# Link and deploy
vercel --token "$VERCEL_TOKEN" --yes --prod

FRONTEND_URL=$(vercel --token "$VERCEL_TOKEN" ls 2>/dev/null | grep -o 'https://[^ ]*' | head -1)

echo -e "${GREEN}✅ Frontend deployed${NC}"
echo "   URL: $FRONTEND_URL"
echo ""

# Step 4: Deploy Backend to Railway
echo -e "${YELLOW}Step 4: Deploying backend to Railway...${NC}"

# Check if Railway CLI is installed
if ! command -v railway &> /dev/null; then
    echo "Installing Railway CLI..."
    npm install -g @railway/cli
fi

# Login to Railway
railway login --token "$RAILWAY_TOKEN"

cd ../"$BACKEND_DIR"

# Check if project exists
PROJECT_ID=$(railway list 2>/dev/null | grep -i "gratisgast" | awk '{print $1}')

if [ -z "$PROJECT_ID" ]; then
    echo "Creating new Railway project..."
    railway init --name "gratisgast-api"
fi

# Add PostgreSQL if not exists
railway add --database postgres 2>/dev/null || echo "Database may already exist"

# Deploy
railway up

# Get backend URL
BACKEND_URL=$(railway domain 2>/dev/null || echo "https://gratisgast-api.up.railway.app")

echo -e "${GREEN}✅ Backend deployed${NC}"
echo "   URL: $BACKEND_URL"
echo ""

# Step 5: Update frontend with backend URL
echo -e "${YELLOW}Step 5: Updating frontend with backend URL...${NC}"

cd ../"$FRONTEND_DIR"

# Update API_URL in index.html
sed -i "s|const API_URL = .*|const API_URL = '$BACKEND_URL/api';|" index.html

# Commit and redeploy
git add index.html
git commit -m "Update: Backend API URL"
git push

vercel --token "$VERCEL_TOKEN" --yes --prod

echo -e "${GREEN}✅ Frontend updated and redeployed${NC}"
echo ""

# Summary
echo "=========================="
echo -e "${GREEN}🎉 Deployment Complete!${NC}"
echo "=========================="
echo ""
echo "Frontend: $FRONTEND_URL"
echo "Backend:  $BACKEND_URL"
echo "GitHub:   https://github.com/$GITHUB_USER/$REPO_NAME"
echo ""
echo "Next steps:"
echo "1. Add custom domain in Vercel (gratisgast.nl)"
echo "2. Add custom domain in Railway (api.gratisgast.nl)"
echo "3. Set up Gmail App Password for emails"
echo "4. Test email capture form"
echo ""
echo -e "${YELLOW}Gratis Gast is live! 🚀${NC}"
