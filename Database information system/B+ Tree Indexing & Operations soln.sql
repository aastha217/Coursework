/****************************************************************************************
                    B+ Tree Indexing & Operations
****************************************************************************************/

CREATE DATABASE IF NOT EXISTS dis_lab;
USE dis_lab;

-- =============================================================================
-- PRE-LAB SETUP
-- =============================================================================

DROP TABLE IF EXISTS Employees;

-- =============================================================================
-- CREATE TABLE
-- =============================================================================

CREATE TABLE Employees
(
    Emp_ID INT PRIMARY KEY,
    Emp_Name VARCHAR(50),
    Salary INT,
    Department VARCHAR(50)
);

-- =============================================================================
-- INSERT SAMPLE DATA
-- =============================================================================

INSERT INTO Employees VALUES
(101,'Aman',50000,'IT'),
(102,'Riya',60000,'HR'),
(103,'Kabir',55000,'Finance'),
(104,'Neha',70000,'IT'),
(105,'Arjun',65000,'HR'),
(106,'Simran',52000,'Finance'),
(107,'Rahul',72000,'IT');

-- =============================================================================
-- Q1 : UNDERSTANDING B+ TREE INDEX CREATION
-- =============================================================================

/*
Create index on Salary column
*/

CREATE INDEX idx_salary
ON Employees(Salary);

-- Verify index creation

SHOW INDEX
FROM Employees;

-- Search using indexed column

SELECT *
FROM Employees
WHERE Salary = 60000;

-- Observe execution plan

EXPLAIN
SELECT *
FROM Employees
WHERE Salary = 60000;

-- =============================================================================
-- Q2 : B+ TREE SEARCH OPERATION
-- =============================================================================

/*
Execute range query
*/

SELECT *
FROM Employees
WHERE Salary BETWEEN 50000 AND 65000;

-- Drop index

DROP INDEX idx_salary
ON Employees;

-- Observe execution plan after dropping index

EXPLAIN
SELECT *
FROM Employees
WHERE Salary BETWEEN 50000 AND 65000;

-- Recreate index

CREATE INDEX idx_salary
ON Employees(Salary);

-- =============================================================================
-- Q3 : B+ TREE INSERTION MECHANICS
-- =============================================================================

/*
Insert new employee records
*/

INSERT INTO Employees
VALUES
(108,'Priya',58000,'IT');

INSERT INTO Employees
VALUES
(109,'Karan',75000,'Finance');

-- Display records ordered by Salary

SELECT *
FROM Employees
ORDER BY Salary;

-- =============================================================================
-- Q4 : B+ TREE DELETION MECHANICS
-- =============================================================================

/*
Delete employee having salary 52000
*/

DELETE FROM Employees
WHERE Salary = 52000;

-- Display records after deletion

SELECT *
FROM Employees
ORDER BY Salary;

-- =============================================================================
-- Q5 : INDEX ON MULTIPLE COLUMNS
-- =============================================================================

/*
Create composite index
*/

CREATE INDEX idx_dept_salary
ON Employees(Department, Salary);

-- Execute query using composite index

SELECT *
FROM Employees
WHERE Department = 'IT'
AND Salary > 60000;

-- Observe execution plan

EXPLAIN
SELECT *
FROM Employees
WHERE Department = 'IT'
AND Salary > 60000;

-- =============================================================================
-- VERIFY INDEXES
-- =============================================================================

SHOW INDEX
FROM Employees;

-- =============================================================================
-- END OF ASSIGNMENT
-- =============================================================================