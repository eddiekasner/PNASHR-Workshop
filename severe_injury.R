######################################
#Description: Severe Injury (OSHA)
#Author: Elena Austin
#Date: October 2020
#Version: 1
######################################

library(pacman)

#use p_load to install and load new packages
p_load(data.table)
p_load(bit64)
p_load(readxl)
p_load(table1)

#do not run on SPH server
severeinjuries <- fread("https://www.osha.gov/severeinjury/xml/severeinjury.csv")

#if on the sph server
unzip("Data/SevereInjuries20201021.zip", exdir = "Data")
severeinjuries = fread("Data/SevereInjuries20201021.csv")

#read excel file (skip first 2 rows)
naics <- read_excel("Data/2012_NAICS_Structure.xls", skip = 2)

#delete first column
naics$`Change Indicator` = NULL

#create date variable
p_load(lubridate)

severeinjuries[, EventDate := 
                 parse_date_time(EventDate, c("mdY", "Ymd"))]
severeinjuries[, Year := 
                 year(EventDate)]
severeinjuries[, Month := 
                 month(EventDate)]


#create data table
naics <- setDT(naics)

#order datasets based on column name
setkey(severeinjuries, "Primary NAICS")
setkey(naics, "2012 NAICS Code")

severeinjuries <- naics[severeinjuries]

#Find all ag injuries (NAICS 11)

#how to match patterns
#use regular expressions
#resource for learning: https://www.regextester.com/

#find all strings that begin with "11" (NAICS code for agriculture)

grep("^11", c("112120", "411532"))
#Note that this returns the place value in the vector

#This returns the value that matches
grep("^11", c("112120", "411532"), value = T)

#select ag sector injuries only

severeinjuries_ag = 
  severeinjuries[grep("^11", `2012 NAICS Code`),]

severeinjuries_ag[, Hospitalized := 
                    factor(Hospitalized, 
                           labels = c("No","Yes","Unknown"))]
severeinjuries_ag[, Amputation := 
                    factor(Amputation,
                           labels = c("No","Yes","Unknown"))]


table1(~ Hospitalized  + Amputation | Year  , 
       data = severeinjuries_ag)

#plot events
p_load(leaflet)
p_load(leaflet.extras)

leaflet() %>%
  addProviderTiles("Stamen.TonerHybrid") %>%
  addHeatmap(data = severeinjuries_ag,
             lng = ~Longitude, lat = ~Latitude,
             radius = 5 )
