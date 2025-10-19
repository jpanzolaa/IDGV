# 1. Cargar las librerías necesarias
# Asegúrate de tenerlas instaladas si no lo están:
# install.packages(c("ggplot2", "tidyr", "dplyr", "patchwork", "ggthemes", "psych"))
suppressPackageStartupMessages(library(ggplot2))
suppressPackageStartupMessages(library(tidyr))
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(patchwork))
suppressPackageStartupMessages(library(ggthemes))
suppressPackageStartupMessages(library(psych))

# 2. Cargar los datos
# Asegúrate de que el archivo 'df_data.RData' esté en tu directorio de trabajo
load("df_data.RData")

# 3. Definir el orden de las variables para los gráficos y las tablas
orden_variables_no_toxic <- c("Feeling", "Toxicity", "Insult", "Violence", "GDNI")
orden_variables_toxic <- c("Feeling", "Toxicity", "Insult", "Violence", "GDVI")

# --- Sección de Gráficos ---

# 4. Preparar y combinar los data frames para el gráfico
df_no_toxic_long <- df_No_Toxic %>%
  pivot_longer(
    cols = all_of(orden_variables_no_toxic),
    names_to = "Variable",
    values_to = "Value"
  ) %>%
  mutate(Variable = factor(Variable, levels = orden_variables_no_toxic)) %>%
  mutate(Type = "Non-Toxic")

df_toxic_long <- df_Toxic %>%
  pivot_longer(
    cols = all_of(orden_variables_toxic),
    names_to = "Variable",
    values_to = "Value"
  ) %>%
  mutate(Variable = factor(Variable, levels = orden_variables_toxic)) %>%
  mutate(Type = "Toxic")

df_combined <- bind_rows(df_no_toxic_long, df_toxic_long)

# 5. Crear el gráfico único con facetado
combined_plot <- ggplot(df_combined, aes(x = Variable, y = Value, fill = Type)) +
  geom_boxplot(alpha = 0.8) +
  labs(
    title = "Comparison of Non-Toxic vs. Toxic Comments",
    y = "Score",
    x = "",
    fill = "Comment Type"
  ) +
  facet_wrap(~ Type, scales = "free_x") +
  scale_fill_manual(values = c("Non-Toxic" = "green", "Toxic" = rgb(244/255, 67/255, 54/255, 1.0))) +
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

# 7. Calcular las estadísticas para df_No_Toxic
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

# 8. Calcular las estadísticas para df_Toxic
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

# 9. Combinar las dos tablas en una sola
tabla_final <- bind_rows(stats_no_toxic, stats_toxic) %>%
  select(Tipo, everything())

# 10. Transponer la tabla para un formato más legible
tabla_final_transpuesta <- t(tabla_final)
colnames(tabla_final_transpuesta) <- tabla_final_transpuesta[1, ]
tabla_final_transpuesta <- as.data.frame(tabla_final_transpuesta[-1, ])

# 11. Imprimir la tabla final
print(tabla_final_transpuesta)