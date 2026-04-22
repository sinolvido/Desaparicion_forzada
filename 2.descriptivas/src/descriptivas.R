require(pacman)
p_load(reticulate,stringi, argparse, here, tidyverse, readxl, dplyr, qdapTools, ggplot2, openxlsx, foreign, haven, magrittr)

parser <- ArgumentParser()
parser$add_argument("--anios",
                    default = here("/Users/mac/Desktop/sin_olvido/2026/desaparicion_forzada/1.import/output/yy_hecho.xlsx"))
parser$add_argument("--anios_g",
                    default = here("/Users/mac/Desktop/sin_olvido/2026/desaparicion_forzada/2.descriptivas/output/yy_hecho.png"))
parser$add_argument("--responsables",
                    default = here("/Users/mac/Desktop/sin_olvido/2026/desaparicion_forzada/1.import/output/responsables.xlsx"))
parser$add_argument("--responsables1",
                    default = here("/Users/mac/Desktop/sin_olvido/2026/desaparicion_forzada/2.descriptivas/output/responsables.png"))
parser$add_argument("--etnias",
                    default = here("/Users/mac/Desktop/sin_olvido/2026/desaparicion_forzada/1.import/output/etnias.xlsx"))
args <- parser$parse_args()


anios<-read.xlsx(args$anios)


anios_long <- anios %>%
  select(yy_hecho, imp_mean) %>%
  pivot_longer(cols = c(imp_mean), names_to = "Categoria", values_to = "Valor")


# Crear dataset solo con el último valor de cada serie
ultimos_valores <- anios_long %>%
  group_by(Valor) %>%
  filter(yy_hecho == max(yy_hecho)) %>%
  ungroup()

anios_long$yy_hecho <-(anios_long$yy_hecho)

breaks_x <- sort(unique(anios_long$yy_hecho))
breaks_x <- breaks_x[seq(1, length(breaks_x), 5)]

ggplot(anios_long, aes(x = yy_hecho, y = Valor, 
                        group = 1)) +
  
  geom_line(linewidth = 1) +
  
  # Línea horizontal en 0
  geom_hline(yintercept = 0, color = "black", linewidth = 0.1) +
  
  # Etiquetas al final de cada línea
  
  scale_y_continuous(name = "Víctimas") +
  
  scale_x_continuous(
    name = "Año",
    breaks = breaks_x,
    expand = expansion(mult = c(0.01, 0.1)) # espacio a la derecha para etiquetas
  ) +
  
  scale_color_manual(
    name = "Serie",
    values = c(
      "Valor" = "green"
    ),
    labels = c(
      "Valor" = "Desapariciones forzadas"
    )
  ) +
  
  scale_linetype_manual(
    name = "Serie",
    values = c(
      "Valor" = "solid"
    ),
    labels = c(
      "Valor" = "Desapariciones forzadas"
    )
  ) +
  
  theme_minimal() +
  theme(
    axis.text.x = element_text(size = 14),
    axis.text.y = element_text(size = 14),
    axis.title.x = element_text(size = 18),
    axis.title.y = element_text(size = 18)
  ) +
  theme(
    panel.grid = element_blank(),     # quita todo el fondo
    axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1),
    legend.position = "bottom"
  )
ggsave(args$anios_g, width = 6, height = 4, dpi = 300, bg = "white")

## responsables


responsables <-read.xlsx(args$responsables)

responsables <- responsables %>%
  select(p_str, imp_mean) %>%
  filter(!is.na(p_str))

responsables <- responsables %>%
  mutate(porc = imp_mean / sum(imp_mean) * 100,
         etiqueta = paste0(round(porc, 1), "%"))

responsables <- responsables %>%
  mutate(
    p_str = case_when(
      p_str == "PARA" ~ "PARAMILITAR",
      p_str == "GUE-FARC" ~ "FARC",
      p_str == "multiple" ~ "MULTIPLE",
      p_str == "EST" ~ "ESTADO",
      p_str == "OTRO" ~ "OTRO",
      p_str == "GUE-ELN" ~ "ELN",
      p_str == "GUE-OTRO" ~ "OTRO",
      TRUE ~ NA_character_
    )
  )


responsables <- responsables %>%
  rename(RESPONSABLES=p_str)

  


ggplot(responsables, aes(x = "", y = imp_mean, fill = RESPONSABLES)) +
  
  geom_col(width = 1) +
  
  coord_polar(theta = "y") +
  
  geom_text(aes(label = etiqueta),
            position = position_stack(vjust = 0.5),
            color = "white",
            size = 4) +
  
  scale_fill_brewer(palette = "Oranges") +
  
  theme_void()
ggsave(args$responsables1, width = 6, height = 4, dpi = 300, bg = "white")
