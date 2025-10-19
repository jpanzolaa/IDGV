# 1. Cargar las librerías necesarias
suppressPackageStartupMessages(library(ggplot2))
suppressPackageStartupMessages(library(tidyr))
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(patchwork))
suppressPackageStartupMessages(library(ggthemes))
suppressPackageStartupMessages(library(psych))

# 2. Cargar los datos
load("df_data.RData")

# 3. Definir el orden de las variables para los gráficos
variables_grafico <- c("Feeling", "Toxicity", "Insult", "Violence")

# --- Sección de Gráficos ---

# 4. Preparar y combinar los data frames para el gráfico
df_no_toxic_long <- df_No_Toxic %>%
  pivot_longer(
    cols = all_of(variables_grafico),
    names_to = "Variable",
    values_to = "Value"
  ) %>%
  mutate(Variable = factor(Variable, levels = variables_grafico)) %>%
  mutate(Type = "No Toxic")

df_toxic_long <- df_Toxic %>%
  pivot_longer(
    cols = all_of(variables_grafico),
    names_to = "Variable",
    values_to = "Value"
  ) %>%
  mutate(Variable = factor(Variable, levels = variables_grafico)) %>%
  mutate(Type = "Toxic")

df_combined <- bind_rows(df_no_toxic_long, df_toxic_long)

# 5. Crear el gráfico único con facetado y puntos de datos
combined_plot <- ggplot(df_combined, aes(x = Variable, y = Value)) +
  geom_boxplot(aes(fill = Type), alpha = 0.8, outlier.shape = NA) +
  geom_jitter(
    aes(color = Type),
    width = 0.2,
    alpha = 0.4,
    shape = 16
  ) +
  labs(
    #title = "Comparison of Non-Toxic vs. Toxic Comments",
    y = "Score",
    x = ""
    #fill = "Comment Type",
    #color = "Comment Type"
  ) +
  facet_wrap(~ Type, scales = "free_x") +
  scale_fill_manual(values = c("No Toxic" = "green", "Toxic" = rgb(244/255, 67/255, 54/255, 1.0))) +
  scale_color_manual(values = c("No Toxic" = "darkgreen", "Toxic" = "brown")) +
  theme_bw() +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"),
    legend.position = "none",
    axis.text.x = element_text(),
    strip.background = element_blank(),
    strip.text = element_text(face = "plain")
  )

# 6. Mostrar el gráfico final
print(combined_plot)

### Saving the plot 💾
# Verifica si la carpeta existe y, si no, la crea
if (!dir.exists("0. Repositorio/img")) {
  dir.create("0. Repositorio/img", recursive = TRUE)
}

# Ahora puedes guardar los gráficos sin problemas
ggsave("0. Repositorio/img/Fig06.pdf", plot = combined_plot, width = 5, height = 3.5, units = "in")
ggsave("0. Repositorio/img/Fig06.png", plot = combined_plot, width = 5, height = 3.5, units = "in", dpi = 300)

# 7. Guardar el gráfico en PNG
# ggsave("Fig04.png", plot = combined_plot, width = 5, height = 3.5, dpi = 300)

# 8. Guardar el gráfico en PDF
# ggsave("Fig04.pdf", plot = combined_plot, width = 5, height = 3.5)

# --- Sección de Tabla de Medidas Estadísticas ---

# 9. Definir las variables para el cálculo de estadísticas
orden_variables_no_toxic <- c("Feeling", "Toxicity", "Insult", "Violence", "GDNI")
orden_variables_toxic <- c("Feeling", "Toxicity", "Insult", "Violence", "GDVI")

# 10. Calcular las estadísticas para df_No_Toxic
stats_no_toxic <- df_No_Toxic %>%
  summarise(
    n = n(),
    across(all_of(orden_variables_no_toxic), list(
      Media = ~ mean(., na.rm = TRUE),
      `Desviación estándar` = ~ sd(., na.rm = TRUE),
      Mediana = ~ median(., na.rm = TRUE),
      Mínimo = ~ min(., na.rm = TRUE),
      Máximo = ~ max(., na.rm = TRUE),
      Q1 = ~ quantile(., 0.25, na.rm = TRUE),
      Q3 = ~ quantile(., 0.75, na.rm = TRUE),
      IQR = ~ IQR(., na.rm = TRUE),
      Asimetría = ~ psych::skew(., na.rm = TRUE),
      Curtosis = ~ psych::kurtosi(., na.rm = TRUE)
    ))
  ) %>%
  mutate(Tipo = "No-Tóxico")

# 11. Calcular las estadísticas para df_Toxic
stats_toxic <- df_Toxic %>%
  summarise(
    n = n(),
    across(all_of(orden_variables_toxic), list(
      Media = ~ mean(., na.rm = TRUE),
      `Desviación estándar` = ~ sd(., na.rm = TRUE),
      Mediana = ~ median(., na.rm = TRUE),
      Mínimo = ~ min(., na.rm = TRUE),
      Máximo = ~ max(., na.rm = TRUE),
      Q1 = ~ quantile(., 0.25, na.rm = TRUE),
      Q3 = ~ quantile(., 0.75, na.rm = TRUE),
      IQR = ~ IQR(., na.rm = TRUE),
      Asimetría = ~ psych::skew(., na.rm = TRUE),
      Curtosis = ~ psych::kurtosi(., na.rm = TRUE)
    ))
  ) %>%
  mutate(Tipo = "Tóxico")

# 12. Combinar las dos tablas en una sola
tabla_final <- bind_rows(stats_no_toxic, stats_toxic) %>%
  select(Tipo, everything())

# 13. Transponer la tabla para un formato más legible
tabla_final_transpuesta <- t(tabla_final)
colnames(tabla_final_transpuesta) <- tabla_final_transpuesta[1, ]
tabla_final_transpuesta <- as.data.frame(tabla_final_transpuesta[-1, ])

# 14. Imprimir la tabla final
print(tabla_final_transpuesta)