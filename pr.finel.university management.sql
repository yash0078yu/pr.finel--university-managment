CREATE DATABASE UniversityCourseManagement;
USE UniversityCourseManagement;

CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100)
);

CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    BirthDate DATE,
    EnrollmentDate DATE
);

CREATE TABLE Instructors (
    InstructorID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    DepartmentID INT,
    Salary DECIMAL(10,2),
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(100),
    DepartmentID INT,
    Credits INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

CREATE TABLE Enrollments (
    EnrollmentID INT PRIMARY KEY,
    StudentID INT,
    CourseID INT,
    EnrollmentDate DATE,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

INSERT INTO Departments VALUES
(1,'Computer Science'),
(2,'Mathematics');

INSERT INTO Students VALUES
(1,'John','Doe','john.doe@email.com','2002-05-10','2022-08-01'),
(2,'Jane','Smith','jane.smith@email.com','2001-03-15','2021-08-01'),
(3,'Michael','Brown','michael.b@email.com','2000-07-20','2023-08-01'),
(4,'Emma','Wilson','emma.w@email.com','2002-11-25','2020-08-01');

INSERT INTO Instructors VALUES
(1,'Alice','Johnson','alice.johnson@uni.com',1,60000),
(2,'Bob','Lee','bob.lee@uni.com',2,55000);

INSERT INTO Courses VALUES
(101,'Introduction to SQL',1,3),
(102,'Data Structures',1,4),
(103,'Calculus',2,3);

INSERT INTO Enrollments VALUES
(1,1,101,'2022-08-01'),
(2,2,102,'2021-08-01'),
(3,3,101,'2023-08-01'),
(4,4,103,'2020-08-01'),
(5,1,102,'2022-08-01');

SELECT * FROM Students;
UPDATE Students SET Email='john.new@email.com' WHERE StudentID=1;
DELETE FROM Students WHERE StudentID=4;

SELECT * FROM Students WHERE EnrollmentDate > '2022-01-01';

SELECT * FROM Courses 
WHERE DepartmentID = (SELECT DepartmentID FROM Departments WHERE DepartmentName='Mathematics')
LIMIT 5;

SELECT CourseID, COUNT(StudentID) AS TotalStudents
FROM Enrollments
GROUP BY CourseID
HAVING COUNT(StudentID) > 5;

SELECT s.*
FROM Students s
JOIN Enrollments e1 ON s.StudentID = e1.StudentID
JOIN Enrollments e2 ON s.StudentID = e2.StudentID
WHERE e1.CourseID = 101 AND e2.CourseID = 102;

SELECT DISTINCT s.*
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
WHERE e.CourseID IN (101,102);

SELECT AVG(Credits) AS AverageCredits FROM Courses;

SELECT MAX(Salary) AS MaxSalary
FROM Instructors
WHERE DepartmentID = (SELECT DepartmentID FROM Departments WHERE DepartmentName='Computer Science');

SELECT d.DepartmentName, COUNT(e.StudentID) AS TotalStudents
FROM Departments d
JOIN Courses c ON d.DepartmentID = c.DepartmentID
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY d.DepartmentName;

SELECT s.FirstName, s.LastName, c.CourseName
FROM Students s
INNER JOIN Enrollments e ON s.StudentID = e.StudentID
INNER JOIN Courses c ON e.CourseID = c.CourseID;

SELECT s.FirstName, s.LastName, c.CourseName
FROM Students s
LEFT JOIN Enrollments e ON s.StudentID = e.StudentID
LEFT JOIN Courses c ON e.CourseID = c.CourseID;

SELECT *
FROM Students
WHERE StudentID IN (
    SELECT StudentID
    FROM Enrollments
    GROUP BY StudentID
    HAVING COUNT(CourseID) > 1
);

SELECT StudentID, YEAR(EnrollmentDate) AS EnrollmentYear
FROM Students;

SELECT CONCAT(FirstName,' ',LastName) AS InstructorName
FROM Instructors;

SELECT CourseID,
COUNT(StudentID) AS TotalStudents,
SUM(COUNT(StudentID)) OVER (ORDER BY CourseID) AS RunningTotal
FROM Enrollments
GROUP BY CourseID;

SELECT FirstName, LastName,
CASE 
    WHEN TIMESTAMPDIFF(YEAR, EnrollmentDate, CURDATE()) > 4 THEN 'Senior'
    ELSE 'Junior'
END AS StudentLevel
FROM Students;