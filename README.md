# StudentGradeBook
This is a simple implementation of Student's GradeBook Database. The source code provided in gradebook.sql will create the database, required tables, insert rows into them. In addition to that, the queries for following tasks are also implemented.
* List all students in a course w and w/o their assignments.
* Add an assignment to a course.
* Change the weights of the assignment types for a course.
* Add 2 points to the score of each student on an assignment.
* Add 2 points just to those students whose last name contains a ‘Q’.
* Compute the grade for a student in a given course.
* Compute the grade for a student in a given course, where the lowest score for the given assignment type is dropped.

#### Executing the Code
The implementaion is in PL/pgSQL 12.1. So, to execute the queries, we need to connect to PostgreSQL. We can use SQLPro Studio, connect to PostgreSQL after installing it and run the queries.
1. Install [PostgreSQL](https://www.postgresql.org/download/), 12.1 recommended.
2. Connect to PostgreSQL, can be done using SQLPro Studio.
3. After connecting to PostgreSQL, execute the queries by uncommenting them from the source code.
