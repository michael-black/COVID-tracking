# Track COVID-19 for your state
Source: All data pulled from the [COVID Tracking Project](https://covidtracking.com).

Here is a step-by-step guide to setting up your own state's plot of (daily) new infections in R:
1. Install and load packages:
```
pacman::p_load(dplyr, tidyr, ggplot2, gridExtra, lubridate)
```
