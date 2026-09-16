use sakila;
#1 Joins 
# Inner join
SELECT c.first_name, c.last_name, p.amount
FROM customer AS c
INNER JOIN payment AS p
  ON c.customer_id = p.customer_id;

#Left join
SELECT c.first_name, c.last_name, p.amount
FROM customer AS c
LEFT JOIN payment AS p
  ON c.customer_id = p.customer_id;
  
# Right join
SELECT c.first_name, c.last_name,p.amount
FROM customer AS c
RIGHT JOIN payment AS p
	ON c.customer_id = p.customer_id;

# Self Join
SELECT c1.first_name AS customer_one,
       c2.first_name AS customer_two,
       c1.store_id
FROM customer AS c1
JOIN customer AS c2
  ON c1.store_id = c2.store_id
 AND c1.customer_id < c2.customer_id
LIMIT 20;

#Cross Join
SELECT c.first_name, c.last_name, s.store_id
FROM customer AS c
CROSS JOIN store AS s;

# Subqueries
# Filteration in Where

SELECT customer_id, first_name, last_name
FROM customer
WHERE customer_id IN (
    SELECT customer_id
    FROM payment
    WHERE amount > 10
);

# Derived column
SELECT c.customer_id,
       c.first_name,
       c.last_name,
       (
           SELECT SUM(p.amount)
           FROM payment AS p
           WHERE p.customer_id = c.customer_id
       ) AS total_paid
FROM customer AS c;

# Derived table
SELECT customer_id, total_paid
FROM (
    SELECT customer_id,
           SUM(amount) AS total_paid
    FROM payment
    GROUP BY customer_id
) AS customer_totals
WHERE total_paid > 100;

#Aggregate comparion
SELECT customer_id,
       SUM(amount) AS total_paid
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > (
    SELECT AVG(customer_total)
    FROM (
        SELECT SUM(amount) AS customer_total
        FROM payment
        GROUP BY customer_id
    ) AS all_customer_totals
);
 #CTE
 WITH customer_totals AS (
    SELECT c.customer_id,
           c.first_name,
           c.last_name,
           SUM(p.amount) AS total_paid
    FROM customer AS c
    JOIN payment AS p
      ON c.customer_id = p.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name
)
SELECT customer_id, first_name, last_name, total_paid
FROM customer_totals
WHERE total_paid > (
    SELECT AVG(total_paid)
    FROM customer_totals
)
ORDER BY total_paid DESC;

# Temp Table
CREATE TEMPORARY TABLE customer_totals_temp AS
SELECT c.customer_id,
       c.first_name,
       c.last_name,
       SUM(p.amount) AS total_paid
FROM customer AS c
JOIN payment AS p
  ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

# Reusing the temp table
SELECT customer_id, first_name, last_name, total_paid
FROM customer_totals_temp
WHERE total_paid > (
    SELECT AVG(total_paid)
    FROM customer_totals_temp
)
ORDER BY total_paid DESC;

#View
CREATE OR REPLACE VIEW customer_payment_totals AS
SELECT c.customer_id,
       c.first_name,
       c.last_name,
       SUM(p.amount) AS total_paid
FROM customer AS c
JOIN payment AS p
  ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

#Resuing the same view
SELECT customer_id, first_name, last_name, total_paid
FROM customer_payment_totals
WHERE total_paid > (
    SELECT AVG(total_paid)
    FROM customer_payment_totals
)
ORDER BY total_paid DESC;