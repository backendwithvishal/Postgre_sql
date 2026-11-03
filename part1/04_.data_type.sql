CREATE TABLE basics.products_basic (

    -- STRING - max length of 100 chacterars
    name VARCHAR(100) NOT NULL,
    
    -- STRING - store texts with max 16MB of data 
    description TEXT,

   -- NUMERIC - store whole numbers with approx 2 billion values  
    stock INTEGER DEFAULT 0,

   --  Store larger whole number than INTEGER
    total_views BIGINT DEFAULT 0,

    -- Exect decimal values
    -- 10 means total digits
    -- 2 means digits after the decimal points, 99999999999.99 
    price NUMERIC(10, 2)
)