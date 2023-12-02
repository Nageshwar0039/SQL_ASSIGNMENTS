-- SQL COMMANDS
-- ASSIGNMENT 1 

-- 1. Identify the primary keys and foreign keys in maven movies db. Discuss the differences

USE mavenmovies;

-- SYNTAX FOR LISTING NUMBER OF PRIMARY KEYS IN A DATABASE

SELECT 
    TABLE_NAME, COLUMN_NAME, CONSTRAINT_NAME
FROM
    INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE
    CONSTRAINT_NAME = 'PRIMARY'
        AND TABLE_SCHEMA = 'mavenmovies';
        
-- SYNTAX FOR LISTING NUMBER OF FORIEGN KEYS IN A DATABASE

SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    CONSTRAINT_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM
    INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE
    REFERENCED_TABLE_NAME IS NOT NULL
        AND TABLE_SCHEMA = 'mavenmovies';
        
-- DIFFERENCE BETWEEN PRIMARY KEY AND FOREIGN KEY IS -
  -- The primary key and foreign key are both terms used in relational databases to define and establish relationships between tables. Here are the key differences between them:

-- Definition:
-- Primary Key: A primary key is a column or set of columns in a table that uniquely identifies each row in that table. It must have a unique value for each record and cannot contain NULL values.
-- Foreign Key: A foreign key is a column or set of columns in a table that refers to the primary key of another table. It establishes a link between two tables, enforcing referential integrity.

-- Uniqueness:
-- Primary Key: Must be unique for each record in the table.
-- Foreign Key: Does not have to be unique in the referencing table. However, it must correspond to a unique value in the referenced table's primary key.

-- NULL Values:
-- Primary Key: Does not allow NULL values.
-- Foreign Key: Can contain NULL values, indicating that a particular record in the referencing table may not have a corresponding record in the referenced table.

-- Purpose:
-- Primary Key: Identifies each record uniquely within its own table, serving as a unique identifier for records.
-- Foreign Key: Establishes a relationship between tables by referencing the primary key of another table. It ensures referential integrity, meaning that values in the foreign key column must exist in the referenced primary key column.

-- Number of Keys:
-- A table can have only one primary key.
-- A table can have multiple foreign keys, each linking to a different table.

-- Indexes:
-- Primary Key: Automatically creates a unique index on the primary key column(s), which helps in optimizing search operations.
-- Foreign Key: May or may not be indexed automatically, depending on the database system. However, it's common to create indexes on foreign key columns for performance reasons.
      
        
        
-- 2.List all details of actors

SELECT 
    ACTOR.*, FILM_ACTOR.*, FILM.*, ACTOR_AWARD.*
FROM
    ACTOR
        INNER JOIN
    FILM_ACTOR ON ACTOR.ACTOR_ID = FILM_ACTOR.ACTOR_ID
        INNER JOIN
    FILM ON FILM.FILM_ID = FILM_ACTOR.FILM_ID
        INNER JOIN
    ACTOR_AWARD ON ACTOR.ACTOR_ID = ACTOR_AWARD.ACTOR_ID
ORDER BY FILM.TITLE DESC;  

-- 3.List all customer information from DB.
		-- SYNTAX
						-- SELECT columns
                        -- FROM table1
                        -- JOIN table2 ON table1.column1 = table2.column1
						-- JOIN table3 ON table2.column2 = table3.column2
                        -- JOIN table4 ON table3.column3 = table4.column3;

SELECT 
    *
FROM
    mavenmovies.customer;

SELECT 
    customer_id, first_name, last_name, email, phone, address, city, country, postal_code
FROM 
    customer
JOIN 
    address ON customer.address_id = address.address_id
JOIN 
    city ON city.city_id = address.city_id
JOIN 
    country ON country.country_id = city.country_id;


-- 4.List different countries.
       -- SYSNTAX :
                          -- SELECT column,...
                          -- FROM table_name;
						
SELECT 
    *
FROM
    mavenmovies.country;

SELECT 
    country_id, country
FROM
    country;

-- 5.Display all active customers.
        -- SYNTAX :
                        -- SELECT *
                        -- FROM table_name
                        -- WHERE column_name(active) = 1;
    
SELECT 
    *
FROM
    mavenmovies.customer;

SELECT 
    *
FROM
    customer
WHERE
    Active = 1;

-- 6.List of all rental IDs for customer with ID 1.
		-- SYNTAX : 
						 -- SELECT column,....
						 -- FROM table_name
                         -- WHERE column_name = 1;

SELECT 
    *
FROM
    mavenmovies.rental;

SELECT 
    rental_id, customer_id
FROM
    Rental
WHERE
    customer_id = 1;

-- 7.Display all the films whose rental duration is greater than 5 .
        -- SYNTAX :
						-- SELECT column1, column2, ...
                        -- FROM table_name
                        -- WHERE column_name operator value;
        
SELECT 
    *
FROM
    mavenmovies.film;
    
SELECT 
    film_id, title, rental_duration
FROM
    film
WHERE
    rental_duration > 5;

-- 8.List the total number of films whose replacement cost is greater than $15 and less than $20.
		-- SYNTAX :
                         -- SELECT COUNT(*) AS NumberOfFilms
                         -- FROM YourTableName
                         -- WHERE ReplacementCost > 15 AND ReplacementCost < 20;

SELECT 
    *
FROM
    mavenmovies.film;

SELECT 
    COUNT(*) AS number_of_films
FROM
    film
WHERE
    replacement_cost > 15
        AND replacement_cost < 20;

-- 9.Find the number of films whose rental rate is less than $1.
        -- SYNTAX :
                        -- SELECT COUNT(column_name)
                        -- FROM table_name
                        -- WHERE column_name condition;

SELECT 
    *
FROM
    mavenmovies.film;

SELECT 
    COUNT(rental_rate)
FROM
    film
WHERE
    rental_rate <= 1;

-- 10.Display the count of unique first names of actors.
        -- SYNTAX :
						   -- SELECT COUNT(DISTINCT column_name) AS alias_name
						   -- FROM your_table_name;

SELECT 
    *
FROM
    mavenmovies.actor;

SELECT 
    COUNT(DISTINCT first_name) AS UniqueFirstNameCount
FROM
    actor;

-- 11.Display the first 10 records from the customer table .
        -- SYNTAX :
                           -- SELECT column_names,...
                           -- FROM table_name
                           -- LIMIT number_of_rows;

SELECT 
    *
FROM
    mavenmovies.customer;

SELECT 
    *
FROM
    Customer
LIMIT 10;

-- 12.Display the first 3 records from the customer table whose first name starts with ‘b’.
		-- SYNTAX :
                           -- SELECT * 
                           -- FROM table_name
                           -- WHERE column_name LIKE PATTERN ("b%")
                           -- LIMIT number_of_rows;

SELECT 
    *
FROM
    mavenmovies.customer;

SELECT 
    *
FROM
    customer
WHERE
    first_name LIKE 'b%'
LIMIT 3;

-- 13.Display the names of the first 5 movies which are rated as ‘G’.
        -- SYNTAX :
                           -- SELECT * 
                           -- FROM table_name
                           -- WHERE column_name = "condition" 
                           -- LIMIT number_of_rows;
                           
SELECT 
    *
FROM
    mavenmovies.film;

SELECT 
    film_id, title, rating
FROM
    film
WHERE
    rating IN ('PG') LIMIT 5;        

-- 14.Find all customers whose first name starts with "a".
        -- SYNTAX :
                         -- SELECT *
						 -- FROM Cities
                         -- WHERE CityName LIKE PATTERN ("a%") ;

SELECT 
    *
FROM
    mavenmovies.customer;

SELECT 
    first_name
FROM
    customer
WHERE
    first_name LIKE 'a%';

-- 15.Find all customers whose first name ends with "a".
		-- SYNTAX :
						 -- SELECT *
						 -- FROM Cities
                         -- WHERE CityName LIKE PATTERN ("%a");
                         
SELECT 
    *
FROM
    mavenmovies.customer;

SELECT 
    first_name
FROM
    customer
WHERE
    first_name LIKE '%a';

-- 16.Display the list of first 4 cities which start and end with ‘a’ .
        -- SYNTAX :
                         -- SELECT *
						 -- FROM Cities
                         -- WHERE CityName LIKE PATTERN (a%a) 
                         -- LIMIT CONDITION;

SELECT 
    *
FROM
    mavenmovies.city;

SELECT 
    *
FROM
    CitY
WHERE
    City LIKE 'a%a'
LIMIT 4;



-- 17.Find all customers whose first name have "NI" in any position.
        -- SYNTAX :
                        -- SELECT column1, column2, ...
                        -- FROM your_table_name
                        -- WHERE column_name LIKE "%PATTERN%" ;
			
SELECT 
    *
FROM
    mavenmovies.customer;

SELECT 
    first_name
FROM
    customer
WHERE
    first_name LIKE '%ni%';

-- 18.Find all customers whose first name have "r" in the second position .
         -- SYNTAX :
                        -- SELECT column1, column2, ...
                        -- FROM your_table_name
                        -- WHERE column_name LIKE "_PATTERN%" ;

SELECT 
    *
FROM
    mavenmovies.customer;

SELECT 
    first_name
FROM
    customer
WHERE
    first_name LIKE '_r%';


-- 19.Find all customers whose first name starts with "a" and are at least 5 characters in length.
         -- SYNTAX :
                        -- SELECT column1, column2, ...
                        -- FROM your_table_name
                        -- WHERE column_name LIKE PATTERN ("A%") AND LENGTH(column_name) CONDITION;

SELECT 
    *
FROM
    mavenmovies.customer;

SELECT 
    first_name
FROM
    customer
WHERE
    first_name LIKE 'A%'
        AND LENGTH(first_name) >= 5;


-- 20.Find all customers whose first name starts with "a" and ends with "o".
        -- SYNTAX : 
                        -- SELECT column1, column2, ...
                        -- FROM your_table_name
                        -- WHERE column_name LIKE "A%O";

SELECT 
    *
FROM
    mavenmovies.customer;

SELECT 
    first_name
FROM
    customer
WHERE
    first_name LIKE 'A%O';

-- 21.Get the films with pg and pg-13 rating using IN operator.
        -- SYNTAX :
                      -- SELECT column1, column2, ...
                      -- FROM your_table_name
                      -- WHERE column_name IN (value1, value2, ...);

SELECT 
    *
FROM
    mavenmovies.film;

SELECT 
    film_id, title
FROM
    film
WHERE
    rating IN ('PG' , 'PG-13');


-- 22.Get the films with length between 50 to 100 using between operator.
        -- SYNTAX :
                      -- SELECT column1, column2, ...
                      -- FROM your_table_name
					  -- WHERE column_name BETWEEN value1 AND value2;

SELECT 
    *
FROM
    mavenmovies.film;
    
SELECT 
    film_id, title, length
FROM
    film
WHERE
    LENGTH BETWEEN 50 AND 100;




-- 23.Get the top 50 actors using limit operator.
        -- SYNTAX :
                   -- SELECT column1, column2, ...
                   -- FROM your_table_name
                   -- LIMIT number_of_rows;

SELECT 
    *
FROM
    mavenmovies.actor;
    
SELECT 
    actor_id, CONCAT(first_name, ' ', last_name) AS name
FROM
    actor
LIMIT 50;


-- 24.Get the distinct film ids from inventory table.
      -- SYNTAX :
                     -- SELECT DISTINCT column1, column2
                     -- FROM your_table_name;

SELECT 
    *
FROM
    mavenmovies.inventory;
    
SELECT DISTINCT
    film_id
FROM
    inventory;


      