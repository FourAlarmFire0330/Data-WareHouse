---------------------------Report 1 ----------------
--------- What is the top 3 average ages of passengers traveling on business class from an Australian airport? ----------------------------
SELECT
    *
FROM
    (
        SELECT
            t.flight_class,
            t.sourceairportid,
            a.country,
            round(SUM(t.total_age) / SUM(t.total_num_of_pass) ) AS avg_age,
            RANK() OVER(
                ORDER BY
                    round(SUM(t.total_age) / SUM(t.total_num_of_pass) ) DESC
            ) AS age_rank
        FROM
            transaction_fact_v2 t,
            airport_dim_v2 a
        WHERE
            t.sourceairportid = a.airportid
            AND   a.country = 'Australia'
            AND   flight_class = 'Business class'
        GROUP BY
            t.flight_class,
            t.sourceairportid,
            a.country
    )
WHERE
    age_rank <= 3;
    


---------------------------Report 2----------------------------
-------------- What is the total number of newly joined gold membership for Adults passenger in each month? ------------

SELECT
    m.membershipname,
    TO_CHAR(t.joindate,'mm') AS joindate,
    p.pass_type,
    SUM(t.total_num_of_sales) AS total_num_sales
FROM
    membershipsales_fact_v2 t,
    membership_type_dim_v2 m,
    passenger_dim_v2 p
WHERE
    t.membershiptypeid = m.membershiptypeid
    AND   p.passid = t.passid
    AND   p.pass_type = 'Adult'
    AND   m.membershipname = 'Gold'
GROUP BY
    m.membershipname,
    TO_CHAR(t.joindate,'mm'),
    p.pass_type
ORDER BY
    TO_CHAR(t.joindate,'mm');



---------------------------Report 3----------------------------

SELECT
    TO_CHAR(f1.flightdate,'yyyy') AS flight_year,
    DECODE(GROUPING(f2.flighttypename),1,'Any Types',f2.flighttypename) AS flight_type,
    DECODE(GROUPING(f3.flightclassname),1,'Any Class',f3.flightclassname) AS flight_class,
    DECODE(GROUPING(s1.sourcecountry),1,'Any SourceCountry',s1.sourcecountry) AS source_country,
    DECODE(GROUPING(d1.destcountry),1,'Any DestCountry',d1.destcountry) AS dest_country,
    COUNT(*) AS num_of_transaction,
    round(AVG(t1.total_agent_profit),2) AS average_agent_profit
FROM
    transaction_fact_v1 t1,
    flightdate_dim_v1 f1,
    flighttype_dim_v1 f2,
    flightclass_dim_v1 f3,
    source_airport_dim_v1 s1,
    dest_airport_dim_v1 d1
WHERE
    t1.sourceairportid = s1.sourceairportid
    AND   t1.destairportid = d1.destairportid
    AND   t1.flightdate = f1.flightdate
    AND   t1.flighttypename = f2.flighttypename
    AND   t1.flightclassname = f3.flightclassname
GROUP BY
    TO_CHAR(f1.flightdate,'yyyy'),
    CUBE(f2.flighttypename,
    f3.flightclassname,
    s1.sourcecountry,
    d1.destcountry)
ORDER BY
    TO_CHAR(f1.flightdate,'yyyy') ASC;




---------------------------Report 4----------------------------
-------------- What are the sub-total and total agent profits of airports and airlines? ------------

SELECT
    DECODE(GROUPING(a1.name),1,'All Airlines',a1.name) AS airlines,
    DECODE(GROUPING(s1.sourcename),1,'All Airports',s1.sourcename) AS airports,
    SUM(f1.total_agent_profit) AS total_profit
FROM
    transaction_fact_v1 f1,
    airline_dim_v1 a1,
    SOURCE_AIRPORT_DIM_V1 s1
WHERE
    f1.airlineid = a1.airlineid
    AND   f1.SOURCEAIRPORTID = s1.SOURCEAIRPORTID
GROUP BY
    CUBE(a1.name,
    s1.sourcename)
ORDER BY
    a1.name,
    s1.sourcename ASC;



---------------------------Report 5----------------------------
-------------- What are the total and cumulative monthly total sales of Gold membership in 2009? ------------

SELECT
    m2.membershipname,
    TO_CHAR(m4.joindate,'yyyy') AS sale_year,
    TO_CHAR(m4.joindate,'mm') AS sale_month,
    TO_CHAR(AVG(SUM(m1.total_sales) ) OVER(
        ORDER BY
            m2.membershipname,
            TO_CHAR(m4.joindate,'yyyy'),
            TO_CHAR(m4.joindate,'mm')
        ROWS 2 PRECEDING
    ),'9,999,999,999') AS monthly_sale,
    TO_CHAR(SUM(SUM(m1.total_sales) ) OVER(
        ORDER BY
            m2.membershipname,
            TO_CHAR(m4.joindate,'yyyy'),
            TO_CHAR(m4.joindate,'mm')
        ROWS UNBOUNDED PRECEDING
    ),'9,999,999,999') AS cumulative_total_sale
FROM
    membershipsales_fact_v1 m1,
    membership_type_dim_v1 m2,
    membershipjoindate_dim_v1 m4
WHERE
    m1.membershiptypeid = m2.membershiptypeid
    AND   m1.joindate = m4.joindate
    AND   TO_CHAR(m4.joindate,'yyyy') = 2009
    AND   m2.membershipname = 'Gold'
GROUP BY
    m2.membershipname,
    TO_CHAR(m4.joindate,'yyyy'),
    TO_CHAR(m4.joindate,'mm');




---------------------------Report 6----------------------------
-------------- What are the city ranks by total number of incoming routes in each country? ------------

SELECT
    d1.destcountry AS country,
    d1.destcity AS city,
    SUM(r1.total_num_of_routes) AS num_of_incoming_routes,
    RANK() OVER(
        PARTITION BY d1.destcountry
        ORDER BY
            SUM(r1.total_num_of_routes) DESC
    ) AS rank_by_incoming_routes
FROM
    route_fact_v1 r1,
    dest_airport_dim_v1 d1
WHERE
    r1.destairportid = d1.destairportid
GROUP BY
    d1.destcountry,
    d1.destcity;




