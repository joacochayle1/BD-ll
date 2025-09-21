/*
Create two or three queries using address table in sakila db:

include postal_code in where (try with in/not it operator)
eventually join the table with city/country tables.
measure execution time.
Then create an index for postal_code on address table.
measure execution time again and compare with the previous ones.
Explain the results
Run queries using actor table, searching for first and last name columns 
independently. Explain the differences and why is that happening?

Compare results finding text in the description on table film with 
LIKE and in the film_text using MATCH ... AGAINST. Explain the results.
*/


-- 1)

select address, postal_code from address a
where postal_code in ('30000','75000')
-- mayormente 0.002s

select address, postal_code from address a
where postal_code not in ('30000','75000') 
-- mayormente 0.002s

select a.address, a.postal_code , c.city, co.country from address a 
inner join city c using (city_id)
inner join country co using (country_id) 
where a.postal_code not in ('80000');
-- mayormente 0.004s

alter table address
add index idx_postal_code_address (postal_code)
/*
Seria de esperar que al crear el índice se reduzca el tiempo de query
pero en este caso no mejoro, lo que si en la tercera query redujo a
0.003s mas estable, las otras siguen igual de tiempo
*/
		 
select first_name from actor a

select last_name from actor a

-- aca no entendi que coraja tengo que explicar, si es sobre el tiempo
-- estan bastante igualadas, ambas dan mayormente 0.002s

SELECT film_id, title, description
FROM film
WHERE description LIKE '%action%';
-- 0.003s


ALTER TABLE film_text
ADD FULLTEXT idx_ft_description (description);

SELECT film_id, title
FROM film_text
WHERE MATCH(description) AGAINST ('action');
-- 0.001

-- Mejora por 2 milesimas el resultado de la busqueda


