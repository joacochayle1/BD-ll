/* 1)
 Write a function that returns the amount of copies of a film in a 
 store in sakila-db. Pass either the
  film id or the film name and the store id.
 */

select count(*) from film f
inner join inventory i using(film_id)
inner join store s using (store_id)
group by s.store_id

delimiter $$
create function sakila_copias_store(
p_film_id int
p_store_id int

) returns int
begin 
	  declare v_count int defalut 0;
	  select count(*) into v_count
	  from inventory where film_id = p_film_id and store_id = p_store_id;
return ifnull(v_count,0);
end$$
delimiter ;

/*
 Write a stored procedure with an output parameter that 
 contains a list of customer first and last names separated by ";", 
 that live in a certain country. You pass the country it gives you the 
 list of people living there. 
 USE A CURSOR, do not use any aggregation function (ike CONTCAT_WS.
 */

-- Ejecutenlo en un archivo aparte y ponganle ejecutar script, porque seleccionar todo
-- y ctrl + enter no funciona
use sakila;

delimiter $$

drop procedure if exists customers_en_pais$$

create procedure customers_en_pais(
  in p_country varchar(100),
  out p_list text
)
begin
  declare fin boolean default false;
  declare v_nombrecompleto varchar(120);

  declare bucle cursor for
    select concat(c.first_name, ' ', c.last_name)
    from customer c
    inner join address a using(address_id)
    inner join city ci using(city_id)
    inner join country co using(country_id)
    where co.country = p_country;

  declare continue handler for not found set fin = true;

  set p_list = '';

  open bucle;
  leer_loop: loop
    fetch bucle into v_nombrecompleto;
    if fin then
      leave leer_loop;
    end if;

    if p_list = '' then
      set p_list = v_nombrecompleto;
    else
      set p_list = concat(p_list, ';', v_nombrecompleto);
    end if;
  end loop;
  close bucle;
end$$

delimiter ;


set @lista='';
call customers_en_pais('Argentina',@lista);
select @lista;




/* 
 3) 
 Review the function inventory_in_stock 
 and the procedure film_in_stock explain the code, write usage examples.
 */

-- inventory_in_stock
-- Devuelve 1 si la copia (inventory_id) está disponible, 0 si está afuera.

/*
 CREATE DEFINER=`root`@`localhost` FUNCTION `sakila`.`inventory_in_stock`(p_inventory_id INT) RETURNS tinyint(1)
    READS SQL DATA
BEGIN
    DECLARE v_rentals INT;
    DECLARE v_out     INT;

    
    aca cuenta si tuvo rentals

    SELECT COUNT(*) INTO v_rentals
    FROM rental
    WHERE inventory_id = p_inventory_id;

si no tuvo alquiler se pone disponible

    IF v_rentals = 0 THEN
      RETURN TRUE;
    END IF;

aca cuenta rentals activos que no tengan return_date para esa copia

    SELECT COUNT(rental_id) INTO v_out
    FROM inventory LEFT JOIN rental USING(inventory_id)
    WHERE inventory.inventory_id = p_inventory_id
    AND rental.return_date IS NULL;

     IF v_out > 0 THEN
      RETURN FALSE; -- Si no devuelve no hay estock
    ELSE
      RETURN TRUE; -- si devuelve si hay :)
    END IF;
END
 */

-- film_in_stock
-- Rellena p_film_count con la cantidad de copias disponibles de una película en una sucursal.
-- Además devuelve (opcional) el listado de inventory_id disponibles como resultset.

/*
CREATE DEFINER=`root`@`localhost` PROCEDURE `sakila`.`film_in_stock`(IN p_film_id INT, IN p_store_id INT, OUT p_film_count INT)
    READS SQL DATA
BEGIN

aca selecciona un listado con ids de inventario disponibles

     SELECT inventory_id
     FROM inventory
     WHERE film_id = p_film_id
     AND store_id = p_store_id
     AND inventory_in_stock(inventory_id);

cuenta las copias disponibles y las guarda en la salida

     SELECT COUNT(*)
     FROM inventory
     WHERE film_id = p_film_id
     AND store_id = p_store_id
     AND inventory_in_stock(inventory_id)
     INTO p_film_count;
END
*/

-- Lo de los ejemplos de uso la verdad que se las debo toy cansadito de ver cosas nuevas que estoy entendiendo a medias
-- cuando lo vuelva a ver ya bien estudiado por ahi se los actualizo en el github