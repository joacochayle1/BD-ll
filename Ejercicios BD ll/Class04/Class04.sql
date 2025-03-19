select title, special_features, rating from film where rating = 'PG-13';
-- --------------------------------------------------------------------- 
select length from film group by length;
-- ------------------------------------------------------------------------------------------
select title, rental_rate, replacement_cost from film where film.replacement_cost between 20.00 and 24.00
order by replacement_cost desc;

-- --------------------------------------------------------- 

select title, rating, c.name, special_features from film f
inner join film_category fc on f.film_id = fc.film_id 
inner join category c on fc.category_id = c.category_id 
where f.special_features like 'Behind the Scenes';
-- ------------------------------------------------------------
select first_name, last_name from actor a
inner join film_actor fa on a.actor_id = fa.actor_id 
inner join film f on f.film_id = fa.film_id 
where title = 'ZOOLANDER FICTION';
-- -----------------------------------------------------------
select a.address, c.city, co.country from store s
inner join address a on s.address_id = a.address_id 
inner join city c on a.city_id = c.city_id 
inner join country co on c.country_id = co.country_id 
where s.store_id = 1;
-- ----------------------------------------------------------------
select title, rating from film
order by rating;
-- ------------------------------------------------------------
select f.title, st.first_name, st.last_name from store s
inner join inventory i on s.store_id = i.store_id
inner join film f on i.film_id = f.film_id
inner join staff st on s.manager_staff_id = st.staff_id 
where s.store_id = 2








