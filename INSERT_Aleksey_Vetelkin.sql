-- 1
-- Choose one of your favorite films and add it to the "film" table.
-- Fill in rental rates with 4.99 and rental durations with 2 weeks.
-- Implemented handling situations when data already exists in table
insert into film (title, rental_rate, rental_duration, language_id)
select 'Ocean''s eleven', 4.99, 14, 1
where not exists (
    select 1
    from public.film
    where upper(title) = upper('Ocean''s eleven')
    limit 1
);

-- 2
-- Add the actors who play leading roles in your favorite film to the "actor"
-- and "film_actor" tables (three or more actors in total).

-- 2.1
-- Adding to 'actor' table
-- Implemented handling situations when data already exists in table
insert into actor (first_name, last_name)
select 'GEORGE', 'CLOONEY' where not exists (
    select 1 from actor where upper(first_name) = 'GEORGE' and upper(last_name) = 'CLOONEY'
);
insert into actor (first_name, last_name)
select 'BRAD', 'PITT' where not exists (
    select 1 from actor where upper(first_name) = 'BRAD' and upper(last_name) = 'PITT'
);
insert into actor (first_name, last_name)
select 'JULIA', 'ROBERTS' where not exists (
    select 1 from actor where upper(first_name) = 'JULIA' and upper(last_name) = 'ROBERTS'
);

-- 2.2
-- Adding to 'film_actor' table
-- Implemented handling situations when data already exists in table
with FilmCte as (
    select film_id
    from public.film
    where upper(title) = upper('Ocean''s eleven')
)
insert into public.film_actor (film_id, actor_id)
select (select film_id from FilmCte), a.actor_id
from public.actor a
where (upper(a.first_name), upper(a.last_name)) in (
      	('GEORGE', 'CLOONEY'),
      	('BRAD', 'PITT'),
	  	('JULIA', 'ROBERTS')
      )
and not exists (
    select 1
    from public.film_actor fa
    where fa.film_id = (select film_id from filmcte) and fa.actor_id = a.actor_id
);

-- 3
-- Add your favorite movies to any store's inventory
-- Implemented handling situations when data already exists in table
with FilmCte as (
    select film_id
    from film
    where upper(title) = upper('Ocean''s eleven')
)
insert into inventory (film_id, store_id)
select (select film_id from FilmCte), 1
where not exists (
    select 1
    from inventory
    where film_id = (select film_id from FilmCte)
    and store_id = 1
);

-- simple selects to check workability of programm
-- select * from film order by film_id desc
-- select * from actor order by actor_id desc
-- select * from film_actor order by film_id desc
-- select * from inventory order by inventory_id desc