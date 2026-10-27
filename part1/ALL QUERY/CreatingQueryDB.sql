PS D:\Postgres_sql\part1> psql -U postgres -d postgres
psql (18.3)
WARNING: Console code page (437) differs from Windows code page (1252)
         8-bit characters might not work correctly. See psql reference
         page "Notes for Windows users" for details.
Type "help" for help.

postgres=# SELECT current_database();
 current_database
------------------
 postgres
(1 row)


postgres=# SELECT current_user;
 current_user
--------------
 postgres
(1 row)


postgres=# SELECT version();
                                 version
-------------------------------------------------------------------------
 PostgreSQL 18.3 on x86_64-windows, compiled by msvc-19.44.35225, 64-bit
(1 row)


postgres=# \l
                                                             List of databases
    Name     |  Owner   | Encoding | Locale Provider |      Collate       |       Ctype        | Locale | ICU Rules |   Access privileges
-------------+----------+----------+-----------------+--------------------+--------------------+--------+-----------+-----------------------
 companydb   | postgres | UTF8     | libc            | English_India.1252 | English_India.1252 |        |           |
 postgres    | postgres | UTF8     | libc            | English_India.1252 | English_India.1252 |        |           |
 school      | postgres | UTF8     | libc            | English_India.1252 | English_India.1252 |        |           |
 template0   | postgres | UTF8     | libc            | English_India.1252 | English_India.1252 |        |           | =c/postgres          +
             |          |          |                 |                    |                    |        |           | postgres=CTc/postgres
 template1   | postgres | UTF8     | libc            | English_India.1252 | English_India.1252 |        |           | =c/postgres          +
             |          |          |                 |                    |                    |        |           | postgres=CTc/postgres
 tripmate_db | postgres | UTF8     | libc            | English_India.1252 | English_India.1252 |        |           |      
(6 rows)


postgres=# \dt
               List of tables
 Schema |      Name      | Type  |  Owner
--------+----------------+-------+----------
 public | departments    | table | postgres
 public | employees      | table | postgres
 public | tblaccount     | table | postgres
 public | tbltransaction | table | postgres
 public | tbluser        | table | postgres
(5 rows)

PS D:\Postgres_sql> psql -U postgres -d postgres -f "D:\Postgres_sql\part1\01_first_database.sql"
psql:D:/Postgres_sql/part1/01_first_database.sql:1: NOTICE:  database "school" does not exist, skipping
DROP DATABASE
PS D:\Postgres_sql> psql -U postgres -d postgres -f "D:\Postgres_sql\part1\01_first_database.sql"
psql:D:/Postgres_sql/part1/01_first_database.sql:1: NOTICE:  database "school" does not exist, skipping
DROP DATABASE
CREATE DATABASE
PS D:\Postgres_sql> psql -U postgres -d postgres -f "D:\Postgres_sql\part1\02_first_schema.sql"
psql:D:/Postgres_sql/part1/02_first_schema.sql:1: NOTICE:  schema "basics" already exists, skipping
CREATE SCHEMA
psql:D:/Postgres_sql/part1/02_first_schema.sql:3: NOTICE:  extension "pgcrypto" already exists, skipping
CREATE EXTENSION
    schema_name
--------------------
 basics
 information_schema
 pg_catalog
 pg_toast
 public
(5 rows)

