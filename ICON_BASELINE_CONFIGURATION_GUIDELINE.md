# ICON Baseline — Configuration Guideline

Practical reference for configuring and running an ICON baseline (e.g. 1980–2020) on Lengau. Use this when setting up a short test or a long production run.

---

## 1. Directory layout (Lustre)

Use a run directory with this structure (e.g. clone this repo and copy `config/` and `scripts/` into it on the cluster):

```
/path/to/your/icon_baseline/
├── input/                    ← Grid + initial-condition files (you provide)
├── output/                   ← ICON writes output here
├── restart/                  ← Restart files (for long runs)
├── logs/                     ← Job/ICON logs
├── config/
│   ├── icon_test_short.nml   ← Short test config (12 steps)
│   ├── icon_1980_2020.nml    ← Full run config (edit nsteps for 40 years)
│   └── output.nml            ← Output stream (interval, variables)
├── scripts/
│   ├── run_icon_baseline.pbs
│   ├── run_icon_help_test.pbs
│   └── find_icon_data_on_lengau.sh
└── README or this guideline
```

---

## 2. What you must configure

### 2.1 Data paths (required before any real run)

| Namelist    | Parameter       | Meaning                    | Example / note                          |
|------------|------------------|----------------------------|----------------------------------------|
| `&grid_nml`| `grid_filename` | Path to ICON grid file     | `"input/icon_grid_R2B05.nc"` or full path |
| `&init_nml`| `ana_filename`  | Path to initial conditions | `"input/initial_conditions.nc"` or full path |

- Edit in **both** `icon_test_short.nml` and `icon_1980_2020.nml` if you use different filenames.
- Put the actual files in `input/` (copy or symlink). See [STEP2_GRID_AND_INIT.md](STEP2_GRID_AND_INIT.md) and `scripts/find_icon_data_on_lengau.sh`.

### 2.2 Run control (`&run_nml`)

| Parameter        | Short test      | Full 1980–2020        | Notes |
|------------------|-----------------|------------------------|--------|
| `nsteps`         | 12 (or small)   | Large (e.g. ~42e6 for 40y at 300 s) | Or use stop date if your build supports it. |
| `dtime`          | 300.0           | 300.0                  | Time step (s). Match validated config. |
| `lrestart`       | .false.         | .false. to start       | Set .true. when resuming from restart. |
| `restart_filename` | ""            | "" or path to restart  | Set when `lrestart` = .true. |
| `output`         | "icon_test"     | "icon_1980_2020"       | Prefix for output files. |

### 2.3 Output (`&output_nml` and output.nml)

| Parameter         | Short test | Full run (for BCs) | Notes |
|-------------------|------------|--------------------------|--------|
| `output_interval` | 1.0 (hours) | 720.0 (monthly)        | Monthly = one file per month for downstream use. |
| `output_bounds` / `output_end` | Short range | Cover 1980–2020 | In hours or as in your ICON version. |
| `ml_varlist`      | As in template | Add vars needed       | Typically T, U, V, Q, Ps, etc. See DWD/MPI-M docs. |

### 2.4 Restart and checkpoint (for long run)

| Namelist           | Parameter             | Suggested      | Notes |
|--------------------|-----------------------|----------------|--------|
| `&restart_nml`     | `write_restart`       | .true.         | Needed to resume after walltime or failure. |
| `&restart_nml`     | `restart_interval`    | 24.0 (hours)   | Or monthly; align with PBS walltime. |
| `&restart_nml`     | `restart_filename`    | "restart/restart_icon.nc" | Path under run directory. |
| `&checkpoint_nml`  | `checkpoint_interval` | 6.0 (hours)    | Safety; tune if needed. |

---

## 3. PBS / job configuration

### 3.1 Queue and project

| PBS directive | Value      | When to change |
|---------------|------------|----------------|
| `#PBS -P`     | ERTH0904   | Use your CHPC project code. |
| `#PBS -q`     | normal     | Baseline run (multi-node). Use `serial` for tiny help test only. |

### 3.2 Resources (run_icon_baseline.pbs)

| Directive        | Typical value              | Notes |
|-------------------|----------------------------|--------|
| `#PBS -l select` | 4:ncpus=24:mpiprocs=24:ompthreads=1 | 4 nodes × 24 MPI procs. Adjust for grid size and walltime. |
| `#PBS -l walltime` | 01:00:00 (short test)     | Use 48:00:00 or more for production 1980–2020 chunks. |

### 3.3 Which config file is used

- Default: `CONFIG_FILE=icon_test_short.nml` (set in the script).
- Full run: submit with  
  `CONFIG_FILE=icon_1980_2020.nml qsub scripts/run_icon_baseline.pbs`  
  and increase walltime in the script.

### 3.4 Email (optional)

- Set `#PBS -M your.email@example.com` and keep `#PBS -m abe` for completion/abort mail.

---

## 4. Environment (do not remove)

These are required on Lengau for the current ICON build:

```bash
module load chpc/earth/icon/2025.10-1-intel2021.3
export LD_LIBRARY_PATH=/home/apps/chpc/compmech/compilers/intel_2021.3/oneapi/compiler/2021.3.0/linux/compiler/lib/intel64_lin:/home/apps/chpc/compmech/compilers/intel_2021.3/oneapi/compiler/2021.3.0/linux/compiler/lib:/home/apps/chpc/compmech/compilers/intel_2021.3/oneapi/compiler/2021.3.0/linux/lib:$LD_LIBRARY_PATH
export OMP_NUM_THREADS=1
```

- Already in `scripts/run_icon_baseline.pbs` and `scripts/run_icon_help_test.pbs`. Do not delete; without them you can get symbol or runtime errors. See [ICON_SYMBOL_ERROR_FIX.md](ICON_SYMBOL_ERROR_FIX.md).

---

## 5. Physics and dynamics (defaults)

The provided namelists use production-style defaults. Only change if you follow a specific validated setup:

- **Physics:** `inwp_gscp=2`, `inwp_convection=1`, `inwp_radiation=2`, etc. (see `&atm_phy_nml`).
- **Dynamics:** `ivctype=2`, `itime_scheme=4`, divergence damping as in template (see `&atm_dyn_nml`).
- **Init:** `init_mode=2` (read from file), `iforcing=3` (NWP). Keep unless you use another forcing type.

Refer to the DWD ICON Tutorial or your group's validated config before changing physics/dynamics.

---

## 6. Step-by-step checklist

**Before first run:**

- [ ] Grid file in `input/`; `grid_nml%grid_filename` points to it.
- [ ] Initial-condition file in `input/`; `init_nml%ana_filename` points to it.
- [ ] PBS `#PBS -P` set to your project (e.g. ERTH0904).
- [ ] Scripts have Unix line endings on the cluster (`dos2unix scripts/*.pbs` if needed).

**Short test:**

- [ ] `config/icon_test_short.nml`: small `nsteps` (e.g. 12), correct grid/init paths.
- [ ] From run dir: `qsub scripts/run_icon_baseline.pbs` (uses short test by default).
- [ ] Check `logs/icon_<jobid>.log` and `output/` for success.

**Full 1980–2020:**

- [ ] `config/icon_1980_2020.nml`: `nsteps` (or stop date) for 40 years; restart/checkpoint enabled; monthly output.
- [ ] `scripts/run_icon_baseline.pbs`: walltime long enough for your chunk (e.g. 48 h).
- [ ] Submit with `CONFIG_FILE=icon_1980_2020.nml qsub scripts/run_icon_baseline.pbs`.
- [ ] Plan restarts: after walltime or failure, set `lrestart=.true.` and `restart_filename` to last restart, then resubmit.

---

## 7. References

- **ICON setup workflow:** [ICON_SETUP_WORKFLOW.md](ICON_SETUP_WORKFLOW.md).
- **Start here / grid & init:** [ICON_BASELINE_START_HERE.md](ICON_BASELINE_START_HERE.md), [STEP2_GRID_AND_INIT.md](STEP2_GRID_AND_INIT.md).
- **DWD ICON Tutorial:** for namelist details and validated setups.
- **Symbol/runtime errors:** [ICON_SYMBOL_ERROR_FIX.md](ICON_SYMBOL_ERROR_FIX.md).
