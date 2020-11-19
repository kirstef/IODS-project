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
colnames(gii) <- c("GIIRank","Country","GII","MatMortRate","AdoBirthRate","PercParl", "SecEduFem", "SecEduMale", "LabForceFem", "LabForceMale")

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

# The joined dataset has 195 ovservations and 19 variables as it should have.

# Save the new joined data to the data folder
write.csv(human, file = './data/human.csv')
