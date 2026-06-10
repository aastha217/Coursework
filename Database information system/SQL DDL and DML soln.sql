/****************************************************************************************
                            SQL DDL AND DML
****************************************************************************************/

CREATE DATABASE IF NOT EXISTS dis_lab;
USE dis_lab;

-- =============================================================================
-- PRE-LAB SETUP
-- =============================================================================

SET SQL_SAFE_UPDATES = 0;

DROP TABLE IF EXISTS New_Candidates;
DROP TABLE IF EXISTS Student_Registry;

-- =============================================================================
-- CREATE STUDENT_REGISTRY TABLE
-- =============================================================================

CREATE TABLE Student_Registry
(
    ID VARCHAR(10) PRIMARY KEY,

    Name VARCHAR(50) NOT NULL,

    Dept_Name VARCHAR(30),

    Total_Credits INT,

    Email VARCHAR(100)
);

-- =============================================================================
-- CREATE NEW_CANDIDATES TABLE
-- =============================================================================

CREATE TABLE New_Candidates
(
    Cand_ID VARCHAR(10),

    Cand_Name VARCHAR(50),

    Cand_Dept VARCHAR(30),

    Cand_Credits INT
);

-- =============================================================================
-- INSERT SAMPLE DATA
-- =============================================================================

INSERT INTO Student_Registry VALUES
('00128','Zhang','Comp. Sci.',102,'zhang@email.com'),
('12345','Shankar','Finance',32,NULL),
('19991','Brandt','History',80,'brandt@email.com'),
('23121','Chavez','Physics',50,NULL),
('44553','Ayan','General',0,NULL);

INSERT INTO New_Candidates VALUES
('30001','Valid Student','CSE',40),
('30002','Null Dept Student',NULL,35),
('30003','Negative Creds','Physics',-5);

-- =============================================================================
-- Q1 : CONDITIONAL DATA RETRIEVAL
-- =============================================================================

/*
Students with credits
between 40 and 80
*/

SELECT
    ID,
    Name,
    Total_Credits
FROM Student_Registry
WHERE Total_Credits BETWEEN 40 AND 80;

-- Students without email

SELECT *
FROM Student_Registry
WHERE Email IS NULL;

-- Department starts with C

SELECT *
FROM Student_Registry
WHERE Dept_Name LIKE 'C%';

-- Students from History or Physics

SELECT
    Name,
    Dept_Name
FROM Student_Registry
WHERE Dept_Name IN ('History','Physics');

-- Display unique departments

SELECT DISTINCT Dept_Name
FROM Student_Registry;

-- =============================================================================
-- Q2 : COMPLEX FILTERS
-- =============================================================================

/*
Comp. Sci. students
having credits >30 and <100
*/

SELECT *
FROM Student_Registry
WHERE Dept_Name = 'Comp. Sci.'
AND Total_Credits > 30
AND Total_Credits < 100;

-- Students not in Comp. Sci.

SELECT *
FROM Student_Registry
WHERE Dept_Name <> 'Comp. Sci.';

-- Students having 0 credits
-- OR belonging to General department

SELECT *
FROM Student_Registry
WHERE Total_Credits = 0
OR Dept_Name = 'General';

-- =============================================================================
-- Q3 : INSERT INTO ... SELECT
-- =============================================================================

/*
Transfer only valid candidates

Conditions:
1. Department NOT NULL
2. Credits >= 0
*/

INSERT INTO Student_Registry
(
    ID,
    Name,
    Dept_Name,
    Total_Credits
)
SELECT
    Cand_ID,
    Cand_Name,
    Cand_Dept,
    Cand_Credits
FROM New_Candidates
WHERE Cand_Dept IS NOT NULL
AND Cand_Credits >= 0;

-- Verify transfer

SELECT *
FROM Student_Registry;

-- =============================================================================
-- Q4 : BULK UPDATES
-- =============================================================================

/*
Increase credits by 5
for Comp. Sci. students
having less than 60 credits
*/

UPDATE Student_Registry
SET Total_Credits = Total_Credits + 5
WHERE Dept_Name = 'Comp. Sci.'
AND Total_Credits < 60;

-- Generate email for NULL values

UPDATE Student_Registry
SET Email = CONCAT(ID,'@univ.edu')
WHERE Email IS NULL;

-- Increase credits by 2
-- for odd credit values

UPDATE Student_Registry
SET Total_Credits = Total_Credits + 2
WHERE Total_Credits % 2 = 1;

-- Verify updates

SELECT *
FROM Student_Registry;

-- =============================================================================
-- Q5 : DATA CLEANUP
-- =============================================================================

/*
Delete students from
General department
having credits less than 10
*/

DELETE FROM Student_Registry
WHERE Dept_Name = 'General'
AND Total_Credits < 10;

-- Delete records having
-- negative credits

DELETE FROM Student_Registry
WHERE Total_Credits < 0;

-- Verify final data

SELECT *
FROM Student_Registry;

-- =============================================================================
-- END OF ASSIGNMENT
-- =============================================================================