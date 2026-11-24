
#!/usr/bin/env bash

# HapMap Population Genomics
# Step 3: LD pruning and PCA

set -euo pipefail

# Navigate to the project root
cd "$(dirname "$0")/.."

# Define input and output paths
INPUT="results/reproduced/hapmap_qc2"
OUT="results/reproduced"

# ==========================================
# 1. Standard LD pruning (r² = 0.2)
# ==========================================

plink2 \
  --pfile "$INPUT" \
  --autosome \
  --indep-pairwise 50 5 0.2 \
  --out "$OUT/ld_standard"

# Run PCA with retained variants
plink2 \
  --pfile "$INPUT" \
  --extract "$OUT/ld_standard.prune.in" \
  --pca 10 \
  --out "$OUT/pca_standard"

# ==========================================
# 2. Strict LD pruning (r² = 0.1)
# ==========================================

plink2 \
  --pfile "$INPUT" \
  --autosome \
  --indep-pairwise 50 5 0.1 \
  --out "$OUT/ld_strict"

# Run PCA with retained variants
plink2 \
  --pfile "$INPUT" \
  --extract "$OUT/ld_strict.prune.in" \
  --pca 10 \
  --out "$OUT/pca_strict"

# ==========================================
# 3. Verify results
# ==========================================

echo "Standard and strict pruning results:"
wc -l \
  "$OUT/ld_standard.prune.in" \
  "$OUT/ld_strict.prune.in"

echo "LD pruning and PCA completed successfully."
