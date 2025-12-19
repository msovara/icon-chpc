# Email Template: ICON Model Announcement

Use this template to announce ICON availability to users.

---

**Subject**: ICON Model Now Available on Lengau Cluster

---

Dear ICON Users,

We are pleased to announce that the ICON (Icosahedral Nonhydrostatic) Model is now installed and available on the Lengau cluster at CHPC.

## Quick Start

**Load the module:**
```bash
module load chpc/earth/icon/2025.10-1-intel2021.3
```

**Verify installation:**
```bash
icon --help
```

## Documentation and Examples

We've created comprehensive documentation and configuration templates to help you get started:

**GitHub Repository**: https://github.com/msovara/icon-chpc

The repository includes:
- Complete usage documentation
- Configuration templates for different simulation types (atmosphere-only, ocean-only, coupled)
- PBS job scripts optimized for Lengau
- Quick start guide and examples

## Installation Details

- **Version**: 2025.10-1
- **Compiler**: Intel OneAPI 2021.3
- **Location**: `/home/apps/chpc/earth/icon-2025.10-1-intel2021.3`
- **Module**: `chpc/earth/icon/2025.10-1-intel2021.3`
- **Features**: OpenMP and MPI support enabled

## What You Can Do

ICON supports:
- Global and limited-area (LAM) simulations
- Atmosphere-only, ocean-only, and coupled simulations
- High-resolution regional modeling
- Climate and weather forecasting

## Getting Started

1. **Clone the repository** (recommended):
   ```bash
   cd /mnt/lustre/users/$USER
   git clone https://github.com/msovara/icon-chpc.git
   cd icon-chpc
   ```

2. **Read the documentation**:
   - `README.md` - Full documentation
   - `QUICKSTART.md` - Quick start guide
   - `config/README.md` - Configuration guide

3. **Use a configuration template**:
   ```bash
   cp config/example_run.nml my_run.nml
   # Edit my_run.nml with your settings
   ```

4. **Submit a job**:
   ```bash
   qsub scripts/run_icon.pbs
   ```

## Resources

- **GitHub Repository**: https://github.com/msovara/icon-chpc
- **ICON Official Docs**: https://icon-model.org/documentation
- **CHPC Support**: support@chpc.ac.za

## Support

For questions about:
- **ICON usage**: Check the GitHub repository documentation
- **Cluster issues**: Contact CHPC support (support@chpc.ac.za)
- **Installation problems**: Verify module loading and check logs

We hope this will be useful for your research. Please don't hesitate to reach out if you have questions or need assistance.

Best regards,
[Your Name/Team]
CHPC

---

**Short Version (for brief announcements):**

---

**Subject**: ICON Model Available on Lengau

ICON Model (version 2025.10-1) is now available on Lengau.

**Quick start:**
```bash
module load chpc/earth/icon/2025.10-1-intel2021.3
```

**Documentation and examples:**
https://github.com/msovara/icon-chpc

Includes configuration templates, PBS scripts, and usage guides for atmosphere-only, ocean-only, and coupled simulations.

For questions: support@chpc.ac.za

---

