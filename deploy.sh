#!/usr/bin/env bash
set -euo pipefail

# deploy.sh - simple deploy script for MoonTV
# Usage: ./deploy.sh [branch]

BRANCH=${1:-$(git rev-parse --abbrev-ref HEAD)}

cd "$(dirname "$0")"

echo "Deploying moontv (branch: $BRANCH)"

git fetch origin "$BRANCH"
git reset --hard "origin/$BRANCH"

echo "Installing dependencies..."
pnpm install --frozen-lockfile

echo "Building..."
pnpm build

echo "Reloading/starting with PM2..."
pm2 reload ecosystem.config.js --env production || pm2 start ecosystem.config.js --env production
pm2 save

echo "Deployment finished."
