-- ASSIGNMENT 3
-- WINDOW FUNCTIONS
-- PRACTICE QUESTIONS

-- 1. Rank the customers based on the total amount they've spent on rentals.
SELECT * FROM mavenmovies.payment;

SELECT customer_id, sum(amount) AS total_amount,
RANK() OVER(order by sum(amount) desc ) AS customer_rank 
FROM payment
GROUP BY customer_id 
ORDER BY sum(amount) desc;
 
 -- 2. Calculate the cumulative revenue generated by each film over time.
 WITH CumulativeFilmRevenue AS (
    SELECT
        f.film_id,
        p.payment_date,
        SUM(p.amount) OVER (PARTITION BY f.film_id ORDER BY p.payment_date) AS cumulative_revenue
    FROM
        film f
    JOIN
        inventory i ON f.film_id = i.film_id
    JOIN
        rental r ON i.inventory_id = r.inventory_id
    JOIN
        payment p ON r.rental_id = p.rental_id
)

SELECT
    cfr.film_id,
    cfr.payment_date,
    cfr.cumulative_revenue
FROM
    CumulativeFilmRevenue cfr
ORDER BY
    cfr.film_id, cfr.payment_date;

 -- 3. Determine the average rental duration for each film, considering films with similar lengths.
SELECT * FROM mavenmovies.film;

select film_id, rental_duration,
avg(rental_duration) over(partition by rental_duration) as avg_rental_duration
from film
order by film_id;

-- 4. Identify the top 3 films in each category based on their rental counts.
SELECT * FROM mavenmovies.film;

select f.film_id, 
count(rental_rate) over(partition by rental_rate) as count_rentalrate 
from film f 
join film_category on film_category.film_id= f.film_id
join category on category.category_id = film_category.category_id;

-- 5. Calculate the difference in rental counts between each customer's total rentals and the average rentals
--    across all customers.
SELECT * FROM mavenmovies.payment;

WITH CustomerRentals AS (
    SELECT
        customer_id,
        COUNT(rental_id) AS total_rentals,
        AVG(COUNT(rental_id)) OVER () AS avg_rentals_across_customers
    FROM
        payment
    GROUP BY
        customer_id
)

SELECT
    customer_id,
    total_rentals, avg_rentals_across_customers,
    total_rentals - avg_rentals_across_customers AS rental_count_difference
FROM
    CustomerRentals;
    
--  6. Find the monthly revenue trend for the entire rental store over time.
WITH MonthlyRevenue AS (
    SELECT
        YEAR(payment_date) AS year,
        MONTH(payment_date) AS month,
        store_id,
        SUM(amount) AS monthly_revenue,
        RANK() OVER (PARTITION BY YEAR(payment_date), MONTH(payment_date) ORDER BY SUM(amount) DESC) AS monthly_rank
    FROM
        payment p
    JOIN
        rental r ON p.rental_id = r.rental_id
    JOIN
        inventory i ON r.inventory_id = i.inventory_id
    GROUP BY
        YEAR(payment_date),
        MONTH(payment_date),
        store_id
)

SELECT
    year,
    month,
    store_id,
    monthly_revenue
FROM
    MonthlyRevenue
WHERE
    monthly_rank = 1
ORDER BY
    year, month, store_id;

-- 7. Identify the customers whose total spending on rentals falls within the top 20% of all customers.
SELECT
    customer_id,
    MAX(total_spending) AS total_spending
FROM (
    SELECT
        customer_id,
        SUM(amount) AS total_spending,
        PERCENT_RANK() OVER (ORDER BY SUM(amount) DESC) AS spending_percent_rank
    FROM
        payment
    GROUP BY
        customer_id
) AS subquery
WHERE
    spending_percent_rank <= 0.2
GROUP BY
    customer_id;

-- 8. Calculate the running total of rentals per category, ordered by rental count.
SELECT
    category_id,
    COUNT(rental_id) AS rental_count,
    SUM(COUNT(rental_id)) OVER (ORDER BY COUNT(rental_id) DESC) AS running_total
FROM
    film_category fc
JOIN
    inventory i ON fc.film_id = i.film_id
JOIN
    rental r ON i.inventory_id = r.inventory_id
GROUP BY
    category_id
ORDER BY
    rental_count DESC;

-- 9. Find the films that have been rented less than the average rental count for their respective categories.
WITH CategoryRentalStats AS (
    SELECT
        fc.film_id,
        fc.category_id,
        COUNT(r.rental_id) AS rental_count,
        AVG(COUNT(r.rental_id)) OVER (PARTITION BY fc.category_id) AS avg_rental_count
    FROM
        film_category fc
    JOIN
        inventory i ON fc.film_id = i.film_id
    JOIN
        rental r ON i.inventory_id = r.inventory_id
    GROUP BY
        fc.film_id, fc.category_id
)

SELECT
    crs.film_id,
    crs.category_id,
    crs.rental_count,
    crs.avg_rental_count
FROM
    CategoryRentalStats crs
WHERE
    crs.rental_count < crs.avg_rental_count;

-- 10. Identify the top 5 months with the highest revenue and display the revenue generated in each month.
WITH MonthlyRevenue AS (
    SELECT
        YEAR(payment_date) AS year,
        MONTH(payment_date) AS month,
        SUM(amount) AS monthly_revenue,
        ROW_NUMBER() OVER (ORDER BY SUM(amount) DESC) AS row_num
    FROM
        payment
    GROUP BY
        YEAR(payment_date),
        MONTH(payment_date)
)

SELECT
    year,
    month,
    monthly_revenue
FROM
    MonthlyRevenue
WHERE
    row_num <= 5
ORDER BY
    row_num;
