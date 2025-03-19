

select * from actor a1 where exists(select * from actor a2 
							  where a1.last_name = a2.last_name 
							  and a1.actor_id <> a2.actor_id)
order by last_name;

-- ------------------------------------------------------------------------------

select * from actor where not exists(select * from film_actor fa where fa.actor_id = actor.actor_id );

-- ---------------------------------------------------------------------------------------------------------

select * from customer c where exists (select * from rental r where r.customer_id = c.customer_id ) = 1;

-- -----------------------------------------------------------------------------------------------------------

select * from customer c where  (select count(*) from rental r where r.customer_id = c.customer_id ) > 1;

-- -----------------------------------------------------------------------------------------------------------

select * from actor a where actor_id in (
									select actor_id from film_actor fa 
										 where film_id in (
										 				select film_id from film f 
										 					   where title in ('BETRAYED REAR','CATCH AMISTAD'))
									);

-- ---------------------------------------------------------------------------------------------------------------

select * from actor a where actor_id in (
									select actor_id from film_actor fa 
									where film_id in (
										 				select film_id from film f 
										 				where title = 'BETRAYED REAR'
													  )
										) and actor_id not in (select actor_id from film_actor fa 
															   where film_id in(select film_id from film 
															   					where title = 'CATCH AMISTAD')
																);

-- --------------------------------------------------------------------------------------------------------------

select * from actor a where actor_id in (
									select actor_id from film_actor fa 
									where film_id in (
										 				select film_id from film f 
										 				where title = 'BETRAYED REAR'
													  )
										) and actor_id in (select actor_id from film_actor fa 
															   where film_id in(select film_id from film 
															   					where title = 'CATCH AMISTAD')
																);

-- --------------------------------------------------------------------------------------------------------------

select * from actor a where actor_id not in (
									select actor_id from film_actor fa 
									where film_id in (
										 				select film_id from film f 
										 				where title in('BETRAYED REAR', 'CATCH AMISTAD') 
													  )
										);




