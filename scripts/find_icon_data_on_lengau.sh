#!/bin/bash
# Run on Lengau to find ICON grid and initial-condition files.
# Usage: set ICON_BASELINE_DIR to your run directory (default below), then:
#   bash scripts/find_icon_data_on_lengau.sh
# Copy/symlink found files to <run_dir>/input/ and set paths in config/*.nml

set -e
BASE="${ICON_BASELINE_DIR:-/mnt/lustre/users/$USER/icon_baseline}"
INPUT="$BASE/input"

echo "=== Run directory (set ICON_BASELINE_DIR to override): $BASE ==="
echo ""

echo "=== Searching for ICON grid files (icon_grid*.nc) ==="
find /home/apps/chpc/earth -maxdepth 4 -name "icon_grid*.nc" 2>/dev/null | head -20
find /mnt/lustre/users/$USER -maxdepth 5 -name "icon_grid*.nc" 2>/dev/null | head -20
echo ""

echo "=== Searching for possible initial-condition / analysis files ==="
find /home/apps/chpc/earth -maxdepth 4 \( -name "*init*.nc" -o -name "*ana*.nc" -o -name "*initial*.nc" -o -name "*1980*.nc" \) 2>/dev/null | head -20
find /mnt/lustre/users/$USER -maxdepth 5 \( -name "*init*.nc" -o -name "*ana*.nc" -o -name "*initial*.nc" \) 2>/dev/null | head -20
echo ""

echo "=== Your input directory ==="
ls -la "$INPUT" 2>/dev/null || echo "Directory $INPUT not found."
echo ""
echo "If you find a grid file, copy or symlink it to $INPUT/ (e.g. input/icon_grid_R2B05.nc)."
echo "If you find an initial-condition file, copy or symlink to $INPUT/ (e.g. input/initial_conditions.nc)."
echo "Then edit config/icon_test_short.nml and config/icon_1980_2020.nml: set grid_filename and ana_filename to match."
