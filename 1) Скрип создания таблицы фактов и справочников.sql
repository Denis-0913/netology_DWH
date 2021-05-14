-- создаем схемы
CREATE SCHEMA dim; CREATE SCHEMA fact;

/* Таблица Fact_Flights - содержит совершенные перелеты. 
 * Если в рамках билета был сложный маршрут с пересадками - каждый сегмент учитываем независимо*/
CREATE TABLE fact.fact_flights (
	flight_no bpchar(6) NOT NULL, -- в задании не указано поле с номером рейса, но совокупность номера рейса (flight_no) и даты отправления (scheduled_departure или actual_departure) 
	--являются естественным ключом, поэтому добавление данного поля упростит работу конечного пользователя с таблицей фактов
	passenger_id text references dim.dim_passengers(passenger_id), -- Пассажир (bookings.tickets.passenger_name)
	actual_departure timestamptz NOT NULL, -- Дата и время вылета (факт) (bookings.flights.actual_departure)
	actual_arrival timestamptz NOT NULL, -- Дата и время прилета (факт) (bookings.flights.actual_arrival)
	delay_time_departure int4 NOT NULL, -- Задержка вылета (разница между фактической и запланированной датой в секундах) (actual_departure - scheduled_departure)
	delay_time_arrival int4 NOT NULL, -- Задержка прилета (разница между фактической и запланированной датой в секундах) (actual_arrival - scheduled_arrival)
	aircraft_code varchar(30) NOT NULL REFERENCES dim.dim_aircrafts(aircraft_code), -- код самолета (bookings.flights.aircraft_code)
	airports_departure_code varchar(30) NOT NULL REFERENCES dim.dim_airports(airport_code), -- Аэропорт вылета (bookings.flights.airports_departure)
	airports_arrival_code varchar(30) NOT NULL REFERENCES dim.dim_airports(airport_code),  -- Аэропорт прилета (bookings.flights.airports_arrival)
	fare_conditions_id int REFERENCES dim.dim_tariff(fare_conditions_id), -- ключ класса обслуживания (dim.dim_tariff)
	amount numeric(10,2) -- стоимость (bookings.ticket_flights.amount)
);



-- создаем справочник самолетов dim_aircrafts
CREATE TABLE dim.dim_aircrafts (
	aircraft_code bpchar(3) PRIMARY KEY, -- ключ (bookings.aircrafts.aircraft_code)
	model varchar(20) NOT NULL, -- модель (bookings.aircrafts.model)
	manufacturer varchar(20) NOT NULL, -- производитель - первое слово в названии  модели самолета 
	"range" int4 NOT NULL -- расстояние (bookings.aircrafts."range")
);

-- создаем справочник аэропортов dim_airports
CREATE TABLE dim.dim_airports (
	airport_code bpchar(3) PRIMARY KEY, -- ключ (bookings.airports.airport_code)
	airport_name varchar(50) NOT NULL, -- название аэропорта (bookings.airports.airport_name)
	airport_city varchar(50) NOT NULL, -- город аэропорта (bookings.airports.city)
	longitude float(8) NOT NULL, -- долгота города (bookings.airports.longitude)
	latitude float(8) NOT NULL -- широта города (bookings.airports.latitude)
);

-- создаем справочник пассажиров dim_passengers
CREATE TABLE dim.dim_passengers (
	passenger_id varchar(20) PRIMARY KEY, -- ключ пасажира (bookings.tickets.passenger_id)
	passenger_name text NOT NULL, -- ФИО пасажира (bookings.tickets.passenger)
	phone  varchar(20), -- телефон  пассажира (bookings.tickets.contact_data ->> 'phone')
	email  varchar(150) -- email  пассажира (bookings.tickets.contact_data ->> 'email')
);

-- создаем справочник тарифов dim_tariff
CREATE TABLE dim.dim_tariff (
	fare_conditions_id serial PRIMARY KEY, -- ключ тарифа - не задан, задаем сами
	fare_conditions varchar(10) NOT NULL -- тариф (bookings.seats.fare_conditions)
);

-- создаем справочник дат dim_calendar
CREATE TABLE dim.dim_calendar (
	id serial PRIMARY KEY, -- ключ
	"date" date UNIQUE NOT NULL , -- дата
	YEAR int4 NOT NULL, -- год
	n_week int4 NOT NULL, -- неделя
	day_week varchar(10) NOT NULL-- день недели
);

-- заполняем справочник дат dim_calendar скриптом SQL
INSERT INTO dim.dim_calendar("date",YEAR,n_week, day_week)
SELECT gs, date_part('year', gs), date_part('week', gs), to_char(gs, 'day')
FROM generate_series('2016-09-13', current_date, interval '1 day') as gs; 
-- 2016-09-13 - мин дата в таблице полетов. через запрос ее вложить нельзя, так как базы схем между собой не связаны. Макс дата равна текущей на тот случай, если данные будут обновляться.

