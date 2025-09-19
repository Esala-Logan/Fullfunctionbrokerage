import requests
from alpha_vantage.cryptocurrencies import CryptoCurrencies
from avConfig import API_KEY

cc = CryptoCurrencies(key=API_KEY, output_format='json')

def fetch_daily_data(symbol):
    # Determine asset type based on symbol
    if symbol == 'BTC':
        asset_type = 'crypto'
    else:
        asset_type = 'stock'

    if asset_type == 'stock':
        # Use raw request instead of wrapper
        url = "https://www.alphavantage.co/query"
        params = {
            'function': 'TIME_SERIES_DAILY',
            'symbol': symbol,
            'outputsize': 'full',
            'apikey': API_KEY
        }
        response = requests.get(url, params=params)
        data = response.json()

        if "Time Series (Daily)" not in data:
            raise ValueError(f"Invalid API response for symbol {symbol}: {data}")

        return {
            date: {
                'open': float(values['1. open']),
                'high': float(values['2. high']),
                'low': float(values['3. low']),
                'close': float(values['4. close']),
                'volume': int(values['5. volume'])
            }
            for date, values in data["Time Series (Daily)"].items()
        }

    elif asset_type == 'crypto':
        data, _ = cc.get_digital_currency_daily(symbol=symbol, market='USD')
        return {
            date: {
                'open': float(values['1a. open (USD)']),
                'high': float(values['2a. high (USD)']),
                'low': float(values['3a. low (USD)']),
                'close': float(values['4a. close (USD)']),
                'volume': float(values['5. volume'])
            }
            for date, values in data.items()
        }

    else:
        raise ValueError(f"Unsupported asset_type: {asset_type}")
