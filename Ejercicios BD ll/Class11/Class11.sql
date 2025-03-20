

select f.title from film f 
left join inventory i on f.film_id =i.film_id
where i.film_id is null

-- -------------------------------------------

select f.title, i.inventory_id from film f 
inner join inventory i on f.film_id = i.film_id
left join rental r on i.inventory_id = r.inventory_id
where r.rental_id is null

-- -------------------------------------------------

select first_name,last_name, c.store_id, f.title, r.rental_date, r.return_date from customer c 
inner join store s on c.store_id = s.store_id
inner join inventory i on s.store_id = i.store_id
inner join film f on i.film_id = f.film_id
inner join rental r on c.customer_id = r.customer_id
order by c.store_id, c.last_name

-- ---------------------------------------------------------------------------------------------

select s.store_id, sum(p.amount) as total_ventas, concat(a.address,"| |", c.city,"| |",st.first_name," ",st.last_name) as Infromacion from store s
inner join staff st on s.store_id = st.store_id
inner join payment p on st.staff_id = p.staff_id 
inner join address a on s.address_id = a.address_id
inner join city c on a.city_id = c.city_id
group by s.store_id, c.city, st.first_name, st.last_name


-- -----------------------------------------------------------------------------------------------------------------------------------------------------

select count(fa.film_id) as Cantidad_de_Peliculas, a.first_name, a.last_name from actor a 
inner join film_actor fa on fa.actor_id = a.actor_id
group by a.actor_id order by Cantidad_de_Peliculas desc;
