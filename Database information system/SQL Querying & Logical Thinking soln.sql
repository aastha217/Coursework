/****************************************************************************************
                    SQL Querying & Logical Thinking
****************************************************************************************/

CREATE DATABASE IF NOT EXISTS dis_lab;
USE dis_lab;

-- =============================================================================
-- PRE-LAB SETUP
-- =============================================================================

SET SQL_SAFE_UPDATES = 0;

DROP TABLE IF EXISTS Student_Registry;

-- =============================================================================
-- CREATE TABLE
-- =============================================================================

CREATE TABLE Student_Registry
(
    ID INT PRIMARY KEY,

    Name VARCHAR(50) NOT NULL,

    Dept_Name VARCHAR(30),

    Total_Credits INT,

    CGPA DECIMAL(3,1),

    Email VARCHAR(100)
);

-- =============================================================================
-- INSERT SAMPLE DATA
-- =============================================================================

INSERT INTO Student_Registry
(ID, Name, Dept_Name, Total_Credits, CGPA, Email)
VALUES
(101,'Aarav Sharma','Comp. Sci.',85,8.9,'101@univ.edu'),
(102,'Priya Verma','Comp. Sci.',72,8.2,'102@univ.edu'),
(103,'Rohit Singh','Comp. Sci.',45,6.8,NULL),
(104,'Neha Gupta','Physics',90,9.1,'104@univ.edu'),
(105,'Kunal Mehta','Physics',30,5.9,NULL),
(106,'Ananya Iyer','Chemistry',78,8.0,'106@univ.edu'),
(107,'Siddharth Jain','Chemistry',60,7.4,NULL),
(108,'Pooja Nair','Mathematics',88,9.3,'108@univ.edu'),
(109,'Rahul Khanna','Mathematics',40,6.2,NULL),
(110,'Ishita Roy','History',35,7.1,'110@univ.edu'),
(111,'Vikram Patel','History',20,5.8,NULL),
(112,'Sneha Kulkarni','Economics',92,8.6,'112@univ.edu'),
(113,'Arjun Malhotra','Economics',55,7.9,NULL),
(114,'Meera Joshi','General',15,6.5,NULL),
(115,'Nitin Rao','General',8,5.2,NULL),
(116,'Kavya Reddy','Comp. Sci.',28,6.0,NULL),
(117,'Aditya Bose','Physics',65,7.8,'117@univ.edu'),
(118,'Rhea Kapoor','Chemistry',50,8.4,'118@univ.edu'),
(119,'Manish Agarwal','Mathematics',95,9.0,'119@univ.edu'),
(120,'Tanvi Deshpande','History',60,8.1,'120@univ.edu');

-- =============================================================================
-- Q1 : FILTERING AND SORTING
-- =============================================================================

/*
Students with CGPA > 7.0
*/

SELECT *
FROM Student_Registry
WHERE CGPA > 7.0;

-- Sort by Total_Credits descending

SELECT *
FROM Student_Registry
ORDER BY Total_Credits DESC;

-- Comp. Sci. students ordered by CGPA

SELECT *
FROM Student_Registry
WHERE Dept_Name = 'Comp. Sci.'
ORDER BY CGPA DESC;

-- Top 5 students based on CGPA

SELECT *
FROM Student_Registry
ORDER BY CGPA DESC
LIMIT 5;

-- Students with credits less than average

SELECT *
FROM Student_Registry
WHERE Total_Credits <
(
    SELECT AVG(Total_Credits)
    FROM Student_Registry
);

-- =============================================================================
-- Q2 : AGGREGATE FUNCTIONS
-- =============================================================================

/*
Total number of students
*/

SELECT COUNT(*) AS Total_Students
FROM Student_Registry;

-- Average CGPA

SELECT AVG(CGPA) AS Average_CGPA
FROM Student_Registry;

-- Minimum and Maximum credits

SELECT
    MIN(Total_Credits) AS Min_Credits,
    MAX(Total_Credits) AS Max_Credits
FROM Student_Registry;

-- Student count per department

SELECT
    Dept_Name,
    COUNT(*) AS Total_Students
FROM Student_Registry
GROUP BY Dept_Name;

-- Average CGPA per department

SELECT
    Dept_Name,
    AVG(CGPA) AS Average_CGPA
FROM Student_Registry
GROUP BY Dept_Name;

-- =============================================================================
-- Q3 : GROUPING AND HAVING
-- =============================================================================

/*
Departments having
more than 3 students
*/

SELECT
    Dept_Name,
    COUNT(*) AS Total_Students
FROM Student_Registry
GROUP BY Dept_Name
HAVING COUNT(*) > 3;

-- Departments with average CGPA > 7.5

SELECT
    Dept_Name,
    AVG(CGPA) AS Average_CGPA
FROM Student_Registry
GROUP BY Dept_Name
HAVING AVG(CGPA) > 7.5;

-- Departments with total credits > 200

SELECT
    Dept_Name,
    SUM(Total_Credits) AS Total_Credits
FROM Student_Registry
GROUP BY Dept_Name
HAVING SUM(Total_Credits) > 200;

-- Departments having student with CGPA < 6.0

SELECT DISTINCT Dept_Name
FROM Student_Registry
WHERE CGPA < 6.0;

-- Departments ordered by average CGPA

SELECT
    Dept_Name,
    AVG(CGPA) AS Average_CGPA
FROM Student_Registry
GROUP BY Dept_Name
ORDER BY Average_CGPA DESC;

-- =============================================================================
-- Q4 : POLICY RULES
-- =============================================================================

/*
High-performing students
*/

SELECT *
FROM Student_Registry
WHERE CGPA >= 8.5
AND Total_Credits >= 60;

-- At-risk students

SELECT *
FROM Student_Registry
WHERE CGPA < 6.0
OR Total_Credits < 30;

-- Students eligible for honors

SELECT *
FROM Student_Registry S
WHERE CGPA >= 8.0
AND Total_Credits >=
(
    SELECT AVG(Total_Credits)
    FROM Student_Registry
    WHERE Dept_Name = S.Dept_Name
);

-- Students with CGPA above department average

SELECT *
FROM Student_Registry S
WHERE CGPA >
(
    SELECT AVG(CGPA)
    FROM Student_Registry
    WHERE Dept_Name = S.Dept_Name
);

-- Departments with no student below 6.5

SELECT Dept_Name
FROM Student_Registry
GROUP BY Dept_Name
HAVING MIN(CGPA) >= 6.5;

-- =============================================================================
-- Q5 : SUBQUERIES AND HAVING
-- =============================================================================

/*
Second highest CGPA
*/

SELECT MAX(CGPA) AS Second_Highest_CGPA
FROM Student_Registry
WHERE CGPA <
(
    SELECT MAX(CGPA)
    FROM Student_Registry
);

-- Students sharing same CGPA

SELECT *
FROM Student_Registry
WHERE CGPA IN
(
    SELECT CGPA
    FROM Student_Registry
    GROUP BY CGPA
    HAVING COUNT(*) > 1
);

-- Department with highest average CGPA

SELECT Dept_Name,
       AVG(CGPA) AS Average_CGPA
FROM Student_Registry
GROUP BY Dept_Name
ORDER BY Average_CGPA DESC
LIMIT 1;

-- Students having credits greater than
-- all History students

SELECT *
FROM Student_Registry
WHERE Total_Credits >
(
    SELECT MAX(Total_Credits)
    FROM Student_Registry
    WHERE Dept_Name = 'History'
);

-- Consolidated department report

SELECT
    Dept_Name,
    COUNT(*) AS Total_Students,
    AVG(CGPA) AS Average_CGPA,
    SUM(Total_Credits) AS Total_Credits
FROM Student_Registry
GROUP BY Dept_Name;

-- =============================================================================
-- VERIFICATION QUERY
-- =============================================================================

SELECT *
FROM Student_Registry;

-- =============================================================================
-- END OF ASSIGNMENT
-- =============================================================================