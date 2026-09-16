use sakila;

#1 Identify if there are duplicates in Customer table. Don't use customer id to check the duplicates
SELECT first_name, last_name, email, store_id, active,
       COUNT(*) AS duplicate_count
FROM customer
GROUP BY first_name, last_name, email, store_id, active
HAVING COUNT(*) > 1;

#2 Number of times letter 'a' is repeated in film descriptions
SELECT SUM(
  CHAR_LENGTH(LOWER(description))
  - CHAR_LENGTH(REPLACE(LOWER(description), 'a', ''))
) AS letter_a_count
FROM film;

#3 Number of times each vowel is repeated in film descriptions
SELECT
  SUM(CHAR_LENGTH(LOWER(description)) - CHAR_LENGTH(REPLACE(LOWER(description), 'a', ''))) AS a_count,
  SUM(CHAR_LENGTH(LOWER(description)) - CHAR_LENGTH(REPLACE(LOWER(description), 'e', ''))) AS e_count,
  SUM(CHAR_LENGTH(LOWER(description)) - CHAR_LENGTH(REPLACE(LOWER(description), 'i', ''))) AS i_count,
  SUM(CHAR_LENGTH(LOWER(description)) - CHAR_LENGTH(REPLACE(LOWER(description), 'o', ''))) AS o_count,
  SUM(CHAR_LENGTH(LOWER(description)) - CHAR_LENGTH(REPLACE(LOWER(description), 'u', ''))) AS u_count
FROM film;

#4 Display the payments made by each customer
#	Month wise
#	Year wise
#	Week wise

# Month wise
SELECT c.customer_id, c.first_name, c.last_name,
       DATE_FORMAT(p.payment_date, '%Y-%m') AS payment_month,
       SUM(p.amount) AS total_paid
FROM customer AS c
JOIN payment AS p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, payment_month
ORDER BY c.customer_id, payment_month;

# Year wise
SELECT c.customer_id, c.first_name, c.last_name,
       YEAR(p.payment_date) AS payment_year,
       SUM(p.amount) AS total_paid
FROM customer AS c
JOIN payment AS p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, payment_year
ORDER BY c.customer_id, payment_year;

# Week wise
SELECT c.customer_id, c.first_name, c.last_name,
       YEARWEEK(p.payment_date, 3) AS payment_week,
       SUM(p.amount) AS total_paid
FROM customer AS c
JOIN payment AS p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, payment_week
ORDER BY c.customer_id, payment_week;

#5 Check if any given year is a leap year or not. You need not consider any table from sakila database. Write within the select query with hardcoded date
SELECT YEAR('2024-01-01') AS year_checked,
       CASE
         WHEN MOD(YEAR('2024-01-01'), 400) = 0
           OR (MOD(YEAR('2024-01-01'), 4) = 0
               AND MOD(YEAR('2024-01-01'), 100) <> 0)
         THEN 'Leap Year'
         ELSE 'Not a Leap Year'
       END AS result;

#6 Display number of days remaining in the current year from today.
SELECT DATEDIFF(
  MAKEDATE(YEAR(CURDATE()) + 1, 1),
  CURDATE()
) AS days_remaining;

#7 Display quarter number(Q1,Q2,Q3,Q4) for the payment dates from payment table.
SELECT payment_date,
       CONCAT('Q', QUARTER(payment_date)) AS quarter
FROM payment;