CREATE DATABASE school

DROP DATABASE school

DROP DATABASE school with (FORCE)

// first query to genarate a Table

CREATE TABLE students(
id SERIAL PRIMARY KEY ,
name VARCHAR(20) NOT NULL,
age SMALLINT,
email VARCHAR(100) UNIQUE,
enroll_data DATE DEFAULT CURRENT_DATE
);

// query for NOT NULL

CREATE TABLE student (
   id SERIAL PRIMARY KEY,
   name VARCHAR(100) NOT NULL,
   class INT CHECK (class BETWEEN 1 AND 12),
   marks INT CHECK (marks BETWEEN 0 AND 100),
   city VARCHAR(50),
   gender CHAR(1) CHECK (gender IN ('M','F')),
   created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
select * from users

select NULL =0;

// creating schema
CREATE SCHEMA IF NOT EXISTS basics;

CREATE EXTENSION IF NOT EXISTS pgcrypto;

SELECT schema_name
FROM information_schema.schemata
ORDER BY schema_name;