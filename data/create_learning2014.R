# Stefanie Kirschenmann, 2020/11/02: This script is needed for the data wrangling and analysis steps for the second week of the IODS course.

# Libraries needed:
library(dplyr) # for data wrangling

# Reading in the full learning2014 data
lrn14 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header=TRUE)

# Looking at the structure and dimensions of the data
str(lrn14) 
dim(lrn14)
# The dataframe consists of 183 observations and 60 variables, with 59 variables being of the data type "integer" and 1 (gender) of the type "character"

# Creating a subset of the dataframe
# Preparations and filtering
# Combining question variables: questions related to deep, surface and strategic learning
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

#Combining columns and add a weighted column to the dataset
deep_columns <- select(lrn14, one_of(deep_questions))
surface_columns <- select(lrn14, one_of(surface_questions))
strategic_columns <- select(lrn14, one_of(strategic_questions))

# Create a new sub dataframe
# As the *attitude* variable is also a combined value based on 10 questions it will be divided by 10. For the deep, stra and surf the mean-value is taken with rowMeans
df_subset <- c("gender","Age","Points")
learning2014 <- select(lrn14,one_of(df_subset))
learning2014$attitude= lrn14$Attitude/10 
learning2014$deep <- rowMeans(deep_columns)
learning2014$stra <- rowMeans(strategic_columns)
learning2014$surf <- rowMeans(surface_columns)
head(learning2014)

# change the name of the second column
colnames(learning2014)[2] <- "age"
# change the name of "Points" to "points"
colnames(learning2014)[3] <- "points"
# reorder the dataframe
learning2014 <- learning2014[c(1,2,4,5,6,7,3)] 
head(learning2014)


# The working directory is already set to the IODS project. This can be done in R-Studio by Session->Set working directory or by using "setwd" to set the working directory 
# The dataframe will be saved  as a .csv file inside the data folder, the path has to be given in reference to the working directory.
# WD <- getwd() : to get the current working directory
# setwd(WD) : setting the current working directory to WD
write.csv(learning2014, file = './data/learning2014.csv', row.names = FALSE)
write.table(learning2014, file = "./data/learning2014.txt", sep = ",", row.names = FALSE)
