# Directory Structure

This document explains the organization of the ICON usage repository.

```
icon-usage/
├── README.md                 # Main documentation
├── QUICKSTART.md            # Quick start guide
├── CONTRIBUTING.md          # Contribution guidelines
├── LICENSE                  # License information
├── .gitignore              # Git ignore file
│
├── config/                  # Configuration templates
│   ├── example_run.nml     # Simple example configuration
│   └── production_run.nml  # Production run configuration
│
└── scripts/                 # PBS job scripts
    ├── run_icon.pbs        # Basic ICON run script
    ├── run_icon_production.pbs  # Production run script
    └── run_icon_restart.pbs     # Restart run script
```

## Directory Descriptions

### Root Directory

- **README.md**: Comprehensive documentation covering all aspects of using ICON
- **QUICKSTART.md**: Fast-track guide to get started quickly
- **CONTRIBUTING.md**: Guidelines for contributing to this repository
- **LICENSE**: MIT License for this repository (ICON itself has BSD-3-Clause)
- **.gitignore**: Files and directories to exclude from version control

### config/

Contains ICON configuration file templates in Fortran namelist format (`.nml`).

- **example_run.nml**: Basic configuration for testing and learning
  - Minimal settings
  - Well-commented
  - Suitable for short test runs

- **production_run.nml**: Production-ready configuration
  - Optimized settings
  - Higher resolution options
  - Production best practices

### scripts/

Contains PBS (Portable Batch System) job submission scripts for the Lengau cluster.

- **run_icon.pbs**: Basic job script
  - Single node
  - Short walltime
  - Good for testing

- **run_icon_production.pbs**: Production job script
  - Multiple nodes
  - Long walltime
  - Optimized for production runs

- **run_icon_restart.pbs**: Restart job script
  - Continues from restart file
  - Useful for long simulations

## Usage Workflow

1. **Start Here**: Read `QUICKSTART.md` for immediate setup
2. **Configuration**: Copy and modify templates from `config/`
3. **Job Submission**: Use scripts from `scripts/` as templates
4. **Reference**: Consult `README.md` for detailed information

## Customizing for Your Work

### Create Your Own Config

```bash
# Copy template
cp config/example_run.nml my_config.nml

# Edit with your settings
nano my_config.nml
```

### Create Your Own Script

```bash
# Copy template
cp scripts/run_icon.pbs my_job.pbs

# Edit PBS directives and paths
nano my_job.pbs

# Submit
qsub my_job.pbs
```

## File Naming Conventions

- Configuration files: `*_run.nml`, `*_config.nml`
- Job scripts: `run_*.pbs`, `submit_*.pbs`
- Output files: `icon_*.nc`, `output_*.nc`
- Restart files: `restart_*.nc`

## Best Practices

1. **Organize by Project**: Create separate directories for different projects
2. **Version Control**: Keep track of configuration changes
3. **Documentation**: Comment your configuration files
4. **Backup**: Keep copies of working configurations
5. **Testing**: Test with small runs before production

## Example Project Structure

```
my_icon_project/
├── config/
│   ├── test_run.nml
│   └── production_run.nml
├── scripts/
│   ├── run_test.pbs
│   └── run_production.pbs
├── input/
│   └── initial_conditions.nc
├── output/
│   └── (ICON output files)
└── restart/
    └── (restart files)
```

This structure keeps your work organized and makes it easy to manage multiple ICON runs.

