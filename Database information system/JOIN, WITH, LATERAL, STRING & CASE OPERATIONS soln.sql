/****************************************************************************************
                JOIN, WITH, LATERAL, STRING & CASE OPERATIONS
****************************************************************************************/

CREATE DATABASE IF NOT EXISTS dis_lab;
USE dis_lab;

-- =============================================================================
-- PRE-LAB SETUP
-- =============================================================================

SET SQL_SAFE_UPDATES = 0;

DROP TABLE IF EXISTS Enrollment;
DROP TABLE IF EXISTS Course;
DROP TABLE IF EXISTS Student;

-- =============================================================================
-- CREATE SCHEMA
-- =============================================================================

CREATE TABLE Student
(
    Student_ID INT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Dept_Name VARCHAR(30)
);

CREATE TABLE Course
(
    Course_ID INT PRIMARY KEY,
    Course_Name VARCHAR(50),
    Dept_Name VARCHAR(30),
    Credits INT
);

CREATE TABLE Enrollment
(
    Enroll_ID INT PRIMARY KEY,
    Student_ID INT,
    Course_ID INT,
    Semester VARCHAR(10),
    Grade CHAR(1)
);

-- =============================================================================
-- INSERT SAMPLE DATA
-- =============================================================================

INSERT INTO Student VALUES
(1,' aaRAv shaRMa ','CSE'),
(2,'neha VERMA','CSE'),
(3,'Rohan Singh','Physics'),
(4,'Meera Joshi','Math'),
(5,'Ishita Roy','History');

INSERT INTO Course VALUES
(101,'DBMS','CSE',4),
(102,'Operating Systems','CSE',3),
(103,'Quantum Mechanics','Physics',4),
(104,'Linear Algebra','Math',3);

INSERT INTO Enrollment VALUES
(1,1,101,'Sem1','A'),
(2,1,102,'Sem1','B'),
(3,2,101,'Sem1','A'),
(4,3,103,'Sem1','C'),
(5,4,104,'Sem1','A'),
(6,2,102,'Sem1','B');

-- =============================================================================
-- Q1 : INNER JOIN OPERATIONS
-- =============================================================================

/*
Display Student Name,
Course Name and Grade
*/

SELECT
    S.Name,
    C.Course_Name,
    E.Grade
FROM Student S
INNER JOIN Enrollment E
ON S.Student_ID = E.Student_ID
INNER JOIN Course C
ON E.Course_ID = C.Course_ID;

-- Students enrolled in CSE courses

SELECT DISTINCT
    S.Name
FROM Student S
JOIN Enrollment E
ON S.Student_ID = E.Student_ID
JOIN Course C
ON E.Course_ID = C.Course_ID
WHERE C.Dept_Name = 'CSE';

-- Students who achieved Grade A

SELECT
    S.Name,
    C.Course_Name
FROM Student S
JOIN Enrollment E
ON S.Student_ID = E.Student_ID
JOIN Course C
ON E.Course_ID = C.Course_ID
WHERE E.Grade = 'A';

-- =============================================================================
-- Q2 : STRING OPERATIONS
-- =============================================================================

/*
Remove spaces and
convert names to uppercase
*/

SELECT
    Student_ID,
    UPPER(TRIM(Name)) AS Formatted_Name
FROM Student;

-- Create Login ID

SELECT
    Student_ID,
    CONCAT
    (
        UPPER(LEFT(TRIM(Name),3)),
        Student_ID
    ) AS Login_ID
FROM Student;

-- Students whose name starts with A or M

SELECT *
FROM Student
WHERE UPPER(LEFT(TRIM(Name),1))
IN ('A','M');

-- =============================================================================
-- Q3 : CASE OPERATIONS
-- =============================================================================

/*
Display Remarks
based on Grade
*/

SELECT
    S.Name,
    E.Grade,

    CASE
        WHEN E.Grade = 'A'
        THEN 'Excellent'

        WHEN E.Grade = 'B'
        THEN 'Good'

        ELSE 'Needs Improvement'
    END AS Remarks

FROM Student S
JOIN Enrollment E
ON S.Student_ID = E.Student_ID;

-- Categorize courses

SELECT
    Course_Name,
    Credits,

    CASE
        WHEN Credits >= 4
        THEN 'Core Course'

        ELSE 'Elective Course'
    END AS Course_Type

FROM Course;

-- =============================================================================
-- Q4 : COMMON TABLE EXPRESSIONS (CTE)
-- =============================================================================

/*
Compute total credits
taken by each student
*/

WITH Student_Credits AS
(
    SELECT
        S.Student_ID,
        S.Name,

        SUM(C.Credits)
        AS Total_Credits

    FROM Student S
    JOIN Enrollment E
    ON S.Student_ID = E.Student_ID

    JOIN Course C
    ON E.Course_ID = C.Course_ID

    GROUP BY
    S.Student_ID,
    S.Name
)

SELECT *
FROM Student_Credits
WHERE Total_Credits > 5;

-- Count enrollments per department

WITH Department_Enrollments AS
(
    SELECT
        C.Dept_Name,

        COUNT(*) AS Total_Enrollments

    FROM Enrollment E
    JOIN Course C
    ON E.Course_ID = C.Course_ID

    GROUP BY C.Dept_Name
)

SELECT *
FROM Department_Enrollments
WHERE Total_Enrollments > 1;

-- =============================================================================
-- Q5 : LATERAL JOIN
-- =============================================================================

/*
For every student,
retrieve course with
highest grade
*/

SELECT
    S.Student_ID,
    S.Name,
    X.Course_Name,
    X.Grade

FROM Student S

JOIN LATERAL
(
    SELECT
        C.Course_Name,
        E.Grade

    FROM Enrollment E
    JOIN Course C
    ON E.Course_ID = C.Course_ID

    WHERE E.Student_ID = S.Student_ID

    ORDER BY E.Grade ASC
    LIMIT 1
) AS X
ON TRUE;

-- =============================================================================
-- VERIFICATION QUERIES
-- =============================================================================

SELECT * FROM Student;

SELECT * FROM Course;

SELECT * FROM Enrollment;

-- =============================================================================
-- END OF ASSIGNMENT
-- =============================================================================