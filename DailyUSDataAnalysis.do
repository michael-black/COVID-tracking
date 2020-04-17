* Stata file for analyzing data for the U.S. from the covid tracking project: https://covidtracking.com
set more off
clear all
 
import delimited using "https://covidtracking.com/api/v1/states/daily.csv", clear


tostring date, replace
gen year = substr(date, 1, 4)
gen month = substr(date, 5, 2)
gen day = substr(date, 7, 2)
destring year, replace
destring month, replace
destring day, replace
gen date2 = mdy(month, day, year)
format date2 %d
drop date
rename date2 date
order date

*keep if inlist(state, "TX", "NY", "CA", "NJ")

tw sc death date, by(state)
