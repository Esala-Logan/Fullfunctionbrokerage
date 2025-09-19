INSERT INTO Users (user_id, first_name, last_name, email, phone, DOB) VALUES
(1, 'Degenerate Gambler', 'Ramirez', 'miguel99@gmail.com', '+1-085-572-1965', '1951-05-31'),
(2, 'Richie', 'Jones', 'bradleysamantha@gmail.com', '139-396-0156', '1969-06-09'),
(3, 'Betty Bettington', 'Spencer', 'Spencer77@ford.info', '+1-484-237-5469', '1953-08-02'),
(4, 'John', 'Jackson', 'riverjohn@evans.org', '791-787-0249', '2004-08-02'),
(5, 'Brandon', 'Hunter', 'theresbrandon@hotmail.com', '185-435-1755', '1989-06-28'),
(6, 'Johnny', 'Armstrong', 'klove@gmail.com', '008-601-6830', '1985-10-14'),
(7, 'Lenny', 'Cook', 'Lenny@aol.com', '(241)456-4110', '1945-10-12'),
(8, 'Gamble-Guru Greg', 'Burke', 'wbaker@yahoo.com', '(956)229-6912', '1945-01-03'),
(9, 'Harry', 'Wyatt', 'Hairyharry@gmail.com', '877-530-1781', '1998-10-16'),
(10, 'Martingale', 'Joseph', 'brownlucas@cisneros-johnson.com', '490-505-5618', '1945-10-05'),
(11, 'Anthony', 'Atkinson', 'louisbailey@mueller-moore.com', '577-820-0615', '1993-06-02'),
(12, 'Brianna', 'Wright', 'Wrightright@yahoo.com', '(984)726-3852', '1944-05-26'),
(13, 'Diana', 'Johnson', 'JDiana@gmail.com', '239-691-9851', '1995-11-15'),
(14, 'William', 'Poole', 'hopindapoole@hotmail.com', '+1-184-691-8883', '1945-02-17'),
(15, 'Jeffery', 'Jones', 'ann91@chapman.com', '239-559-2453', '1973-05-06'),
(16, 'Christina', 'Clark', 'clarkegibson@yahoo.com', '429-923-8429', '1974-07-15'),
(17, 'Brian', 'Bowen', 'cbranch@sanchez.info', '579-243-4919', '1939-09-12'),
(18, 'Charles', 'Sanchez', 'joseph75@hernandez-mcguire.com', '(071)879-7273', '1994-09-10'),
(19, 'Steven', 'Smith', 'csmith@yahoo.com', '973-731-3855', '1978-07-03'),
(20, 'Jill', 'Harris', 'jmartin@robinson.com', '(239)299-4143', '1982-09-04'),
(21, 'Jerome', 'Powell', 'j.powell@federalreserve.gov', '202-555-0199', '1953-02-04');

INSERT INTO Accounts (user_id, account_type, cash_balance, status) VALUES
-- Individual Accounts
(1, 'individual', 5000.00, 'active'),
(2, 'individual', 2500.50, 'active'),
(3, 'individual', 10000.00, 'active'),
(4, 'individual', 750.00, 'active'),
(5, 'individual', 150.00, 'active'),
(6, 'individual', 25000.00, 'active'),
(7, 'individual', 300.00, 'active'),
(8, 'individual', 4000.75, 'active'),
(9, 'individual', 800.00, 'active'),
(10, 'individual', 15000.00, 'active'),

-- Joint Accounts
(11, 'joint', 500.00, 'active'),
(12, 'joint', 3500.25, 'active'),
(13, 'joint', 12000.00, 'active'),
(14, 'joint', 600.00, 'active'),
(15, 'joint', 4200.00, 'active'),

-- Retirement Accounts
(16, 'retirement', 1850.00, 'active'),
(17, 'retirement', 18000.00, 'active'),
(18, 'retirement', 9000.50, 'active'),
(19, 'retirement', 2000.00, 'active'),
(20, 'retirement', 25000.00, 'active'),

-- Suspended Account for Jerome Powell
(21, 'brokerage', 1000000.00, 'suspended');

INSERT INTO Securities (symbol, name, asset_type, exchange, current_price) VALUES
('AAPL', 'Apple Inc.', 'stock', 'NASDAQ', 173.74),
('MSFT', 'Microsoft Corporation', 'stock', 'NASDAQ', 294.27),
('AMZN', 'Amazon.com Inc.', 'stock', 'NASDAQ', 3200.50),
('GOOGL', 'Alphabet Inc.', 'stock', 'NASDAQ', 2500.00),
('TSLA', 'Tesla Inc.', 'stock', 'NASDAQ', 650.00),
('META', 'Meta Platforms Inc.', 'stock', 'NASDAQ', 250.00),
('NVDA', 'NVIDIA Corporation', 'stock', 'NASDAQ', 500.00),
('JPM', 'JPMorgan Chase & Co.', 'stock', 'NYSE', 160.00),
('V', 'Visa Inc.', 'stock', 'NYSE', 220.00),
('JNJ', 'Johnson & Johnson', 'stock', 'NYSE', 180.00),
('BTC', 'Bitcoin', 'crypto', 'crypto', 82000.00);

INSERT INTO Holdings (account_id, security_id, quantity, average_price)
SELECT account_id, security_id, 
       FLOOR(RANDOM() * 50 + 1) AS quantity, 
       current_price
FROM (
    SELECT a.account_id, s.security_id, s.current_price,
           ROW_NUMBER() OVER (PARTITION BY a.account_id ORDER BY RANDOM()) AS rn
    FROM Accounts a
    CROSS JOIN Securities s
) AS subquery
WHERE rn <= 2;

INSERT INTO Orders (account_id, security_id, order_type, quantity, price_executed, total_value, order_status, executed_at) VALUES
(1, 1, 'buy', 10, 173.74, 1737.40, 'filled', '2025-03-18 10:15:00'),
(2, 2, 'sell', 5, 3200.50, 16002.50, 'filled', '2025-03-18 11:00:00'),
(3, 3, 'buy', 20, 650.00, 13000.00, 'filled', '2025-03-18 09:45:00'),
(4, 4, 'sell', 15, 294.27, 4414.05, 'filled', '2025-03-18 14:30:00'),
(5, 5, 'buy', 8, 500.00, 4000.00, 'filled', '2025-03-18 13:20:00'),
(6, 6, 'sell', 12, 180.00, 2160.00, 'filled', '2025-03-18 12:10:00'),
(7,7, 'buy', 25, 2500.00, 62500.00, 'filled', '2025-03-18 15:45:00'),
(8, 8, 'sell', 30, 250.00, 7500.00, 'filled', '2025-03-18 08:55:00'),
(9, 9, 'buy', 7, 220.00, 1540.00, 'filled', '2025-03-18 16:05:00'),
(10, 10, 'sell', 18, 160.00, 2880.00, 'filled', '2025-03-18 17:30:00'),
(11, 11, 'buy', 3, 82000.00, 246000.00, 'filled', '2025-03-18 18:00:00');



INSERT INTO Transactions (account_id, transaction_type, amount, method, status) VALUES
(1, 'deposit', 500.00, 'bank transfer', 'completed'),
(2, 'deposit', 200.00, 'bank transfer', 'completed'),
(3, 'deposit', 1000.00, 'wire transfer', 'completed'),
(4, 'deposit', 150.00, 'bank transfer', 'completed'),
(5, 'deposit', 50.00, 'bank transfer', 'completed'),
(6, 'deposit', 5000.00, 'wire transfer', 'completed'),
(7, 'deposit', 100.00, 'bank transfer', 'completed'),
(8, 'deposit', 500.00, 'cash deposit', 'completed'),
(9, 'deposit', 200.00, 'bank transfer', 'completed'),
(10, 'deposit', 1000.00, 'wire transfer', 'completed');


INSERT INTO Transactions (account_id, transaction_type, amount, method, status) VALUES
(1, 'withdrawal', 200.00, 'ATM', 'completed'),
(2, 'withdrawal', 100.00, 'ATM', 'completed'),
(3, 'withdrawal', 500.00, 'ATM', 'completed'),
(4, 'withdrawal', 50.00, 'cash withdrawal', 'completed'),
(5, 'withdrawal', 20.00, 'ATM', 'completed'),
(6, 'withdrawal', 1000.00, 'bank transfer', 'completed'),
(7, 'withdrawal', 50.00, 'ATM', 'completed'),
(8, 'withdrawal', 200.00, 'cash withdrawal', 'completed'),
(9, 'withdrawal', 100.00, 'bank transfer', 'completed'),
(10, 'withdrawal', 500.00, 'bank transfer', 'completed');
