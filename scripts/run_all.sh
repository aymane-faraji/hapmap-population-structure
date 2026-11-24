
#!/usr/bin/env bash

# HapMap Population Genomics
# Complete reproducible analysis workflow

set -euo pipefail

# Navigate to the project root
cd "$(dirname "$0")/.."

# Check required tools
command -v plink2 >/dev/null || {
    echo "ERROR: PLINK2 is not installed."
    exit 1
}

command -v Rscript >/dev/null || {
    echo "ERROR: Rscript is not installed."
    exit 1
}

# Check required input files
for file in data/hapmap1.ped data/hapmap1.map data/pop.phe; do
    if [[ ! -f "$file" ]]; then
        echo "ERROR: Missing input file: $file"
        exit 1
    fi
done

echo "=================================="
echo "HAPMAP POPULATION GENOMICS"
echo "=================================="

echo "[1/4] Running quality control..."
bash scripts/run_qc.sh

echo "[2/4] Calculating Hudson's FST..."
bash scripts/run_fst.sh

echo "[3/4] Performing LD pruning and PCA..."
bash scripts/run_pca.sh

echo "[4/4] Generating R figures..."
Rscript scripts/plot_reproduced.R

echo "=================================="
echo "WORKFLOW COMPLETED SUCCESSFULLY"
echo "=================================="
