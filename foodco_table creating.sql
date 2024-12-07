CREATE DATABASE foodco;
USE foodco;

-- Create Customers table
CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(15),
    address TEXT
);
INSERT INTO Customers (first_name, last_name, email, phone_number, address)
VALUES
('John', 'Doe', 'john.doe@example.com', '1234567890', '123 Elm St, Springfield'),
('Jane', 'Smith', 'jane.smith@example.com', '9876543210', '456 Maple Ave, Springfield'),
('Alice', 'Johnson', 'alice.johnson@example.com', '5556667777', '789 Oak Blvd, Springfield');

SELECT * FROM Customers;


-- Create Restaurants table
CREATE TABLE Restaurants (
    restaurant_id INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_name VARCHAR(100) NOT NULL,
    cuisine_type VARCHAR(50),
    address TEXT
);
INSERT INTO Restaurants (restaurant_name, cuisine_type, address)
VALUES
('Spice Heaven', 'Indian', '101 Curry Lane, Springfield'),
('Pasta Palace', 'Italian', '202 Olive St, Springfield'),
('Sushi World', 'Japanese', '303 Sashimi Way, Springfield');
SELECT * FROM Restaurants;

-- Create Menu_Items table
CREATE TABLE Menu_Items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_id INT NOT NULL,
    item_name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (restaurant_id) REFERENCES Restaurants(restaurant_id) ON DELETE CASCADE
);
INSERT INTO Menu_Items (restaurant_id, item_name, price)
VALUES
(1, 'Chicken Tikka Masala', 12.99),
(1, 'Paneer Butter Masala', 10.99),
(2, 'Spaghetti Carbonara', 14.49),
(2, 'Margherita Pizza', 11.99),
(3, 'California Roll', 9.99),
(3, 'Salmon Nigiri', 7.49);
SELECT * FROM Menu_Items;

-- Create Orders table
CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    restaurant_id INT NOT NULL,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    total_price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) ON DELETE CASCADE,
    FOREIGN KEY (restaurant_id) REFERENCES Restaurants(restaurant_id) ON DELETE CASCADE
);
INSERT INTO Orders (customer_id, restaurant_id, order_date, total_price)
VALUES
(1, 1, '2024-11-18 12:30:00', 23.98),
(2, 2, '2024-11-18 18:45:00', 26.48),
(3, 3, '2024-11-18 20:15:00', 17.48);
SELECT * FROM Orders;

-- Create Order_Items table
CREATE TABLE Order_Items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    item_id INT NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (item_id) REFERENCES Menu_Items(item_id) ON DELETE CASCADE
);
INSERT INTO Order_Items (order_id, item_id, quantity)
VALUES
(1, 1, 1),
(1, 2, 1),
(2, 3, 1),
(2, 4, 1),
(3, 5, 1),
(3, 6, 1);
SELECT * FROM Order_Items;

-- Create Delivery_Agents table
CREATE TABLE Delivery_Agents (
    agent_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone_number VARCHAR(15) NOT NULL
);
INSERT INTO Delivery_Agents (first_name, last_name, phone_number)
VALUES
('Mike', 'Johnson', '4445556666'),
('Emily', 'Taylor', '7778889999'),
('James', 'Brown', '2223334444');
SELECT * FROM Delivery_Agents;

-- Create Deliveries table
CREATE TABLE Deliveries (
    delivery_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    agent_id INT ,
    delivery_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    delivery_status VARCHAR(50) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (agent_id) REFERENCES Delivery_Agents(agent_id) ON DELETE SET NULL
);
INSERT INTO Deliveries (order_id, agent_id, delivery_date, delivery_status)
VALUES
(1, 1, '2024-11-18 13:00:00', 'Delivered'),
(2, 2, '2024-11-18 19:15:00', 'Delivered'),
(3, 3, '2024-11-18 20:45:00', 'Delivered');
SELECT * FROM Deliveries;