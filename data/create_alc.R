# Name: Phuong Nguyen
# Date: 18.11.2018
# This file is where data wrangling is done for the third week exercise

# 1.2.3. Read in data
# Two datasets are provided for measurement of student performance.
# One is measured using math class, while the other using Portuguese class
math <- read.table("student-mat.csv", sep = ";" , header=TRUE)
por <- read.table("student-por.csv", sep = ";", header = TRUE)

dim(math)
str(math)

dim(por)
str(por)

# 4. Join the two datasets using the listed attributes as student identities
# Duplicated attributes will have suffix added according to which dataset it 
# belong to
library(dplyr)

join_by <- c(
  "school","sex","age","address","famsize","Pstatus","Medu",
  "Fedu","Mjob","Fjob","reason","nursery","internet")
math_por <- inner_join(math, por, by = join_by, suffix = c(".math", ".por"))

dim(math_por)
str(math_por)


# 5. Combine the 'duplicated' answers in the joined data

# create a new data frame with only the joined columns
alc <- select(math_por, one_of(join_by))

# the columns in the datasets which were not used for joining the data
notjoined_columns <- colnames(math)[!colnames(math) %in% join_by]

# print out the columns not used for joining
print(notjoined_columns)

# for every column name not used for joining...
for(column_name in notjoined_columns) {
  # select two columns from 'math_por' with the same original name
  two_columns <- select(math_por, starts_with(column_name))
  # select the first column vector of those two columns
  first_column <- select(two_columns, 1)[[1]]
  
  # if that first column vector is numeric...
  if(is.numeric(first_column)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[column_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # add the first column vector to the alc data frame
    alc[column_name] <- first_column
  }
}


# 6. Take the average of the answers related to weekday and weekend alcohol 
# consumption to create a new column 'alc_use' to the joined data
alc <- mutate(alc, alc_use = (alc$Dalc + alc$Walc) / 2)

# Use 'alc_use' to create a new logical column 'high_use' which is TRUE 
# for students for which 'alc_use' is greater than 2 (and FALSE otherwise)
alc <- mutate(alc, high_use = alc$alc_use > 2)

# 7. Glimpse and check the data
glimpse(alc)
# Write the data
write.table(alc, file = "alc.csv", sep = ";")
