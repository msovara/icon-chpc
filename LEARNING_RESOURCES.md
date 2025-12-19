# ICON Learning Resources

This document provides a curated list of resources for learning and using ICON.

## Official Documentation

### Primary Resources

1. **[DWD ICON Tutorial 2025 (PDF)](https://www.dwd.de/EN/ourservices/nwp_icon_tutorial/pdf_volume/icon_tutorial2025_en.pdf)**
   - **Source**: German Weather Service (DWD)
   - **Content**: Comprehensive tutorial covering ICON setup, configuration, and usage
   - **Recommended for**: All users, especially beginners
   - **Topics**: Configuration, namelist parameters, best practices, examples

2. **[ICON Model Website](https://icon-model.org)**
   - Official ICON website
   - General information, news, and updates
   - Links to documentation and resources

3. **[ICON Documentation](https://icon-model.org/documentation)**
   - Official user documentation
   - Technical specifications
   - API references

4. **[ICON GitLab Repository](https://gitlab.dkrz.de/icon/icon-model)**
   - Source code repository
   - Issue tracking
   - Development information

### DKRZ Resources

5. **[DKRZ ICON Documentation](https://www.dkrz.de/up/services/software/icon)**
   - DKRZ-specific ICON documentation
   - Installation guides
   - Usage examples for DKRZ systems

## This Repository

### Documentation Files

- **`README.md`** - Complete usage guide
- **`QUICKSTART.md`** - Quick start guide (5 minutes)
- **`ICON_MODES.md`** - Explanation of global vs LAM modes
- **`ANNOUNCEMENT.md`** - Installation announcement
- **`config/README.md`** - Configuration file guide

### Configuration Templates

- **`config/example_run.nml`** - Basic test configuration
- **`config/production_run.nml`** - Production run template
- **`config/atmosphere_only.nml`** - Atmosphere-only simulations
- **`config/ocean_only.nml`** - Ocean-only simulations
- **`config/coupled_atm_oce.nml`** - Coupled simulations

### Job Scripts

- **`scripts/run_icon.pbs`** - Basic PBS job script
- **`scripts/run_icon_production.pbs`** - Production job script
- **`scripts/run_icon_restart.pbs`** - Restart run script

## Learning Path

### For Beginners

1. **Start Here**: Read `QUICKSTART.md` in this repository
2. **Official Tutorial**: Study the [DWD ICON Tutorial 2025](https://www.dwd.de/EN/ourservices/nwp_icon_tutorial/pdf_volume/icon_tutorial2025_en.pdf)
3. **Configuration**: Review `config/example_run.nml` and `config/README.md`
4. **First Run**: Follow the quick start guide to run your first simulation
5. **Full Documentation**: Read `README.md` for comprehensive information

### For Intermediate Users

1. **Configuration Templates**: Study all templates in `config/` directory
2. **Advanced Topics**: Review `ICON_MODES.md` for global vs LAM modes
3. **Production Runs**: Use `config/production_run.nml` as reference
4. **Optimization**: Review PBS scripts for resource optimization

### For Advanced Users

1. **Official Documentation**: Deep dive into ICON technical documentation
2. **Source Code**: Explore ICON GitLab repository
3. **Custom Configurations**: Create specialized configurations for your research
4. **Performance Tuning**: Optimize for your specific use case

## Key Topics Covered in DWD Tutorial

The [DWD ICON Tutorial 2025](https://www.dwd.de/EN/ourservices/nwp_icon_tutorial/pdf_volume/icon_tutorial2025_en.pdf) covers:

- ICON model overview and architecture
- Installation and setup
- Configuration file structure
- Namelist parameters explained
- Grid files and initial conditions
- Running simulations
- Output files and post-processing
- Troubleshooting common issues
- Best practices and recommendations

## Additional Resources

### Community Resources

- ICON user forums (if available)
- ICON mailing lists
- Scientific publications using ICON

### Related Tools

- **CDO (Climate Data Operators)**: Post-processing ICON output
- **NCO (NetCDF Operators)**: NetCDF file manipulation
- **Python/xarray**: Analysis of ICON output

### Training Materials

- ICON workshops and training sessions
- Online courses (if available)
- Video tutorials (if available)

## Getting Help

### Documentation Issues

- Check this repository's documentation first
- Review the [DWD ICON Tutorial 2025](https://www.dwd.de/EN/ourservices/nwp_icon_tutorial/pdf_volume/icon_tutorial2025_en.pdf)
- Consult official ICON documentation

### Technical Support

- **CHPC Support**: support@chpc.ac.za (for cluster-specific issues)
- **ICON Community**: Check ICON forums and mailing lists
- **GitHub Issues**: https://github.com/msovara/icon-chpc/issues (for this repository)

### Configuration Help

- Review configuration templates in `config/` directory
- Check `config/README.md` for configuration guide
- Refer to namelist examples in DWD tutorial

## Recommended Reading Order

1. **Quick Start** (`QUICKSTART.md`) - Get running quickly
2. **DWD Tutorial** - Understand ICON fundamentals
3. **Full Documentation** (`README.md`) - Comprehensive reference
4. **Configuration Guide** (`config/README.md`) - Deep dive into configuration
5. **Mode Selection** (`ICON_MODES.md`) - Choose the right mode for your work

## Contributing

If you find additional resources or have suggestions for improving documentation:

- Open an issue on GitHub: https://github.com/msovara/icon-chpc/issues
- Submit a pull request with improvements
- Share resources with the community

---

**Last Updated**: December 2025  
**ICON Version**: 2025.10-1

