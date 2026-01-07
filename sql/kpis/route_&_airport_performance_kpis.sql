-- ============================================================
-- Route & Airport Performance KPIs
-- Dataset: US Airline On-Time Performance (1987–2008)
-- Author: Adnan Momin
-- Tables:
--   flights_fact_daily   (33M+ rows)
--   flights_fact_monthly
-- ============================================================

USE airline_analytics;

-- ------------------------------------------------------------
-- KPI 1 — Busiest Routes (By Flight Volume)
-- ------------------------------------------------------------
SELECT
    ao.airport_code AS origin,
    ad.airport_code AS destination,
    SUM(f.total_flights) AS total_flights
FROM flights_fact_daily f
JOIN airports_dim ao ON f.origin_airport_id = ao.airport_id
JOIN airports_dim ad ON f.dest_airport_id   = ad.airport_id
GROUP BY ao.airport_code, ad.airport_code
ORDER BY total_flights DESC
LIMIT 20;

-- ------------------------------------------------------------
-- KPI 2 — Most Delayed Routes (Weighted Arrival Delay)
-- ------------------------------------------------------------
SELECT
    ao.airport_code AS origin,
    ad.airport_code AS destination,
    ROUND(
        SUM(f.avg_arr_delay * f.total_flights)
        / NULLIF(SUM(f.total_flights), 0),
        2
    ) AS weighted_avg_arr_delay,
    SUM(f.total_flights) AS total_flights
FROM flights_fact_daily f
JOIN airports_dim ao ON f.origin_airport_id = ao.airport_id
JOIN airports_dim ad ON f.dest_airport_id   = ad.airport_id
GROUP BY ao.airport_code, ad.airport_code
HAVING SUM(f.total_flights) > 100000
ORDER BY weighted_avg_arr_delay DESC
LIMIT 20;

-- ------------------------------------------------------------
-- KPI 3 — Route Reliability (Cancellation Rate)
-- ------------------------------------------------------------
SELECT
    ao.airport_code AS origin,
    ad.airport_code AS destination,
    ROUND(
        SUM(f.cancelled_flights)
        / NULLIF(SUM(f.total_flights), 0) * 100,
        2
    ) AS cancellation_rate_pct,
    SUM(f.total_flights) AS total_flights
FROM flights_fact_daily f
JOIN airports_dim ao ON f.origin_airport_id = ao.airport_id
JOIN airports_dim ad ON f.dest_airport_id   = ad.airport_id
GROUP BY ao.airport_code, ad.airport_code
HAVING SUM(f.total_flights) > 50000
ORDER BY cancellation_rate_pct DESC
LIMIT 20;

-- ------------------------------------------------------------
-- KPI 4 — Busiest Airports (Departures)
-- ------------------------------------------------------------
SELECT
    ao.airport_code AS airport,
    SUM(f.total_flights) AS departing_flights
FROM flights_fact_daily f
JOIN airports_dim ao ON f.origin_airport_id = ao.airport_id
GROUP BY ao.airport_code
ORDER BY departing_flights DESC
LIMIT 20;

-- ------------------------------------------------------------
-- KPI 5 — Worst Airports by Arrival Delay
-- ------------------------------------------------------------
SELECT
    ad.airport_code AS airport,
    ROUND(
        SUM(f.avg_arr_delay * f.total_flights)
        / NULLIF(SUM(f.total_flights), 0),
        2
    ) AS weighted_avg_arr_delay,
    SUM(f.total_flights) AS total_flights
FROM flights_fact_daily f
JOIN airports_dim ad ON f.dest_airport_id = ad.airport_id
GROUP BY ad.airport_code
HAVING SUM(f.total_flights) > 100000
ORDER BY weighted_avg_arr_delay DESC
LIMIT 20;

-- ------------------------------------------------------------
-- KPI 6 — Airport Reliability (Cancellation Rate)
-- ------------------------------------------------------------
SELECT
    ao.airport_code AS airport,
    ROUND(
        SUM(f.cancelled_flights)
        / NULLIF(SUM(f.total_flights), 0) * 100,
        2
    ) AS cancellation_rate_pct,
    SUM(f.total_flights) AS total_flights
FROM flights_fact_daily f
JOIN airports_dim ao ON f.origin_airport_id = ao.airport_id
GROUP BY ao.airport_code
HAVING SUM(f.total_flights) > 100000
ORDER BY cancellation_rate_pct DESC
LIMIT 20;
