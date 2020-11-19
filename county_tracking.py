import pandas as pd
import requests
import io
import matplotlib.pyplot as plt
import matplotlib.dates as mdates
import numpy as np
import datetime as dt
   
url = "https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv" 
download = requests.get(url).content
rdf = pd.read_csv(io.StringIO(download.decode('utf-8')))

## Brazos County, Texas
df = rdf[rdf['county'].str.contains("Brazos")].copy()
df['lagcases'] = df['cases'].shift(1)
df['daily_new'] = df['cases'] - df['lagcases']
df['ma7'] = df['daily_new'].rolling(window = 7).mean()
fig, ax = plt.subplots()
ax.plot(df['date'], df['ma7'])
ax.scatter(df['date'], df['daily_new'], s=10, c = 'black')
ax.axvline(x="2020-06-30", c = 'r')
ax.axvline(x="2020-08-19", c = 'r')
# ax.annotate(text = "Mask Mandate >", xy = ("2020-05-19",300))
# ax.annotate(text = "TAMU Reopens >", xy = ("2020-07-07",200))
fig.autofmt_xdate()
ax.fmt_xdata = mdates.DateFormatter('%Y-%m-%d')
ax.set_title('Daily New Cases for Brazos County, TX')
plt.gca().xaxis.set_major_locator(mdates.DayLocator(interval=20))
plt.savefig('brazos_dnc.png', dpi = 1200)

## Washington, DC
dc = rdf[rdf['county'].str.contains("District of Columbia")].copy()
dc['lagcases'] = dc['cases'].shift(1)
dc['daily_new'] = dc['cases'] - dc['lagcases']
dc['ma7'] = dc['daily_new'].rolling(window = 7).mean()
fig, ax = plt.subplots()
ax.plot(dc['date'], dc['ma7'])
ax.scatter(dc['date'], dc['daily_new'], s=10, c = 'black')
## Full timeline of DC regulations: https://www.dcpolicycenter.org/publications/covid-19-timeline/
# ax.axvline(x="2020-06-30", c = 'r')
fig.autofmt_xdate()
ax.fmt_xdata = mdates.DateFormatter('%Y-%m-%d')
ax.set_title('Daily New Cases for District of Columbia')
plt.gca().xaxis.set_major_locator(mdates.DayLocator(interval=20))
plt.savefig('dc_dnc.png', dpi = 1200)

## Washington County, Arkansas
w_ar = rdf[rdf['county'].str.contains("Washington") & rdf['state'].str.contains("Arkansas")].copy()
w_ar['lagcases'] = w_ar['cases'].shift(1)
w_ar['daily_new'] = w_ar['cases'] - w_ar['lagcases']
w_ar['ma7'] = w_ar['daily_new'].rolling(window = 7).mean()
fig, ax = plt.subplots()
ax.plot(w_ar['date'], w_ar['ma7'])
ax.scatter(w_ar['date'], w_ar['daily_new'], s=10, c = 'black')
fig.autofmt_xdate()
ax.fmt_xdata = mdates.DateFormatter('%Y-%m-%d')
ax.set_title('Daily New Cases for Washington County, AR')
plt.gca().xaxis.set_major_locator(mdates.DayLocator(interval=20))
plt.savefig('washington_ar_dnc.png', dpi = 1200)


