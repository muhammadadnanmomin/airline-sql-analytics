-- ============================================================
-- Airline Performance KPIs
-- Dataset: US Airline On-Time Performance (1987–2008)
-- Author: Adnan Momin
-- Tables:
--   flights_fact_daily   (33M+ rows)
--   flights_fact_monthly
-- ============================================================

USE airline_analytics;

-- ------------------------------------------------------------
-- KPI 1 — Total Flights by Airline (Overall Ranking)
-- ------------------------------------------------------------
SELECT
    a.airline_code,
    SUM(f.total_flights) AS total_flights
FROM flights_fact_daily f
JOIN airlines_dim a
  ON f.airline_id = a.airline_id
GROUP BY a.airline_code
ORDER BY total_flights DESC
LIMIT 10;

-- ------------------------------------------------------------
-- KPI 2 — Weighted Average Departure Delay by Airline
-- (Avoids averaging averages)
-- ------------------------------------------------------------
SELECT
    a.airline_code,
    ROUND(
        SUM(f.avg_dep_delay * f.total_flights)
        / NULLIF(SUM(f.total_flights), 0),
        2
    ) AS weighted_avg_dep_delay
FROM flights_fact_daily f
JOIN airlines_dim a
  ON f.airline_id = a.airline_id
GROUP BY a.airline_code
ORDER BY weighted_avg_dep_delay ASC;

-- ------------------------------------------------------------
-- KPI 3 — Weighted Average Arrival Delay by Airline
-- ------------------------------------------------------------
SELECT
    a.airline_code,
    ROUND(
        SUM(f.avg_arr_delay * f.total_flights)
        / NULLIF(SUM(f.total_flights), 0),
        2
    ) AS weighted_avg_arr_delay
FROM flights_fact_daily f
JOIN airlines_dim a
  ON f.airline_id = a.airline_id
GROUP BY a.airline_code
ORDER BY weighted_avg_arr_delay ASC;

-- ------------------------------------------------------------
-- KPI 4 — Cancellation Rate by Airline (%)
-- ------------------------------------------------------------
SELECT
    a.airline_code,
    ROUND(
        SUM(f.cancelled_flights)
        / NULLIF(SUM(f.total_flights), 0) * 100,
        2
    ) AS cancellation_rate_pct
FROM flights_fact_daily f
JOIN airlines_dim a
  ON f.airline_id = a.airline_id
GROUP BY a.airline_code
ORDER BY cancellation_rate_pct DESC;

-- ------------------------------------------------------------
-- KPI 5 — Diversion Rate by Airline (%)
-- ------------------------------------------------------------
SELECT
    a.airline_code,
    ROUND(
        SUM(f.diverted_flights)
        / NULLIF(SUM(f.total_flights), 0) * 100,
        2
    ) AS diversion_rate_pct
FROM flights_fact_daily f
JOIN airlines_dim a
  ON f.airline_id = a.airline_id
GROUP BY a.airline_code
ORDER BY diversion_rate_pct DESC;

-- ------------------------------------------------------------
-- KPI 6 — Composite Airline Performance Score
-- (Lower score = better performance)
-- ------------------------------------------------------------
SELECT
    a.airline_code,

    ROUND(
        SUM(f.avg_arr_delay * f.total_flights)
        / NULLIF(SUM(f.total_flights), 0),
        2
    ) AS weighted_avg_arr_delay,

    ROUND(
        SUM(f.cancelled_flights)
        / NULLIF(SUM(f.total_flights), 0) * 100,
        2
    ) AS cancellation_pct,

    ROUND(
        SUM(f.diverted_flights)
        / NULLIF(SUM(f.total_flights), 0) * 100,
        2
    ) AS diversion_pct,

    ROUND(
        (
            SUM(f.avg_arr_delay * f.total_flights)
            / NULLIF(SUM(f.total_flights), 0)
        )
        + (SUM(f.cancelled_flights)
           / NULLIF(SUM(f.total_flights), 0) * 100 * 2)
        + (SUM(f.diverted_flights)
           / NULLIF(SUM(f.total_flights), 0) * 100 * 3),
        2
    ) AS performance_score

FROM flights_fact_daily f
JOIN airlines_dim a
  ON f.airline_id = a.airline_id
GROUP BY a.airline_code
ORDER BY performance_score ASC;

-- ------------------------------------------------------------
-- KPI 7 — Airline Delay Trend Over Time (Monthly)
-- ------------------------------------------------------------
SELECT
    m.year,
    m.month,
    a.airline_code,
    ROUND(m.avg_arr_delay, 2) AS avg_arr_delay
FROM flights_fact_monthly m
JOIN airlines_dim a
  ON m.airline_id = a.airline_id
WHERE a.airline_code = 'AA'
ORDER BY m.year, m.month;

-- ------------------------------------------------------------
-- KPI 8 — Best & Worst Airlines (Filtered by Volume)
-- ------------------------------------------------------------
SELECT
    a.airline_code,
    SUM(f.total_flights) AS total_flights,
    ROUND(
        SUM(f.avg_arr_delay * f.total_flights)
        / NULLIF(SUM(f.total_flights), 0),
        2
    ) AS weighted_avg_arr_delay
FROM flights_fact_daily f
JOIN airlines_dim a
  ON f.airline_id = a.airline_id
GROUP BY a.airline_code
HAVING SUM(f.total_flights) > 500000
ORDER BY weighted_avg_arr_delay ASC;
