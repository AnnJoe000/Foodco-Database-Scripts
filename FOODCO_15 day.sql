USE foodco;

-- day1 (DISTINCT, AS, WHERE)
-- DISTINT
	SELECT DISTINCT cuisine_type 
	FROM Restaurants;
-- AS
	SELECT 
    first_name AS FirstName, 
    last_name AS LastName 
	FROM Customers;
-- WHERE
	SELECT first_name AS FirstName, last_name AS LastName 
	FROM Customers WHERE email LIKE '%example.com';


-- day 2 (Arithmetic, Comparison, Logical)
-- Arithmetic
	SELECT o.order_id, SUM(mi.price * oi.quantity) AS total_cost
	FROM Orders o
	JOIN Order_Items oi ON o.order_id = oi.order_id
	JOIN Menu_Items mi ON oi.item_id = mi.item_id
	GROUP BY o.order_id;

-- Comparison
	SELECT * FROM Orders
	WHERE total_price > 20;

-- Logical
SELECT *
	FROM Menu_Items
	WHERE price > 9 AND price < 12;




-- day3 (IS NULL, IS NOT NULL, IN, NOT IN)
-- NULL
	SELECT customer_id, first_name, last_name, email FROM Customers WHERE phone_number IS NULL;

-- NOT IN
	SELECT restaurant_id, restaurant_name, cuisine_type 
	FROM Restaurants 
	WHERE cuisine_type NOT IN ('Italian', 'Japanese');

-- IS NOT NULL
	SELECT item_id, item_name, price
	FROM Menu_Items WHERE price IS NOT NULL;

-- IN
	SELECT restaurant_id, restaurant_name, cuisine_type FROM Restaurants
	WHERE cuisine_type IN ('Italian', 'Mexican', 'Chinese');
-- NOT IN 
	SELECT restaurant_id, restaurant_name, cuisine_type
	FROM Restaurants WHERE cuisine_type NOT IN ('Italian', 'Chinese');
    
    
    
-- day 4 (BETWEEN, NOT BETWEEN, LIKE, NOT LIKE)
-- BETWEEN
SELECT order_id, customer_id, order_date, total_price
FROM Orders WHERE order_date BETWEEN '2024-01-01' AND '2000-01-07';

-- NOT BETWEEN
SELECT order_id, customer_id, order_date, total_price
FROM Orders WHERE order_date NOT BETWEEN '2024-01-01' AND '2000-01-07';

-- LIKE
SELECT customer_id, first_name, last_name, email
FROM Customers WHERE first_name LIKE 'J%n';

-- NOT LIKE
SELECT customer_id, first_name, last_name, email
FROM Customers WHERE first_name NOT LIKE 'J%n';



-- Day 5 (ORDER BY, LIMIT)
-- ORDER BY 
SELECT item_id, item_name, price FROM Menu_Items
ORDER BY price DESC LIMIT 5;


-- LIMIT
SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, COUNT(o.order_id) AS total_orders
FROM Customers c JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_orders DESC LIMIT 3;

-- Day 6 (COUNT,SUM AVG)
-- COUNT
SELECT COUNT(*) AS Total_Orders 
FROM Orders;

-- AVG
SELECT AVG(price) AS Average_Price 
FROM Menu_Items;

-- SUM
SELECT SUM(price) FROM Menu_Items;


-- Day 7 (GROUP BY & HAVING )
SELECT r.restaurant_name,SUM(o.total_price) AS total_sales
FROM Orders o JOIN Restaurants r ON o.restaurant_id = r.restaurant_id
GROUP BY r.restaurant_name;

SELECT r.restaurant_name, SUM(o.total_price) AS total_sales FROM Orders o 
JOIN Restaurants r ON o.restaurant_id = r.restaurant_id
GROUP BY r.restaurant_name
HAVING SUM(o.total_price) > 50;


-- Day 8 (inner join)
SELECT 
    Orders.order_id,
    Customers.first_name,
    Customers.phone_number,
    Restaurants.restaurant_name,
    Restaurants.address,
    Orders.order_date
FROM Orders INNER JOIN Customers ON Orders.customer_id = Customers.customer_id
INNER JOIN Restaurants ON Orders.Restaurant_ID = Restaurants.Restaurant_ID;

-- Day 9 (LEFT JOIN, RIGHT JOIN)
SELECT 
    Restaurants.Restaurant_ID,
    Restaurants.Restaurant_Name,
    Orders.Order_ID,
    Orders.Order_Date
FROM Restaurants LEFT JOIN Orders ON Restaurants.Restaurant_ID = Orders.Restaurant_ID;


SELECT 
    Delivery_Agents.agent_id,
    Delivery_Agents.first_Name,
    Deliveries.Delivery_ID,
    Deliveries.delivery_date
FROM Delivery_Agents
RIGHT JOIN Deliveries ON Delivery_Agents.Agent_ID = Deliveries.Agent_ID;



-- Day 10 (UNION, UNION ALL)

SELECT first_name AS Name FROM Customers  
UNION  SELECT first_name AS Name FROM Delivery_Agents;  


SELECT first_name AS Name  FROM Customers  
UNION ALL  SELECT first_name AS Name  FROM Delivery_Agents;  


-- Day 11 (mathematical )

SELECT item_name, price AS OriginalPrice, price * 0.9 AS DiscountedPrice FROM Menu_Items; 

-- Day 12 (String Functions)

SELECT LOWER(email) AS standardized_email
FROM customers;

SELECT UPPER(address) AS standardized_address
FROM customers ;

-- Day 13 (String Functions)

SELECT o.order_id, o.order_date, d.delivery_date,
TIMESTAMPDIFF(hour,d.delivery_date, o.order_date) AS duration_in_days 
FROM orders o,Deliveries d; 

-- Day 14 (Subqueries, Views)

SELECT distinct(customer_id)  FROM orders  WHERE customer_id IN 
(  
    SELECT customer_id FROM orders  
    GROUP BY customer_id HAVING COUNT(order_id) > 1  
);

CREATE VIEW top_spenders AS  
SELECT customer_id, SUM(total_price) AS total_spent  FROM orders  
GROUP BY customer_id  ORDER BY total_spent DESC  LIMIT 3;

SELECT * FROM top_spenders;

-- Day 15 (Stored Procedures and Triggers )

DELIMITER //

CREATE PROCEDURE UpdateDeliveryStatus(IN orderId INT, IN newStatus VARCHAR(50))
BEGIN
    UPDATE Deliveries
    SET delivery_status = newStatus
    WHERE order_id = orderId;
END //

DELIMITER ;
Drop procedure UpdateDeliveryStatus;
CALL UpdateDeliveryStatus(5, 'Delivered');
SELECT * FROM Deliveries;


DELIMITER //
CREATE TRIGGER UpdateOrderTotal AFTER INSERT ON Order_Items
FOR EACH ROW
BEGIN
    DECLARE item_price DECIMAL(10, 2);
    
    -- Retrieve the price of the item being added
    SELECT price INTO item_price
    FROM Menu_Items
    WHERE item_id = NEW.item_id;

    -- Update the total price in the Orders table
    UPDATE Orders
    SET total_price = total_price + (item_price * NEW.quantity)
    WHERE order_id = NEW.order_id;
END //
DELIMITER ;
INSERT INTO Order_Items (order_id, item_id, quantity) VALUES (1, 3, 2); 
SELECT * FROM Orders WHERE order_id = 1;