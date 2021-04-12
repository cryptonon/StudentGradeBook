/***** Creating GRADEBOOK database (for the first time) *****/

-- DROP DATABASE IF EXISTS GRADEBOOK;
-- CREATE DATABASE GRADEBOOK;

/********************* Creating Tables *********************/

-- Dropping Tables if they already exist
DROP TABLE IF EXISTS CRS_ASSIGNMENT;
DROP TABLE IF EXISTS ASSIGNMENT_WEIGHT;
DROP TABLE IF EXISTS STUDENT;
DROP TABLE IF EXISTS COURSE;
DROP TABLE IF EXISTS ASSIGNMENT_TYPE;

-- STUDENT Table
CREATE TABLE STUDENT(
	STU_ID int not null PRIMARY KEY,
	STU_LNAME varchar(255),
	STU_FNAME varchar(255),
	STU_EMAIL varchar(255)
);

-- COURSE Table
CREATE TABLE COURSE(
	CRS_NUM int not null PRIMARY KEY,
	CRS_NAME varchar(255),
	CRS_SEMESTER varchar(10),
	CRS_YEAR int,
	CRS_DEPT varchar(255)
);

-- ASSIGNMENT_TYPE Table
CREATE TABLE ASSIGNMENT_TYPE(
	ASSIGN_TYPE_ID int not null PRIMARY KEY,
	ASSIGN_TYPE_NAME varchar(255)
);

-- ASSIGNMENT_WEIGHT Table
CREATE TABLE ASSIGNMENT_WEIGHT(
	ASSIGN_TYPE_ID int not null,
	CRS_NUM int not null,
	GRADE_WEIGHT int,
	PRIMARY KEY (CRS_NUM, ASSIGN_TYPE_ID),
	FOREIGN KEY (ASSIGN_TYPE_ID) REFERENCES ASSIGNMENT_TYPE(ASSIGN_TYPE_ID) ON DELETE CASCADE,
	FOREIGN KEY (CRS_NUM) REFERENCES COURSE(CRS_NUM) ON DELETE CASCADE
);

-- CRS_ASSIGNMENT Table
CREATE TABLE CRS_ASSIGNMENT(
	CRS_NUM int not null,
	STU_ID int not null,
	ASSIGN_TYPE_ID int not null,
	ASSIGNMENT_ID int not null,
	ASSIGNMENT_SCORE int DEFAULT 0,
	PRIMARY KEY(CRS_NUM, STU_ID, ASSIGN_TYPE_ID, ASSIGNMENT_ID),
	FOREIGN KEY (CRS_NUM) REFERENCES COURSE(CRS_NUM )ON DELETE CASCADE,
	FOREIGN KEY (STU_ID) REFERENCES STUDENT(STU_ID) ON DELETE CASCADE,
	FOREIGN KEY (ASSIGN_TYPE_ID) REFERENCES ASSIGNMENT_TYPE(ASSIGN_TYPE_ID) ON DELETE CASCADE
);

/********************* END of Table Creation *********************/


/********************* Inserting into Tables *********************/

-- STUDENT Table
INSERT INTO STUDENT VALUES (11, 'Phuyal', 'Aayush', 'aayush@phuyal.com');
INSERT INTO STUDENT VALUES (12, 'Doe', 'John', 'john@doe.com');
INSERT INTO STUDENT VALUES (13, 'Zuck', 'Mark', 'mark@fb.com');
INSERT INTO STUDENT VALUES (14, 'Cook', 'Tim', 'tim@apple.com');
INSERT INTO STUDENT VALUES (15, 'PichaiQ', 'Sundar', 'sundar@google.com');

-- COURSE Table
INSERT INTO COURSE VALUES(80729, 'Database Systems', 'Spring', 2021,'CS');
INSERT INTO COURSE VALUES(81067, 'Numerical Analysis', 'Spring', 2022, 'Math');
INSERT INTO COURSE VALUES(86219, 'Persuasive Writing', 'Fall', 2020, 'English');
INSERT INTO COURSE VALUES(84242, 'Applied Data Structure', 'Fall', 2021, 'CS, Tech X');
INSERT INTO COURSE VALUES(11111, 'Product Management', 'Spring', 2023, 'EECS, Tech X');

-- ASSIGNMENT_TYPE Table
INSERT INTO ASSIGNMENT_TYPE VALUES(1,'Homework');
INSERT INTO ASSIGNMENT_TYPE VALUES(2,'Quiz');
INSERT INTO ASSIGNMENT_TYPE VALUES(3,'Participation');
INSERT INTO ASSIGNMENT_TYPE VALUES(4,'Midterm/Test/Final');

-- ASSIGNMENT_WEIGHT Table
INSERT INTO ASSIGNMENT_WEIGHT VALUES(1,80729,30);
INSERT INTO ASSIGNMENT_WEIGHT VALUES(4,80729,60);
INSERT INTO ASSIGNMENT_WEIGHT VALUES(2,80729,10);
INSERT INTO ASSIGNMENT_WEIGHT VALUES(1,81067,40);
INSERT INTO ASSIGNMENT_WEIGHT VALUES(2,81067,20);
INSERT INTO ASSIGNMENT_WEIGHT VALUES(3,81067,40);
INSERT INTO ASSIGNMENT_WEIGHT VALUES(3,86219,20);
INSERT INTO ASSIGNMENT_WEIGHT VALUES(2,86219,60);
INSERT INTO ASSIGNMENT_WEIGHT VALUES(4,86219,20);
INSERT INTO ASSIGNMENT_WEIGHT VALUES(1,84242,40);
INSERT INTO ASSIGNMENT_WEIGHT VALUES(2,84242,20);
INSERT INTO ASSIGNMENT_WEIGHT VALUES(4,84242,40);
INSERT INTO ASSIGNMENT_WEIGHT VALUES(1,11111,15);
INSERT INTO ASSIGNMENT_WEIGHT VALUES(3,11111,35);
INSERT INTO ASSIGNMENT_WEIGHT VALUES(2,11111,50);

-- CRS_ASSIGNMENT Table
INSERT INTO CRS_ASSIGNMENT VALUES(80729,11,1,1,90);
INSERT INTO CRS_ASSIGNMENT VALUES(80729,12,1,1,60);
INSERT INTO CRS_ASSIGNMENT VALUES(80729,13,1,1,70);
INSERT INTO CRS_ASSIGNMENT VALUES(80729,14,1,1,40);
INSERT INTO CRS_ASSIGNMENT VALUES(81067,11,1,2,90);
INSERT INTO CRS_ASSIGNMENT VALUES(81067,12,1,2,60);
INSERT INTO CRS_ASSIGNMENT VALUES(81067,15,1,1,70);
INSERT INTO CRS_ASSIGNMENT VALUES(11111,15,1,1,40);
INSERT INTO CRS_ASSIGNMENT VALUES(11111,13,1,1,0);
INSERT INTO CRS_ASSIGNMENT VALUES(11111,12,1,1,100);
INSERT INTO CRS_ASSIGNMENT VALUES(11111,15,2,1,90);
INSERT INTO CRS_ASSIGNMENT VALUES(11111,15,3,1,95);
INSERT INTO CRS_ASSIGNMENT VALUES(11111,15,1,2,95);
INSERT INTO CRS_ASSIGNMENT VALUES(11111,15,1,3,90);
INSERT INTO CRS_ASSIGNMENT VALUES(11111,13,1,2,100);
INSERT INTO CRS_ASSIGNMENT VALUES(11111,15,4,1,90);

/********************* END of insertion  *********************/


/********************* Inspecting the Tables *********************/

-- STUDENT Table: SELECT * FROM STUDENT
-- COURSE Table: SELECT * FROM COURSE
-- ASSIGNMENT_TYPE Table: SELECT * FROM ASSIGNMENT_TYPE
-- ASSIGNMENT_WEIGHT Table: SELECT * FROM ASSIGNMENT_WEIGHT
-- CRS_ASSIGNMENT Table: SELECT * FROM CRS_ASSIGNMENT

/********************* END of inspection  *********************/


/********************* max/min/avg scores  *********************/

-- Creating a function
CREATE OR REPLACE FUNCTION getScores(crsNum int, assignTypeID int, assignID int)
RETURNS TABLE(MaxScore int, MinScore int, AvgScore numeric) AS $$
BEGIN
  RETURN QUERY
  SELECT 
  	MAX(CRS_ASSIGNMENT.ASSIGNMENT_SCORE),
  	MIN(CRS_ASSIGNMENT.ASSIGNMENT_SCORE),
  	AVG(CRS_ASSIGNMENT.ASSIGNMENT_SCORE) 
  FROM CRS_ASSIGNMENT
  WHERE 
  	CRS_ASSIGNMENT.CRS_NUM = crsNum AND
  	CRS_ASSIGNMENT.ASSIGN_TYPE_ID = assignTypeID AND 
  	CRS_ASSIGNMENT.ASSIGNMENT_ID = assignID;
END 
$$ LANGUAGE plpgsql;

-- Calling the function
--SELECT * FROM getScores(11111, 1, 1);

-- Test for getScore(11111, 1, 1)
/* 

Course 11111 with assignment type ID 1 and assignment 1 has 3 scores i.e. 0, 40, 100.
So, the function must return 100 (max), 0 (min), 46.67 (avg). The result is expected.
Hence, we validate the correctness of this function.

*/

/********************* END of max/min/avg scores  *********************/


/********************* list all STUDENTS in a given COURSE  *********************/

-- Creating a function
CREATE OR REPLACE FUNCTION getStudents(CourseNum int)
RETURNS TABLE(stuID int, lName varchar(255), fName varchar(255), email varchar(255)) AS $$
BEGIN
  RETURN QUERY
  SELECT DISTINCT
  	STUDENT.STU_ID,
  	STUDENT.STU_LNAME,
  	STUDENT.STU_FNAME,
  	STUDENT.STU_EMAIL
  FROM CRS_ASSIGNMENT
  INNER JOIN STUDENT ON STUDENT.STU_ID = CRS_ASSIGNMENT.STU_ID
  WHERE CRS_ASSIGNMENT.CRS_NUM = CourseNum;
END 
$$ LANGUAGE plpgsql;

-- Calling the function
-- SELECT * FROM getStudents(11111);

-- Test for getStudents(11111)
/* 

Course 11111 has 3 students: 12, 13 and 15.
So, the function must return 3 rows with student 12, 13, and 15.
The result is expected. Hence, we validate the correctness of this function.

*/

/********************* END of list all STUDENTS  *********************/



/********************* list all STUDENTS and the ASSIGNMENTS in a given COURSE  *********************/

-- Creating a function
CREATE OR REPLACE FUNCTION getStudentAndAssignments(CourseNum int)
RETURNS TABLE(
	Id int,
	lName varchar(255),
	Fname varchar(255),
	assignTypeID varchar(255),
	assignTypeName int,
	assignScore int) AS $$
BEGIN
  RETURN QUERY
  SELECT DISTINCT
  	STUDENT.STU_ID,
  	STUDENT.STU_LNAME,
  	STUDENT.STU_FNAME,
  	ASSIGNMENT_TYPE.ASSIGN_TYPE_NAME,
  	CRS_ASSIGNMENT.ASSIGNMENT_ID,
  	CRS_ASSIGNMENT.ASSIGNMENT_SCORE
  FROM (CRS_ASSIGNMENT INNER JOIN STUDENT ON CRS_ASSIGNMENT.STU_ID = STUDENT.STU_ID)
  		INNER JOIN ASSIGNMENT_TYPE ON ASSIGNMENT_TYPE.ASSIGN_TYPE_ID = CRS_ASSIGNMENT.ASSIGN_TYPE_ID 
  		WHERE CRS_NUM = CourseNum;
END 
$$ LANGUAGE plpgsql;

-- Calling the function
-- SELECT * FROM getStudentAndAssignments(81067);

-- Test for getStudentAndAssignments(81067)
/* 

Course 81067 has 3 students: 11, 12 and 15. Each of them have only 1 assignment.
11: Homework -> 90, 12: Homework -> 60, 15: Homework -> 70
So, the function must return 3 rows with student 12, 13, and 15 and the respective scores.
The result is expected. Hence, we validate the correctness of this function.

*/

/********************* END of list all STUDENTS  *********************/


/********************* adding a row to COURSE_ASSIGNMENT  *********************/

-- Creating a Function
CREATE OR REPLACE FUNCTION addAssignment(
	crsNum int,
	studentId int,
	assignTypeID int,
	assignID int,
	score int) RETURNS VOID AS $$
BEGIN
  INSERT INTO CRS_ASSIGNMENT VALUES(crsNum,studentID,assignTypeID,assignID,score);
END 
$$ LANGUAGE plpgsql;

-- Calling the function and inspecting CRS_ASSIGNMENT
-- SELECT addAssignment(11111,14,1,1,95);
-- SELECT * FROM CRS_ASSIGNMENT;

-- Test for addAssignment(11111,14,1,1,95)
/* 

We expect the CRS_ASSIGNMENT to grow by 1 row.
So, the function must add a row with student 14, homework and the score of 95.
The result is expected. Hence, we validate the correctness of this function.

*/

/********************* END of add assignment  *********************/


/********************* changing GRADE_WEIGHT of assignment  *********************/

-- Creating a function
CREATE OR REPLACE FUNCTION updateAssignmentWeight(
	crsNum int,
	assignTypeID int,
	updatedWeight int) RETURNS VOID AS $$
BEGIN
  UPDATE ASSIGNMENT_WEIGHT
  SET GRADE_WEIGHT = updatedWeight
  WHERE CRS_NUM = crsNum AND ASSIGN_TYPE_ID = assignTypeID;
END 
$$ LANGUAGE plpgsql;

-- Calling the function and inspecting ASSIGNMENT_WEIGHT
-- SELECT updateAssignmentWeight(80729,1,31);
-- SELECT * FROM ASSIGNMENT_WEIGHT;

-- Test for updateAssignmentWeight(80729,1,31)
/* 

We expect the ASSIGNMENT_WEIGHT to change for homework for Course 80729 from 30 to 31
The result is expected. Hence, we validate the correctness of this function.

*/

/********************* END of add assignment  *********************/


/********************* adding two points  *********************/

-- Creating a Function
CREATE OR REPLACE FUNCTION addTwoPoints(
	crsNum int,
	assignTypeID int,
	assignID int) RETURNS VOID AS $$
BEGIN
  UPDATE CRS_ASSIGNMENT
  SET ASSIGNMENT_SCORE = ASSIGNMENT_SCORE + 2
  WHERE CRS_NUM = crsNum AND ASSIGN_TYPE_ID = assignTypeID AND ASSIGNMENT_ID = assignID;
END 
$$ LANGUAGE plpgsql;

-- Calling the function and inspecting CRS_ASSIGNMENT
--SELECT addTwoPoints(81067,1,2);
--SELECT * FROM CRS_ASSIGNMENT;

-- Test for addTwoPoints(81067,1,2)
/* 

Course 81067, assignTypeID 1, assignID 2 has two student instances i.e. 11 and 12 with
scores 90 and 60 respectively.
We expect these scores to increase to 92 and 62 resp.
The result is expected. Hence, we validate the correctness of this function.

*/

/********************* END of add two points  *********************/


/********************* adding two points where lastName has Q  *********************/

-- Creating a Function
CREATE OR REPLACE FUNCTION addTwoPointsQ(
	crsNum int,
	assignTypeID int,
	assignID int) RETURNS VOID AS $$
BEGIN
  UPDATE CRS_ASSIGNMENT
  SET ASSIGNMENT_SCORE = CRS_ASSIGNMENT.ASSIGNMENT_SCORE + 2
  FROM STUDENT WHERE STUDENT.STU_ID = CRS_ASSIGNMENT.STU_ID AND
  (STU_LNAME like '%q%' OR STU_LNAME like '%Q%') AND 
  CRS_ASSIGNMENT.CRS_NUM = crsNum AND 
  CRS_ASSIGNMENT.ASSIGN_TYPE_ID = assignTypeID AND 
  CRS_ASSIGNMENT.ASSIGNMENT_ID = assignID;
END 
$$ LANGUAGE plpgsql;

-- Calling the function and inspecting CRS_ASSIGNMENT
--SELECT addTwoPointsQ(11111,1,2);
--SELECT * FROM CRS_ASSIGNMENT;

-- Test for addTwoPointsQ(11111,1,2)
/* 

Course 11111, assignTypeID 1, assignID 2 has two student instances
i.e. 13 (score 95)(Zuck, Mark) and 15 (score 100) (PichaiQ, Sundar)
We expect 15's score to increase from 95 to 97 as 15 has Q in last name.
The result is expected. Hence, we validate the correctness of this function.

*/

/********************* END of add two points Q  *********************/