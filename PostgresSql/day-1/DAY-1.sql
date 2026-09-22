-- ====================================================================
-- 🐘 POSTGRESQL DAY 1: FUNDAMENTALS & CRUD OPERATIONS
-- ====================================================================
-- This file contains all basic SQL commands for Day 1.
-- Every query has a "Simple English Explanation" so anyone can understand
-- exactly what the database is doing without prior SQL experience.
-- ====================================================================


-- ====================================================================
-- 📌 SECTION 0: USEFUL PSQL META-COMMANDS (Run in Terminal / psql CLI)
-- ====================================================================
-- NOTE: These backslash (\) commands work in the psql terminal prompt,
-- not in a regular SQL query editor.

-- \l                 -> List all databases on this PostgreSQL server.
-- \c database_name   -> Connect to (switch to) a specific database.
-- \dt                -> List all tables inside the current database.
-- \d table_name      -> Describe a table (see columns, data types, and rules).
-- \du                -> List all database users and their roles/permissions.
-- \q                 -> Quit and exit the psql command line tool.
-- \! cls             -> Clear screen on Windows command prompt.


-- ====================================================================
-- 📌 SECTION 1: DATABASE CREATION & CLEANUP
-- ====================================================================

-- 💬 Simple English: "Delete the database named 'school_db' if it already exists, so we can start fresh."
DROP DATABASE IF EXISTS school_db;

-- 💬 Simple English: "Create a brand new database called 'school_db'."
CREATE DATABASE school_db;

-- 💬 Simple English: "Connect to our newly created 'school_db' database."
-- In psql terminal: \c school_db;


-- ====================================================================
-- 📌 SECTION 2: TABLE CREATION (CREATE TABLE)
-- ====================================================================

-- 💬 Simple English: "If a table named 'students' already exists, delete it."
DROP TABLE IF EXISTS students;

-- 💬 Simple English: "Create a new table named 'students' with 6 columns to store student details."
-- Breakdown of Columns:
--   - id: stores whole numbers (e.g., 1, 2, 3)
--   - fname: stores first name up to 50 characters of text
--   - lname: stores last name up to 50 characters of text
--   - email: stores email address up to 100 characters of text
--   - class_name: stores class/section name up to 50 characters
--   - marks: stores score as an integer whole number
CREATE TABLE students (
    id INT,
    fname VARCHAR(50),
    lname VARCHAR(50),
    email VARCHAR(100),
    class_name VARCHAR(50),
    marks INT
);


-- ====================================================================
-- 📌 SECTION 3: INSERTING DATA (CREATE in CRUD)
-- ====================================================================

-- 💬 Simple English: "Insert a single new student into the 'students' table."
INSERT INTO students (id, fname, lname, email, class_name, marks)
VALUES (1, 'Aarav', 'Sharma', 'aarav.sharma@example.com', 'BCA-1', 85);

-- 💬 Simple English: "Insert multiple student records all at once in one single query."
INSERT INTO students (id, fname, lname, email, class_name, marks)
VALUES
    (2, 'Diya',   'Patel',   'diya.patel@example.com',   'BCA-1', 92),
    (3, 'Rohan',  'Gupta',   'rohan.gupta@example.com',  'BCA-2', 74),
    (4, 'Ananya', 'Verma',   'ananya.v@example.com',     'BCA-1', 65),
    (5, 'Riya',   'Sharma',  'riya.sharma@example.com',  'BCA-1', 88),
    (6, 'Aman',   'Verma',   'aman.verma@example.com',   'BCA-2', 76),
    (7, 'Neha',   'Singh',   'neha.singh@example.com',   'BCA-2', 82);


-- ====================================================================
-- 📌 SECTION 4: READING / QUERYING DATA (READ in CRUD)
-- ====================================================================

-- 💬 Simple English: "Show me every single row and every single column from the students table."
-- The asterisk (*) means 'ALL columns'.
SELECT * FROM students;

-- 💬 Simple English: "Show me ONLY the first name, class name, and marks of all students."
SELECT fname, class_name, marks FROM students;

-- 💬 Simple English: "Show me first name and marks, but rename the column headers in the output as 'Student Name' and 'Score'."
SELECT fname AS "Student Name", marks AS "Score" FROM students;

-- 💬 Simple English: "Show me a unique list of all classes with no duplicate names."
SELECT DISTINCT class_name FROM students;


-- ====================================================================
-- 📌 SECTION 5: FILTERING DATA (WHERE CLAUSE)
-- ====================================================================

-- 💬 Simple English: "Find all students who belong specifically to class 'BCA-1'."
SELECT * FROM students 
WHERE class_name = 'BCA-1';

-- 💬 Simple English: "Find all students who scored strictly more than 80 marks."
SELECT * FROM students 
WHERE marks > 80;

-- 💬 Simple English: "Find all students who scored 80 or more marks AND are in class 'BCA-1'."
-- Both conditions MUST be true.
SELECT * FROM students 
WHERE marks >= 80 AND class_name = 'BCA-1';

-- 💬 Simple English: "Find all students who scored above 90 OR belong to class 'BCA-2'."
-- Either condition can be true.
SELECT * FROM students 
WHERE marks > 90 OR class_name = 'BCA-2';

-- 💬 Simple English: "Find all students whose marks are between 75 and 90 (inclusive)."
SELECT * FROM students 
WHERE marks BETWEEN 75 AND 90;

-- 💬 Simple English: "Find all students whose ID is in the list (1, 3, 5, 7)."
SELECT * FROM students 
WHERE id IN (1, 3, 5, 7);

-- 💬 Simple English: "Find all students whose first name starts with the letter 'A'."
-- The '%' symbol represents any number of characters after 'A'.
SELECT * FROM students 
WHERE fname LIKE 'A%';

-- 💬 Simple English: "Find all students whose last name ends with 'ma'."
SELECT * FROM students 
WHERE lname LIKE '%ma';

-- 💬 Simple English: "Find all students whose email is missing (NULL)."
SELECT * FROM students 
WHERE email IS NULL;

-- 💬 Simple English: "Find all students who have a valid email entered (NOT NULL)."
SELECT * FROM students 
WHERE email IS NOT NULL;


-- ====================================================================
-- 📌 SECTION 6: SORTING AND LIMITING RESULTS
-- ====================================================================

-- 💬 Simple English: "Show all students sorted by their marks from highest to lowest (Descending)."
SELECT * FROM students 
ORDER BY marks DESC;

-- 💬 Simple English: "Show all students sorted alphabetically by first name (Ascending A to Z)."
SELECT * FROM students 
ORDER BY fname ASC;

-- 💬 Simple English: "Get only the TOP 3 highest scoring students."
SELECT * FROM students 
ORDER BY marks DESC 
LIMIT 3;

-- 💬 Simple English: "Skip the top 2 students and show the next 3 students (Pagination: Page 2)."
SELECT * FROM students 
ORDER BY marks DESC 
LIMIT 3 OFFSET 2;


-- ====================================================================
-- 📌 SECTION 7: UPDATING DATA (UPDATE in CRUD)
-- ====================================================================

-- 💬 Simple English: "Update student with ID = 3 and change their marks to 91."
-- WARNING: Always include a WHERE clause; otherwise every row in the table will be updated!
UPDATE students
SET marks = 91
WHERE id = 3;

-- 💬 Simple English: "Give a 5-mark bonus to all students who belong to class 'BCA-2'."
UPDATE students 
SET marks = marks + 5 
WHERE class_name = 'BCA-2';

-- 💬 Simple English: "Update both the email and class_name for student with ID = 1."
UPDATE students
SET email = 'aarav.updated@example.com',
    class_name = 'BCA-HONORS'
WHERE id = 1;

-- 💬 Simple English: "Check the updated table to see our changes."
SELECT * FROM students ORDER BY id ASC;


-- ====================================================================
-- 📌 SECTION 8: DELETING DATA (DELETE in CRUD)
-- ====================================================================

-- 💬 Simple English: "Delete the specific student who has ID = 4."
-- WARNING: Always specify WHERE; without WHERE, all rows in the table will be erased!
DELETE FROM students
WHERE id = 4;

-- 💬 Simple English: "Delete all students who scored less than 70 marks."
DELETE FROM students
WHERE marks < 70;

-- 💬 Simple English: "Delete all data inside the table instantly (keeps the table structure empty)."
-- TRUNCATE is faster than DELETE when clearing entire tables.
-- TRUNCATE TABLE students;

-- 💬 Simple English: "Completely remove the table and its structure from the database."
-- DROP TABLE students;

-- 💬 Simple English: "Final check of the students table."
SELECT * FROM students ORDER BY id ASC;
