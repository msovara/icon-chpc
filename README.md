# ICON Model Usage Guide

Complete guide for using the ICON (Icosahedral Nonhydrostatic) Model on the Lengau cluster.

**Repository**: [github.com/msovara/icon-usage](https://github.com/msovara/icon-usage)

## Table of Contents

1. [Quick Start](#quick-start)
2. [Loading ICON](#loading-icon)
3. [Configuration Files](#configuration-files)
4. [Running ICON](#running-icon)
5. [Job Submission](#job-submission)
6. [Input/Output Files](#inputoutput-files)
7. [Examples](#examples)
8. [Troubleshooting](#troubleshooting)
9. [References](#references)

## Quick Start

```bash
# Load ICON module
module load chpc/earth/icon/2025.10-1-intel2021.3

# Check ICON installation
icon --help

# Run a simple test case
icon -c config/example_run.nml
```

## Loading ICON

### Option 1: Using Modules (Recommended)

```bash
module load chpc/earth/icon/2025.10-1-intel2021.3
```

This automatically sets:
- `ICON` - Installation directory
- `ICON_ROOT` - Same as ICON
- `ICON_VERSION` - Version number
- `PATH` - Includes ICON bin directory
- `LD_LIBRARY_PATH` - Includes ICON libraries

### Option 2: Manual Setup

```bash
export ICON=/home/apps/chpc/earth/icon-2025.10-1-intel2021.3
export PATH=${ICON}/bin:${PATH}
export LD_LIBRARY_PATH=${ICON}/lib:${LD_LIBRARY_PATH}
```

## Configuration Files

ICON uses Fortran namelist files (`.nml`) for configuration. Key configuration sections:

### Main Configuration Sections

1. **`&run_nml`** - General run control
2. **`&grid_nml`** - Grid configuration
3. **`&io_nml`** - Input/Output settings
4. **`&atm_phy_nml`** - Atmospheric physics
5. **`&atm_dyn_nml`** - Atmospheric dynamics
6. **`&init_nml`** - Initialization settings

### Available Configuration Templates

See `config/` directory for example configuration files:

- **`example_run.nml`** - Basic test configuration
- **`production_run.nml`** - Production run template
- **`atmosphere_only.nml`** - Atmosphere-only simulations (prescribed SST)
- **`ocean_only.nml`** - Ocean-only simulations (prescribed atmospheric forcing)
- **`coupled_atm_oce.nml`** - Fully coupled atmosphere-ocean simulations

### Choosing the Right Configuration

- **Atmosphere-only**: Use for weather forecasting, atmospheric research, or when SST is prescribed
- **Ocean-only**: Use for ocean circulation studies or when atmospheric forcing is prescribed
- **Coupled**: Use for climate simulations, long-term projections, or Earth system modeling

## Running ICON

### Serial Run

```bash
icon -c config/example_run.nml
```

### Parallel Run (MPI)

```bash
mpirun -np 4 icon -c config/example_run.nml
```

### With OpenMP

```bash
export OMP_NUM_THREADS=4
icon -c config/example_run.nml
```

### Combined MPI + OpenMP

```bash
export OMP_NUM_THREADS=2
mpirun -np 8 icon -c config/example_run.nml
```

## Job Submission

### PBS Job Script Template

See `scripts/run_icon.pbs` for a complete PBS job script template.

Basic structure:

```bash
#!/bin/bash
#PBS -N icon_run
#PBS -l select=1:ncpus=24:mpiprocs=24:ompthreads=1
#PBS -l walltime=02:00:00
#PBS -q normal
#PBS -o icon_run.out
#PBS -e icon_run.err

cd $PBS_O_WORKDIR

# Load modules
module load chpc/earth/icon/2025.10-1-intel2021.3

# Run ICON
mpirun -np 24 icon -c config/example_run.nml
```

### Submit Job

```bash
qsub scripts/run_icon.pbs
```

### Check Job Status

```bash
qstat -u $USER
```

## Input/Output Files

### Input Files

- **Configuration file** (`.nml`) - Main namelist configuration
- **Initial conditions** - NetCDF files with initial atmospheric state
- **Boundary conditions** - For nested runs
- **Grid files** - ICON grid definition files

### Output Files

- **Restart files** - For continuing simulations
- **Output files** - NetCDF files with model results
- **Log files** - Model output and diagnostics

### Common File Locations

```bash
# Input directory (example)
INPUT_DIR=/mnt/lustre/users/$USER/icon/input

# Output directory (example)
OUTPUT_DIR=/mnt/lustre/users/$USER/icon/output

# Restart directory (example)
RESTART_DIR=/mnt/lustre/users/$USER/icon/restart
```

## Examples

### Example 1: Simple Test Run

```bash
# Load module
module load chpc/earth/icon/2025.10-1-intel2021.3

# Create working directory
mkdir -p ~/icon_test
cd ~/icon_test

# Copy example configuration
cp $ICON/examples/config/example_run.nml .

# Run ICON
icon -c example_run.nml
```

### Example 2: Production Run with MPI

```bash
# Load module
module load chpc/earth/icon/2025.10-1-intel2021.3

# Set up directories
WORK_DIR=/mnt/lustre/users/$USER/icon/production
mkdir -p $WORK_DIR/{input,output,restart}
cd $WORK_DIR

# Prepare configuration file
# Edit config/production_run.nml with your settings

# Submit job
qsub scripts/run_icon_production.pbs
```

### Example 3: Restart Run

```bash
# Load module
module load chpc/earth/icon/2025.10-1-intel2021.3

# Edit configuration to use restart file
# In your .nml file, set:
# &run_nml
#   lrestart = .true.
#   restart_filename = "path/to/restart_file.nc"
# /

# Run ICON
icon -c config/restart_run.nml
```

## Troubleshooting

### Common Issues

#### 1. Module Not Found

```bash
# Check available modules
module avail icon

# If module doesn't exist, use manual setup
export ICON=/home/apps/chpc/earth/icon-2025.10-1-intel2021.3
export PATH=${ICON}/bin:${PATH}
```

#### 2. Library Errors

```bash
# Check LD_LIBRARY_PATH
echo $LD_LIBRARY_PATH

# Add ICON libraries if missing
export LD_LIBRARY_PATH=${ICON}/lib:${LD_LIBRARY_PATH}
```

#### 3. MPI Issues

```bash
# Check MPI setup
which mpirun
mpirun --version

# Load Intel MPI if needed
module load intel/2021.3
```

#### 4. Configuration File Errors

- Check namelist syntax (Fortran namelist format)
- Verify file paths are correct
- Ensure all required sections are present
- Check file permissions

#### 5. Memory Issues

- Reduce number of MPI processes
- Use fewer OpenMP threads
- Check available memory: `free -h`
- Request more memory in PBS script

### Getting Help

- Check ICON documentation: `icon --help`
- Review configuration examples in `config/` directory
- Check log files for error messages
- Consult ICON user manual

## References

### ICON Documentation

- [ICON Model Website](https://icon-model.org)
- [ICON User Guide](https://icon-model.org/documentation)
- [DKRZ ICON Documentation](https://www.dkrz.de/up/services/software/icon)

### Lengau Cluster

- [CHPC Documentation](https://wiki.chpc.ac.za/_media/chpc:chpc_accounts_policy_v2.7.pdf)
- [Lengau User Guide](https://wiki.chpc.ac.za/)

### Related Tools

- NetCDF tools for data analysis
- CDO (Climate Data Operators) for post-processing
- NCO (NetCDF Operators) for data manipulation

## License

ICON is licensed under BSD-3-Clause. See the ICON license file for details.

## Contact

For issues with ICON installation on Lengau:
- CHPC Support: support@chpc.ac.za
- Check ICON installation: `/home/apps/chpc/earth/icon-2025.10-1-intel2021.3`

---

**Last Updated**: December 2025
**ICON Version**: 2025.10-1
**Compiler**: Intel OneAPI 2021.3

