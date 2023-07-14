#*#BTC1855H - Assignment 4: Martians are coming - Data Wrangling 
#*Soumya Shastri

#Load required packages (Ensure these are already installed)
library(dplyr)

#Read the data from the CSV file into a data frame (Ensure the file is in your working directory)
ufo.data <- read.csv(("ufo_subset.csv"), na.strings = c("", "NA")) #na.strings function to replace all missing data, that was found while inspecting,with na

#To remove spaces in the column names and replace with "."
unspaced_data <- make.names(names(ufo.data))
print(unspaced_data)

#Replace missing values for shape with "unknown"
ufo.data1 <- ufo.data %>%
  mutate(shape = ifelse(is.na(shape), "unknown", shape)) %>%
  #Extract country info from city column and impute in country (Needs review, and how would we ensure that only 2 letters of the country go in the column)
  ifelse(country == "", 
         sub(".*\\((.*?)\\).*", "\\1", city), 
         country)
  #Remove rows where country column is blank 
  filter(!is.na(country))

#Convert Datetime and Date_posted columns into appropriate formats
ufo.data1$date_posted <- as.Date(strptime(ufo.data1$date_posted, format = "%d-%m-%Y"))
ufo.data1$datetime <- as.Date(strptime(ufo.data1$datetime, format = "%Y-%m-%d %H:%M")) ##Time disappeared??

#Find all combinations of the word "hoax" in Comments column and create new column "is_hoax"
ufo.data2 <- ufo.data1 %>%
  mutate(is_hoax = grepl("hoax|HOAX|Hoax", ufo.data1$comments))


  

#Instructions: 
#Create a table reporting the percentage of hoax sightings per country.
#Add another column to the dataset (report_delay) and populate with the time difference in days, between the date of the sighting and the date it was reported.
#Remove the rows where the sighting was reported before it happened.
#Create a table reporting the average report_delay per country.
#Check the data quality (missingness, format, range etc) of the "duration seconds" column. Explain what kinds of problems you have identified and how you chose to deal with them, in your comments.
#Create a histogram using the "duration seconds" column.