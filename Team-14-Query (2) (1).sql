--Query 1: The brokerage wants to find out how many users have completed at least 1 transaction.
SELECT DISTINCT u.user_id, u.first_name, u.last_name
FROM Users u
JOIN Accounts a ON u.user_id = a.user_id
JOIN Transactions t ON a.account_id = t.account_id
ORDER BY u.last_name DESC;

--Query 2: The brokerage wants to know the total balance on each account and sort them to have the largest accounts at the top of the table.
SELECT a.account_id, (a.cash_balance + COALESCE(SUM(t.amount), 0)) AS total_balance
FROM Accounts a
LEFT JOIN Transactions t ON a.account_id = t.account_id
GROUP BY a.account_id, a.cash_balance
ORDER BY total_balance DESC;

--Query 3: The brokerage wants to know the total number of transactions per account type.
SELECT a.account_type, t.transaction_type, COUNT(t.transaction_id) AS total_transactions
FROM Accounts a
JOIN Transactions t ON a.account_id = t.account_id
GROUP BY a.account_type, t.transaction_type;

--Query 4: The brokerage wants to find all the users with a suspended account.
SELECT u.user_id, u.first_name, u.last_name
FROM Users u
JOIN Accounts a ON u.user_id = a.user_id
WHERE a.status = 'suspended'
ORDER BY u.first_name DESC;

--Query 5: The brokerage wants to find the most recent market data for each security:
SELECT md.security_id, s.symbol, s.name, md.date, md.close_price
FROM Market_Data md
JOIN Securities s ON md.security_id = s.security_id
WHERE md.date = (SELECT MAX(date) FROM Market_Data WHERE security_id = md.security_id);


--Query 6: The brokerage wants to find the total amount deposited by each user:
SELECT u.user_id, u.first_name, u.last_name, SUM(t.amount) AS total_deposits
FROM Users u
JOIN Accounts a ON u.user_id = a.user_id
JOIN Transactions t ON a.account_id = t.account_id
WHERE t.transaction_type = 'deposit' AND t.status = 'completed'
GROUP BY u.user_id;

--Query 7: The brokerage wants to find all filled buy orders:
SELECT o.order_id, o.account_id, s.symbol, o.quantity, o.order_status
FROM Orders o
JOIN Securities s ON o.security_id = s.security_id
WHERE o.order_status = 'filled' AND o.order_type = 'buy';

--Query 8 "The brokerage wants update the users account balances after withdraws and deposits properly "
CREATE OR REPLACE FUNCTION update_account_balance() 
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.transaction_type = 'deposit' THEN
        UPDATE Accounts
        SET cash_balance = cash_balance + NEW.amount
        WHERE account_id = NEW.account_id;
    ELSIF NEW.transaction_type = 'withdrawal' THEN
        UPDATE Accounts
        SET cash_balance = cash_balance - NEW.amount
        WHERE account_id = NEW.account_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_account_balance
AFTER INSERT ON Transactions
FOR EACH ROW
EXECUTE FUNCTION update_account_balance();

--Query 9 The brokerage wants to see how many trades/orders were made in a given month (March)
SELECT COUNT(order_id) AS total_orders
FROM Orders
WHERE EXTRACT(MONTH FROM executed_at) = 3 
  AND EXTRACT(YEAR FROM executed_at) = 2025;
  
  --Query 10  The brokerage wants to find the most traded security on the platform and rank all tradable securities from most traded to least traded
  -- Query to find the most traded security and rank securities by number of trades
SELECT Securities.symbol, Securities.name, SUM(Orders.quantity) AS total_traded
FROM Orders
JOIN Securities ON Orders.security_id = Securities.security_id
WHERE Orders.order_status = 'filled'
GROUP BY Securities.symbol, Securities.name
ORDER BY total_traded DESC;
