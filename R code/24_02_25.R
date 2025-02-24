library(dplyr)

data(starwars)

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

