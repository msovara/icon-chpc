# ICON Baseline — Step 2: Grid and Initial Conditions

This is the part you need before the short test or a long run (e.g. 1980–2020) can start.

---

## What you need

| File | Purpose | Namelist parameter |
|------|--------|---------------------|
| **Grid** | ICON global mesh (e.g. R2B04 ~13 km, R2B05 ~6.5 km) | `grid_nml%grid_filename` |
| **Initial conditions** | Atmospheric state at start (e.g. 1980-01-01) on the ICON grid | `init_nml%ana_filename` |

---

## 1. Look for existing files on Lengau

On the cluster, run the helper script (from this repo’s `scripts/` or copy its contents):

```bash
cd /path/to/your/icon_run_directory
bash scripts/find_icon_data_on_lengau.sh
```

Optional: set `ICON_BASELINE_DIR` to your run directory if the script uses it:

```bash
export ICON_BASELINE_DIR=/mnt/lustre/users/$USER/icon_baseline
bash scripts/find_icon_data_on_lengau.sh
```

Or search manually:

```bash
# Grid files
find /home/apps/chpc/earth -name "icon_grid*.nc" 2>/dev/null
find /mnt/lustre/users/$USER -name "icon_grid*.nc" 2>/dev/null

# Initial / analysis files
find /home/apps/chpc/earth -name "*init*.nc" -o -name "*ana*.nc" 2>/dev/null
find /mnt/lustre/users/$USER -name "*initial*.nc" -o -name "*1980*.nc" 2>/dev/null
```

---

## 2. Put files into `input/`

Once you have paths to a grid file and an initial-condition file:

```bash
cd /path/to/your/icon_run_directory/input

# Example: copy grid (replace with your path)
cp /path/to/icon_grid_R2B05.nc .

# Or symlink to avoid duplicating
ln -sf /path/to/icon_grid_R2B05.nc icon_grid_R2B05.nc

# Example: copy initial conditions (replace with your path)
cp /path/to/your_init_1980.nc initial_conditions.nc
# or
ln -sf /path/to/your_init_1980.nc initial_conditions.nc

ls -la
```

The namelists expect (by default):

- Grid: `input/icon_grid_R2B05.nc`
- Init: `input/initial_conditions.nc`

If you use different names, edit the namelists in step 3.

---

## 3. Edit the namelists (if needed)

If your filenames differ, edit both namelists in `config/`:

```bash
cd /path/to/your/icon_run_directory
nano config/icon_test_short.nml
nano config/icon_1980_2020.nml
```

Set:

- `&grid_nml` → `grid_filename = "input/your_grid_file.nc"`
- `&init_nml` → `ana_filename = "input/your_init_file.nc"`

Paths can be relative to the run directory (e.g. `input/...`) or absolute.

---

## 4. Run the short test

```bash
cd /path/to/your/icon_run_directory
qsub scripts/run_icon_baseline.pbs
```

This uses `icon_test_short.nml` (12 steps, 1 h walltime). Check:

- `logs/icon_<jobid>.log` — ICON log
- `output/` — should get at least one output file
- `icon_baseline.err` — PBS stderr

If the short test completes and writes output, you can move on to the full run (checkpointing, monthly output, longer walltime). See [ICON_BASELINE_CONFIGURATION_GUIDELINE.md](ICON_BASELINE_CONFIGURATION_GUIDELINE.md).

---

## If you don’t have grid or init data

- **Grid:** Ask CHPC or your group whether an ICON grid (e.g. R2B04/R2B05) is available under `/home/apps/chpc/earth/` or project space. Otherwise, use DKRZ/CESM/ICON distribution and copy to Lengau.
- **Initial conditions:** Usually from DKRZ, your institute, or a run that interpolates ERA5 (or another reanalysis) to the ICON grid. You may need to request or generate this once the grid is fixed.

See [ICON_SETUP_WORKFLOW.md](ICON_SETUP_WORKFLOW.md) (Step 2) and [ICON_BASELINE_START_HERE.md](ICON_BASELINE_START_HERE.md) for more context.
