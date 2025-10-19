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

# Define colors with 50% transparency (alpha = 0.5)
colors <- c(
  "True Positive" = rgb(0/255, 255/255, 0/255, 1.0),  # Green for TP (#4CAF50)
  "True Negative" = rgb(0/255, 255/255, 0/255, 1.0),  # Green for TN (#4CAF50)
  "False Positive" = rgb(244/255, 67/255, 54/255, 1.0), # Red for FP (#F44336)
  "False Negative" = rgb(255/255, 152/255, 0/255, 1.0)  # Orange for FN (#FF9800)
)

# Explicitly open a graphics device (optional, for troubleshooting)
dev.new()

# Create and display the heatmap
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
    axis.title = element_text(size = 14, face = "bold"),
    plot.title = element_text(size = 16, face = "bold", hjust = 0.5),
    panel.grid = element_blank(),
    legend.position = "none"
  ) +
  coord_fixed()

# Explicitly print the plot to ensure it displays
print(plot)