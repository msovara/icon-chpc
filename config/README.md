# ICON Configuration Files

This directory contains ICON configuration file templates in Fortran namelist format.

## Available Templates

### example_run.nml

Basic configuration template for testing and learning ICON.

**Use when:**
- Learning ICON
- Testing new configurations
- Short test runs
- Development

**Features:**
- Minimal settings
- Well-commented
- Easy to understand
- Suitable for small runs

### production_run.nml

Production-ready configuration template for scientific simulations.

**Use when:**
- Production runs
- Long simulations
- Scientific research
- High-resolution runs

**Features:**
- Optimized settings
- Higher resolution options
- Production best practices
- Comprehensive physics options

### atmosphere_only.nml

Atmosphere-only simulation configuration (no ocean coupling).

**Use when:**
- Weather forecasting
- Climate simulations with prescribed SST
- Atmospheric research
- Regional climate modeling

**Features:**
- Atmospheric physics and dynamics
- Prescribed sea surface temperature
- No ocean model
- Optimized for atmospheric studies

### ocean_only.nml

Ocean-only simulation configuration (no atmosphere coupling).

**Use when:**
- Ocean circulation studies
- Ocean-only climate simulations
- Ocean dynamics research
- Prescribed atmospheric forcing

**Features:**
- Ocean physics and dynamics
- Prescribed atmospheric forcing
- No atmosphere model
- Optimized for ocean studies

### coupled_atm_oce.nml

Fully coupled atmosphere-ocean simulation configuration.

**Use when:**
- Climate simulations
- Long-term climate projections
- Earth system modeling
- Coupled climate research

**Features:**
- Full atmosphere-ocean coupling
- Sea ice model (optional)
- Two-way interaction
- Climate system modeling

## Configuration File Format

ICON uses Fortran namelist format. Key points:

- Sections start with `&section_name` and end with `/`
- Comments start with `!`
- Boolean values: `.true.` or `.false.`
- Strings are enclosed in quotes
- Arrays use comma separation

Example:
```fortran
&run_nml
  num_lev = 60        ! Number of levels
  nsteps = 100        ! Number of time steps
  dtime = 300.0       ! Time step in seconds
  lrestart = .false.  ! Not a restart run
/
```

## Key Configuration Sections

### &run_nml
General run control: time steps, restart options, output settings

### &grid_nml
Grid configuration: grid file, resolution, domain settings

### &io_nml
Input/Output: file formats, I/O processes, prefetching

### &atm_phy_nml
Atmospheric physics: microphysics, convection, radiation, turbulence

### &atm_dyn_nml
Atmospheric dynamics: time integration, diffusion, coordinate systems

### &init_nml
Initialization: initial conditions, forcing, analysis data

### &output_nml
Output configuration: variables, intervals, file formats

### &restart_nml
Restart files: intervals, file names, checkpoint settings

## Creating Your Own Configuration

1. **Copy a template:**
   ```bash
   cp example_run.nml my_config.nml
   ```

2. **Edit parameters:**
   - Modify values according to your needs
   - Add or remove sections as required
   - Adjust for your grid and resolution

3. **Validate syntax:**
   - Check namelist format
   - Verify file paths
   - Test with a short run

4. **Document changes:**
   - Add comments explaining your choices
   - Note any special requirements
   - Document dependencies

## Common Modifications

### Change Resolution

```fortran
&grid_nml
  grid_filename = "icon_grid_R2B06.nc"  ! Higher resolution
/
```

### Adjust Time Step

```fortran
&run_nml
  dtime = 150.0  ! Smaller time step (more stable)
/
```

### Enable Restart

```fortran
&run_nml
  lrestart = .true.
  restart_filename = "path/to/restart.nc"
/
```

### Change Output Variables

```fortran
&output_nml
  ml_varlist = "temp", "pres", "u", "v", "qv", "qc"
/
```

## Tips

- **Start Simple**: Begin with example_run.nml and modify gradually
- **Test First**: Always test with short runs before production
- **Document**: Add comments explaining your parameter choices
- **Backup**: Keep copies of working configurations
- **Validate**: Check file paths and grid files exist

## Resources

- **[DWD ICON Tutorial 2025 (PDF)](https://www.dwd.de/EN/ourservices/nwp_icon_tutorial/pdf_volume/icon_tutorial2025_en.pdf)** - Official comprehensive tutorial from German Weather Service (DWD)
- ICON User Guide: https://icon-model.org/documentation
- ICON GitLab Repository: https://gitlab.dkrz.de/icon/icon-model
- Fortran Namelist Format: Standard Fortran namelist syntax
- ICON Examples: Check ICON installation for more examples
- DKRZ ICON Documentation: https://www.dkrz.de/up/services/software/icon

## Getting Help

If you encounter issues with configuration:

1. Check namelist syntax
2. Verify file paths are correct
3. Ensure all required sections are present
4. Test with minimal configuration first
5. Consult ICON documentation
6. Check ICON error messages

