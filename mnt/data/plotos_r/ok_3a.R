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
# Esta línea es la clave para evitar el error.
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
  mutate(Type = "(a) No Toxic")

df_toxic_long <- df_Toxic %>%
  pivot_longer(
    cols = all_of(variables_grafico),
    names_to = "Variable",
    values_to = "Value"
  ) %>%
  mutate(Variable = factor(Variable, levels = variables_grafico)) %>%
  mutate(Type = "(b) Toxic")

df_combined <- bind_rows(df_no_toxic_long, df_toxic_long)

# 5. Crear el gráfico único con facetado y puntos de datos
combined_plot <- ggplot(df_combined, aes(x = Variable, y = Value, fill = Type)) +
  geom_boxplot(alpha = 0.8, outlier.shape = NA) +
  geom_jitter(
    aes(color = Type),
    width = 0.2,
    alpha = 0.4,
    shape = 16
  ) +
  labs(
    title = "Comparison of Non-Toxic vs. Toxic Comments",
    y = "Score",
    x = "",
    fill = "Comment Type",
    color = "Comment Type"
  ) +
  facet_wrap(~ Type, scales = "free_x") +
  scale_fill_manual(values = c("Non-Toxic" = "green", "Toxic" = rgb(244/255, 67/255, 54/255, 1.0))) +
  scale_color_manual(values = c("Non-Toxic" = "darkgreen", "Toxic" = "brown")) +
  theme_bw() +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"),
    legend.position = "bottom",
    axis.text.x = element_text(angle = 45, hjust = 1),
    strip.background = element_rect(fill = "gray90"),
    strip.text = element_text(face = "bold")
  )

# 6. Mostrar el gráfico final
print(combined_plot)

# --- Sección de Tabla de Medidas Estadísticas ---

# 7. Definir las variables para el cálculo de estadísticas
orden_variables_no_toxic <- c("Feeling", "Toxicity", "Insult", "Violence", "GDNI")
orden_variables_toxic <- c("Feeling", "Toxicity", "Insult", "Violence", "GDVI")

# 8. Calcular las estadísticas para df_No_Toxic
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

# 9. Calcular las estadísticas para df_Toxic
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

# 10. Combinar las dos tablas en una sola
tabla_final <- bind_rows(stats_no_toxic, stats_toxic) %>%
  select(Tipo, everything())

# 11. Transponer la tabla para un formato más legible
tabla_final_transpuesta <- t(tabla_final)
colnames(tabla_final_transpuesta) <- tabla_final_transpuesta[1, ]
tabla_final_transpuesta <- as.data.frame(tabla_final_transpuesta[-1, ])

# 12. Imprimir la tabla final
print(tabla_final_transpuesta)