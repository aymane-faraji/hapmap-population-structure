
#!/usr/bin/env bash

# HapMap population genomics
# Step 2: Genetic differentiation analysis

set -euo pipefail

# Navigate to the project root
cd "$(dirname "$0")/.."

# Calculate Hudson's FST before MAF filtering
plink2 \
  --pfile results/reproduced/hapmap_qc1 \
  --within data/pop.phe POP \
  --fst POP method=hudson \
  --out results/reproduced/fst_before_maf

# Calculate Hudson's FST after MAF filtering
plink2 \
  --pfile results/reproduced/hapmap_qc2 \
  --within data/pop.phe POP \
  --fst POP method=hudson \
  --out results/reproduced/fst_after_maf

# Display both results
echo "FST before MAF filtering:"
cat results/reproduced/fst_before_maf.fst.summary

echo "FST after MAF filtering:"
cat results/reproduced/fst_after_maf.fst.summary
