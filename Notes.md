# Introducción a el cómputo Cientifico (14/02/25)

Se puede definir como el uso de herramientas, técnicas, procedimientos y desarrollos teóricos que se requieren para resolver problemas utilizando ordenadores y algun programa estadistico

Utiliza herramientas como la programación, el análisis numérico y la visualización de datos para obtener soluciones precisas y eficientes

* Moda, mediana, percentil

## Importancia en las areas

### Campo actuarial

En el campo actuarial el cómputo cientifico es esencial para:
	
* **modelado de riesgos**: Permite crear modelos matemáticos para evaluar y gestionar riesgos en seguros y pensiones
*  **Simulación de escenarios**: Ayuda a simular diferentes escenarios económicos y demográficos para prever el comportamiento futuro de productos actuariales
*  **Optimización de portafolios**: Facilita la optimización de portafolios de inversión para maximizar rendimientos y minimizar riesgos

### Campo financiero

* **Analsis de datos financieros**: Permite analizar grandes volumenes de datos financieros para identificar tendencias y patrones
* **Modelos financieros** ayuda a desarrollar modelos para la valoración de activos, la gestión de riesgos y la predicción de precios
*  **Trading algoritmico**: Facilita la implementación de estrategias de trading automatizados basado en algoritmos complejos

### Sector comercial

* **Analisis de mercado**: permite analizar datos de mercado para identificar oportunidades y tendencias
* **optimazación de operaciones**: ayuda a optimizar procesos comerciales, como la gestión de inventarios y logistica
* **personalización de oferta**: facilita la creación de ofertas personalizadas basadas en el analisis de datos de clientes.

		En una aseguradora se aplican las tres áreas

## Proceso de la programación

Importar -> Ordenar-> Ciclo(Comprender(Transformar -> visualizar -> Modelar)) -> comunicar

## Estructuras de Datos de Python

## Estructuras de Datos de R

* Vectores: Estructura más basica de R y puede contener elementos del mismo tipo
* Matrices o arreglos: Son arreglos de datos bidimensionales que pueden contener diferentes tipos de datos en cada columna
* Listas: son colecciones de elementos que pueden ser de diferente tipo
* Tibbles: versión mejorada del DataFrame, proporcionada por la paqueteria *tibble*


# 17-02-25

## Packages

* insuranceData
* dplyr
* skmimr
* visdat
* ggplot2


**Factor**: variable categórica

# UNIDAD II  17/02/25

**EDA: Analisis exploratorio de datos (Exploratory Data Analysis)**
Ciclo iterativo en el que:
* generas preguntas

**objetivo**:

indicar posibles errores (datos incorrectamente introducidos, detectar la ausencia de valores o una mala decodificación)

**Pasos**:

Se puede dividir en 3 grandes pasos y estos a su vez se subdividen en muchsa tareas que se deben realizar para empezar a interpretar los resultados

* Carga de los datos

* Limpieza de datos: Eliminar duplicados, tratar valores nulos, verificar tipos de datos

	Registros duplicados. si hay un registro repetido 10 veces y el modelo se equivoca en su predicción, se estará equivocando
   10 veces por un solo registro. En algunos casos puede hacerse *oversampling* 


# 24/02/25

3. **Visualización**: Fase en la que se asocia con el EDA, ya que se tiene un data set limpio y funcional, solo queda
explorarlo, visualizar la distribución de las variables numéricas, explor los recuentos de las variables categóricas,
aplicar análisis estadísticos 

Hay cinco tareas que se repiten en este proceso:

- split-apply-combine: consiste en separar un problema en secciones (de acuerdo a una variable de inteŕes) , operar sobre cada subconjunto
de manera independiente (ej. calcular la media de cada grupo, ordenar observaciones por grupo, estandarizar por grupo) y despues unir las secciones nuevamente
Las funciones en R son:

From dplyr:
* `select`: Select variables/columns
* `filter`: select observations/rows
* `mutate`: Transform or rename columns
* `summarize`: crea DataFrames oara resumir datos
* `arrange`: reorder the observartions, rows
* `group_by`: make subgroups

From tidyr:


