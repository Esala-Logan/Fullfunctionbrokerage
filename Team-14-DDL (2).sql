CREATE TABLE Users (
    user_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    DOB DATE NOT NULL
);

CREATE TABLE Accounts (
    account_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id) ON DELETE CASCADE,
    account_type VARCHAR(20),
    cash_balance DECIMAL(15, 2) DEFAULT 0.00,
    status VARCHAR(20) CHECK (status IN ('active', 'suspended', 'closed')) DEFAULT 'active'
);

CREATE TABLE Securities (
    security_id SERIAL PRIMARY KEY,
    symbol VARCHAR(10) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    asset_type VARCHAR(20) CHECK (asset_type IN ('stock', 'bond', 'ETF', 'crypto')) NOT NULL,
    exchange VARCHAR(20) NOT NULL,
    current_price DECIMAL(15,2) DEFAULT 0.00
);


CREATE TABLE Market_Data (
    data_id SERIAL PRIMARY KEY,
    security_id INT NOT NULL,
    date DATE NOT NULL,
    open_price DECIMAL(15,2) NOT NULL,
    close_price DECIMAL(15,2) NOT NULL,
    high_price DECIMAL(15,2) NOT NULL,
    low_price DECIMAL(15,2) NOT NULL,
    volume BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_market_data FOREIGN KEY (security_id) REFERENCES Securities(security_id),
    UNIQUE (security_id, date) 
);


CREATE TABLE Holdings (
    holding_id SERIAL PRIMARY KEY,
    account_id INT REFERENCES Accounts(account_id) ON DELETE CASCADE,
    security_id INT REFERENCES Securities(security_id) ON DELETE CASCADE,
    quantity INT CHECK (quantity >= 0) NOT NULL,
    average_price DECIMAL(15, 2) NOT NULL
);

CREATE TABLE Orders (
    order_id SERIAL PRIMARY KEY,
    account_id INT REFERENCES Accounts(account_id) ON DELETE CASCADE,
    security_id INT REFERENCES Securities(security_id) ON DELETE CASCADE,
    order_type VARCHAR(10) CHECK (order_type IN ('buy', 'sell')) NOT NULL,
    quantity INT CHECK (quantity > 0) NOT NULL,
    price_executed DECIMAL(15,2), 
    total_value DECIMAL(15,2), 
    order_status VARCHAR(20) CHECK (order_status IN ('open', 'partially filled', 'filled', 'canceled')) NOT NULL DEFAULT 'open',
    executed_at TIMESTAMP 
);

CREATE TABLE Transactions (
    transaction_id SERIAL PRIMARY KEY,
    account_id INT REFERENCES Accounts(account_id) ON DELETE CASCADE,
    transaction_type VARCHAR(20) CHECK (transaction_type IN ('deposit', 'withdrawal', 'fee')) NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    method VARCHAR(20),
    status VARCHAR(20) CHECK (status IN ('pending', 'completed')) NOT NULL DEFAULT 'pending',
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);



