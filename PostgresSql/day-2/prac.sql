-- ====================================================================
-- 🐘 POSTGRESQL DAY 2: PRACTICE QUERIES (JSONB, ARRAYS, AGGREGATIONS)
-- ====================================================================
-- This file contains practical exercises querying JSONB fields,
-- PostgreSQL Arrays, Pattern Matching, Grouping, and Aggregates.
-- Every query has a "Simple English Explanation" for beginners.
-- ====================================================================


-- ====================================================================
-- 📌 SECTION 1: TABLE SETUP AND DATA INSERTION
-- ====================================================================

-- 💬 Simple English: "Reset the course_enrollments table."
DROP TABLE IF EXISTS course_enrollments;

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

-- 💬 Simple English: "Insert 10 sample enrollment records with JSON metadata and skill arrays."
INSERT INTO course_enrollments (student_name, email, course_name, level, price, enrolled_on, completion_status, rating, course_meta, skills) VALUES
('Suraj Jha',     'suraj@chaicode.com',          'Next.js Mastery',     'Advanced',     299.99, '2025-12-01', TRUE,  5,    '{"duration": "30 hours", "instructor": "Suraj"}',              ARRAY['React','Next.js','TypeScript']),
('Priya Singh',   'priya@example.com',           'React Native Basics', 'Beginner',     149.00, '2025-11-15', FALSE, NULL, '{"duration": "20 hours", "platform": "Expo"}',                ARRAY['React Native','JavaScript']),
('Amit Kumar',    'amit.dev@outlook.com',        'Node.js APIs',        'Intermediate', 249.50, '2025-12-20', TRUE,  4,    '{"duration": "25 hours", "tools": ["Prisma","Express"]}',      ARRAY['Node.js','Prisma','REST']),
('Neha Patel',    'neha@tech.com',               'Full-Stack React',    'Advanced',     399.99, '2025-11-10', TRUE,  5,    '{"duration": "40 hours", "projects": 5}',                      ARRAY['React','Next.js','PostgreSQL']),
('Rahul Gupta',   'rahul.gupta@gmail.com',       'Python for AI',       'Intermediate', 199.00, '2025-12-05', FALSE, 3,    '{"duration": "22 hours", "libs": ["LangChain"]}',              ARRAY['Python','AI/ML']),
('Deepika Rani',  'deepika.rani@yahoo.com',      'Docker Essentials',   'Beginner',     129.99, '2025-11-25', TRUE,  4,    '{"duration": "15 hours", "cloud": "Cloudflare"}',              ARRAY['Docker','DevOps']),
('Vikram Singh',  'vikram@codearmy.com',         'Advanced SQL',        'Intermediate', 179.50, '2025-12-15', FALSE, NULL, '{"duration": "18 hours", "db": "PostgreSQL"}',                 ARRAY['SQL','PostgreSQL','Indexes']),
('Anita Joshi',   'anita.joshi@edu.in',          'TypeScript Pro',      'Advanced',     279.00, '2025-11-30', TRUE,  5,    '{"duration": "28 hours", "focus": "Generics"}',                ARRAY['TypeScript','Advanced JS']),
('Karan Mehra',   'karan.mehra@freelancer.com',  'Cloudflare Workers',  'Intermediate', 225.75, '2025-12-10', TRUE,  4,    '{"duration": "24 hours", "serverless": true}',                 ARRAY['Cloudflare','Workers','Edge']),
('Sonia Verma',   'sonia.verma@startup.in',      'AI Integration',      'Advanced',     349.99, '2025-12-25', FALSE, 2,    '{"duration": "35 hours", "apis": ["OpenAI"]}',                 ARRAY['AI','LangChain','Vercel']);


-- ====================================================================
-- 📌 SECTION 2: BASIC RETRIEVAL & FILTERING
-- ====================================================================

-- 💬 Simple English: "Show all records from the table."
SELECT * FROM course_enrollments;

-- 💬 Simple English: "Show only students enrolled in 'Beginner' level courses."
SELECT student_name, course_name, price 
FROM course_enrollments
WHERE level = 'Beginner';

-- 💬 Simple English: "Get a list of distinct (unique) course names without duplicates."
SELECT DISTINCT course_name 
FROM course_enrollments;

-- 💬 Simple English: "Show students who are in Intermediate courses AND have already completed the course."
SELECT student_name, course_name, level, completion_status 
FROM course_enrollments
WHERE level = 'Intermediate' AND completion_status = TRUE;

-- 💬 Simple English: "Show students who are in Beginner OR Advanced courses."
SELECT student_name, course_name, level 
FROM course_enrollments
WHERE level = 'Beginner' OR level = 'Advanced';

-- 💬 Simple English: "Find students enrolled in either 'Next.js Mastery' or 'Node.js APIs' using IN operator."
SELECT student_name, course_name, price 
FROM course_enrollments
WHERE course_name IN ('Next.js Mastery', 'Node.js APIs');


-- ====================================================================
-- 📌 SECTION 3: WORKING WITH JSONB DATA (PostgreSQL Specialty)
-- ====================================================================

-- 💬 Simple English: "Extract the 'duration' property from the course_meta JSON column as plain text."
-- Operator '->>' returns the extracted field as readable TEXT.
SELECT student_name, course_name, course_meta->>'duration' AS duration
FROM course_enrollments;

-- 💬 Simple English: "Extract the 'platform' property from JSON (returns NULL for rows that don't have it)."
SELECT student_name, course_meta->>'platform' AS platform
FROM course_enrollments;

-- 💬 Simple English: "Find all course enrollments where the JSON metadata contains instructor = 'Suraj'."
-- Operator '@>' checks if the left JSON contains the right JSON key-value pair.
SELECT student_name, course_name, course_meta
FROM course_enrollments
WHERE course_meta @> '{"instructor": "Suraj"}';


-- ====================================================================
-- 📌 SECTION 4: WORKING WITH POSTGRESQL ARRAYS
-- ====================================================================

-- 💬 Simple English: "Find all students whose skills array includes 'React'."
-- Operator '@>' checks if the array contains the given element(s).
SELECT student_name, course_name, skills
FROM course_enrollments
WHERE skills @> ARRAY['React'];

-- 💬 Simple English: "Find all students who have 'PostgreSQL' anywhere in their skills array using ANY()."
SELECT student_name, course_name, skills
FROM course_enrollments
WHERE 'PostgreSQL' = ANY(skills);

-- 💬 Simple English: "Unnest the skills array (flattens each skill tag into its own separate row)."
SELECT student_name, UNNEST(skills) AS individual_skill
FROM course_enrollments;


-- ====================================================================
-- 📌 SECTION 5: PATTERN MATCHING (LIKE & ILIKE)
-- ====================================================================

-- 💬 Simple English: "Find students whose name starts with 'A' or 'a' (case-insensitive with ILIKE)."
-- 'A%' means 'starts with A, followed by any characters'.
SELECT student_name, email 
FROM course_enrollments
WHERE student_name ILIKE 'a%';

-- 💬 Simple English: "Find students whose name ends with 'Singh'."
-- '%Singh' means 'any characters leading up to Singh'.
SELECT student_name, email 
FROM course_enrollments
WHERE student_name LIKE '%Singh';

-- 💬 Simple English: "Find students whose name has exactly 5 letters ending with 'a' (e.g., 'Neha', 'Priya' has 5 chars)."
-- Each underscore '_' represents exactly ONE character.
SELECT student_name 
FROM course_enrollments
WHERE student_name LIKE '____a';


-- ====================================================================
-- 📌 SECTION 6: STRING MANIPULATION FUNCTIONS
-- ====================================================================

-- 💬 Simple English: "Display student names in ALL UPPERCASE letters."
SELECT UPPER(student_name) AS uppercase_name, LOWER(email) AS lowercase_email
FROM course_enrollments;

-- 💬 Simple English: "Combine (concatenate) student name and course name into a single friendly message."
SELECT CONCAT(student_name, ' is enrolled in ', course_name) AS enrollment_summary
FROM course_enrollments;


-- ====================================================================
-- 📌 SECTION 7: AGGREGATE FUNCTIONS (COUNT, SUM, AVG, MIN, MAX)
-- ====================================================================

-- 💬 Simple English: "Count the total number of enrollments in the entire table."
SELECT COUNT(*) AS total_enrollments 
FROM course_enrollments;

-- 💬 Simple English: "Calculate the total total revenue generated by all course sales."
SELECT SUM(price) AS total_revenue 
FROM course_enrollments;

-- 💬 Simple English: "Find the average, minimum, and maximum course prices."
SELECT 
    ROUND(AVG(price), 2) AS average_price,
    MIN(price) AS lowest_price,
    MAX(price) AS highest_price
FROM course_enrollments;

-- 💬 Simple English: "Calculate the average student rating for courses (ignoring unrated NULL values)."
SELECT ROUND(AVG(rating), 2) AS average_rating 
FROM course_enrollments 
WHERE rating IS NOT NULL;


-- ====================================================================
-- 📌 SECTION 8: GROUP BY & HAVING (Grouping Data)
-- ====================================================================

-- 💬 Simple English: "Calculate the total revenue and enrollment count for each course."
SELECT 
    course_name,
    COUNT(*) AS total_students,
    SUM(price) AS total_revenue
FROM course_enrollments
GROUP BY course_name
ORDER BY total_revenue DESC;

-- 💬 Simple English: "Find the average student rating for each course."
SELECT 
    course_name,
    ROUND(AVG(rating), 2) AS avg_rating
FROM course_enrollments
WHERE rating IS NOT NULL
GROUP BY course_name;

-- 💬 Simple English: "Count how many students have completed vs not completed their courses."
SELECT 
    completion_status AS is_completed,
    COUNT(*) AS student_count
FROM course_enrollments
GROUP BY completion_status;

-- 💬 Simple English: "Show only course levels that have 3 or more enrolled students (HAVING filters groups)."
SELECT 
    level,
    COUNT(*) AS total_students,
    ROUND(AVG(price), 2) AS avg_price
FROM course_enrollments
GROUP BY level
HAVING COUNT(*) >= 3;


-- ====================================================================
-- 📌 SECTION 9: SORTING AND PAGINATION
-- ====================================================================

-- 💬 Simple English: "Show top 5 most expensive course enrollments."
SELECT student_name, course_name, price 
FROM course_enrollments
ORDER BY price DESC
LIMIT 5;

-- 💬 Simple English: "Get page 2 of students (3 items per page, so skip 3, take next 3)."
SELECT enrollment_id, student_name, course_name 
FROM course_enrollments
ORDER BY enrollment_id ASC
LIMIT 3 OFFSET 3;
