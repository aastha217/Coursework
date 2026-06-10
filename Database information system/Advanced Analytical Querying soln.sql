/****************************************************************************************
		Advanced Analytical Querying

Q1 : Architecture & Lossless Decomposition (Normalization)
Q2 : Database Automation (Triggers & Procedures)
Q3 : Advanced Analytical Querying
Q4 : Security & Transactional Concurrency

****************************************************************************************/

-- =============================================================================
-- STEP 1 : CREATE DATABASE
-- =============================================================================

CREATE DATABASE IF NOT EXISTS dis_lab;
USE dis_lab;

-- =============================================================================
-- STEP 2 : DROP TABLES (IF ALREADY EXIST)
-- =============================================================================

DROP TABLE IF EXISTS Financial_Audit_Log;
DROP TABLE IF EXISTS Order_Items;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Customers;

-- =============================================================================
-- Q1. NORMALIZATION (BCNF DECOMPOSITION)
-- =============================================================================

/*
Legacy Table:

Legacy_Sales_Data
(
 Order_ID,
 Customer_Name,
 Customer_Email,
 Shipping_Address,
 Product_ID,
 Product_Name,
 Category,
 Stock_Quantity,
 Unit_Price,
 Order_Date,
 Order_Status,
 Qty_Purchased
)

Functional Dependencies:

Customer_Email
    -> Customer_Name, Shipping_Address

Product_ID
    -> Product_Name, Category,
       Stock_Quantity, Unit_Price

Order_ID
    -> Customer_Email,
       Order_Date,
       Order_Status

(Order_ID, Product_ID)
    -> Qty_Purchased

BCNF Tables:
1. Customers
2. Products
3. Orders
4. Order_Items
*/

-- =============================================================================
-- CUSTOMERS TABLE
-- =============================================================================

CREATE TABLE Customers
(
    Customer_ID INT AUTO_INCREMENT PRIMARY KEY,

    Customer_Name VARCHAR(100) NOT NULL,

    Customer_Email VARCHAR(100) NOT NULL UNIQUE,
    -- UNIQUE constraint as required

    Shipping_Address VARCHAR(255)
);

-- =============================================================================
-- PRODUCTS TABLE
-- =============================================================================

CREATE TABLE Products
(
    Product_ID INT PRIMARY KEY,

    Product_Name VARCHAR(100) NOT NULL,

    Category VARCHAR(50),

    Stock_Quantity INT NOT NULL,

    Unit_Price DECIMAL(10,2) NOT NULL,

    CHECK (Stock_Quantity >= 0)
    -- Stock can never become negative
);

-- =============================================================================
-- ORDERS TABLE
-- =============================================================================

CREATE TABLE Orders
(
    Order_ID INT PRIMARY KEY,

    Customer_ID INT NOT NULL,

    Order_Date DATE NOT NULL,

    Order_Status VARCHAR(50),

    FOREIGN KEY(Customer_ID)
    REFERENCES Customers(Customer_ID)
);

-- =============================================================================
-- ORDER_ITEMS TABLE
-- =============================================================================

CREATE TABLE Order_Items
(
    Order_ID INT,

    Product_ID INT,

    Qty_Purchased INT NOT NULL,

    PRIMARY KEY(Order_ID, Product_ID),

    FOREIGN KEY(Order_ID)
    REFERENCES Orders(Order_ID)
    ON DELETE CASCADE,
    -- If order is deleted, corresponding order items are deleted automatically

    FOREIGN KEY(Product_ID)
    REFERENCES Products(Product_ID)
);

-- =============================================================================
-- OPTIONAL : LOAD DATA FROM LEGACY TABLE
-- =============================================================================

INSERT INTO Customers
(
 Customer_Name,
 Customer_Email,
 Shipping_Address
)
SELECT DISTINCT
       Customer_Name,
       Customer_Email,
       Shipping_Address
FROM Legacy_Sales_Data;

INSERT INTO Products
(
 Product_ID,
 Product_Name,
 Category,
 Stock_Quantity,
 Unit_Price
)
SELECT DISTINCT
       Product_ID,
       Product_Name,
       Category,
       Stock_Quantity,
       Unit_Price
FROM Legacy_Sales_Data;

INSERT INTO Orders
(
 Order_ID,
 Customer_ID,
 Order_Date,
 Order_Status
)
SELECT DISTINCT
       L.Order_ID,
       C.Customer_ID,
       L.Order_Date,
       L.Order_Status
FROM Legacy_Sales_Data L
JOIN Customers C
ON L.Customer_Email = C.Customer_Email;

INSERT INTO Order_Items
(
 Order_ID,
 Product_ID,
 Qty_Purchased
)
SELECT
       Order_ID,
       Product_ID,
       Qty_Purchased
FROM Legacy_Sales_Data;

-- =============================================================================
-- Q2 : DATABASE AUTOMATION
-- =============================================================================

/*
Requirement:
Prevent overselling during flash sales.

If Qty_Purchased > Available Stock
then transaction should fail.
*/

DELIMITER $$

CREATE TRIGGER trg_check_inventory
BEFORE INSERT
ON Order_Items
FOR EACH ROW
BEGIN

    DECLARE available_stock INT;

    SELECT Stock_Quantity
    INTO available_stock
    FROM Products
    WHERE Product_ID = NEW.Product_ID;

    IF NEW.Qty_Purchased > available_stock THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'ERROR: Insufficient stock available';

    END IF;

END $$

DELIMITER ;

-- =============================================================================
-- TEST TRIGGER
-- =============================================================================

/*
Suppose stock available = 5

Trying to buy 10 units should fail
*/

-- INSERT INTO Order_Items
-- VALUES (2001,503,10);

-- =============================================================================
-- FINANCIAL AUDIT LOG TABLE
-- =============================================================================

CREATE TABLE Financial_Audit_Log
(
    Log_ID INT AUTO_INCREMENT PRIMARY KEY,

    Order_ID INT,

    Action_Type VARCHAR(50),

    Action_Date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    Remarks VARCHAR(255)
);

-- =============================================================================
-- Q2(2) STORED PROCEDURE : PROCESS_REFUND
-- =============================================================================

/*
Tasks:

1. Mark order as Refunded

2. Restore inventory

3. Create audit log entry
*/

DELIMITER $$

CREATE PROCEDURE Process_Refund
(
    IN p_Order_ID INT
)
BEGIN

    -- Update order status

    UPDATE Orders
    SET Order_Status = 'Refunded'
    WHERE Order_ID = p_Order_ID;

    -- Restore stock quantity

    UPDATE Products P
    JOIN Order_Items OI
    ON P.Product_ID = OI.Product_ID

    SET P.Stock_Quantity =
        P.Stock_Quantity + OI.Qty_Purchased

    WHERE OI.Order_ID = p_Order_ID;

    -- Log transaction

    INSERT INTO Financial_Audit_Log
    (
        Order_ID,
        Action_Type,
        Remarks
    )
    VALUES
    (
        p_Order_ID,
        'REFUND',
        'Inventory Restored & Refund Processed'
    );

END $$

DELIMITER ;

-- =============================================================================
-- TEST PROCEDURE
-- =============================================================================

CALL Process_Refund(1001);

-- =============================================================================
-- Q3 : ADVANCED ANALYTICAL QUERYING
-- =============================================================================

-- =============================================================================
-- Q3(1) CUSTOMER LOYALTY CATEGORIZATION
-- =============================================================================

/*
Platinum > 2000

Gold >1000 and <=2000

Silver <=1000
*/

SELECT
    C.Customer_ID,
    C.Customer_Name,

    SUM(P.Unit_Price * OI.Qty_Purchased)
    AS Total_Spent,

    CASE

        WHEN SUM(P.Unit_Price * OI.Qty_Purchased) > 2000
            THEN 'Platinum'

        WHEN SUM(P.Unit_Price * OI.Qty_Purchased) > 1000
            THEN 'Gold'

        ELSE 'Silver'

    END AS Loyalty_Tier

FROM Customers C

JOIN Orders O
ON C.Customer_ID = O.Customer_ID

JOIN Order_Items OI
ON O.Order_ID = OI.Order_ID

JOIN Products P
ON OI.Product_ID = P.Product_ID

GROUP BY
C.Customer_ID,
C.Customer_Name;

-- =============================================================================
-- Q3(2) REVENUE ANALYSIS USING CTE
-- =============================================================================

/*
Revenue = Unit Price × Quantity

Display categories having
revenue > 50000
*/

WITH Category_Revenue AS
(
    SELECT

        P.Category,

        SUM
        (
            P.Unit_Price *
            OI.Qty_Purchased
        ) AS Total_Revenue

    FROM Products P

    JOIN Order_Items OI
    ON P.Product_ID = OI.Product_ID

    GROUP BY P.Category
)

SELECT *
FROM Category_Revenue

WHERE Total_Revenue > 50000;

-- =============================================================================
-- Q3(3) DEEP PURCHASING HABITS
-- =============================================================================

/*
For every customer,
retrieve top 2 most expensive orders.

Using Window Function
*/

WITH Ranked_Orders AS
(
    SELECT

        C.Customer_ID,
        C.Customer_Name,

        O.Order_ID,

        SUM
        (
            P.Unit_Price *
            OI.Qty_Purchased
        ) AS Order_Value,

        ROW_NUMBER() OVER
        (
            PARTITION BY C.Customer_ID
            ORDER BY
            SUM
            (
                P.Unit_Price *
                OI.Qty_Purchased
            ) DESC
        ) AS rn

    FROM Customers C

    JOIN Orders O
    ON C.Customer_ID = O.Customer_ID

    JOIN Order_Items OI
    ON O.Order_ID = OI.Order_ID

    JOIN Products P
    ON OI.Product_ID = P.Product_ID

    GROUP BY
        C.Customer_ID,
        C.Customer_Name,
        O.Order_ID
)

SELECT
    Customer_ID,
    Customer_Name,
    Order_ID,
    Order_Value

FROM Ranked_Orders

WHERE rn <= 2

ORDER BY
Customer_ID,
Order_Value DESC;

-- =============================================================================
-- Q4 : SECURITY & TRANSACTIONAL CONCURRENCY
-- =============================================================================

-- =============================================================================
-- Q4(1) ROLE BASED ACCESS CONTROL
-- =============================================================================

/*
Public Catalog View

Hide:
1. Stock Quantity
2. Supplier Cost
3. Internal Data

Expose:
1. Product Name
2. Category
3. Unit Price
*/

CREATE VIEW Public_Hardware_Catalog AS

SELECT
    Product_Name,
    Category,
    Unit_Price
FROM Products;

-- =============================================================================
-- CREATE ROLE
-- =============================================================================

CREATE ROLE Frontend_App;

-- =============================================================================
-- GRANT READ ONLY ACCESS
-- =============================================================================

GRANT SELECT
ON dis_lab.Public_Hardware_Catalog
TO Frontend_App;

-- =============================================================================
-- VERIFY
-- =============================================================================

SHOW GRANTS FOR Frontend_App;

-- =============================================================================
-- Q4(2) PREVENT LOST UPDATES
-- =============================================================================

/*
Scenario:

Only 1 monitor left.

Two customers attempt purchase simultaneously.

Solution:
Use Transaction + Row Lock

SELECT ... FOR UPDATE
*/

START TRANSACTION;

-- Lock monitor row

SELECT
    Product_ID,
    Product_Name,
    Stock_Quantity

FROM Products

WHERE Product_ID = 501

FOR UPDATE;

-- Check stock manually

-- If stock > 0

UPDATE Products

SET Stock_Quantity =
    Stock_Quantity - 1

WHERE Product_ID = 501
AND Stock_Quantity > 0;

-- Release lock

COMMIT;

-- =============================================================================
-- ROLLBACK EXAMPLE
-- =============================================================================

/*
If error occurs:

ROLLBACK;
*/

-- =============================================================================
-- USEFUL VERIFICATION QUERIES
-- =============================================================================

SELECT * FROM Customers;

SELECT * FROM Products;

SELECT * FROM Orders;

SELECT * FROM Order_Items;

SELECT * FROM Financial_Audit_Log;

SELECT * FROM Public_Hardware_Catalog;

/****************************************************************************************
END OF COMPLETE DIS LAB ASSIGNMENT SOLUTION
****************************************************************************************/