-- Materialize KPIs

-- 1. KPI — Airline Performance

CREATE TABLE kpi_airline_performance AS
SELECT
    a.airline_id,
    a.airline_code,

    SUM(f.total_flights) AS total_flights,

    ROUND(
        SUM(f.avg_arr_delay * f.total_flights) / SUM(f.total_flights),
        2
    ) AS weighted_avg_arr_delay,

    ROUND(
        SUM(f.avg_dep_delay * f.total_flights) / SUM(f.total_flights),
        2
    ) AS weighted_avg_dep_delay,

    SUM(f.cancelled_flights) AS cancelled_flights,
    SUM(f.diverted_flights) AS diverted_flights,

    ROUND(
        SUM(f.cancelled_flights) / SUM(f.total_flights) * 100,
        2
    ) AS cancellation_rate_pct,

    ROUND(
        SUM(f.diverted_flights) / SUM(f.total_flights) * 100,
        2
    ) AS diversion_rate_pct

FROM flights_fact_daily f
JOIN airlines_dim a
  ON f.airline_id = a.airline_id
GROUP BY a.airline_id, a.airline_code;


-- 2. KPI — Route Performance

CREATE TABLE kpi_route_performance AS
SELECT
    ao.airport_code AS origin,
    ad.airport_code AS destination,

    SUM(f.total_flights) AS total_flights,

    ROUND(
        SUM(f.avg_arr_delay * f.total_flights) / SUM(f.total_flights),
        2
    ) AS weighted_avg_arr_delay,

    ROUND(
        SUM(f.cancelled_flights) / SUM(f.total_flights) * 100,
        2
    ) AS cancellation_rate_pct

FROM flights_fact_daily f
JOIN airports_dim ao ON f.origin_airport_id = ao.airport_id
JOIN airports_dim ad ON f.dest_airport_id = ad.airport_id
GROUP BY ao.airport_code, ad.airport_code;

-- 3. KPI — Airport Performance

CREATE TABLE kpi_airport_performance AS
SELECT
    ao.airport_code AS airport,

    SUM(f.total_flights) AS total_flights,

    ROUND(
        SUM(f.avg_arr_delay * f.total_flights) / SUM(f.total_flights),
        2
    ) AS weighted_avg_arr_delay,

    ROUND(
        SUM(f.cancelled_flights) / SUM(f.total_flights) * 100,
        2
    ) AS cancellation_rate_pct

FROM flights_fact_daily f
JOIN airports_dim ao
  ON f.origin_airport_id = ao.airport_id
GROUP BY ao.airport_code;

-- 4. KPI — Monthly Trends (Time Series)

CREATE TABLE kpi_monthly_trends AS
SELECT
    year,
    month,
    airline_id,

    SUM(total_flights) AS total_flights,

    ROUND(
        SUM(avg_arr_delay * total_flights) / SUM(total_flights),
        2
    ) AS avg_arr_delay

FROM flights_fact_monthly
GROUP BY year, month, airline_id;