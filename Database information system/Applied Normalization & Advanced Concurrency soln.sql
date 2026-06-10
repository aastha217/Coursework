/****************************************************************************************
					Applied Normalization & Advanced Concurrency
*****************************************************************************************
Q1 : Demonstrate Anomalies in Bad_Orders
Q2 : Normalize Bad_Orders into 3NF
Q3 : Deadlock Demonstration
Q4 : Phantom Read Demonstration & Prevention

****************************************************************************************/

-- =============================================================================
-- CREATE DATABASE
-- =============================================================================

CREATE DATABASE IF NOT EXISTS dis_lab;
USE dis_lab;

-- =============================================================================
-- PRE-LAB SETUP
-- =============================================================================

SET SQL_SAFE_UPDATES = 0;

DROP TABLE IF EXISTS Bad_Orders;
DROP TABLE IF EXISTS Accounts;

-- =============================================================================
-- DENORMALIZED TABLE
-- =============================================================================

CREATE TABLE Bad_Orders
(
    Order_ID INT,
    Product_ID INT,
    Customer_ID INT,
    Customer_Name VARCHAR(50),
    Customer_City VARCHAR(50),
    Product_Name VARCHAR(50),
    Category VARCHAR(50),
    Quantity INT,
    Unit_Price DECIMAL(10,2),
    Order_Date DATE,

    PRIMARY KEY(Order_ID, Product_ID)
);

INSERT INTO Bad_Orders VALUES
(1,1,101,'Alice','Jaipur','Laptop','Electronics',1,50000.00,'2024-03-01'),
(1,2,101,'Alice','Jaipur','Smartphone','Electronics',1,20000.00,'2024-03-01'),
(2,1,101,'Alice','Jaipur','Laptop','Electronics',1,50000.00,'2024-03-05'),
(3,3,102,'Bob','Delhi','Tablet','Electronics',1,30000.00,'2024-03-10');

-- =============================================================================
-- BANKING TABLE FOR CONCURRENCY
-- =============================================================================

CREATE TABLE Accounts
(
    Account_ID INT PRIMARY KEY,
    Account_Name VARCHAR(50),
    Balance DECIMAL(10,2)
);

INSERT INTO Accounts VALUES
(201,'Vikram',10000.00),
(202,'Sanya',15000.00);

-- =============================================================================
-- Q1 : DEMONSTRATING ANOMALIES
-- =============================================================================

/*
BAD_ORDERS is in 1NF but contains:
1. Update Anomaly
2. Deletion Anomaly
3. Insertion Anomaly
*/

-- =============================================================================
-- Q1(A) UPDATE ANOMALY
-- =============================================================================

/*
Change Alice's city only in Order_ID = 1

This creates inconsistent customer data.
*/

UPDATE Bad_Orders
SET Customer_City = 'Mumbai'
WHERE Customer_Name = 'Alice'
AND Order_ID = 1;

-- Verify anomaly

SELECT
    Customer_ID,
    Customer_Name,
    COUNT(DISTINCT Customer_City) AS Different_Cities
FROM Bad_Orders
GROUP BY
    Customer_ID,
    Customer_Name
HAVING COUNT(DISTINCT Customer_City) > 1;

/*
Expected Output

Customer_ID  Customer_Name  Different_Cities
------------------------------------------------
101          Alice               2

Proof:
Alice now exists as both Jaipur and Mumbai
*/

-- =============================================================================
-- Q1(B) DELETION ANOMALY
-- =============================================================================

/*
Delete Bob's only order
*/

DELETE FROM Bad_Orders
WHERE Order_ID = 3;

-- Try retrieving Tablet information

SELECT
    Product_Name,
    Category,
    Unit_Price
FROM Bad_Orders
WHERE Product_Name = 'Tablet';

/*
Expected Output

0 Rows Returned

Proof:
Deleting order removed product information too.
*/

-- =============================================================================
-- Q1(C) INSERTION ANOMALY
-- =============================================================================

/*
Attempt to insert a new product
without assigning an order.
*/

INSERT INTO Bad_Orders
(
    Order_ID,
    Product_ID,
    Customer_ID,
    Customer_Name,
    Customer_City,
    Product_Name,
    Category,
    Quantity,
    Unit_Price,
    Order_Date
)
VALUES
(
    NULL,
    4,
    NULL,
    NULL,
    NULL,
    'Monitor',
    'Electronics',
    NULL,
    15000.00,
    NULL
);

/*
Expected MySQL Error

ERROR 1048 (23000):
Column 'Order_ID' cannot be null

Reason:
Primary key cannot contain NULL values.

Thus product cannot exist independently.
*/

-- =============================================================================
-- IMPORTANT
-- =============================================================================

/*
Before Q2

RE-RUN PRE-LAB SETUP
to restore original Bad_Orders table.
*/

-- =============================================================================
-- Q2 : NORMALIZATION INTO 3NF
-- =============================================================================

/*
Create:

1. Customers
2. Products
3. Orders
4. Order_Items

Parent tables first.
*/

-- =============================================================================
-- DROP NORMALIZED TABLES IF EXIST
-- =============================================================================

DROP TABLE IF EXISTS Order_Items;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Customers;

-- =============================================================================
-- CUSTOMERS TABLE
-- =============================================================================

CREATE TABLE Customers
(
    Customer_ID INT PRIMARY KEY,

    Customer_Name VARCHAR(50) NOT NULL,

    Customer_City VARCHAR(50)
);

-- =============================================================================
-- PRODUCTS TABLE
-- =============================================================================

CREATE TABLE Products
(
    Product_ID INT PRIMARY KEY,

    Product_Name VARCHAR(50),

    Category VARCHAR(50),

    Unit_Price DECIMAL(10,2)
);

-- =============================================================================
-- ORDERS TABLE
-- =============================================================================

CREATE TABLE Orders
(
    Order_ID INT PRIMARY KEY,

    Customer_ID INT NOT NULL,

    Order_Date DATE,

    FOREIGN KEY(Customer_ID)
    REFERENCES Customers(Customer_ID)
);

-- =============================================================================
-- ORDER ITEMS TABLE
-- =============================================================================

CREATE TABLE Order_Items
(
    Order_ID INT,

    Product_ID INT,

    Quantity INT,

    PRIMARY KEY(Order_ID, Product_ID),

    FOREIGN KEY(Order_ID)
    REFERENCES Orders(Order_ID),

    FOREIGN KEY(Product_ID)
    REFERENCES Products(Product_ID)
);

-- =============================================================================
-- Q2(2) DATA MIGRATION USING INSERT SELECT DISTINCT
-- =============================================================================

-- Populate Customers

INSERT INTO Customers
(
    Customer_ID,
    Customer_Name,
    Customer_City
)
SELECT DISTINCT
       Customer_ID,
       Customer_Name,
       Customer_City
FROM Bad_Orders;

-- Populate Products

INSERT INTO Products
(
    Product_ID,
    Product_Name,
    Category,
    Unit_Price
)
SELECT DISTINCT
       Product_ID,
       Product_Name,
       Category,
       Unit_Price
FROM Bad_Orders;

-- Populate Orders

INSERT INTO Orders
(
    Order_ID,
    Customer_ID,
    Order_Date
)
SELECT DISTINCT
       Order_ID,
       Customer_ID,
       Order_Date
FROM Bad_Orders;

-- Populate Order Items

INSERT INTO Order_Items
(
    Order_ID,
    Product_ID,
    Quantity
)
SELECT
       Order_ID,
       Product_ID,
       Quantity
FROM Bad_Orders;

-- =============================================================================
-- Q2(3) LOSSLESS DECOMPOSITION VERIFICATION
-- =============================================================================

/*
Join all four tables.

Output must exactly recreate Bad_Orders.
*/

SELECT

    O.Order_ID,

    P.Product_ID,

    C.Customer_ID,

    C.Customer_Name,

    C.Customer_City,

    P.Product_Name,

    P.Category,

    OI.Quantity,

    P.Unit_Price,

    O.Order_Date

FROM Orders O

JOIN Customers C
ON O.Customer_ID = C.Customer_ID

JOIN Order_Items OI
ON O.Order_ID = OI.Order_ID

JOIN Products P
ON OI.Product_ID = P.Product_ID

ORDER BY
O.Order_ID,
P.Product_ID;

/*
If output matches Bad_Orders exactly

=> Lossless decomposition proven
*/

-- =============================================================================
-- Q3 : DEADLOCK DEMONSTRATION
-- =============================================================================

/*
VERY IMPORTANT

Open TWO SQL WINDOWS

SESSION A
SESSION B

Check they are different:

SELECT CONNECTION_ID();
*/

-- =============================================================================
-- SESSION A
-- =============================================================================

START TRANSACTION;

UPDATE Accounts
SET Balance = 9000
WHERE Account_ID = 201;

/*
Lock acquired on Account 201

Do NOT commit.
*/

-- =============================================================================
-- SESSION B
-- =============================================================================

START TRANSACTION;

UPDATE Accounts
SET Balance = 14000
WHERE Account_ID = 202;

/*
Lock acquired on Account 202

Do NOT commit.
*/

-- =============================================================================
-- SESSION A
-- =============================================================================

UPDATE Accounts
SET Balance = Balance - 1000
WHERE Account_ID = 202;

/*
This waits because
Session B already locked 202.
*/

-- =============================================================================
-- SESSION B
-- =============================================================================

UPDATE Accounts
SET Balance = Balance - 1000
WHERE Account_ID = 201;

/*
Deadlock occurs.

MySQL detects circular waiting.

Typical Error:

ERROR 1213 (40001):
Deadlock found when trying to get lock;
try restarting transaction
*/

-- =============================================================================
-- CLEANUP AFTER DEADLOCK
-- =============================================================================

ROLLBACK;

-- Run in BOTH sessions

-- =============================================================================
-- Q4 : PHANTOM READ
-- =============================================================================

/*
A phantom read occurs when
new rows appear between two reads.
*/

-- =============================================================================
-- PART A : TRIGGER PHANTOM READ
-- =============================================================================

-- =============================================================================
-- SESSION A
-- =============================================================================

SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

START TRANSACTION;

SELECT SUM(Balance)
AS Total_Balance
FROM Accounts;

/*
Initial Sum

10000 + 15000

= 25000
*/

-- =============================================================================
-- SESSION B
-- =============================================================================

START TRANSACTION;

INSERT INTO Accounts
VALUES
(
    203,
    'Kabir',
    5000.00
);

COMMIT;

-- =============================================================================
-- SESSION A
-- =============================================================================

SELECT SUM(Balance)
AS Total_Balance
FROM Accounts;

/*
New Sum

10000 + 15000 + 5000

= 30000

Even though Session A
did not modify data.

This is PHANTOM READ.
*/

ROLLBACK;

-- =============================================================================
-- Q4 PART B : FIX PHANTOM READ
-- =============================================================================

-- =============================================================================
-- SESSION A
-- =============================================================================

SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;

START TRANSACTION;

SELECT SUM(Balance)
AS Total_Balance
FROM Accounts;

/*
Highest isolation level.

Range lock acquired.
*/

-- =============================================================================
-- SESSION B
-- =============================================================================

START TRANSACTION;

INSERT INTO Accounts
VALUES
(
    204,
    'Amit',
    5000.00
);

/*
What happens?

Session B gets BLOCKED.

It waits.

Reason:

SERIALIZABLE prevents
new rows from appearing
inside Session A transaction.
*/

-- =============================================================================
-- SESSION A
-- =============================================================================

COMMIT;

/*
Lock released.
*/

-- =============================================================================
-- SESSION B
-- =============================================================================

/*
Immediately after Session A commits,

INSERT executes successfully.

Then:

COMMIT;
*/

COMMIT;

-- =============================================================================
-- VERIFICATION QUERIES
-- =============================================================================

SELECT * FROM Customers;

SELECT * FROM Products;

SELECT * FROM Orders;

SELECT * FROM Order_Items;

SELECT * FROM Accounts;

-- =============================================================================
-- END OF ASSIGNMENT 
-- =============================================================================
