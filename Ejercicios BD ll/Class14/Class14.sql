use sakila;

-- 1)

select 
concat(c.first_name, " ", c.last_name) as Full_name,
a.address,
cy.city
from customer c
inner join address a using(address_id)
inner join city cy using(city_id)
inner join country co using(country_id)
where co.country like 'Argentina';


-- 2)

select f.title, lan.name as language,
case f.rating 
	when 'G' then 'G (General Audiences) – All ages admitted.'
	when 'PG' then 'PG (Parental Guidance Suggested) – Some material may not be suitable for children.'
	when 'PG-13' then 'PG-13 (Parents Strongly Cautioned) – Some material may be inappropriate for children under 13.'
	when 'R' then 'R (Restricted) – Under 17 requires accompanying parent or adult guardian.'
	when 'NC-17' then 'C-17 (Adults Only) – No one 17 and under admitted.'
	else 'NR - Not Rated'
end as 'rating description'
from film f
inner join language lan using(language_id);


-- 3)
-- Ejecutar primero el set y despues la consulta

SET @parametro_busqueda = 'Laura';

select f.title, f.release_year,concat(a.first_name," ",a.last_name) as Actor from film f
inner join film_actor fa using(film_id)
inner join actor a using(actor_id)
where concat(a.first_name," ",a.last_name) like concat('%',upper(@parametro_busqueda),'%'); 

-- 4)


select f.title, concat(c.first_name," ",c.last_name) as full_name,
case 
	when r.return_date is null then 'No'
	else 'Yes'
end as returned
from rental r 
inner join inventory i using(inventory_id )
inner join film f using(film_id)
inner join customer c using(customer_id)
where month(r.rental_date) = 5 or month(r.rental_date) = 6;

-- 5)

-- CAST y CONVERT sirven para cambiar el tipo de dato de un valor o columna.
-- Ambos hacen lo mismo (no hay diferencia práctica), pero CAST sigue el estándar SQL
-- mientras que CONVERT es una extensión propia de MySQL y algunos otros SGBD.
-- Se usan para convertir, por ejemplo, texto a número, número a texto, fecha a texto, etc.
-- Ejemplos con la base de datos sakila:

-- Convertir customer_id a CHAR (texto) usando CAST
select customer_id, CAST(customer_id AS CHAR) as id_texto
from customer
limit 1;

-- Convertir customer_id a CHAR usando CONVERT
select customer_id, CONVERT(customer_id, CHAR) as id_texto
from customer
limit 1;

-- Convertir rental_date a DATE (solo fecha, sin hora)
select rental_id, CAST(rental_date AS DATE) as solo_fecha
from rental
limit 1;

-- Convertir amount (decimal) a entero
select payment_id, amount, CAST(amount AS SIGNED) as monto_entero
from payment
limit 1;

-- 6)

-- Estas funciones sirven para manejar valores NULL y reemplazarlos por otro valor.
-- Si el valor es NULL, devuelven el valor alternativo; si no es NULL, devuelven el valor original.

-- IFNULL(expr1, expr2) → MySQL SÍ la tiene. Devuelve expr2 si expr1 es NULL.
select first_name, IFNULL(null, 'Valor por defecto') as ejemplo from customer limit 1;

-- COALESCE(expr1, expr2, expr3, ...) → MySQL SÍ la tiene. Devuelve el primer valor que no sea NULL.
select COALESCE(null, null, 'Primer valor no nulo') as ejemplo;

-- ISNULL(expr) → En MySQL, devuelve 1 si expr es NULL, 0 si no lo es (no reemplaza valores).
select first_name, ISNULL(null) as es_nulo from customer limit 1;

-- NVL no existe en MySQL, es de Oracle. Hace lo mismo que IFNULL.

-- Ejemplos con sakila:

-- Usando IFNULL para reemplazar un campo NULL
select customer_id, IFNULL(email, 'sin email') as email_seguro
from customer
limit 5;

-- Usando COALESCE con múltiples alternativas
select customer_id, COALESCE(email, 'sin email', 'otro valor') as email_seguro
from customer
limit 5;

-- Detectar NULL con ISNULL
select rental_id, ISNULL(return_date) as no_devuelto
from rental
limit 5;



