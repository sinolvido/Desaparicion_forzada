pacman::p_load(verdata, argparse, dplyr, here, arrow, purrr, assertr, glue, stringr, 
               stringi, janitor, readr, future, writexl, tidyverse, readxl, openxlsx, scales)


parser <- ArgumentParser()
parser$add_argument("--replicas",
                    default = here("/Users/mac/Desktop/sin_olvido/bases/Desaparicion.csv"))
parser$add_argument("--anios",
                    default = here("/Users/mac/Desktop/sin_olvido/2026/desaparicion_forzada/1.import/output/yy_hecho.xlsx"))
parser$add_argument("--responsables",
                    default = here("/Users/mac/Desktop/sin_olvido/2026/desaparicion_forzada/1.import/output/responsables.xlsx"))
parser$add_argument("--etnias",
                    default = here("/Users/mac/Desktop/sin_olvido/2026/desaparicion_forzada/1.import/output/etnias.xlsx"))
args <- parser$parse_args()


replicas_datos <- verdata::read_replicates(replicates_dir = here::here(args$replicas),
                                           violation = "desaparicion",
                                           replicate_nums = c(1:10),
                                           version = "v1")

tabla_documentada <- verdata::summary_observed("desaparicion",
                                               replicas_datos, 
                                               strata_vars = "yy_hecho",
                                               conflict_filter = TRUE,
                                               forced_dis_filter = FALSE,
                                               edad_minors_filter = TRUE,
                                               include_props = TRUE)

tabla_combinada <- verdata::combine_replicates("desaparicion",
                                               tabla_documentada,
                                               replicas_datos, 
                                               strata_vars = "yy_hecho",
                                               conflict_filter = TRUE,
                                               forced_dis_filter = FALSE,
                                               edad_minors_filter = FALSE,
                                               include_props = FALSE)



write_xlsx(tabla_combinada, args$anios)

# responsables 

tabla_documentada <- verdata::summary_observed("desaparicion",
                                               replicas_datos, 
                                               strata_vars = "p_str",
                                               conflict_filter = TRUE,
                                               forced_dis_filter = FALSE,
                                               #edad_minors_filter = TRUE,
                                               include_props = TRUE)

tabla_combinada <- verdata::combine_replicates("desaparicion",
                                               tabla_documentada,
                                               replicas_datos, 
                                               strata_vars = "p_str",
                                               conflict_filter = TRUE,
                                               forced_dis_filter = FALSE,
                                               #edad_minors_filter = FALSE,
                                               include_props = FALSE)



write_xlsx(tabla_combinada, args$responsables)


# etnia

tabla_documentada <- verdata::summary_observed("desaparicion",
                                               replicas_datos, 
                                               strata_vars = "etnia",
                                               conflict_filter = TRUE,
                                               forced_dis_filter = FALSE,
                                               #edad_minors_filter = TRUE,
                                               include_props = TRUE)

tabla_combinada <- verdata::combine_replicates("desaparicion",
                                               tabla_documentada,
                                               replicas_datos, 
                                               strata_vars = "etnia",
                                               conflict_filter = TRUE,
                                               forced_dis_filter = FALSE,
                                               #edad_minors_filter = FALSE,
                                               include_props = FALSE)



write_xlsx(tabla_combinada, args$etnias)


