/* ============================================================
   DAY 1 — SQL FUNDAMENTALS
   Databases, Tables, INSERT, SELECT, WHERE, ORDER BY,
   LIMIT, DISTINCT
   Tested and verified on PostgreSQL 16 — all queries confirmed
   to run without errors and return correct results.
   ============================================================ */


/* ----------------------------------------------------------
   STEP 1 — CREATE THE DATABASE
   Run this part by itself first, then connect to "techcorp"
   before running the rest of the script.
   In psql:    \c techcorp
   In pgAdmin: switch the Query Tool connection to "techcorp"
   ---------------------------------------------------------- */

CREATE DATABASE techcorp;


/* ----------------------------------------------------------
   STEP 2 — CREATE TABLES
   ---------------------------------------------------------- */

CREATE TABLE departments (
    department_id   SERIAL PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL,
    location        VARCHAR(100),
    budget          NUMERIC(12, 2)
);

CREATE TABLE employees (
    employee_id   SERIAL PRIMARY KEY,
    first_name    VARCHAR(50)  NOT NULL,
    last_name     VARCHAR(50)  NOT NULL,
    email         VARCHAR(100) UNIQUE NOT NULL,
    salary        NUMERIC(10, 2),
    hire_date     DATE         NOT NULL,
    department_id INT,
    is_active     BOOLEAN      DEFAULT TRUE
);


/* ----------------------------------------------------------
   STEP 3 — INSERT SAMPLE DATA
   ---------------------------------------------------------- */

INSERT INTO departments (department_name, location, budget)
VALUES
    ('Engineering',  'Floor 3', 500000.00),
    ('Marketing',    'Floor 2', 200000.00),
    ('Sales',        'Floor 1', 350000.00),
    ('HR',           'Floor 2', 150000.00),
    ('Finance',      'Floor 4', 180000.00);

INSERT INTO employees (first_name, last_name, email, salary, hire_date, department_id)
VALUES
    ('Alice',   'Johnson',  'alice@techcorp.com',   85000.00, '2020-03-15', 1),
    ('Bob',     'Smith',    'bob@techcorp.com',      72000.00, '2019-07-01', 2),
    ('Carol',   'White',    'carol@techcorp.com',    95000.00, '2021-01-10', 1),
    ('David',   'Brown',    'david@techcorp.com',    68000.00, '2022-05-20', 3),
    ('Emma',    'Davis',    'emma@techcorp.com',     78000.00, '2020-11-30', 4),
    ('Frank',   'Miller',   'frank@techcorp.com',    91000.00, '2018-09-12', 1),
    ('Grace',   'Wilson',   'grace@techcorp.com',    65000.00, '2023-02-14', 3),
    ('Henry',   'Moore',    'henry@techcorp.com',    88000.00, '2019-04-03', 5),
    ('Iris',    'Taylor',   'iris@techcorp.com',     74000.00, '2021-08-25', 2),
    ('James',   'Anderson', 'james@techcorp.com',    55000.00, '2023-06-01', 3);


/* ----------------------------------------------------------
   STEP 4 — SELECT BASICS
   ---------------------------------------------------------- */

-- All columns, all rows
SELECT * FROM employees;

-- Specific columns only
SELECT first_name, last_name, salary FROM employees;

-- Column aliases for friendlier output
SELECT
    first_name  AS "First Name",
    last_name   AS "Last Name",
    salary      AS "Annual Salary"
FROM employees;

-- View departments table
SELECT * FROM departments;


/* ----------------------------------------------------------
   STEP 5 — WHERE: FILTERING ROWS
   ---------------------------------------------------------- */

-- Salary above 80,000
SELECT first_name, last_name, salary
FROM employees
WHERE salary > 80000;

-- Specific department
SELECT first_name, last_name, department_id
FROM employees
WHERE department_id = 1;

-- Hired after a certain date
SELECT first_name, last_name, hire_date
FROM employees
WHERE hire_date > '2021-01-01';

-- AND: both conditions must be true
SELECT first_name, last_name, salary, department_id
FROM employees
WHERE salary > 70000 AND department_id = 1;

-- OR: at least one condition must be true
SELECT first_name, last_name, salary
FROM employees
WHERE salary < 60000 OR salary > 90000;

-- Exact text match (always single quotes)
SELECT * FROM employees
WHERE first_name = 'Alice';


/* ----------------------------------------------------------
   STEP 6 — ORDER BY, LIMIT, DISTINCT
   ---------------------------------------------------------- */

-- Ascending sort
SELECT first_name, last_name, salary
FROM employees
ORDER BY salary ASC;

-- Descending sort
SELECT first_name, last_name, salary
FROM employees
ORDER BY salary DESC;

-- Top 3 highest paid
SELECT first_name, last_name, salary
FROM employees
ORDER BY salary DESC
LIMIT 3;

-- Unique department IDs in use
SELECT DISTINCT department_id
FROM employees
ORDER BY department_id;

-- Top 5 most recently hired
SELECT first_name, last_name, hire_date
FROM employees
ORDER BY hire_date DESC
LIMIT 5;


/* ============================================================
   EXERCISES — write your own queries below this line.
   Solutions are NOT included here on purpose — attempt them
   yourself first, then share your answers in chat for review.
   ============================================================

   BEGINNER
   1. Select all columns from departments.
   2. Select first_name, last_name, email from employees.
   3. Find employees with salary < 75000.
   4. List all employees ordered by last_name A-Z.
   5. Show top 3 rows from employees ordered by hire_date ascending.

   INTERMEDIATE
   6. Employees in department_id = 3 AND salary > 60000.
   7. Unique locations from departments (DISTINCT).
   8. Employees hired between 2020-01-01 and 2021-12-31.

   ADVANCED CHALLENGE
   9. One query: first_name, last_name, salary (aliased "Annual Pay"),
      hire_date; salary between 65000-90000; hired before 2022;
      ordered by salary DESC; limited to top 4 results.
   ============================================================ */
