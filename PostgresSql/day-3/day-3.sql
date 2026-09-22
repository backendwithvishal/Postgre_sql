-- ====================================================================
-- 🐘 POSTGRESQL DAY 3: ALTER TABLE, CASE EXPRESSIONS & RELATIONSHIPS
-- ====================================================================
-- This file contains all SQL commands for Day 3:
-- 1. ALTER TABLE (modifying table structure without losing data)
-- 2. CASE Expressions (If-Else conditional logic in SQL)
-- 3. Database Relationships (1:1, 1:N, N:M with Foreign Keys)
-- Every query has a "Simple English Explanation" for beginners.
-- ====================================================================


-- ====================================================================
-- 📌 PART 1: ALTER TABLE COMMANDS (Modifying Existing Tables)
-- ====================================================================

-- 💬 Simple English: "Delete previous test tables if they exist so we start clean."
DROP TABLE IF EXISTS movies CASCADE;

-- 💬 Simple English: "Create a basic starting movies table."
CREATE TABLE movies (
    movie_id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    release_year INTEGER
);

-- --------------------------------------------------------------------
-- 1.1 ADDING COLUMNS
-- --------------------------------------------------------------------

-- 💬 Simple English: "Add a new column 'director' to the movies table."
ALTER TABLE movies
ADD COLUMN director VARCHAR(100);

-- 💬 Simple English: "Add multiple columns ('budget' and 'box_office') at the same time."
ALTER TABLE movies
ADD COLUMN budget DECIMAL(12, 2),
ADD COLUMN box_office DECIMAL(12, 2);

-- 💬 Simple English: "Add a column 'rating' with a default fallback value of 'PG-13'."
ALTER TABLE movies
ADD COLUMN rating VARCHAR(10) DEFAULT 'PG-13';

-- 💬 Simple English: "Add a column 'duration_minutes' that can never be null, defaulting to 120."
ALTER TABLE movies
ADD COLUMN duration_minutes INTEGER NOT NULL DEFAULT 120;


-- --------------------------------------------------------------------
-- 1.2 DROPPING COLUMNS
-- --------------------------------------------------------------------

-- 💬 Simple English: "Remove the 'budget' column from the movies table."
ALTER TABLE movies
DROP COLUMN budget;

-- 💬 Simple English: "Remove multiple columns ('box_office' and 'duration_minutes') at once."
ALTER TABLE movies
DROP COLUMN box_office,
DROP COLUMN duration_minutes;


-- --------------------------------------------------------------------
-- 1.3 RENAMING COLUMNS & TABLES
-- --------------------------------------------------------------------

-- 💬 Simple English: "Rename the column 'release_year' to 'year_released'."
ALTER TABLE movies
RENAME COLUMN release_year TO year_released;

-- 💬 Simple English: "Rename the column 'title' to 'movie_title'."
ALTER TABLE movies
RENAME COLUMN title TO movie_title;

-- 💬 Simple English: "Rename the entire table from 'movies' to 'cinema_films'."
ALTER TABLE movies
RENAME TO cinema_films;

-- 💬 Simple English: "Rename the table back to 'movies'."
ALTER TABLE cinema_films
RENAME TO movies;


-- --------------------------------------------------------------------
-- 1.4 MODIFYING COLUMN DATA TYPES & CONSTRAINTS
-- --------------------------------------------------------------------

-- 💬 Simple English: "Change the data type of 'year_released' to SMALLINT (saves storage space)."
ALTER TABLE movies
ALTER COLUMN year_released TYPE SMALLINT;

-- 💬 Simple English: "Change the 'rating' column data type to VARCHAR(20) using explicit conversion."
ALTER TABLE movies
ALTER COLUMN rating TYPE VARCHAR(20)
USING rating::VARCHAR(20);

-- 💬 Simple English: "Change the default value of 'rating' to 'Not Rated'."
ALTER TABLE movies
ALTER COLUMN rating SET DEFAULT 'Not Rated';

-- 💬 Simple English: "Remove the default value constraint from 'rating'."
ALTER TABLE movies
ALTER COLUMN rating DROP DEFAULT;

-- 💬 Simple English: "Make the 'movie_title' column strictly required (NOT NULL)."
ALTER TABLE movies
ALTER COLUMN movie_title SET NOT NULL;

-- 💬 Simple English: "Allow 'rating' to be optional (remove NOT NULL constraint)."
ALTER TABLE movies
ALTER COLUMN rating DROP NOT NULL;


-- ====================================================================
-- 📌 PART 2: CASE EXPRESSIONS (SQL IF-ELSE CONDITIONAL LOGIC)
-- ====================================================================

-- 💬 Simple English: "Clean up and create sample tables for testing CASE statements."
DROP TABLE IF EXISTS viewer_activity CASCADE;
DROP TABLE IF EXISTS platform_movies CASCADE;

CREATE TABLE platform_movies (
    movie_id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    genre VARCHAR(50),
    rating DECIMAL(3, 1),
    release_year INTEGER,
    content_rating VARCHAR(10)
);

INSERT INTO platform_movies (title, genre, rating, release_year, content_rating) VALUES
('Stellar Voyage',     'Sci-Fi',      8.7, 2023, 'PG-13'),
('Dark Alley',         'Thriller',    7.2, 2022, 'R'),
('Laugh Factory',      'Comedy',      6.5, 2024, 'PG'),
('Epic Quest',         'Fantasy',     9.1, 2023, 'PG-13'),
('True Crime Story',   'Documentary', 8.0, 2024, 'R'),
('Action Hero',        'Action',      5.8, 2021, 'PG-13');


-- --------------------------------------------------------------------
-- 2.1 SIMPLE CASE IN SELECT (Assigning labels based on value)
-- --------------------------------------------------------------------

-- 💬 Simple English: "Categorize movies based on rating:
-- IF rating >= 9.0 -> 'Must Watch'
-- IF rating >= 8.0 -> 'Great'
-- IF rating >= 7.0 -> 'Good'
-- OTHERWISE -> 'Average'"
SELECT 
    title,
    rating,
    CASE 
        WHEN rating >= 9.0 THEN 'Must Watch'
        WHEN rating >= 8.0 THEN 'Great'
        WHEN rating >= 7.0 THEN 'Good'
        ELSE 'Average'
    END AS recommendation_label
FROM platform_movies;


-- --------------------------------------------------------------------
-- 2.2 CASE WITH MULTIPLE CONDITIONS (AND / OR)
-- --------------------------------------------------------------------

-- 💬 Simple English: "Tag movies with family suitability and release freshness."
SELECT 
    title,
    rating,
    release_year,
    content_rating,
    CASE 
        WHEN rating >= 8.0 AND content_rating IN ('PG', 'PG-13') THEN 'Family Hit'
        WHEN rating >= 8.0 AND content_rating = 'R' THEN 'Critically Acclaimed Adult Film'
        WHEN rating < 6.5 THEN 'Needs Improvement'
        ELSE 'General Entertainment'
    END AS audience_tag,
    CASE 
        WHEN release_year >= 2024 THEN 'New Release'
        WHEN release_year >= 2022 THEN 'Recent'
        ELSE 'Catalog Classic'
    END AS recency_tag
FROM platform_movies;


-- --------------------------------------------------------------------
-- 2.3 CASE IN ORDER BY CLAUSE (Custom sorting rules)
-- --------------------------------------------------------------------

-- 💬 Simple English: "Sort movies in a custom genre priority: Fantasy first, then Sci-Fi, then Thriller, then others."
SELECT title, genre, rating
FROM platform_movies
ORDER BY 
    CASE 
        WHEN genre = 'Fantasy' THEN 1
        WHEN genre = 'Sci-Fi' THEN 2
        WHEN genre = 'Thriller' THEN 3
        ELSE 4
    END,
    rating DESC;


-- --------------------------------------------------------------------
-- 2.4 CASE IN AGGREGATIONS (Conditional Counting and Totals)
-- --------------------------------------------------------------------

-- 💬 Simple English: "Count how many movies are highly rated (>= 8.0), low rated (< 7.0), or rated 'R' in one summary row."
SELECT 
    COUNT(*) AS total_movies,
    COUNT(CASE WHEN rating >= 8.0 THEN 1 END) AS highly_rated_count,
    COUNT(CASE WHEN rating < 7.0 THEN 1 END) AS low_rated_count,
    COUNT(CASE WHEN content_rating = 'R' THEN 1 END) AS mature_content_count
FROM platform_movies;


-- --------------------------------------------------------------------
-- 2.5 CASE IN UPDATE STATEMENTS
-- --------------------------------------------------------------------

-- 💬 Simple English: "Update content_rating tags: If rating >= 8.0 and R, append ' - Premium'; otherwise leave as is."
UPDATE platform_movies
SET content_rating = 
    CASE 
        WHEN rating >= 8.0 AND content_rating = 'R' THEN 'R-Premium'
        ELSE content_rating
    END;

-- 💬 Simple English: "View the updated records."
SELECT title, rating, content_rating FROM platform_movies;


-- ====================================================================
-- 📌 PART 3: DATABASE RELATIONSHIPS & FOREIGN KEYS
-- ====================================================================


-- --------------------------------------------------------------------
-- 3.1 ONE-TO-ONE (1:1) RELATIONSHIP
-- Example: 1 User has exactly 1 Preferences record.
-- --------------------------------------------------------------------

DROP TABLE IF EXISTS user_preferences CASCADE;
DROP TABLE IF EXISTS stream_users CASCADE;

-- 💬 Simple English: "Parent Table: stores core user accounts."
CREATE TABLE stream_users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

-- 💬 Simple English: "Child Table: stores user settings.
-- Notice 'user_id INT UNIQUE': The UNIQUE constraint enforces 1-to-1 (each user gets only ONE settings row).
-- 'ON DELETE CASCADE' means if a user is deleted, their preferences are automatically erased."
CREATE TABLE user_preferences (
    preference_id SERIAL PRIMARY KEY,
    user_id INT UNIQUE NOT NULL,
    theme VARCHAR(20) DEFAULT 'dark',
    autoplay BOOLEAN DEFAULT TRUE,
    subtitle_language VARCHAR(20) DEFAULT 'English',
    CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES stream_users(user_id) ON DELETE CASCADE
);

-- 💬 Simple English: "Insert user accounts and their corresponding 1:1 preferences."
INSERT INTO stream_users (username, email) VALUES
('cinephile_jane', 'jane@email.com'),
('binge_watcher_bob', 'bob@email.com');

INSERT INTO user_preferences (user_id, theme, autoplay) VALUES
(1, 'dark', TRUE),
(2, 'light', FALSE);

-- 💬 Simple English: "Query user accounts together with their preferences."
SELECT u.user_id, u.username, u.email, p.theme, p.autoplay, p.subtitle_language
FROM stream_users u
JOIN user_preferences p ON u.user_id = p.user_id;


-- --------------------------------------------------------------------
-- 3.2 ONE-TO-MANY (1:N) RELATIONSHIP
-- Example: 1 Director directs Many Movies.
-- --------------------------------------------------------------------

DROP TABLE IF EXISTS director_movies CASCADE;
DROP TABLE IF EXISTS directors CASCADE;

-- 💬 Simple English: "Parent Table: stores movie directors."
CREATE TABLE directors (
    director_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    birth_year INTEGER,
    nationality VARCHAR(50)
);

-- 💬 Simple English: "Child Table: stores movies.
-- 'director_id INT NOT NULL' does NOT have UNIQUE, which allows one director to appear in multiple movie rows!
-- 'ON DELETE RESTRICT' prevents deleting a director if movies linked to them still exist."
CREATE TABLE director_movies (
    movie_id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    director_id INTEGER NOT NULL,
    release_year INTEGER,
    budget DECIMAL(12, 2),
    CONSTRAINT fk_director FOREIGN KEY (director_id) REFERENCES directors(director_id) ON DELETE RESTRICT
);

-- 💬 Simple English: "Insert directors."
INSERT INTO directors (name, birth_year, nationality) VALUES
('Christopher Nolan', 1970, 'British-American'),
('Greta Gerwig',       1983, 'American'),
('Denis Villeneuve',  1967, 'Canadian');

-- 💬 Simple English: "Insert multiple movies linked to their respective directors via director_id."
INSERT INTO director_movies (title, director_id, release_year, budget) VALUES
('Inception',         1, 2010, 160000000.00),
('Interstellar',      1, 2014, 165000000.00),
('Dunkirk',           1, 2017, 100000000.00),
('Lady Bird',         2, 2017,  10000000.00),
('Little Women',      2, 2019,  40000000.00),
('Arrival',           3, 2016,  47000000.00),
('Blade Runner 2049', 3, 2017, 150000000.00);

-- 💬 Simple English: "Count how many movies each director has made."
SELECT 
    d.name AS director_name,
    COUNT(m.movie_id) AS total_movies_directed
FROM directors d
JOIN director_movies m ON d.director_id = m.director_id
GROUP BY d.name
ORDER BY total_movies_directed DESC;


-- --------------------------------------------------------------------
-- 3.3 MANY-TO-MANY (N:M) RELATIONSHIP
-- Example: 1 Actor acts in Many Films, and 1 Film has Many Actors.
-- Solution: We need a Junction / Bridge Table (film_cast).
-- --------------------------------------------------------------------

DROP TABLE IF EXISTS film_cast CASCADE;
DROP TABLE IF EXISTS actors CASCADE;
DROP TABLE IF EXISTS films CASCADE;

-- 💬 Simple English: "First Main Table: Actors."
CREATE TABLE actors (
    actor_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    birth_year INTEGER,
    country VARCHAR(50)
);

-- 💬 Simple English: "Second Main Table: Films."
CREATE TABLE films (
    film_id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    release_year INTEGER,
    genre VARCHAR(50)
);

-- 💬 Simple English: "Junction / Bridge Table: connects actors and films together.
-- UNIQUE(film_id, actor_id) ensures the same actor is not added twice to the exact same film."
CREATE TABLE film_cast (
    cast_id SERIAL PRIMARY KEY,
    film_id INTEGER NOT NULL,
    actor_id INTEGER NOT NULL,
    character_name VARCHAR(100),
    role_type VARCHAR(20) DEFAULT 'supporting',
    CONSTRAINT fk_film FOREIGN KEY (film_id) REFERENCES films(film_id) ON DELETE CASCADE,
    CONSTRAINT fk_actor FOREIGN KEY (actor_id) REFERENCES actors(actor_id) ON DELETE CASCADE,
    UNIQUE(film_id, actor_id)
);

-- 💬 Simple English: "Insert sample actors."
INSERT INTO actors (name, birth_year, country) VALUES
('Leonardo DiCaprio',   1974, 'USA'),
('Marion Cotillard',   1975, 'France'),
('Tom Hardy',          1977, 'UK'),
('Anne Hathaway',      1982, 'USA'),
('Matthew McConaughey',1969, 'USA');

-- 💬 Simple English: "Insert sample films."
INSERT INTO films (title, release_year, genre) VALUES
('Inception',             2010, 'Sci-Fi'),
('The Dark Knight Rises', 2012, 'Action'),
('Interstellar',          2014, 'Sci-Fi'),
('Dunkirk',               2017, 'War');

-- 💬 Simple English: "Link actors to films in the junction table."
INSERT INTO film_cast (film_id, actor_id, character_name, role_type) VALUES
-- Inception has 3 actors
(1, 1, 'Dom Cobb',   'lead'),
(1, 2, 'Mal Cobb',   'supporting'),
(1, 3, 'Eames',      'supporting'),
-- The Dark Knight Rises has 2 actors
(2, 3, 'Bane',       'lead'),
(2, 4, 'Catwoman',   'lead'),
-- Interstellar has 2 actors
(3, 4, 'Brand',      'supporting'),
(3, 5, 'Cooper',     'lead'),
-- Dunkirk has 1 actor
(4, 3, 'Farrier',    'supporting');

-- 💬 Simple English: "Show which actors starred in which films and their character names (3-table JOIN)."
SELECT 
    f.title AS film_title,
    a.name AS actor_name,
    c.character_name,
    c.role_type
FROM films f
JOIN film_cast c ON f.film_id = c.film_id
JOIN actors a ON c.actor_id = a.actor_id
ORDER BY f.title, c.role_type;