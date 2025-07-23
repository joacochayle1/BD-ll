-- 1)

Create or replace view list_of_customers as
select customer.customer_id, 
	concat(customer.first_name, ' ', customer.last_name) as Nombre,
	address.address,
	address.postal_code,
	address.phone,
	city.city,
	customer.active,
	customer.store_id,
	country.country,
	case when customer.active = 1 then 'active'
	else 'inactive'
	end as estado
from customer 
inner join address on customer.address_id = address.address_id
inner join city on address.city_id     = city.city_id
  inner join country on city.country_id = country.country_id;


select * from list_of_customers

-- 2)

create or replace view film_details as
select f.film_id,
	   f.title Titulo,
	   f.description Descripcion,
	   c.name Categoria,
	   f.rental_rate Precio,
	   f.`length` Duracion,
	   f.rating Rating,
	   group_concat(concat(a.first_name,' ',a.last_name)) Actores
from film f 
inner join film_actor fa on fa.film_id = f.film_id
inner join actor a on a.actor_id = fa.actor_id
inner join film_category fc on fc.film_id = f.film_id
inner join category c on c.category_id = fc.category_id
group by f.film_id, f.title, c.category_id


select * from film_details

-- 3)

create or replace view sales_by_film_category as
select c.name Cateogria,
	   sum(p.amount) as total
from category c
inner join film_category fc using(category_id)
inner join film f using(film_id)
inner join inventory i using(film_id)
inner join rental r using(inventory_id)
inner join payment p using(rental_id)
group by c.category_id, c.name


select * from sales_by_film_category sbfc 


-- 4)


create or replace view actor_information as
select a.actor_id,
	   a.first_name Nombre,
	   a.last_name Apellido ,
	   count(fa.film_id) 'peliculas en las que actuo' 
from actor a
inner join film_actor fa using(actor_id)
inner join film f using(film_id)
group by a.actor_id, a.first_name, a.last_name

select * from actor_information ai

 
-- 5)

-- La query primero une las tablas y las relaciona para poder unir actor con film
-- a travez de film_actor y a su vez compara los actores entre si para saber en las pelicualas que estuvo
-- ese actor y colocarlo por categoria. 

select 
a.actor_id,
a.first_name,
a.last_name,
(select group_concat(CONCAT(cat.name, ": ", (
select group_concat(f.title separator ", ") from film f
inner join film_category fc using(film_id)
inner join category c1 using(category_id)
inner join film_actor fa1 using(film_id)
inner join actor a2 using(actor_id)
 
where c1.category_id = cat.category_id and a2.actor_id = a.actor_id

)
) separator " | ") from category cat
inner join film_category fc1 using(category_id)
inner join film f1 using(film_id)
inner join film_actor fa using(film_id)
inner join actor a1 using(actor_id)
where a1.actor_id = a.actor_id

) as films
from actor a
inner join film_actor fa using(actor_id )
inner join film f using(film_id)
group by a.actor_id;



-- 6)

/*
Materialized Views

Descripción:
  Una materialized view (vista materializada) es una vista cuya
  consulta se ejecuta y cuyos resultados se almacenan físicamente
  en disco como una tabla. A diferencia de una vista normal (virtual),
  que se recalcula en cada acceso, la materialized view guarda el
  resultado precomputado y lo actualiza sólo cuando se refresca.

¿Para qué se usan?
  - Mejorar el rendimiento de consultas complejas y agregaciones
    costosas, evitando computarlas cada vez.
  - Reducir la carga de CPU y E/S en informes que se ejecutan con
    alta frecuencia o sobre grandes volúmenes de datos.
  - Proporcionar un “snapshot” de datos en un punto en el tiempo,
    útil para reporting o análisis histórico.

Alternativas:
  - **Vistas virtuales**: recalculan en cada ejecución, no ocupan
    espacio, pero pueden ser lentas si la consulta es pesada.
  - **Tablas de resumen / ETL**: crear manualmente tablas de agregados
    mediante procesos por lotes; más flexibles, pero requieren
    mantenimiento y orquestación externa.
  - **Índices materializados** (en algunos SGBD): estructuras similares
    a materialized views enfocadas en acelerar búsquedas concretas.

SGBD que las soportan:
  - **Oracle**: con `CREATE MATERIALIZED VIEW ...` y opciones de
    refresco (COMPLETE, FAST, ON COMMIT).  
  - **PostgreSQL**: `CREATE MATERIALIZED VIEW ...` con `REFRESH MATERIALIZED VIEW`.  
  - **IBM Db2**: llamadas “materialized query tables” (MQT).  
  - **SQL Server**: no tiene materialized views directas, pero usa
    **indexed views** (vistas con índices clusterizados).  
  - **MySQL / MariaDB**: nativamente no, pero MariaDB ofrece “
    sequence storage engines” o soluciones con tablas y eventos
    para simularlas.

Consideraciones:
  - Hay que decidir la frecuencia de refresco (manual, programado,
    automático al commit).  
  - Las vistas materializadas ocupan espacio extra y requieren
    mantenimiento, pero ganan en velocidad de lectura.  
  - La consistencia entre la vista y las tablas base depende del modo
    de refresco; puede haber un desfase hasta el próximo refresh.
*/



