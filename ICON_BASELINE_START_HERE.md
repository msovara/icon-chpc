# ICON Baseline — Start Here

Quick entry point for running an ICON baseline (short test or long run) on Lengau.

---

## 1. Verify ICON runs (no data needed)

ICON is MPI-linked; **do not** run `icon --help` on the login node (you may get a segfault). Use a short PBS job:

1. Copy this repo’s `config/` and `scripts/` to a run directory on Lengau (e.g. `/mnt/lustre/users/$USER/icon_baseline/`).
2. From that directory:  
   `qsub scripts/run_icon_help_test.pbs`
3. Check `icon_help_test.out` and `icon_help_test.err`. If you see **symbol lookup error** or **libifport**, see **[ICON_SYMBOL_ERROR_FIX.md](ICON_SYMBOL_ERROR_FIX.md)** — the PBS scripts in this repo already include the required `LD_LIBRARY_PATH` for Lengau.

---

## 2. Get grid and initial conditions

You need:

- An ICON **grid file** (e.g. `icon_grid_R2B05.nc`).
- **Initial conditions** (e.g. for 1980-01-01) on that grid.

**Find existing files on the cluster:**

```bash
export ICON_BASELINE_DIR=/mnt/lustre/users/$USER/icon_baseline   # your run dir
bash scripts/find_icon_data_on_lengau.sh
```

Then copy or symlink the files into `input/` and set `grid_filename` and `ana_filename` in your namelists. Full steps: **[STEP2_GRID_AND_INIT.md](STEP2_GRID_AND_INIT.md)**.

---

## 3. Run the short test

From your run directory:

```bash
qsub scripts/run_icon_baseline.pbs
```

This uses `config/icon_test_short.nml` (12 steps). Check `logs/icon_<jobid>.log` and `output/`.

---

## 4. Full run (e.g. 1980–2020)

- Set **PBS project**: edit `#PBS -P ERTH0904` in `scripts/run_icon_baseline.pbs` to your project code.
- Ensure **Unix line endings** on the cluster: `dos2unix scripts/*.pbs`.
- Configure grid/init and run control: **[ICON_BASELINE_CONFIGURATION_GUIDELINE.md](ICON_BASELINE_CONFIGURATION_GUIDELINE.md)**.
- Submit full run:  
  `CONFIG_FILE=config/icon_1980_2020.nml qsub scripts/run_icon_baseline.pbs`  
  and increase walltime in the PBS script as needed.

---

## Doc index

| Document | Purpose |
|----------|--------|
| [ICON_SYMBOL_ERROR_FIX.md](ICON_SYMBOL_ERROR_FIX.md) | Fix `__svml_idiv8_l9` / `libifport` and run `icon --help` on a compute node |
| [STEP2_GRID_AND_INIT.md](STEP2_GRID_AND_INIT.md) | Find and set up grid + initial-condition files |
| [ICON_BASELINE_CONFIGURATION_GUIDELINE.md](ICON_BASELINE_CONFIGURATION_GUIDELINE.md) | Namelist, PBS, and checklist for short test and long run |
| [ICON_SETUP_WORKFLOW.md](ICON_SETUP_WORKFLOW.md) | General ICON setup workflow |
