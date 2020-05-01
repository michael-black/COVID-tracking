* Stata file for analyzing data for the U.S. from the covid tracking project: https://covidtracking.com
set more off
clear all

cd "/Users/michaelblack/Documents/COVID-tracking"
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


// Tracking new infections for my family
preserve
	keep if state == "TX"
	tw (sc positiveincrease date) (lowess positiveincrease date), saving(TX, replace) leg(off) title("TX")
restore

preserve
	keep if state == "AR"
	tw (sc positiveincrease date) (lowess positiveincrease date), saving(AR, replace) leg(off) title("AR")
restore

preserve
	keep if state == "CT"
	tw (sc positiveincrease date) (lowess positiveincrease date), saving(CT, replace) leg(off) title("CT")
restore

preserve
	keep if state == "NY"
	tw (sc positiveincrease date) (lowess positiveincrease date), saving(NY, replace) leg(off) title("NY")
restore


gr combine TX.gph AR.gph CT.gph NY.gph
gr export newinfections_fam.png, replace
