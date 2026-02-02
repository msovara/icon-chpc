# Create ICON Usage Repository on GitHub

Quick guide to create and publish the ICON usage repository on your GitHub account.

## Option 1: Using GitHub Web Interface (Recommended)

### Step 1: Create Repository on GitHub

1. Go to: https://github.com/new
2. **Repository name**: `icon-usage`
3. **Description**: `ICON Model usage guide, configuration templates, and job scripts for Lengau cluster (CHPC)`
4. **Visibility**: Choose Public (recommended) or Private
5. **Important**: Do NOT check any boxes (no README, .gitignore, or license - we already have these)
6. Click **"Create repository"**

### Step 2: Initialize and Push from Local

```bash
cd icon-usage

# Initialize git (if not already done)
git init

# Add all files
git add .

# Create initial commit
git commit -m "Initial commit: ICON usage documentation and templates for Lengau cluster"

# Add remote
git remote add origin https://github.com/msovara/icon-usage.git

# Rename branch to main
git branch -M main

# Push to GitHub
git push -u origin main
```

## Option 2: Using GitHub CLI (gh)

If you have GitHub CLI installed:

```bash
cd icon-usage

# Initialize git
git init
git add .
git commit -m "Initial commit: ICON usage documentation and templates for Lengau cluster"

# Create repository on GitHub
gh repo create icon-usage --public --description "ICON Model usage guide, configuration templates, and job scripts for Lengau cluster (CHPC)" --source=. --remote=origin --push
```

## Option 3: Using the Quick Setup Script

```bash
cd icon-usage

# Make script executable (Linux/Mac)
chmod +x QUICK_SETUP.sh

# Run setup script
./QUICK_SETUP.sh

# Then follow the instructions it prints
```

## After Creating the Repository

### Add Repository Topics

On GitHub, go to your repository → Settings → Topics, and add:
- `icon-model`
- `climate-modeling`
- `hpc`
- `lengau`
- `chpc`
- `south-africa`
- `atmospheric-modeling`

### Add Repository Description

Update the description to:
```
ICON Model usage guide, configuration templates, and PBS job scripts optimized for the Lengau HPC cluster at CHPC (Centre for High Performance Computing), South Africa.
```

### Enable Features (Optional)

- **Issues**: Enable for bug reports and feature requests
- **Discussions**: Enable for community questions
- **Wiki**: Optional, for additional documentation

## Verify Repository

After pushing, verify at:
- **Repository URL**: https://github.com/msovara/icon-usage
- **Clone URL**: `git clone https://github.com/msovara/icon-usage.git`

## Repository Structure

Your repository will contain:
```
icon-usage/
├── README.md                    # Main documentation
├── QUICKSTART.md               # Quick start guide
├── config/                      # Configuration templates
│   ├── example_run.nml
│   └── production_run.nml
└── scripts/                     # PBS job scripts
    ├── run_icon.pbs
    └── run_icon_production.pbs
```

## Next Steps

1. ✅ Repository created
2. 📝 Review and customize templates if needed
3. 📢 Share with ICON users on Lengau
4. 🔄 Keep documentation updated
5. 🤝 Accept contributions from users

## Troubleshooting

### Authentication Issues

If `git push` asks for credentials:
- Use a Personal Access Token instead of password
- Or set up SSH keys: https://docs.github.com/en/authentication/connecting-to-github-with-ssh

### Repository Already Exists

If the repository name is taken:
- Choose a different name (e.g., `icon-lengau-usage`)
- Update the remote URL accordingly

### Large Files

If you need to add large files later:
```bash
git lfs install
git lfs track "*.nc"
git add .gitattributes
```

---

**Ready to create!** Follow Option 1 for the simplest approach.














