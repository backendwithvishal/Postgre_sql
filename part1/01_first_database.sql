CREATE DATABASE shopDB

DROP DATABASE shopDB 

DROP DATABASE shopDB with (FORCE)

// first query to genarate a Table

CREATE TABLE students(
id SERIAL PRIMARY KEY ,
name VARCHAR(20) NOT NULL,
age SMALLINT,
email VARCHAR(100) UNIQUE,
enroll_data DATE DEFAULT CURRENT_DATE
);

// query for NOT NULL

