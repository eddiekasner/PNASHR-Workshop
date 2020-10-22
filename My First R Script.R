######################################
#Description: My first code
#Author: Elena Austin
#Date: October 2020
#Version: 1
######################################

#####################
#Section 1 R Syntax
########################

#Creating variables

my_lucky_number <- 5
my_name <- "Elena"
my_favorite_ice_cream <- c("chocolate", "vanilla", "maple")

#use "libraries" of functions bundled as packages
#use a manager called pacman

#check that pacman is downloaded
if (!require("pacman")) 
  install.packages("pacman") 

#call library pacman to manage libraries
library(pacman)

#Load package to create descriptive table
p_load(table1)


#Read in data
#.csv format
mydata <- read.csv("Data/testdata.csv")
View(mydata)

#generate table
table1( ~ Petal.Width + Petal.Length | Species, data = mydata)

#Regression
fit <- lm(Petal.Width ~ Petal.Length, data = mydata)
class(fit)
summary(fit)
par(mfrow=c(2,2))
plot(fit)

#make regression output pretty (can generate LaTeX and html output)
p_load(stargazer)
stargazer(fit, type = "text", align = T)

#######
#download data from the web
###############

#use p_load to install and load new packages
p_load(data.table)
p_load(bit64)
p_load(readxl)

severeinjuries <- fread("https://www.osha.gov/severeinjury/xml/severeinjury.csv")

naics <- read_excel("Data/2012_NAICS_Structure.xls", 
                    skip = 2)
naics$`Change Indicator` = NULL

#create date variable
p_load(lubridate)
severeinjuries[, EventDate := 
                 parse_date_time(EventDate, "mdY")]
severeinjuries[, Year := 
                 year(EventDate)]
severeinjuries[, Month := 
                 month(EventDate)]


#create data table
naics <- setDT(naics)

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
    radius = 5,
  )


