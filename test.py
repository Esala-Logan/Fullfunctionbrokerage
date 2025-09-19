from alpha_vantage.timeseries import TimeSeries

# Your API key here
API_KEY = "7ONWL271RTUPGUJ2"
ts = TimeSeries(key=API_KEY, output_format='json')

try:
    # Fetching the daily time series for 'AAPL' with compact output
    data, meta_data = ts.get_daily(symbol='AAPL', outputsize='compact')

    # Printing a success message and showing a snippet of the data
    print("Successfully fetched data:")
    print(data)  # You can print the first few items with `print(list(data.items())[:3])`
except ValueError as e:
    print(f"Error: {e}")
