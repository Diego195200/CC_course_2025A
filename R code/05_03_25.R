library(pacman)
library(dplyr)
library(corrplot)
p_load(datos, GwalkR, janitor, inspectdf, tidyverse)

options(scipen = 999)  # evita la notación cientifica
data(package = "datos")  # para ver los datasets que hay
?datos_credito
credit <- as.data.frame(datos_credito)  # convertir a dataframe
names(credit)  # to view columns
str(credit)  # view datatypes

# Visualizar las categorias de la variable
levels(credit$Estado)
levels(credit$Trabajo)

colSums(is.na(credit))
dim(credit)
sum(is.na(credit))

# omitir datos faltantes
credito <- credit %>%
  na.omit()

summary(credito)
# analisis bivariado

# correlación entre variables numericas
cor(credito[c("Ingresos", "Gastos", "Activos", "Deuda", "Cantidad", "Precio")])

# correlación de todas las variables numericas
cred_num <- credito %>%
  select(where(is.numeric))

cor(cred_num)

numericas <- credito[, sapply(credito, is.numeric)]
cor_matrix <- cor(numericas)
# grafico correlacion
corrplot(cor_matrix, method='shade')
# ingresos y gastos ( a medida que los ingresos aumentan, los gastos tambien aumenta

# ANOVA para probar varianzas, medias, diferencia de medias
# comparar los ingresos con estado civil
# anova para ver si hay diferencias significativas entre las medias de dos o más grupos
# ingresos es la variable dependiente ( la que se trata de explicar)
# Estado civil es la variable independiente (el factor que puede influir
# debe haber una vaariable numerica y categorica
aov_result <- aov(Ingresos ~ EstadoCivil, data=credito)
summary(aov_result)
# medias iguales no me interesan, que sean diferentes

# p value menor a 0.05, se rechaza H0, hay evidencia de que al menos uno de los grupos tiene una media diferente a los demas
# en el caso, indica que el estado civil tiene un efecto significativo en los ingresos
