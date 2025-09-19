import psycopg2
from avConfig import DB_CONFIG

def store_data_to_db(data, symbol):
    conn = psycopg2.connect(**DB_CONFIG)
    cur = conn.cursor()

    # Get the security_id using the symbol
    cur.execute("SELECT security_id FROM Securities WHERE symbol = %s;", (symbol,))
    result = cur.fetchone()

    if not result:
        print(f"{symbol} not found in Securities table.")
        conn.close()
        return

    security_id = result[0]

    for date, values in data.items():
        try:
            cur.execute("""
            INSERT INTO market_data (
                security_id, symbol, date, open_price, high_price, low_price, close_price, volume
            ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
            ON CONFLICT (security_id, date) DO NOTHING;
            """, (
                security_id,
                symbol,  # <- new field
                date,
                values['open'],
                values['high'],
                values['low'],
                values['close'],
                int(values['volume'])
            ))
        except Exception as e:
            print(f"Error inserting {symbol} on {date}: {e}")
            raise

    conn.commit()
    cur.close()
    conn.close()
