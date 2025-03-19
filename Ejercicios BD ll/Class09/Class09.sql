select ci.city, ci.country_id,
(select country from country co where co.country_id = ci.country_id ) as country,
(select count(*) from city ci2 where ci2.country_id = ci.country_id )
from city ci group by ci.country_id order by country,country_id

-- -------------------------------------------------------------------------------

select 
(select co.country from country co where c.country_id = co.country_id ) as "Country",
(select count(*) from city c1 where c1.country_id = c.country_id) as cuenta
from city c group by c.country_id having cuenta > 10 order by cuenta desc; 

-- --------------------------------------------------------------------------------

select 
(select first_name from customer c where p.customer_id  = c.customer_id )as Nombre,
(select last_name from customer c2 where p.customer_id  = c2.customer_id ) as Apellido,
(select address from address a where a.address_id = 
	(select address_id from customer c3 where c3.customer_id  = p.customer_id group by a.address_id)) as address,
(select count(*) from rental r where r.customer_id = p.customer_id )as rented,
(select sum(amount) from payment p2 where p.customer_id = p2.customer_id) as total_payed
from payment p group by customer_id

-- ------------------------------------------------------------------------------------------------------------------

select avg(f.`length`), 
(select name from category c where c.category_id = (select category_id from film_category fc where fc.film_id = f.film_id )) as categoria
from film f group by categoria order by avg(f.`length`) desc

-- ----------------------------------------------------------------------------------------------------------------------------------------

select f.rating,
(select count(*) from payment p where p.rental_id in
	(select r.rental_id from rental r where r.inventory_id in
		(select i.inventory_id from inventory i where i.film_id in 
			(select f2.film_id from film f2 where f2.rating = f.rating)))) as cantidad
from film f group by f.rating order by cantidad desc










