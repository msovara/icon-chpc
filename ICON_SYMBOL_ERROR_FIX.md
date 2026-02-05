# Fix: icon --help "undefined symbol: __svml_idiv8_l9"

## What the error means

```
icon: symbol lookup error: .../netcdf-4.9.2-intel2021.3/hdf5/lib/libhdf5.so.310: undefined symbol: __svml_idiv8_l9
```

`__svml_idiv8_l9` is an **Intel SVML (Short Vector Math Library)** symbol. The ICON binary was built with Intel 2021.3, but the HDF5 library (from the NetCDF module) was built with a different Intel runtime or is loading without the Intel compiler runtime in the library path. The dynamic linker then fails when HDF5 (or code that uses it) needs that symbol.

---

## Fixes to try (on Lengau, in order)

### 1. Load the Intel compiler module **before** ICON (if available)

On Lengau there is **no** separate `intel/2021.3` module; ICON was built with Intel 2021.3 but that compiler is not exposed as a module. So skip to **Fix 2** (set `LD_LIBRARY_PATH` manually).

If on another cluster you have e.g. `module load intel/2021.3`, load it **before** ICON and try `icon --help`.

---

### 2. Prepend the Intel compiler lib path manually

If there is no Intel module, or loading it doesn't fix the error, set `LD_LIBRARY_PATH` to the Intel 2021.3 compiler libs (SVML is there):

```bash
module load chpc/earth/icon/2025.10-1-intel2021.3
export LD_LIBRARY_PATH=/home/apps/chpc/compmech/compilers/intel_2021.3/oneapi/compiler/2021.3.0/linux/compiler/lib:$LD_LIBRARY_PATH
icon --help
```

On Lengau the correct path is `.../compiler/2021.3.0/linux/compiler/lib`. If it still fails, also prepend `.../compiler/2021.3.0/linux/lib`.

---

### 3. Make the fix permanent in your PBS script

For jobs, add the same `module load` order and/or `LD_LIBRARY_PATH` at the top of your run script (e.g. `scripts/run_icon_baseline.pbs`), **before** `mpirun`:

```bash
module load chpc/earth/icon/2025.10-1-intel2021.3
# Required on Lengau (see this doc):
export LD_LIBRARY_PATH=/home/apps/chpc/compmech/compilers/intel_2021.3/oneapi/compiler/2021.3.0/linux/compiler/lib/intel64_lin:/home/apps/chpc/compmech/compilers/intel_2021.3/oneapi/compiler/2021.3.0/linux/compiler/lib:/home/apps/chpc/compmech/compilers/intel_2021.3/oneapi/compiler/2021.3.0/linux/lib:$LD_LIBRARY_PATH
export OMP_NUM_THREADS=1
mpirun -np ${PBS_NP} icon -c ${CONFIG_FILE} ...
```

---

### 4. If it still fails: ask CHPC to align NetCDF/HDF5 with ICON

If loading Intel first and/or setting `LD_LIBRARY_PATH` does not fix it, the NetCDF/HDF5 stack may have been built with a different Intel version. In that case:

- Ask CHPC support to either:
  - Rebuild NetCDF/HDF5 with the **same** Intel 2021.3 used for ICON, or
  - Document the exact module load order (and any `LD_LIBRARY_PATH`) required for `chpc/earth/icon/2025.10-1-intel2021.3` and `chpc/earth/netcdf/...`.

Include in your request:

- The exact error: `symbol lookup error: ... libhdf5.so.310: undefined symbol: __svml_idiv8_l9`
- That you load: `chpc/earth/icon/2025.10-1-intel2021.3`
- Output of: `module list` and `echo $LD_LIBRARY_PATH` when the error occurs.

---

## Quick copy-paste (Lengau)

**Run these one at a time** (so the export doesn't get truncated):

```bash
module purge
module load chpc/earth/icon/2025.10-1-intel2021.3
```

```bash
export LD_LIBRARY_PATH=/home/apps/chpc/compmech/compilers/intel_2021.3/oneapi/compiler/2021.3.0/linux/compiler/lib:$LD_LIBRARY_PATH
```

Check it took effect:

```bash
echo $LD_LIBRARY_PATH
```

You should see `/home/apps/chpc/compmech/compilers/intel_2021.3/oneapi/compiler/2021.3.0/linux/compiler/lib` at the start. Then:

```bash
icon --help
```

**If it still fails**, add the second Intel lib path and try again:

```bash
export LD_LIBRARY_PATH=/home/apps/chpc/compmech/compilers/intel_2021.3/oneapi/compiler/2021.3.0/linux/compiler/lib:/home/apps/chpc/compmech/compilers/intel_2021.3/oneapi/compiler/2021.3.0/linux/lib:$LD_LIBRARY_PATH
icon --help
```

**If you then get `libifport.so.5: cannot open shared object file`:** the minimal path omitted the Intel Fortran runtime dir. Find it and add it:

```bash
find /home/apps/chpc/compmech/compilers/intel_2021.3 -name "libifport*" 2>/dev/null
```

Add the **directory** that contains `libifport.so.5` to `LD_LIBRARY_PATH`. On Lengau it is `intel64_lin` (64-bit):

```bash
export LD_LIBRARY_PATH=/home/apps/chpc/compmech/compilers/intel_2021.3/oneapi/compiler/2021.3.0/linux/compiler/lib/intel64_lin:/home/apps/chpc/compmech/compilers/intel_2021.3/oneapi/compiler/2021.3.0/linux/compiler/lib:/home/apps/chpc/compmech/compilers/intel_2021.3/oneapi/compiler/2021.3.0/linux/lib:/home/apps/chpc/earth/icon-2025.10-1-intel2021.3/lib
icon --help
```

**Full working sequence (minimal env):** Use this in a **batch job on a compute node**, not on the login node (see below).

**SIGSEGV on login node when running `icon --help`:** ICON is linked with MPI and calls `MPI_Init` at startup. Login nodes often do not support running MPI, so you get a segmentation fault. **Run the test in a short PBS job** on a compute node. From your run directory (where you have copied the repo scripts and configs):

```bash
cd /path/to/your/icon_run_directory
qsub scripts/run_icon_help_test.pbs
```

Then check `icon_help_test.out` and `icon_help_test.err`. If the install and `LD_LIBRARY_PATH` are correct, the job will finish and the output will show ICON's help. Use the same `LD_LIBRARY_PATH` in your real run script (`scripts/run_icon_baseline.pbs`).

---

**If you still had the SVML error:** try a **minimal environment** (other modules can pollute `LD_LIBRARY_PATH` with Intel 2016 etc.):

```bash
module purge
module load chpc/earth/icon/2025.10-1-intel2021.3
export LD_LIBRARY_PATH=/home/apps/chpc/compmech/compilers/intel_2021.3/oneapi/compiler/2021.3.0/linux/compiler/lib:/home/apps/chpc/compmech/compilers/intel_2021.3/oneapi/compiler/2021.3.0/linux/lib:/home/apps/chpc/earth/icon-2025.10-1-intel2021.3/lib
icon --help
```

If it still fails, the NetCDF/HDF5 stack was likely built with a different Intel version. **Contact CHPC** and ask them to fix the `chpc/earth/netcdf/4.9.2-intel2021.3` (or HDF5) build so it is compatible with `chpc/earth/icon/2025.10-1-intel2021.3`, or to provide the correct `LD_LIBRARY_PATH` / module order. Include the exact error and the output of `echo $LD_LIBRARY_PATH` and `module list`.
