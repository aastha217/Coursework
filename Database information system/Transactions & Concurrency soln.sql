/****************************************************************************************
                        Transactions & Concurrency
****************************************************************************************/

CREATE DATABASE IF NOT EXISTS dis_lab;
USE dis_lab;

-- =============================================================================
-- PRE-LAB SETUP
-- =============================================================================

SET SQL_SAFE_UPDATES = 0;

DROP TABLE IF EXISTS Accounts;

-- =============================================================================
-- CREATE SCHEMA
-- =============================================================================

CREATE TABLE Accounts
(
    Account_ID INT PRIMARY KEY,

    Account_Name VARCHAR(50),

    Balance DECIMAL(10,2)
    CHECK (Balance >= 0)
);

-- =============================================================================
-- INSERT SAMPLE DATA
-- =============================================================================

INSERT INTO Accounts VALUES
(101,'Alice',5000.00),
(102,'Bob',3000.00),
(103,'Charlie',1000.00);

-- =============================================================================
-- Q1 : COMMIT & ROLLBACK
-- =============================================================================

/*
Transfer ₹1000
from Alice to Bob
*/

START TRANSACTION;

UPDATE Accounts
SET Balance = Balance - 1000
WHERE Account_ID = 101;

UPDATE Accounts
SET Balance = Balance + 1000
WHERE Account_ID = 102;

COMMIT;

-- Verify balances

SELECT *
FROM Accounts;

-- -----------------------------------------------------------------------------

/*
Attempt transfer ₹6000
from Bob to Charlie
*/

START TRANSACTION;

UPDATE Accounts
SET Balance = Balance - 6000
WHERE Account_ID = 102;

UPDATE Accounts
SET Balance = Balance + 6000
WHERE Account_ID = 103;

ROLLBACK;

-- Verify balances remain unchanged

SELECT *
FROM Accounts;

-- =============================================================================
-- Q2 : SAVEPOINT
-- =============================================================================

/*
Charlie books flight
*/

START TRANSACTION;

UPDATE Accounts
SET Balance = Balance - 400
WHERE Account_ID = 103;

SAVEPOINT Flight_Booked;

-- Attempt hotel booking

UPDATE Accounts
SET Balance = Balance - 800
WHERE Account_ID = 103;

ROLLBACK TO Flight_Booked;

COMMIT;

-- Verify Charlie's balance

SELECT *
FROM Accounts
WHERE Account_ID = 103;

-- =============================================================================
-- Q3 : DIRTY READ
-- =============================================================================

/*
SESSION A
*/

SET SESSION TRANSACTION ISOLATION LEVEL
READ UNCOMMITTED;

START TRANSACTION;

UPDATE Accounts
SET Balance = 10000
WHERE Account_ID = 101;

-- Do NOT commit yet

-- =============================================================================
-- SESSION B
-- =============================================================================

SET SESSION TRANSACTION ISOLATION LEVEL
READ UNCOMMITTED;

SELECT *
FROM Accounts
WHERE Account_ID = 101;

-- Dirty read occurs

-- =============================================================================
-- SESSION A
-- =============================================================================

ROLLBACK;

-- =============================================================================
-- SESSION B
-- =============================================================================

SELECT *
FROM Accounts
WHERE Account_ID = 101;

-- Observe original balance restored

-- =============================================================================
-- PREVENT DIRTY READ
-- =============================================================================

/*
Use READ COMMITTED
or REPEATABLE READ
*/

SET SESSION TRANSACTION ISOLATION LEVEL
READ COMMITTED;

SELECT *
FROM Accounts
WHERE Account_ID = 101;

-- =============================================================================
-- Q4 : LOST UPDATE
-- =============================================================================

/*
SESSION A
*/

START TRANSACTION;

SELECT Balance
FROM Accounts
WHERE Account_ID = 102;

-- Assume balance = 3000

UPDATE Accounts
SET Balance = 3500
WHERE Account_ID = 102;

-- Do NOT commit

-- =============================================================================
-- SESSION B
-- =============================================================================

START TRANSACTION;

SELECT Balance
FROM Accounts
WHERE Account_ID = 102;

-- Assume balance = 3000

UPDATE Accounts
SET Balance = 2800
WHERE Account_ID = 102;

-- =============================================================================
-- BOTH SESSIONS
-- =============================================================================

COMMIT;

-- Verify final balance

SELECT *
FROM Accounts
WHERE Account_ID = 102;

-- =============================================================================
-- FIX LOST UPDATE USING LOCKING
-- =============================================================================

/*
Reset Bob's balance
*/

UPDATE Accounts
SET Balance = 3000
WHERE Account_ID = 102;

-- =============================================================================
-- SESSION A
-- =============================================================================

START TRANSACTION;

SELECT Balance
FROM Accounts
WHERE Account_ID = 102
FOR UPDATE;

UPDATE Accounts
SET Balance = Balance + 500
WHERE Account_ID = 102;

-- Keep transaction open

-- =============================================================================
-- SESSION B
-- =============================================================================

START TRANSACTION;

SELECT Balance
FROM Accounts
WHERE Account_ID = 102
FOR UPDATE;

-- Session B waits
-- until Session A commits

-- =============================================================================
-- SESSION A
-- =============================================================================

COMMIT;

-- =============================================================================
-- SESSION B
-- =============================================================================

UPDATE Accounts
SET Balance = Balance - 200
WHERE Account_ID = 102;

COMMIT;

-- Verify final balance

SELECT *
FROM Accounts
WHERE Account_ID = 102;

-- =============================================================================
-- VERIFICATION QUERY
-- =============================================================================

SELECT *
FROM Accounts;

-- =============================================================================
-- END OF ASSIGNMENT
-- =============================================================================