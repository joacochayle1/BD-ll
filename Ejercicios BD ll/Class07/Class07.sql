select title, rating, film.`length` from film where film.`length` <= all (select film.`length` from film);

-- ---------------------------------------------------------------------------------------------------------

select title from film where film.`length` < all (select film.`length` from film);

-- -------------------------------------------------------------------------------------------------------------------------------

select customer_id, (select first_name from customer where customer_id = payment.customer_id) as Nombre, 
					(select last_name from customer where customer_id = payment.customer_id) as Apellido,
					(select address from address where address.address_id = (select address_id from customer
					 														 where customer_id = payment.customer_id)) as address,
       amount as pago_mas_bajo
from payment
where amount = (select min(amount) from payment where customer_id = payment.customer_id);
					  
					  
					  
select customer_id, (select first_name from customer where customer_id = payment.customer_id) as Nombre, 
					(select last_name from customer where customer_id = payment.customer_id) as Apellido,
					(select address from address where address.address_id = (select address_id from customer
					 														 where customer_id = payment.customer_id)) as address,
       amount as pago_mas_bajo
from payment
where amount <= all (select amount from payment where customer_id = payment.customer_id);

-- ----------------------------------------------------------------------------------------------------------------------------------


select customer_id,
concat(
       (select min(amount) from payment where customer_id = p.customer_id),
       ' ----- ',
       (select max(amount) from payment p2  where customer_id = p.customer_id)
       ) as rango_pago
from payment p
group by customer_id;




