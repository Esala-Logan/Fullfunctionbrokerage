from alphaVantageHelper import fetch_daily_data
from dbConfigs import store_data_to_db
import time

def main():
    symbols = ['MSFT', 'AMZN', 'GOOGL', 'TSLA', 'META', 'NVDA', 'JPM', 'V', 'JNJ', 'BTC']
    for symbol in symbols:
        print(f"\n Fetching data for {symbol}...")
        try:
            data = fetch_daily_data(symbol)
            print(f"Data fetched for {symbol}, total days: {len(data)}")
        except Exception as e:
            print(f"Error fetching data for {symbol}: {e}")
            continue

        store_data_to_db(data, symbol)
        time.sleep(15)

if __name__ == '__main__':
    main()
