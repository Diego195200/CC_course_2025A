library(insuranceData)
library(dplyr)
data(dataCar)

# vehiculo con mayor valor
filter(dataCar, dataCar$veh_value == max(dataCar$veh_value))

# vehiculo con mayor reclamación
filter(dataCar, dataCar$claimcst0==max(dataCar$claimcst0))

max(dataCar$claimcst0)

# verificar si existen valores NA

dataCar %>%
  summarise_all(~sum(is.na(.)))
# conocer las posiciones de una columna
which(is.na(dataCar$veh_value))
# para todo el data frame
which(is.na(dataCar), arr.ind = TRUE)  # arr.ind: index de los NA

# dataset who

who <- read.csv('WHO.csv', na.strings = c("null", "**"), stringsAsFactors = FALSE)

who %>%
  summarise_all(~sum(is.na(.)))

which(is.na(who), arr.ind = TRUE)

