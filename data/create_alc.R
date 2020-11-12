# Stefanie Kirschenmann, 2020/11/11: Script for the data wrangling part of week 3 of the IODS course (Logistic Regression).

#### READING IN THE DATASETS ####
#read the math class questionaire data into memory. Reading in strings as factors #####
math <- read.table("./data/student-mat.csv", sep = ";" , header=TRUE,  stringsAsFactors = TRUE)

# read the portuguese class questionaire data into memory
por <- read.table("./data/student-por.csv", sep = ";", header = TRUE,  stringsAsFactors = TRUE)

# Look at the first lines of the two .csv
head(math)
head(por)

# Dimension of the data sets
dim(math) # math has 33 variables and 395 observations
dim(por) # por has 33 variables and 649 observations

# Structure of the data sets
str(math) # The structure consists of two kind of datatypes: integer and character. The character type is evaluated as Factor with different categories via the argument "stringAsFactors = TRUE")
str(por)

#### JOIN THE TWO DATA SETS ####

# access the dplyr library
library(dplyr)

# (student) identifiers columns
join_by <- c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet")

# join the two datasets by the selected identifiers
math_por <- inner_join(math, por, by = join_by, suffix=c(".math",".por"))

# see the column names of the joined data set
colnames(math_por)

# We defined the join_by columns as student identifiers. So we create now a new data frame with only the joined columns to just keep the student data.
alc <- select(math_por, one_of(join_by))

# glimpse at the data
glimpse(math_por)
glimpse(alc)
dim(math_por)
head(math_por)

#### GETTING RID OF DUPLICATES/COMBINING ####
# the columns in the datasets which were not used for joining the data
notjoined_columns <- colnames(math)[!colnames(math) %in% join_by]

# print out the columns not used for joining
notjoined_columns

# for every column name not used for joining... DataCamp if-else structure
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

#### MEAN OF WEEKDAY/WEEKEND ALCOHOL CONSUMPTION ###
alc$alc_use <- rowMeans(select(alc, one_of(c("Dalc", "Walc"))))
#select(lrn14, one_of(strategic_questions))
alc$alc_use
alc$Dalc
alc$Walc

#Another option would be:
#alc <- mutate(alc, alc_use2 = (Dalc + Walc) / 2)
#alc$alc_use2

## Create logical column 'high_use' which is TRUE for alc_use > 2 ##
alc <- mutate(alc, high_use = alc_use > 2)

#### GLIMPSE AT THE NEW DATASET ####
glimpse(alc) # 382 observations of 35 variables as expected

#Save the dataset to the data folder
write.csv(alc, file = './data/alc.csv')
