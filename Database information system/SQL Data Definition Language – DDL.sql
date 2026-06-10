/****************************************************************************************
                    SQL Data Definition Language (DDL)
****************************************************************************************/

CREATE DATABASE IF NOT EXISTS dis_lab;
USE dis_lab;

-- =============================================================================
-- Q1 : DESIGN AND IMPLEMENTATION OF A ROBUST SCHEMA
-- =============================================================================

/*
Create Student_Registry table

Requirements:
1. Preserve leading zeros in ID
2. Default department = General
3. Total credits cannot be negative
*/

DROP TABLE IF EXISTS Student_Registry;

CREATE TABLE Student_Registry
(
    Student_ID VARCHAR(10) PRIMARY KEY,

    Name VARCHAR(30),

    Dept_Name VARCHAR(30)
    DEFAULT 'General',

    Tot_Cred INT
    CHECK (Tot_Cred >= 0)
);

-- =============================================================================
-- INSERT SAMPLE DATA
-- =============================================================================

/*
Insert data from the given dataset.

Use VARCHAR for Student_ID
so leading zeros are preserved.
*/

INSERT INTO Student_Registry
VALUES
('00128','Zhang','Comp. Sci.',102);

INSERT INTO Student_Registry
VALUES
('12345','Shankar','Finance',32);

INSERT INTO Student_Registry
VALUES
('19991','Brandt','History',80);

INSERT INTO Student_Registry
(
    Student_ID,
    Name,
    Tot_Cred
)
VALUES
(
    '23121',
    'Chavez',
    110
);

-- Verify data

SELECT *
FROM Student_Registry;

-- =============================================================================
-- Q2 : SCHEMA EVOLUTION AND INTEGRITY ENFORCEMENT
-- =============================================================================

-- =============================================================================
-- ADD CREDIT LIMIT CONSTRAINT
-- =============================================================================

/*
Maximum credits allowed = 100
*/

ALTER TABLE Student_Registry
ADD CONSTRAINT chk_credit_limit
CHECK (Tot_Cred <= 100);

-- =============================================================================
-- FIX INVALID DATA
-- =============================================================================

/*
Update records having
credits greater than 100
*/

UPDATE Student_Registry
SET Tot_Cred = 100
WHERE Tot_Cred > 100;

-- Reapply constraint

ALTER TABLE Student_Registry
ADD CONSTRAINT chk_credit_limit
CHECK (Tot_Cred <= 100);

-- Verify data

SELECT *
FROM Student_Registry;

-- =============================================================================
-- ADD EMAIL COLUMN
-- =============================================================================

/*
Each email must be unique
*/

ALTER TABLE Student_Registry
ADD Email VARCHAR(100);

ALTER TABLE Student_Registry
ADD CONSTRAINT unique_email
UNIQUE(Email);

-- =============================================================================
-- UPDATE EMAIL VALUES
-- =============================================================================

UPDATE Student_Registry
SET Email = 'zhang@email.com'
WHERE Student_ID = '00128';

UPDATE Student_Registry
SET Email = 'shankar@email.com'
WHERE Student_ID = '12345';

UPDATE Student_Registry
SET Email = 'brandt@email.com'
WHERE Student_ID = '19991';

UPDATE Student_Registry
SET Email = 'chavez@email.com'
WHERE Student_ID = '23121';

-- =============================================================================
-- STRUCTURAL REFACTORING
-- =============================================================================

/*
Rename Tot_Cred
to Total_Credits
*/

ALTER TABLE Student_Registry
RENAME COLUMN Tot_Cred
TO Total_Credits;

-- Increase Name size

ALTER TABLE Student_Registry
MODIFY Name VARCHAR(40);

-- Verify structure

DESCRIBE Student_Registry;

-- =============================================================================
-- STRUCTURAL CLEANUP
-- =============================================================================

/*
TRUNCATE removes all rows
but keeps table structure
*/

TRUNCATE TABLE Student_Registry;

-- Verify structure exists

SHOW TABLES;

DESCRIBE Student_Registry;

-- =============================================================================
-- DROP TABLE
-- =============================================================================

/*
DROP removes both
data and table structure
*/

DROP TABLE Student_Registry;

-- Verify table removal

SHOW TABLES;

-- =============================================================================
-- END OF ASSIGNMENT
-- =============================================================================