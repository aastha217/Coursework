/****************************************************************************************
                        Basic Indexing Concepts
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
    Name VARCHAR(50),
    Dept_Name VARCHAR(30)
);

CREATE TABLE Course
(
    Course_ID INT PRIMARY KEY,
    Course_Name VARCHAR(50),
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
(101,'Aarav','CSE'),
(102,'Neha','CSE'),
(103,'Rohan','Physics'),
(104,'Meera','Math'),
(105,'Ishita','History');

INSERT INTO Course VALUES
(201,'DBMS',4),
(202,'OS',3),
(203,'Physics',4),
(204,'Algebra',3);

INSERT INTO Enrollment VALUES
(1,101,201,'Sem1','A'),
(2,101,202,'Sem1','B'),
(3,102,201,'Sem1','A'),
(4,103,203,'Sem1','C'),
(5,104,204,'Sem1','A'),
(6,102,202,'Sem1','B');

-- =============================================================================
-- Q1 : BASIC INDEX CREATION & USAGE
-- =============================================================================

/*
Retrieve student with Student_ID = 101
*/

SELECT *
FROM Student
WHERE Student_ID = 101;

-- Create index on Student_ID

CREATE INDEX idx_student_id
ON Student(Student_ID);

-- Execute query again

SELECT *
FROM Student
WHERE Student_ID = 101;

-- Display all indexes

SHOW INDEX
FROM Student;

-- =============================================================================
-- Q2 : INDEX ON NON-KEY ATTRIBUTE
-- =============================================================================

/*
Create index on Dept_Name
*/

CREATE INDEX idx_dept_name
ON Student(Dept_Name);

-- Retrieve all students from CSE department

SELECT *
FROM Student
WHERE Dept_Name = 'CSE';

-- Count students per department

SELECT
    Dept_Name,
    COUNT(*) AS Total_Students
FROM Student
GROUP BY Dept_Name;

-- =============================================================================
-- Q3 : INDEX ON COURSE TABLE
-- =============================================================================

/*
Create index on Course_Name
*/

CREATE INDEX idx_course_name
ON Course(Course_Name);

-- Retrieve DBMS course details

SELECT *
FROM Course
WHERE Course_Name = 'DBMS';

-- Retrieve courses with Credits >= 3

SELECT *
FROM Course
WHERE Credits >= 3;

-- =============================================================================
-- Q4 : COMPOSITE INDEX
-- =============================================================================

/*
Create composite index
*/

CREATE INDEX idx_student_course
ON Enrollment(Student_ID, Course_ID);

-- Retrieve records for Student_ID = 102

SELECT *
FROM Enrollment
WHERE Student_ID = 102;

-- Retrieve all courses taken by Student_ID = 102

SELECT
    C.Course_ID,
    C.Course_Name,
    E.Semester,
    E.Grade
FROM Enrollment E
JOIN Course C
ON E.Course_ID = C.Course_ID
WHERE E.Student_ID = 102;

-- =============================================================================
-- Q5 : INDEX MAINTENANCE
-- =============================================================================

/*
Drop index on Dept_Name
*/

DROP INDEX idx_dept_name
ON Student;

-- Verify index removal

SHOW INDEX
FROM Student;

-- Recreate index

CREATE INDEX idx_dept_name
ON Student(Dept_Name);

-- =============================================================================
-- Q6 : MULTIPLE INDEX USAGE
-- =============================================================================

/*
Create indexes on Name and Grade
*/

CREATE INDEX idx_student_name
ON Student(Name);

CREATE INDEX idx_grade
ON Enrollment(Grade);

-- Students whose name starts with A

SELECT *
FROM Student
WHERE Name LIKE 'A%';

-- Students with Grade = A

SELECT
    S.Student_ID,
    S.Name,
    E.Grade
FROM Student S
JOIN Enrollment E
ON S.Student_ID = E.Student_ID
WHERE E.Grade = 'A';

-- =============================================================================
-- Q7 : COMBINED QUERY OPTIMIZATION
-- =============================================================================

/*
Ensure indexes exist on Student_ID and Course_ID
*/

CREATE INDEX idx_enrollment_student
ON Enrollment(Student_ID);

CREATE INDEX idx_enrollment_course
ON Enrollment(Course_ID);

-- Display Student Name, Course Name and Grade

SELECT
    S.Name AS Student_Name,
    C.Course_Name,
    E.Grade
FROM Enrollment E
JOIN Student S
ON E.Student_ID = S.Student_ID
JOIN Course C
ON E.Course_ID = C.Course_ID;

-- =============================================================================
-- VERIFY INDEXES
-- =============================================================================

SHOW INDEX FROM Student;

SHOW INDEX FROM Course;

SHOW INDEX FROM Enrollment;

-- =============================================================================
-- END OF ASSIGNMENT
-- =============================================================================