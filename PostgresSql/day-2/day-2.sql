-- ====================================================================
-- 🐘 POSTGRESQL DAY 2: CONSTRAINTS, DATA TYPES & TABLE DESIGN
-- ====================================================================
-- This file demonstrates table design using PostgreSQL constraints:
-- PRIMARY KEY, NOT NULL, UNIQUE, CHECK, DEFAULT, and SERIAL.
-- Every query has a "Simple English Explanation" for beginners.
-- ====================================================================


-- ====================================================================
-- 📌 SECTION 1: EMPLOYEE MANAGEMENT TABLE (Constraints Demonstration)
-- ====================================================================

-- 💬 Simple English: "Delete the employees table if it already exists so we can re-create it clean."
DROP TABLE IF EXISTS employees;

-- 💬 Simple English: "Create an 'employees' table with strict business rules (constraints)."
-- Constraint explanations:
--   - emp_id SERIAL PRIMARY KEY : Auto-increments (1, 2, 3...) and uniquely identifies each employee.
--   - fname & lname VARCHAR NOT NULL : First and last name can never be left empty.
--   - email UNIQUE NOT NULL : No two employees can have the same email address.
--   - dept VARCHAR NOT NULL : Department must always be specified.
--   - salary NUMERIC CHECK (salary > 0) : Salary cannot be zero or negative.
--   - hire_date DATE DEFAULT CURRENT_DATE : If not provided, defaults to today's date.
--   - created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP : Records the exact second the row was added.
CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    fname VARCHAR(50) NOT NULL,
    lname VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    dept VARCHAR(50) NOT NULL,
    salary NUMERIC(10, 2) CHECK (salary > 0),
    hire_date DATE NOT NULL DEFAULT CURRENT_DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- ====================================================================
-- 📌 SECTION 2: INSERTING VALID EMPLOYEE DATA
-- ====================================================================

-- 💬 Simple English: "Insert 5 employee records with valid information."
INSERT INTO employees (fname, lname, email, dept, salary, hire_date) VALUES
('John', 'Doe', 'john.doe@company.com', 'Engineering', 75000.00, '2023-01-15'),
('Jane', 'Smith', 'jane.smith@company.com', 'Marketing', 65000.00, '2023-02-20'),
('Bob', 'Johnson', 'bob.johnson@company.com', 'Engineering', 80000.00, '2022-11-10'),
('Alice', 'Williams', 'alice.williams@company.com', 'HR', 60000.00, '2023-03-05'),
('Charlie', 'Brown', 'charlie.brown@company.com', 'Sales', 70000.00, '2023-01-25');


-- ====================================================================
-- 📌 SECTION 3: TESTING CONSTRAINTS (How Postgres protects your data)
-- ====================================================================

-- 💬 Simple English: "Testing UNIQUE constraint: Trying to insert a duplicate email will fail!"
-- ERROR: duplicate key value violates unique constraint "employees_email_key"
-- INSERT INTO employees (fname, lname, email, dept, salary) 
-- VALUES ('Duplicate', 'User', 'john.doe@company.com', 'IT', 50000.00);

-- 💬 Simple English: "Testing CHECK constraint: Trying to insert negative salary will fail!"
-- ERROR: new row for relation "employees" violates check constraint "employees_salary_check"
-- INSERT INTO employees (fname, lname, email, dept, salary) 
-- VALUES ('Negative', 'Salary', 'negative@company.com', 'IT', -500.00);

-- 💬 Simple English: "Testing NOT NULL constraint: Trying to omit a required first name will fail!"
-- ERROR: null value in column "fname" of relation "employees" violates not-null constraint
-- INSERT INTO employees (fname, lname, email, dept, salary) 
-- VALUES (NULL, 'NoName', 'noname@company.com', 'IT', 50000.00);


-- ====================================================================
-- 📌 SECTION 4: BASIC QUERIES ON EMPLOYEES
-- ====================================================================

-- 💬 Simple English: "Show all employees working in the 'HR' department."
SELECT * FROM employees 
WHERE dept = 'HR';

-- 💬 Simple English: "Find all employees with a salary greater than 70,000, ordered from highest to lowest."
SELECT fname, lname, dept, salary 
FROM employees 
WHERE salary > 70000 
ORDER BY salary DESC;

-- 💬 Simple English: "Calculate the total employee count and average salary per department."
SELECT 
    dept AS "Department",
    COUNT(*) AS "Employee Count",
    AVG(salary) AS "Average Salary",
    MIN(salary) AS "Lowest Salary",
    MAX(salary) AS "Highest Salary"
FROM employees
GROUP BY dept;


-- ====================================================================
-- 📌 SECTION 5: MODERN DATA TYPES (JSONB & ARRAY) TABLE
-- ====================================================================

-- 💬 Simple English: "Delete course_enrollments table if it exists so we can re-create it."
DROP TABLE IF EXISTS course_enrollments;

-- 💬 Simple English: "Create a course enrollments table that uses modern PostgreSQL data types:
-- JSONB (to store flexible JSON metadata) and TEXT[] (to store a list of skill tags)."
CREATE TABLE course_enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    student_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    course_name VARCHAR(50) NOT NULL,
    level VARCHAR(20),
    price NUMERIC(8,2) CHECK (price > 0),
    enrolled_on DATE DEFAULT CURRENT_DATE,
    completion_status BOOLEAN DEFAULT FALSE,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    course_meta JSONB,
    skills TEXT[]
);

-- 💬 Simple English: "Check the structure of both tables."
-- In psql terminal:
-- \d employees;
-- \d course_enrollments;