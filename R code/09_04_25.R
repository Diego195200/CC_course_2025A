library(pacman)
p_load(haven, dplyr, factoextra, FactoMineR, readr, rgl, fpc, psych)

toothpaste_attributes <- read_sav('/var/home/diegob/Documents/Computer Science/R code/toothpaste_attributes.sav')
View(toothpaste_attributes)

# Normalizar datos (par pca)
data1 <- scale(toothpaste_attributes[,-1])
# datos normalizados
View(data1)

# Realizar pca

# si el determinante de la correlacion tiende a cero los datos son adecuados para el pca
det(cor(data1))

# factor de adecuación muestral de Kaiser
# MSA >= 0.6 es ideal, MSA >= es medicre pero útil
psych::KMO(data1)  # sirve para saber que tan adcuada es la variable para reducirla 0.5 mediocre, 0.7 medio aceptable  a 0.8 aceptable

# todas las var poseen una msa mayor a 0.5 por lo que es pertinente hacer el pca
pca <- princomp(data1)
summary(pca)  # los componentes que más varianza aportan es comp 1 y 2. (Var entre 70 y 80). En la proporcion de varianza solo considerar más del 15%
?princomp
# grafica e eigenvalores
fviz_eig(pca, choice='variance')

fviz_eig(pca, choice ='eigenvalue')
# loa adecuado es extraer unicamente dos factores

#Cuántos componentes son adecuados?
# 1. Con base en la % de varianza acumulada (>=70%)
# 2. Revisar que esos comp tengan eigenvalue > 1

# Coseno cuadrado es para medir la calidad de la representación de las variables originales en el espacio de los componentes principales
# el coseno cuadrado de una variable en un comp principal es el cuadrado del coseno del ángulo entre la variable original y el componente principal

# Grafico de las puntuaciones factoriales y su representación
fviz_pca_ind(pca,
             col.ind = 'cos2',
gradient.cols = c('red', 'yellow', 'green'),
             repel = FALSE)
# los puntos verdes están representados bien, las otras observaciones no están represetadas
# esto es la mayoria de las observaciones se adecuan a las dos dimensiones

# Gráfico de las cargas
# Cuánto contribuye cada variable a las diferentes comp principales
# los componentes contribuyen en diferente medida a los cuadrantes dentro de la representación bidimensional

fviz_pca_var(pca, col.var = 'contrib', gradient.cols = c('red', 'yellow', 'green'), repel = FALSE)

fviz_pca_biplot(pca, col.var='red', col.ind = 'blue')

pca$loadings
# por ejemplo, en el cuadrante 1 se tiene sujetos como el 8, que deberán tener puntuaciones altas en aspectos relacionados a salud pero bajas en temas esteticos
data1[8,]
# en el cuadrante dos se tienen personas con un interés bajo en temas de salud pero alto en temas estéticos
data1[14,]

# analisis con spss
# Las variables en un pca deben estar altamente correlacionadas para que tenga sentido realizarlo
pysch::cor.plot(data1)

det(cor(data1))

# La rotación más comun es varimax


pca2 <- psych::principal(data1, nfactors=2, residuals=FALSE, rotate="varimax", scores=TRUE, oblique.scores=FALSE, method='regression', use='pairwise', cor='cor', weight=NULL)

pca2

# Matriz de coeficientes para las puntuaciones de los componentes
pca2$weights[,1]
pca2$weights[,2]

# Nuevas variables obtenidas, cuya principal caracteriatistica es que son ortogonales, es decir linealmente independientes

# Por lo anterior un conjunto de 6 variables altamente relacionadas se redujo unicamente dos variables cuya característica es que son ortogonales
# las variables son las siguientges
pca2$scores






