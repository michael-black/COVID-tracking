clear
set more off
local path "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports"
****************************************************************************************
********************** Set State/County and Current Date Here **************************
****************************************************************************************
// Set local directory
cd "/Users/michaelblack/Downloads"

// Set state and county of interest
local state "Texas"
local county "Brazos"

// Set current day in May
local mayday 21
****************************************************************************************
****************************************************************************************
****************************************************************************************

// Get March Data (Starts March 22nd)
forvalues i = 22(1)31{
	import delimited using "`path'/03-`i'-2020.csv", clear
	keep if province_state == "`state'"
	keep if admin2 == "`county'"
	gen datestr = "03-`i'-2020"
	save "`county'_03_`i'_2020.dta", replace
}
// Get April Data 
forvalues i = 1(1)9{
	import delimited using "`path'/04-0`i'-2020.csv", clear
	keep if province_state == "`state'"
	keep if admin2 == "`county'"
	gen datestr = "04-0`i'-2020"
	save "`county'_04_0`i'_2020.dta", replace
}
forvalues i = 10(1)30{
	import delimited using "`path'/04-`i'-2020.csv", clear
	keep if province_state == "`state'"
	keep if admin2 == "`county'"
	gen datestr = "04-`i'-2020"
	save "`county'_04_`i'_2020.dta", replace
}
// Get May Data 
forvalues i = 1(1)9{
	import delimited using "`path'/05-0`i'-2020.csv", clear
	keep if province_state == "`state'"
	keep if admin2 == "`county'"
	gen datestr = "05-0`i'-2020"
	save "`county'_05_0`i'_2020.dta", replace
}
forvalues i = 10(1)`mayday'{
	import delimited using "`path'/05-`i'-2020.csv", clear
	keep if province_state == "`state'"
	keep if admin2 == "`county'"
	gen datestr = "05-`i'-2020"
	save "`county'_05_`i'_2020.dta", replace
}

// Append all data
use "`county'_03_22_2020.dta", clear
forvalues i = 23(1)31{
	append using "`county'_03_`i'_2020.dta"
}
forvalues i = 1(1)9{
	append using "`county'_04_0`i'_2020.dta"
}
forvalues i = 10(1)30{
	append using "`county'_04_`i'_2020.dta"
}
forvalues i = 1(1)9{
	append using "`county'_05_0`i'_2020.dta"
}
forvalues i = 10(1)`mayday'{
	append using "`county'_05_`i'_2020.dta"
}
save "`county'.dta", replace

// Erase daily datasets
forvalues i = 22(1)31{
	erase "`county'_03_`i'_2020.dta"
}
forvalues i = 1(1)9{
	erase "`county'_04_0`i'_2020.dta"
}
forvalues i = 10(1)30{
	erase "`county'_04_`i'_2020.dta"
}
forvalues i = 1(1)9{
	erase "`county'_05_0`i'_2020.dta"
}
forvalues i = 10(1)`mayday'{
	erase "`county'_05_`i'_2020.dta"
}

// Format date variable
split datestr, parse("-")
forvalues i = 1(1)3{
	destring datestr`i', replace
}
rename datestr1 month
rename datestr2 day
rename datestr3 year
gen date = mdy(month, day, year)
format date %td
sort date

// Create new daily cases
gen newcases = confirmed - confirmed[_n-1]	   
order date confirmed newcases

// Plot new daily cases and a polynomial of degree 4
twoway fpfitci newcases date, estopts(degree(4)) || scatter newcases date

/*
// Create Rich's Rt
gen recentnew = (confirmed[_n-1]-confirmed[_n-(14+1)])
gen Rt = (14)*(newcases/recentnew)
tw line Rt date
