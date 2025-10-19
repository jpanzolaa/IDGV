# Install ggplot2 if not already installed
if (!require(ggplot2)) {
  install.packages("ggplot2")
}

# Load ggplot2 library
library(ggplot2)
library(fmsb)

# --- Definir todos los datos ---
vals1 <- c(T = 9.0, F = 3.003, V = 2.00, I = 0.556)
vals1a <- c(T = 0.09, F = 4.53, V = 0.01, I = 0.01)

vals2 <- c(T = 0.09, F = 4.545, V = 9.00, I = 0.01)
vals2a <- c(T = 9.0, F = 0.437, V = 6.00, I = 1.733)

vals3 <- c(T = 0.09, F = 6.935, V = 6.00, I = 0.01)
vals3a <- c(T = 9.00, F = 4.545, V = 9.00, I = 0.01)

# --- Preparar los data frames para cada gráfico ---
# Para el Gráfico 1 (vals1 vs vals1a)
max_fixed <- rep(10, 4)  # Máximo fijo en 10
min_fixed <- rep(0, 4)   # Mínimo fijo en 0
names(max_fixed) <- names(min_fixed) <- c("T", "F", "V", "I")

df_plot1 <- data.frame(rbind(max_fixed, min_fixed, vals1, vals1a))
rownames(df_plot1) <- c("max", "min", "vals1", "vals1a")

# Para el Gráfico 2 (vals2 vs vals2a)
df_plot2 <- data.frame(rbind(max_fixed, min_fixed, vals2, vals2a))
rownames(df_plot2) <- c("max", "min", "vals2", "vals2a")

# Para el Gráfico 3 (vals3 vs vals3a)
df_plot3 <- data.frame(rbind(max_fixed, min_fixed, vals3, vals3a))
rownames(df_plot3) <- c("max", "min", "vals3", "vals3a")

# --- Configurar el diseño de los gráficos y generar la figura ---
par(mfrow = c(1, 3), oma = c(4, 0, 2, 0), mar = c(2, 2, 2, 1), xpd = TRUE)

# Colores y estilo
line_colors <- c("red", "green")
area_colors <- c(rgb(1, 0, 0, 0.25), rgb(0, 1, 0, 0.25))


# Gráfico 1: vals1 vs vals1a
radarchart(df_plot1,
           axistype = 1,
           cglty = 1,
           cglcol = "gray",
           pcol = line_colors,
           plwd = 2,
           plty = 1,
           pfcol = area_colors,
           title = "(a)",
           vlcex = 1.5,
           axislabcol = "blue",
           caxislabels = seq(0, 10, 2.5),
           cglwd = 0.8)
legend(x = 0.8, y = 1.3,
       legend = c("FP", "TN"),
       bty = "n",
       pch = 15,
       col = line_colors,
       text.col = "black",
       cex = 1.2,
       pt.cex = 1.8)
text(x = -0.75, y = 0.9, labels = expression(GDVI[AI] == "5.506"), xpd = TRUE, cex = 1.3, col = "red", font = 2, pos = 1)
text(x = -0.75, y = 0.75, labels = expression(GDVI[AI] == "0.728"), xpd = TRUE, cex = 1.3, col = "darkgreen", font = 2, pos = 1)

text(x = 0.07, y = 1.05, labels = vals1[["T"]], xpd = TRUE, cex = 1.3, col = "red", font = 1, pos = 1)
text(x = 0.45, y = 0.15, labels = vals1[["I"]], xpd = TRUE, cex = 1.3, col = "red", font = 1, pos = 1)
text(x = 0.075, y = -0.31, labels = vals1[["V"]], xpd = TRUE, cex = 1.3, col = "red", font = 1, pos = 1)
text(x = -0.6, y = 0.18, labels = vals1[["F"]], xpd = TRUE, cex = 1.3, col = "red", font = 1, pos = 1)

text(x = 0.16, y = 0.3, labels = vals1a[["T"]], xpd = TRUE, cex = 1.3, col = "darkgreen", font = 1, pos = 1)
text(x = 0.3, y = 0.03, labels = vals1a[["I"]], xpd = TRUE, cex = 1.3, col = "darkgreen", font = 1, pos = 1)
text(x = 0.13, y = -0.13, labels = vals1a[["V"]], xpd = TRUE, cex = 1.3, col = "darkgreen", font = 1, pos = 1)
text(x = -0.6, y = 0.02, labels = vals1a[["F"]], xpd = TRUE, cex = 1.3, col = "darkgreen", font = 1, pos = 1)

# Gráfico 2: vals2 vs vals2a
radarchart(df_plot2,
           axistype = 1,
           cglty = 1,
           cglcol = "gray",
           pcol = line_colors,
           plwd = 2,
           plty = 1,
           pfcol = area_colors,
           title = "(b)",
           vlcex = 1.5,
           axislabcol = "blue",
           caxislabels = seq(0, 10, 2.5),
           cglwd = 0.8)
legend(x = 0.8, y = 1.3,
       legend = c("FN", "TP"),
       bty = "n",
       pch = 15,
       col = line_colors,
       text.col = "black",
       cex = 1.2,
       pt.cex = 1.8)
par(xpd = TRUE)
text(x = 0, y = -1.4, labels = "T: Toxicity  F: Feeling  V: Violence  I: Insult", adj = c(0.5, 0), cex = 1.5,col = "grey20")

text(x = -0.75, y = 0.9, labels = expression(GDVI[AI] == "2.978"), xpd = TRUE, cex = 1.3, col = "red", font = 2, pos = 1)
text(x = -0.75, y = 0.75, labels = expression(GDVI[AI] == "6.239"), xpd = TRUE, cex = 1.3, col = "darkgreen", font = 2, pos = 1)

text(x = 0.15, y = 0.35, labels = vals2[["T"]], xpd = TRUE, cex = 1.3, col = "red", font = 1, pos = 1)
text(x = 0.3, y = 0.18, labels = vals2[["I"]], xpd = TRUE, cex = 1.3, col = "red", font = 1, pos = 1)
text(x = 0.075, y = -0.83, labels = vals2[["V"]], xpd = TRUE, cex = 1.3, col = "red", font = 1, pos = 1)
text(x = -0.6, y = 0.18, labels = vals2[["F"]], xpd = TRUE, cex = 1.3, col = "red", font = 1, pos = 1)

text(x = 0.075, y = 1.025, labels = vals2a[["T"]], xpd = TRUE, cex = 1.3, col = "darkgreen", font = 1, pos = 1)
text(x = 0.4, y = 0.025, labels = vals2a[["I"]], xpd = TRUE, cex = 1.3, col = "darkgreen", font = 1, pos = 1)
text(x = -0.07, y = -0.57, labels = vals2a[["V"]], xpd = TRUE, cex = 1.3, col = "darkgreen", font = 1, pos = 1)
text(x = -0.2, y = 0.02, labels = vals2a[["F"]], xpd = TRUE, cex = 1.3, col = "darkgreen", font = 1, pos = 1)

# Gráfico 3: vals3 vs vals3a
radarchart(df_plot3,
           axistype = 1,
           cglty = 1,
           cglcol = "gray",
           pcol = line_colors,
           plwd = 2,
           plty = 1,
           pfcol = area_colors,
           title = "(c)",
           vlcex = 1.5,
           axislabcol = "blue",
           caxislabels = seq(0, 10, 2.5),
           cglwd = 0.8)
legend(x = 0.8, y = 1.3,
       legend = c("FN", "TP"),
       bty = "n",
       pch = 15,
       col = line_colors,
       text.col = "black",
       cex = 1.2,
       pt.cex = 1.8)

text(x = -0.75, y = 0.9, labels = expression(GDVI[AI] == "2.586"), xpd = TRUE, cex = 1.3, col = "red", font = 2, pos = 1)
text(x = -0.75, y = 0.75, labels = expression(GDVI[AI] == "7.433"), xpd = TRUE, cex = 1.3, col = "darkgreen", font = 2, pos = 1)

text(x = 0.15, y = 0.35, labels = vals3[["T"]], xpd = TRUE, cex = 1.3, col = "red", font = 1, pos = 1)
text(x = 0.3, y = 0.18, labels = vals3[["I"]], xpd = TRUE, cex = 1.3, col = "red", font = 1, pos = 1)
text(x = 0.075, y = -0.57, labels = vals3[["V"]], xpd = TRUE, cex = 1.3, col = "red", font = 1, pos = 1)
text(x = -0.8, y = 0.18, labels = vals3[["F"]], xpd = TRUE, cex = 1.3, col = "red", font = 1, pos = 1)

text(x = 0.075, y = 1.025, labels = vals3a[["T"]], xpd = TRUE, cex = 1.3, col = "darkgreen", font = 1, pos = 1)
text(x = 0.33, y = 0.025, labels = vals3a[["I"]], xpd = TRUE, cex = 1.3, col = "darkgreen", font = 1, pos = 1)
text(x = 0.075, y = -0.8, labels = vals3a[["V"]], xpd = TRUE, cex = 1.3, col = "darkgreen", font = 1, pos = 1)
text(x = -0.47, y = 0.02, labels = vals3a[["F"]], xpd = TRUE, cex = 1.3, col = "darkgreen", font = 1, pos = 1)

# Agregar un título principal a toda la figura
mtext("", outer = TRUE, cex = 1.5)

# Después de que la gráfica se muestre correctamente en RStudio:
dev.copy(png, "Fig04a.png", width = 900, height = 400, res = 100)
dev.off()
