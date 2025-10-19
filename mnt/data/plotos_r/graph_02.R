# Paquetes
library(ggplot2)
library(dplyr)
library(tibble)
library(patchwork)

# ====== Datos ======
vals1 <- c(Toxicity = 9.0,  Feeling = 3.003, Violence = 2.00, Insult = 0.555)
vals2 <- c(Toxicity = 0.09, Feeling = 4.545, Violence = 9.00, Insult = 0.01)
vals3 <- c(Toxicity = 0.09, Feeling = 6.935, Violence = 6.00, Insult = 0.01)
vals4 <- c(Toxicity = 0.09, Feeling = 4.543, Violence = 6.00, Insult = 0.01)

# ====== Función para polígono recto ======
radar_recto <- function(vec, title, fill_col = "#377EB8") {
  var_levels <- names(vec)
  
  # Creamos un data frame con coordenadas para cada vértice
  df <- enframe(vec, name = "variable", value = "value") %>%
    mutate(
      variable = factor(variable, levels = var_levels),
      value = pmin(pmax(as.numeric(value), 0), 10)
    )
  
  # Asignar ángulo y convertir a coordenadas cartesianas
  n_vars <- nrow(df)
  angles <- seq(0, 2*pi, length.out = n_vars + 1)[- (n_vars + 1)]
  coords <- tibble(
    x = df$value * cos(angles),
    y = df$value * sin(angles),
    label = df$value,
    var = df$variable
  )
  coords <- bind_rows(coords, coords[1, ])  # cerrar polígono
  
  # Polígono recto
  ggplot(coords, aes(x, y)) +
    geom_polygon(fill = scales::alpha(fill_col, 0.25), color = fill_col, linewidth = 1) +
    geom_point(size = 2.5, color = fill_col) +
    geom_text(aes(label = round(label, 2)), vjust = -0.5, size = 3) +
    # Líneas radiales y círculos guía
    geom_path(data = tibble(
      x = rep(seq(0, 10, by = 2), each = n_vars + 1) * cos(rep(c(angles, angles[1]), times = 6)),
      y = rep(seq(0, 10, by = 2), each = n_vars + 1) * sin(rep(c(angles, angles[1]), times = 6)),
      group = rep(1:6, each = n_vars + 1)
    ), aes(x, y, group = group), color = "grey80", linewidth = 0.3) +
    coord_equal() +
    theme_minimal(base_size = 12) +
    labs(title = title, x = NULL, y = NULL) +
    theme(
      axis.text = element_blank(),
      axis.ticks = element_blank(),
      panel.grid = element_blank(),
      plot.title = element_text(hjust = 0.5, face = "bold")
    )
}

# ====== Colores ======
cols <- c("#E41A1C", "#4DAF4A", "#377EB8", "#FF7F00")

# ====== Graficar 4 paneles ======
p1 <- radar_recto(vals1, "vals1", cols[1])
p2 <- radar_recto(vals2, "vals2", cols[2])
p3 <- radar_recto(vals3, "vals3", cols[3])
p4 <- radar_recto(vals4, "vals4", cols[4])

# ====== Combinar en 1x4 ======
p_final <- (p1 | p2 | p3 | p4) + plot_layout(nrow = 1)

print(p_final)

# Guardar
ggsave("radar_recto_4x1.png", plot = p_final, width = 16, height = 4.5, dpi = 300)
