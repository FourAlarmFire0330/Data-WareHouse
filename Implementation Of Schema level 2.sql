----------------------------------------------------
--------   Implementation of Level-2   ----------
----------------------------------------------------

--  First Create the Dimensions
--  Creating table AIRLINE_SERVICE_DIM_v1

CREATE TABLE airline_service_dim_v1
    AS
        SELECT
            serviceid
        FROM
            opfl.airline_services;
            
--  Creating table AIRLINE_SERVICE_BRIDGE_v1

CREATE TABLE airline_service_bridge_v1
    AS
        SELECT
            *
        FROM
            opfl.provides;
            
--  Creating table AIRLINE_DIM_v1

CREATE TABLE airline_dim_v1
    AS
        SELECT
            a.airlineid,
            a.name,
            1.0 / COUNT(*) AS weight_factor,
            LISTAGG(s.serviceid,
            '_') WITHIN GROUP(
            ORDER BY
                s.serviceid
            ) AS servicegrouplist
        FROM
            airlines a,
            opfl.airline_services s,
            opfl.provides p
        WHERE
            p.airlineid = a.airlineid
            AND   p.serviceid = s.serviceid
        GROUP BY
            a.airlineid,
            a.name;
            
-- Creating table SOURCE_AIRPORT_DIM_v1

CREATE TABLE source_airport_dim_v1
    AS
        SELECT
            airportid AS sourceairportid,
            name AS sourcename,
            city AS sourcecity,
            country AS sourcecountry,
            dst AS sourcedst
        FROM
            airports;
   
-- Creating table DEST_AIRPORT_DIM_v1

CREATE TABLE dest_airport_dim_v1
    AS
        SELECT
            airportid AS destairportid,
            name AS destname,
            city AS destcity,
            country AS destcountry,
            dst AS destdst
        FROM
            airports;   
            
--  Creating table FLIGHTCLASS_DIM_v1

CREATE TABLE flightclass_dim_v1 (
    flightclassname   VARCHAR(20)
);

INSERT INTO flightclass_dim_v1 VALUES ( 'First Class' );

INSERT INTO flightclass_dim_v1 VALUES ( 'Business Class' );

INSERT INTO flightclass_dim_v1 VALUES ( 'Economy Class' );

--  Creating table FLIGHTDATE_DIM_v1

CREATE TABLE flightdate_dim_v1
    AS
        SELECT DISTINCT
            flightdate
        FROM
            flights;
        
-- Creating table FLIGHTTYPE_DIM_v1

CREATE TABLE flighttype_dim_v1 (
    flighttypename   VARCHAR(20)
);

INSERT INTO flighttype_dim_v1 VALUES ( 'Domestic' );

INSERT INTO flighttype_dim_v1 VALUES ( 'International' );

--  Creating table PASSENGER_TYPE_DIM_v1

CREATE TABLE passenger_type_dim_v1 (
    passengertype   VARCHAR(20),
    minage          NUMBER(3,0),
    maxage          NUMBER(3,0)
);

INSERT INTO passenger_type_dim_v1 VALUES (
    'Children',
    0,
    10
);

INSERT INTO passenger_type_dim_v1 VALUES (
    'Teenager',
    11,
    17
);

INSERT INTO passenger_type_dim_v1 VALUES (
    'Adult',
    18,
    60
);

INSERT INTO passenger_type_dim_v1 VALUES (
    'Elder',
    61,
    150
);
    
--  Creating table MEMBERSHIP_TYPE_DIM_v1

CREATE TABLE membership_type_dim_v1
    AS
        SELECT
            membershiptypeid,
            membershipname,
            period
        FROM
            opfl.membershiptype;
    
--  Creating table MEMBERSHIPFEE_DIM_V1

CREATE TABLE membershipfee_dim_v1
    AS
        SELECT DISTINCT
            m.membershiptypeid,
            p.startdate,
            p.enddate,
            m1.membershipfee,
            m.promotion
        FROM
            opfl.membershipjoinrecords m,
            opfl.promotion p,
            opfl.membershiptype m1
        WHERE
            m.membershiptypeid = m1.membershiptypeid
            AND   m.promotion = p.promotionid
        ORDER BY
            m.membershiptypeid;

UPDATE membershipfee_dim_v1
    SET
        membershipfee = membershipfee * ( 1 - 0.1 )
WHERE
    promotion = 'P1';

UPDATE membershipfee_dim_v1
    SET
        membershipfee = membershipfee * ( 1 - 0.15 )
WHERE
    promotion = 'P2';

UPDATE membershipfee_dim_v1
    SET
        membershipfee = membershipfee * ( 1 - 0.17 )
WHERE
    promotion = 'P3';

UPDATE membershipfee_dim_v1
    SET
        membershipfee = membershipfee * ( 1 - 0.17 )
WHERE
    promotion = 'P4';

UPDATE membershipfee_dim_v1
    SET
        membershipfee = membershipfee * ( 1 - 0.2 )
WHERE
    promotion = 'P5';

INSERT INTO membershipfee_dim_v1 VALUES (
    'M1',
    TO_DATE('01-Sep-05','dd-Mon-yy'),
    TO_DATE('31-Oct-06','dd-Mon-yy'),
    399,
    'No pro'
);

INSERT INTO membershipfee_dim_v1 VALUES (
    'M1',
    TO_DATE('01-Jun-07','dd-Mon-yy'),
    TO_DATE('29-Feb-08','dd-Mon-yy'),
    399,
    'No pro'
);

INSERT INTO membershipfee_dim_v1 VALUES (
    'M1',
    TO_DATE('01-May-08','dd-Mon-yy'),
    TO_DATE('29-Feb-12','dd-Mon-yy'),
    399,
    'No pro'
);

INSERT INTO membershipfee_dim_v1 VALUES (
    'M1',
    TO_DATE('01-May-12','dd-Mon-yy'),
    TO_DATE('31-Dec-12','dd-Mon-yy'),
    399,
    'No pro'
);

INSERT INTO membershipfee_dim_v1 VALUES (
    'M1',
    TO_DATE('01-May-13','dd-Mon-yy'),
    TO_DATE('31-Dec-14','dd-Mon-yy'),
    399,
    'No pro'
);

INSERT INTO membershipfee_dim_v1 VALUES (
    'M2',
    TO_DATE('01-Sep-05','dd-Mon-yy'),
    TO_DATE('31-Oct-06','dd-Mon-yy'),
    599,
    'No pro'
);

INSERT INTO membershipfee_dim_v1 VALUES (
    'M2',
    TO_DATE('01-Jun-07','dd-Mon-yy'),
    TO_DATE('29-Feb-08','dd-Mon-yy'),
    599,
    'No pro'
);

INSERT INTO membershipfee_dim_v1 VALUES (
    'M2',
    TO_DATE('01-May-08','dd-Mon-yy'),
    TO_DATE('29-Feb-12','dd-Mon-yy'),
    599,
    'No pro'
);

INSERT INTO membershipfee_dim_v1 VALUES (
    'M2',
    TO_DATE('01-May-12','dd-Mon-yy'),
    TO_DATE('31-Dec-12','dd-Mon-yy'),
    599,
    'No pro'
);

INSERT INTO membershipfee_dim_v1 VALUES (
    'M2',
    TO_DATE('01-May-13','dd-Mon-yy'),
    TO_DATE('31-Dec-14','dd-Mon-yy'),
    599,
    'No pro'
);

INSERT INTO membershipfee_dim_v1 VALUES (
    'M3',
    TO_DATE('01-Sep-05','dd-Mon-yy'),
    TO_DATE('31-Oct-06','dd-Mon-yy'),
    799,
    'No pro'
);

INSERT INTO membershipfee_dim_v1 VALUES (
    'M3',
    TO_DATE('01-Jun-07','dd-Mon-yy'),
    TO_DATE('29-Feb-08','dd-Mon-yy'),
    799,
    'No pro'
);

INSERT INTO membershipfee_dim_v1 VALUES (
    'M3',
    TO_DATE('01-May-08','dd-Mon-yy'),
    TO_DATE('29-Feb-12','dd-Mon-yy'),
    799,
    'No pro'
);

INSERT INTO membershipfee_dim_v1 VALUES (
    'M3',
    TO_DATE('01-May-12','dd-Mon-yy'),
    TO_DATE('31-Dec-12','dd-Mon-yy'),
    799,
    'No pro'
);

INSERT INTO membershipfee_dim_v1 VALUES (
    'M3',
    TO_DATE('01-May-13','dd-Mon-yy'),
    TO_DATE('31-Dec-14','dd-Mon-yy'),
    799,
    'No pro'
);

INSERT INTO membershipfee_dim_v1 VALUES (
    'M4',
    TO_DATE('01-Sep-05','dd-Mon-yy'),
    TO_DATE('31-Oct-06','dd-Mon-yy'),
    999,
    'No pro'
);

INSERT INTO membershipfee_dim_v1 VALUES (
    'M4',
    TO_DATE('01-Jun-07','dd-Mon-yy'),
    TO_DATE('29-Feb-08','dd-Mon-yy'),
    999,
    'No pro'
);

INSERT INTO membershipfee_dim_v1 VALUES (
    'M4',
    TO_DATE('01-May-08','dd-Mon-yy'),
    TO_DATE('29-Feb-12','dd-Mon-yy'),
    999,
    'No pro'
);

INSERT INTO membershipfee_dim_v1 VALUES (
    'M4',
    TO_DATE('01-May-12','dd-Mon-yy'),
    TO_DATE('31-Dec-12','dd-Mon-yy'),
    999,
    'No pro'
);

INSERT INTO membershipfee_dim_v1 VALUES (
    'M4',
    TO_DATE('01-May-13','dd-Mon-yy'),
    TO_DATE('31-Dec-14','dd-Mon-yy'),
    999,
    'No pro'
);

-- Creating table MEMBERSHIPJOINDATE_DIM_v1

CREATE TABLE membershipjoindate_dim_v1
    AS
        SELECT DISTINCT
            joindate
        FROM
            opfl.membershipjoinrecords;

--  Creating table ROUTE_FACT_v1

DROP TABLE route_fact_v1 PURGE;

CREATE TABLE route_fact_v1
    AS
        SELECT
            sourceairportid,
            destairportid,
            airlineid,
            COUNT(routeid) AS total_num_of_routes,
            SUM(distance) AS total_distance,
            SUM(servicecost) AS total_service_cost
        FROM
            routes
        GROUP BY
            sourceairportid,
            destairportid,
            airlineid;
            
--  Creating table TRANSACTION_TEMPFACT_v1

CREATE TABLE transaction_tempfact_v1
    AS
        SELECT
            r1.sourceairportid,
            r1.destairportid,
            a2.country AS sourcecountry,
            a3.country AS destcountry,
            a1.airlineid,
            f.flightdate,
            p.age,
            f.fare,
            t.totalpaid,
            t.passid
        FROM
            routes r1,
            flights f,
            transactions t,
            passengers p,
            airlines a1,
            airports a2,
            airports a3
        WHERE
            r1.routeid = f.routeid
            AND   t.passid = p.passid
            AND   t.flightid = f.flightid
            AND   r1.airlineid = a1.airlineid
            AND   r1.sourceairportid = a2.airportid
            AND   r1.destairportid = a3.airportid;

ALTER TABLE transaction_tempfact_v1 ADD flightclassname VARCHAR(20);

UPDATE transaction_tempfact_v1
    SET
        flightclassname = 'First Class'
WHERE
    totalpaid >= 2 * fare;

UPDATE transaction_tempfact_v1
    SET
        flightclassname = 'Business Class'
WHERE
    totalpaid >= 1.5 * fare
    AND   totalpaid < 2 * fare;

UPDATE transaction_tempfact_v1
    SET
        flightclassname = 'Economy Class'
WHERE
    totalpaid < 1.5 * fare;

ALTER TABLE transaction_tempfact_v1 ADD flighttypename VARCHAR(20);

UPDATE transaction_tempfact_v1
    SET
        flighttypename = 'Domestic'
WHERE
    sourcecountry = destcountry;

UPDATE transaction_tempfact_v1
    SET
        flighttypename = 'International'
WHERE
    sourcecountry != destcountry;

ALTER TABLE transaction_tempfact_v1 ADD passengertype VARCHAR(20);

UPDATE transaction_tempfact_v1
    SET
        passengertype = 'Children'
WHERE
    age >= 0
    AND   age < 11;

UPDATE transaction_tempfact_v1
    SET
        passengertype = 'Teenager'
WHERE
    age >= 11
    AND   age <= 17;

UPDATE transaction_tempfact_v1
    SET
        passengertype = 'Adult'
WHERE
    age >= 18
    AND   age <= 60;

UPDATE transaction_tempfact_v1
    SET
        passengertype = 'Elder'
WHERE
    age > 60
    AND   age < 150;

--  Creating table TRANSACTION_FACT_v1

CREATE TABLE transaction_fact_v1
    AS
        SELECT
            sourceairportid,
            destairportid,
            airlineid,
            passengertype,
            flightdate,
            flightclassname,
            flighttypename,
            ( SUM(totalpaid) - SUM(fare) ) AS total_agent_profit,
            COUNT(passid) AS total_num_of_pass,
            SUM(age) AS total_pass_age,
            SUM(totalpaid) AS total_paid
        FROM
            transaction_tempfact_v1
        GROUP BY
            sourceairportid,
            destairportid,
            airlineid,
            passengertype,
            flightdate,
            flightclassname,
            flighttypename;
            
--  Creating table MEMBERSHIPSALES_TEMPFACT_v1

CREATE TABLE membershipsales_tempfact_v1
    AS
        SELECT
            j.membershiptypeid,
            p1.age,
            j.joindate,
            ( 1 - nvl(p.discount,0) ) * t.membershipfee AS paid
        FROM
            opfl.membershipjoinrecords j
            LEFT JOIN opfl.promotion p ON p.promotionid = j.promotion
            JOIN opfl.membershiptype t ON j.membershiptypeid = t.membershiptypeid
            JOIN passengers p1 ON j.passid = p1.passid;

ALTER TABLE membershipsales_tempfact_v1 ADD passengertype VARCHAR(20);

UPDATE membershipsales_tempfact_v1
    SET
        passengertype = 'Children'
WHERE
    age >= 0
    AND   age < 11;

UPDATE membershipsales_tempfact_v1
    SET
        passengertype = 'Teenager'
WHERE
    age >= 11
    AND   age <= 17;

UPDATE membershipsales_tempfact_v1
    SET
        passengertype = 'Adult'
WHERE
    age >= 18
    AND   age <= 60;

UPDATE membershipsales_tempfact_v1
    SET
        passengertype = 'Elder'
WHERE
    age > 60
    AND   age < 150;

--  Creating table MembershipSales_fact_v1  --

CREATE TABLE membershipsales_fact_v1
    AS
        SELECT
            membershiptypeid,
            passengertype,
            joindate,
            SUM(paid) AS total_sales,
            COUNT(*) AS total_num_of_sales
        FROM
            membershipsales_tempfact_v1
        GROUP BY
            membershiptypeid,
            passengertype,
            joindate;
