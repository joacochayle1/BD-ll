-- 1) ----------------------------------------------------------------------------------------


insert into customer (store_id,first_name,last_name,email, address_id,active,create_date) 
values (1,'Jose Luí','Domingueh García','Josepro@gmail.com',
		(select a.address_id from address a inner join city ci on a.city_id  = ci.city_id 
		inner join country co on ci.country_id = co.country_id 
		where co.country = 'United States'
		order by a.address_id desc
		limit 1),
		1,
		now()

);


-- 2) -----------------------------------------------------------------------------------------


insert into rental (rental_date, inventory_id, customer_id, return_date, staff_id)
values (
    now(),
    (
        select max(i.inventory_id)
        from inventory i
        inner join film f on f.film_id = i.film_id
        where f.title = 'academy dinosaur'
    ),
    1, 
    date_add(now(), interval 3 day),
    (
        select staff_id
        from staff
        where store_id = 2
        limit 1
    )
);


-- 3) ----------------------------------------------------------------------------------------


update film
   set release_year = 2001
 where rating = 'G';

update film
   set release_year = 2002
 where rating = 'PG';

update film
   set release_year = 2003
 where rating = 'PG-13';

update film
   set release_year = 2004
 where rating = 'R';

update film
   set release_year = 2005
 where rating = 'NC-17';

-- 4) ------------------------------------------------------------------------------------------

select rental_id
  from rental
 where return_date is null
 order by rental_date desc
 limit 1;

update rental
   set return_date = now()
 where rental_id = 16053;


select * 
  from rental
 where rental_id = 16053;


-- 5) -----------------------------------------------------------------------------------------
delete from film
 where film_id = 10;

delete p
  from payment p
  join rental r on p.rental_id = r.rental_id
  join inventory i on r.inventory_id = i.inventory_id
 where i.film_id = 10;

delete r
  from rental r
  join inventory i on r.inventory_id = i.inventory_id
 where i.film_id = 10;

delete from inventory
 where film_id = 10;

delete from film_actor
 where film_id = 10;

delete from film_category
 where film_id = 10;


delete from film
 where film_id = 10;


-- 6) ------------------------------------------------------------------------------------------
select inventory_id
  from inventory
 where store_id = 1
   and inventory_id not in (
     select inventory_id
       from rental
      where return_date is null
   )
 limit 1;

insert into rental (rental_date, inventory_id, customer_id, return_date, staff_id)
values (
  now(),
  1,
  (select customer_id from customer order by customer_id limit 1),
  null,
  (select staff_id    from staff    order by staff_id    limit 1)
);

insert into payment (customer_id, staff_id, rental_id, amount, payment_date)
values (
  (select customer_id from rental r2 where r2.inventory_id = 1 order by r2.rental_date desc limit 1),
  (select staff_id    from rental r3 where r3.inventory_id = 1 order by r3.rental_date desc limit 1),
  (select rental_id   from rental r4 where r4.inventory_id = 1 order by r4.rental_date desc limit 1),
  5.99,            -- monto cualquiera
  now()
);

select * from rental  where inventory_id = 1 order by rental_date desc limit 1;
select * from payment where rental_id   = (select rental_id from rental where inventory_id = 1 order by rental_date desc limit 1);




