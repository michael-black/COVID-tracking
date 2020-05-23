# Track COVID-19 for your state
Source: All data pulled from the [COVID Tracking Project](https://covidtracking.com).

The following is a step-by-step breakdown of the "State Tracking.R" script in this repository.
1. Install and load packages:
```
pacman::p_load(dplyr, tidyr, ggplot2, gridExtra, lubridate)
```

2. Set your working directory and import the data. Your working directory will be the home for your visualization. You are importing data from an online resource.
```
setwd("<your directory here>")
data <- read.csv("https://covidtracking.com/api/v1/states/daily.csv")
```

3. Reformat the date variable to make it easier to work with:
```
data <- data %>%
  mutate(date = as.Date(as.character(date), "%Y%m%d"))
```

4. For a state that had no re-openings, first create a new dataset with only that state's information. You'll need to know the state's abbreviation.
```
ct <- data %>%
  filter(state == "CT")
```
Next, create the plot! Here I am using the variable `positiveIncrease`, which measures the rate of new positive cases per day. The data contains many more metrics, so I encourage you to look at others. If you want to look at a different variable, just replace `positiveIncrease` with your variable, and then replace `y = "New Infections"` with the correct label for your chosen variable.
```
ct_plot <- ggplot(ct, aes(date, positiveIncrease))+
  geom_point() +
  geom_smooth() +
  theme_classic() +
  labs(title = "New Infections in Connecticut, Daily", x = "Date", y = "New Infections")
```

If you want to graph some variable before and after a re-opening, you'll have to split your data. Here is an example for Texas, which partially re-opened on May 1st, 2020:
```
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
```
Notice that you'll need to create two datasets, in this case `txpre` and `txpos` for Texas pre- and post-opening. For different states, make sure you get the dates right.

## Trouble?
If you want more help or run into any issues, feel free to [contact me](mailto:mblack438@gmail.com)!
