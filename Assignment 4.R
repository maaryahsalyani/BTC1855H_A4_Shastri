#*#BTC1855H - Assignment 4: Martians are coming - Data Wrangling 
#*Soumya Shastri

#Load required packages (Ensure these are already installed)
library(dplyr)

#Read the data from the CSV file into a data frame (Ensure the file is in your working directory)
ufo.data <- read.csv(("ufo_subset.csv"), na.strings = c("", "NA")) #na.strings function to replace all missing data, that was found while inspecting,with na

#To remove spaces in the column names
unspaced_data <- make.names(names(ufo.data))
print(unspaced_data)

#Replace missing values for shape with "unknown"
ufo.data1 <- ufo.data %>%
  mutate(shape = ifelse(is.na(shape), "unknown", shape)) %>%
  #Extract country info from city column and impute in country ######(Needs review, and how would we ensure that only 2 letters of the country go in the column)######
  ifelse(country == "", 
         sub(".*\\((.*?)\\).*", "\\1", city), 
         country)
  #Remove rows where country column is blank 
  filter(!is.na(country))

#Convert Datetime and Date_posted columns into appropriate formats
ufo.data1$date_posted <- as.Date(strptime(ufo.data1$date_posted, format = "%d-%m-%Y"))
ufo.data1$datetime <- as.Date(strptime(ufo.data1$datetime, format = "%Y-%m-%d %H:%M")) ####Time disappeared??####

#Find all combinations of the word "hoax" in Comments column and create new column "is_hoax"
ufo.data2 <- ufo.data1 %>%
  mutate(is_hoax = grepl("hoax|HOAX|Hoax", ufo.data1$comments))

#Create a table of hoax sightings and country
hoax_table <- table(ufo.data2$country, ufo.data2$is_hoax)
#Create a table with percentage of sightings per country
hoax_percentage <- prop.table(hoax_table, margin = 1) * 100 
print(hoax_percentage)  

#Add a report_delay column to dataset
ufo.data3 <- ufo.data2 %>% mutate(report_delay = as.numeric(date_posted - datetime)) %>%
  #Remove the rows that have a negative value (reported before sighted)
  filter(report_delay >= 0) 

#Create table reporting average report delay per country ####Needs review, only giving me one number#####
average_report_delay <- ufo.data3 %>%
  group_by(country) %>%
  summarize(average_delay = mean(report_delay, na.rm = T))


#Instructions: 
#Check the data quality (missingness, format, range etc) of the "duration seconds" column. Explain what kinds of problems you have identified and how you chose to deal with them, in your comments.
#Create a histogram using the "duration seconds" column.