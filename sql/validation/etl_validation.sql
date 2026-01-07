USE airline_analytics;

-- ============================================
-- VALIDATION 1: Row counts
-- ============================================

SELECT COUNT(*) AS daily_rows
FROM flights_fact_daily;

SELECT COUNT(*) AS monthly_rows
FROM flights_fact_monthly;


-- ============================================
-- VALIDATION 2: Date range check
-- ============================================

SELECT
    MIN(flight_date) AS min_date,
    MAX(flight_date) AS max_date
FROM flights_fact_daily;


-- ============================================
-- VALIDATION 3: Daily → Monthly consistency
-- (Total flights should roughly match)
-- ============================================

SELECT
    SUM(total_flights) AS daily_total
FROM flights_fact_daily;

SELECT
    SUM(total_flights) AS monthly_total
FROM flights_fact_monthly;


-- ============================================
-- VALIDATION 4: Negative values check
-- ============================================

SELECT COUNT(*) AS negative_delay_rows
FROM flights_fact_daily
WHERE avg_arr_delay < -60
   OR avg_dep_delay < -60;


-- ============================================
-- VALIDATION 5: Dimension coverage
-- ============================================

SELECT COUNT(DISTINCT airline_id) AS airlines_in_fact
FROM flights_fact_daily;

SELECT COUNT(*) AS airlines_dim_count
FROM airlines_dim;

SELECT COUNT(DISTINCT origin_airport_id) AS airports_in_fact
FROM flights_fact_daily;

SELECT COUNT(*) AS airports_dim_count
FROM airports_dim;
