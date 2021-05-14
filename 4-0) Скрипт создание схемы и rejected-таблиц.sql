
-- создаем схемы
CREATE SCHEMA rejected;


CREATE TABLE rejected.fact_flights (
	flight_no bpchar(6),
	passenger_id text, 
	actual_departure timestamptz ,
	actual_arrival timestamptz,
	delay_time_departure int4,
	delay_time_arrival int4,
	aircraft_code varchar(30),
	airports_departure_code varchar(30),
	airports_arrival_code varchar(30),
	fare_conditions_id int,
	amount numeric(10,2),
	reason_for_rejection TEXT -- поле с причиной отклонения
);



CREATE TABLE rejected.dim_aircrafts (
	aircraft_code bpchar(3),
	model varchar(20), 
	manufacturer varchar(20), 
	"range" int4,
	reason_for_rejection TEXT
);


CREATE TABLE rejected.dim_airports (
	airport_code bpchar(3), 
	airport_name varchar(50),
	airport_city varchar(50),
	longitude float(8),
	latitude float(8),
	reason_for_rejection TEXT -- поле с причиной отклонения
);


CREATE TABLE rejected.dim_passengers (
	passenger_id varchar(20), 
	passenger_name text, 
	phone  varchar(20), 
	email  varchar(150),
	reason_for_rejection TEXT -- поле с причиной отклонения
);


CREATE TABLE rejected.dim_tariff (
	fare_conditions_id int4,
	fare_conditions varchar(10),
	reason_for_rejection TEXT -- поле с причиной отклонения
);


CREATE TABLE rejected.dim_calendar (
	id int4 , 
	"date" date , 
	YEAR int4 , 
	n_week int4 ,
	day_week varchar(10),
	reason_for_rejection TEXT -- поле с причиной отклонения
);


