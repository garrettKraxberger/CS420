CREATE DATABASE IF NOT EXISTS student_info;
USE student_info;

-- CREATE TABLES

CREATE TABLE INSTRUCTOR (
    InstructorID INT PRIMARY KEY,
    InstructorName VARCHAR(100) NOT NULL,
    Department VARCHAR(100) NOT NULL
);

CREATE TABLE STUDENT (
    StudentID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Major VARCHAR(100) NOT NULL,
    AcademicYear VARCHAR(20) NOT NULL
);

CREATE TABLE COURSE (
    CourseID INT PRIMARY KEY,
    CourseTitle VARCHAR(100) NOT NULL,
    InstructorID INT NOT NULL,
    FOREIGN KEY (InstructorID) REFERENCES INSTRUCTOR(InstructorID)
);

CREATE TABLE ENROLLMENT (
    EnrollmentID INT PRIMARY KEY,
    StudentID INT NOT NULL,
    CourseID INT NOT NULL,
    Grade VARCHAR(2),
    FOREIGN KEY (StudentID) REFERENCES STUDENT(StudentID),
    FOREIGN KEY (CourseID) REFERENCES COURSE(CourseID)
);

SHOW TABLES;
DESCRIBE STUDENT;
DESCRIBE INSTRUCTOR;
DESCRIBE COURSE;
DESCRIBE ENROLLMENT;


-- INSERT DATA

INSERT INTO INSTRUCTOR (InstructorID, InstructorName, Department) VALUES
(1, 'Dr. Brad Stevens', 'Computer Science'),
(2, 'Dr. Danny Ainge', 'Mathematics'),
(3, 'Dr. Joe Mazzulla', 'Cybersecurity');

INSERT INTO STUDENT (StudentID, FirstName, LastName, Major, AcademicYear) VALUES
(101, 'Jayson', 'Tatm', 'Computer Science', 'Junior'),
(102, 'Jaylen', 'Brown', 'Mathematics', 'Sophomore'),
(103, 'Derrick', 'White', 'Cybersecurity', 'Senior'),
(104, 'Payton', 'Pritchard', 'Computer Science', 'Freshman'),
(105, 'Sam', 'Hauser', 'Mathematics', 'Junior');

INSERT INTO COURSE (CourseID, CourseTitle, InstructorID) VALUES
(201, 'Introduction to Programming', 1),
(202, 'Discrete Mathematics', 2),
(203, 'Network Security', 3),
(204, 'Data Structures', 1);

INSERT INTO ENROLLMENT (EnrollmentID, StudentID, CourseID, Grade) VALUES
(301, 101, 201, 'A'),
(302, 101, 204, 'B'),
(303, 102, 202, 'A'),
(304, 103, 203, 'B+'),
(305, 104, 201, 'A-'),
(306, 105, 202, 'B');

SELECT * FROM INSTRUCTOR;
SELECT * FROM STUDENT;
SELECT * FROM COURSE;
SELECT * FROM ENROLLMENT;


-- UPDATE AND DELETE

-- Update student major
UPDATE STUDENT SET Major = 'Data Science' WHERE StudentID = 102;
SELECT * FROM STUDENT WHERE StudentID = 102;

-- Change course instructor
UPDATE COURSE SET InstructorID = 2 WHERE CourseID = 204;
SELECT * FROM COURSE WHERE CourseID = 204;

-- Update a grade
UPDATE ENROLLMENT SET Grade = 'A' WHERE StudentID = 101 AND CourseID = 204;
SELECT * FROM ENROLLMENT WHERE StudentID = 101;

-- Delete one enrollment record
DELETE FROM ENROLLMENT WHERE EnrollmentID = 306;
SELECT * FROM ENROLLMENT;

-- This will fail due to foreign key constraint (run alone for screenshot)
DELETE FROM STUDENT WHERE StudentID = 101;

-- Fix: delete enrollments first, then delete the student
DELETE FROM ENROLLMENT WHERE StudentID = 101;
DELETE FROM STUDENT WHERE StudentID = 101;

SELECT * FROM STUDENT;
SELECT * FROM ENROLLMENT;


-- SELECT QUERIES

-- All students ordered by last name
SELECT StudentID, FirstName, LastName, Major, AcademicYear
FROM STUDENT
ORDER BY LastName ASC;

-- Courses taught by a specific instructor
SELECT c.CourseID, c.CourseTitle, i.InstructorName, i.Department
FROM COURSE c
JOIN INSTRUCTOR i ON c.InstructorID = i.InstructorID
WHERE i.InstructorName = 'Dr. Brad Stevens';

-- Each student with their enrolled courses
SELECT s.FirstName, s.LastName, c.CourseTitle, i.InstructorName
FROM STUDENT s
JOIN ENROLLMENT e ON s.StudentID = e.StudentID
JOIN COURSE c ON e.CourseID = c.CourseID
JOIN INSTRUCTOR i ON c.InstructorID = i.InstructorID
ORDER BY s.LastName ASC;

-- Student names and grades for a specific course
SELECT s.FirstName, s.LastName, c.CourseTitle, e.Grade
FROM STUDENT s
JOIN ENROLLMENT e ON s.StudentID = e.StudentID
JOIN COURSE c ON e.CourseID = c.CourseID
WHERE c.CourseTitle = 'Discrete Mathematics'
ORDER BY s.LastName ASC;

-- Each course with total students enrolled
SELECT c.CourseTitle, COUNT(e.StudentID) AS EnrolledStudents
FROM COURSE c
LEFT JOIN ENROLLMENT e ON c.CourseID = e.CourseID
GROUP BY c.CourseID, c.CourseTitle
ORDER BY EnrolledStudents DESC;
