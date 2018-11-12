# Name: Phuong Nguyen
# Date: 11.11.2018
# This file is where data wrangling is done for the second week exercise

# 1. Read in data
lrn2014 <- read.table(
  "http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt",
  sep = "\t", header = TRUE
)

# 2. The data table contains 183 records, spanning across 60 different variables
dim(lrn2014)
str(lrn2014)

# 3. Create an analysis dataset with the variables gender, age, attitude, deep,
# stra, surf and points by combining questions in the learning2014 data
library(dplyr)
keep_columns <- c("gender", "Age", "Attitude", "Points")
learning2014 <- select(lrn2014, one_of(keep_columns))
colnames(learning2014)[2] <- "age"
colnames(learning2014)[3] <- "attitude"
colnames(learning2014)[4] <- "points"

deep_questions <- c(
  "D03", "D11", "D19", "D27", "D07", "D14",
  "D22", "D30", "D06", "D15", "D23", "D31"
)
surface_questions <- c(
  "SU02", "SU10", "SU18", "SU26", "SU05", "SU13",
  "SU21", "SU29", "SU08", "SU16", "SU24", "SU32"
)
strategic_questions <- c(
  "ST01", "ST09", "ST17", "ST25",
  "ST04", "ST12", "ST20", "ST28"
)
learning2014$deep <- rowMeans(select(lrn2014, one_of(deep_questions)))
learning2014$surf <- rowMeans(select(lrn2014, one_of(surface_questions)))
learning2014$stra <- rowMeans(select(lrn2014, one_of(strategic_questions)))
learning2014 <- filter(learning2014, points > 0)
learning2014$attitude <- learning2014$attitude / 10

# 4. Write csv data to file and read it back in
write.table(learning2014, file = "learning2014.txt", sep = "\t")
learning2014_again <- read.table("learning2014.txt", sep = "\t", header = TRUE)
head(learning2014_again)
str(learning2014_again)
