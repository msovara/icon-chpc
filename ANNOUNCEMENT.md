# ICON Model Now Available on Lengau Cluster

**Date**: December 2025  
**ICON Version**: 2025.10-1  
**Compiler**: Intel OneAPI 2021.3

## Announcement

The ICON (Icosahedral Nonhydrostatic) Model is now installed and available on the Lengau cluster at CHPC. ICON is a state-of-the-art weather and climate model developed by DWD (German Weather Service) and MPI-M (Max Planck Institute for Meteorology).

## Quick Start

### 1. Load the ICON Module

```bash
module load chpc/earth/icon/2025.10-1-intel2021.3
```

### 2. Verify Installation

```bash
icon --help
```

### 3. Get Started

We've created comprehensive documentation and configuration templates to help you get started quickly:

**GitHub Repository**: https://github.com/msovara/icon-chpc

The repository includes:
- ✅ Complete usage documentation
- ✅ Configuration templates for different simulation types
- ✅ PBS job scripts for Lengau cluster
- ✅ Quick start guide
- ✅ Examples for atmosphere-only, ocean-only, and coupled simulations

## What You Can Do with ICON

ICON supports multiple simulation modes:

1. **Global Simulations** - Full Earth coverage for climate and weather studies
2. **Limited-Area (LAM) Simulations** - High-resolution regional modeling
3. **Atmosphere-Only** - With prescribed sea surface temperature
4. **Ocean-Only** - With prescribed atmospheric forcing
5. **Coupled Atmosphere-Ocean** - Full Earth system modeling

## Installation Details

- **Location**: `/home/apps/chpc/earth/icon-2025.10-1-intel2021.3`
- **Module**: `chpc/earth/icon/2025.10-1-intel2021.3`
- **Compiled with**: Intel OneAPI 2021.3
- **Features**: OpenMP and MPI support enabled

## Getting Started Guide

### Option 1: Use the GitHub Repository (Recommended)

1. **Clone the repository**:
   ```bash
   cd /mnt/lustre/users/$USER
   git clone https://github.com/msovara/icon-chpc.git
   cd icon-chpc
   ```

2. **Read the documentation**:
   ```bash
   cat README.md          # Full documentation
   cat QUICKSTART.md      # Quick start guide
   ```

3. **Copy a configuration template**:
   ```bash
   cp config/example_run.nml my_run.nml
   # Edit my_run.nml with your settings
   ```

4. **Submit a job**:
   ```bash
   # Edit scripts/run_icon.pbs with your configuration
   qsub scripts/run_icon.pbs
   ```

### Option 2: Manual Setup

1. **Load the module**:
   ```bash
   module load chpc/earth/icon/2025.10-1-intel2021.3
   ```

2. **Create your working directory**:
   ```bash
   mkdir -p ~/icon_work/{input,output,restart}
   cd ~/icon_work
   ```

3. **Create a configuration file** (see examples below)

4. **Run ICON**:
   ```bash
   # Serial test run
   icon -c my_config.nml
   
   # Or with MPI
   mpirun -np 24 icon -c my_config.nml
   ```

## Configuration Templates Available

The GitHub repository includes ready-to-use configuration templates:

- **`example_run.nml`** - Basic test configuration
- **`production_run.nml`** - Production run template
- **`atmosphere_only.nml`** - Atmosphere-only simulations
- **`ocean_only.nml`** - Ocean-only simulations
- **`coupled_atm_oce.nml`** - Coupled atmosphere-ocean simulations

## Example: Running Your First Simulation

```bash
# 1. Load module
module load chpc/earth/icon/2025.10-1-intel2021.3

# 2. Create working directory
mkdir -p ~/icon_test
cd ~/icon_test

# 3. Clone repository (or copy config files)
git clone https://github.com/msovara/icon-chpc.git
cd icon-chpc

# 4. Copy and edit configuration
cp config/example_run.nml my_test.nml
# Edit my_test.nml: set grid file, initial conditions, etc.

# 5. Submit job
qsub scripts/run_icon.pbs
```

## Resources and Documentation

### On GitHub
- **Repository**: https://github.com/msovara/icon-chpc
- **Documentation**: See README.md in the repository
- **Quick Start**: See QUICKSTART.md
- **Configuration Guide**: See config/README.md

### ICON Official Documentation
- **ICON Website**: https://icon-model.org
- **ICON Documentation**: https://icon-model.org/documentation
- **DKRZ ICON Resources**: https://www.dkrz.de/up/services/software/icon

## Support and Questions

### For ICON Usage Questions
- Check the GitHub repository documentation: https://github.com/msovara/icon-chpc
- Review ICON official documentation: https://icon-model.org/documentation
- Consult ICON user community forums

### For Cluster/Technical Issues
- **CHPC Support**: support@chpc.ac.za
- **Lengau Documentation**: https://www.chpc.ac.za/documentation

### For Installation Issues
- Check installation logs
- Verify module is loaded: `module show chpc/earth/icon/2025.10-1-intel2021.3`
- Ensure you have access to required directories

## Important Notes

1. **Grid Files**: You'll need ICON grid files for your simulations. These are typically available from:
   - ICON grid repository
   - DKRZ data portal
   - Your project's data directory

2. **Initial Conditions**: ICON requires initial conditions in NetCDF format. Ensure you have:
   - Properly formatted initial condition files
   - Correct variable names and units
   - Compatible grid resolution

3. **Computational Resources**: 
   - ICON can be computationally intensive
   - Request appropriate resources in PBS scripts
   - Consider using multiple nodes for large simulations

4. **Storage**: 
   - Output files can be large
   - Use `/mnt/lustre/users/$USER` for data storage
   - Clean up old output files regularly

## Next Steps

1. ✅ Load the ICON module
2. ✅ Clone or browse the GitHub repository
3. ✅ Review the documentation
4. ✅ Choose a configuration template
5. ✅ Prepare your grid files and initial conditions
6. ✅ Run a test simulation
7. ✅ Scale up to production runs

## Feedback

If you have suggestions for improving the documentation or encounter issues, please:
- Open an issue on GitHub: https://github.com/msovara/icon-chpc/issues
- Contact CHPC support: support@chpc.ac.za

---

**Happy Modeling!** 🎉

We hope ICON will be useful for your research. The documentation and examples in the GitHub repository should help you get started quickly.

