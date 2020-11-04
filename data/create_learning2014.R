# Stefanie Kirschenmann, 2020/11/02: This script is needed for the data wrangling and analysis steps for the second week of the IODS course.

# Libraries needed:
library(dplyr) # for data wrangling

# Reading in the full learning2014 data
lrn14 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header=TRUE)

# Looking at the structure and dimensions of the data
str(lrn14) 
dim(lrn14)
# The dataframe consists of 183 observations and 60 variables, with 59 variables being of the data type "integer",
# and 1 (gender) of the type "character"


# Creating a subset of the dataframes
# Preparations and filtering
# questions related to deep, surface and strategic learning
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

deep_columns <- select(lrn14, one_of(deep_questions))
surface_columns <- select(lrn14, one_of(surface_questions))
strategic_columns <- select(lrn14, one_of(strategic_questions))

# Attach the combined columns to the dataframe
lrn14$deep <- rowMeans(deep_columns)
lrn14$surf <- rowMeans(surface_columns)
lrn14$stra <- rowMeans(strategic_columns)
lrn14$attitude <- lrn14$Attitude/10

# create the df subset
df_subset <- c("gender","Age","attitude", "deep", "stra", "surf", "Points")
learning2014 <- select(lrn14,one_of(df_subset))
learning2014

# Change "Age" and "Points" to lower case letters
colnames(learning2014)[2] <- "age"
colnames(learning2014)[7] <- "points"

head(learning2014)

# The working directory is already set to the IODS project. This can be done in R-Studio by Session->Set working directory or by using "setwd" to set the working directory 
# The dataframe will be saved  as a .csv file inside the data folder, the path has to be given in reference to the working directory.
# WD <- getwd() : to get the current working directory
# setwd(WD) : setting the current working directory to WD
write.csv(learning2014, file = './data/learning2014.csv')
write.table(learning2014, file = "./data/learning2014.txt", sep = "\t", row.names = TRUE, col.names = NA)
