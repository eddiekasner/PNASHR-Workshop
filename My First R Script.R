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

