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
  #Remove rows where country column is blank 
  filter(!is.na(country))

#Convert Datetime and Date_posted columns into appropriate formats
ufo.data1$date_posted <- as.Date(strptime(ufo.data1$date_posted, format = "%d-%m-%Y"))
ufo.data1$datetime <- as.Date(strptime(ufo.data1$datetime, format = "%Y-%m-%d %H:%M"))

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

#Create table reporting average report delay per country
average_report_delay <- aggregate(report_delay ~ country, ufo.data3, mean)
print(average_report_delay)

#Data quality of "duration seconds" column and how dealt with
#* Structure: The values in this column are numeric.
is.numeric(ufo.data3$duration.seconds) #output is TRUE
#*The values are all positive 
any(ufo.data3$duration.seconds < 0) #Output returns FALSE
#* Missing values: 
which(is.na(ufo.data3$duration.seconds)) #Output returned as zero, indicating that there are no missing values in this column
#* Format: The decimal precision in the values of the column is inconsistent. Some values have one decimal place, some have two decimal places, and some have no decimal places at all.
#*In order to fix it, create a sprintf function to indicate that the number should be displayed with two decimal places
sprintf("%.2f", ufo.data$duration.seconds)
#*Range: Some values range to years in duration. This seems erroneous, as UFO sightings should not be longer than a day. I would remove anything higher than 86400 seconds.
ufo.data4 <- ufo.data3 %>%
  filter(duration.seconds < 86400) %>%
  filter(duration.seconds > 0) 

#Histogram of duration seconds; log10 used for better visualization 
hist(log10(ufo.data4$duration.seconds), main= "Histogram of Duration Seconds",xlab = "log10 of Duration seconds",ylab="Frequency")
