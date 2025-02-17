library(insuranceData)
library(dplyr)
library(skimr)
library(ggplot2)
library(visdat)

# Activar DataFrame
data(dataCar)

#Concer estructura de la base
str(dataCar)

# resumenes estadisticos

summary(dataCar)
skim(dataCar)

# ver encabezado de la base
head(dataCar)

# ver ultimos datos
tail(dataCar)

# Ver dimesión (filas columnas)
dim(dataCar)

# glimpse, de dplyr para ver tipos de datos de las variables, una opción a str()
glimpse(dataCar)

# ver nombres de columnas
names(dataCar)
colnames(dataCar)

# para verificar si hay datos faltantes
any(is.na(dataCar))
which(is.na(dataCar), arr.ind=TRUE)

# visualizar
vis_dat(dataCar)

#visualizar si hay datos faltantes
vis_miss(dataCar)

# Que porcentaje de polizas incurren en al menos una reclamación
dataCar$numclaims > 0

sum(dataCar$numclaims >=0)
# En porcentaje
sum(dataCar$numclaims > 0) / nrow(dataCar)

# Top 5 de vehiculos con mayor numero de reclamaciones

top_5_claims <- dataCar %>%
  group_by(veh_body) %>%
  summarise(numclaims=sum(numclaims)) %>%
  arrange(desc(numclaims))

head(top_5_claims, 5)

# write.csv(dataCar, "datacar.csv")