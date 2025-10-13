#1) 
CREATE USER data_analyst@'%' 
IDENTIFIED BY 'pepe123';



#2)
GRANT SELECT, UPDATE, DELETE ON sakila.*
TO data_analyst@'%' WITH GRANT OPTION

/*
3) Creo la Conexion en dbeaver con el usuario data_analyst y la contra pepe123
Una vez con esta cuenta, trato de hacer:
*/

Create Table Tabla (
titulo varchar(50)
);

-- SQL Error [1142] [42000]: 
-- CREATE command denied to user 'data_analyst'@'192.168.65.1' for table 'Tabla'


#4) Trato de Actualizar Tabla y Funciona

Update film f 
set title = 'ACADEMY Dinosaurio'
where title LIKE 'ACADEMY DINOSAUR';

#5) Hago revoke a los permisos a Data_analyst

revoke UPDATE on sakila.* From data_analyst@'%';

#6) Nos loggeamos como data analyst de nuevo y probamos:
Update film f 
set title = 'ACADEMY DINOSAUR'
where title LIKE 'ACADEMY Dinosaurio';

/*
Tira este error:

SQL Error [1142] [42000]: UPDATE command denied to user 'data_analyst'@'203.0.74.1' for table 'film'
*/