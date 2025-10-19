# Instalar el paquete fmsb si aún no lo has hecho
# install.packages("fmsb")

# Cargar la librería
library(fmsb)

# --- Definir todos los datos ---
vals1 <- c(Toxicity = 9.0, Feeling = 3.003, Violence = 2.00, Insult = 0.555)
vals1a <- c(Toxicity = 0.09, Feeling = 4.53, Violence = 0.01, Insult = 0.01)

vals2 <- c(Toxicity = 0.09, Feeling = 4.545, Violence = 9.00, Insult = 0.01)
vals2a <- c(Toxicity = 9.0, Feeling = 0.437, Violence = 6.00, Insult = 1.733)

vals3 <- c(Toxicity = 0.09, Feeling = 6.935, Violence = 6.00, Insult = 0.01)
vals3a <- c(Toxicity = 9.00, Feeling = 4.545, Violence = 9.00, Insult = 0.01)

# --- Preparar los data frames para cada gráfico ---
# Para el Gráfico 1 (vals1 vs vals1a)
df1_vals <- rbind(vals1, vals1a)
max1 <- apply(df1_vals, 2, max) * 1.1
min1 <- apply(df1_vals, 2, min) * 0.9
df_plot1 <- data.frame(rbind(max1, min1, df1_vals))
rownames(df_plot1) <- c("max", "min", "vals1", "vals1a")

# Para el Gráfico 2 (vals2 vs vals2a)
df2_vals <- rbind(vals2, vals2a)
max2 <- apply(df2_vals, 2, max) * 1.1
min2 <- apply(df2_vals, 2, min) * 0.9
df_plot2 <- data.frame(rbind(max2, min2, df2_vals))
rownames(df_plot2) <- c("max", "min", "vals2", "vals2a")

# Para el Gráfico 3 (vals3 vs vals3a)
df3_vals <- rbind(vals3, vals3a)
max3 <- apply(df3_vals, 2, max) * 1.1
min3 <- apply(df3_vals, 2, min) * 0.9
df_plot3 <- data.frame(rbind(max3, min3, df3_vals))
rownames(df_plot3) <- c("max", "min", "vals3", "vals3a")

# --- Configurar el diseño de los gráficos y generar la figura ---
# Usa par() para crear un panel de 1 fila y 3 columnas para los subgráficos
par(mfrow = c(1, 3), oma = c(0, 0, 2, 0), mar = c(2, 2, 2, 1))

# Colores y estilo
line_colors <- c("red", "green")
area_colors <- c(rgb(1, 0, 0, 0.25), rgb(0, 0, 1, 0.25))

# Gráfico 1: vals1 vs vals1a
radarchart(df_plot1,
           cglty = 1,
           cglcol = "gray",
           pcol = line_colors,
           plwd = 2,
           plty = 1,
           pfcol = area_colors,
           title = "(a)",
           vlcex = 1.5)

# Gráfico 2: vals2 vs vals2a
radarchart(df_plot2,
           cglty = 1,
           cglcol = "gray",
           pcol = line_colors,
           plwd = 2,
           plty = 1,
           pfcol = area_colors,
           title = "(b)",
           vlcex = 1.5)

# Gráfico 3: vals3 vs vals3a
radarchart(df_plot3,
           cglty = 1,
           cglcol = "gray",
           pcol = line_colors,
           plwd = 2,
           plty = 1,
           pfcol = area_colors,
           title = "(c)",
           vlcex = 1.5)
legend(x = "topright",
       legend = c("vals3", "vals3a"),
       bty = "n",
       pch = 20,
       col = line_colors,
       text.col = "black",
       cex = 1,
       pt.cex = 1.5)

# Agregar un título principal a toda la figura
mtext("Comparación de Múltiples Conjuntos de Datos", outer = TRUE, cex = 1.5)