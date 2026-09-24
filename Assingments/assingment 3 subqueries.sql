#1 display all customer details who have made more than 5 payments.
WITH payment_counts AS (
    SELECT customer_id, COUNT(*) AS payment_count
    FROM payment
    GROUP BY customer_id
    HAVING COUNT(*) > 5
)
SELECT c.*, pc.payment_count
FROM customer AS c
JOIN payment_counts AS pc
  ON c.customer_id = pc.customer_id;
  
#2 Find the names of actors who have acted in more than 10 films.
WITH actor_film_counts AS (
    SELECT actor_id, COUNT(*) AS film_count
    FROM film_actor
    GROUP BY actor_id
    HAVING COUNT(*) > 10
)
SELECT a.first_name, a.last_name, afc.film_count
FROM actor AS a
JOIN actor_film_counts AS afc
  ON a.actor_id = afc.actor_id;

#3 Find the names of customers who never made a payment.
SELECT c.customer_id, c.first_name, c.last_name
FROM customer AS c
WHERE NOT EXISTS (
    SELECT 1
    FROM payment AS p
    WHERE p.customer_id = c.customer_id
);


#4 List all films whose rental rate is higher than the average rental rate of all films.
SELECT title, rental_rate
FROM film
WHERE rental_rate > (
    SELECT AVG(rental_rate)
    FROM film
);

#5 List the titles of films that were never rented.
CREATE OR REPLACE VIEW film_rental_counts AS
SELECT f.film_id,
       f.title,
       COUNT(r.rental_id) AS rental_count
FROM film AS f
LEFT JOIN inventory AS i
  ON f.film_id = i.film_id
LEFT JOIN rental AS r
  ON i.inventory_id = r.inventory_id
GROUP BY f.film_id, f.title;

SELECT title
FROM film_rental_counts
WHERE rental_count = 0;

#6 Display the customers who rented films in the same month as customer with ID 5.
CREATE OR REPLACE VIEW customer_rental_months AS
SELECT DISTINCT c.customer_id,
       c.first_name,
       c.last_name,
       DATE_FORMAT(r.rental_date, '%Y-%m') AS rental_month
FROM customer AS c
JOIN rental AS r
  ON c.customer_id = r.customer_id;
  
SELECT customer_id, first_name, last_name, rental_month
FROM customer_rental_months
WHERE rental_month IN (
    SELECT rental_month
    FROM customer_rental_months
    WHERE customer_id = 5
)
AND customer_id <> 5;

#7Find all staff members who handled a payment greater than the average payment amount.
WITH average_payment AS (
    SELECT AVG(amount) AS avg_amount
    FROM payment
)
SELECT DISTINCT s.staff_id, s.first_name, s.last_name
FROM staff AS s
JOIN payment AS p
  ON s.staff_id = p.staff_id
CROSS JOIN average_payment AS ap
WHERE p.amount > ap.avg_amount;

#8Show the title and rental duration of films whose rental duration is greater than the average.
CREATE OR REPLACE VIEW film_durations AS
SELECT title, rental_duration
FROM film;

SELECT title, rental_duration
FROM film_durations
WHERE rental_duration > (
    SELECT AVG(rental_duration)
    FROM film_durations
);

#9 Find all customers who have the same address as customer with ID 1.
CREATE TEMPORARY TABLE customer_one_address AS
SELECT address_id
FROM customer
WHERE customer_id = 1;

SELECT c.customer_id, c.first_name, c.last_name, c.address_id
FROM customer AS c
JOIN customer_one_address AS a
  ON c.address_id = a.address_id
WHERE c.customer_id <> 1;

#10 List all payments that are greater than the average of all payments.   out of 10 questions split them like - 3 queries for sub queires, 3 for ctes , 3 for views  1  for temp table
SELECT payment_id, customer_id, staff_id, amount, payment_date
FROM payment
WHERE amount > (
    SELECT AVG(amount)
    FROM payment
);
