# library for global app
library(shiny) # shiny features
library(shinydashboard) # shinydashboard functions
library(DT)  # for DT tables
library(dplyr)  # for pipe operator & data manipulations
library(plotly) # for data visualization and plots using plotly 
library(ggplot2) # for data visualization & plots using ggplot2
library(ggtext) # beautifying text on top of ggplot
library(maps) # for USA states map - boundaries used by ggplot for mapping
library(ggcorrplot) # for correlation plot
library(shinycssloaders) # to add a loader while graph is populating
library(janitor)
library(rio) #import export
library(tidyverse)
library(naniar)
library(mice)

# -------------------------------- note function
# names() - get columns
# omit() - delete row blank
# gg_miss_var(my_data_raw, show_pct = TRUE) - DRAW % var is NA
# n_miss(my_data_raw$Joined) - get count NA
# pct_miss(my_data_raw) - get % var is NA
# head(5) - get 5 row
# is.na(X) - check true false NA
#


# ----------------------------------------------

# read data object
my_data_raw <- read.csv("players_20.csv", header = TRUE, sep = ",", na= c("", " "))

# clear dataset
my_data <- my_data_raw %>% 
  janitor::clean_names() %>%
    na.omit(my_data_raw)



  
  
  
  

