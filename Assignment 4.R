#*#BTC1855H - Assignment 4: Martians are coming - Data Wrangling 
#*Soumya Shastri

#Load required packages (Ensure these are already installed)
library(dplyr)

#Read the data from the CSV file into a data frame (Ensure the file is in your working directory)
ufo.data <- read.csv("ufo_subset.csv")
#To remove spaces in the column names and replace with "."
unspaced_data <- make.names(names(ufo.data))
print(unspaced_data)

#Replace missing values for shape with "unknown"
ufo.data$shape <- replace(ufo.data$shape, ufo.data$shape == "", "unknown")

#Remove rows without country information
ufo.data$country <- ufo.data %>% filter(ufo.data$country != "")


#Instructions: 
#BONUS: For some of the rows where Country column is blank, the country name is found in the City column in brackets. Where Country info is missing, try to extract the information in brackets in the City column and impute that value in the Country column.
#Convert Datetime and Date_posted columns into appropriate formats
#NUFORC officials comment on sightings that may be hoax.  Figure out a way (go through the Comments and decide how a proper filter should look like) to identify possible hoax reports. Create a new boolean column "is_hoax", and populate this column with TRUE if the sighting is a possible hoax, FALSE otherwise.
#Create a table reporting the percentage of hoax sightings per country.
#Add another column to the dataset (report_delay) and populate with the time difference in days, between the date of the sighting and the date it was reported.
#Remove the rows where the sighting was reported before it happened.
#Create a table reporting the average report_delay per country.
#Check the data quality (missingness, format, range etc) of the "duration seconds" column. Explain what kinds of problems you have identified and how you chose to deal with them, in your comments.
#Create a histogram using the "duration seconds" column.