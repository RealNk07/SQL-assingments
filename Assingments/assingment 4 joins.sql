#1 List all customers along with the films they have rented.
SELECT c.customer_id,
       c.first_name,
       c.last_name,
       f.title
FROM customer AS c
JOIN rental AS r
  ON c.customer_id = r.customer_id
JOIN inventory AS i
  ON r.inventory_id = i.inventory_id
JOIN film AS f
  ON i.film_id = f.film_id
ORDER BY c.last_name, c.first_name, f.title;

#2 List all customers and show their rental count, including those who haven't rented any films.
SELECT c.customer_id,
       c.first_name,
       c.last_name,
       COUNT(r.rental_id) AS rental_count
FROM customer AS c
LEFT JOIN rental AS r
  ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY rental_count DESC;

#3 Show all films along with their category. Include films that don't have a category assigned.
SELECT f.film_id,
       f.title,
       c.name AS category
FROM film AS f
LEFT JOIN film_category AS fc
  ON f.film_id = fc.film_id
LEFT JOIN category AS c
  ON fc.category_id = c.category_id
ORDER BY f.title;

#4 Show all customers and staff emails from both customer and staff tables using a full outer join (simulate using LEFT + RIGHT + UNION).
SELECT c.store_id,
       c.email AS customer_email,
       s.email AS staff_email
FROM customer AS c
LEFT JOIN staff AS s
  ON c.store_id = s.store_id

UNION

SELECT s.store_id,
       c.email AS customer_email,
       s.email AS staff_email
FROM customer AS c
RIGHT JOIN staff AS s
  ON c.store_id = s.store_id;
  
#5 Find all actors who acted in the film "ACADEMY DINOSAUR".
SELECT a.actor_id,
       a.first_name,
       a.last_name
FROM actor AS a
JOIN film_actor AS fa
  ON a.actor_id = fa.actor_id
JOIN film AS f
  ON fa.film_id = f.film_id
WHERE f.title = 'ACADEMY DINOSAUR';

#6 List all stores and the total number of staff members working in each store, even if a store has no staff.
SELECT s.store_id,
       COUNT(st.staff_id) AS staff_count
FROM store AS s
LEFT JOIN staff AS st
  ON s.store_id = st.store_id
GROUP BY s.store_id;

#7 List the customers who have rented films more than 5 times. Include their name and total rental count. Solve this using joins
SELECT c.customer_id,
       c.first_name,
       c.last_name,
       COUNT(r.rental_id) AS rental_count
FROM customer AS c
JOIN rental AS r
  ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(r.rental_id) > 5
ORDER BY rental_count DESC;
