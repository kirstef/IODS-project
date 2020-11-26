# Stefanie Kirschenmann, 2020/11/19: Script for the data wrangling part for week 5 of the IODS course (Dimensionality Reduction Techniques).

#### READING IN THE "HUMAN DEVELOPMENT" AND "GENDER INEQUALITY" DATA ####
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

# Metadata for the datasets and technical notes: http://hdr.undp.org/en/content/human-development-index-hdi and http://hdr.undp.org/sites/default/files/hdr2015_technical_notes.pdf

#### DATA EXPLORATION ####

# Structure and dimensions of the datasets

dim(hd)
str(hd)

dim(gii)
str(gii)

# Summaries of the two datasets

summary(hd)
summary(gi)

#### LOOKING AT THE METAFILES ####

# Let's print the colnames ones more

colnames(hd)
colnames(gii)

head(hd)
head(gii)

# The variable names are renamed and have the following meaning:

## For hd: ##
# HDIRank: Human development index rank 
# Country: Country
# HDI: Human Development Index
# LifeExp: Life Expectancy at birth
# EduYearsExp: Expected Years of Education
# EduYearsMean: Mean Years of Education
# GNI: Gross National Income per Capita
# GniRAunk-HDIRank: Gross National Income Rank minus Human Development Index

## For gii: ##
# GIIRank: Gender Inequality Index Rank
# Country: Country
# GII: Gender Inequality Index
# MatMortRate: Maternal Mortality Rate
# PercParl: Female and male shares of parliamentary seats
# SecEduFem: female population with secondary education 
# SecEduMale: male population with secondary education 
# LabForceFem: female labor force participation rate
# LabForceMale: male labor force participation rate

colnames(hd) <- c("HDIRank","Country","HDI","LifeExp","EduYearsExp","EduYearsMean", "GNI", "GNIRank-HDIRank")
colnames(gii) <- c("GIIRank","Country","GII","MatMortRat","AdoBirthRate","PercParl", "SecEduFem", "SecEduMale", "LabForceFem", "LabForceMale")

#Let's check again

head(hd)
head(gii)

#### MUTATE "GENDER INEQUALITY" DATA
# access the dplyr library
library(dplyr)

# Create new ratio variables SecEduFem/SecEduMale and LabForceFem/LabForceMale
gii <- mutate(gii, SecEduRat = SecEduFem/SecEduMale)
gii <- mutate(gii, LabForceRat = LabForceFem/LabForceMale)
head(gii)


#### JOIN THE TWO DATASETS BY COUNTRIES ####

human <- inner_join(hd, gii, by = "Country")

#Checking dimensions
head(human)
dim(human)
dim(gii)
dim(hd)

# The joined dataset has 195 observations and 19 variables as it should have.

# Save the new joined data to the data folder
write.csv(human, file = './data/human.csv', row.names = FALSE) 


#### 2nd part ####
# Load again our human data (also available via "human" because it was build in this script, but for completeness let's check again)
human <- read.csv('./data/human.csv', header = T)
names(human)
dim(human)
str(human)

summary(human)
head(human)

#### MUTATE THE DATA: GNI AS NUMERIC ####
# load necessary packages and libraries tidyr and stringr

library(tidyr)
library(stringr)

# look at the structure of the GNI column before mutation
str(human$GNI)

# perform string manipulation (remove the commas) and save as numeric
human$GNI <- str_replace(human$GNI, pattern=",", replace ="") %>% as.numeric()

# print the GNI again to check that everything is as it should
human$GNI


#### EXCLUDE UNNEEDED VARIABLES
# select the columns to keep and overwrite the human df with only these remaining columns
keep <- c("Country", "SecEduRat", "LabForceRat",  "EduYearsExp", "LifeExp", "GNI", "MatMortRat", "AdoBirthRate", "PercParl")
human <- select(human, one_of(keep))
dim(human) #check: 195 observations, 9 variables


#### REMOVE ROWS WITH NA VALUES
# completeness indicator shows TRUE for rows without NA values and FALSE for rows with NA values
complete.cases(human)

# Print the completeless indicator as a last column
data.frame(human[-1], comp = complete.cases(human))

# filter out rows with NA values
human_ <- filter(human, complete.cases(human) == TRUE)

# Check and compare again
dim(human)
dim(human_)

#### REMOVE THE ROWS WITH REGIONS ####
# At the end of the df we find the rows with regions instead of countries - let's look at those and then remove them
tail(human_,n=10)
last <- nrow(human_) - 7 # last 7 entries are the ones not needed
human_ <- human_[1:last, ]

#### DEFINE ROW NAMES BY COUNTRY NAMES, REMOVE COUNTRY COLUMN ####
rownames(human_) <- human_$Country
head(human_)
human_ <- dplyr::select(human_, -Country)
head(human_) # Check ok

# overwrite old human file
#write.csv(human_, file = './data/human.csv',row.names=TRUE) -> this leads to a "row-names" column with variable x and thus 9 variables which I don't want. With write.table it works and keeps the countries as column-names.
write.table(human_, './data/human.csv')

dim(human_)
#human <- read.csv('./data/human.csv')

human <- read.table('./data/human.csv')
head(human)
dim(human)
