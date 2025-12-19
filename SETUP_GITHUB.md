# Setting Up the GitHub Repository

This guide explains how to create and publish the ICON usage repository on GitHub.

## Step 1: Initialize Git Repository

```bash
cd icon-usage
git init
git add .
git commit -m "Initial commit: ICON usage documentation and templates"
```

## Step 2: Create GitHub Repository

1. Go to https://github.com/new
2. Repository name: `icon-usage` (or your preferred name)
3. Description: "ICON Model usage guide, configuration templates, and job scripts for Lengau cluster"
4. Choose visibility: Public (recommended) or Private
5. **Do NOT** initialize with README, .gitignore, or license (we already have these)
6. Click "Create repository"

## Step 3: Connect Local Repository to GitHub

```bash
# Add remote using your GitHub username
git remote add origin https://github.com/msovara/icon-usage.git

# Or using SSH:
git remote add origin git@github.com:msovara/icon-usage.git

# Verify remote
git remote -v
```

## Step 4: Push to GitHub

```bash
# Push to main branch
git branch -M main
git push -u origin main
```

## Step 5: Configure Repository Settings

On GitHub, go to repository Settings:

1. **General**:
   - Add topics: `icon-model`, `climate-modeling`, `hpc`, `lengau`, `chpc`
   - Add description
   - Enable Issues and Discussions (if desired)

2. **Pages** (optional):
   - Enable GitHub Pages to host documentation
   - Source: main branch, /docs folder

3. **Collaborators** (if needed):
   - Add collaborators who can contribute

## Step 6: Create Releases (Optional)

For versioned releases:

```bash
# Tag a release
git tag -a v1.0.0 -m "Initial release: ICON usage documentation"
git push origin v1.0.0
```

Then create a release on GitHub with release notes.

## Repository Structure Summary

```
icon-usage/
├── README.md                    # Main documentation
├── QUICKSTART.md               # Quick start guide
├── DIRECTORY_STRUCTURE.md      # Directory organization
├── CONTRIBUTING.md             # Contribution guidelines
├── LICENSE                     # MIT License
├── SETUP_GITHUB.md            # This file
├── .gitignore                  # Git ignore rules
│
├── config/                     # Configuration templates
│   ├── README.md              # Config documentation
│   ├── example_run.nml        # Example configuration
│   └── production_run.nml     # Production configuration
│
└── scripts/                    # PBS job scripts
    ├── run_icon.pbs           # Basic run script
    ├── run_icon_production.pbs # Production script
    └── run_icon_restart.pbs   # Restart script
```

## Making Updates

After making changes:

```bash
# Stage changes
git add .

# Commit with descriptive message
git commit -m "Description of changes"

# Push to GitHub
git push origin main
```

## Adding a Badge (Optional)

Add to README.md:

```markdown
![GitHub](https://img.shields.io/github/license/msovara/icon-usage)
![GitHub last commit](https://img.shields.io/github/last-commit/msovara/icon-usage)
```

## Enabling GitHub Actions (Optional)

Create `.github/workflows/` for:
- Documentation validation
- Configuration file syntax checking
- Automated testing

## Sharing the Repository

Once published, share the repository:

- **GitHub URL**: `https://github.com/msovara/icon-usage`
- **Clone command**: `git clone https://github.com/msovara/icon-usage.git`
- **Documentation**: Available in README.md

## Next Steps

1. ✅ Repository created and published
2. 📝 Add more examples as needed
3. 🤝 Invite collaborators
4. 📢 Announce to ICON user community
5. 🔄 Keep documentation updated

## Troubleshooting

### Authentication Issues

```bash
# Use personal access token instead of password
# Or set up SSH keys for GitHub
```

### Push Rejected

```bash
# If remote has content, pull first:
git pull origin main --allow-unrelated-histories
git push origin main
```

### Large Files

```bash
# Use Git LFS for large files if needed
git lfs install
git lfs track "*.nc"
```

---

**Repository is ready!** Users can now clone and use your ICON usage templates.

