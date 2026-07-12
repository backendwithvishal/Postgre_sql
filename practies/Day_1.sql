CREATE DATABASE techcopy;

CREATE TABLE departments (
department_id SERIAL PRIMARY KEY,
department_name VARCHAR(100) NOT NULL,
location VARCHAR(100),
budget NUMERIC(12, 2)
);

CREATE TABLE employees (
employee_id SERIAL PRIMARY KEY,
first_name VARCHAR(50) NOT NULL,
last_name VARCHAR(50) NOT NULL,
email VARCHAR(100) UNIQUE NOT NULL,
salary NUMERIC(10, 2),
hire_date DATE NOT NULL,
department_id INT,
is_active BOOLEAN DEFAULT TRUE
);

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

SELECT * FROM  departments;

SELECT * FROM employees;

SELECT first_name, last_name, salary FROM employees;

SELECT 
first_name AS "First Name",
last_name AS "Last Name",
salary AS "Annual Salary"
FROM employees;

SELECT * FROM departments;

SELECT first_name, last_name, salary
FROM employees
WHERE salary > 80000;

SELECT first_name, last_name, department_id
FROM employees
WHERE department_id = 1;

SELECT first_name, last_name, hire_date
FROM employees
WHERE hire_date > '2021-01-01';

SELECT first_name, last_name, salary
FROM employees
WHERE salary > 70000 AND department_id = 1;

SELECT * FROM employees
WHERE first_name = 'Alice';

SELECT first_name, last_name, salary
FROM employees
ORDER BY salary ASC;

SELECT first_name, last_name, salary
FROM employees
ORDER BY salary DESC
LIMIT 5;

SELECT DISTINCT department_id
FROM employees
ORDER BY department_id;

SELECT first_name, last_name, hire_date
FROM employees
ORDER BY hire_date DESC
LIMIT 5;

SELECT first_name, lst

SELECT COUNT(*) AS total_emplyees FROM employees;

SELECT SUM(salary) AS total_salary_expense FROM employees;