# Load required library
library(fmsb)

# Define the data
vals1 <- c(Toxicity = 9.0, Feeling = 3.003, Violence = 2.00, Insult = 0.555)
vals2 <- c(Toxicity = 0.09, Feeling = 4.545, Violence = 9.00, Insult = 0.01)
vals3 <- c(Toxicity = 0.09, Feeling = 6.935, Violence = 6.00, Insult = 0.01)
vals4 <- c(Toxicity = 0.09, Feeling = 4.543, Violence = 6.00, Insult = 0.01)

# Function to prepare data for radar chart
prepare_radar_data <- function(values) {
  data <- rbind(rep(10, 4), rep(0, 4), values)
  colnames(data) <- names(values)
  return(as.data.frame(data))
}

# Set up a 2x2 layout with adjusted margins
par(mfrow = c(2, 2), mar = c(2, 2, 3, 2))  # Ajuste de márgenes para títulos superiores

# Radar chart for vals1 (Top-left)
radarchart(prepare_radar_data(vals1),
           axistype = 1,
           pcol = rgb(244/255, 67/255, 54/255, 0.9),
           pfcol = rgb(244/255, 67/255, 54/255, 0.3),
           plwd = 2,
           cglcol = "grey",
           cglty = 1,
           axislabcol = "blue",
           caxislabels = seq(0, 10, 2.5),
           cglwd = 0.8,
           vlcex = 1.2,
           title = "(a)")  # Añadido título superior
text(x = 0.7, y = 0.75, labels = expression(GDVI[AI] == "5.506"), xpd = TRUE, cex = 0.9, col = "blue", font = 2, pos = 1)
text(x = 0.05, y = 0.97, labels = vals1[["Toxicity"]], xpd = TRUE, cex = 1.0, col = "black", font = 1, pos = 1)
text(x = -0.55, y = 0.12, labels = vals1[["Feeling"]], xpd = TRUE, cex = 1.0, col = "black", font = 1, pos = 1)
text(x = 0.37, y = 0.12, labels = vals1[["Insult"]], xpd = TRUE, cex = 1.0, col = "black", font = 1, pos = 1)
text(x = 0.05, y = -0.3, labels = vals1[["Violence"]], xpd = TRUE, cex = 1.0, col = "black", font = 1, pos = 1)

# Radar chart for vals2 (Top-right)
radarchart(prepare_radar_data(vals2),
           axistype = 1,
           pcol = rgb(255/255, 152/255, 0/255, 0.9),
           pfcol = rgb(255/255, 152/255, 0/255, 0.3),
           plwd = 2,
           cglcol = "grey",
           cglty = 1,
           axislabcol = "blue",
           caxislabels = seq(0, 10, 2.5),
           cglwd = 0.8,
           vlcex = 1.2,
           title = "(b)")  # Título superior
text(x = 0.7, y = 0.75, labels = expression(GDVI[AI] == "2.987"), xpd = TRUE, cex = 0.9, col = "blue", font = 2, pos = 1)
text(x = 0.125, y = 0.28, labels = vals2[["Toxicity"]], xpd = TRUE, cex = 1.0, col = "black", font = 1, pos = 1)
text(x = -0.65, y = 0.13, labels = vals2[["Feeling"]], xpd = TRUE, cex = 1.0, col = "black", font = 1, pos = 1)
text(x = 0.28, y = 0.13, labels = vals2[["Insult"]], xpd = TRUE, cex = 1.0, col = "black", font = 1, pos = 1)
text(x = 0.05, y = -0.85, labels = vals2[["Violence"]], xpd = TRUE, cex = 1.0, col = "black", font = 1, pos = 1)

# Radar chart for vals3 (Bottom-left)
radarchart(prepare_radar_data(vals3),
           axistype = 1,
           pcol = rgb(255/255, 152/255, 0/255, 0.9),
           pfcol = rgb(255/255, 152/255, 0/255, 0.3),
           plwd = 2,
           cglcol = "grey",
           cglty = 1,
           axislabcol = "blue",
           caxislabels = seq(0, 10, 2.5),
           cglwd = 0.8,
           vlcex = 1.2,
           title = "(c)")  # Título superior
text(x = 0.7, y = 0.75, labels = expression(GDVI[AI] == "2.586"), xpd = TRUE, cex = 0.9, col = "blue", font = 2, pos = 1)
text(x = 0.11, y = 0.3, labels = vals3[["Toxicity"]], xpd = TRUE, cex = 1.0, col = "black", font = 1, pos = 1)
text(x = -0.81, y = 0.13, labels = vals3[["Feeling"]], xpd = TRUE, cex = 1.0, col = "black", font = 1, pos = 1)
text(x = 0.27, y = 0.13, labels = vals3[["Insult"]], xpd = TRUE, cex = 1.0, col = "black", font = 1, pos = 1)
text(x = 0.05, y = -0.6, labels = vals3[["Violence"]], xpd = TRUE, cex = 1.0, col = "black", font = 1, pos = 1)

# Radar chart for vals4 (Bottom-right)
radarchart(prepare_radar_data(vals4),
           axistype = 1,
           pcol = rgb(255/255, 152/255, 0/255, 0.9),
           pfcol = rgb(255/255, 152/255, 0/255, 0.3),
           plwd = 2,
           cglcol = "grey",
           cglty = 1,
           axislabcol = "blue",
           caxislabels = seq(0, 10, 2.5),
           cglwd = 0.8,
           vlcex = 1.2,
           title = "(d)")  # Título superior
text(x = 0.7, y = 0.75, labels = expression(GDVI[AI] == "2.227"), xpd = TRUE, cex = 0.9, col = "blue", font = 2, pos = 1)
text(x = 0.1, y = 0.3, labels = vals4[["Toxicity"]], xpd = TRUE, cex = 1.0, col = "black", font = 1, pos = 1)
text(x = -0.6, y = 0.13, labels = vals4[["Feeling"]], xpd = TRUE, cex = 1.0, col = "black", font = 1, pos = 1)
text(x = 0.25, y = 0.13, labels = vals4[["Insult"]], xpd = TRUE, cex = 1.0, col = "black", font = 1, pos = 1)
text(x = 0.05, y = -0.6, labels = vals4[["Violence"]], xpd = TRUE, cex = 1.0, col = "black", font = 1, pos = 1)