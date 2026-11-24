
# ==========================================
# HapMap Population Genomics
# Reproducible PCA Visualization
# ==========================================

library(ggplot2)

# Input and output directories
input_dir <- "results/reproduced"
output_dir <- "figures/reproduced"

dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

# Read population metadata
pop <- read.table(
  "data/pop.phe",
  header = FALSE,
  col.names = c("FID", "IID", "Population")
)

pop$Population <- factor(
  pop$Population,
  levels = c(1, 2),
  labels = c("HCB", "JPT")
)

# Function to create a PCA plot
create_pca_plot <- function(prefix, title, filename) {

  # Read PLINK2 PCA coordinates
  pca <- read.table(
    file.path(input_dir, paste0(prefix, ".eigenvec")),
    header = TRUE,
    comment.char = "",
    check.names = FALSE
  )

  names(pca)[1:2] <- c("FID", "IID")

  # Join coordinates with population information
  data <- merge(pca, pop, by = c("FID", "IID"))

  # Validate sample matching
  stopifnot(
    nrow(data) == 89,
    sum(data$Population == "HCB") == 45,
    sum(data$Population == "JPT") == 44
  )

  # Build the PCA plot
  plot <- ggplot(
    data,
    aes(x = PC1, y = PC2, color = Population)
  ) +
    geom_point(size = 3, alpha = 0.8) +
    scale_color_manual(
      values = c(HCB = "#2878B5", JPT = "#E28C32")
    ) +
    labs(
      title = title,
      x = "PC1",
      y = "PC2",
      color = "Population"
    ) +
    theme_minimal(base_size = 13)

  # Save the figure
  ggsave(
    filename = file.path(output_dir, filename),
    plot = plot,
    width = 8,
    height = 5,
    dpi = 300,
    bg = "white"
  )

  cat("Saved:", filename, "\n")
}

# Generate standard PCA figure
create_pca_plot(
  "pca_standard",
  "HCB vs JPT - PCA (LD r² = 0.2)",
  "pca_standard.png"
)

# Generate strict PCA figure
create_pca_plot(
  "pca_strict",
  "HCB vs JPT - PCA (LD r² = 0.1)",
  "pca_strict.png"
)

# ==========================================
# Scree Plot
# ==========================================

eigenval <- read.table(
  file.path(input_dir, "pca_standard.eigenval"),
  header = FALSE
)

names(eigenval) <- "Eigenvalue"

# Set the correct PC order
eigenval$PC <- factor(
  paste0("PC", seq_len(nrow(eigenval))),
  levels = paste0("PC", seq_len(nrow(eigenval)))
)

scree_plot <- ggplot(
  eigenval,
  aes(x = PC, y = Eigenvalue, group = 1)
) +
  geom_line() +
  geom_point(size = 3) +
  labs(
    title = "Scree Plot - First 10 Principal Components",
    x = "Principal Component",
    y = "Eigenvalue"
  ) +
  theme_minimal(base_size = 13)

ggsave(
  filename = file.path(output_dir, "scree_plot.png"),
  plot = scree_plot,
  width = 8,
  height = 5,
  dpi = 300,
  bg = "white"
)

cat("All reproduced figures saved successfully!\n")
