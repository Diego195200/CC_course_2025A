library(dplyr)
library(tidyr)
library(tibble)
library(extraDistr)
library(ChainLadder)

siniestros <- read.csv('/var/home/diegob/Documents/Computer Science/project/Incendio_Siniestros.csv', fileEncoding = 'latin1')

# Selecting variables of interest for make the triangle
siniestros <- siniestros %>% select(AÑO, MONTO.PAGADO)

# Deleting the zero mounts
siniestros <- filter(siniestros, siniestros$MONTO.PAGADO >0)
# Viewing datatypes
sapply(siniestros, class)

# Adding a two new columns: Delay and payment year

# Dev_year column
siniestros <- add_column(siniestros, dev_year = as.integer(rdunif(nrow(siniestros), 0, 8)), .after = 1)
# payment year
siniestros <- siniestros %>% mutate(payment_year = as.integer(rowSums((across(c(AÑO, dev_year))))), .after = 2)

# Because each year has a max development year, eg 2023 has max dev_year 0
siniestros <- siniestros %>%
  mutate(
    max_dev_year = 2023 - AÑO,  # Max DY allowed for each AY
    dev_year_fixed = if_else(dev_year <= max_dev_year, dev_year, NA_real_),
    .after = 3
  )


# Because we don't trust in the content of each cell, we will see the possible range of values in each cell

possible_values <- lapply(siniestros, unique)
    # To fix:
    # MONEDA: "No disponible", "No Disponible"
    # FORMA.DE.VENTA: "Fuerza Venta Interna o Matriz", "Fuerza Venta Interna o Casa Matriz"; "No disponible", "No Disponible"; "Agentes Persona Fisica", "Agentes Persona Física"; "Módulos de Venta", "Modulos de Venta"; "Descuento por Nómina", "Descuento por Nomina"; "Microcréditos", "Microcreditos"
    # GIRO: "No Disponible", "No disponible"
    # ENTIDAD: Fix accents, uppercase, "En el extranjero", "Entranjero"
    #

# Missing values

colSums(is.na(siniestros))  # There is no missing values


# 1. What is the year with most claims. R: 2023 with 16,760 claims
max_year_of_claims <- siniestros %>%
  group_by(AÑO) %>%
  summarise(frec_year = n()) %>%
  arrange(desc(frec_year))



# MAKING THE LOSS TRIANGLE

# Aggregate and complete missing DYs
triangle_long <- siniestros %>%
  group_by(AÑO, dev_year) %>%
  summarise(values = sum(MONTO.PAGADO, na.rm = TRUE))

# drop the exceding years
triangle_long <- triangle_long %>%
  filter(AÑO + dev_year <= 2023)

# Making the triangle
triangle <- as.triangle(
  triangle_long,
  origin = "AÑO",
  dev = "dev_year",
  value = "values"
)
# Acumulated triangle
triangle <- incr2cum(triangle)
print(triangle)

plot(triangle/1000000)
plot(triangle/1000000, lattice = T)
