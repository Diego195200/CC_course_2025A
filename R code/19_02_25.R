library(ggplot2)
library(insuranceData)

data(dataCar)
# Graficas con ggplot2

# Tres elementos: data, aesthetic mappings, objetos geometricos
# ggplot(datos, aes()) + geom_tipo()

# top 5 vehiculos con mayor numero de reclamaciones
claims_tipo <- dataCar %>%
  group_by(veh_body) %>%
  summarise(totclaims=sum(numclaims)) %>%
  arrange(desc(totclaims))

ggplot(claims_tipo, aes(x = reorder(veh_body, -totclaims), y = totclaims)) +
  geom_bar(stat= "identity", fill = "blue", color = "black") +
  labs(title = "Número de reclamaciones por tipo de vehiculo", x="Tipo de vehiculo", y="Total de reclamaciones")+
  theme_minimal()+
  theme(axis.text.x = element_text(angle=45, hjust=1))

# top 10 vehiculos con mayor monto de reclamaciones
claims_monto <- dataCar %>%
  group_by(veh_body) %>%
  summarise(montclaims=sum(claimcst0)) %>%
  arrange(desc(montclaims))

claims_monto

ggplot(claims_monto, aes(x = reorder(veh_body, -montclaims), y = montclaims)) +
  geom_bar(stat= "identity", fill = "orange", color = "black") +
  labs(title = "Monto de reclamaciones por tipo de vehiculo", x="Tipo de vehiculo", y="Total de monto")+
  theme_minimal()+
  theme(axis.text.x = element_text(angle=45, hjust=1))

# Numero de reclamaciones por género

num_gender <- dataCar %>%
  group_by(gender) %>%
  summarise(numclaims = n()) %>%
  arrange(desc(numclaims))

num_gender

ggplot(num_gender, aes(x = reorder(-numclaims), y = numclaims)) +
  geom_bar(stat= "identity", fill = "orange", color = "black") +
  labs(title = "Monto de reclamaciones por tipo de vehiculo", x="Tipo de vehiculo", y="Total de monto")+
  theme_minimal()+
  theme(axis.text.x = element_text(angle=45, hjust=1))


# suma de reclamaciones por tipo de vehiculo y genero

claims_veh_gen <- dataCar %>%
  group_by(gender, veh_body) %>%
  summarise(totclaims = sum(numclaims)) %>%
  arrange(desc(totclaims))

claims_veh_gen

ggplot(claims_veh_gen, aes(x = reorder(veh_body, -totclaims), y = totclaims, fill=gender)) +
  geom_bar(stat= "identity", position = "dodge") +
  labs(title = "Tipo de vehiculo reclamaciones por genero", x="Tipo de vehiculo", y="numero de reclamaciones")+
  theme_minimal()+
  theme(axis.text.x = element_text(angle=45, hjust=1)) # + scale_fill_manual(values=c("light blue", 'pink'))

# reporte de lo que hemos hecho de este dataset subir a github

