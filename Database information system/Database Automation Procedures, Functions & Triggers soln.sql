/****************************************************************************************
            Database Automation : Procedures, Functions & Triggers
****************************************************************************************/

CREATE DATABASE IF NOT EXISTS dis_lab;
USE dis_lab;

-- =============================================================================
-- PRE-LAB SETUP
-- =============================================================================

SET SQL_SAFE_UPDATES = 0;

DROP TRIGGER IF EXISTS before_insert_enrollment;
DROP TRIGGER IF EXISTS after_update_grade;

DROP PROCEDURE IF EXISTS Enroll_Student;
DROP PROCEDURE IF EXISTS Department_Report;

DROP FUNCTION IF EXISTS Calculate_GPA;

DROP TABLE IF EXISTS Grade_Log;
DROP TABLE IF EXISTS Enrollment;
DROP TABLE IF EXISTS Student;
DROP TABLE IF EXISTS Course;

-- =============================================================================
-- CREATE SCHEMA
-- =============================================================================

CREATE TABLE Student
(
    Student_ID INT PRIMARY KEY,
    Name VARCHAR(50),
    Dept_Name VARCHAR(30),
    Total_Credits INT DEFAULT 0
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
    Grade CHAR(1),

    FOREIGN KEY(Student_ID)
    REFERENCES Student(Student_ID),

    FOREIGN KEY(Course_ID)
    REFERENCES Course(Course_ID)
);

CREATE TABLE Grade_Log
(
    Log_ID INT AUTO_INCREMENT PRIMARY KEY,
    Student_ID INT,
    Old_Grade CHAR(1),
    New_Grade CHAR(1),
    Change_Date DATETIME
);

-- =============================================================================
-- INSERT SAMPLE DATA
-- =============================================================================

INSERT INTO Student VALUES
(1,'Aarav','CSE',0),
(2,'Neha','CSE',0),
(3,'Rohan','Physics',0);

INSERT INTO Course VALUES
(101,'DBMS',4),
(102,'OS',3),
(103,'Mathematics',4);

INSERT INTO Enrollment VALUES
(1,1,101,'A'),
(2,1,102,'B'),
(3,2,101,'A');

UPDATE Student
SET Total_Credits = 7
WHERE Student_ID = 1;

UPDATE Student
SET Total_Credits = 4
WHERE Student_ID = 2;

-- =============================================================================
-- Q1 : ENROLLMENT AUTOMATION
-- =============================================================================

/*
Create procedure to:
1. Enroll student
2. Update Total_Credits automatically
*/

DELIMITER //

CREATE PROCEDURE Enroll_Student
(
    IN p_Student_ID INT,
    IN p_Course_ID INT,
    IN p_Grade CHAR(1)
)
BEGIN

    DECLARE v_Credits INT;
    DECLARE v_Enroll_ID INT;

    SELECT Credits
    INTO v_Credits
    FROM Course
    WHERE Course_ID = p_Course_ID;

    SELECT IFNULL(MAX(Enroll_ID),0) + 1
    INTO v_Enroll_ID
    FROM Enrollment;

    INSERT INTO Enrollment
    VALUES
    (
        v_Enroll_ID,
        p_Student_ID,
        p_Course_ID,
        p_Grade
    );

    UPDATE Student
    SET Total_Credits = Total_Credits + v_Credits
    WHERE Student_ID = p_Student_ID;

END //

DELIMITER ;

-- Enroll Rohan in OS with grade B

CALL Enroll_Student(3,102,'B');

-- Verify credits

SELECT *
FROM Student
WHERE Student_ID = 3;

-- =============================================================================
-- Q2 : GPA CALCULATOR FUNCTION
-- =============================================================================

/*
Grade Scale

A = 10
B = 8
C = 6
D = 4
F = 0
*/

DELIMITER //

CREATE FUNCTION Calculate_GPA
(
    p_Student_ID INT
)
RETURNS DECIMAL(5,2)

DETERMINISTIC

BEGIN

    DECLARE v_GPA DECIMAL(5,2);

    SELECT
    SUM(
        CASE Grade
            WHEN 'A' THEN 10
            WHEN 'B' THEN 8
            WHEN 'C' THEN 6
            WHEN 'D' THEN 4
            WHEN 'F' THEN 0
        END * C.Credits
    ) / SUM(C.Credits)

    INTO v_GPA

    FROM Enrollment E
    JOIN Course C
    ON E.Course_ID = C.Course_ID

    WHERE E.Student_ID = p_Student_ID;

    RETURN IFNULL(v_GPA,0);

END //

DELIMITER ;

-- Generate GPA report

SELECT
    Student_ID,
    Name,
    Calculate_GPA(Student_ID) AS GPA
FROM Student;

-- =============================================================================
-- Q3 : INTEGRITY & AUDITING
-- =============================================================================

-- =============================================================================
-- TRIGGER TO PREVENT NULL GRADE
-- =============================================================================

DELIMITER //

CREATE TRIGGER before_insert_enrollment
BEFORE INSERT
ON Enrollment
FOR EACH ROW

BEGIN

    IF NEW.Grade IS NULL THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Grade cannot be NULL';

    END IF;

END //

DELIMITER ;

-- =============================================================================
-- TRIGGER TO LOG GRADE CHANGES
-- =============================================================================

DELIMITER //

CREATE TRIGGER after_update_grade
AFTER UPDATE
ON Enrollment
FOR EACH ROW

BEGIN

    IF OLD.Grade <> NEW.Grade THEN

        INSERT INTO Grade_Log
        (
            Student_ID,
            Old_Grade,
            New_Grade,
            Change_Date
        )
        VALUES
        (
            NEW.Student_ID,
            OLD.Grade,
            NEW.Grade,
            NOW()
        );

    END IF;

END //

DELIMITER ;

-- =============================================================================
-- CHECK 1 : INSERT NULL GRADE
-- =============================================================================

INSERT INTO Enrollment
VALUES
(
    10,
    3,
    103,
    NULL
);

-- =============================================================================
-- CHECK 2 : CHANGE AARAV'S GRADE
-- =============================================================================

UPDATE Enrollment
SET Grade = 'B'
WHERE Student_ID = 1
AND Course_ID = 101;

-- View audit log

SELECT *
FROM Grade_Log;

-- =============================================================================
-- Q4 : HOD REPORT
-- =============================================================================

/*
Generate department summary
using Calculate_GPA function
*/

DELIMITER //

CREATE PROCEDURE Department_Report
(
    IN p_Department VARCHAR(30)
)
BEGIN

    SELECT
        Dept_Name AS Department,

        COUNT(*) AS Total_Students,

        AVG
        (
            Calculate_GPA(Student_ID)
        ) AS Average_GPA

    FROM Student

    WHERE Dept_Name = p_Department

    GROUP BY Dept_Name;

END //

DELIMITER ;

-- Generate report for CSE

CALL Department_Report('CSE');

-- Generate report for Physics

CALL Department_Report('Physics');

-- =============================================================================
-- VERIFICATION QUERIES
-- =============================================================================

SELECT * FROM Student;

SELECT * FROM Course;

SELECT * FROM Enrollment;

SELECT * FROM Grade_Log;

-- =============================================================================
-- END OF ASSIGNMENT
-- =============================================================================