#!/bin/bash
# Quick setup script for ICON usage repository
# This script helps initialize the Git repository and prepare for GitHub

set -e

echo "=========================================="
echo "ICON Usage Repository - Quick Setup"
echo "=========================================="
echo ""

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo "ERROR: git is not installed"
    exit 1
fi

# Initialize git repository if not already initialized
if [ ! -d .git ]; then
    echo "Initializing Git repository..."
    git init
    echo "✓ Git repository initialized"
else
    echo "✓ Git repository already initialized"
fi

# Add all files
echo ""
echo "Adding files to Git..."
git add .
echo "✓ Files added"

# Check if remote is already set
if git remote -v | grep -q "origin"; then
    echo ""
    echo "Git remote 'origin' is already configured:"
    git remote -v
    echo ""
    read -p "Do you want to update it? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git remote set-url origin https://github.com/msovara/icon-usage.git
        echo "✓ Remote updated"
    fi
else
    echo ""
    echo "Setting up GitHub remote..."
    git remote add origin https://github.com/msovara/icon-usage.git
    echo "✓ Remote added: https://github.com/msovara/icon-usage.git"
fi

# Create initial commit if needed
if [ -z "$(git log --oneline 2>/dev/null)" ]; then
    echo ""
    echo "Creating initial commit..."
    git commit -m "Initial commit: ICON usage documentation and templates for Lengau cluster"
    echo "✓ Initial commit created"
else
    echo ""
    echo "Repository already has commits"
    echo "Current status:"
    git status --short
fi

echo ""
echo "=========================================="
echo "Setup Complete!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Create the repository on GitHub:"
echo "   https://github.com/new"
echo "   Repository name: icon-usage"
echo "   Description: ICON Model usage guide and templates for Lengau cluster"
echo ""
echo "2. Push to GitHub:"
echo "   git branch -M main"
echo "   git push -u origin main"
echo ""
echo "3. Add topics on GitHub:"
echo "   icon-model, climate-modeling, hpc, lengau, chpc"
echo ""
echo "Repository URL: https://github.com/msovara/icon-usage"
echo "=========================================="

