use sakila;

-- 1. In the previous lab we wrote a query to find first name, last name, and emails of all the customers who rented 
-- Action movies. Convert the query into a simple stored procedure. Use the following query:

  /* select first_name, last_name, email
  from customer
  join rental on customer.customer_id = rental.customer_id
  join inventory on rental.inventory_id = inventory.inventory_id
  join film on film.film_id = inventory.film_id
  join film_category on film_category.film_id = film.film_id
  join category on category.category_id = film_category.category_id
  where category.name = "Action"
  group by first_name, last_name, email; */

DROP PROCEDURE IF EXISTS customers_action_movies_proc;

delimiter //
CREATE PROCEDURE customers_action_movies_proc()
BEGIN
	SELECT 
    first_name, last_name, email
FROM
    customer
        JOIN
    rental ON customer.customer_id = rental.customer_id
        JOIN
    inventory ON rental.inventory_id = inventory.inventory_id
        JOIN
    film ON film.film_id = inventory.film_id
        JOIN
    film_category ON film_category.film_id = film.film_id
        JOIN
    category ON category.category_id = film_category.category_id
WHERE
    category.name = 'Action'
GROUP BY first_name , last_name , email;
END;
// delimiter ;

-- check
CALL customers_action_movies_proc();

-- 2. Update the stored procedure in a such manner that it can take a string argument for the category name and 
-- return the results for all customers that rented movie of that category/genre. 
-- For eg., it could be action, animation, children, classics, etc.

DROP PROCEDURE IF EXISTS customers_movies_proc;

delimiter //
CREATE PROCEDURE customers_movies_proc(IN category VARCHAR(20))
BEGIN
	SELECT 
    first_name, last_name, email
FROM
    customer
        JOIN
    rental ON customer.customer_id = rental.customer_id
        JOIN
    inventory ON rental.inventory_id = inventory.inventory_id
        JOIN
    film ON film.film_id = inventory.film_id
        JOIN
    film_category ON film_category.film_id = film.film_id
        JOIN
    category ON category.category_id = film_category.category_id
WHERE
    category.name = category
GROUP BY first_name , last_name , email;
END;
// delimiter ;

-- check
CALL customers_movies_proc('action');
CALL customers_movies_proc('animation');
CALL customers_movies_proc('children');
CALL customers_movies_proc('classics');

-- 3. Write a query to check the number of movies released in each movie category. 
-- Convert the query in to a stored procedure to filter only those categories that have movies 
-- released greater than a certain number. Pass that number as an argument in the stored procedure.

-- the query
SELECT 
    name, COUNT(f.film_id) AS n_films
FROM
    film_category f
        JOIN
    category c USING (category_id)
GROUP BY f.category_id;

-- stored procedure
DROP PROCEDURE IF EXISTS category_n_movies_proc;

delimiter //
CREATE PROCEDURE category_n_movies_proc(IN threshold SMALLINT)
BEGIN
SELECT 
    name, COUNT(f.film_id) AS n_films
FROM
    film_category f
        JOIN
    category c USING (category_id)
GROUP BY f.category_id
HAVING n_films > threshold;
END;
// delimiter ;

-- check
CALL category_n_movies_proc(70);




