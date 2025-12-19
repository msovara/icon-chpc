# ICON Model Modes: Global vs ICON-LAM

This document explains the difference between ICON global mode and ICON-LAM (Limited-Area Model) mode.

## Overview

The ICON model we built supports **both global and limited-area (LAM) modes**. The same executable (`icon`) can run either mode depending on the configuration.

## ICON Global Mode

**What it is:**
- Full global atmospheric/ocean model
- Covers the entire Earth
- Uses icosahedral grid covering the globe
- Suitable for:
  - Global climate simulations
  - Global weather forecasting
  - Earth system modeling
  - Long-term climate projections

**Configuration:**
- Uses global grid files (e.g., `icon_grid_R2B05.nc`)
- No lateral boundary conditions needed
- Periodic boundary conditions in longitude

## ICON-LAM (Limited-Area Model)

**What it is:**
- Regional/limited-area version of ICON
- Covers a specific region (e.g., Europe, Africa, specific country)
- Uses a subset of the icosahedral grid
- Requires lateral boundary conditions
- Suitable for:
  - High-resolution regional weather forecasting
  - Regional climate downscaling
  - Local weather studies
  - Regional atmospheric research

**Configuration:**
- Uses limited-area grid files
- Requires boundary conditions from a global model
- Higher resolution possible (can go to ~1km or finer)
- Typically nested within a global model

## Which Mode Are We Using?

The installation we built is the **full ICON model** which supports both modes. The mode is determined by:

1. **Grid file**: Global grid = global mode, Limited-area grid = LAM mode
2. **Configuration settings**: Boundary conditions, nesting options
3. **Initial conditions**: Global or regional data

## Current Installation

**Repository**: `https://gitlab.dkrz.de/icon/icon-model.git` (main ICON repository)
**Executable**: `icon` (supports both global and LAM)
**Version**: 2025.10-1

This is the **full ICON model**, not a separate ICON-LAM build. You can use it for:
- ✅ Global simulations
- ✅ Limited-area (LAM) simulations
- ✅ Both, depending on your configuration

## Configuration Examples

### Global Mode Configuration

```fortran
&grid_nml
  grid_filename = "icon_grid_R2B05.nc"  ! Global grid
/

&init_nml
  init_mode = 2  ! Read from global initial conditions
  ! No boundary conditions needed
/
```

### LAM Mode Configuration

```fortran
&grid_nml
  grid_filename = "icon_grid_LAM_Europe_R2B07.nc"  ! Limited-area grid
/

&init_nml
  init_mode = 2  ! Read from regional initial conditions
  ! Boundary conditions required
/

&boundary_nml
  lboundary = .true.  ! Enable boundary conditions
  boundary_file = "boundary_conditions.nc"  ! From global model
/
```

## Switching Between Modes

To switch between global and LAM mode:

1. **Change the grid file** in your configuration
2. **Adjust initialization** settings
3. **Add/remove boundary conditions** as needed
4. **Use the same executable** - no rebuild required

## Resources

- **ICON Documentation**: https://icon-model.org/documentation
- **ICON-LAM Guide**: Check ICON documentation for LAM-specific settings
- **Grid Files**: Available in ICON grid directory or from DKRZ

## Summary

- ✅ We built the **full ICON model** (supports both global and LAM)
- ✅ Same executable works for both modes
- ✅ Mode is determined by configuration, not build
- ✅ You can run global or LAM simulations with this installation

If you need ICON-LAM specifically, you can configure it using limited-area grids and boundary conditions - no separate build is needed!

