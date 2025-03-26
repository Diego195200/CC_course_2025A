library(pacman)
library(ggplot2)
library(dplyr)
library(corrplot)
library(datos)
p_load(datos, GWalkR, janitor, inspectdf, tidyverse, factoextra)

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

# ANOVA
# Deuda vs Estado civil RH0
# Gastos vs Edad RH0
# Podemos hacer un analisis de regresión con estas variables

# Tablas de contingencia: sirve para demostrar el analisis tanto en conjunto como en marginal
table(credito$EstadoCivil=='divorciado', credito$Estado=='malo')  # TRUE, TRUE cuando coinciden las dos condiciones

# Tabla de contigencia con porcentajes
tabla_contingencia <- credito %>%  # pipe shortcut ctrl + shift + m
  tabyl(EstadoCivil, Estado) %>%  # tabyl is a janitor function for contingency tables
  adorn_totals('row')  %>%  # añadir totales por fila
  adorn_percentages('row') %>% # calcular porcentajes por fila
  adorn_pct_formatting(digits = 1)  # Formato para un decimal

tabla_contingencia
table(credito$EstadoCivil, credito$Estado)
prop.table(table(credito$EstadoCivil, credito$Estado), margin = 1)*100

# Estado civil con vivienda

civil_vivienda <- credito %>%  # pipe shortcut ctrl + shift + m
  tabyl(EstadoCivil, Vivienda) %>%  # tabyl is a janitor function for contingency tables
  adorn_totals('row')  %>%  # añadir totales por fila
  adorn_percentages('row') %>% # calcular porcentajes por fila
  adorn_pct_formatting(digits = 1)  # Formato para un decimal

civil_vivienda
table(credito$EstadoCivil, credito$Vivienda)
prop.table(table(credito$EstadoCivil, credito$Vivienda), margin = 1)*100


# graf barras para vairables categoricas o variables de conteo
# graf columnas cuando y es una variable continua

# Grafica tabla de contingencia
ggplot(credito, aes(x=EstadoCivil, fill=Estado)) +
  geom_bar(position = 'fill') + # bar because is a count variable
  theme_minimal() +
  labs(title = "Distribución de Estado por Estado civil", x="Estado civil", y="Proporción")

# Grafica de Estado civil con ingresos
ggplot(credito, aes(x=EstadoCivil, y=Ingresos, fill=EstadoCivil)) +
  geom_col() +
  theme_minimal()+
  labs(title = "Distribución del Ingreso por Estado Civil")

# Consulta

cons <- credito %>%
  group_by(EstadoCivil, Estado) %>%
  summarise(IngresoPromedio = round(mean(Ingresos),0)) %>%
  arrange(desc(Estado), desc(IngresoPromedio))

# div y credito bueno
filter(cons, EstadoCivil=='divorciado', Estado=='bueno')

# Buscar condiciones boleanas in filter

# boxplot
#
ggplot(credito, aes(x=EstadoCivil, y=Ingresos)) +
  geom_boxplot() +
  theme_minimal()+
  labs(title = "Ingresos por Estado Civil", x='Estado Civil', y='Ingresos')

# razon deuda

credito <- credito %>%
  mutate(#activos = ifelse(Activos==0, 1e-10, Activos),
         pago_mensual = Precio / Plazo,
         riesgo = pago_mensual / (Ingresos - Gastos),
         estado_credito = case_when(
           riesgo < 1 ~ "Credito sano",
           riesgo == 1 ~"Credito medio",
           riesgo > 1 ~ "Credito riesgo"
         )
  )



credito <- credito %>%
  mutate(
         activos = ifelse(Activos==0, 1e-10, Activos),
         riesgo = -0.1*(Precio / Ingresos) +0.10*(Deuda / activos) +  0.35*(Gastos / Ingresos) + 0.25*(Cantidad / activos),
         # estado_credito = case_when(
         #   abs(dedicado_pago) < 0.5 ~ "Credito sano",
         #   abs(dedicado_pago) == 0.5 ~"Credito medio",
         #   abs(dedicado_pago) > 0.5 ~ "Credito riesgo"
         # )
  )

credito %>%
  group_by(EstadoCivil, Estado) %>%
  summarise(IngresoPromedio = round(mean(Ingresos),0),
            riesgo = round(mean(riesgo),0),
            estado_credito = first(estado_credito)) %>%
  arrange(desc(Estado),desc(IngresoPromedio))

# caoacidad de deuda=ingresos*.35  deuda no debe superar el 35%

credito <- credito %>%
  mutate(
         capacidad_deuda=Ingresos*0.35,
         estado_credito = case_when(
           capacidad_deuda >= Deuda ~ "Credito sano",
           capacidad_deuda < Deuda ~ "Credito riesgo"
         )
  )

ing_cap <- credito %>%
  group_by(EstadoCivil, Estado) %>%
  summarise(IngresoPromedio = round(mean(Ingresos),0),
            capacidad_deuda = round(mean(capacidad_deuda),0),
            estado_credito = first(estado_credito)) %>%
  arrange(desc(Estado),desc(IngresoPromedio))

table(credito$estado_credito)
table(credito$Estado)

# Visualización de datos con gwalR
gwalkr(credito)

ggplot(credito, aes(x=EstadoCivil)) +
  geom_bar() +
  theme_minimal() +
  labs(title = "Ingreso por Estado Civil", x="Estado Civil", y="Frecuencia")


# PCA
# Reduce el numero de dimensiones de grandes cnjuntos de datos (variables numericas)
# Componentes principales que conservan la mayor parte de la información general
# Ayuda a redcir la complejidad de los modelos
# 80-90% de la varianza


# Pasos
# Estandarizar variables
cred_num_estand <- scale(cred_num)

# Realizar PCA
pca <- prcomp(cred_num_estand, center=TRUE, scale. = TRUE)

#Summary
summary(pca)

# Grafico de scree plot para ver la varianza explicada por cada componente
fviz_eig(pca)
