/* 1a. List First Name and LastName from Sakila.Actor */
USE sakila;

SELECT 
    first_name, last_name
FROM
    actor;

/*** 1b.Concat firstname and Last name and display*/
SELECT 
    UPPER(CONCAT(first_name, ' ', last_name)) AS Actor_Name
FROM
    Actor;

/***2a.Find the ID first_Name and last_Name for an actor named Joe********/

SELECT 
    actor_id, first_name, last_name
FROM
    Actor
WHERE
    first_name = 'Joe';

/**********2b.Find all actors whose last name contain the letters `GEN******/
SELECT 
    *
FROM
    Actor
WHERE
    UPPER(last_name) LIKE '%GEN%';

/*************2c.Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order****/
SELECT 
    *
FROM
    Actor
WHERE
    UPPER(last_name) LIKE '%LI%'
ORDER BY last_name , first_name;

/*************2d.Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:*****/

SELECT 
    Country_id, country
FROM
    country
WHERE
    country IN ('Afghanistan' , 'Bangladesh', 'China');

/****** 3a.Add a description column with blob datatype *******/
ALTER table actor ADD COLUMN description blob;

/******* 3b.drop column Description *****/
ALTER TABLE sakila.actor DROP column  description;

/****4a.List the last names of actors, as well as how many actors have that last name.*****/

SELECT DISTINCT
    last_name
FROM
    Actor;

/****** Find how many have same last names****/
SELECT 
    last_name, COUNT(*) AS NumberofOccurence
FROM
    sakila.actor
GROUP BY last_name;

/********4b List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors***/
SELECT 
    last_name, COUNT(*) AS NumberofOccurence
FROM
    sakila.actor
GROUP BY last_name
HAVING COUNT(*) >= 2;

/************************4c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. Write a query to fix the record.*********/

SELECT 
    *
FROM
    sakila.actor
WHERE
    first_name = 'Groucho';
UPDATE sakila.actor 
SET 
    first_name = 'HARPO',
    last_name = 'WILLIAMS'
WHERE
    first_name = 'GROUCHO'
        AND last_name = 'WILLIAMS';

/******4d.In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.*****/

UPDATE actor 
SET 
    first_name = 'GROUCHO'
WHERE
    first_name = 'HARPO';





/********5a.Create table address ****/

CREATE TABLE IF NOT EXISTS address (
  address_id integer NOT NULL AUTO_INCREMENT,
  address varchar(50) NOT NULL,
  address2 varchar(50) DEFAULT NULL,
  district varchar(20) NOT NULL,
  city_id smallint(5) unsigned NOT NULL,
  postal_code varchar(10) DEFAULT NULL,
  phone varchar(20) NOT NULL,
  location blob NOT NULL,
  `last_update` timestamp NOT NULL ,
  PRIMARY KEY (`address_id`),
CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE
) 

 /* 6a.Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`*/
 
SELECT 
    a.first_name,
    a.last_name,
    b.address,
    b.address2,
    b.district,
    b.city_id,
    b.postal_code
FROM
    sakila.staff a
        INNER JOIN
    sakila.address b ON a.address_id = b.address_id;


 /*6b.Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.*/
 SELECT 
    a.staff_id,
    a.first_name,
    a.last_name,
    SUM(b.amount) AS total_amount
FROM
    sakila.staff a
        INNER JOIN
    sakila.payment b ON a.staff_id = b.staff_id  where b.payment_date between '2005-08-01' and '2005-08-31'
GROUP BY a.staff_id , a.first_name , a.last_name;

 /**6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join****/
 
SELECT 
    a.film_id, a.title, COUNT(b.actor_id) AS Number_of_actors
FROM
    sakila.film a
        INNER JOIN
    sakila.film_actor b ON a.film_id = b.film_id
GROUP BY a.film_id , a.title;
 
 
 /***6d.How many copies of the film `Hunchback Impossible` exist in the inventory system?****/
SELECT 
    a.film_id, a.title, COUNT(b.inventory_id) AS NumberofCopies
FROM
    sakila.film a
        INNER JOIN
    sakila.inventory b ON a.film_id = b.film_id
WHERE
    a.title = 'Hunchback Impossible'
GROUP BY a.film_id , a.title;

/************6e  Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:*******************/

SELECT a.customer_id,a.first_name,a.last_name ,sum(b.amount) as total  from 
customer a inner join payment b on a.customer_id=b.customer_id 
group by  a.customer_id , a.first_name,a.last_name
order by a.last_name;

 
 
/****** 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, 
 films starting with the letters `K` and `Q` have also soared in popularity. Use subqueries to display the titles of movies starting with the letters 
 `K` and `Q` whose language is English.***************/
 
 SELECT a.film_id,a.title from sakila.film a where 
 a.language_id in ( SELECT language_id from sakila.language where name='English')
 and a.title like "K%" or a.title like "Q%";
 
/*** 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.***/
SELECT a.actor_id,a.first_name,a.last_name from sakila.actor a
where a.actor_id in ( SELECT actor_id from sakila.film_actor 
where film_id in ( SELECT film_id from sakila.film where title='Alone Trip'));

/******7c. You want to run an email marketing campaign in Canada, for which you will need the names and 
email addresses of all Canadian customers. Use joins to retrieve this information ***/

SELECT a.customer_id,a.first_name,a.last_name,a.email from sakila.customer a 
inner join sakila.address b on a.address_id =b.address_id
inner join  sakila.city c on b.city_id=c.city_id inner join 
sakila.country d on c.country_id=d.country_id 
where d.country='Canada';

/******************7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
Identify all movies categorized as _family_ films.******************/

SELECT a.film_id,a.title from sakila.film a inner join  sakila.film_category b on a.film_id=b.film_id
inner join sakila.category c on b.category_id=c.category_id where 
c.name='Family';

/************* 7e.Display the most frequently rented movies in descending order*******************/
SELECT a.film_id, a.title , count(c.rental_id) as Rental_count from sakila.film a inner join sakila.inventory b on a.film_id=b.film_id
inner join sakila.rental c on b.inventory_id=c.inventory_id group by a.film_id,a.title
order by count(c.rental_id) desc;

/******* 7f.Write a query to display how much business, in dollars, each store brought in.******/
SELECT a.store_id, sum(c.amount) as Sales_Amount from sakila.store a inner join sakila.staff b on a.store_id=b.store_id
inner join sakila.payment c on c.staff_id=b.staff_id
group by a.store_id;

/****************7g.Write a query to display for each store its store ID, city, and country.************/

SELECT 
    a.store_id, c.city, d.country
FROM
    sakila.store a
        INNER JOIN
    sakila.address b ON a.address_id = b.address_id
        INNER JOIN
    sakila.city c ON b.city_id = c.city_id
        INNER JOIN
    sakila.country d ON c.country_id = d.country_id;

/*********** 7h List the top five genres in gross revenue in descending order. (**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)****/
use sakila;
SELECT 
    a.category_id, e.name AS Genre, SUM(d.amount) AS revenue
FROM
    sakila.film_category a
        INNER JOIN
    sakila.category e ON a.category_id = e.category_id
        INNER JOIN
    sakila.inventory b ON a.film_id = b.film_id
        INNER JOIN
    sakila.rental c ON b.inventory_id = c.inventory_id
        INNER JOIN
    sakila.payment d ON c.rental_id = d.rental_id
GROUP BY category_id , e.name
ORDER BY revenue DESC
LIMIT 0 , 5;


/******* 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.**********/

CREATE OR REPLACE VIEW sakila.top_5_genre as 
(
SELECT 
    a.category_id, e.name AS Genre, SUM(d.amount) AS revenue
FROM
    sakila.film_category a
        INNER JOIN
    sakila.category e ON a.category_id = e.category_id
        INNER JOIN
    sakila.inventory b ON a.film_id = b.film_id
        INNER JOIN
    sakila.rental c ON b.inventory_id = c.inventory_id
        INNER JOIN
    sakila.payment d ON c.rental_id = d.rental_id
GROUP BY category_id , e.name
ORDER BY revenue DESC
LIMIT 0 , 5);

/******* 8b.Display the view contents*******************/
select * from sakila.top_5_genre;

/*******************8c. Drop the view ****************/
DROP VIEW sakila.top_5_genre;
