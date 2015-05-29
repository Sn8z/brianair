SET AUTOCOMMIT = 0;
START TRANSACTION;
LOCK TABLES Reservation WRITE;
CALL create_reservation(1, 2, @res);
UNLOCK TABLES;
COMMIT;
START TRANSACTION;
LOCK TABLES Passenger WRITE, Ticket WRITE, Reservation READ;
CALL add_passenger(@res ,9407021337,"Heriku","Sneitz", @pass);
CALL add_passenger(@res,9205221337,"Mac","Sneitz", @pass);
CALL add_passenger(@res,9205221338,"Fail","Failure", @pass);
UNLOCK TABLES;
COMMIT;

START TRANSACTION;
LOCK TABLES Reservation WRITE;
CALL create_reservation(1, 2, @res);
UNLOCK TABLES;
COMMIT;

START TRANSACTION;
LOCK TABLES 
Passenger WRITE,
Ticket WRITE,
Reservation WRITE,
PaymentInfo WRITE,
Contact WRITE;
CALL add_passenger(@res ,9407020016,"Erik","Sneitz", @pass);
CALL add_passenger(@res,9205221337,"Mac","Sneitz", @pass);
CALL add_contact(@res, @pass, "lol@lol.com", 1337);
UNLOCK TABLES;
COMMIT;
START TRANSACTION;
LOCK TABLES
PaymentInfo WRITE,
ProfitFactor READ,
Route AS route1 READ,
Route AS route2 READ,
Reservation WRITE,
Reservation AS r1 WRITE,
Reservation AS r2 WRITE,
Reservation AS r3 WRITE,
Reservation AS r4 WRITE,
WeeklyFlight READ,
WeeklyFlight AS wf1 READ,
WeeklyFlight AS wf2 READ,
WeeklyFlight AS wf3 READ,
Flight AS f1 READ,
Flight AS f2 READ,
Flight AS f3 READ,
Ticket WRITE;
CALL add_payment(@res, 1337127688103333, "Erik Sneitz", 5, 12);
UNLOCK TABLES;
COMMIT;
/*
CALL create_reservation(1, 2, @res);
CALL add_passenger(@res ,94070201116,"Test","Sneitz", @pass);
CALL add_passenger(@res,920522123,"Test2","Sneitz", @pass);
CALL add_contact(@res, @pass, "lol@lol.com", 1337);
CALL add_payment(@res, 1337127688103333, "Erik Sneitz", 5, 12);

CALL create_reservation(1, 2, @res);
CALL add_passenger(@res ,9407020017,"Erik","Sneitz", @pass);
CALL add_passenger(@res,9205225032,"Marcus","Sneitz", @pass);
CALL add_contact(@res, @pass, "lol@lol.com", 1337);
CALL add_payment(@res, 13371276234203333, "Erik Sneitz", 5, 12);

CALL create_reservation(1, 30, @res);
*/
START TRANSACTION;
CALL search(5,31,5,"Jönköping","Linköping");
COMMIT;

SET @available_seats = check_available_seats(1);
SELECT @available_seats;
SET @booked_seats = occupied_seats(1);
SELECT @booked_seats;
SET @price = calc_price(1,3);
SELECT @price;
