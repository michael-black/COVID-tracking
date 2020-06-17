#R code for analyzing data for the U.S. from the COVID Tracking Project: https://covidtracking.com

# Install and load packages
pacman::p_load(dplyr, tidyr, ggplot2, gridExtra, lubridate)

setwd("/Users/michaelblack/Documents/COVID-tracking")
data <- read.csv("https://covidtracking.com/api/v1/states/daily.csv")

data <- data %>%
  mutate(date = as.Date(as.character(date), "%Y%m%d"))

txpre <- data %>%
  filter(state == "TX", 
         date <= "2020-04-30")
txpos <- data %>%
  filter(state == "TX", 
         date >= "2020-05-01")

death <- ggplot() +
  geom_point(aes(date, death), data = txpre)+
  geom_smooth(aes(date, death), data = txpre) +
  geom_vline(xintercept = as.numeric(ymd("2020-04-30")), color = "red") +
  geom_point(aes(date, death), data = txpos)+
  geom_smooth(aes(date, death), data = txpos) +
  theme_classic() +
  labs(title = "Total Deaths in Texas", x = "Date", y = "Deaths")

curve <- ggplot() +
  geom_point(aes(date, positiveIncrease), data = txpre)+
  geom_smooth(aes(date, positiveIncrease), data = txpre) +
  geom_vline(xintercept = as.numeric(ymd("2020-04-30")), color = "red") +
  geom_point(aes(date, positiveIncrease), data = txpos)+
  geom_smooth(aes(date, positiveIncrease), data = txpos) +
  theme_classic() +
  labs(title = "New Infections in Texas, Daily", x = "Date", y = "New Infections")

hospital <- ggplot() +
  geom_point(aes(date, hospitalizedCurrently), data = txpre)+
  geom_smooth(aes(date, hospitalizedCurrently), data = txpre) +
  geom_vline(xintercept = as.numeric(ymd("2020-04-30")), color = "red") +
  geom_point(aes(date, hospitalizedCurrently), data = txpos)+
  geom_smooth(aes(date, hospitalizedCurrently), data = txpos) +
  theme_classic() +
  labs(title = "Hospitalizations in Texas", x = "Date", y = "Number Hospitalized")


final<- grid.arrange(curve, 
                     hospital,
                     death, nrow=1)
ggsave("final.png", plot = final)
