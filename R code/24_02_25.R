library(dplyr)
library(modeest)
data(starwars)
library(insuranceData)

names(starwars)
str(starwars)

#missing data?
is.na(starwars)

# how many missing data?
sum(is.na(starwars))

which(is.na(starwars), arr.ind = TRUE)

colSums(is.na(starwars))  # na for each column

# ommiting data

newdata <- starwars %>%
  na.omit()

sum(is.na(newdata))

# pocos datos no es recomendable omitir datos

# replacing with the mean
starwars_1 <- select(starwars, name, height, mass, birth_year)
newdata_mean <- data.frame(sapply(starwars_1, function (x) ifelse(is.na(x), mean(x, na.rm=TRUE), x)))  # reduce vectorialmente los resultados

newdata_median <- data.frame(sapply(starwars_1, function (x) ifelse(is.na(x), median(x, na.rm=TRUE), x)))

sum(is.na(newdata_median))

summary(newdata_mean$height)
str(newdata_mean$height)

# datatype casting

newdata_mean[,2:3] <- lapply(newdata_mean[,2:3], as.numeric)
newdata_median[,2:3] <- lapply(newdata_median[,2:3], as.numeric)

summary(newdata_mean)
summary(newdata_median)

# 26/02/25

# select specific data types
starw <- starwars %>%
  select(name, where(is.numeric))

# lapply devuelve listas
# datatype casting

newdata_mean[,2:3] <- lapply(newdata_mean[,2:3], as.numeric) # lapply respeta los dtypes
newdata_median[,2:3] <- lapply(newdata_median[,2:3], as.numeric)

# mediana recortada quitar datos de los extremos. si n=10, media recortada al 10%, se quita un dato de cada lado
# trimmed=0.1 -> n*trimmed = datos quitados


newdata_mean_cut <- data.frame(lapply(starw, function (x) ifelse(is.na(x), mean(x, na.rm=TRUE, trim = 0.1), x)))
# media recorta para la altura
mean(starw$height, na.rm=T, trim = 0.20)  # media recortada
mean(starw$height, na.rm=T, trim = 0.40)  # media recortada

# media para la masa

mean(starw$mass, na.rm=T, trim = 0.2)
mean(starw$mass, na.rm=T)
summary(starw$mass)

# resumen estadistico
summary(newdata_mean_cut)
# mode with modeest package
newdata_mode <- data.frame(lapply(starw, function (x) ifelse(is.na(x), mfv(x, na_rm=TRUE, trim = 0.1), x)))

# interpolación
# zoo package
newdata_interpol <- data.frame(lapply(starw, function (x) ifelse(is.na(x), na.approx(x, na.rm=T), x)))
summary(newdata_interpol$height)
summary(starw$height)
summary(newdata_mean_cut$mass)
?na.approx

# importancia: interpolación,media cut, mediana tercera

#buscar función que reemplace na con una regresion lineal


# verificando duplicados con janitor
library(janitor)
data(dataCar)
dim(dataCar)

dataCar %>%
  janitor::get_dupes()

# remove duplicates

dataCar1 <- dataCar %>%
  distinct()

dim(dataCar1)
dim(dataCar)


