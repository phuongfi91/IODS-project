# Name: Phuong Nguyen
# Date: 09.12.2018
# This file is where data wrangling is done for the last week exercise
# Original data source: 
# https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt
# https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt
  



### Last week exercise

# 1. Read in the data
BPRS <- read.table(
  "https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt",
  sep  =" ", header = T)

RATS <- read.table(
  "https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt",
  header = TRUE, sep = '\t')

# Check data
# Data contains treatment type (1, 2) amongst 40 male subjects within 8 weeks
# with week0 being the pre-treatment condition
str(BPRS)
# Data contains group number (1, 2, 3) amongst 16 rat subjects within 9 weeks
str(RATS)


# 2. Convert the categorical variables of both data sets to factors
BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)
RATS$ID <- factor(RATS$ID)
RATS$Group <- factor(RATS$Group)

# 3. Convert the data sets to long form
library(dplyr)
library(tidyr)

BPRSL <- BPRS %>% gather(key = weeks, value = bprs, -treatment, -subject)
BPRSL <- BPRSL %>% mutate(week = as.integer(substr(BPRSL$weeks, 5, 5)))

RATSL <- RATS %>%
  gather(key = WD, value = Weight, -ID, -Group) %>%
  mutate(Time = as.integer(substr(WD, 3, 4)))

# 4. Check the datasets and compare the long and the wide form
# The long form condenses the week columns into a single column "weeks", this way
# data can be treated as records, making it easier to use for the upcoming analysis.
# "week" indicates the week the subject is on, corresponding to his bprs score.
str(BPRSL)
str(BPRS)
# Week columns are also done in a similar manner here for this dataset, with the 
# purpose described like above. Time describes the week the subject is on, corresponding
# to its Weight
str(RATSL)
str(RATS)


# Writing data to file
write.table(BPRSL, file = "bprsl.csv", sep = ";")
write.table(RATSL, file = "ratsl.csv", sep = ";")
