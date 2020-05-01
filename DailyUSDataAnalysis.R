#R code for analyzing data for the U.S. from the COVID Tracking Project: https://covidtracking.com

# Install and load packages
pacman::p_load(dplyr, tidyr, ggplot2, gridExtra)

setwd("/Users/michaelblack/Documents/COVID-tracking")
data <- read.csv("https://covidtracking.com/api/v1/states/daily.csv")

data <- data %>%
  mutate(date = as.Date(as.character(date), "%Y%m%d"))

tx <- data %>%
  filter(state == "TX")
tx_plot <- ggplot(tx, aes(date, positiveIncrease))+
  geom_point() +
  geom_smooth() +
  theme_classic() +
  labs(title = "New Infections in Texas, Daily", x = "Date", y = "New Infections")

ar <- data %>%
  filter(state == "AR")
ar_plot <- ggplot(ar, aes(date, positiveIncrease))+
  geom_point() +
  geom_smooth() +
  theme_classic() +
  labs(title = "New Infections in Arkansas, Daily", x = "Date", y = "New Infections")

ct <- data %>%
  filter(state == "CT")
ct_plot <- ggplot(ct, aes(date, positiveIncrease))+
  geom_point() +
  geom_smooth() +
  theme_classic() +
  labs(title = "New Infections in Connecticut, Daily", x = "Date", y = "New Infections")

ny <- data %>%
  filter(state == "NY")
ny_plot <- ggplot(ny, aes(date, positiveIncrease))+
  geom_point() +
  geom_smooth() +
  theme_classic() +
  labs(title = "New Infections in New York, Daily", x = "Date", y = "New Infections")

final<- grid.arrange(tx_plot, ar_plot, ct_plot, ny_plot)
ggsave("final.png", plot = final)
