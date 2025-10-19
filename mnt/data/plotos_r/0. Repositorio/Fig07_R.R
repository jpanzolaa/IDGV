# 1. Cargar las librerías necesarias
suppressPackageStartupMessages(library(ggplot2))
suppressPackageStartupMessages(library(tidyr))
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(patchwork))
suppressPackageStartupMessages(library(ggthemes))

# 2. Cargar los datos
load("df_data.RData")

# 3. Preparar los datos para el gráfico
df_no_toxic_gdni <- df_No_Toxic %>%
  select(GDNI) %>%
  mutate(Type = "(a) No Toxic", GDNI = as.numeric(GDNI))

df_toxic_gdvi <- df_Toxic %>%
  select(GDVI) %>%
  mutate(Type = "(b) Toxic", GDVI = as.numeric(GDVI))

df_toxic_gdvi <- df_toxic_gdvi %>% rename(GDNI = GDVI)

df_combined_gdni <- bind_rows(df_no_toxic_gdni, df_toxic_gdvi)

# 4. Encontrar la altura máxima para posicionar el boxplot
max_density <- df_combined_gdni %>%
  group_by(Type) %>%
  summarise(max_y = max(density(GDNI)$y)) %>%
  ungroup() %>%
  pull(max_y) %>%
  max()

# 5. Crear el gráfico combinado
gdni_plot <- ggplot(df_combined_gdni, aes(x = GDNI)) +
  # Capa de histograma
  geom_histogram(aes(y = after_stat(density), fill = Type),
                 bins = 30,
                 color = "black", alpha = 0.6) +
  scale_fill_manual(values = c("(a) No Toxic" = "green", "(b) Toxic" = rgb(244/255, 67/255, 54/255, 1.0))) +
  # Capa de densidad
  geom_density(aes(color = Type),
               lwd = 1.2) +
  scale_color_manual(values = c("(a) No Toxic" = rgb(0, 0.39, 0, 0.7), "(b) Toxic" = rgb(244/255, 67/255, 54/255, 0.7))) +
  # Capa de diagrama de cajas superpuesta
  geom_boxplot(aes(y = max_density * 0.75),
               fill = rgb(0, 1, 1, alpha = 0.15),
               alpha = 0.3,
               color = "black",
               lwd = 0.8,
               outlier.shape = 1,
               width = max_density * 0.5) +
  # Añadir puntos de datos
  geom_jitter(
    aes(y = max_density * 0.75, color = Type),
    width = 0.1,  # Controla el "ruido" horizontal
    alpha = 0.6,
    size = 1.5,
    shape = 16
  ) +
  # Etiquetado y títulos
  labs(
    #title = "Distribución de GDNI/GDVI",
    #subtitle = "Comparación de Densidad, Histograma y Boxplot por Tipo de Comentario",
    x = expression(GDVI[AI]~Score),
    y = "Density"
  ) +
  # Facetado para crear las dos subfiguras
  facet_wrap(~ Type, scales = "free_x") +
  # Tema profesional
  theme_bw() +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"),
    plot.subtitle = element_text(hjust = 0.5),
    legend.position = "none",
    strip.background = element_blank()
  )

# 6. Mostrar el gráfico
print(gdni_plot)

### Saving the plot 💾
# Verifica si la carpeta existe y, si no, la crea
if (!dir.exists("0. Repositorio/img")) {
  dir.create("0. Repositorio/img", recursive = TRUE)
}

# Ahora puedes guardar los gráficos sin problemas
ggsave("0. Repositorio/img/Fig07.pdf", plot = gdni_plot, width = 5, height = 3.5, units = "in")
ggsave("0. Repositorio/img/Fig07.png", plot = gdni_plot, width = 5, height = 3.5, units = "in", dpi = 300)
