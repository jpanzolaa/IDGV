library(fmsb)

set.seed(1)

# Crear el data frame con los valores
df1 <- data.frame(
  Toxicity = c(10, 0, 9),
  Feeling = c(10, 0, 3.003),
  Violence = c(10, 0, 2.0),
  Insult = c(10, 0, 0.555)
)

# Asignar nombres a las filas
rownames(df1) <- c("Max", "Min", "Value")

# Graficar el radar
radarchart(df1,
           cglty = 1, cglcol = "gray",
           pcol = 4, plwd = 2,
           pfcol = rgb(0, 0.4, 1, 0.25),
           title = "False Positive")

# Agregar texto en el gráfico
text(x = 0.5, y = 1.1, labels = "esta es una puta victoria.", cex = 0.9, col = "red")
