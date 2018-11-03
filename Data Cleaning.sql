------------------Data Cleaning-------------------
-----------------Explore the table that will be used to create the data warehouse first---------
-----------------excute data cleaing-------------
----------Explore table OPFL.AIRPORTS to find the illegal airportid---------
SELECT
    *
FROM
    opfl.airports
WHERE
    airportid < 0;

----------Delete the data where the airportid below zero------

CREATE TABLE airports
    AS
        SELECT
            *
        FROM
            opfl.airports
        WHERE
            airportid > 0;
            
----------Explore table OPFL.AIRLINES to find the illegal airlineid---------          

SELECT
    *
FROM
    opfl.airlines
WHERE
    airlineid < 0;
            
-----------Delete the data where the airlineid below zero--------

CREATE TABLE airlines
    AS
        SELECT
            *
        FROM
            opfl.airlines
        WHERE
            airlineid > 0;

----------Explore table OPFL.ROUTES to find the illegal routeid---------

SELECT
    *
FROM
    opfl.routes
WHERE
    routeid < 0;
            
-------------Delete the data where the routeid below zero--------

CREATE TABLE routes
    AS
        SELECT
            *
        FROM
            opfl.routes
        WHERE
            routeid > 0;


----------Explore table OPFL.FLIGHTS to find the illegal flightid or fare---------

SELECT
    *
FROM
    opfl.flights
WHERE
    fare < 0;

-------------Delete the illegal fare in table OPFL.FLIGHTS--------------

CREATE TABLE flights
    AS
        SELECT
            *
        FROM
            opfl.flights
        WHERE
            fare >= 0;


----------Explore table OPFL.TRANSACTION to find the illegal FLIGHT---------

SELECT
    *
FROM
    opfl.transactions
WHERE
    flightid NOT IN (
        SELECT
            flightid
        FROM
            opfl.flights
    );

---------------Delete the ghost flight in table transactions-----------------

CREATE TABLE transactions
    AS
        SELECT
            *
        FROM
            opfl.transactions
        WHERE
            flightid IN (
                SELECT
                    flightid
                FROM
                    opfl.flights
            );

----------Explore table OPFL.PASSENGERS to find the illegal AGE---------

SELECT
    *
FROM
    opfl.passengers
WHERE
    age < 0;         
            
----------------Delete the passengers whose age is below zero-------------

CREATE TABLE passengers
    AS
        SELECT
            *
        FROM
            opfl.passengers
        WHERE
            age >= 0;
            
-------------------Explore table OPFL.Promotions to find the illegal Discount (No Problem) -----------

SELECT
    *
FROM
    opfl.promotion
WHERE
    discount < 0;
    
------------------Explore table OPFL.MEMBERSHIPTYPE to find the illegal MEMBERSHIPFEE (No Problem)------------

SELECT
    *
FROM
    opfl.membershiptype
WHERE
    membershipfee < 0;