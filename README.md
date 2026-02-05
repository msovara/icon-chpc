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
8. [Baseline runs (short test and 1980–2020)](#baseline-runs-short-test-and-19802020)
9. [Troubleshooting](#troubleshooting)
10. [Learning Resources](#learning-resources)
11. [References](#references)

## Quick Start

```bash
# Load ICON module
module load chpc/earth/icon/2025.10-1-intel2021.3

# Check ICON installation (on Lengau: run in a PBS job, not on login node — see Troubleshooting)
icon --help

# Run a simple test case
icon -c config/example_run.nml
```

**On Lengau:** If you see a symbol error (`__svml_idiv8_l9`) or segfault when running `icon --help`, see [ICON_SYMBOL_ERROR_FIX.md](ICON_SYMBOL_ERROR_FIX.md). The PBS scripts in `scripts/` already set the required `LD_LIBRARY_PATH`. Use `qsub scripts/run_icon_help_test.pbs` from your run directory to verify ICON on a compute node.

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

- **`icon_test_short.nml`** - Short sanity run (12 steps); use with `scripts/run_icon_baseline.pbs`
- **`icon_1980_2020.nml`** - Long baseline (e.g. 1980–2020); requires grid and initial-condition files in `input/`
- **`output.nml`** - Output stream (interval, variables); referenced by the above
- **`example_run.nml`** - Basic test configuration (if present)
- **`production_run.nml`** - Production run template (if present)
- **`atmosphere_only.nml`** - Atmosphere-only simulations (prescribed SST) (if present)
- **`ocean_only.nml`** - Ocean-only simulations (if present)
- **`coupled_atm_oce.nml`** - Fully coupled atmosphere-ocean simulations (if present)

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

### PBS Job Scripts (Lengau)

This repo provides ready-to-use scripts for Lengau (with project `ERTH0904` and the required `LD_LIBRARY_PATH` fix):

- **`scripts/run_icon_help_test.pbs`** — Quick check that ICON runs on a compute node (no grid/init needed). From your run directory: `qsub scripts/run_icon_help_test.pbs`
- **`scripts/run_icon_baseline.pbs`** — Short test or full baseline. Default: `config/icon_test_short.nml`. For full run: `CONFIG_FILE=config/icon_1980_2020.nml qsub scripts/run_icon_baseline.pbs`
- **`scripts/find_icon_data_on_lengau.sh`** — Search for grid and initial-condition files on the cluster

Copy `config/` and `scripts/` to your run directory on Lustre, set `#PBS -P` to your project, ensure Unix line endings (`dos2unix scripts/*.pbs`), then submit. See [ICON_BASELINE_START_HERE.md](ICON_BASELINE_START_HERE.md) and [ICON_BASELINE_CONFIGURATION_GUIDELINE.md](ICON_BASELINE_CONFIGURATION_GUIDELINE.md).

### Basic PBS structure

```bash
#!/bin/bash
#PBS -N icon_run
#PBS -P YOUR_PROJECT
#PBS -l select=1:ncpus=24:mpiprocs=24:ompthreads=1
#PBS -l walltime=02:00:00
#PBS -q normal
#PBS -o icon_run.out
#PBS -e icon_run.err

cd $PBS_O_WORKDIR
module load chpc/earth/icon/2025.10-1-intel2021.3
# On Lengau, add LD_LIBRARY_PATH — see ICON_SYMBOL_ERROR_FIX.md
export OMP_NUM_THREADS=1
mpirun -np 24 icon -c config/icon_test_short.nml
```

### Submit Job

```bash
cd /path/to/your/icon_run_directory
qsub scripts/run_icon_baseline.pbs
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

## Baseline runs (short test and 1980–2020)

For a **short sanity run** or a **long baseline (e.g. 1980–2020)** on Lengau:

1. **Start here:** [ICON_BASELINE_START_HERE.md](ICON_BASELINE_START_HERE.md) — verify ICON, get grid/init, run short test.
2. **Grid and initial conditions:** [STEP2_GRID_AND_INIT.md](STEP2_GRID_AND_INIT.md) — what you need and where to put files.
3. **Configuration and checklist:** [ICON_BASELINE_CONFIGURATION_GUIDELINE.md](ICON_BASELINE_CONFIGURATION_GUIDELINE.md) — namelist, PBS, and step-by-step.
4. **Symbol/runtime errors on Lengau:** [ICON_SYMBOL_ERROR_FIX.md](ICON_SYMBOL_ERROR_FIX.md) — fix for `__svml_idiv8_l9` and running `icon --help` on a compute node.

---

## Troubleshooting

### Common Issues

#### 0. Symbol or runtime errors on Lengau (`__svml_idiv8_l9`, `libifport`, or segfault with `icon --help`)

ICON on Lengau may need a specific `LD_LIBRARY_PATH` (Intel 2021.3 compiler and Fortran runtime). The PBS scripts in `scripts/` already include this. Do **not** run `icon --help` on the login node (ICON is MPI-linked). Use `qsub scripts/run_icon_help_test.pbs` from your run directory. Full details: [ICON_SYMBOL_ERROR_FIX.md](ICON_SYMBOL_ERROR_FIX.md).

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
- Refer to [DWD ICON Tutorial 2025](https://www.dwd.de/EN/ourservices/nwp_icon_tutorial/pdf_volume/icon_tutorial2025_en.pdf) for namelist examples

#### 5. Memory Issues

- Reduce number of MPI processes
- Use fewer OpenMP threads
- Check available memory: `free -h`
- Request more memory in PBS script

#### 6. Grid File Issues

- Verify grid file exists and is readable
- Check grid file format (NetCDF)
- Ensure grid resolution matches your configuration
- For LAM runs, ensure boundary conditions are provided

#### 7. Initial Condition Issues

- Verify initial condition file format (NetCDF)
- Check variable names match ICON requirements
- Ensure grid compatibility between initial conditions and model grid
- Verify time information is correct

### Getting Help

- **ICON Help**: `icon --help` (on Lengau: run in a PBS job; see [ICON_SYMBOL_ERROR_FIX.md](ICON_SYMBOL_ERROR_FIX.md))
- **Configuration Examples**: See `config/` directory
- **Baseline runs**: [ICON_BASELINE_START_HERE.md](ICON_BASELINE_START_HERE.md), [ICON_BASELINE_CONFIGURATION_GUIDELINE.md](ICON_BASELINE_CONFIGURATION_GUIDELINE.md)
- **Log Files**: Check `icon_run.err` and `icon_run.out` (or `logs/icon_<jobid>.log`) for detailed error messages
- **[DWD ICON Tutorial 2025](https://www.dwd.de/EN/ourservices/nwp_icon_tutorial/pdf_volume/icon_tutorial2025_en.pdf)**: Official tutorial with detailed examples
- **ICON Documentation**: https://icon-model.org/documentation
- **CHPC Support**: https://users.chpc.ac.za/helpdesk/tickets/submit/

## Learning Resources

For comprehensive learning materials, see **[LEARNING_RESOURCES.md](LEARNING_RESOURCES.md)** in this repository.

### Essential Reading

- **[DWD ICON Tutorial 2025 (PDF)](https://www.dwd.de/EN/ourservices/nwp_icon_tutorial/pdf_volume/icon_tutorial2025_en.pdf)** - **Highly Recommended**: Official comprehensive tutorial from German Weather Service (DWD)
  - Covers ICON setup, configuration, namelist parameters, and best practices
  - Includes detailed examples and troubleshooting guides
  - Essential reference for all ICON users

### Additional Resources

- [ICON Model Website](https://icon-model.org)
- [ICON User Guide](https://icon-model.org/documentation)
- [DKRZ ICON Documentation](https://www.dkrz.de/up/services/software/icon)
- [ICON GitLab Repository](https://gitlab.dkrz.de/icon/icon-model)

## References

### Official ICON Documentation

- [ICON Model Website](https://icon-model.org)
- [ICON User Guide](https://icon-model.org/documentation)
- **[DWD ICON Tutorial 2025 (PDF)](https://www.dwd.de/EN/ourservices/nwp_icon_tutorial/pdf_volume/icon_tutorial2025_en.pdf)** - Official tutorial from German Weather Service (DWD)
- [DKRZ ICON Documentation](https://www.dkrz.de/up/services/software/icon)
- [ICON GitLab Repository](https://gitlab.dkrz.de/icon/icon-model)

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
- CHPC Support: https://users.chpc.ac.za/helpdesk/tickets/submit/
- Check ICON installation: `/home/apps/chpc/earth/icon-2025.10-1-intel2021.3`

---

**Last Updated**: December 2025
**ICON Version**: 2025.10-1
**Compiler**: Intel OneAPI 2021.3

