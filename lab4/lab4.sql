/*
Lab 2 report Josef Atoui (josat799), Stefan Brynielsson (stebr364)
*/

/*
Drop all user created tables that have been created when solving the lab
*/
delimiter ;

DROP FUNCTION IF EXISTS calculateFreeSeats;
DROP FUNCTION IF EXISTS calculatePrice;
DROP Trigger IF EXISTS tg_booking;

DROP VIEW IF EXISTS allFlights;

DROP PROCEDURE IF EXISTS addYear;
DROP PROCEDURE IF EXISTS addDay;
DROP PROCEDURE IF EXISTS addDestination;
DROP PROCEDURE IF EXISTS addRoute;
DROP PROCEDURE IF EXISTS addFlight;
DROP PROCEDURE IF EXISTS addReservation;
DROP PROCEDURE IF EXISTS addPassenger;
DROP PROCEDURE IF EXISTS addContact;
DROP PROCEDURE IF EXISTS addPayment;

DROP TABLE IF EXISTS bookingnumber CASCADE;
DROP TABLE IF EXISTS booking CASCADE;
DROP TABLE IF EXISTS payment CASCADE;
DROP TABLE IF EXISTS contactperson CASCADE;
DROP TABLE IF EXISTS passengerreservations CASCADE;
DROP TABLE IF EXISTS reservation CASCADE;
DROP TABLE IF EXISTS passenger CASCADE;
DROP TABLE IF EXISTS flight CASCADE;
DROP TABLE IF EXISTS weeklyschedule CASCADE;
DROP TABLE IF EXISTS day CASCADE;
DROP TABLE IF EXISTS route CASCADE;
DROP TABLE IF EXISTS year CASCADE;

DROP TABLE IF EXISTS airport CASCADE;


-- DROP TABLE IF EXISTS myitem CASCADE;
-- DROP VIEW IF EXISTS item_view CASCADE;
-- DROP VIEW IF EXISTS total_debit_view CASCADE;
-- DROP VIEW IF EXISTS total_debit_view2 CASCADE;
-- DROP VIEW IF EXISTS jbsale_supply CASCADE;

/* Have the source scripts in the file so it is easy to recreate!*/

CREATE TABLE airport (
  name varchar(30),
  country varchar(30),
  airportcode varchar(3),

  CONSTRAINT pk_airport
    PRIMARY KEY (airportcode)
);

CREATE TABLE year (
  year integer,
  profitfactor double,

  CONSTRAINT pk_year
    PRIMARY KEY (year)
);

CREATE TABLE route (
  id integer NOT NULL AUTO_INCREMENT,
  destination varchar(3),
  departure varchar(3),
  price double,
  year integer,

  CONSTRAINT pk_route
    PRIMARY KEY (id),

  CONSTRAINT fk_destination
    FOREIGN KEY (destination) REFERENCES airport(airportcode),

  CONSTRAINT fk_departure
    FOREIGN KEY (departure) REFERENCES airport(airportcode),

  CONSTRAINT fk_year
    FOREIGN KEY (year) REFERENCES year(year)

);

CREATE TABLE day (
  id integer AUTO_INCREMENT,
  day varchar(10),
  year integer,
  weekdayfactor double,

  CONSTRAINT pk_day
    PRIMARY KEY (id),

  CONSTRAINT fk_day_year
    FOREIGN KEY (year) REFERENCES year(year)
);

CREATE TABLE weeklyschedule (
  id integer NOT NULL AUTO_INCREMENT,
  day integer,
  time time,
  route integer,

  CONSTRAINT pk_weeklyschedule
    PRIMARY KEY (id),

  CONSTRAINT fk_day
    FOREIGN KEY (day) REFERENCES day(id),

  CONSTRAINT fk_route
    FOREIGN KEY (route) REFERENCES route(id)

);

CREATE TABLE flight (
  flightnumber integer AUTO_INCREMENT,
  week integer,
  schedule integer,

  CONSTRAINT pk_flight
    PRIMARY KEY (flightnumber),

  CONSTRAINT fk_schedule
    FOREIGN KEY (schedule) REFERENCES weeklyschedule(id)
);

CREATE TABLE passenger (
  passportnumber integer,
  name varchar(30),

  CONSTRAINT pk_passenger
    PRIMARY KEY (passportnumber)
);

CREATE TABLE reservation (
  reservationnumber integer,
  seats integer,
  flight integer,

  CONSTRAINT pk_reservation
    PRIMARY KEY (reservationnumber),

  CONSTRAINT fk_flight
    FOREIGN KEY (flight) REFERENCES flight(flightnumber)
);


CREATE TABLE contactperson (
  passenger integer,
  phonenumber bigint,
  email varchar(30),

  CONSTRAINT pk_contactperson
    PRIMARY KEY (passenger),

  CONSTRAINT fk_passportnumber
    FOREIGN KEY (passenger) REFERENCES passenger(passportnumber)
);

CREATE TABLE payment (
  cardnumber bigint,
  cardholder varchar(30),

  CONSTRAINT pk_payment
    PRIMARY KEY (cardnumber)
);

CREATE TABLE booking (
  reservationnumber integer,
  contact integer,
  payment bigint,
  cost double,

  CONSTRAINT pk_booking
    PRIMARY KEY (reservationnumber),

  CONSTRAINT fk_contact
    FOREIGN KEY (contact) REFERENCES contactperson(passenger),

  CONSTRAINT fk_payment
    FOREIGN KEY (payment) REFERENCES payment(cardnumber),

  CONSTRAINT fk_reservation
    FOREIGN KEY (reservationnumber) REFERENCES reservation(reservationnumber)
);

CREATE TABLE bookingnumber (
  passenger integer,
  booking integer,
  bookingnumber integer,

  CONSTRAINT pk_bookingnumber
    PRIMARY KEY (passenger, booking),

  CONSTRAINT fk_passenger
    FOREIGN KEY (passenger) REFERENCES passenger(passportnumber),

  CONSTRAINT fk_booking
    FOREIGN KEY (booking) REFERENCES booking(reservationnumber)
);

delimiter //
CREATE PROCEDURE addYear(IN year integer, IN factor double)
  BEGIN
    INSERT INTO year (year, profitfactor) VALUES (year, factor);
  END; //
delimiter ;

delimiter //
CREATE PROCEDURE addDay(IN year integer, IN day varchar(10), IN factor double)
  BEGIN
    INSERT INTO day (day, year, weekdayfactor) VALUES (day, year, factor);
  END; //
delimiter ;

delimiter //
CREATE PROCEDURE addDestination(IN airport_code varchar(3), IN name varchar(30), IN country varchar(30))
  BEGIN
    INSERT INTO airport (name, country, airportcode) VALUES (name, country, airport_code);
  END; //
delimiter ;

delimiter //
CREATE PROCEDURE addRoute(IN departure_airport_code varchar(3), IN arrival_airport_code varchar(3), IN year integer, IN routeprice double)
  BEGIN
    INSERT INTO route (destination, departure, price, year) VALUES (arrival_airport_code, departure_airport_code, routeprice, year);
  END; //
delimiter ;

delimiter //
CREATE PROCEDURE addFlight(IN departure_airport_code varchar(3), IN arrival_airport_code varchar(3), IN year integer, IN day varchar(10), IN departure_time time)
  BEGIN
    DECLARE routeid integer;
    DECLARE dayid integer;
    DECLARE schedule integer;
    DECLARE n integer;

    SELECT route.id INTO routeid
      FROM route
      WHERE route.departure = departure_airport_code AND route.destination = arrival_airport_code and route.year = year;

    SELECT day.id INTO dayid FROM day WHERE day.day = day AND day.year = year;
      INSERT INTO weeklyschedule (route, day, time) VALUES (routeid, dayid, departure_time);

    SELECT weeklyschedule.id INTO schedule
      FROM weeklyschedule
      WHERE weeklyschedule.route = route AND weeklyschedule.day = dayid AND weeklyschedule.time = departure_time;

    SET n = 1;

    WHILE n <= 52 DO
      INSERT INTO flight (week, schedule) VALUES (n, schedule);
      SET n = n + 1;
      END WHILE;
    END; //
  delimiter ;

  delimiter //
  CREATE FUNCTION calculateFreeSeats(flightnumber integer) RETURNS integer

    BEGIN
    DECLARE maximum_seats integer;
    DECLARE booked_seats integer;

    SET maximum_seats = 40;
    SET booked_seats = 0;

    SELECT COUNT(*) into booked_seats
    FROM reservation, bookingnumber
    WHERE reservation.flight = flightnumber AND reservation.reservationnumber = bookingnumber.booking
          AND bookingnumber.bookingnumber IS NOT NULL;

    RETURN maximum_seats - booked_seats;
  END; //
delimiter ;


delimiter //
CREATE FUNCTION calculatePrice(flightnumber integer) RETURNS double
  BEGIN

  DECLARE route_price integer;
  DECLARE weekday_factor double;
  DECLARE booked_passengers integer;
  DECLARE profit_factor double;

  SET booked_passengers = 40 - calculateFreeSeats(flightnumber);
  SELECT day.weekdayfactor INTO weekday_factor
  FROM weeklyschedule, flight, day
  WHERE flight.flightnumber = flightnumber
        and flight.schedule = weeklyschedule.id
        and weeklyschedule.day = day.id;


  SELECT year.profitfactor INTO profit_factor
  FROM weeklyschedule, flight, day, year
  WHERE flight.flightnumber = flightnumber
        and flight.schedule = weeklyschedule.id
        and weeklyschedule.day = day.id
        and year.year = day.year;


  SELECT route.price INTO route_price
  FROM weeklyschedule, flight, route
  WHERE flight.flightnumber = flightnumber
        and flight.schedule = weeklyschedule.id
        and weeklyschedule.route = route.id;


  RETURN round(route_price * weekday_factor * ((booked_passengers + 1)/40) * profit_factor, 3);
  END; //
delimiter ;

delimiter //
CREATE TRIGGER tg_booking
AFTER UPDATE ON booking
FOR EACH ROW
BEGIN

  Update bookingnumber
  SET bookingnumber.bookingnumber = rand()
  WHERE bookingnumber.booking = OLD.reservationnumber AND NEW.payment IS NOT NULL;

END; //
delimiter ;

delimiter //
CREATE PROCEDURE addReservation(IN departure_airport_code VARCHAR(3),
                                IN arrival_airport_code VARCHAR(3),
                                IN year integer,
                                IN week integer,
                                IN day VARCHAR(10),
                                IN time time,
                                IN number_of_passengers integer,
                                OUT output_reservation_nr integer)
  BEGIN

  DECLARE flight_id integer;
  DECLARE flight_count integer;

  SELECT count(flight.flightnumber) INTO flight_count
  FROM flight, weeklyschedule, day, route
  WHERE flight.schedule = weeklyschedule.id
        AND flight.week = week
        AND weeklyschedule.day = day.id
        AND day.year = year
        AND day.day = day
        AND weeklyschedule.route = route.id
        AND weeklyschedule.time = time
        AND route.destination = arrival_airport_code
        AND route.departure = departure_airport_code;

  SELECT flight.flightnumber INTO flight_id
  FROM flight, weeklyschedule, day, route
  WHERE flight.schedule = weeklyschedule.id
        AND flight.week = week
        AND weeklyschedule.day = day.id
        AND day.year = year
        AND day.day = day
        AND weeklyschedule.route = route.id
        AND weeklyschedule.time = time
        AND route.destination = arrival_airport_code
        AND route.departure = departure_airport_code;


  IF flight_count < 1 THEN SELECT "There exist no flight for the given route, date and time" as "Message";
  ELSEIF number_of_passengers > calculateFreeSeats(flight_id) THEN SELECT "There are not enough seats available on the chosen flight" as "Message";
  ELSE
  SET output_reservation_nr = FLOOR(RAND()*(10000+1));
  INSERT INTO reservation (reservationnumber, seats, flight) VALUES (output_reservation_nr, number_of_passengers, flight_id);
  INSERT INTO booking (reservationnumber, contact, payment) VALUES (output_reservation_nr, NULL, NULL);

  SELECT "OK result" as "Message";
  END IF;

  END; //
delimiter ;



delimiter //
CREATE PROCEDURE addPassenger(IN reservation_nr integer, IN passport_number integer, IN name VARCHAR(30))
  BEGIN
  DECLARE reservations integer;
  SELECT COUNT(reservation.reservationnumber) INTO reservations FROM reservation WHERE reservation.reservationnumber = reservation_nr;

  IF reservations < 1 THEN SELECT "The given reservation number does not exist" as "Message";
  ELSEIF (SELECT booking.payment FROM booking WHERE booking.reservationnumber = reservation_nr) IS NOT NULL
  THEN SELECT "The booking has already been payed and no futher passengers can be added" as "Message";
  ELSE
    IF (SELECT COUNT(*) from passenger WHERE passenger.passportnumber = passport_number) < 1 THEN
      INSERT INTO passenger (passportnumber, name) VALUES (passport_number, name);
    END IF;
  INSERT INTO bookingnumber (passenger, booking) VALUES (passport_number, reservation_nr);
  SELECT "OK result" as "Message";
  END IF;
  END; //
delimiter ;


delimiter //
CREATE PROCEDURE addContact(IN reservation_nr integer, IN passport_number integer, IN email VARCHAR(30), IN phone BIGINT)
BEGIN

DECLARE reservations integer;
DECLARE reserved integer;
SELECT COUNT(reservation.reservationnumber) INTO reservations FROM reservation WHERE reservation.reservationnumber = reservation_nr;

SELECT COUNT(*) INTO reserved FROM bookingnumber WHERE bookingnumber.booking = reservation_nr AND bookingnumber.passenger = passport_number;

IF reservations < 1 THEN SELECT "The given reservation number does not exist" as "Message";
ELSEIF reserved < 1 THEN SELECT "The person is not a passenger of the reservation" as "Message";
ELSE
INSERT INTO contactperson (passenger, email, phonenumber) VALUES (passport_number, email, phone);
UPDATE booking SET booking.contact = passport_number WHERE booking.reservationnumber = reservation_nr;
SELECT "OK result" as "Message";
END IF;

END; //
delimiter ;

delimiter //
CREATE PROCEDURE addPayment (IN reservation_nr integer, IN cardholder_name varchar(30), credit_card_number BIGINT)
  BEGIN
    DECLARE reservations integer;
    DECLARE flight_id integer;
    DECLARE passengers integer;

    SELECT COUNT(*) INTO passengers
    FROM bookingnumber
    WHERE bookingnumber.booking = reservation_nr;

    SELECT COUNT(booking.reservationnumber) INTO reservations
      FROM booking
      WHERE booking.reservationnumber = reservation_nr;

    SELECT reservation.flight INTO flight_id
      FROM reservation
      WHERE reservation.reservationnumber = reservation_nr;

    IF reservations < 1
      THEN SELECT "The given reservation number does not exist" as "Message";

    ELSEIF (SELECT booking.contact FROM booking WHERE booking.reservationnumber = reservation_nr) IS NULL
      THEN SELECT "The reservation has no contact yet" as "Message";
    ELSEIF (SELECT COUNT(*) FROM bookingnumber WHERE bookingnumber.booking = reservation_nr) > calculateFreeSeats(flight_id)
      THEN SELECT "There are not enough seats available on the flight anymore, deleting reservation" as "Message";

      DELETE FROM bookingnumber WHERE bookingnumber.booking = reservation_nr;
      DELETE FROM booking WHERE booking.reservationnumber = reservation_nr;
      DELETE FROM reservation WHERE reservation.reservationnumber = reservation_nr;
    ELSE
    INSERT INTO payment (cardholder, cardnumber) VALUES (cardholder_name, credit_card_number);
    UPDATE booking
    SET booking.payment = credit_card_number, booking.cost = calculatePrice(flight_id) * passengers
    WHERE booking.reservationnumber = reservation_nr;
    SELECT "OK result" as "Message";
    END IF;
  END; //

delimiter ;



CREATE VIEW allFlights AS
SELECT airport_d.name AS departure_city_name, airport_a.name AS destination_city_name,
        weeklyschedule.time AS departure_time,
        day.day AS departure_day,
        flight.week AS departure_week,
        day.year AS departure_year,
        calculateFreeSeats(flight.flightnumber) AS nr_of_free_seats,
        calculatePrice(flight.flightnumber) AS current_price_per_seat

FROM airport AS airport_d, airport AS airport_a, route, weeklyschedule,day, flight
WHERE flight.schedule = weeklyschedule.id AND
      weeklyschedule.route = route.id AND
      route.departure = airport_d.airportcode AND
      route.destination = airport_a.airportcode AND
      weeklyschedule.day = day.id;
