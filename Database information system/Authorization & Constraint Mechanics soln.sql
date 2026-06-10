/****************************************************************************************
                Authorization & Constraint Mechanics
*****************************************************************************************
Q1 : Basic Authorization (GRANT & REVOKE)
Q2 : Privilege Delegation (WITH GRANT OPTION)
Q3 : Authorization using Views
Q4 : Constraint Mechanics
      - NOT NULL
      - DEFAULT
      - UNIQUE
      - ON DELETE CASCADE
      - ON DELETE SET NULL

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

DROP TABLE IF EXISTS Enrollments;
DROP TABLE IF EXISTS Courses;
DROP TABLE IF EXISTS Students;

-- =============================================================================
-- STUDENTS TABLE
-- =============================================================================

CREATE TABLE Students
(
    Student_ID INT PRIMARY KEY,

    Student_Name VARCHAR(50) NOT NULL,
    -- NOT NULL Constraint

    Email VARCHAR(100) UNIQUE,
    -- UNIQUE Constraint

    City VARCHAR(50) DEFAULT 'Jaipur'
    -- DEFAULT Constraint
);

-- =============================================================================
-- COURSES TABLE
-- =============================================================================

CREATE TABLE Courses
(
    Course_ID INT PRIMARY KEY,

    Course_Name VARCHAR(50)
);

-- =============================================================================
-- ENROLLMENTS TABLE
-- =============================================================================

CREATE TABLE Enrollments
(
    Enroll_ID INT PRIMARY KEY,

    Student_ID INT,

    Course_ID INT,

    CONSTRAINT fk_student
    FOREIGN KEY(Student_ID)
    REFERENCES Students(Student_ID)
    ON DELETE CASCADE,

    CONSTRAINT fk_course
    FOREIGN KEY(Course_ID)
    REFERENCES Courses(Course_ID)
    ON DELETE SET NULL
);

-- =============================================================================
-- INSERT SAMPLE DATA
-- =============================================================================

INSERT INTO Students
VALUES
(101,'Aman','aman@email.com','Delhi'),
(102,'Riya','riya@email.com','Mumbai'),
(103,'Kabir','kabir@email.com','Jaipur');

INSERT INTO Courses
VALUES
(1,'DBMS'),
(2,'Operating Systems'),
(3,'Computer Networks');

INSERT INTO Enrollments
VALUES
(1,101,1),
(2,102,2),
(3,103,3);

-- =============================================================================
-- Q1 : TESTING BASIC AUTHORIZATION
-- =============================================================================

/*
Administrator wants
read-only access
for userA
*/

-- =============================================================================
-- STEP 1 : CREATE USER
-- =============================================================================

CREATE USER IF NOT EXISTS 'userA'@'localhost'
IDENTIFIED BY 'userA123';

-- =============================================================================
-- STEP 2 : GRANT SELECT PRIVILEGE
-- =============================================================================

GRANT SELECT
ON dis_lab.Students
TO 'userA'@'localhost';

FLUSH PRIVILEGES;

-- =============================================================================
-- STEP 3 : LOGIN AS userA
-- =============================================================================

/*
Run:

SELECT * FROM Students;
*/

SELECT * FROM Students;

-- =============================================================================
-- STEP 4 : TRY DELETE OPERATION
-- =============================================================================

DELETE FROM Students
WHERE Student_ID = 101;

/*
Expected Error

ERROR 1142 (42000):
DELETE command denied to user
'userA'@'localhost'
for table 'Students'

Reason:
Only SELECT privilege granted.
*/

-- =============================================================================
-- STEP 5 : REVOKE SELECT PRIVILEGE
-- =============================================================================

REVOKE SELECT
ON dis_lab.Students
FROM 'userA'@'localhost';

FLUSH PRIVILEGES;

-- =============================================================================
-- VERIFY
-- =============================================================================

/*
Run as userA

SELECT * FROM Students;

Expected Error

ERROR 1142 (42000):
SELECT command denied
*/

-- =============================================================================
-- Q2 : PRIVILEGE DELEGATION
-- =============================================================================

/*
Test privilege propagation
using WITH GRANT OPTION
*/

-- =============================================================================
-- CREATE USERS
-- =============================================================================

CREATE USER IF NOT EXISTS 'userB'@'localhost'
IDENTIFIED BY 'userB123';

CREATE USER IF NOT EXISTS 'userC'@'localhost'
IDENTIFIED BY 'userC123';

-- =============================================================================
-- ADMIN GRANTS TO userB
-- =============================================================================

GRANT SELECT
ON dis_lab.Students
TO 'userB'@'localhost'
WITH GRANT OPTION;

FLUSH PRIVILEGES;

-- =============================================================================
-- LOGIN AS userB
-- =============================================================================

GRANT SELECT
ON dis_lab.Students
TO 'userC'@'localhost';

FLUSH PRIVILEGES;

-- =============================================================================
-- LOGIN AS userC
-- =============================================================================

SELECT * FROM Students;

/*
Success

userC can read records
because privilege delegated
from userB
*/

-- =============================================================================
-- ADMIN REVOKES userB PRIVILEGE
-- =============================================================================

REVOKE SELECT
ON dis_lab.Students
FROM 'userB'@'localhost';

FLUSH PRIVILEGES;

-- =============================================================================
-- TEST userC AGAIN
-- =============================================================================

SELECT * FROM Students;

/*
Observation

In MySQL:

Privileges granted through
WITH GRANT OPTION
are revoked recursively.

Result:

userC loses privilege too.

This is called
Cascading Revocation.
*/

-- =============================================================================
-- Q3 : AUTHORIZATION USING VIEWS
-- =============================================================================

/*
Hide Email field
from regular users
*/

-- =============================================================================
-- CREATE VIEW
-- =============================================================================

CREATE VIEW Student_Public AS

SELECT
    Student_ID,
    Student_Name,
    City
FROM Students;

-- =============================================================================
-- CREATE userD
-- =============================================================================

CREATE USER IF NOT EXISTS 'userD'@'localhost'
IDENTIFIED BY 'userD123';

-- =============================================================================
-- GRANT ACCESS TO VIEW ONLY
-- =============================================================================

GRANT SELECT
ON dis_lab.Student_Public
TO 'userD'@'localhost';

FLUSH PRIVILEGES;

-- =============================================================================
-- LOGIN AS userD
-- =============================================================================

SELECT *
FROM Student_Public;

/*
Output

Student_ID | Student_Name | City

Email column hidden
*/

-- =============================================================================
-- ATTEMPT DIRECT ACCESS
-- =============================================================================

SELECT Email
FROM Students;

/*
Expected Error

ERROR 1142 (42000):
SELECT command denied
to user 'userD'

Reason:

userD only has access
to the View
not base table.
*/

-- =============================================================================
-- Q4 : CONSTRAINT MECHANICS
-- =============================================================================

-- =============================================================================
-- Q4(A) NOT NULL CONSTRAINT
-- =============================================================================

/*
Attempt insertion
without Student_Name
*/

INSERT INTO Students
(
    Student_ID,
    Email,
    City
)
VALUES
(
    104,
    'new@email.com',
    'Delhi'
);

/*
Expected Error

ERROR 1364 (HY000):
Field 'Student_Name'
doesn't have a default value

OR

Column 'Student_Name'
cannot be null
*/

-- =============================================================================
-- Q4(B) DEFAULT CONSTRAINT
-- =============================================================================

/*
Insert student
without City
*/

INSERT INTO Students
(
    Student_ID,
    Student_Name,
    Email
)
VALUES
(
    104,
    'Neha',
    'neha@email.com'
);

-- Verify

SELECT *
FROM Students
WHERE Student_ID = 104;

/*
Output

City = Jaipur

Automatically assigned.
*/

-- =============================================================================
-- Q4(C) UNIQUE CONSTRAINT
-- =============================================================================

/*
Try duplicate Email
*/

INSERT INTO Students
VALUES
(
    105,
    'Rohan',
    'aman@email.com',
    'Delhi'
);

/*
Expected Error

ERROR 1062 (23000):
Duplicate entry
'aman@email.com'
for key 'Email'
*/

-- =============================================================================
-- Q4(D) FOREIGN KEY ACTIONS
-- =============================================================================

DROP TABLE IF EXISTS Enrollments_New;

-- =============================================================================
-- CREATE NEW TABLE
-- =============================================================================

CREATE TABLE Enrollments_New
(
    Enroll_ID INT PRIMARY KEY,

    Student_ID INT,

    Course_ID INT,

    FOREIGN KEY(Student_ID)
    REFERENCES Students(Student_ID)
    ON DELETE CASCADE,

    FOREIGN KEY(Course_ID)
    REFERENCES Courses(Course_ID)
    ON DELETE SET NULL
);

-- =============================================================================
-- INSERT SAMPLE DATA
-- =============================================================================

INSERT INTO Enrollments_New
VALUES
(1,101,1),
(2,102,2),
(3,103,3);

-- =============================================================================
-- VIEW DATA BEFORE DELETION
-- =============================================================================

SELECT *
FROM Enrollments_New;

-- =============================================================================
-- TEST ON DELETE CASCADE
-- =============================================================================

/*
Delete Student 101
*/

DELETE FROM Students
WHERE Student_ID = 101;

-- Check Child Table

SELECT *
FROM Enrollments_New;

/*
Observation

Record:

(1,101,1)

is automatically deleted.

Reason:

ON DELETE CASCADE
removes dependent rows.
*/

-- =============================================================================
-- TEST ON DELETE SET NULL
-- =============================================================================

/*
Delete Course 2
*/

DELETE FROM Courses
WHERE Course_ID = 2;

-- Check Child Table

SELECT *
FROM Enrollments_New;

/*
Before

Enroll_ID | Student_ID | Course_ID
-----------------------------------
2         | 102        | 2

After

Enroll_ID | Student_ID | Course_ID
-----------------------------------
2         | 102        | NULL

Reason:

ON DELETE SET NULL
sets foreign key value
to NULL instead of deleting row.
*/

-- =============================================================================
-- BEFORE & AFTER COMPARISON QUERIES
-- =============================================================================

SELECT * FROM Students;

SELECT * FROM Courses;

SELECT * FROM Enrollments;

SELECT * FROM Enrollments_New;

-- =============================================================================
-- SHOW USER PRIVILEGES
-- =============================================================================

SHOW GRANTS FOR 'userA'@'localhost';

SHOW GRANTS FOR 'userB'@'localhost';

SHOW GRANTS FOR 'userC'@'localhost';

SHOW GRANTS FOR 'userD'@'localhost';

-- =============================================================================
-- END OF ASSIGNMENT 
-- =============================================================================
