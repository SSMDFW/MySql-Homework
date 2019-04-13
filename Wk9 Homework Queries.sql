
#1a. Display the first and last names of all actors from the table actor.
	select 
	distinct a.first_name, 
	a.last_name 
	from sakila.actor_info as a;

#1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
	select 
	distinct upper(CONCAT(a.first_name,' ',a.last_name)) as ACTOR_NAME 
	from sakila.actor_info as a;

#2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
	select a.actor_id, 
	a.first_name, 
	a.last_name 
	from sakila.actor_info as a 
	where a.first_name = 'Joe';

#2b. Find all actors whose last name contain the letters GEN:
	select a.actor_id, 
	a.first_name, 
	a.last_name 
	from sakila.actor_info as a 
	where a.last_name like '%GEN%';
#2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
	select 
    a.actor_id, 
    a.first_name, 
    a.last_name 
    from sakila.actor_info as a 
    where a.last_name like '%LI%' 
    order by   a.last_name,a.first_name;
#2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
		select 
		c.code, 
		c.Name 
		from world.country as c 
		where c.name in ('Afghanistan', 'Bangladesh', 'China');
#3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
	use sakila;
	ALTER TABLE actor
	ADD COLUMN description BLOB;
#3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
	use sakila;
	ALTER TABLE actor
	drop COLUMN description;
#4a. List the last names of actors, as well as how many actors have that last name.
	select a.last_name, 
	count(a.actor_id) 'ActorCount'  
	from actor a 
	group by a.last_name;
#4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors.
	select a.last_name, 
	count(a.actor_id) 'ActorCount'  
	from actor a 
	group by a.last_name 
	having ActorCount>=2;
#4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
	UPDATE 
		actor
	SET 
		first_name= 'HARPO'
	WHERE 
	   first_name = 'GROUCHO' and last_name='WILLIAMS';
       select a.first_name, a.last_name from actor a where a.last_name='WILLIAMS';
#4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
	UPDATE 
		actor
	SET 
		first_name= 'GROUCHO'
	WHERE 
	   first_name = 'HARPO' and last_name='WILLIAMS';
       select a.first_name, a.last_name from actor a where a.last_name='WILLIAMS';
#5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
	describe address;
#6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
	Select 
    s.first_name, 
    s.last_name, 
    a.address,
    a.address2,
    a.postal_code, a.location
    from staff s 
    inner join address a on s.address_id=a.address_id;
#6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
	Select 
    s.first_name, 
    s.last_name, 
    sum(p.amount)'Total'
    from payment p
    inner join staff s on s.staff_id=p.staff_id
    where cast(p.payment_date as Date) between '2005-08-01' and '2005-08-31'   
    group by s.first_name,s.last_name; 
#6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
	select f.title,
	count(a.actor_id) 'ActorCount'  
	from film f 
    inner join film_actor a on f.film_id = a.film_id
	group by f.title;
#6d. How many copies of the film Hunchback Impossible exist in the inventory system?
	select
    f.title,
    count(i.inventory_id)'InvCnt'
    from inventory i 
    inner join film f on i.film_id=f.film_id
    where f.title = 'Hunchback Impossible'
    group by f.title;
#6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
	Select 
    s.first_name, 
    s.last_name, 
    sum(p.amount)'Total'
    from payment p
    inner join customer s on s.customer_id=p.customer_id
    group by s.first_name,s.last_name
    order by s.last_name, s.first_name; 
#7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
	use sakila;
	select 
	f.title
	from film f
	where (f.title like 'K%' or  f.title like 'Q%')
	and f.language_id = (select l.language_id from language as l where name='English');

#7b. Use subqueries to display all actors who appear in the film Alone Trip.
    select 
	a.first_name, a.last_name
	from actor a 
    inner join film_actor fa on a.actor_id = fa.actor_id
	where 
	fa.film_id = (select f.film_id from film as f where f.title='Alone Trip')
    order by a.last_name, a.first_name;
#7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
	select
	c.first_name,
	c.last_name,
	c.email,
	u.country
	from customer c 
	inner join address a on c.address_id=a.address_id
	inner join city ct on a.city_id =ct.city_id
	inner join country u on ct.country_id=u.country_id
	where u.country ='Canada';
#7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
	select
	f.title
	,f.rating
	,ct.name category
	from film f 
	inner join film_category c on f.film_id=c.film_id
	inner join category ct on c.category_id = ct.category_id
	where ct.name ='Family';

#7e. Display the most frequently rented movies in descending order.
		select
		f.title,
		count(r.rental_id)Rentals
		from rental r 
		inner join inventory i on r.inventory_id=i.inventory_id
		inner join film f on f.film_id = i.film_id
		group by f.title order by Rentals Desc;
#7f. Write a query to display how much business, in dollars, each store brought in.
		select
		s.store_id,
        sum(p.amount)'total'
		from rental r 
		inner join payment p on r.rental_id =p.rental_id
		inner join inventory i on r.inventory_id=i.inventory_id
        inner join store s on i.store_id = s.store_id
		group by s.store_id, a.location order by Total Desc;
#7g. Write a query to display for each store its store ID, city, and country.
		select
		s.store_id, c.city, u.country 
        from  store s 
        inner join address a on s.address_id = a.address_id
        INNER join city c on a.city_id = c.city_id
        inner join country u on c.country_id=u.country_id;
#7h. List the top five genres in gross revenue in descending order. 
	#(Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
		select
		c.name category,
        sum(p.amount)'total'
		from rental r 
		inner join payment p on r.rental_id =p.rental_id
		inner join inventory i on r.inventory_id=i.inventory_id
  --      inner join  film f  on  i.film_id = f.film_id
        inner join film_category fc on i.film_id=fc.film_id
        inner join category c on c.category_id = fc.category_id
		group by c.name order by total desc LIMIT 5;
#8a. In your new role as an executive, you would like to have an easy way of 
#viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
	CREATE VIEW vw_Top_5_Genres AS 
    		select
		c.name category,
        sum(p.amount)'total'
		from rental r 
		inner join payment p on r.rental_id =p.rental_id
		inner join inventory i on r.inventory_id=i.inventory_id
  --      inner join  film f  on  i.film_id = f.film_id
        inner join film_category fc on i.film_id=fc.film_id
        inner join category c on c.category_id = fc.category_id
		group by c.name order by total desc LIMIT 5;
#8b. How would you display the view that you created in 8a?
		select * from vw_Top_5_Genres;
#8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
		drop view vw_Top_5_Genres;



