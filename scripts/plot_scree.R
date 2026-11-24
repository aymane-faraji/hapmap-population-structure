# Load ggplot2
library(ggplot2)

# Read eigenvalues
eigenval <- read.table("hapmap_pca.eigenval", header = FALSE)

# Rename the column
names(eigenval) <- c("Eigenvalue")

# Add principal component labels
eigenval$PC <- paste0("PC", 1:nrow(eigenval))
eigenval$PC <- factor(eigenval$PC, levels = eigenval$PC)



# Check the table
print(eigenval)

# Create scree plot
scree_plot <- ggplot(eigenval, aes(x = PC, y = Eigenvalue, group = 1)) +
  geom_line() +
  geom_point(size = 3) +
  labs(
    title = "Scree Plot of the First 10 Principal Components",
    x = "Principal Component",
    y = "Eigenvalue"
  ) +
  theme_minimal(base_size = 13)

# Save the plot
ggsave(
  filename = "scree_plot.png",
  plot = scree_plot,
  width = 8,
  height = 5,
  dpi = 300,
  bg = "white"
)

cat("Scree plot saved successfully!\n")