# Stefanie Kirschenmann, 2020/12/01: Script for the data wrangling part for week 6 of the IODS course (Analysis of Longitudinal Data).

#### READING IN THE "BPRS" AND "RATS" DATA ####
BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", sep =" ", header = T)
RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", sep ="\t", header = T)


#### QUICK LOOK AT THE VARIABLE NAMES, CONTENTS, DIMENSIONS, STRUCTURE, SUMMARIES ####


## BPRS
names(BPRS) # subject ID, treatment group, weeks
dim(BPRS)# BPRS has 40 observations and 11 variables
str(BPRS) 
head(BPRS) # Dataset involves integer values for different subjects in different weeks, with subjects belonging to either treatment group 1 or 2.
summary(BPRS) # Mean value of the different weeks is going down from week0 to week8

# The data is in the wide form data. We have every week as a separate variable.

## RATS
names(RATS)
dim(RATS) # BPRS has 16 observations and 13 variables
str(RATS)
head(RATS)
summary(BPRS) 

# Access the packages dplyr and tidyr
library(dplyr)
library(tidyr)

#### CONVERSION OF CATEGORICAL VARIABLES TO FACTORS ####

#BPRS
BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)
str(BPRS) # check if it worked

#RATS
RATS$ID <- factor(RATS$ID)
RATS$Group <- factor(RATS$Group)

#### CONVERSION TO LONG FORM ####

#BPRS
BPRSL <-  BPRS %>% gather(key = weeks, value = bprs, -treatment, -subject)
BPRSL <-  BPRSL %>% mutate(week = as.integer(substr(weeks, 5,5))) # Adding week variable to BPRsL: Extracting the week number and put the values into the new column "week"

#RATS
RATSL <- RATS %>% gather(key = days, value = weight, -ID, -Group)
RATSL <- RATSL %>% mutate(Time = as.integer(substr(days, 3, 4)))


#### COMPARISON OF WIDE AND LONG DATASETS ####

# Take a glimpse at the long BPRSL data with glimpse() and head()
glimpse(BPRSL)
glimpse(RATSL)

# Compare wide and long format via head
head(BPRS)
head(BPRSL) # In the long format the different weeks are gathered in the column "weeks" and the respective values can be found in the new bprs column.

head(RATS)
head(RATSL) # In the long format the different days are gathered in the column "days" and the respective values can be found in the new width column.

dim(BPRSL) # The dataset has now only 5 variables, but 360 observations
dim(RATSL) # The dataset has now only 5 variables, but 176 observations

str(BPRSL)
str(RATSL)

summary(BPRSL[, c(4,5)]) # Gives a good informative summary of our variables, although the values for treatment and subject don't make sense like this
summary(BPRSL[, c(4,5)]) # Looking only at the last columns
summary(RATSL) # Gives a good informative summary of our variables,  although the values for ID (mean value) don't make sense like this

## We have now the following variables:##
# BPRS DATASET:
# treatment: factor, tells us, whether the individual belongs to treatment group 1 or 2
# subject: factor, gives the ID of the individual in the treatment group: ID 1 with treatment 1 is not the same as ID 1 with treatment 2!
# weeks: string, gives the week number in a string version
# bprs: integer, gives the bprs value for the individual of ID (subject), treatment group (treatment) and for the given week (week)
# week: integer, integer value of the week number

# RATS DATASET
# ID: factor value, ID of the rat in a certain group
# Group: factor, gives the group the rat is belonging to
# days: string, gives the day number in a string version
# weight: integer, gives the width for the rat with ID X in group X at a certain Time X
# Time: integer, integer version of the day

write.csv(BPRSL, './data/bprsl.csv', row.names = FALSE)
write.csv(RATSL, './data/ratsl.csv', row.names = FALSE)

bprsltest <- read.csv('./data/bprsl.csv', stringsAsFactors = T) #CHECK
head(bprsltest)
ratsltest <- read.csv('./data/ratsl.csv') #CHECK
head(ratsltest)

#### VISUALISATIONS ####
#Access the package ggplot2
library(ggplot2)

# Draw the plot
ggplot(bprsltest, aes(x = week, y = bprs, linetype = subject)) +
  geom_line() +
  scale_linetype_manual(values = rep(1:10, times=4)) +
  facet_grid(. ~ treatment, labeller = label_both) +
  theme(legend.position = "none") + 
  scale_y_continuous(limits = c(min(BPRSL$bprs), max(BPRSL$bprs)))

