library(dplyr)
library(shiny)
library(shinydashboard)
library(ggplot2)
library(DT)
library(splitstackshape) 
library(data.table)
library(leaflet)
library(shinythemes)
library(googleVis)
library(rsconnect)

test_dataset = fread("./Hotel_Reviews_newDataset2.csv")

select_nationality = test_dataset %>% 
  group_by(Reviewer_Nationality) %>% 
  tally()

summary_trip= test_dataset %>% group_by(type_trip) %>% tally()
summary_trip= summary_trip %>% 
  filter(!(type_trip=='With a pet'))

trip_list=summary_trip %>% select(type_trip)

traveller = test_dataset%>% group_by(Tags_04) %>% tally()
traveller = traveller %>% select(Tags_04)

test_dataset = test_dataset %>% mutate(., Year=substr(Review_Date,1,4))

test_dataset$Review_Date=as.Date(test_dataset$Review_Date)

years=test_dataset %>% group_by(Year) %>% tally()
years=years %>% select(Year)
