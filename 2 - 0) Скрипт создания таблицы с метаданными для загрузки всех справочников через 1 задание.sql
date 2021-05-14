-- создаем схему для метаданных
create schema metadata;

-- создаем таблицу метаданных для справочников
create table metadata.dim (
script varchar(256) not null,
schema_name varchar(256) not null,
table_name varchar(256) not null,
field varchar(256) not null,
ord smallint, 
primary key (schema_name, table_name, field));

-- загружаем в таблицу metadata.dim данные для загрузки справочников
insert into metadata.dim (script,schema_name, table_name, field, ord)
Values
('SELECT DISTINCT s.fare_conditions FROM bookings.seats s ORDER BY s.fare_conditions', 'dim', 'dim_tariff', 'fare_conditions',1),
('SELECT DISTINCT t.passenger_id, t.passenger_name, t.contact_data ->> ''phone'' AS phone, t.contact_data ->> ''email'' AS email FROM bookings.tickets t',
'dim', 'dim_passengers', 'passenger_id',1),
('SELECT DISTINCT t.passenger_id, t.passenger_name, t.contact_data ->> ''phone'' AS phone, t.contact_data ->> ''email'' AS email FROM bookings.tickets t',
'dim', 'dim_passengers', 'passenger_name',2),
('SELECT DISTINCT t.passenger_id, t.passenger_name, t.contact_data ->> ''phone'' AS phone, t.contact_data ->> ''email'' AS email FROM bookings.tickets t',
'dim', 'dim_passengers', 'phone',3),
('SELECT DISTINCT t.passenger_id, t.passenger_name, t.contact_data ->> ''phone'' AS phone, t.contact_data ->> ''email'' AS email FROM bookings.tickets t',
'dim', 'dim_passengers', 'email',4),
('SELECT DISTINCT a.airport_code, a.airport_name, a.city as airport_city, a.latitude, a.longitude FROM bookings.airports a', 'dim', 'dim_airports', 'airport_code',1),
('SELECT DISTINCT a.airport_code, a.airport_name, a.city as airport_city, a.latitude, a.longitude FROM bookings.airports a', 'dim', 'dim_airports', 'airport_name',2),
('SELECT DISTINCT a.airport_code, a.airport_name, a.city as airport_city, a.latitude, a.longitude FROM bookings.airports a', 'dim', 'dim_airports', 'city',3),
('SELECT DISTINCT a.airport_code, a.airport_name, a.city as airport_city, a.latitude, a.longitude FROM bookings.airports a', 'dim', 'dim_airports', 'latitude',4),
('SELECT DISTINCT a.airport_code, a.airport_name, a.city as airport_city, a.latitude, a.longitude FROM bookings.airports a', 'dim', 'dim_airports', 'longitude',5),
('SELECT DISTINCT a.aircraft_code, a.model, LEFT(a.model, POSITION('' '' in model)-1) AS manufacturer, a."range" FROM bookings.aircrafts a','dim', 'dim_aircrafts', 'aircraft_code',1),
('SELECT DISTINCT a.aircraft_code, a.model, LEFT(a.model, POSITION('' '' in model)-1) AS manufacturer, a."range" FROM bookings.aircrafts a','dim', 'dim_aircrafts', 'model',2),
('SELECT DISTINCT a.aircraft_code, a.model, LEFT(a.model, POSITION('' '' in model)-1) AS manufacturer, a."range" FROM bookings.aircrafts a','dim', 'dim_aircrafts', 'manufacturer',3),
('SELECT DISTINCT a.aircraft_code, a.model, LEFT(a.model, POSITION('' '' in model)-1) AS manufacturer, a."range" FROM bookings.aircrafts a','dim', 'dim_aircrafts', 'range',4);
