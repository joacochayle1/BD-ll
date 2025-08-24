CREATE TABLE `employees` (
  `employeeNumber` int(11) NOT NULL,
  `lastName` varchar(50) NOT NULL,
  `firstName` varchar(50) NOT NULL,
  `extension` varchar(10) NOT NULL,
  `email` varchar(100) NOT NULL,
  `officeCode` varchar(10) NOT NULL,
  `reportsTo` int(11) DEFAULT NULL,
  `jobTitle` varchar(50) NOT NULL,
  PRIMARY KEY (`employeeNumber`)
);
insert  into `employees`(`employeeNumber`,`lastName`,`firstName`,`extension`,`email`,`officeCode`,`reportsTo`,`jobTitle`) values 
(1002,'Murphy','Diane','x5800','dmurphy@classicmodelcars.com','1',NULL,'President'),
(1056,'Patterson','Mary','x4611','mpatterso@classicmodelcars.com','1',1002,'VP Sales'),
(1076,'Firrelli','Jeff','x9273','jfirrelli@classicmodelcars.com','1',1002,'VP Marketing');

insert  into `employees`(`employeeNumber`,`lastName`,`firstName`,`extension`,`email`,`officeCode`,`reportsTo`,`jobTitle`) values 
(1999,'Jorge','Castello','x5524',null,'1',NULL,'Profe')


/* 1) Cuando intento poner un email null, me tira error diciendo que no puede ser null
	  ya que al crear la tabla se le indica que NO puede ser null.

*/ 

-- 2)
UPDATE employees SET employeeNumber = employeeNumber - 20; 
/*
se le resta el numero de empleado
*/
UPDATE employees SET employeeNumber = employeeNumber + 20;
/*
No me deja sumarle porque el numero de empleado debe ser unico y como un empleado tiene 1034
 y el otro 1054 si le sumo 20 primero va a pasar por el que tiene 1034 y no se le puede sumar
 porque tendria 1054, igual que el otro empleado y al ser unico no se puede.
*/

-- 3)
alter table employees
add column edad int check (edad between 16 and 70);

-- 4) 

/*
 film_actor es la tabla intermedia que modela la relación muchos a muchos entre film y actor.
 Claves:
   film.film_id      PRIMARY KEY
   actor.actor_id    PRIMARY KEY
   film_actor(actor_id, film_id) PRIMARY KEY compuesta
 Foreign keys:
   film_actor.actor_id -> actor.actor_id
   film_actor.film_id  -> film.film_id
 Efecto: no se pueden insertar filas en film_actor que apunten a film/actor inexistentes;
         no se pueden borrar film/actor referenciados (a menos que la FK tenga ON DELETE CASCADE).

*/

-- 5)

select * from employees e

alter TABLE employees
add column lastUpdate DateTime default now(),
add column lastUpdateUser char(50)

delimiter $$ -- se deben de ejecutar en archivo separado para poder crearlos correctamente
create trigger user_date_time_insert
before insert on employees
for each row
begin
    set new.lastUpdate = now();
    set new.lastUpdateUser = user();
end$$
delimiter ;

delimiter $$
create trigger user_date_time_update
before update on employees
for each row
begin
    set new.lastUpdate = now();
    set new.lastUpdateUser = user();
end$$
delimiter ;


-- 6)

show triggers like 'film';

-- Existen 3 triggers

/*
 ins_film(AFTER)
 BEGIN
    INSERT INTO film_text (film_id, title, description)
        VALUES (new.film_id, new.title, new.description);
  END
  
 Cada que se inserta una nueva pelicula,  se guardan los datos insertados en otra tabla llamada film_text, a modo de tener
 otra tabla con los 'logs' de lo que se hace/modifica en la tabla de peliculas
 */

/*
  upd_film(AFTER)
  BEGIN
    IF (old.title != new.title) OR (old.description != new.description) OR (old.film_id != new.film_id)
    THEN
        UPDATE film_text
            SET title=new.title,
                description=new.description,
                film_id=new.film_id
        WHERE film_id=old.film_id;
    END IF;
  END
  
  Cada que se actualiza una pelicula, se actualiza la fila en la tabla ya mencionada de film_text. previo a la modificacion de
  los datos, se valida con un IF que al menos 1 de los campos sea distintos a los que ya estan insertdos, ya que si son iguales no 
  tiene sentido hacer la operacion. Una vez validados los datos, busca la fila en film_text que tenga el mismo id y ahi modifica
  los datos
  */

/*
  del_film (AFTER)
  BEGIN
    DELETE FROM film_text WHERE film_id = old.film_id;
  END
  
  Cuando se borra una pelicula de la tabla films, se bora tambien de la tabla film_text, asi de simple...
 */


