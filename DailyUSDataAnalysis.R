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
tx_plot <- ggplot() +
  geom_point(aes(date, positiveIncrease), data = txpre)+
  geom_smooth(aes(date, positiveIncrease), data = txpre) +
  geom_vline(xintercept = as.numeric(ymd("2020-04-30")), color = "red") +
  geom_point(aes(date, positiveIncrease), data = txpos)+
  geom_smooth(aes(date, positiveIncrease), data = txpos) +
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

gapre <- data %>%
  filter(state == "GA", 
         date <= "2020-04-23")
gapos <- data %>%
  filter(state == "GA", 
         date >= "2020-04-24")
ga_plot <- ggplot() +
  geom_point(aes(date, positiveIncrease), data = gapre)+
  geom_smooth(aes(date, positiveIncrease), data = gapre, method = "loess") +
  geom_vline(xintercept = as.numeric(ymd("2020-04-24")), color = "red") +
  geom_point(aes(date, positiveIncrease), data = gapos)+
  geom_smooth(aes(date, positiveIncrease), data = gapos, method = "loess") +
  theme_classic() +
  labs(title = "New Infections in Georgia, Daily", x = "Date", y = "New Infections")


final<- grid.arrange(tx_plot, 
                     ga_plot,
                     #ar_plot, 
                     ct_plot, 
                     ny_plot)
                     #nrow = 1)
ggsave("final.png", plot = final)

#### Local Difference in Infection Rates for re-opened economies
txpre2 <- data %>%
  filter(state == "TX", 
         date <= "2020-04-30",
         date >= "2020-04-16")
txpos2 <- data %>%
  filter(state == "TX", 
         date >= "2020-05-01")
txloc <- ggplot() +
  geom_point(aes(date, positiveIncrease), data = txpre2)+
  geom_smooth(aes(date, positiveIncrease), data = txpre2, method = "gam") +
  geom_vline(xintercept = as.numeric(ymd("2020-04-30")), color = "red") +
  geom_point(aes(date, positiveIncrease), data = txpos2)+
  geom_smooth(aes(date, positiveIncrease), data = txpos2, method = "gam") +
  theme_classic() +
  labs(title = "New Infections in Texas, Daily", x = "Date", y = "New Infections")

gapre2 <- data %>%
  filter(state == "GA", 
         date <= "2020-04-23",
         date >= "2020-04-10")
gapos2 <- data %>%
  filter(state == "GA", 
         date >= "2020-04-24")
galoc <- ggplot() +
  geom_point(aes(date, positiveIncrease), data = gapre2)+
  geom_smooth(aes(date, positiveIncrease), data = gapre2, method = "gam") +
  geom_vline(xintercept = as.numeric(ymd("2020-04-24")), color = "red") +
  geom_point(aes(date, positiveIncrease), data = gapos2)+
  geom_smooth(aes(date, positiveIncrease), data = gapos2, method = "gam") +
  theme_classic() +
  labs(title = "New Infections in Georgia, Daily", x = "Date", y = "New Infections")

localdiff<- grid.arrange(txloc, galoc, nrow = 1)
ggsave("localdiff.png", plot = localdiff)

