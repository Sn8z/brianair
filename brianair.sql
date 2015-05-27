/*
	Reset the db
*/
DROP DATABASE IF EXISTS brianair;
CREATE DATABASE brianair;
USE brianair;

/*
	Create tables
*/

CREATE TABLE City
(
	id INT NOT NULL AUTO_INCREMENT,
	name VARCHAR(32),
	PRIMARY KEY(id)
);

CREATE TABLE Route
(
	id INT NOT NULL AUTO_INCREMENT,
	year INT NOT NULL,
	price INT NOT NULL,
	start INT NOT NULL,
	destination INT NOT NULL,
	PRIMARY KEY(id),
	FOREIGN KEY(start) REFERENCES City(id),
	FOREIGN KEY(destination) REFERENCES City(id)
);

CREATE TABLE WeeklyFlight
(
	id INT NOT NULL AUTO_INCREMENT,
	departure_time TIMESTAMP NOT NULL,
	weekday VARCHAR(32) NOT NULL,
	route INT NOT NULL,
	PRIMARY KEY(id),
	FOREIGN KEY(route) REFERENCES Route(id)
);

CREATE TABLE Flight
(
	id INT NOT NULL AUTO_INCREMENT,
	month INT NOT NULL,
	day INT NOT NULL,
	weekly_flight INT NOT NULL,
	PRIMARY KEY(id),
	FOREIGN KEY(weekly_flight) REFERENCES WeeklyFlight(id)
);

CREATE TABLE ProfitFactor
(
	day VARCHAR(32) NOT NULL,
	year INT NOT NULL,
	factor DOUBLE NOT NULL,
	PRIMARY KEY(day, year)
);

CREATE TABLE Passenger
(
	ssn BIGINT NOT NULL,
	fname VARCHAR(32) NOT NULL,
	lname VARCHAR(32) NOT NULL,
	PRIMARY KEY(ssn)
);

CREATE TABLE Contact
(
	id BIGINT NOT NULL,
	email VARCHAR(50) NOT NULL,
	phone BIGINT NOT NULL,
	PRIMARY KEY(id),
	FOREIGN KEY(id) REFERENCES Passenger(ssn)
);

CREATE TABLE PaymentInfo
(
	cc_number BIGINT NOT NULL,
	cc_holder VARCHAR(32) NOT NULL,
	expiration_date TIMESTAMP NOT NULL,
	PRIMARY KEY(cc_number)
);

CREATE TABLE Reservation
(
	id INT NOT NULL AUTO_INCREMENT,
	nr_of_passengers INT NOT NULL,
	flight INT NOT NULL,
	contact BIGINT NOT NULL,
	payment_info BIGINT NOT NULL,
	PRIMARY KEY(id),
	FOREIGN KEY(flight) REFERENCES Flight(id),
	FOREIGN KEY(contact) REFERENCES Contact(id),
	FOREIGN KEY(payment_info) REFERENCES PaymentInfo(cc_number)
);

CREATE TABLE Ticket
(
	reservation INT NOT NULL,
	passenger BIGINT NOT NULL,
	ticket VARCHAR(32) NOT NULL UNIQUE,
	PRIMARY KEY(reservation, passenger),
	FOREIGN KEY(reservation) REFERENCES Reservation(id),
	FOREIGN KEY(passenger) REFERENCES Passenger(ssn)
);

/*
	Setup procedures
*/

DELIMITER //

/* for testing purpose (remove later) */
CREATE PROCEDURE get_passengers()
BEGIN
	SELECT * FROM Passenger;
END //

CREATE PROCEDURE create_reservation(flight INT)
BEGIN
	INSERT INTO Reservation(flight)
	VALUES(flight);
END //

CREATE PROCEDURE add_passenger(reservation INT, ssn BIGINT, fname VARCHAR(32), lname VARCHAR(32), OUT passenger BIGINT)
BEGIN
	INSERT INTO Passenger(ssn, fname, lname)
	VALUES(ssn, fname, lname);
	SET passenger = ssn;
END //

DELIMITER ;

/*
	Setup triggers
*/

/*
	Insert some data
*/

INSERT INTO ProfitFactor(day, year, factor)
VALUES
	("Monday", 2015, 1),
	("Tuesday", 2015, 1),
	("Wednesday", 2015, 1),
	("Thursday", 2015, 1),
	("Friday", 2015, 1.5),
	("Saturday", 2015, 2),
	("Sunday", 2015, 1.5),
	("Monday", 2016, 1.2),
	("Tuesday", 2016, 1.2),
	("Wednesday", 2016, 1.2),
	("Thursday", 2016, 1.2),
	("Friday", 2016, 1.8),
	("Saturday", 2016, 2.3),
	("Sunday", 2016, 2);

INSERT INTO City(name)
VALUES
	("Linköping"),
	("Jönköping"),
	("Stockholm"),
	("Malmö"),
	("Göteborg"),
	("Uppsala");

INSERT INTO Route(year, price, start, destination)
VALUES
	(
		2015,
		800,
		(SELECT id FROM City WHERE name LIKE "Jönköping"),
		(SELECT id FROM City WHERE name LIKE "Linköping")		
	),
	(
		2015,
		1000,
		(SELECT id FROM City WHERE name LIKE "Uppsala"),
		(SELECT id FROM City WHERE name LIKE "Linköping")		
	),
	(
		2016,
		800,
		(SELECT id FROM City WHERE name LIKE "Göteborg"),
		(SELECT id FROM City WHERE name LIKE "Jönköping")		
	);

INSERT INTO Passenger(ssn, fname, lname)
VALUES
	(9205225031, "Marcus", "Sneitz"),
	(9202191780, "Elin", "Arvidsson"),
	(9407020016, "Erik", "Sneitz");

