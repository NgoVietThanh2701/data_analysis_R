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
# names() - get name var
# omit() - delete row blank
# gg_miss_var(my_data_raw, show_pct = TRUE) - DRAW % var is NA
# n_miss(my_data_raw$Joined) - get count NA
# pct_miss(my_data_raw) - get % var is NA
# is.na(X) - check true false NA
# mean(column) : trung binh 


# ---------------------------------------------- choose dataset -----------------------------

# read data object
my_data_raw <- read.csv("players_20.csv", header = TRUE, sep = ",", na= c("", " "))

# clear dataset
my_data <- my_data_raw %>% 
  janitor::clean_names() %>%
    na.omit(my_data_raw)

# get 50 obs
my_data_head100 <- my_data %>% head(100)

# ---------------------------------------------- statistical & chart ----------------------

# chooose select var
c1 = my_data %>%  
  select("overall", "potential", "value", "wage", "age") %>% 
  names()


# ---------------------------------------- linear regression ---------------------------------
# 
#   median ~= 0 the best
#   R-squared: khác biệt về X giải thích được % về khác biệt Y
#   mô hình: Y = a + b*X + e (a: gtri đầu tiên, b: tham số(độ dốc) X, e: phần dư)
#   anova(lm) - bang phan tich phuong sai
#   confint(linear_model) // khoang tin cay uoc luong
#   var(X) : xem phuong sai
#     
#-----------------------------------------

# linear_model <- lm(my_data$weight ~ my_data$height, data = my_data) 
# summary(linear_model)
# var(my_data$weight)
# anova(linear_model)
# # pt: weight =  -80.56 + 0.866*height
# # height = 170 -> weight = 66.66kg
# # height = 175 -> weight = 70.1kg
# plot(my_data$height, my_data$weight, pch=18, ylab="Cân nặng", xlab = "Chiều cao", col='blue')
# abline(linear_model, lwd=2, col='red')

  
  
  

