# Workflow: Testing ICON Installation to Configuring the Global ICON Simulation

**Purpose:** Phase 1 of Paper 2 — from verifying the ICON installation on Lengau through to a fully configured, ready-to-run global ICON simulation (1980–2020) for MPAS boundary conditions.

**Output:** A tested installation, a validated configuration, and a run directory ready for Task 1.1 (submit the 1980–2020 baseline run).

---

## Overview

| Step | What you do | Success criterion |
|------|-------------|--------------------|
| 1 | Test ICON installation on Lengau | `icon --help` works; short test run completes |
| 2 | Choose and obtain global grid + initial/boundary data | Grid file and init data paths known |
| 3 | Configure namelists for global 1980–2020 run | Namelists match DWD/validated defaults; paths correct |
| 4 | Set up run directory and job script | All paths valid; PBS script points to your config |
| 5 | Run a short “sanity” simulation | A few time steps complete; output files written |
| 6 | Finalise for long run (checkpointing, output frequency) | Ready to submit Task 1.1 (full 1980–2020) |

---

## Step 1: Test ICON Installation on Lengau

**Goal:** Confirm the ICON binary and environment work before investing in a full setup.

### 1.1 Log in and load the module

```bash
ssh msovara@lengau.chpc.ac.za
# Or: ssh msovara@login2.lengau.chpc.ac.za

module load chpc/earth/icon/2025.10-1-intel2021.3
# If your installed version has a different name, use: module avail icon
# and load the one that matches your build (e.g. icon/latest-intel2021.3)
```

### 1.2 Verify the executable

```bash
which icon
icon --help
# Optional: icon --version (if supported)
```

You should see ICON’s help text; no “command not found” or library errors.

### 1.3 Minimal test run (no real grid)

Use a tiny step count and a test/example config so the run finishes in seconds and only checks that the binary runs.

- **Option A — Use icon-usage example:**  
  Clone or copy the [icon-chpc](https://github.com/msovara/icon-chpc) (or icon-usage) repo on Lengau, then:

```bash
cd /mnt/lustre/users/msovara/SoftwareBuilds/icon  # or your chosen dir
# Copy example config and ensure grid_filename exists or use a minimal grid
cp icon-usage/config/example_run.nml ./test_install.nml
# Edit test_install.nml: set nsteps = 2, and grid_filename to a grid you have
# (see Step 2 for where to get grids)
icon -c test_install.nml
```

- **Option B — Synthetic/minimal run:**  
  If the ICON build provides a test case (e.g. in `$ICON/examples` or `run`), run that once according to the installation guide.

**Check:** Run completes without segfault; no “missing file” errors that indicate a broken install. If you see “grid file not found”, that’s a configuration/path issue, not necessarily a broken install.

### 1.4 Quick PBS test (optional but recommended)

Submit a 1-node, 1-minute job that only runs `icon --help` or the same minimal `icon -c test_install.nml` to confirm the module and MPI environment work under PBS.

```bash
#PBS -l select=1:ncpus=4:mpiprocs=4
#PBS -l walltime=00:05:00
#PBS -q normal
cd $PBS_O_WORKDIR
module load chpc/earth/icon/2025.10-1-intel2021.3
mpirun -np 4 icon -c test_install.nml
```

**Check:** Job runs and exits 0; no module or MPI errors in the PBS output.

---

## Step 2: Choose and Obtain Global Grid and Initial/Boundary Data

**Goal:** Have the grid file and initial conditions (and any boundary data) that a global 1980–2020 run needs. Paths will be used in Step 3.

### 2.1 Global grid

- ICON global runs use an icosahedral grid (e.g. R2B04, R2B05, …). Resolution choice affects cost and resolution of your boundary conditions for MPAS.
- **Obtain:** From DKRZ/CESM/ICON distribution or your institute’s shared data. Typical locations:
  - DKRZ/CESM: e.g. `icon_grid_<name>.nc`
  - Lengau: check `/home/apps/chpc/earth/` or project space for pre-downloaded grids.
- **Place:** e.g. `/mnt/lustre/users/msovara/icon_runs/global/grids/` and note the full path for `grid_nml%grid_filename`.

### 2.2 Initial conditions (and boundary data if applicable)

- For a **global** atmosphere (and optionally ocean) run starting 1980, you need:
  - **Initial state:** e.g. from ERA5 or another reanalysis interpolated to the ICON grid (often provided by DKRZ or your group).
  - **SST / boundary** if not coupled: e.g. prescribed SST files; format and frequency must match your namelist.
- **References:** DWD ICON Tutorial and [icon-chpc config README](https://github.com/msovara/icon-chpc) describe common setups. Align with a “validated” global configuration (e.g. from DWD/MPI-M or your group).

**Deliverable:** List of paths (grid, initial file, SST/boundary if needed). Put these in a small text file or env vars so you can plug them into the namelist in Step 3.

---

## Step 3: Configure Namelists for Global 1980–2020 Run

**Goal:** Produce the main run namelist and output namelist that match a validated global configuration and your data paths.

### 3.1 Base template

Start from a **global**, production-style template. In icon-chpc/icon-usage you have:

- `config/production_run.nml` — use as base.
- `config/atmosphere_only.nml` or `config/coupled_atm_oce.nml` — use if your Task 1.1 is atmosphere-only or coupled; adjust to match the “validated” setup you are mirroring.

Copy to your run directory:

```bash
cp icon-usage/config/production_run.nml /mnt/lustre/users/msovara/icon_runs/global/icon_1980_2020.nml
cp icon-usage/config/example_run.nml    /mnt/lustre/users/msovara/icon_runs/global/output.nml
# Edit both as below
```

### 3.2 Key namelist edits for 1980–2020 global run

Apply these in `icon_1980_2020.nml` (and any included namelists). Use the DWD ICON Tutorial and your chosen “validated” config as the authority; below is a checklist.

| Namelist / parameter | What to set | Notes |
|----------------------|-------------|--------|
| `&run_nml` | | |
| `nsteps` | Large enough for 1980–2020 at your `dtime` | e.g. (41×365.25×24×3600)/dtime; or use `stop_date` if supported |
| `dtime` | e.g. 300–720 s | Match validated global config; stability depends on resolution |
| `lrestart` | .false. for start; .true. for restarts | |
| `restart_filename` | Path to restart when restarting | |
| `output` | e.g. `"icon_1980_2020"` | Prefix for your output files |
| `&grid_nml` | | |
| `grid_filename` | Full path to your global grid file | From Step 2.1 |
| `&init_nml` | | |
| `init_mode` | 2 (read from file) for real-data start | |
| `ana_filename` | Full path to initial condition file | From Step 2.2 |
| `iforcing` | As in validated config (e.g. 3 for NWP) | |
| `&io_nml` | num_io_procs, async_prefetch, etc. | Match production; tune for Lengau if needed |
| **Output** | | |
| `output.nml` or in-run output list | Monthly means; variables needed for MPAS BCs | See 3.3 |

### 3.3 Output: monthly means for MPAS boundary conditions

Task 1.1 requires **monthly-mean** atmospheric (and oceanic if coupled) fields for MPAS. In ICON this is usually done by:

- Defining an output stream with a **monthly** interval, and
- Selecting the variables that will be used as boundary conditions for MPAS (e.g. T, U, V, Q, Ps, SST, etc.).

Configure the output namelist (or the output section of your main namelist) accordingly. Exact namelist names depend on your ICON version (e.g. `output_nml`, or stream-specific blocks). Reference: DWD ICON Tutorial and your `config/README.md`.

**Check:** No path in the namelist points to a non-existent file; `nsteps` or stop date covers 1980–2020; output interval is monthly.

---

## Step 4: Set Up Run Directory and Job Script

**Goal:** One directory that contains configs, links to grid/init data, and a PBS script that runs the 1980–2020 job.

### 4.1 Directory layout

Example:

```text
/mnt/lustre/users/msovara/icon_runs/global/
├── icon_1980_2020.nml    # Main namelist
├── output.nml            # Output stream definitions
├── input/                # Symlinks or copies of grid + init + BC data
│   ├── icon_grid_R2B05.nc
│   └── init_1980.nc
├── output/               # ICON will write here (set in job or namelist)
├── restart/              # Restart files (for long run)
├── logs/
└── run_global_1980_2020.pbs
```

Create it and point the namelist paths to `input/` (or absolute paths under this tree).

### 4.2 PBS script

Base the script on `icon-usage/scripts/run_icon_production.pbs`. Key changes:

- **CONFIG_FILE:** Your main namelist, e.g. `icon_1980_2020.nml`.
- **Resource request:** For a 40-year global run, request enough nodes and walltime (e.g. multiple days or use checkpointing and multiple jobs). Start conservative (e.g. 4 nodes × 48 h) then adjust from first test.
- **Paths:** Set `PBS_O_WORKDIR` or explicitly `cd` to the run directory; ensure `input/`, `output/`, `restart/` are used consistently.
- **Email:** Set `#PBS -M your.email@example.com` for completion/abort alerts.

Example (adjust node count and walltime):

```bash
#PBS -N icon_global_1980_2020
#PBS -l select=4:ncpus=24:mpiprocs=24:ompthreads=1
#PBS -l walltime=48:00:00
#PBS -q normal
#PBS -o icon_global.out
#PBS -e icon_global.err
#PBS -m abe
#PBS -M your.email@example.com

cd $PBS_O_WORKDIR
module load chpc/earth/icon/2025.10-1-intel2021.3
export OMP_NUM_THREADS=1

CONFIG_FILE="icon_1980_2020.nml"
mkdir -p output restart logs
mpirun -np ${PBS_NP} icon -c ${CONFIG_FILE} > logs/icon_${PBS_JOBID}.log 2>&1
```

**Check:** `qsub run_global_1980_2020.pbs` from that directory would use the right config and paths (you can do a short test in Step 5).

---

## Step 5: Run a Short “Sanity” Simulation

**Goal:** Confirm that the full pipeline (config + grid + init + PBS) works over a few time steps before committing to the long run.

### 5.1 Short test config

Copy your production namelist to a test one:

```bash
cp icon_1980_2020.nml icon_test_short.nml
```

Edit `icon_test_short.nml`: set `nsteps = 12` (or similar small number), same grid and init file. Optionally reduce output frequency or disable extra output streams to speed up the test.

### 5.2 Submit a short job

Temporarily point the PBS script at `icon_test_short.nml` and request a short walltime (e.g. 30 minutes). Submit:

```bash
qsub run_global_1980_2020.pbs
qstat -u $USER
```

After the job completes, check:

- PBS output/error files: no MPI or module errors.
- `output/`: at least one NetCDF or output file produced.
- `logs/icon_*.log`: ICON reports normal integration (no fatal errors).

If anything fails, fix paths/namelist and re-run this step until the short test passes.

### 5.3 Restore production config

Point the PBS script back to `icon_1980_2020.nml` and, if you use restart, set `lrestart = .false.` and the correct start date/initial file for the full 1980–2020 run.

---

## Step 6: Finalise for the Long Run (Task 1.1)

**Goal:** Ensure the 1980–2020 run is robust and reproducible.

### 6.1 Checkpointing and restarts

- Enable checkpoint/restart in the namelist so that if the job hits walltime or fails, you can resume from the last checkpoint.
- Decide restart write frequency (e.g. monthly or every N steps). Align with PBS walltime and queue limits so one job writes restarts before the limit.

### 6.2 Output and storage

- Confirm monthly-mean output is written and variables match what MPAS will need.
- Ensure `output/` (and restart) paths have enough quota on Lustre; plan for 40 years of monthly data.

### 6.3 Submission and monitoring

- Submit the production job: `qsub run_global_1980_2020.pbs`.
- Monitor with `qstat`; check first `output/` and `restart/` files after a few hours/days.
- If the job stops (walltime or failure), restart using the last restart file and set `lrestart = .true.`, `restart_filename = "..."` in the namelist, and resubmit (you may want a separate `run_global_restart.pbs` that points to a restart config).

---

## Checklist Summary

Before considering “setup complete” and moving to Task 1.1:

- [ ] ICON runs with `icon --help` and a minimal test run on Lengau (interactive and optionally under PBS).
- [ ] Global grid file and initial condition file paths are set in the namelist and exist under the run directory (or absolute paths).
- [ ] Main namelist has been adjusted for 1980–2020 (nsteps or stop date, dtime, validated physics/dynamics choices).
- [ ] Output is configured for monthly means and the variables needed for MPAS boundary conditions.
- [ ] Run directory has a clear layout (config, input, output, restart, logs) and the PBS script uses it correctly.
- [ ] A short sanity run (small nsteps) has been submitted and completed successfully with output files written.
- [ ] Checkpoint/restart is enabled and you know how to resume after walltime or failure.
- [ ] Production job script points at the final namelist and is ready to submit for the full 1980–2020 run.

---

## References

- **DWD ICON Tutorial 2025:** [PDF](https://www.dwd.de/EN/ourservices/nwp_icon_tutorial/pdf_volume/icon_tutorial2025_en.pdf) — setup, namelists, and best practices.
- **icon-chpc (Lengau):** [github.com/msovara/icon-chpc](https://github.com/msovara/icon-chpc) — config templates, PBS scripts, and usage notes.
- **ICON installation (this project):** `icon/ICON_INSTALLATION_GUIDE.md` — build and module details on Lengau.
- **Paper 2 research plan:** Phase 1, Task 1.1 — Run Global ICON Simulation (1980–2020); output = boundary conditions for MPAS.
