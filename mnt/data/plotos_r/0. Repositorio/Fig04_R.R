# Install ggplot2 if not already installed
if (!require(ggplot2)) {
  install.packages("ggplot2")
}

# Load ggplot2 library
library(ggplot2)

# Create the confusion matrix data with types
conf_matrix <- data.frame(
  Reference = factor(c("Non-Toxic", "Non-Toxic", "Toxic", "Toxic"), levels = c("Non-Toxic", "Toxic")),
  Predicted = factor(c("Non-Toxic", "Toxic", "Non-Toxic", "Toxic"), levels = c("Non-Toxic", "Toxic")),
  Count = c(499, 1, 25, 475),
  Type = c("True Negative", "False Positive", "False Negative", "True Positive")
)

# Define colors
colors <- c(
  "True Positive" = "#00FF00",  # Green for TP
  "True Negative" = "#00FF00",  # Green for TN
  "False Positive" = "#F44336", # Red for FP
  "False Negative" = "#FF9800"  # Orange for FN
)

# Create the heatmap plot
plot <- ggplot(conf_matrix, aes(x = Predicted, y = Reference, fill = Type)) +
  geom_tile(color = "white", linewidth = 1) +
  geom_text(aes(label = Count), color = "white", size = 6, fontface = "bold") +
  scale_fill_manual(values = colors) +
  theme_minimal() +
  labs(
    title = "Confusion Matrix",
    x = "Classification by LLM",
    y = "Reference"
  ) +
  theme(
    axis.text = element_text(size = 12, face = "plain"),
    axis.title = element_text(size = 14, face = "plain"),
    plot.title = element_text(size = 16, face = "plain", hjust = 0.5),
    panel.grid = element_blank(),
    legend.position = "none"
  ) +
  coord_fixed()

# Print the plot to the RStudio plot pane
print(plot)

# ---

### Saving the plot 💾

# Verifica si la carpeta existe y, si no, la crea
if (!dir.exists("0. Repositorio/img")) {
  dir.create("0. Repositorio/img", recursive = TRUE)
}

# Ahora puedes guardar los gráficos sin problemas
ggsave("0. Repositorio/img/Fig04.pdf", plot = plot, width = 6, height = 5, units = "in")
ggsave("0. Repositorio/img/Fig04.png", plot = plot, width = 6, height = 5, units = "in", dpi = 300)