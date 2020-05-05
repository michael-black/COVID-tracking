#R code for analyzing data for the U.S. from the COVID Tracking Project: https://covidtracking.com

# Install and load packages
pacman::p_load(dplyr, tidyr, ggplot2, gridExtra, lubridate)

setwd("/Users/michaelblack/Documents/COVID-tracking")
data <- read.csv("https://covidtracking.com/api/v1/states/daily.csv")

data <- data %>%
  mutate(date = as.Date(as.character(date), "%Y%m%d"))

tx <- data %>%
  filter(state=="TX") %>%
  arrange(date)

plot(tx$date, tx$positiveIncrease)
plot(lm(positiveIncrease ~ date, data = tx), which = 2)
pred <- predict(lm(positiveIncrease ~ poly(date, 10), data = tx))
pred <- as.data.frame(pred)
pred$id <- 1:nrow(pred)