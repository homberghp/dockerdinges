/*
 * database schema for transaction demo
 */
begin work; -- ddl is transactional in postgresql, use it to your benefit.
CREATE EXTENSION if not exists btree_gist;
CREATE EXTENSION if not exists citext;
CREATE DOMAIN email AS citext
  CHECK ( value ~ '^[a-zA-Z0-9.!#$%&''*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$' );

create table customers(
    customer_id serial primary key,
    customer_name text not null,
    customer_email email not null,
    credit money check (credit >=0::money)
);

create table rental_items(
    item_id serial primary key,
    item_description text not null,
    item_cost_per_day money check (item_cost_per_day >= 0::money),
    item_deposit money check (item_deposit >= 0::money)
    
);

create table reservations (
    reservation_id serial primary key,
    item_id integer references rental_items(item_id) not null,
    for_customer integer references customers(customer_id) not null,
    reservation_cost money not null check (reservation_cost > 0::money),
    during daterange not null,
    EXCLUDE USING GIST (item_id WITH =, during WITH &&)
);

INSERT INTO public.customers VALUES (1, 'Piet Puk', 'p.puk@gmail.com', '$12,356.00');
INSERT INTO public.customers VALUES (2, 'Jan Klaassen', 'j.klaassen@hotmail.com', '$550.00');
INSERT INTO public.rental_items VALUES (1, 'City Bike', '$10.00', '$50.00');
INSERT INTO public.rental_items VALUES (2, 'Umbrella', '$0.50', '$10.00');

commit;
