library(pacman)
library(factoextra)
p_load(psych, haven, factoextra)

data_pca <- read.csv2("data_pca.csv")

# normalizar datos
data_normal <- scale(data_pca[,-16])
View(data_normal)

# PCA

# determinante de correlación
det(cor(data_normal))  # La correlación tiende a cero
psych::cor.plot(data_normal)

# Factor de adecuación muestral de kaiser
psych::KMO(data_normal)  # MSA de 0.34, es muy bajo por lo que no se recomienda PCA

pca <- princomp(data_normal)
summary(pca)  # Vamos a considerar 6 componentes, donde hay una acumulación de varianza del 70%

# grafica de eigenvalores y varianza
fviz_eig(pca, choice='variance')

fviz_eig(pca, choice ='eigenvalue')

# Grafico de las puntuaciones factoriales y su representación
fviz_pca_ind(pca,
             col.ind = 'cos2',
             gradient.cols = c('red', 'yellow', 'green'),
             repel = FALSE)  # Existe una gran cantidad de datos no bien representados correctamente


# PCA con 6 componentes

pca_6comp <- psych::principal(data_normal, nfactors = 6, residuals=FALSE, rotate="varimax", scores=TRUE, oblique.scores=FALSE, method='regression', use='pairwise', cor='cor', weight=NULL)
pca_6comp$weights

# Nuevas variables obtenidas, cuya principal caracteriatistica es que son ortogonales, es decir linealmente independientes

# Por lo anterior un conjunto de 15 variables altamente relacionadas se redujo unicamente dos variables cuya característica es que son ortogonales

