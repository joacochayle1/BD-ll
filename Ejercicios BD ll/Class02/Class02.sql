create database imdb;

create table if not exists film(
	film_id int primary key auto_increment,
	title varchar(20),
	description varchar(100),
	release_year date
);
create table if not exists actor(
	actor_id int primary key auto_increment,
	first_name varchar(50),
	last_name varchar(50)
);

create table if not exists film_actor(
	actor_id int,
	film_id int
);

alter table film_actor add 
	constraint fk_actor
		foreign key (actor_id)
		references actor(actor_id);
alter table film_actor add
	constraint fk_film
		foreign key (film_id) 
		references film(film_id);

alter table film add column
duration int; 

select title from film where description  = 'PG_13';
select duration from film;
