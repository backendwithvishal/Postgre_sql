-- ====================================================================
-- 🐘 POSTGRESQL DAY 4: SQL JOINS & VIEWS
-- ====================================================================
-- This file contains all types of SQL JOINs in PostgreSQL:
-- 1. INNER JOIN
-- 2. LEFT JOIN (LEFT OUTER JOIN)
-- 3. RIGHT JOIN (RIGHT OUTER JOIN)
-- 4. FULL OUTER JOIN
-- 5. CROSS JOIN
-- 6. SELF JOIN
-- 7. ANTI-JOIN (Finding unmatched records)
-- 8. DATABASE VIEWS (CREATE VIEW & DROP VIEW)
-- 9. GROUP BY & HAVING with JOINs
-- Every query has a "Simple English Explanation" for beginners.
-- ====================================================================


-- ====================================================================
-- 📌 SECTION 1: SAMPLE TABLE SETUP
-- ====================================================================

-- 💬 Simple English: "Clean up previous tables if they exist."
DROP TABLE IF EXISTS students CASCADE;
DROP TABLE IF EXISTS classes CASCADE;

-- 💬 Simple English: "Create 'classes' table to store courses offered."
CREATE TABLE classes (
    class_id INT PRIMARY KEY,
    class_name VARCHAR(50) NOT NULL
);

-- 💬 Simple English: "Create 'students' table. Notice 'class_id' is optional (can be NULL)
-- so we can see how LEFT JOIN and FULL JOIN handle missing values."
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    class_id INT
);

-- 💬 Simple English: "Insert 3 courses."
INSERT INTO classes (class_id, class_name) VALUES
(101, 'JavaScript'),
(102, 'Python'),
(103, 'Java');   -- Notice: No student is enrolled in Java yet!

-- 💬 Simple English: "Insert 4 students."
INSERT INTO students (student_id, name, class_id) VALUES
(1, 'Rahul',  101),   -- Enrolled in JavaScript
(2, 'Anjali', 102),   -- Enrolled in Python
(3, 'Aman',   101),   -- Enrolled in JavaScript
(4, 'Neha',   NULL);  -- Not enrolled in any class yet (class_id is NULL)

-- 💬 Simple English: "Verify raw data inside both tables."
SELECT * FROM classes;
SELECT * FROM students;


-- ====================================================================
-- 📌 SECTION 2: INNER JOIN
-- ====================================================================
-- 💡 Concept: Returns ONLY rows where there is a match in BOTH tables.
-- Students without a class (Neha) and classes without students (Java) are EXCLUDED.

-- 💬 Simple English: "Show student name and their class name ONLY for students who are actually enrolled in a class."
SELECT s.student_id, s.name AS student_name, c.class_name
FROM students s
INNER JOIN classes c ON s.class_id = c.class_id;


-- ====================================================================
-- 📌 SECTION 3: LEFT JOIN (LEFT OUTER JOIN)
-- ====================================================================
-- 💡 Concept: Returns ALL rows from the LEFT table (students).
-- If a student has no matching class, the class column shows NULL (e.g., Neha -> NULL).

-- 💬 Simple English: "Show ALL students, along with their class name if they have one. If not, show NULL."
SELECT s.student_id, s.name AS student_name, c.class_name
FROM students s
LEFT JOIN classes c ON s.class_id = c.class_id;


-- ====================================================================
-- 📌 SECTION 4: RIGHT JOIN (RIGHT OUTER JOIN)
-- ====================================================================
-- 💡 Concept: Returns ALL rows from the RIGHT table (classes).
-- If a class has no students (e.g., Java), the student columns show NULL.

-- 💬 Simple English: "Show ALL classes, along with students enrolled in them. If a class has 0 students, show NULL for student name."
SELECT s.name AS student_name, c.class_id, c.class_name
FROM students s
RIGHT JOIN classes c ON s.class_id = c.class_id;


-- ====================================================================
-- 📌 SECTION 5: FULL OUTER JOIN (PostgreSQL Specialty)
-- ====================================================================
-- 💡 Concept: Combines LEFT JOIN and RIGHT JOIN together.
-- Returns ALL rows from both tables. Shows NULL wherever there is no match on either side.

-- 💬 Simple English: "Show ALL students AND ALL classes. Include students without a class AND classes without any students."
SELECT s.name AS student_name, c.class_name
FROM students s
FULL OUTER JOIN classes c ON s.class_id = c.class_id;


-- ====================================================================
-- 📌 SECTION 6: CROSS JOIN (Cartesian Product)
-- ====================================================================
-- 💡 Concept: Multiplies every row of the first table with every row of the second table (4 students × 3 classes = 12 combinations).

-- 💬 Simple English: "Generate every possible student-course pairing combination."
SELECT s.name AS student_name, c.class_name
FROM students s
CROSS JOIN classes c;


-- ====================================================================
-- 📌 SECTION 7: ANTI-JOINS (Finding Missing / Unmatched Records)
-- ====================================================================

-- 💬 Simple English: "Find only the students who are NOT enrolled in any class."
SELECT s.student_id, s.name
FROM students s
LEFT JOIN classes c ON s.class_id = c.class_id
WHERE c.class_id IS NULL;

-- 💬 Simple English: "Find only the classes that currently have ZERO students enrolled."
SELECT c.class_id, c.class_name
FROM classes c
LEFT JOIN students s ON c.class_id = s.class_id
WHERE s.student_id IS NULL;


-- ====================================================================
-- 📌 SECTION 8: SELF JOIN (Hierarchical Data: Employees & Managers)
-- ====================================================================
-- 💡 Concept: A table joins with ITSELF. Used when a column references another row in the same table.

DROP TABLE IF EXISTS employees CASCADE;

-- 💬 Simple English: "Create an employees table where manager_id points to another employee's employee_id."
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    manager_id INT,
    CONSTRAINT fk_manager FOREIGN KEY (manager_id) REFERENCES employees(employee_id)
);

-- 💬 Simple English: "Insert employees:
-- Rahul has no manager (top boss).
-- Anjali and Aman report to Rahul (id 1).
-- Neha reports to Anjali (id 2)."
INSERT INTO employees (employee_id, name, manager_id) VALUES
(1, 'Rahul',  NULL),  -- CEO / Top-level Manager
(2, 'Anjali', 1),     -- Reports to Rahul
(3, 'Aman',   1),     -- Reports to Rahul
(4, 'Neha',   2);     -- Reports to Anjali

-- 💬 Simple English: "Show each employee alongside the name of their manager."
SELECT 
    e.name AS employee_name,
    COALESCE(m.name, 'Top Level Boss (No Manager)') AS manager_name
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.employee_id;


-- ====================================================================
-- 📌 SECTION 9: DATABASE VIEWS (Saved Virtual Queries)
-- ====================================================================
-- 💡 Concept: A VIEW is a saved SQL query you can treat like a virtual table.

-- 💬 Simple English: "Create a reusable View that saves our student-class full join query."
DROP VIEW IF EXISTS student_classes_view;

CREATE VIEW student_classes_view AS
SELECT 
    COALESCE(s.name, 'No Student') AS student_name,
    COALESCE(c.class_name, 'No Class Assigned') AS class_name
FROM students s
FULL OUTER JOIN classes c ON s.class_id = c.class_id;

-- 💬 Simple English: "Query the view just like a regular table."
SELECT * FROM student_classes_view;


-- ====================================================================
-- 📌 SECTION 10: JOINS WITH GROUP BY & HAVING
-- ====================================================================

-- 💬 Simple English: "Count how many students are enrolled in each class (including classes with 0 students)."
SELECT 
    c.class_name,
    COUNT(s.student_id) AS total_enrolled_students
FROM classes c
LEFT JOIN students s ON c.class_id = s.class_id
GROUP BY c.class_name
ORDER BY total_enrolled_students DESC;

-- 💬 Simple English: "Show only classes that have strictly MORE THAN 1 enrolled student."
SELECT 
    c.class_name,
    COUNT(s.student_id) AS total_enrolled_students
FROM classes c
INNER JOIN students s ON c.class_id = s.class_id
GROUP BY c.class_name
HAVING COUNT(s.student_id) > 1;
