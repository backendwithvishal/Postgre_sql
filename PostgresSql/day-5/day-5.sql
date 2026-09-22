-- ====================================================================
-- 🐘 POSTGRESQL DAY 5: FUNCTIONS & STORED PROCEDURES (PL/pgSQL)
-- ====================================================================
-- This file demonstrates how to write server-side logic in PostgreSQL:
-- 1. User Defined Functions (UDF) - return values, used in SELECT
-- 2. Stored Procedures - perform actions, run transactions, called with CALL
-- Every query and routine has a "Simple English Explanation" for beginners.
-- ====================================================================


-- ====================================================================
-- 📌 SECTION 1: SAMPLE TABLE SETUP
-- ====================================================================

-- 💬 Simple English: "Clean up previous table so we start fresh."
DROP TABLE IF EXISTS tech_youtubers CASCADE;

-- 💬 Simple English: "Create table to track tech YouTubers, their channel names, tech stack, subscriber count in millions, and active status."
CREATE TABLE tech_youtubers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    channel VARCHAR(100) NOT NULL,
    tech VARCHAR(50) NOT NULL,
    subscribers_millions NUMERIC(4,2) CHECK (subscribers_millions >= 0),
    active BOOLEAN DEFAULT TRUE
);

-- 💬 Simple English: "Insert initial sample data."
INSERT INTO tech_youtubers (name, channel, tech, subscribers_millions)
VALUES
('Hitesh Choudhary', 'Chai aur Code',       'JavaScript',  1.60),
('Anuj Bhaiya',      'Coding Shuttle',      'DSA',         0.85),
('Akshay Saini',     'Namaste JavaScript',  'JavaScript',  1.20),
('CodeWithHarry',    'CodeWithHarry',       'Full Stack',  5.80),
('Kunal Kushwaha',   'Kunal Kushwaha',      'DSA',         1.00);

-- 💬 Simple English: "View the initial table records."
SELECT * FROM tech_youtubers;


-- ====================================================================
-- 📌 SECTION 2: USER DEFINED FUNCTIONS (UDF)
-- ====================================================================
-- 💡 Rule of Thumb: Functions MUST return a value or table.
-- You run them using SELECT.


-- --------------------------------------------------------------------
-- FUNCTION 1: SCALAR FUNCTION (Returns a single number)
-- --------------------------------------------------------------------

-- 💬 Simple English: "Create a function called 'total_youtubers' that counts and returns the total number of channels."
CREATE OR REPLACE FUNCTION total_youtubers()
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
BEGIN
    -- Return the total row count from tech_youtubers table
    RETURN (SELECT COUNT(*) FROM tech_youtubers);
END;
$$;

-- 💬 Simple English: "How to call/execute the function:"
SELECT total_youtubers() AS total_channel_count;


-- --------------------------------------------------------------------
-- FUNCTION 2: TABLE-RETURNING FUNCTION (Returns multiple rows & columns)
-- --------------------------------------------------------------------

-- 💬 Simple English: "Create a function that takes a technology name (e.g., 'JavaScript') and returns all channels teaching that tech."
CREATE OR REPLACE FUNCTION get_youtubers_by_tech(p_tech VARCHAR)
RETURNS TABLE(creator_name VARCHAR, channel_name VARCHAR, subs NUMERIC)
LANGUAGE plpgsql
AS $$
BEGIN
    -- RETURN QUERY streams rows matching the WHERE filter
    RETURN QUERY
    SELECT name, channel, subscribers_millions
    FROM tech_youtubers
    WHERE tech = p_tech;
END;
$$;

-- 💬 Simple English: "How to call a table-returning function:"
SELECT * FROM get_youtubers_by_tech('JavaScript');


-- --------------------------------------------------------------------
-- FUNCTION 3: CONDITIONAL LOGIC FUNCTION (Using IF ... ELSE)
-- --------------------------------------------------------------------

-- 💬 Simple English: "Create a function that checks subscriber count:
-- If subscribers >= 1 million -> return 'Big Channel'
-- Otherwise -> return 'Growing Channel'"
CREATE OR REPLACE FUNCTION channel_category(subs NUMERIC)
RETURNS VARCHAR
LANGUAGE plpgsql
AS $$
BEGIN
    IF subs >= 1.0 THEN
        RETURN 'Big Channel';
    ELSE
        RETURN 'Growing Channel';
    END IF;
END;
$$;

-- 💬 Simple English: "Use our custom function inside a SELECT query just like a built-in SQL function:"
SELECT 
    name, 
    channel, 
    subscribers_millions, 
    channel_category(subscribers_millions) AS channel_tier
FROM tech_youtubers;


-- --------------------------------------------------------------------
-- FUNCTION 4: TOTAL SUBSCRIBERS CALCULATION (SUM Function)
-- --------------------------------------------------------------------

-- 💬 Simple English: "Create a function that calculates the combined total subscribers of all creators."
CREATE OR REPLACE FUNCTION total_subscribers()
RETURNS NUMERIC
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN (
        SELECT COALESCE(SUM(subscribers_millions), 0)
        FROM tech_youtubers
    );
END;
$$;

-- 💬 Simple English: "Execute the total subscribers function:"
SELECT total_subscribers() AS grand_total_subs_in_millions;


-- --------------------------------------------------------------------
-- FUNCTION 5: GET ACTIVE CHANNELS ONLY
-- --------------------------------------------------------------------

-- 💬 Simple English: "Create a function to return only active tech channels."
CREATE OR REPLACE FUNCTION get_active_channels()
RETURNS TABLE (
    creator_name VARCHAR,
    channel_name VARCHAR,
    technology VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT name, channel, tech
    FROM tech_youtubers
    WHERE active = TRUE;
END;
$$;

-- 💬 Simple English: "View all active channels:"
SELECT * FROM get_active_channels();


-- ====================================================================
-- 📌 SECTION 3: STORED PROCEDURES
-- ====================================================================
-- 💡 Rule of Thumb: Procedures DO NOT need to return a value.
-- They PERFORM ACTIONS (INSERT, UPDATE, DELETE, Transactions).
-- You run them using the CALL command.


-- --------------------------------------------------------------------
-- PROCEDURE 1: INSERT A NEW RECORD
-- --------------------------------------------------------------------

-- 💬 Simple English: "Create a stored procedure that adds a new creator into our database."
CREATE OR REPLACE PROCEDURE add_youtuber(
    p_name VARCHAR,
    p_channel VARCHAR,
    p_tech VARCHAR,
    p_subs NUMERIC
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO tech_youtubers (name, channel, tech, subscribers_millions)
    VALUES (p_name, p_channel, p_tech, p_subs);
END;
$$;

-- 💬 Simple English: "Call the procedure to insert Tanay Pratap's channel:"
CALL add_youtuber('Tanay Pratap', 'Tanay Pratap', 'Web Development', 0.50);

-- 💬 Simple English: "Verify that the new YouTuber was added:"
SELECT * FROM tech_youtubers WHERE channel = 'Tanay Pratap';


-- --------------------------------------------------------------------
-- PROCEDURE 2: UPDATE A CHANNEL'S STATUS (DEACTIVATE)
-- --------------------------------------------------------------------

-- 💬 Simple English: "Create a procedure that marks a specific channel as inactive."
CREATE OR REPLACE PROCEDURE deactivate_youtuber(p_channel VARCHAR)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE tech_youtubers
    SET active = FALSE
    WHERE channel = p_channel;
END;
$$;

-- 💬 Simple English: "Call procedure to deactivate 'Coding Shuttle':"
CALL deactivate_youtuber('Coding Shuttle');

-- 💬 Simple English: "Check the status of 'Coding Shuttle' to verify active is now false:"
SELECT * FROM tech_youtubers WHERE channel = 'Coding Shuttle';


-- --------------------------------------------------------------------
-- PROCEDURE 3: UPDATE SUBSCRIBER COUNT
-- --------------------------------------------------------------------

-- 💬 Simple English: "Create a procedure to update subscriber count for any channel."
CREATE OR REPLACE PROCEDURE update_subscribers(
    p_channel VARCHAR,
    p_new_subs NUMERIC
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE tech_youtubers
    SET subscribers_millions = p_new_subs
    WHERE channel = p_channel;
END;
$$;

-- 💬 Simple English: "Update 'Chai aur Code' subscriber count to 1.75 million:"
CALL update_subscribers('Chai aur Code', 1.75);

-- 💬 Simple English: "Check the updated subscriber count:"
SELECT * FROM tech_youtubers WHERE channel = 'Chai aur Code';


-- --------------------------------------------------------------------
-- PROCEDURE 4: SAFE DELETE WITH ERROR / EXCEPTION HANDLING
-- --------------------------------------------------------------------

-- 💬 Simple English: "Create a procedure that safely deletes a channel. If channel is not found, throw an error."
CREATE OR REPLACE PROCEDURE safe_delete(p_channel VARCHAR)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM tech_youtubers WHERE channel = p_channel;

    -- If no row was found and deleted, raise an exception error
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Channel "%" not found in the database!', p_channel;
    END IF;
END;
$$;

-- 💬 Simple English: "Delete Tanay Pratap safely:"
CALL safe_delete('Tanay Pratap');


-- --------------------------------------------------------------------
-- PROCEDURE 5: BATCH UPDATE (Deactivate all DSA channels)
-- --------------------------------------------------------------------

-- 💬 Simple English: "Create a procedure to deactivate all DSA channels in one step."
CREATE OR REPLACE PROCEDURE deactivate_dsa_channels()
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE tech_youtubers
    SET active = FALSE
    WHERE tech = 'DSA';
END;
$$;

-- 💬 Simple English: "Execute the batch deactivation:"
CALL deactivate_dsa_channels();

-- 💬 Simple English: "Final check of the table:"
SELECT * FROM tech_youtubers ORDER BY id ASC;


-- ====================================================================
-- 📌 SECTION 4: CLEANUP / DROPPING FUNCTIONS & PROCEDURES
-- ====================================================================

-- 💬 Simple English: "How to drop functions and procedures when they are no longer needed:"
-- DROP FUNCTION IF EXISTS total_youtubers();
-- DROP FUNCTION IF EXISTS get_youtubers_by_tech(VARCHAR);
-- DROP FUNCTION IF EXISTS channel_category(NUMERIC);
-- DROP PROCEDURE IF EXISTS add_youtuber(VARCHAR, VARCHAR, VARCHAR, NUMERIC);
-- DROP PROCEDURE IF EXISTS deactivate_youtuber(VARCHAR);
