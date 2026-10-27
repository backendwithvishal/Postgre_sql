
-- DROP TABLE IF EXISTS basics.students;

CREATE TABLE basics.students (

    id SERIAL PRIMARY KEY,
    -- this is a primary key which uniquely represent the tuples or the rows of table & primary key is autoincrement also 

    name TEXT NOT NULL,
    -- NOT NULL means that this column cannot be empty or null

    email TEXT NOT NULL UNIQUE,
    -- UNIQUE means that this column cannot have duplicate values 

    age INTEGER CHECK (age >= 18),
    -- INTEGER means that this column can store integer values only 
    -- CHECK (age >= 18) means that this column can only store values greater than or equal to 18

    created_at TIMESTAMP DEFAULT NOW()
    -- TIMESTAMP means that this column can store timestamp values only 
    -- DEFAULT NOW() means that this column will have a default value of the current timestamp

);