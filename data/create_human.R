# Name: Phuong Nguyen
# Date: 25.11.2018
# This file is where data wrangling is done for the fourth week exercise
# Original data source: http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human1.txt




### WEEK 4 ASSIGNMENT

# 1. 2. Read in the "Human development" and "Gender inequality" datasets
hd <- read.csv(
  "http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv",
  stringsAsFactors = F
)

gii <- read.csv(
  "http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv",
  stringsAsFactors = F, na.strings = ".."
)

# 3. Explore the datasets
# Structure and summaries of variables in "Human development" dataset
str(hd)
summary(hd)

# Structure and summaries of variables in "Gender inequality" dataset
str(gii)
summary(gii)

# 4. Rename variables into shorter and more descriptive names
colnames(hd) <- c(
  "HDI.Rank", "Country", "HDI", "Life.Exp", 
  "Edu.Exp", "Edu.Mean", "GNI", "GNI.Minus.Rank"
)

colnames(gii) <- c(
  "GII.Rank", "Country", "GII", "Mat.Mor", "Ado.Birth",
  "Parli.F", "Edu2.F", "Edu2.M", "Labo.F", "Labo.M"
)

# 5. Gii dataset mutation
gii <- mutate(gii, Edu2.FM = Edu2.F/Edu2.M)
gii <- mutate(gii, Labo.FM = Labo.F/Labo.M)

# 6. Joining hd and gii datasets
library(dplyr)
join_by <- c("Country")
human <- inner_join(hd, gii, by = join_by)

# Write data to file
write.table(human, file = "human.csv", sep = ";")






### WEEK 5 ASSIGNMENT

# 1. Transform GNI variable to numeric
library(stringr)
human$GNI <- str_replace(human$GNI, pattern = ",", replacement = "") %>% as.numeric()

# 2. Keep only selected columns
keep <- c(
  "Country", "Edu2.FM", "Labo.FM", "Edu.Exp", 
  "Life.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F")

human <- select(human, one_of(keep))

# 3. Remove all rows with missing values
human = filter(human, complete.cases(human))

# 4. Remove all records related to regions instead of countries
last <- nrow(human) - 7
human <- human[1:last, ]

# 5. Define row names by the country and remove the country column
rownames(human) <- human$Country
human <- select(human, -Country)

# Write data to file
write.table(human, file = "human.csv", sep = ";", row.names = TRUE)
