
#!/usr/bin/env bash

# HapMap population genomics
# Step 1: Data conversion and quality control

set -euo pipefail

# Move to the project root directory
cd "$(dirname "$0")/.."

# Keep reproduced outputs separate from original results
mkdir -p results/reproduced

# 1. Convert PED/MAP files into PLINK2 format
plink2 \
  --pedmap data/hapmap1 \
  --make-pgen \
  --out results/reproduced/hapmap_raw

# 2. Remove variants with >5% missing genotypes
plink2 \
  --pfile results/reproduced/hapmap_raw \
  --geno 0.05 \
  --make-pgen \
  --out results/reproduced/hapmap_qc1

# 3. Remove variants with MAF <5%
plink2 \
  --pfile results/reproduced/hapmap_qc1 \
  --maf 0.05 \
  --make-pgen \
  --out results/reproduced/hapmap_qc2

echo "Quality control completed successfully."
