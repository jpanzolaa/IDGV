library(ggplot2)
library(tibble)
library(dplyr)
library(scales)
library(cowplot)  # Para crear insets

# Datos
df <- tribble(
  ~Hora,        ~Sujeto,        ~Indice,
  "8:10 a. m.", "Perpetrator",   0.727,
  "8:15 a. m.", "Survivor",      0.051,
  "9:05 a. m.", "Perpetrator",   0.050,
  "9:20 a. m.", "Survivor",      0.119,
  "10:10 a. m.","Perpetrator",   1.163,
  "10:25 a. m.","Survivor",      0.050,
  "11:45 a. m.","Perpetrator",   0.730,
  "12:00 p. m.","Survivor",      0.796,
  "1:15 p. m.", "Perpetrator",   0.730,
  "2:30 p. m.", "Survivor",      0.050,
  "3:10 p. m.", "Perpetrator",   0.730,
  "4:00 p. m.", "Survivor",      1.396,
  "4:30 p. m.", "Perpetrator",   0.176,
  "5:15 p. m.", "Survivor",      0.730,
  "5:40 p. m.", "Perpetrator",   0.736,
  "6:22 p. m.", "Survivor",      0.730,
  "6:41 p. m.", "Perpetrator",   0.724,
  "6:55 p. m.", "Perpetrator",   1.396,
  "7:10 p. m.", "Survivor",      0.724,
  "7:25 p. m.", "Perpetrator",   0.736,
  "7:40 p. m.", "Survivor",      0.730,
  "7:55 p. m.", "Perpetrator",   0.729,
  "8:13 p. m.", "Survivor",      0.726,
  "8:31 p. m.", "Perpetrator",   0.730,
  "8:44 p. m.", "Perpetrator",   1.398,
  "9:01 p. m.", "Perpetrator",   1.398,
  "9:13 p. m.", "Perpetrator",   1.397,
  "9:21 p. m.", "Perpetrator",   0.728,
  "9:30 p. m.", "Survivor",      1.158,
  "9:31 p. m.", "Perpetrator",   7.516,
  "9:40 p. m.", "Perpetrator",   0.730,
  "9:41 p. m.", "Perpetrator",   0.730,
  "9:42 p. m.", "Perpetrator",   0.051,
  "9:56 p. m.", "Survivor",      0.728,
  "9:57 p. m.", "Perpetrator",   2.977,
  "10:10 p. m.","Survivor",      0.728,
  "10:11 p. m.","Perpetrator",   7.523,
  "10:15 p. m.","Survivor",      0.727,
  "10:17 p. m.","Perpetrator",   8.521
)

# Procesamiento de datos
df <- df %>%
  mutate(
    Hora = gsub("a\\. m\\.", "AM", Hora),
    Hora = gsub("p\\. m\\.", "PM", Hora),
    Hora = factor(Hora, levels = unique(Hora)),
    Sujeto = factor(Sujeto)
  )

# Crear etiquetas espaciadas
niveles <- levels(df$Hora)
etiquetas <- ifelse(seq_along(niveles) %% 4 == 3, niveles, "")

# Crear el diagrama de cajas para el inset CON LÍNEA PUNTEADA
boxplot_inset <- ggplot(df, aes(x = Sujeto, y = Indice, fill = Sujeto)) +
  geom_boxplot(alpha = 0.8, outlier.size = 2) +
  # Línea punteada verde horizontal en y = 2 - DIBUJADA SOBRE LAS BARRAS
  geom_hline(yintercept = 2, color = "green", linetype = "dashed", linewidth = 0.8) +
  geom_hline(yintercept = 4.0, color = "yellow", linetype = "dashed", linewidth = 0.8) +
  geom_hline(yintercept = 6.0, color = "orange", linetype = "dashed", linewidth = 0.8) +
  geom_hline(yintercept = 7.5, color = "red", linetype = "dashed", linewidth = 0.8) +
  scale_fill_manual(values = c("Perpetrator" = "#F8766D", "Survivor" = "#00BFC4")) +
  labs(x = NULL, y = NULL) +
  theme_minimal(base_size = 9) +
  theme(
    legend.position = "none",
    axis.text.x = element_text(angle = 0, hjust = 0.5, color = "blue", size = 12),  # Azul y tamaño 10
    axis.text.y = element_text(color = "blue", size = 12),  # Azul y tamaño 10
    panel.background = element_rect(fill = "#F8F8FF", color = "black", linewidth = 0.5),
    plot.background = element_rect(fill = "white", color = "white", linewidth = 0.5),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    plot.margin = margin(2, 2, 2, 2, "pt")
  ) +
  scale_y_continuous(limits = c(0, 9))

# Gráfico principal SIN grilla CON LÍNEA VERDE en y=2 (SOBRE las barras)
main_plot <- ggplot(df, aes(x = Hora, y = Indice, fill = Sujeto)) +
  geom_col(position = "dodge", width = 0.7, alpha = 0.8) +
  # Línea punteada verde horizontal en y = 2 - DIBUJADA SOBRE LAS BARRAS
  geom_hline(yintercept = 2, color = "green", linetype = "dashed", linewidth = 1.0) +
  geom_hline(yintercept = 4.0, color = "yellow", linetype = "dashed", linewidth = 1.0) +
  geom_hline(yintercept = 6.0, color = "orange", linetype = "dashed", linewidth = 1.0) +
  geom_hline(yintercept = 7.5, color = "red", linetype = "dashed", linewidth = 1.0) +
  labs(
    title = "",
    subtitle = "",
    x = "Hour",
    y = expression("GDVI"["AI"])
  ) +
  theme_minimal(base_family = "Arial") +
  theme(
    axis.text.x = element_text(angle = 0, hjust = 1, vjust = 1, size = 12, color = "blue"),  # Azul
    axis.text.y = element_text(color = "blue", size = 12),  # Azul y tamaño 10
    axis.title.x = element_text(color = "black", size = 12),  # Título del eje X en negro
    axis.title.y = element_text(color = "black", size = 12),  # Título del eje Y en negro
    plot.title = element_text(hjust = 0.5, face = "bold", size = 14, margin = margin(b = 5)),
    plot.subtitle = element_text(hjust = 0.5, size = 10, margin = margin(b = 15)),
    legend.position = "none",
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    plot.margin = margin(1, 1, 1, 1, "cm")
  ) +
  scale_x_discrete(labels = etiquetas) +
  scale_fill_manual(
    values = c("Perpetrator" = "#F8766D", "Survivor" = "#00BFC4"),
    labels = c("Perpetrator" = "Perpetrador", "Survivor" = "Superviviente")
  ) +
  scale_y_continuous(
    expand = expansion(mult = c(0, 0.05)),
    breaks = pretty_breaks(n = 10),
    limits = c(0, 9)
  )

# Crear leyenda flotante por separado (versión optimizada)
legend_plot <- ggplot(data.frame(Sujeto = c("Perpetrator", "Survivor"), 
                                 Indice = c(1, 1)), 
                      aes(x = Sujeto, y = Indice, fill = Sujeto)) +
  geom_col() +
  scale_fill_manual(
    values = c("Perpetrator" = "#F8766D", "Survivor" = "#00BFC4"),
    labels = c("Perpetrator" = "Perpetrator", "Survivor" = "Survivor"),
    name = ""
  ) +
  theme_void() +
  theme(
    legend.position = "bottom",
    legend.direction = "horizontal",
    legend.text = element_text(size = 12, margin = margin(r = 15)),
    legend.title = element_text(size = 11, face = "bold", margin = margin(r = 20)),
    legend.key.size = unit(0.45, "cm"),
    legend.key.height = unit(0.45, "cm"),
    legend.key.width = unit(0.45, "cm"),
    legend.spacing.x = unit(0.5, "cm"),
    legend.background = element_rect(fill = "white", color = "white", linewidth = 0.3),
    legend.margin = margin(5, 10, 5, 10)
  )

# Extraer la leyenda
legend <- get_legend(legend_plot)

# Añadir el inset y la leyenda al gráfico principal
final_plot <- ggdraw(main_plot) +
  draw_plot(
    boxplot_inset,
    x = 0.15,
    y = 0.28,
    width = 0.3, 
    height = 0.4
  ) +
  draw_plot(
    legend,
    x = 0.45,
    y = 0.7,
    width = 0.2,
    height = 0.2
  )

print(final_plot)