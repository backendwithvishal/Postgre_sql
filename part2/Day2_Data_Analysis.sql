/* ============================================================
   DAY 2 — DATA ANALYSIS
   Aggregate Functions, GROUP BY, HAVING, CASE,
   Date Functions, String Functions
   Tested and verified on PostgreSQL 16 — all queries confirmed
   to run without errors and return correct results.

   PRE-REQUISITE: Run Day1_SQL_Fundamentals.sql first.
   This script uses the same "techcorp" database, "employees"
   and "departments" tables, and same sample data.
   ============================================================ */

-- Make sure you're connected to techcorp before running this
-- psql:    \c techcorp
-- pgAdmin: switch Query Tool connection to "techcorp"


/* ----------------------------------------------------------
   PART 1 — AGGREGATE FUNCTIONS
   COUNT, SUM, AVG, MIN, MAX
   ---------------------------------------------------------- */

-- Total number of employees
SELECT COUNT(*) AS total_employees FROM employees;

-- Total salary expense (company payroll)
SELECT SUM(salary) AS total_salary_expense FROM employees;

-- Average salary across all employees
SELECT AVG(salary) AS average_salary FROM employees;

-- Highest and lowest salary in one query
SELECT MAX(salary) AS highest_salary, MIN(salary) AS lowest_salary
FROM employees;

-- ROUND() to clean up decimal places
SELECT ROUND(AVG(salary), 2) AS average_salary FROM employees;


/* ----------------------------------------------------------
   PART 2 — GROUP BY
   Aggregate functions become powerful when grouped
   ---------------------------------------------------------- */

-- Employee count per department
SELECT department_id, COUNT(*) AS employee_count
FROM employees
GROUP BY department_id
ORDER BY department_id;

-- Average salary per department, highest paying dept first
SELECT department_id, ROUND(AVG(salary), 2) AS avg_salary
FROM employees
GROUP BY department_id
ORDER BY avg_salary DESC;

-- Total salary cost per department
SELECT department_id, SUM(salary) AS total_salary
FROM employees
GROUP BY department_id
ORDER BY total_salary DESC;


/* ----------------------------------------------------------
   PART 3 — HAVING
   Filters groups AFTER aggregation (WHERE filters rows BEFORE)
   ---------------------------------------------------------- */

-- Departments with more than 2 employees
SELECT department_id, COUNT(*) AS employee_count
FROM employees
GROUP BY department_id
HAVING COUNT(*) > 2;

-- Departments where average salary exceeds 75,000
SELECT department_id, ROUND(AVG(salary), 2) AS avg_salary
FROM employees
GROUP BY department_id
HAVING AVG(salary) > 75000
ORDER BY avg_salary DESC;


/* ----------------------------------------------------------
   PART 4 — CASE statements
   SQL's if/else — classify rows based on conditions
   ---------------------------------------------------------- */

-- Salary band classification
SELECT
    first_name,
    last_name,
    salary,
    CASE
        WHEN salary >= 90000 THEN 'High'
        WHEN salary >= 70000 THEN 'Medium'
        ELSE 'Low'
    END AS salary_band
FROM employees
ORDER BY salary DESC;

-- Tenure / seniority classification using hire_date
SELECT
    first_name,
    last_name,
    hire_date,
    CASE
        WHEN hire_date < '2020-01-01' THEN 'Veteran'
        WHEN hire_date < '2022-01-01' THEN 'Experienced'
        ELSE 'New Hire'
    END AS tenure_status
FROM employees
ORDER BY hire_date;


/* ----------------------------------------------------------
   PART 5 — DATE FUNCTIONS
   ---------------------------------------------------------- */

-- Today's date and current timestamp
SELECT CURRENT_DATE AS today, NOW() AS current_timestamp;

-- Calculate exact time employed using AGE()
SELECT
    first_name,
    last_name,
    hire_date,
    AGE(CURRENT_DATE, hire_date) AS time_employed
FROM employees
ORDER BY hire_date;

-- EXTRACT a specific part of a date (year, month, day...)
SELECT
    first_name,
    last_name,
    EXTRACT(YEAR FROM hire_date) AS hire_year
FROM employees
ORDER BY hire_year;

-- Filter by extracted year
SELECT first_name, last_name, hire_date
FROM employees
WHERE EXTRACT(YEAR FROM hire_date) = 2020;

-- Date arithmetic: add an INTERVAL (e.g. 90-day probation end date)
SELECT
    first_name,
    last_name,
    hire_date,
    hire_date + INTERVAL '90 days' AS probation_end
FROM employees;


/* ----------------------------------------------------------
   PART 6 — STRING FUNCTIONS
   ---------------------------------------------------------- */

-- Concatenate using the || operator
SELECT
    first_name || ' ' || last_name AS full_name
FROM employees;

-- Concatenate using CONCAT(), plus UPPER()
SELECT
    CONCAT(first_name, ' ', last_name) AS full_name,
    UPPER(last_name) AS last_name_upper
FROM employees;

-- LENGTH() of a string
SELECT
    email,
    LENGTH(email) AS email_length
FROM employees
ORDER BY email_length DESC;

-- LOWER() and UPPER()
SELECT
    LOWER(first_name) AS lower_name,
    UPPER(last_name) AS upper_name
FROM employees;

-- SUBSTRING() — extract part of a string
SELECT
    first_name,
    SUBSTRING(first_name FROM 1 FOR 3) AS short_name
FROM employees;

-- TRIM() — remove leading/trailing spaces
SELECT TRIM('   PostgreSQL   ') AS trimmed_text;

-- REPLACE() — swap part of a string (e.g. changing email domain)
SELECT
    email,
    REPLACE(email, '@techcorp.com', '@newcorp.com') AS new_email
FROM employees;


/* ============================================================
   EXERCISES — write your own queries below this line.
   Solutions are NOT included here on purpose — attempt them
   yourself first, then share your answers in chat for review.
   ============================================================

   BEGINNER
   1. Count total employees.
   2. Find company-wide average salary, rounded to 2 decimals.
   3. Find the highest salary in department_id = 3.
   4. Display each employee's full name in UPPERCASE.
   5. Find employees hired in the year 2023.

   INTERMEDIATE
   6. Find departments with 3 or more employees (GROUP BY + HAVING).
   7. Classify each employee's salary using CASE into:
      'Senior Pay' (>=85000), 'Mid Pay' (>=65000), 'Entry Pay' (rest).
   8. Find departments with budget > 180000, ordered by budget DESC.

   ADVANCED CHALLENGE
   9. Using a JOIN between employees and departments:
      show department_name, employee_count, average salary
      (rounded to 2 decimals), and a CASE-based label:
      'High Budget Dept' if avg salary >= 85000, else 'Standard Dept'.
      Only include departments where avg salary > 70000.
      Order by avg_salary descending.
   ============================================================ */
