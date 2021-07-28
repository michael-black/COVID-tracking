# Track COVID-19 for selected counties
Source: All data pulled from the [NY Times COVID-19 Data Repository](https://github.com/nytimes/covid-19-data).

The "county_tracking.py" script displays the daily new cases and a 7-day moving average for selected counties. Currently, the script is set up to track Brazos County, TX, Washington County, AR, and Washington, D.C.

The following line selects your state and county of interest (Washington County, AR example):
```
w_ar = rdf[rdf['county'].str.contains("Washington") & rdf['state'].str.contains("Arkansas")].copy()
```
Next, create a lag of total cases, and take the difference between total and one-day lagged cases to get daily new cases.
```
w_ar['lagcases'] = w_ar['cases'].shift(1)
w_ar['daily_new'] = w_ar['cases'] - w_ar['lagcases']

```
Finally, create the seven day moving average:
```
w_ar['ma7'] = w_ar['daily_new'].rolling(window = 7).mean()
```

## Notes:

You can create a vertical line for days of particular interest using the following:
```
ax.axvline(x="<YYYY-MM-DD>", c = 'r')
```

## Trouble?
If you want more help or run into any issues, feel free to [contact me](mailto:mblack438@gmail.com)!
