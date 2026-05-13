-- CS420 Lab 4: Tutoring Center Database (3NF)

CREATE DATABASE IF NOT EXISTS TutoringCenter;
USE TutoringCenter;

-- CREATE TABLES

CREATE TABLE Student (
    StudentID   INT          PRIMARY KEY,
    StudentName VARCHAR(100) NOT NULL,
    StudentEmail VARCHAR(150) NOT NULL,
    Major       VARCHAR(100) NOT NULL
);

CREATE TABLE Tutor (
    TutorID    INT          PRIMARY KEY,
    TutorName  VARCHAR(100) NOT NULL,
    TutorEmail VARCHAR(150) NOT NULL
);

CREATE TABLE Course (
    CourseID    VARCHAR(10)  PRIMARY KEY,
    CourseTitle VARCHAR(150) NOT NULL,
    Department  VARCHAR(100) NOT NULL
);

CREATE TABLE Room (
    RoomID       VARCHAR(10) PRIMARY KEY,
    RoomBuilding VARCHAR(100) NOT NULL,
    RoomCapacity INT          NOT NULL
);

CREATE TABLE Session (
    SessionID       INT         PRIMARY KEY,
    SessionDate     DATE        NOT NULL,
    SessionTime     TIME        NOT NULL,
    SessionType     VARCHAR(50) NOT NULL,
    HourlyRate      DECIMAL(5,2) NOT NULL,
    DurationMinutes INT         NOT NULL,
    StudentID       INT         NOT NULL,
    TutorID         INT         NOT NULL,
    CourseID        VARCHAR(10) NOT NULL,
    RoomID          VARCHAR(10) NOT NULL,
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (TutorID)   REFERENCES Tutor(TutorID),
    FOREIGN KEY (CourseID)  REFERENCES Course(CourseID),
    FOREIGN KEY (RoomID)    REFERENCES Room(RoomID)
);

-- INSERT DATA

INSERT INTO Student VALUES
(1001, 'Jayson Tatum',      'jayson.tatum@university.edu',      'Computer Science'),
(1002, 'Jaylen Brown',      'jaylen.brown@university.edu',      'Mathematics'),
(1003, 'Payton Pritchard',  'payton.pritchard@university.edu',  'Biology'),
(1004, 'Derrick White',     'derrick.white@university.edu',     'Computer Science'),
(1005, 'Sam Hauser',        'sam.hauser@university.edu',        'Psychology');

INSERT INTO Tutor VALUES
(2001, 'Joe Mazzula',    'joe.mazzula@university.edu'),
(2002, 'Brad Stevens',   'brad.stevens@university.edu'),
(2003, 'Danny Ainge',    'danny.ainge@university.edu'),
(2004, 'Red Auerbach',   'red.auerbach@university.edu'),
(2005, 'Bill Chisholm',  'bill.chisholm@university.edu');

INSERT INTO Course VALUES
('CS420',  'Database Management Systems', 'Computer Science'),
('MATH301','Linear Algebra',              'Mathematics'),
('BIO210', 'Cell Biology',                'Biology'),
('CS310',  'Operating Systems',           'Computer Science'),
('PSY201', 'Research Methods',            'Psychology');

INSERT INTO Room VALUES
('A101', 'Pierce Hall',  6),
('B204', 'Garnett Hall', 4),
('C310', 'Rondo Hall',   8),
('D102', 'Bird Hall',    5),
('E205', 'McHale Hall',  10);



INSERT INTO Session VALUES
(3001, '2025-04-07', '10:00:00', 'In-Person', 25.00, 60,  1001, 2001, 'CS420',  'A101'),
(3002, '2025-04-08', '13:00:00', 'In-Person', 20.00, 90,  1002, 2002, 'MATH301','B204'),
(3003, '2025-04-09', '09:00:00', 'Online',    15.00, 45,  1003, 2003, 'BIO210', 'C310'),
(3004, '2025-04-10', '14:30:00', 'In-Person', 25.00, 60,  1004, 2001, 'CS310',  'D102'),
(3005, '2025-04-11', '11:00:00', 'In-Person', 18.00, 75,  1005, 2004, 'PSY201', 'E205'),
(3006, '2025-04-14', '10:00:00', 'In-Person', 25.00, 60,  1001, 2001, 'CS310',  'A101'),
(3007, '2025-04-15', '15:00:00', 'Online',    20.00, 60,  1002, 2005, 'MATH301','B204');

-- QUERIES

-- 1. All sessions with student name, tutor name, course title, room ID
SELECT
    s.SessionID,
    s.SessionDate,
    st.StudentName,
    t.TutorName,
    c.CourseTitle,
    s.RoomID
FROM Session s
JOIN Student st ON s.StudentID = st.StudentID
JOIN Tutor   t  ON s.TutorID   = t.TutorID
JOIN Course  c  ON s.CourseID  = c.CourseID
ORDER BY s.SessionDate;

-- 2. All sessions for a specific student (Mia Torres, StudentID = 1001)
SELECT
    s.SessionID,
    s.SessionDate,
    s.SessionTime,
    c.CourseTitle,
    t.TutorName,
    s.SessionType,
    s.DurationMinutes
FROM Session s
JOIN Course c ON s.CourseID = c.CourseID
JOIN Tutor  t ON s.TutorID  = t.TutorID
WHERE s.StudentID = 1001
ORDER BY s.SessionDate;

-- 3. All sessions conducted by a specific tutor (Dr. Alan Park, TutorID = 2001)
SELECT
    s.SessionID,
    s.SessionDate,
    s.SessionTime,
    st.StudentName,
    c.CourseTitle,
    s.SessionType
FROM Session s
JOIN Student st ON s.StudentID = st.StudentID
JOIN Course  c  ON s.CourseID  = c.CourseID
WHERE s.TutorID = 2001
ORDER BY s.SessionDate;

-- 4a. Number of sessions per course
SELECT
    c.CourseID,
    c.CourseTitle,
    COUNT(*) AS SessionCount
FROM Session s
JOIN Course c ON s.CourseID = c.CourseID
GROUP BY c.CourseID, c.CourseTitle
ORDER BY SessionCount DESC;

-- 4b. Number of sessions per room
SELECT
    r.RoomID,
    r.RoomBuilding,
    COUNT(*) AS SessionCount
FROM Session s
JOIN Room r ON s.RoomID = r.RoomID
GROUP BY r.RoomID, r.RoomBuilding
ORDER BY SessionCount DESC;