# ICON Quick Start Guide

Get up and running with ICON in 5 minutes!

## Prerequisites

- Access to Lengau cluster
- ICON module installed (contact CHPC if not available)

## Step 1: Load ICON Module

```bash
module load chpc/earth/icon/2025.10-1-intel2021.3
```

## Step 2: Verify Installation

```bash
icon --help
```

You should see ICON help output.

## Step 3: Create Working Directory

```bash
mkdir -p ~/icon_test
cd ~/icon_test
```

## Step 4: Copy Configuration Template

```bash
# If you cloned this repository:
cp config/example_run.nml .

# Or create a minimal config:
cat > test_run.nml << 'EOF'
&run_nml
  num_lev = 60
  nsteps = 10
  dtime = 300.0
  lrestart = .false.
/
EOF
```

## Step 5: Run ICON (Test)

```bash
# Serial run (small test)
icon -c test_run.nml
```

## Step 6: Submit Production Job

```bash
# Copy and edit PBS script
cp scripts/run_icon.pbs my_run.pbs
# Edit my_run.pbs to set your configuration file

# Submit job
qsub my_run.pbs

# Check status
qstat -u $USER
```

## Common Commands

```bash
# Check ICON version
icon --version

# View configuration help
icon --help

# List available grids
ls $ICON/grids/

# Check module info
module show chpc/earth/icon/2025.10-1-intel2021.3
```

## Next Steps

- Read the full [README.md](README.md) for detailed documentation
- Check [config/](config/) for configuration examples
- See [scripts/](scripts/) for job submission templates

## Getting Help

- Check ICON logs: `icon_run.err` and `icon_run.out`
- Review configuration file syntax
- **[DWD ICON Tutorial 2025](https://www.dwd.de/EN/ourservices/nwp_icon_tutorial/pdf_volume/icon_tutorial2025_en.pdf)**: Official tutorial with detailed examples
- Consult ICON documentation: https://icon-model.org
- Contact CHPC support: support@chpc.ac.za

## Additional Resources

- **Official Tutorial**: [DWD ICON Tutorial 2025 (PDF)](https://www.dwd.de/EN/ourservices/nwp_icon_tutorial/pdf_volume/icon_tutorial2025_en.pdf) - Comprehensive guide from German Weather Service
- **Full Documentation**: See `README.md` in this repository
- **Configuration Guide**: See `config/README.md`

---

**That's it!** You're ready to run ICON. For more details, see the full documentation.

