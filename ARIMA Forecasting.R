#R code for analyzing data for the U.S. from the COVID Tracking Project: https://covidtracking.com

# Install and load packages
pacman::p_load(dplyr, tidyr, ggplot2, gridExtra, lubridate, rdd, forecast)

setwd("/Users/michaelblack/Documents/COVID-tracking")
data <- read.csv("https://covidtracking.com/api/v1/states/daily.csv")

data <- data %>%
  mutate(date = as.Date(as.character(date), "%Y%m%d"))

tx <- data %>%
  filter(state == "TX") %>%
  select(infinc = "positiveIncrease", date) %>%
  arrange(date)
txts <- ts(tx$infinc, start = as.Date("2020-03-04"), frequency = 7)

autoArimaFit <- auto.arima(txts)
plot(forecast(autoArimaFit, h=30))
