library(insuranceData)
library(ggplot2)
library(dplyr)
library(RColorBrewer)

# Data information
data(dataCar)

#number of policies
total_policies <- nrow(dataCar)

# Variables in dataCar
print(names(dataCar))

# policies with claims

policies_with_claims <- sum(dataCar$numclaims > 0)

perc_claims <- policies_with_claims / total_policies

# five vehicules with most claims

five_veh_claims <- dataCar %>%
  group_by(veh_body) %>%
  summarise(claim_veh = sum(numclaims)) %>%
  arrange(desc(claim_veh))

five_veh_claims

# Graph of 5 vehicules with most claims

ggplot(five_veh_claims, aes(x = reorder(veh_body, -claim_veh), y = claim_veh)) +
  geom_bar(stat= "identity", fill = "red", color = "black") +
  labs(title = "Number of claims by type of vehicle", x="Type of vehicle", y="Total claims ")+
  theme_minimal()+
  theme(axis.text.x = element_text(angle=45, hjust=1))


ten_veh_tot_claims <- dataCar %>%
  group_by(veh_body) %>%
  summarise(total_claim = sum(claimcst0)) %>%
  arrange(desc(total_claim))

head(ten_veh_tot_claims,10)

# Graph of total claims by vehicule
ggplot(ten_veh_tot_claims, aes(x = reorder(veh_body, -total_claim), y = total_claim)) +
  geom_bar(stat= "identity", fill = "green", color = "black") +
  labs(title = "Total claim amount by type of vehicle", x="Type of vehicle", y="Total claim amount ")+
  theme_minimal()+
  theme(axis.text.x = element_text(angle=45, hjust=1))


# Claims by gender

claims_gender <- dataCar %>%
  group_by(gender) %>%
  summarise(claim_by_gender=n()) %>%
  arrange(desc(claim_by_gender))

claims_gender

# Graph number of claims by gender

ggplot(claims_gender, aes(x = gender, y = claim_by_gender)) +
  geom_bar(stat= "identity", fill = "orange", color = "black") +
  labs(title = "Number of claims by gender", x="Gender", y="Claims")+
  theme_minimal()+
  theme(axis.text.x = element_text(angle=45, hjust=1))

# number of claims by type of vehicule and gender

claims_veh_gen <- dataCar %>%
  group_by(veh_body, gender) %>%
  summarise(numberclaims = sum(numclaims))

claims_veh_gen

ggplot(claims_veh_gen, aes(x = reorder(veh_body, -numberclaims), y = numberclaims, fill=gender)) +
  geom_bar(stat= "identity", position = "dodge") +
  labs(title = "Number of claims by type of vehicle and gender", x="Type of vehicle", y="numero de reclamaciones")+
  theme_minimal()+
  theme(axis.text.x = element_text(angle=45, hjust=1)) # + scale_fill_manual(values=c("light blue", 'pink'))

# Claims by age of vehicle

claims_veh_age <- dataCar %>%
  group_by(veh_age) %>%
  summarise(numclaims = sum(numclaims)) %>%
  arrange(desc(numclaims))

claims_veh_age

ggplot(claims_veh_age, aes(x=reorder(veh_age, -numclaims), y=numclaims, fill=numclaims)) +
  geom_col(width=0.7) +
  scale_fill_gradient(low = "lightblue", high = "darkblue") +
  labs(title = "Vehicle Age with Most Claims", x = "Vehicle Age", y = "Number of Claims") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 0, hjust = 1, vjust=1), plot.title = element_text(hjust = 0.5, face="bold"))


# Area where the mean exposure is longer by vehicle

area_veh <- dataCar %>%
  group_by(area, veh_body) %>%
  summarise(exp = mean(exposure)) %>%
  arrange(desc(veh_body))

## colors for graph
colors_13 <- colorRampPalette(brewer.pal(12, "Paired"))(13)

ggplot(area_veh, aes(x=reorder(area, -exp), y=exp, fill=veh_body)) +
  geom_bar(stat="identity", position="dodge") +
  labs(title = "Average Exposure by Vehicle Body Type and Area", x = "Area", y = "Average Exposure", fill = "Vehicle Body") +
  geom_vline(xintercept = seq(1.5, length(unique(area_veh$area)) - 0.5, by = 1),
             linetype="dashed", color="black", size=0.5) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 0, hjust = 1), plot.title = element_text(hjust = 0.5, face="bold")) +
  scale_fill_manual(values = colors_13)


# vehicle value by area

value_area_exp <- dataCar %>%
  mutate(veh_value = cut(veh_value, breaks = c(0, 13, 24, 35), right = FALSE, labels=c('0-12', '13-23', '24-35'))) %>%
  group_by(veh_value, area) %>%
  summarise(numb_veh = n(), .groups = "drop")


ggplot(value_area_exp, aes(x=area, y=numb_veh, fill=veh_value)) +
  geom_bar(stat="identity", position="dodge") +
  labs(
    title = "Range of vehicle values by zones",
    x = "Area",
    y = "Number of vehicles",
    fill = "Vehicle value"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1), plot.title = element_text(hjust = 0.5, face="bold"))


# SEDAN value

sedan <- filter(dataCar, dataCar$veh_body == "SEDAN")
max(sedan$veh_value)
mean(sedan$veh_age)

# Vehicles by area

veh_area <- dataCar %>%
  group_by(area, veh_body) %>%
  summarise(numveh = n())


ggplot(veh_area, aes(x=reorder(area, -numveh), y=numveh, fill=veh_body)) +
  geom_bar(stat="identity", position="dodge") +
  labs(title = "Number of vehicles by type and by area", x = "Area", y = "Number", fill = "Vehicle Body") +
  geom_vline(xintercept = seq(1.5, length(unique(area_veh$area)) - 0.5, by = 1),
             linetype="dashed", color="black", size=0.5) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 0, hjust = 1), plot.title = element_text(hjust = 0.5, face="bold")) +
  scale_fill_manual(values = colors_13)