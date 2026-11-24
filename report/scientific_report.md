# Exploratory Population Structure Analysis of HapMap HCB and JPT Samples

**Project type:** Educational bioinformatics analysis
**Tools:** PLINK 2.0, Linux command line, R, ggplot2
**Status:** Exploratory; not a validated population-genomics study

## 1. Research question

Can genome-wide SNP data from a HapMap teaching dataset reveal genetic differentiation and population structure between samples labelled **HCB** (Han Chinese in Beijing; *n* = 45) and **JPT** (Japanese in Tokyo; *n* = 44)?

The goal was to compare allele frequencies, estimate genetic differentiation using Hudson's FST, and visualize sample structure with principal component analysis (PCA). We also examined how minor-allele-frequency (MAF) filtering and LD-pruning thresholds affect the results.

## 2. Dataset and methods

### 2.1 Input data and sample annotation

The analysis used the PLINK HapMap tutorial dataset (`hapmap1.ped`, `hapmap1.map`) and its population annotation file (`pop.phe`). The starting dataset contained **89 individuals** and **83,534 variants**. PED/MAP data were converted to PLINK 2.0 PGEN/PVAR/PSAM format. Sample-to-population matching used the two-part sample key (FID, IID) from the population annotation file; the dataset's case/control phenotype codes were not interpreted as population labels.

### 2.2 Variant quality control and frequency analysis

- Variants with genotype missingness **greater than 5%** were removed with `--geno 0.05`: **2,134 removed**, **81,400 retained**.
- Across the 81,400 retained variants, **23,711** had pooled-sample MAF below 5%, including **14,603** with observed MAF equal to zero.
- A separate dataset was created using `--maf 0.05`, retaining **57,689 variants**. The unfiltered-by-MAF dataset was preserved for sensitivity comparisons.
- Allele frequencies were calculated separately for HCB and JPT. Absolute frequency differences were summarized for each variant: `|f_HCB - f_JPT|`.

### 2.3 Genetic differentiation

Hudson's FST was estimated between the two annotated populations, first after the missingness filter and then after the additional pooled-sample MAF filter.

### 2.4 PCA and LD pruning

PCA was calculated from the 57,689-variant dataset after LD pruning using two configurations:

| LD-pruning configuration | Variants retained for PCA |
|---|---:|
| `--indep-pairwise 50 5 0.2` | 31,822 |
| `--indep-pairwise 50 5 0.1` | 22,830 |

Ten principal components were calculated for each configuration. PC1–PC2 scatter plots were generated in R with points colored using the HCB/JPT metadata. A scree plot was generated for the first PCA using the first ten reported eigenvalues.

## 3. Results

### 3.1 Allele-frequency differentiation

Of the **81,400** variants examined after missingness filtering, **12,095 (14.9%)** showed an observed absolute allele-frequency difference of at least **0.10** (10 percentage points) between HCB and JPT. This threshold was used descriptively and does not constitute a significance test.

As an example, variant `rs2585179` had a reported alternative-allele frequency of **0.244444** in HCB and **0.659091** in JPT, corresponding to an absolute difference of **0.414647** (41.46 percentage points).

### 3.2 Hudson's FST

| Dataset | Hudson's FST |
|---|---:|
| After missingness QC | 0.00682475 |
| After missingness QC + MAF ≥ 5% | 0.00686778 |

Both estimates indicate **low genome-wide genetic differentiation** in this sample. Their small difference (0.00004303) suggests that the overall FST estimate is not highly sensitive to the particular 5% MAF filter used here. No confidence interval or permutation-based significance test was performed.

### 3.3 PCA

Both PCAs showed a **visually clear separation of HCB and JPT along PC1**. In the stricter LD-pruned analysis, mean PC1 scores were **+0.1026376 for HCB** and **−0.1049689 for JPT**. The absolute difference between these group means was approximately **0.20761 PC1 units**. These are PCA coordinates, not allele-frequency percentages, and the sign of a principal component is arbitrary.

The separation remained visible after changing the LD-pruning threshold from *r²* = 0.2 to *r²* = 0.1, a limited sensitivity check supporting the stability of the visual pattern under these two settings.

For the initial PCA, the first two reported eigenvalues were **1.60672 (PC1)** and **1.11740 (PC2)**. PC1 was the largest of the ten computed eigenvalues. Percentages of *total* variance explained cannot be calculated reliably from only these ten reported eigenvalues without the appropriate total variance denominator.

One JPT sample, `JPT253`, appeared closer to PC1 = 0 than most other JPT samples in the stricter PCA. Its missing-genotype fraction in the original dataset was **204/83,534 = 0.00244212 (0.244%)**, providing no obvious indication of unusually high overall missingness. Its position alone does **not** demonstrate admixture or a sample-annotation error.

## 4. Discussion

The low Hudson's FST values and the visible PCA separation are not contradictory. FST summarizes the overall magnitude of allele-frequency differentiation, whereas PCA can display a systematic, multivariate pattern accumulated across many loci, even when the aggregate differentiation is small.

The consistency between the two PCA plots is encouraging but should not be interpreted as proof of definitive population separation or biological causation. The analysis was conducted as a training exercise and has several material limitations.

## 5. Limitations

1. **Artificial genomic positions:** The teaching dataset's MAP file uses artificial marker positions. Consequently, the 50-variant sliding-window LD pruning is an approximation and does not establish control of LD across authentic physical distances.
2. **Pedagogical allele encoding:** Alleles in the source dataset use `1`/`2` coding and PLINK marks reference alleles as provisional. These data should not be interpreted as sequence-resolved nucleotide substitutions without additional harmonization.
3. **Limited sample size:** The analysis includes only 45 HCB and 44 JPT samples, and results may be influenced by sampling variation.
4. **Incomplete validation:** No permutation test, uncertainty interval, kinship assessment, batch-effect investigation, or rigorous sample-level outlier analysis was completed. The source file's sex/phenotype fields also require independent metadata validation before biological interpretation.
5. **LD and marker dependence:** The variant set is not guaranteed to consist of independent markers, and changing an LD threshold does not resolve the artificial-position limitation.

## 6. Conclusion

In this exploratory HapMap training analysis, **HCB and JPT exhibited low genome-wide differentiation by Hudson's FST (approximately 0.0068), alongside a visible separation along PC1**. The FST estimate changed minimally after MAF filtering, and the PCA grouping remained visually similar under two LD-pruning thresholds. These observations demonstrate an end-to-end population-genetics workflow but **do not constitute a fully validated population-genomics finding**.

A useful next step would be to repeat the workflow on a well-annotated dataset with authentic genomic coordinates and complete sample metadata, followed by more rigorous QC, LD pruning, and uncertainty assessment.

## 7. Figures and reproducibility

Recommended repository figures:

- **Figure 1:** PCA of HCB and JPT after LD pruning at *r²* = 0.2 (`pca_HCB_JPT.png`).
- **Figure 2:** PCA of HCB and JPT after stricter LD pruning at *r²* = 0.1 (`pca_HCB_JPT_strict.png`).
- **Figure 3:** Scree plot of the ten eigenvalues from the initial PCA (`scree_plot.png`).

**Data source:** PLINK HapMap tutorial dataset: https://zzz.nyspi.org/plink/tutorial.shtml
**Reproducibility:** The GitHub repository should include scripts, software/environment details, data-acquisition instructions, processing parameters, and figure-generation instructions. Original data should only be redistributed if the applicable terms permit it.
